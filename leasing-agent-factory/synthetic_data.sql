-- Oracle Private Agent Factory - Leasing Industry Synthetic Data
-- Run as LEASING_AGENT_USER after executing setup_user.sql

-- USE CASE 1: LEASE CONTRACT INTELLIGENCE
CREATE TABLE lease_contracts (
    contract_id        VARCHAR2(20) PRIMARY KEY,
    customer_name      VARCHAR2(100),
    asset_type         VARCHAR2(50),
    asset_description  VARCHAR2(200),
    start_date         DATE,
    end_date           DATE,
    monthly_payment    NUMBER(12,2),
    residual_value     NUMBER(12,2),
    total_value        NUMBER(12,2),
    early_term_penalty NUMBER(12,2),
    status             VARCHAR2(20),
    renewal_option     VARCHAR2(10),
    jurisdiction       VARCHAR2(50),
    account_manager    VARCHAR2(100)
);

INSERT INTO lease_contracts VALUES ('LC-2024-001','PT Maju Bersama','Heavy Equipment','Caterpillar 320 Excavator',DATE '2022-01-15',DATE '2027-01-14',18500000,95000000,1110000000,55500000,'ACTIVE','YES','DKI Jakarta','Budi Santoso');
INSERT INTO lease_contracts VALUES ('LC-2024-002','CV Teknologi Nusantara','Vehicle Fleet','Toyota Fortuner x5 Units',DATE '2023-03-01',DATE '2026-02-28',12000000,45000000,432000000,36000000,'ACTIVE','NO','Jawa Barat','Siti Rahayu');
INSERT INTO lease_contracts VALUES ('LC-2024-003','PT Agro Makmur','Agricultural Equipment','John Deere Tractor 6R 150',DATE '2021-06-01',DATE '2024-05-31',9500000,38000000,342000000,19000000,'EXPIRED','YES','Jawa Timur','Ahmad Fauzi');
INSERT INTO lease_contracts VALUES ('LC-2024-004','PT Konstruksi Jaya','Heavy Equipment','Komatsu PC200 Excavator',DATE '2023-07-01',DATE '2028-06-30',22000000,110000000,1320000000,66000000,'ACTIVE','YES','Sumatera Utara','Dewi Kusuma');
INSERT INTO lease_contracts VALUES ('LC-2024-005','UD Sinar Harapan','Vehicle','Mitsubishi Fuso Truck x3',DATE '2022-09-15',DATE '2025-09-14',8500000,25000000,306000000,25500000,'ACTIVE','NO','Sulawesi Selatan','Hendra Wijaya');
INSERT INTO lease_contracts VALUES ('LC-2024-006','PT Tambang Sejahtera','Mining Equipment','Komatsu HD785 Dump Truck',DATE '2020-04-01',DATE '2025-03-31',45000000,250000000,2700000000,135000000,'ACTIVE','YES','Kalimantan Timur','Rini Pratiwi');
INSERT INTO lease_contracts VALUES ('LC-2024-007','CV Mitra Logistik','Vehicle Fleet','Isuzu Elf Box Truck x8',DATE '2024-01-01',DATE '2027-12-31',16000000,60000000,576000000,48000000,'ACTIVE','YES','DKI Jakarta','Budi Santoso');
INSERT INTO lease_contracts VALUES ('LC-2024-008','PT Perkebunan Lestari','Agricultural Equipment','Kubota M7060 Tractor',DATE '2023-05-15',DATE '2026-05-14',7800000,30000000,280800000,15600000,'ACTIVE','NO','Sumatera Selatan','Siti Rahayu');

-- USE CASE 2: CREDIT & RISK ANALYSIS
CREATE TABLE customer_credit_profile (
    customer_id       VARCHAR2(20) PRIMARY KEY,
    customer_name     VARCHAR2(100),
    customer_type     VARCHAR2(20),
    credit_score      NUMBER(5),
    annual_revenue    NUMBER(15,2),
    debt_to_income    NUMBER(5,2),
    years_in_business NUMBER(5),
    industry_sector   VARCHAR2(50),
    num_active_leases NUMBER(5),
    total_exposure    NUMBER(15,2),
    payment_history   VARCHAR2(20),
    risk_rating       VARCHAR2(10),
    last_review_date  DATE
);

