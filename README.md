## 👤 Intern Details

| Field       | Details                  |
|-------------|--------------------------|
| Name        | [GOTTIPATI VEERA SAI MUKESH]              |
| Intern ID   | [CITS2609]         |
| Company     | CodeTechIT Solutions     |
| Task        | Task 1 — Inventory Tracker (SQL) |
| Technology  | MySQL 8.0, MySQL Workbench |

---

## 📌 Project Overview

This project is a complete **Inventory Management System** built using **MySQL**.
It is designed to help businesses efficiently manage their products, monitor
stock levels, track supplier information, and record every stock movement
through a clean and structured relational database.

The system provides a full backend database solution with tables, relationships,
sample data, queries, views, and stored procedures — all written in pure SQL.

---

## 🎯 Objectives

- Design a normalized relational database for inventory management
- Create tables with proper primary keys, foreign keys, and constraints
- Insert realistic sample data for testing and demonstration
- Write meaningful SQL queries to extract business insights
- Create reusable database views for quick reporting
- Implement a stored procedure for safe stock transactions
- Demonstrate low stock alerts and inventory valuation

---

## 🛠️ Technologies Used

| Technology       | Version  | Purpose                        |
|------------------|----------|--------------------------------|
| MySQL            | 8.0.46   | Database engine                |
| MySQL Workbench  | 8.0.47   | GUI for writing and running SQL|
| SQL              | Standard | Query language                 |

---

## 🗂️ Project Structure

```
inventory-tracker-sql/
│
├── inventory_tracker.sql     ← Main SQL file (schema + data + queries)
└── README.md                 ← Project documentation
```

---

## 🏗️ Database Schema

The database `inventory_tracker` contains the following **5 tables**:

---

### 1. 🗃️ categories
Stores all product categories.

| Column        | Type         | Description              |
|---------------|--------------|--------------------------|
| category_id   | INT (PK)     | Unique category ID       |
| category_name | VARCHAR(100) | Name of the category     |
| description   | TEXT         | Category description     |
| created_at    | TIMESTAMP    | Record creation time     |

---

### 2. 🏭 suppliers
Stores supplier/vendor information.

| Column        | Type         | Description              |
|---------------|--------------|--------------------------|
| supplier_id   | INT (PK)     | Unique supplier ID       |
| supplier_name | VARCHAR(150) | Name of the supplier     |
| contact_name  | VARCHAR(100) | Contact person name      |
| phone         | VARCHAR(20)  | Phone number             |
| email         | VARCHAR(100) | Email address            |
| address       | TEXT         | Physical address         |
| created_at    | TIMESTAMP    | Record creation time     |

---

### 3. 📦 products
The main inventory table — stores all product details.

| Column        | Type           | Description                        |
|---------------|----------------|------------------------------------|
| product_id    | INT (PK)       | Unique product ID                  |
| product_name  | VARCHAR(150)   | Name of the product                |
| category_id   | INT (FK)       | Links to categories table          |
| supplier_id   | INT (FK)       | Links to suppliers table           |
| sku           | VARCHAR(50)    | Stock Keeping Unit (unique code)   |
| unit_price    | DECIMAL(10,2)  | Price per unit                     |
| quantity      | INT            | Current stock quantity             |
| reorder_level | INT            | Minimum stock before alert         |
| created_at    | TIMESTAMP      | Record creation time               |
| updated_at    | TIMESTAMP      | Last update time                   |

---

### 4. 🔄 transactions
Records every stock movement (IN or OUT).

| Column           | Type          | Description                        |
|------------------|---------------|------------------------------------|
| transaction_id   | INT (PK)      | Unique transaction ID              |
| product_id       | INT (FK)      | Links to products table            |
| transaction_type | ENUM          | 'IN' (restock) or 'OUT' (sold)     |
| quantity         | INT           | Number of units moved              |
| transaction_date | TIMESTAMP     | Date and time of transaction       |
| notes            | TEXT          | Optional notes or remarks          |

---

### 5. 👤 users
Stores staff/admin who manage the inventory.

| Column     | Type         | Description                  |
|------------|--------------|------------------------------|
| user_id    | INT (PK)     | Unique user ID               |
| username   | VARCHAR(50)  | Login username               |
| full_name  | VARCHAR(100) | Full name of the user        |
| role       | ENUM         | 'admin' or 'staff'           |
| email      | VARCHAR(100) | Email address                |
| created_at | TIMESTAMP    | Record creation time         |

