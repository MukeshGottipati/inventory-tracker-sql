-- ============================================================
--         INVENTORY TRACKER - Full SQL Project
--         CodeTechIT Solutions Internship Task
-- ============================================================

-- ============================================================
-- SECTION 1: DATABASE SETUP
-- ============================================================

CREATE DATABASE IF NOT EXISTS inventory_tracker;
USE inventory_tracker;

-- ============================================================
-- SECTION 2: TABLE SCHEMA
-- ============================================================

-- 1. Categories Table
CREATE TABLE categories (
    category_id   INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE,
    description   TEXT,
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Suppliers Table
CREATE TABLE suppliers (
    supplier_id   INT AUTO_INCREMENT PRIMARY KEY,
    supplier_name VARCHAR(150) NOT NULL,
    contact_name  VARCHAR(100),
    phone         VARCHAR(20),
    email         VARCHAR(100),
    address       TEXT,
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. Products Table
CREATE TABLE products (
    product_id    INT AUTO_INCREMENT PRIMARY KEY,
    product_name  VARCHAR(150) NOT NULL,
    category_id   INT,
    supplier_id   INT,
    sku           VARCHAR(50) UNIQUE NOT NULL,       -- Stock Keeping Unit
    unit_price    DECIMAL(10, 2) NOT NULL,
    quantity      INT DEFAULT 0,
    reorder_level INT DEFAULT 10,                   -- Alert when stock goes below this
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE SET NULL,
    FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id) ON DELETE SET NULL
);

-- 4. Transactions Table (Stock IN / Stock OUT)
CREATE TABLE transactions (
    transaction_id   INT AUTO_INCREMENT PRIMARY KEY,
    product_id       INT NOT NULL,
    transaction_type ENUM('IN', 'OUT') NOT NULL,    -- IN = restock, OUT = sold/used
    quantity         INT NOT NULL,
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    notes            TEXT,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
);

-- 5. Users/Staff Table (who manages inventory)
CREATE TABLE users (
    user_id    INT AUTO_INCREMENT PRIMARY KEY,
    username   VARCHAR(50) NOT NULL UNIQUE,
    full_name  VARCHAR(100),
    role       ENUM('admin', 'staff') DEFAULT 'staff',
    email      VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- ============================================================
-- SECTION 3: SAMPLE DATA
-- ============================================================

-- Categories
INSERT INTO categories (category_name, description) VALUES
('Electronics',   'Electronic devices and accessories'),
('Stationery',    'Office and school supplies'),
('Furniture',     'Office and home furniture'),
('Clothing',      'Apparel and accessories'),
('Food & Beverage', 'Consumable food and drink items');

-- Suppliers
INSERT INTO suppliers (supplier_name, contact_name, phone, email, address) VALUES
('Tech World Pvt Ltd',  'Ravi Kumar',   '9876543210', 'ravi@techworld.com',   'Mumbai, Maharashtra'),
('Office Essentials',   'Priya Sharma', '9123456780', 'priya@officeess.com',  'Delhi, India'),
('FurniCo',             'Amit Patel',   '9988776655', 'amit@furnico.com',     'Ahmedabad, Gujarat'),
('FashionHub',          'Sneha Rao',    '8877665544', 'sneha@fashionhub.com', 'Bangalore, Karnataka'),
('Fresh Supplies Co.',  'John D.',      '7766554433', 'john@freshsup.com',    'Chennai, Tamil Nadu');

-- Products
INSERT INTO products (product_name, category_id, supplier_id, sku, unit_price, quantity, reorder_level) VALUES
('Laptop 15"',          1, 1, 'ELEC-LAP-001', 55000.00, 25,  5),
('Wireless Mouse',      1, 1, 'ELEC-MOU-001',  799.00,  80, 15),
('USB-C Hub',           1, 1, 'ELEC-USB-001', 1299.00,  40, 10),
('A4 Notebook',         2, 2, 'STAT-NB-001',   120.00, 200, 50),
('Ball Pen (Pack 10)',  2, 2, 'STAT-PEN-001',   85.00, 150, 30),
('Whiteboard Marker',   2, 2, 'STAT-WBM-001',   45.00,  90, 20),
('Office Chair',        3, 3, 'FURN-CHR-001', 8500.00,  15,  3),
('Study Table',         3, 3, 'FURN-TBL-001',12000.00,  10,  2),
('T-Shirt (L)',         4, 4, 'CLTH-TS-001',   499.00,  60, 10),
('Coffee (250g)',        5, 5, 'FB-COF-001',    350.00,  45, 15);

-- Transactions
INSERT INTO transactions (product_id, transaction_type, quantity, notes) VALUES
(1, 'IN',  10, 'Initial stock received from Tech World'),
(1, 'OUT',  3, 'Sold to client - Invoice #1021'),
(2, 'IN',  50, 'Restock order'),
(2, 'OUT', 12, 'Sold in bulk to office client'),
(4, 'IN', 100, 'New batch received'),
(4, 'OUT', 30, 'Distributed to staff'),
(7, 'OUT',  2, 'Sold to retail customer'),
(9, 'IN',  20, 'New season stock'),
(10,'IN',  25, 'Monthly supply received'),
(10,'OUT',  8, 'Used in office pantry');

-- Users
INSERT INTO users (username, full_name, role, email) VALUES
('admin01',   'Arjun Mehta',  'admin', 'arjun@company.com'),
('staff_riya', 'Riya Singh',  'staff', 'riya@company.com'),
('staff_dev',  'Dev Verma',   'staff', 'dev@company.com');


-- ============================================================
-- SECTION 4: KEY SQL QUERIES
-- ============================================================

-- ── Q1: View all products with category and supplier info ──
SELECT
    p.product_id,
    p.product_name,
    p.sku,
    c.category_name,
    s.supplier_name,
    p.unit_price,
    p.quantity,
    p.reorder_level
FROM products p
LEFT JOIN categories c ON p.category_id = c.category_id
LEFT JOIN suppliers  s ON p.supplier_id = s.supplier_id
ORDER BY p.product_name;


-- ── Q2: Low stock alert (products below reorder level) ──
SELECT
    product_name,
    sku,
    quantity        AS current_stock,
    reorder_level   AS minimum_required,
    (reorder_level - quantity) AS shortage
FROM products
WHERE quantity < reorder_level
ORDER BY shortage DESC;


-- ── Q3: Total stock value (quantity × unit price per product) ──
SELECT
    product_name,
    quantity,
    unit_price,
    (quantity * unit_price) AS total_value
FROM products
ORDER BY total_value DESC;


-- ── Q4: Overall inventory value ──
SELECT
    SUM(quantity * unit_price) AS total_inventory_value
FROM products;


-- ── Q5: Transaction history for a specific product (e.g., Laptop) ──
SELECT
    t.transaction_id,
    p.product_name,
    t.transaction_type,
    t.quantity,
    t.transaction_date,
    t.notes
FROM transactions t
JOIN products p ON t.product_id = p.product_id
WHERE p.product_name = 'Laptop 15"'
ORDER BY t.transaction_date DESC;


-- ── Q6: Total stock IN vs OUT per product ──
SELECT
    p.product_name,
    SUM(CASE WHEN t.transaction_type = 'IN'  THEN t.quantity ELSE 0 END) AS total_in,
    SUM(CASE WHEN t.transaction_type = 'OUT' THEN t.quantity ELSE 0 END) AS total_out,
    SUM(CASE WHEN t.transaction_type = 'IN'  THEN t.quantity
             WHEN t.transaction_type = 'OUT' THEN -t.quantity ELSE 0 END) AS net_stock
FROM transactions t
JOIN products p ON t.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY p.product_name;


-- ── Q7: Products grouped by category with stock count ──
SELECT
    c.category_name,
    COUNT(p.product_id)      AS total_products,
    SUM(p.quantity)          AS total_units,
    SUM(p.quantity * p.unit_price) AS category_value
FROM categories c
LEFT JOIN products p ON c.category_id = p.category_id
GROUP BY c.category_id, c.category_name
ORDER BY category_value DESC;


-- ── Q8: Most sold products (highest OUT transactions) ──
SELECT
    p.product_name,
    SUM(t.quantity) AS total_sold
FROM transactions t
JOIN products p ON t.product_id = p.product_id
WHERE t.transaction_type = 'OUT'
GROUP BY p.product_id, p.product_name
ORDER BY total_sold DESC
LIMIT 5;


-- ── Q9: Supplier-wise product count and stock value ──
SELECT
    s.supplier_name,
    COUNT(p.product_id)            AS products_supplied,
    SUM(p.quantity * p.unit_price) AS stock_value
FROM suppliers s
LEFT JOIN products p ON s.supplier_id = p.supplier_id
GROUP BY s.supplier_id, s.supplier_name
ORDER BY stock_value DESC;


-- ── Q10: Recent transactions (last 30 days) ──
SELECT
    t.transaction_id,
    p.product_name,
    t.transaction_type,
    t.quantity,
    t.transaction_date,
    t.notes
FROM transactions t
JOIN products p ON t.product_id = p.product_id
WHERE t.transaction_date >= NOW() - INTERVAL 30 DAY
ORDER BY t.transaction_date DESC;


-- ============================================================
-- SECTION 5: USEFUL VIEWS
-- ============================================================

-- View: Current inventory summary
CREATE OR REPLACE VIEW v_inventory_summary AS
SELECT
    p.product_id,
    p.product_name,
    p.sku,
    c.category_name,
    s.supplier_name,
    p.unit_price,
    p.quantity          AS stock,
    p.reorder_level,
    (p.quantity * p.unit_price) AS stock_value,
    CASE
        WHEN p.quantity = 0              THEN 'Out of Stock'
        WHEN p.quantity < p.reorder_level THEN 'Low Stock'
        ELSE 'In Stock'
    END AS stock_status
FROM products p
LEFT JOIN categories c ON p.category_id = c.category_id
LEFT JOIN suppliers  s ON p.supplier_id = s.supplier_id;

-- Usage: SELECT * FROM v_inventory_summary;
-- Usage: SELECT * FROM v_inventory_summary WHERE stock_status = 'Low Stock';


-- ============================================================
-- SECTION 6: STORED PROCEDURE - Add Stock Transaction
-- ============================================================

DELIMITER $$

CREATE PROCEDURE add_transaction(
    IN p_product_id       INT,
    IN p_type             ENUM('IN', 'OUT'),
    IN p_quantity         INT,
    IN p_notes            TEXT
)
BEGIN
    DECLARE current_qty INT;

    -- Get current stock
    SELECT quantity INTO current_qty FROM products WHERE product_id = p_product_id;

    -- Prevent negative stock on OUT
    IF p_type = 'OUT' AND current_qty < p_quantity THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Insufficient stock for this transaction.';
    ELSE
        -- Insert transaction record
        INSERT INTO transactions (product_id, transaction_type, quantity, notes)
        VALUES (p_product_id, p_type, p_quantity, p_notes);

        -- Update product quantity
        IF p_type = 'IN' THEN
            UPDATE products SET quantity = quantity + p_quantity WHERE product_id = p_product_id;
        ELSE
            UPDATE products SET quantity = quantity - p_quantity WHERE product_id = p_product_id;
        END IF;
    END IF;
END$$

DELIMITER ;

-- Usage:
-- CALL add_transaction(1, 'IN',  5, 'Restock from supplier');
-- CALL add_transaction(2, 'OUT', 3, 'Sold to customer');


-- ============================================================
-- END OF PROJECT
-- ============================================================