INSERT INTO customer_credit_profile VALUES ('CUST-001','PT Maju Bersama','CORPORATE',785,15000000000,0.32,12,'Construction',2,1200000000,'EXCELLENT','LOW',DATE '2024-10-01');
INSERT INTO customer_credit_profile VALUES ('CUST-002','CV Teknologi Nusantara','SME',620,3500000000,0.55,5,'Technology',1,432000000,'GOOD','MEDIUM',DATE '2024-09-15');
INSERT INTO customer_credit_profile VALUES ('CUST-003','PT Agro Makmur','CORPORATE',540,8000000000,0.68,8,'Agriculture',3,980000000,'FAIR','HIGH',DATE '2024-11-01');
INSERT INTO customer_credit_profile VALUES ('CUST-004','PT Konstruksi Jaya','CORPORATE',810,25000000000,0.28,18,'Construction',4,2500000000,'EXCELLENT','LOW',DATE '2024-10-20');
INSERT INTO customer_credit_profile VALUES ('CUST-005','UD Sinar Harapan','SME',490,1200000000,0.78,3,'Logistics',1,306000000,'POOR','CRITICAL',DATE '2024-11-10');
INSERT INTO customer_credit_profile VALUES ('CUST-006','PT Tambang Sejahtera','CORPORATE',720,50000000000,0.41,15,'Mining',5,4500000000,'GOOD','MEDIUM',DATE '2024-09-30');
INSERT INTO customer_credit_profile VALUES ('CUST-007','CV Mitra Logistik','SME',680,4500000000,0.48,7,'Logistics',2,1100000000,'GOOD','MEDIUM',DATE '2024-10-05');
INSERT INTO customer_credit_profile VALUES ('CUST-008','PT Perkebunan Lestari','CORPORATE',760,12000000000,0.35,10,'Agriculture',1,280800000,'EXCELLENT','LOW',DATE '2024-11-01');

-- USE CASE 3: COLLECTIONS AUTOMATION
CREATE TABLE collections_accounts (
    account_id         VARCHAR2(20) PRIMARY KEY,
    contract_id        VARCHAR2(20) REFERENCES lease_contracts(contract_id),
    customer_name      VARCHAR2(100),
    contact_phone      VARCHAR2(20),
    contact_email      VARCHAR2(100),
    days_past_due      NUMBER(5),
    overdue_amount     NUMBER(12,2),
    total_outstanding  NUMBER(15,2),
    last_payment_date  DATE,
    last_payment_amt   NUMBER(12,2),
    collection_stage   VARCHAR2(30),
    assigned_collector VARCHAR2(100),
    next_action        VARCHAR2(200),
    next_action_date   DATE,
    notes              VARCHAR2(500)
);

INSERT INTO collections_accounts VALUES (
  'COL-001','LC-2024-002','CV Teknologi Nusantara',
  '+62-21-5551234','finance@teknosinusantara.co.id',
  15,12000000,432000000,DATE '2024-10-16',12000000,
  'REMINDER','Agus Permadi',
  'Send payment reminder via email and WhatsApp',
  DATE '2024-11-16',
  'First missed payment. Good historical record.');

INSERT INTO collections_accounts VALUES (
  'COL-002','LC-2024-005','UD Sinar Harapan',
  '+62-411-5559876','owner@sinarharapan.co.id',
  45,25500000,306000000,DATE '2024-09-15',8500000,
  'SOFT_COLLECTION','Sri Wahyuni',
  'Phone call and formal demand letter',
  DATE '2024-11-05',
  '2nd notice. Partial payment received last month. Owner difficult to reach.');

