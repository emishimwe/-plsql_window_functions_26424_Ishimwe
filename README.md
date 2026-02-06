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
 
