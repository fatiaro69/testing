-- Oracle Private Agent Factory - Leasing
-- Run this as ADMIN in SQL Developer Web BEFORE synthetic_data.sql

-- Step 1: Create the agent schema user
CREATE USER LEASING_AGENT_USER
  IDENTIFIED BY "AgentUser#2024"
  DEFAULT TABLESPACE DATA
  QUOTA UNLIMITED ON DATA;

-- Step 2: Grant required privileges
GRANT CONNECT, RESOURCE TO LEASING_AGENT_USER;
GRANT CREATE SESSION TO LEASING_AGENT_USER;
GRANT CREATE TABLE, CREATE VIEW, CREATE SEQUENCE TO LEASING_AGENT_USER;
GRANT SELECT ANY TABLE TO LEASING_AGENT_USER;
GRANT EXECUTE ON DBMS_CLOUD TO LEASING_AGENT_USER;
GRANT EXECUTE ON DBMS_CLOUD_AI TO LEASING_AGENT_USER;

-- Step 3: Enable SQL Developer Web access for this user
BEGIN
  ORDS.ENABLE_SCHEMA(
    p_enabled             => TRUE,
    p_schema              => 'LEASING_AGENT_USER',
    p_url_mapping_type    => 'BASE_PATH',
    p_url_mapping_pattern => 'leasing',
    p_auto_rest_auth      => FALSE
  );
  COMMIT;
END;
/

-- Step 4: Create Select AI profile for Credit Risk agent
-- (Run after connecting OCI GenAI in ADB settings)
BEGIN
  DBMS_CLOUD_AI.CREATE_PROFILE(
    profile_name => 'CREDIT_ANALYST_PROFILE',
    attributes   => '{
      "provider": "oci",
      "credential_name": "OCI_GENAI_CRED",
      "object_list": [
        {"owner": "LEASING_AGENT_USER", "name": "CUSTOMER_CREDIT_PROFILE"},
        {"owner": "LEASING_AGENT_USER", "name": "LEASE_CONTRACTS"},
        {"owner": "LEASING_AGENT_USER", "name": "V_RISK_SUMMARY"}
      ]
    }'
  );
END;
/

COMMIT;

-- Verify user created
SELECT username, account_status FROM dba_users
WHERE username = 'LEASING_AGENT_USER';
