# Leasing Agent Factory - Claude Code Instructions

## Your Mission
Deploy Oracle AI Database Private Agent Factory with 3 leasing AI agents.

## Steps to Execute (in order)
1. Read deploy.sh and ask user for their OCI Tenancy OCID and Compartment OCID
2. Update deploy.sh variables with the provided values
3. Fix Windows line endings: sed -i 's/\r//' deploy.sh
4. Run OCI CLI to create Autonomous Database - wait for AVAILABLE state
5. Download DB wallet to ./wallet/leasing_db_wallet.zip
6. Validate agent_config.yaml syntax
7. Generate SQLcl command to load synthetic_data.sql
8. Generate OCI Marketplace stack launch URL and CLI command
9. Generate curl test commands for all 3 agent REST API endpoints

## Windows 10 Git Bash Rules
- Always use forward slashes: /c/Users/Gulo/ not C:\Users\Gulo\
- Fix line endings before running any .sh file
- Use winpty prefix if interactive commands hang
- OCI CLI path may need: export PATH=$PATH:/c/Users/Gulo/bin

## Agent Summary
1. Lease Contract Intelligence - RAG over contracts and policy docs
2. Credit & Risk Analysis - SQL analytics on credit profiles  
3. Collections Automation - Workflow for overdue account management
