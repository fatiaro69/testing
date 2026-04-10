#!/bin/bash
# Oracle Private Agent Factory - Leasing Deployment
# Run in Git Bash on Windows 10

OCI_TENANCY_OCID="ocid1.tenancy.oc1..aaaaaaaaghysqhr3phrt6atz57epiwl4h32vb6oavg2ayblwnohjsxeclzwq"
OCI_REGION="ap-osaka-1"
COMPARTMENT_OCID="ocid1.compartment.oc1..aaaaaaaabd5xaedyzvbirfqewuo3xwmeevbbsyjbgjm2ji7bcmn3hvnrkngq"
DB_DISPLAY_NAME="LeasingAgentDB"
DB_ADMIN_PASSWORD="WelcomeLeasing#2024"
AGENT_USER_PASSWORD="AgentUser#2024"
STUDIO_IP="REPLACE_AFTER_MARKETPLACE_DEPLOY"

echo "=== STEP 1: Verify OCI Connection ==="
oci iam tenancy get --tenancy-id "$OCI_TENANCY_OCID"

echo "=== STEP 2: Create Autonomous Database ==="
oci db autonomous-database create \
  --compartment-id "$COMPARTMENT_OCID" \
  --display-name "$DB_DISPLAY_NAME" \
  --db-name "leasingagentdb" \
  --admin-password "$DB_ADMIN_PASSWORD" \
  --db-workload "OLTP" \
  --compute-model ECPU \
  --compute-count 4 \
  --data-storage-size-in-tbs 1 \
  --is-auto-scaling-enabled true \
  --region "$OCI_REGION" \
  --wait-for-state AVAILABLE

echo "=== STEP 3: Download Wallet ==="
mkdir -p ./wallet
DB_OCID=$(oci db autonomous-database list \
  --compartment-id "$COMPARTMENT_OCID" \
  --query "data[0].id" --raw-output)
oci db autonomous-database generate-wallet \
  --autonomous-database-id "$DB_OCID" \
  --password "WalletPwd#2024" \
  --file ./wallet/leasing_db_wallet.zip

echo "=== STEP 4: Marketplace Deploy Instructions ==="
echo "URL: https://marketplace.oracle.com/app/agentfactory"
echo "Shape: VM.Standard.E4.Flex - 4 OCPU 16GB"
echo "Compartment: $COMPARTMENT_OCID"
echo "Region: $OCI_REGION"
echo "Enable Public IP: YES"

echo "=== STEP 5: Studio Config ==="
echo "Open: https://$STUDIO_IP:8080/studio"
echo "LLM: OCI GenAI - meta.llama-3.3-70b-instruct"
echo "DB: LEASING_DB - leasingagentdb_high"
echo "Embed: cohere.embed-multilingual-v3"

echo "=== STEP 6: Test Agents ==="
echo "Contract Agent:"
curl -X POST "https://$STUDIO_IP:8080/api/agents/lease-contract-agent/chat" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{"message": "Tampilkan semua kontrak aktif"}'

echo "Credit Agent:"
curl -X POST "https://$STUDIO_IP:8080/api/agents/credit-risk-agent/chat" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{"message": "Tampilkan customer dengan risk rating CRITICAL"}'

echo "Collections Agent:"
curl -X POST "https://$STUDIO_IP:8080/api/agents/collections-agent/chat" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{"message": "Tampilkan akun overdue lebih dari 30 hari"}'
