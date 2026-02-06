/************************************************************
 * Mobile Money Transactions System - PL/SQL Queries
 * Student: Emmanuel Ishimwe
 * ID: 26424
 * Course: Database Development with PL/SQL
 * Institution: AUCA
 * Academic Year: 2025-2026
 ************************************************************/

-- STEP 1.2: Create the Tables
-- STEP 1.2.1: Create CUSTOMERS table
CREATE TABLE customers (
    customer_id     NUMBER PRIMARY KEY,
    full_name       VARCHAR2(100) NOT NULL,
    phone_number    VARCHAR2(15) UNIQUE NOT NULL,
    region          VARCHAR2(50),
    created_at      DATE DEFAULT SYSDATE
);
 -- STEP 1.2.2: Create MERCHANTS table
CREATE TABLE merchants (
    merchant_id     NUMBER PRIMARY KEY,
    merchant_name   VARCHAR2(100) NOT NULL,
    category        VARCHAR2(50),
    region          VARCHAR2(50)
);
-- STEP 1.2.3: Create TRANSACTIONS table
CREATE TABLE transactions (
    transaction_id     NUMBER PRIMARY KEY,
    customer_id        NUMBER NOT NULL,
    merchant_id        NUMBER,
    transaction_amount NUMBER(12,2) NOT NULL,
    transaction_date   DATE DEFAULT SYSDATE,

    CONSTRAINT fk_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id),

    CONSTRAINT fk_merchant
        FOREIGN KEY (merchant_id)
        REFERENCES merchants(merchant_id)
);
-- STEP 2.1: Insert Customers
INSERT INTO customers VALUES (1, 'Alice Mukamana', '0788000001', 'Kigali', SYSDATE);
INSERT INTO customers VALUES (2, 'Jean Pierre', '0788000002', 'Huye', SYSDATE);
INSERT INTO customers VALUES (3, 'Eric Nshimiyimana', '0788000003', 'Musanze', SYSDATE);
INSERT INTO customers VALUES (4, 'Grace Uwimana', '0788000004', 'Kigali', SYSDATE);
INSERT INTO customers VALUES (5, 'Patrick Habimana', '0788000005', 'Rubavu', SYSDATE);

COMMIT;
-- STEP 2.2: Insert Merchants
INSERT INTO merchants VALUES (101, 'City Supermarket', 'Retail', 'Kigali');
INSERT INTO merchants VALUES (102, 'Quick Transport', 'Transport', 'Huye');
INSERT INTO merchants VALUES (103, 'Smart Electronics', 'Electronics', 'Kigali');
INSERT INTO merchants VALUES (104, 'Green Restaurant', 'Food', 'Musanze');

COMMIT;
-- STEP 2.3: Insert Transactions
INSERT INTO transactions VALUES (1001, 1, 101, 50000, DATE '2025-01-10');
INSERT INTO transactions VALUES (1002, 2, 102, 30000, DATE '2025-01-15');
INSERT INTO transactions VALUES (1003, 1, 103, 70000, DATE '2025-02-05');
INSERT INTO transactions VALUES (1004, 3, 104, 20000, DATE '2025-02-10');
INSERT INTO transactions VALUES (1005, 4, 101, 90000, DATE '2025-03-01');
INSERT INTO transactions VALUES (1006, 1, 101, 40000, DATE '2025-03-12');
INSERT INTO transactions VALUES (1007, 5, NULL, 25000, DATE '2025-03-15');

COMMIT;

/************************************************************
 * PART A: SQL JOINs
 ************************************************************/

-- 1?? INNER JOIN: Transactions with valid customers and merchants
SELECT
    t.transaction_id,
    c.full_name,
    m.merchant_name,
    t.transaction_amount,
    t.transaction_date
FROM transactions t
INNER JOIN customers c
    ON t.customer_id = c.customer_id
INNER JOIN merchants m
    ON t.merchant_id = m.merchant_id;


-- 2?? LEFT JOIN: Customers who never made a transaction
SELECT
    c.customer_id,
    c.full_name,
    t.transaction_id,
    t.transaction_amount
FROM customers c
LEFT JOIN transactions t
    ON c.customer_id = t.customer_id;


-- 3?? RIGHT JOIN: Merchants with no transactions
SELECT
    m.merchant_id,
    m.merchant_name,
    t.transaction_id,
    t.transaction_amount
FROM transactions t
RIGHT JOIN merchants m
    ON t.merchant_id = m.merchant_id;


-- 4?? FULL OUTER JOIN: Compare customers and merchants including unmatched records
SELECT 
    c.customer_id,
    c.full_name AS customer_name,
    m.merchant_id,
    m.merchant_name,
    t.transaction_id
FROM customers c
FULL OUTER JOIN transactions t ON c.customer_id = t.customer_id
FULL OUTER JOIN merchants m ON t.merchant_id = m.merchant_id
ORDER BY c.customer_id NULLS LAST;

-- 5?? SELF JOIN: Customers within the same region
SELECT
    c1.customer_id AS customer_1_id,
    c1.full_name   AS customer_1_name,
    c2.customer_id AS customer_2_id,
    c2.full_name   AS customer_2_name,
    c1.region
FROM customers c1
JOIN customers c2
    ON c1.region = c2.region
   AND c1.customer_id < c2.customer_id;



/************************************************************
 * PART B: SQL Window Functions
 ************************************************************/