---

## 🔗 Entity Relationship Summary

```
categories  ──< products >──  suppliers
                   │
                   │
              transactions
```

- One **category** can have many **products**
- One **supplier** can supply many **products**
- One **product** can have many **transactions**

---

## 📊 Sample Data Included

### Categories (5)
- Electronics
- Stationery
- Furniture
- Clothing
- Food & Beverage

### Suppliers (5)
- Tech World Pvt Ltd — Mumbai
- Office Essentials — Delhi
- FurniCo — Ahmedabad
- FashionHub — Bangalore
- Fresh Supplies Co. — Chennai

### Products (10)
- Laptop 15", Wireless Mouse, USB-C Hub
- A4 Notebook, Ball Pen Pack, Whiteboard Marker
- Office Chair, Study Table
- T-Shirt (L)
- Coffee (250g)

### Transactions (10)
- Various IN (restock) and OUT (sold/used) records
- Covers multiple products with notes

---

## 🔍 SQL Queries Included

The project includes **10 key queries** demonstrating real business use cases:

| # | Query Description                          |
|---|--------------------------------------------|
| 1 | View all products with category & supplier |
| 2 | Low stock alert (below reorder level)      |
| 3 | Stock value per product                    |
| 4 | Total overall inventory value              |
| 5 | Transaction history for a product          |
| 6 | Total stock IN vs OUT per product          |
| 7 | Category-wise stock summary                |
| 8 | Most sold products (Top 5)                 |
| 9 | Supplier-wise product count & stock value  |
|10 | Recent transactions (last 30 days)         |

---

## 👁️ Database View

### v_inventory_summary
A reusable view that shows a complete snapshot of all products with:
- Product name, SKU, category, supplier
- Current stock, unit price, stock value
- **Stock Status:** `In Stock` / `Low Stock` / `Out of Stock`

```sql
SELECT * FROM v_inventory_summary;
SELECT * FROM v_inventory_summary WHERE stock_status = 'Low Stock';
```

---

## ⚙️ Stored Procedure

### add_transaction(product_id, type, quantity, notes)
A stored procedure that safely processes stock transactions:
- Validates stock before OUT transactions
- Prevents negative stock (raises error if insufficient)
- Inserts transaction record
- Updates product quantity automatically

```sql
-- Add stock IN
CALL add_transaction(1, 'IN', 5, 'Restock from supplier');

-- Add stock OUT
CALL add_transaction(2, 'OUT', 3, 'Sold to customer');
```

---

## ▶️ How to Run

1. Install **MySQL 8.0** and **MySQL Workbench**
2. Open MySQL Workbench and connect to local instance
3. Go to **File → Open SQL Script**
4. Select `inventory_tracker.sql`
5. Press **Ctrl + Shift + Enter** to run the full script
6. Verify with:

```sql
USE inventory_tracker;
SELECT * FROM v_inventory_summary;
```

---

## ✅ Output / Results

After running the script successfully:
- Database `inventory_tracker` is created
- All 5 tables are created with proper constraints
- 10 products, 5 categories, 5 suppliers inserted
- 10 transactions recorded
- View and stored procedure created
- All 10 queries return meaningful results

---

## 📚 Key Concepts Demonstrated

- **DDL** — CREATE DATABASE, CREATE TABLE
- **DML** — INSERT, UPDATE
- **DQL** — SELECT with JOIN, GROUP BY, ORDER BY, HAVING
- **Aggregate Functions** — SUM, COUNT, AVG
- **CASE Statements** — Dynamic stock status labels
- **Views** — Reusable virtual tables
- **Stored Procedures** — Parameterized logic with error handling
- **Foreign Keys** — Referential integrity between tables
- **ENUM Types** — Controlled value columns
- **AUTO_INCREMENT** — Automatic primary key generation

---

## 🙏 Acknowledgement

This project was developed as part of the **CodeTechIT Solutions Internship Program**.
It demonstrates practical SQL skills applied to a real-world inventory management scenario.

---

*© 2026 [GOTTIPATI VEERA SAI MUKESH] | CodeTechIT Solutions Internship*
