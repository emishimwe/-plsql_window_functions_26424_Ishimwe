# Mobile Money Transactions System – SQL Window Functions  
**Course:** Database Development with PL/SQL  
**Student:** Emmanuel Ishimwe [26424]  
**Instructor:** Eric Maniraguha  
**Academic Year:** 2025 – 2026  

---

## 📌 Project Overview
The **Mobile Money Transactions System** is a database-driven project designed to store, manage, and analyze mobile money transactions between customers and merchants.  

It demonstrates **SQL JOINs**, **PL/SQL window functions**, and **analytical reporting** in a realistic financial scenario, similar to mobile money platforms.

The project helps in:  
- Tracking customer transactions  
- Identifying top-performing merchants  
- Segmenting customers for targeted services  
- Calculating trends and running totals using window functions  

---

## Step 1: Database Schema

### 1️⃣ Tables

#### CUSTOMERS
| Column Name      | Description |
|------------------|-------------|
| customer_id (PK) | Unique customer identifier |
| full_name        | Customer full name |
| phone_number     | Mobile phone number |
| region           | Customer location |
| created_at       | Account creation date |

#### MERCHANTS
| Column Name      | Description |
|------------------|-------------|
| merchant_id (PK) | Unique merchant identifier |
| merchant_name    | Merchant business name |
| category         | Merchant type/category |
| region           | Merchant location |

#### TRANSACTIONS
| Column Name          | Description |
|----------------------|-------------|
| transaction_id (PK)  | Unique transaction identifier |
| customer_id (FK)     | References CUSTOMERS(customer_id) |
| merchant_id (FK)     | References MERCHANTS(merchant_id) |
| transaction_amount   | Amount transferred |
| transaction_date     | Date of transaction |

---

### 2️⃣ Entity Relationship (ER) Diagram
- **Entities:** CUSTOMERS, MERCHANTS, TRANSACTIONS  
- **Relationships:**  
  - One **Customer** → Many **Transactions**  
  - One **Merchant** → Many **Transactions**  

> ![ER Diagram](/img/mobile_money_er_diagram.png)  

---
### STEP 1.1: Verify the Database Connection

Before creating anything, we prove the connection works
 ![ER Diagram](/img/date.png)
### STEP 1.2.1: Create CUSTOMERS table
 ![ER Diagram](/img/customers_table.png)
 ### STEP 1.2.1: Create MERCHANTS table
 ![ER Diagram](/img/merchants_records.png)
 ### STEP 1.2.1: Create TRANSACTIONS table
 ![ER Diagram](/img/transaction_records.png)
## STEP 1.3: Confirm Tables Exist
 ![ER Diagram](/img/all_tables.png)

### (PART A):SQL JOINs 
## Step 2: SQL JOINs Implementation

## 2.1: INNER JOIN – Transactions with Valid Customers and Merchants
This query retrieves only valid customer-to-merchant transactions. It ensures data integrity by excluding transactions without registered customers or merchants. Management can use this information to analyze legitimate merchant payments.
 ![ER Diagram](/img/inner_join.png)
 ## 2.2: LEFT JOIN - Customers who have NEVER made a transaction
This query identifies customers regardless of whether they have performed any transactions. Customers with NULL transaction values represent inactive users. This helps management target inactive customers with promotions or awareness campaigns.
 ![ER Diagram](/img/left_join.png)
 ## 2.3: RIGHT JOIN - Merchants with NO transactions
 This query identifies all registered merchants, including those who have not received any transactions. Merchants with NULL transaction values indicate no sales activity. Management can use this insight to evaluate merchant engagement or remove inactive merchants.
 ![ER Diagram](/img/right_join.png)
 ## 2.4: FULL OUTER JOIN - Compare customers and merchants, including unmatched records
 This query provides a comprehensive comparison of customers and merchants, including those without transactions. It helps management understand system coverage, identify inactive users, and assess overall platform participation.
 ![ER Diagram](/img/full_join.png)
 ## 2.5: SELF JOIN - Compare customers within the same region
 This query compares customers located in the same region. It helps the business analyze regional customer distribution and identify clusters of users within the same geographical area for targeted services or promotions.
 ![ER Diagram](/img/self_join.png)

 ### PART B: WINDOW FUNCTIONS (PL/SQL / Oracle SQL)
 ## STEP 4.1: Ranking Window Functions
(ROW_NUMBER, RANK, DENSE_RANK, PERCENT_RANK)
Rank customers by total transaction amount
## STEP 4.1.1: Prepare the Data (Total per Customer)
Before ranking, we aggregate per customer
![ER Diagram](/img/Prepare_the_Data.png)
## STEP 4.1.2: Apply Ranking Functions
This query ranks customers based on their total transaction value. ROW_NUMBER assigns a unique position, RANK and DENSE_RANK handle ties differently, while PERCENT_RANK shows each customer’s relative position within the entire population. This helps identify high-value customers for loyalty programs.
![ER Diagram](/img/Apply_Ranking_Functions.png)
## STEP 4.2: Aggregate Window Functions
SUM() OVER(), AVG() OVER(), MIN() OVER(), MAX() OVER()

These functions let us analyze trends over time without collapsing rows.
## STEP 4.2.1: Running Total of Transactions
This query calculates a running total of transaction amounts over time. It helps management understand transaction growth patterns and monitor overall system performance as transactions occur.
Running Total using SUM() OVER()
![ER Diagram](/img/SUM_OVER.png)
## STEP 4.2.2: Moving Average (3-Transaction Window)
Moving Average using AVG() OVER()
This query computes a three-transaction moving average of transaction amounts. It helps identify trends by reducing the effect of sudden spikes or drops in transaction values.
![ER Diagram](/img/AVG_OVER.png)
## STEP 4.2.3: MIN and MAX Over All Transactions
This query identifies the smallest and largest transaction amounts in the system while retaining individual transaction records. It helps assess transaction limits and detect unusually high or low values.
![ER Diagram](/img/MIN_MAX.png)
## STEP 4.3: Navigation Window Functions
(LAG() and LEAD())
These functions let us compare a row with the previous or next row.
They are perfect for growth analysis.
## STEP 4.3.1: Compare Each Transaction with the Previous One (LAG)
This query compares each transaction with the previous one to identify increases or decreases in transaction value. It helps the business monitor short-term transaction fluctuations and detect unusual changes.
![ER Diagram](/img/LAG.png)
## STEP 4.3.2: Compare Each Transaction with the Next One (LEAD)
This query compares each transaction with the next transaction in time.
It helps anticipate future transaction behavior and supports trend analysis.
![ER Diagram](/img/LEAD.png)
## STEP 4.4: Distribution Window Functions
Functions used: NTILE(4), CUME_DIST()
## 4.4.1 Customer Quartile Segmentation (NTILE)
Divides customers into four groups based on transaction value, enabling targeted marketing and customer prioritization.
![ER Diagram](/img/NTILE.png)
## 4.4.2 Cumulative Distribution (CUME_DIST)
Shows the relative standing of each customer within the entire population.
![ER Diagram](/img/CUME_DIST.png)