-- 1?? Ranking Functions: Prepare the Data (Total per Customer)
-- Before ranking, we aggregate per customer.
SELECT
    c.customer_id,
    c.full_name,
    SUM(t.transaction_amount) AS total_amount
FROM customers c
JOIN transactions t
    ON c.customer_id = t.customer_id
GROUP BY c.customer_id, c.full_name;
-- STEP 4.1.2: Apply Ranking Functions
SELECT
    c.customer_id,
    c.full_name,
    SUM(t.transaction_amount) AS total_amount,

    ROW_NUMBER() OVER (ORDER BY SUM(t.transaction_amount) DESC) AS row_num,
    RANK() OVER (ORDER BY SUM(t.transaction_amount) DESC) AS rank_pos,
    DENSE_RANK() OVER (ORDER BY SUM(t.transaction_amount) DESC) AS dense_rank_pos,
    PERCENT_RANK() OVER (ORDER BY SUM(t.transaction_amount) DESC) AS percent_rank_pos

FROM customers c
JOIN transactions t
    ON c.customer_id = t.customer_id
GROUP BY c.customer_id, c.full_name;
-- STEP 4.2: Aggregate Window Functions
-- Running Total of Transactions
SELECT
    transaction_id,
    transaction_date,
    transaction_amount,
    SUM(transaction_amount) OVER (
        ORDER BY transaction_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total
FROM transactions;
-- Moving Average (3-Transaction Window)
SELECT
    transaction_id,
    transaction_date,
    transaction_amount,
    AVG(transaction_amount) OVER (
        ORDER BY transaction_date
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS moving_avg_3
FROM transactions;
-- STEP 4.2.3: MIN and MAX Over All Transactions
SELECT
    transaction_id,
    transaction_amount,
    MIN(transaction_amount) OVER () AS min_amount,
    MAX(transaction_amount) OVER () AS max_amount
FROM transactions;
-- STEP 4.3: Navigation Window Functions
--(LAG() and LEAD())
SELECT
    transaction_id,
    transaction_date,
    transaction_amount,
    LAG(transaction_amount) OVER (
        ORDER BY transaction_date
    ) AS previous_amount,
    transaction_amount - LAG(transaction_amount) OVER (
        ORDER BY transaction_date
    ) AS difference_amount
FROM transactions;
-- Compare Each Transaction with the Next One (LEAD)
SELECT
    transaction_id,
    transaction_date,
    transaction_amount,
    LEAD(transaction_amount) OVER (
        ORDER BY transaction_date
    ) AS next_amount
FROM transactions;
-- Ranking Window Functions
SELECT
    c.customer_id,
    c.full_name,
    SUM(t.transaction_amount) AS total_amount,

    ROW_NUMBER() OVER (ORDER BY SUM(t.transaction_amount) DESC) AS row_num,
    RANK() OVER (ORDER BY SUM(t.transaction_amount) DESC) AS rank_pos,
    DENSE_RANK() OVER (ORDER BY SUM(t.transaction_amount) DESC) AS dense_rank_pos,
    PERCENT_RANK() OVER (ORDER BY SUM(t.transaction_amount) DESC) AS percent_rank_pos
FROM customers c
JOIN transactions t
    ON c.customer_id = t.customer_id
GROUP BY c.customer_id, c.full_name;
-- STEP 4.2: Aggregate Window Functions
SELECT
    transaction_id,
    transaction_date,
    transaction_amount,
    SUM(transaction_amount) OVER (
        ORDER BY transaction_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total
FROM transactions;
-- 4.2.2 Three-Transaction Moving Average
SELECT
    transaction_id,
    transaction_date,
    transaction_amount,
    AVG(transaction_amount) OVER (
        ORDER BY transaction_date
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS moving_avg
FROM transactions;
-- 4.2.3 Minimum and Maximum Transaction Values
SELECT
    transaction_id,
    transaction_amount,
    MIN(transaction_amount) OVER () AS min_amount,
    MAX(transaction_amount) OVER () AS max_amount
FROM transactions;
-- 4.3.1 Compare with Previous Transaction (LAG)
SELECT
    transaction_id,
    transaction_date,
    transaction_amount,
    LAG(transaction_amount) OVER (ORDER BY transaction_date) AS previous_amount,
    transaction_amount -
    LAG(transaction_amount) OVER (ORDER BY transaction_date) AS amount_difference
FROM transactions;
-- 4.3.2 Compare with Next Transaction (LEAD)
SELECT
    transaction_id,
    transaction_date,
    transaction_amount,
    LEAD(transaction_amount) OVER (ORDER BY transaction_date) AS next_amount
FROM transactions;
-- STEP 4.4: Distribution Window Functions
-- 4.4.1 Customer Quartile Segmentation (NTILE)
SELECT
    c.customer_id,
    c.full_name,
    SUM(t.transaction_amount) AS total_amount,
    NTILE(4) OVER (ORDER BY SUM(t.transaction_amount) DESC) AS quartile
FROM customers c
JOIN transactions t
    ON c.customer_id = t.customer_id
GROUP BY c.customer_id, c.full_name;
-- 4.4.2 Cumulative Distribution (CUME_DIST)
SELECT
    c.customer_id,
    c.full_name,
    SUM(t.transaction_amount) AS total_amount,
    CUME_DIST() OVER (ORDER BY SUM(t.transaction_amount)) AS cumulative_distribution
FROM customers c
JOIN transactions t
    ON c.customer_id = t.customer_id
GROUP BY c.customer_id, c.full_name;

