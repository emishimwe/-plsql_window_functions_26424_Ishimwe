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

## Step 2: SQL JOINs Implementation

### 2.1 INNER JOIN – Transactions with Valid Customers and Merchants
```sql
SELECT t.transaction_id, c.full_name AS customer, m.merchant_name, t.transaction_amount, t.transaction_date
FROM transactions t
INNER JOIN customers c ON t.customer_id = c.customer_id
INNER JOIN merchants m ON t.merchant_id = m.merchant_id;
