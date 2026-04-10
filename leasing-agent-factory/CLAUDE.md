# Leasing Agent Factory - Claude Code Instructions

## Your Mission
Deploy Oracle AI Database Private Agent Factory with 3 leasing AI agents.

## Steps to Execute
1. Verify OCI CLI connection
2. Create Autonomous Database - wait for AVAILABLE
3. Download DB wallet to ./wallet/leasing_db_wallet.zip
4. Create all project files
5. Load synthetic data via SQL Developer Web
6. Launch Agent Factory from OCI Marketplace
7. Configure Studio with LLM and DB connection
8. Import agent_config.yaml
9. Test all 3 agents via REST API

## Windows 10 Notes
- OCI CLI configured via PowerShell
- Use forward slashes in Git Bash paths
- Fix line endings: sed -i 's/\r//' deploy.sh