INSERT INTO collections_accounts VALUES (
  'COL-003','LC-2024-003','PT Agro Makmur',
  '+62-31-5554321','cfo@agromakmur.co.id',
  90,57000000,342000000,DATE '2024-08-01',9500000,
  'LEGAL','Rizky Ramadan',
  'Coordinate with legal team for formal notice',
  DATE '2024-11-01',
  'Lease expired. Refuses renewal or return of equipment. Legal escalation initiated.');

INSERT INTO collections_accounts VALUES (
  'COL-004','LC-2024-006','PT Tambang Sejahtera',
  '+62-542-5556789','treasury@tambangsejahtaera.co.id',
  10,45000000,2700000000,DATE '2024-10-21',45000000,
  'REMINDER','Agus Permadi',
  'Send WhatsApp reminder to treasury team',
  DATE '2024-11-20',
  'Large account. Likely processing delay. Handle with care.');

-- SUMMARY VIEWS
CREATE OR REPLACE VIEW v_collections_summary AS
SELECT
    collection_stage,
    COUNT(*)              AS num_accounts,
    SUM(overdue_amount)   AS total_overdue,
    AVG(days_past_due)    AS avg_days_past_due
FROM collections_accounts
GROUP BY collection_stage;

CREATE OR REPLACE VIEW v_risk_summary AS
SELECT
    risk_rating,
    COUNT(*)              AS num_customers,
    SUM(total_exposure)   AS total_exposure,
    AVG(credit_score)     AS avg_credit_score
FROM customer_credit_profile
GROUP BY risk_rating;

-- KNOWLEDGE BASE FOR RAG
CREATE TABLE lease_policy_docs (
    doc_id    NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    doc_title VARCHAR2(200),
    category  VARCHAR2(50),
    content   CLOB
);

INSERT INTO lease_policy_docs (doc_title, category, content) VALUES (
  'Early Termination Policy','CONTRACT',
  'Early termination requires written notice at least 90 days prior to the intended termination date. The lessee shall pay an early termination fee of 5% of the remaining lease obligation. All leased assets must be returned in good working condition. Any damage beyond normal wear and tear will be charged to the lessee at market repair rates. Early termination fees are non-negotiable unless approved by the Credit Committee.');

INSERT INTO lease_policy_docs (doc_title, category, content) VALUES (
  'Renewal Option Guidelines','CONTRACT',
  'Lessees with an active renewal option clause may exercise their right to renew within 6 months before the lease end date. Renewal terms are subject to re-evaluation of the asset residual value and the lessee credit profile. A new credit assessment will be conducted. Renewal rates may differ from the original contract based on current market conditions and asset depreciation. Approval from the Account Manager and Credit Team is required for all renewals.');

INSERT INTO lease_policy_docs (doc_title, category, content) VALUES (
  'Collections Escalation Policy','COLLECTIONS',
  'Stage 1 Reminder 1 to 30 DPD: Automated email and SMS reminders sent on Day 1, Day 7, and Day 15. Stage 2 Soft Collection 31 to 60 DPD: Assigned collector makes direct phone contact within 2 business days. Formal demand letter issued. Stage 3 Legal 61 to 90 DPD: Legal department issues formal notice of default. Lessee must respond within 14 days. Stage 4 Write-Off 90 plus DPD: Account referred to external collection agency or legal proceedings initiated for asset repossession.');

INSERT INTO lease_policy_docs (doc_title, category, content) VALUES (
  'Credit Risk Rating Criteria','CREDIT',
  'LOW RISK: Credit score 750 or above, Debt-to-Income below 40%, Excellent payment history, 10 or more years in business. MEDIUM RISK: Credit score 600 to 749, DTI 40 to 60%, Good payment history, 5 to 9 years in business. HIGH RISK: Credit score 500 to 599, DTI 60 to 75%, Fair payment history, 3 to 4 years in business, requires additional collateral. CRITICAL RISK: Credit score below 500, DTI above 75%, Poor payment history. New lease applications will be declined. Existing accounts flagged for immediate review.');

COMMIT;
