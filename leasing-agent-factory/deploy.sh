#!/bin/bash
# Oracle Private Agent Factory - Leasing Deployment Script
# Run in Git Bash on Windows 10

set -e

echo "======================================================"
echo " Oracle Private Agent Factory - Leasing Setup Script"
echo "======================================================"

# -----------------------------------------------
# CONFIGURE YOUR VARIABLES HERE
# -----------------------------------------------
OCI_TENANCY_OCID="REPLACE_WITH_YOUR_TENANCY_OCID"
OCI_REGION="ap-singapore-1"
COMPARTMENT_OCID="REPLACE_WITH_YOUR_COMPARTMENT_OCID"
DB_DISPLAY_NAME="LeasingAgentDB"
DB_ADMIN_PASSWORD="WelcomeLeasing#2024"
AGENT_USER_PASSWORD="AgentUser#2024"

echo ""
echo "STEP 1: Verify OCI CLI Connection"
echo "------------------------------------------------------"
oci iam tenancy get --tenancy-id "$OCI_TENANCY_OCID"
echo "OCI CLI connected successfully"

echo ""
echo "STEP 2: Create Autonomous Database"
echo "------------------------------------------------------"
oci db autonomous-database create \
  --compartment-id "$COMPARTMENT_OCID" \
  --display-name "$DB_DISPLAY_NAME" \
  --db-name "leasingagentdb" \
  --admin-password "$DB_ADMIN_PASSWORD" \
  --db-workload "OLTP" \
  --cpu-core-count 2 \
  --data-storage-size-in-tbs 1 \
  --is-auto-scaling-enabled true \
  --region "$OCI_REGION" \
  --wait-for-state AVAILABLE
echo "Autonomous Database created"

echo ""
echo "STEP 3: Download DB Wallet"
echo "------------------------------------------------------"
mkdir -p ./wallet

DB_OCID=$(oci db autonomous-database list \
  --compartment-id "$COMPARTMENT_OCID" \
  --query "data[0].id" --raw-output)

oci db autonomous-database generate-wallet \
  --autonomous-database-id "$DB_OCID" \
  --password "WalletPwd#2024" \
  --file ./wallet/leasing_db_wallet.zip
echo "Wallet saved to ./wallet/leasing_db_wallet.zip"

echo ""
echo "STEP 4: Launch Agent Factory from OCI Marketplace"
echo "------------------------------------------------------"
echo "Go to: https://marketplace.oracle.com/app/agentfactory"
echo "Click Launch Stack"
echo "Compartment: $COMPARTMENT_OCID"
echo "Region: $OCI_REGION"
echo "Shape: VM.Standard.E4.Flex (4 OCPU, 16GB)"
echo "Enable Public IP: YES"
echo ""
echo "After deploy, open: https://<STUDIO_IP>:8080/studio"

echo ""
echo "STEP 5: Configure Agent Factory Studio"
echo "------------------------------------------------------"
echo "A) LLM Provider: OCI Generative AI"
echo "   Endpoint: https://inference.generativeai.$OCI_REGION.oci.oraclecloud.com"
echo "   Model: meta.llama-3.1-70b-instruct"
echo ""
echo "B) Database Connection: LEASING_DB"
echo "   Upload wallet: ./wallet/leasing_db_wallet.zip"
echo "   Service: leasingagentdb_high"
echo "   Username: LEASING_AGENT_USER"
echo "   Password: $AGENT_USER_PASSWORD"
echo ""
echo "C) Embedding Model: cohere.embed-multilingual-v3"

echo ""
echo "STEP 6: Load Synthetic Data"
echo "------------------------------------------------------"
echo "Run in SQL Developer Web as ADMIN:"
echo "  1. Execute setup_user.sql"
echo "  2. Connect as LEASING_AGENT_USER"
echo "  3. Execute synthetic_data.sql"

echo ""
echo "STEP 7: Import Agents"
echo "------------------------------------------------------"
echo "In Agent Factory Studio:"
echo "  Import Agent -> Upload agent_config.yaml"
echo "  3 agents will be created:"
echo "  - Lease Contract Intelligence Agent"
echo "  - Credit & Risk Analysis Agent"
echo "  - Collections Automation Agent"

echo ""
echo "STEP 8: Test REST APIs"
echo "------------------------------------------------------"
STUDIO_IP="REPLACE_WITH_STUDIO_IP"
echo "Contract Agent:"
echo "curl -X POST https://$STUDIO_IP:8080/api/agents/lease-contract-agent/chat \\"
echo "  -H 'Content-Type: application/json' \\"
echo "  -H 'Authorization: Bearer YOUR_TOKEN' \\"
echo "  -d '{\"message\": \"Tampilkan semua kontrak aktif\"}'"
echo ""
echo "Credit Agent:"
echo "curl -X POST https://$STUDIO_IP:8080/api/agents/credit-risk-agent/chat \\"
echo "  -H 'Content-Type: application/json' \\"
echo "  -H 'Authorization: Bearer YOUR_TOKEN' \\"
echo "  -d '{\"message\": \"Tampilkan customer dengan risk rating CRITICAL\"}'"
echo ""
echo "Collections Agent:"
echo "curl -X POST https://$STUDIO_IP:8080/api/agents/collections-agent/chat \\"
echo "  -H 'Content-Type: application/json' \\"
echo "  -H 'Authorization: Bearer YOUR_TOKEN' \\"
echo "  -d '{\"message\": \"Tampilkan akun overdue lebih dari 30 hari\"}'"

echo ""
echo "======================================================"
echo " Deployment Complete!"
echo "======================================================"
