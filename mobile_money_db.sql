/************************************************************
 * Mobile Money Transactions System - PL/SQL Queries
 * Student: Emmanuel Ishimwe
 * ID: 26424
 * Course: Database Development with PL/SQL
 * Institution: AUCA
 * Academic Year: 2025-2026
 ************************************************************/

/************************************************************
 * PART A: SQL JOINs
 ************************************************************/

-- 1?? INNER JOIN: Transactions with valid customers and merchants
SELECT 
    t.transaction_id,
    c.full_name AS customer_name,
    m.merchant_name,
    t.transaction_amount,
    t.transaction_date
FROM transactions t
INNER JOIN customers c ON t.customer_id = c.customer_id
INNER JOIN merchants m ON t.merchant_id = m.merchant_id
ORDER BY t.transaction_date;

-- 2?? LEFT JOIN: Customers who never made a transaction
SELECT 
    c.customer_id,
    c.full_name,
    t.transaction_id
FROM customers c
LEFT JOIN transactions t ON c.customer_id = t.customer_id
WHERE t.transaction_id IS NULL;

-- 3?? RIGHT/FULL OUTER JOIN: Merchants with no transactions
SELECT 
    m.merchant_id,
    m.merchant_name,
    t.transaction_id
FROM merchants m
LEFT JOIN transactions t ON m.merchant_id = t.merchant_id
WHERE t.transaction_id IS NULL;

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
    c1.customer_id AS customer1_id,
    c1.full_name AS customer1_name,
    c2.customer_id AS customer2_id,
    c2.full_name AS customer2_name,
    c1.region
FROM customers c1
INNER JOIN customers c2 
    ON c1.region = c2.region 
    AND c1.customer_id <> c2.customer_id
ORDER BY c1.region;


/************************************************************
 * PART B: SQL Window Functions
 ************************************************************/

-- 1?? Ranking Functions: Top merchants by region
SELECT 
    c.region,
    m.merchant_name,
    SUM(t.transaction_amount) AS total_sales,
    RANK() OVER (PARTITION BY c.region ORDER BY SUM(t.transaction_amount) DESC) AS rank_in_region,
    DENSE_RANK() OVER (PARTITION BY c.region ORDER BY SUM(t.transaction_amount) DESC) AS dense_rank_in_region,
    PERCENT_RANK() OVER (PARTITION BY c.region ORDER BY SUM(t.transaction_amount) DESC) AS percent_rank_in_region
FROM transactions t
JOIN customers c ON t.customer_id = c.customer_id
JOIN merchants m ON t.merchant_id = m.merchant_id
GROUP BY c.region, m.merchant_name
ORDER BY c.region, rank_in_region;

-- 2?? Aggregate Functions: Running totals of transactions
SELECT 
    transaction_date,
    transaction_amount,
    SUM(transaction_amount) OVER (
        ORDER BY transaction_date 
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total,
    AVG(transaction_amount) OVER (
        ORDER BY transaction_date 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS moving_avg_3
FROM transactions
ORDER BY transaction_date;

-- 3?? Navigation Functions: Previous and next transaction per customer
SELECT 
    customer_id,
    transaction_date,
    transaction_amount,
    LAG(transaction_amount) OVER (PARTITION BY customer_id ORDER BY transaction_date) AS prev_transaction,
    LEAD(transaction_amount) OVER (PARTITION BY customer_id ORDER BY transaction_date) AS next_transaction,
    transaction_amount - LAG(transaction_amount) OVER (PARTITION BY customer_id ORDER BY transaction_date) AS growth
FROM transactions
ORDER BY customer_id, transaction_date;

-- 4?? Distribution Functions: Customer quartiles by spending
SELECT 
    customer_id,
    SUM(transaction_amount) AS total_spent,
    NTILE(4) OVER (ORDER BY SUM(transaction_amount) DESC) AS quartile,
    CUME_DIST() OVER (ORDER BY SUM(transaction_amount) DESC) AS cumulative_dist
FROM transactions
GROUP BY customer_id
ORDER BY quartile, total_spent DESC;

-- 5?? Top N transactions per merchant
WITH RankedTransactions AS (
    SELECT 
        t.transaction_id,
        t.customer_id,
        t.merchant_id,
        t.transaction_amount,
        RANK() OVER (PARTITION BY t.merchant_id ORDER BY t.transaction_amount DESC) AS rank_per_merchant
    FROM transactions t
)
SELECT 
    RT.transaction_id,
    c.full_name AS customer_name,
    m.merchant_name,
    RT.transaction_amount,
    RT.rank_per_merchant
FROM RankedTransactions RT
JOIN customers c ON RT.customer_id = c.customer_id
JOIN merchants m ON RT.merchant_id = m.merchant_id
WHERE RT.rank_per_merchant <= 3
ORDER BY RT.merchant_id, RT.rank_per_merchant;
