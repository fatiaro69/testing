# Oracle Private Agent Factory - Leasing Industry

## Project Purpose
Deploy Oracle AI Database Private Agent Factory on OCI for a leasing company
with 3 AI agents: Lease Contract Intelligence, Credit & Risk Analysis,
Collections Automation.

## Environment
- OS: Windows 10, Git Bash
- OCI Region: ap-singapore-1  
- LLM: OCI GenAI (Meta Llama 3.1 70B)
- DB: Oracle Autonomous Database 26ai

## Key Files
- leasing-agent-factory/deploy.sh          → OCI CLI deployment commands
- leasing-agent-factory/synthetic_data.sql → Creates tables and seeds data
- leasing-agent-factory/agent_config.yaml  → Agent definitions for 3 use cases

## How to Deploy
1. cd leasing-agent-factory
2. sed -i 's/\r//' deploy.sh
3. chmod +x deploy.sh  
4. Fill in your OCI details in deploy.sh
5. Run: claude (and use the master prompt in leasing-agent-factory/CLAUDE.md)
