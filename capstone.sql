create database if not exists enterprise_dw;
use database enterprise_dw;

create schema if not exists retail_mart;
use schema retail_mart;

create or replace table dim_date(
    date_sk INT PRIMARY KEY,
    full_date DATE NOT NULL,
    year INT NOT NULL,
    quarter INT NOT NULL,
    month INT NOT NULL,
    month_name VARCHAR(10) NOT NULL,
    day_of_week VARCHAR(10) NOT NULL,
    is_weekend BOOLEAN NOT NULL,
    is_holiday BOOLEAN NOT NULL
);

create or replace table dim_customer(
    customer_sk INT PRIMARY KEY,
    customer_id VARCHAR(20) NOT NULL,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    tier VARCHAR(20) NOT NULL,
    city VARCHAR(50) NOT NULL,
    effective_start_timestamp TIMESTAMP_NTZ NOT NULL,
    effective_end_timestamp TIMESTAMP_NTZ,
    is_current BOOLEAN NOT NULL
);

create or replace table dim_product(
    product_sk INT PRIMARY KEY,
    product_id VARCHAR(20) NOT NULL,
    product_name VARCHAR(100) NOT NULL,
    category_name VARCHAR(50) NOT NULL,
    department_name VARCHAR(50) NOT NULL,
    unit_cost DECIMAL(10, 2) NOT NULL
);

create or replace table fact_sales(
    sales_sk INT PRIMARY KEY,
    order_id VARCHAR(20) NOT NULL, -- Degenerate Dimension
    customer_sk INT REFERENCES DIM_CUSTOMER(customer_sk),
    product_sk INT REFERENCES DIM_PRODUCT(product_sk),
    order_date_sk INT REFERENCES DIM_DATE(date_sk), -- Role Playing 1
    ship_date_sk INT REFERENCES DIM_DATE(date_sk),  -- Role Playing 2
    quantity INT NOT NULL,                          -- Additive Measure
    revenue DECIMAL(12, 2) NOT NULL                 -- Additive Measure
);

-- fact monthly inventory (periodic snapshot fact table)
create or replace table fact_monthly_inventory(
    snapshot_sk INT PRIMARY KEY,
    snapshot_date_sk INT REFERENCES DIM_DATE(date_sk),
    product_sk INT REFERENCES DIM_PRODUCT(product_sk),
    starting_stock_qty INT NOT NULL,               -- Semi-Additive
    ending_stock_qty INT NOT NULL,                 -- Semi-Additive
    restock_qty INT NOT NULL                       -- Additive
);

-- fact_promotion coverage (factless fact table)
create or replace table fact_promotion_coverage(
    coverage_sk INT PRIMARY KEY,
    product_sk INT REFERENCES DIM_PRODUCT(product_sk),
    date_sk INT REFERENCES DIM_DATE(date_sk),
    promotion_code VARCHAR(30) NOT NULL
);

INSERT INTO DIM_DATE VALUES
(20260101, '2026-01-01', 2026, 1, 1, 'January', 'Thursday', FALSE, TRUE),
(20260102, '2026-01-02', 2026, 1, 1, 'January', 'Friday', FALSE, FALSE),
(20260103, '2026-01-03', 2026, 1, 1, 'January', 'Saturday', TRUE, FALSE),
(20260104, '2026-01-04', 2026, 1, 1, 'January', 'Sunday', TRUE, FALSE),
(20260105, '2026-01-05', 2026, 1, 1, 'January', 'Monday', FALSE, FALSE),
(20260106, '2026-01-06', 2026, 1, 1, 'January', 'Tuesday', FALSE, FALSE),
(20260107, '2026-01-07', 2026, 1, 1, 'January', 'Wednesday', FALSE, FALSE),
(20260108, '2026-01-08', 2026, 1, 1, 'January', 'Thursday', FALSE, FALSE),
(20260109, '2026-01-09', 2026, 1, 1, 'January', 'Friday', FALSE, FALSE),
(20260110, '2026-01-10', 2026, 1, 1, 'January', 'Saturday', TRUE, FALSE),
(20260111, '2026-01-11', 2026, 1, 1, 'January', 'Sunday', TRUE, FALSE),
(20260112, '2026-01-12', 2026, 1, 1, 'January', 'Monday', FALSE, FALSE),
(20260113, '2026-01-13', 2026, 1, 1, 'January', 'Tuesday', FALSE, FALSE),
(20260114, '2026-01-14', 2026, 1, 1, 'January', 'Wednesday', FALSE, FALSE),
(20260115, '2026-01-15', 2026, 1, 1, 'January', 'Thursday', FALSE, FALSE),
(20260116, '2026-01-16', 2026, 1, 1, 'January', 'Friday', FALSE, FALSE),
(20260117, '2026-01-17', 2026, 1, 1, 'January', 'Saturday', TRUE, FALSE),
(20260118, '2026-01-18', 2026, 1, 1, 'January', 'Sunday', TRUE, FALSE),
(20260119, '2026-01-19', 2026, 1, 1, 'January', 'Monday', FALSE, FALSE),
(20260120, '2026-01-20', 2026, 1, 1, 'January', 'Tuesday', FALSE, FALSE);

INSERT INTO DIM_CUSTOMER VALUES
(-1, 'CUST-000', 'Inferred Member', 'unknown@domain.com', 'None', 'Unknown', '2020-01-01 00:00:00', NULL, TRUE),
(101, 'CUST-001', 'Alice Smith', 'alice@gmail.com', 'Gold', 'New York', '2025-01-01 00:00:00', '2026-01-05 00:00:00', FALSE),
(102, 'CUST-001', 'Alice Smith', 'alice_new@gmail.com', 'Platinum', 'New York', '2026-01-05 00:00:00', NULL, TRUE),
(103, 'CUST-002', 'Bob Jones', 'bob@yahoo.com', 'Silver', 'Chicago', '2025-06-01 00:00:00', NULL, TRUE),
(104, 'CUST-003', 'Charlie Brown', 'charlie@hotmail.com', 'Bronze', 'Houston', '2025-08-15 00:00:00', NULL, TRUE),
(105, 'CUST-004', 'Diana Prince', 'diana@amazon.com', 'Platinum', 'Seattle', '2025-02-10 00:00:00', NULL, TRUE),
(106, 'CUST-005', 'Evan Wright', 'evan@tech.com', 'Silver', 'Boston', '2025-11-20 00:00:00', NULL, TRUE),
(107, 'CUST-006', 'Fiona Gallagher', 'fiona@chicago.gov', 'Gold', 'Chicago', '2025-04-12 00:00:00', NULL, TRUE),
(108, 'CUST-007', 'George Clark', 'george@clark.org', 'Bronze', 'Denver', '2025-09-01 00:00:00', NULL, TRUE),
(109, 'CUST-008', 'Hannah Abbott', 'hannah@hogwarts.edu', 'Gold', 'Austin', '2025-03-30 00:00:00', NULL, TRUE),
(110, 'CUST-009', 'Ian Malcolm', 'ian@dino.com', 'Platinum', 'Dallas', '2025-07-07 00:00:00', NULL, TRUE),
(111, 'CUST-010', 'Julia Roberts', 'julia@cinema.com', 'Silver', 'Los Angeles', '2025-10-15 00:00:00', NULL, TRUE),
(112, 'CUST-011', 'Kevin Bacon', 'kevin@actor.com', 'Gold', 'Philadelphia', '2025-12-01 00:00:00', NULL, TRUE),
(113, 'CUST-012', 'Laura Croft', 'laura@tomb.org', 'Platinum', 'San Francisco', '2025-01-20 00:00:00', NULL, TRUE),
(114, 'CUST-013', 'Michael Scott', 'michael@paper.com', 'Bronze', 'Scranton', '2025-05-05 00:00:00', NULL, TRUE),
(115, 'CUST-014', 'Nancy Drew', 'nancy@detective.com', 'Silver', 'River Heights', '2025-06-18 00:00:00', NULL, TRUE),
(116, 'CUST-015', 'Oscar Martinez', 'oscar@accounting.com', 'Gold', 'Scranton', '2025-08-22 00:00:00', NULL, TRUE),
(117, 'CUST-016', 'Pam Beesly', 'pam@art.com', 'Silver', 'Scranton', '2025-09-14 00:00:00', NULL, TRUE),
(118, 'CUST-017', 'Quentin Tarantino', 'quentin@film.com', 'Platinum', 'Los Angeles', '2025-10-01 00:00:00', NULL, TRUE),
(119, 'CUST-018', 'Rachel Green', 'rachel@fashion.com', 'Gold', 'New York', '2025-11-11 00:00:00', NULL, TRUE),
(120, 'CUST-019', 'Steve Rogers', 'steve@shield.gov', 'Platinum', 'Brooklyn', '2025-01-01 00:00:00', NULL, TRUE);

INSERT INTO DIM_PRODUCT VALUES
(201, 'PRD-101', '4K Smart Monitor 27in', 'Monitors', 'Electronics', 250.00),
(202, 'PRD-102', 'Ergonomic Mechanical Keyboard', 'Accessories', 'Electronics', 75.00),
(203, 'PRD-103', 'Wireless Gaming Mouse', 'Accessories', 'Electronics', 40.00),
(204, 'PRD-104', 'USB-C Docking Station', 'Accessories', 'Electronics', 90.00),
(205, 'PRD-105', 'Noise-Canceling Headphones', 'Audio', 'Electronics', 180.00),
(206, 'PRD-106', 'Standing Desk Converter', 'Furniture', 'Office Supplies', 150.00),
(207, 'PRD-107', 'Mesh Office Chair', 'Furniture', 'Office Supplies', 200.00),
(208, 'PRD-108', 'LED Desk Lamp', 'Lighting', 'Office Supplies', 25.00),
(209, 'PRD-109', 'HD Web Camera 1080p', 'Audio & Video', 'Electronics', 50.00),
(210, 'PRD-110', 'External SSD 1TB', 'Storage', 'Electronics', 85.00),
(211, 'PRD-111', 'Bluetooth Soundbar', 'Audio', 'Electronics', 110.00),
(212, 'PRD-112', 'Paper Shredder Cross-Cut', 'Equipment', 'Office Supplies', 60.00),
(213, 'PRD-113', 'Laser Printer Monochrome', 'Printers', 'Office Supplies', 190.00),
(214, 'PRD-114', 'Surge Protector Tower', 'Power', 'Electronics', 30.00),
(215, 'PRD-115', 'Ergonomic Footrest', 'Furniture', 'Office Supplies', 35.00),
(216, 'PRD-116', 'Wireless Charger Pad', 'Accessories', 'Electronics', 20.00),
(217, 'PRD-117', 'Thermal Label Printer', 'Printers', 'Office Supplies', 130.00),
(218, 'PRD-118', 'Laptop Sleeve 15in', 'Accessories', 'Electronics', 18.00),
(219, 'PRD-119', 'Blue Light Glasses', 'Apparel', 'Personal', 22.00),
(220, 'PRD-120', 'Cable Management Box', 'Accessories', 'Office Supplies', 15.00);

INSERT INTO FACT_SALES VALUES
(1, 'ORD-9001', 102, 201, 20260101, 20260103, 1, 399.99),
(2, 'ORD-9001', 102, 202, 20260101, 20260103, 2, 240.00),
(3, 'ORD-9002', 103, 205, 20260102, 20260104, 1, 299.99),
(4, 'ORD-9003', 104, 203, 20260102, 20260105, 3, 180.00),
(5, 'ORD-9004', 105, 207, 20260103, 20260106, 1, 350.00),
(6, 'ORD-9005', 106, 210, 20260104, 20260107, 2, 260.00),
(7, 'ORD-9006', 107, 204, 20260105, 20260108, 1, 140.00),
(8, 'ORD-9007', 108, 208, 20260105, 20260107, 4, 160.00),
(9, 'ORD-9008', 109, 206, 20260106, 20260109, 1, 250.00),
(10, 'ORD-9009', 110, 213, 20260107, 20260110, 1, 299.00),
(11, 'ORD-9010', 111, 209, 20260108, 20260111, 2, 160.00),
(12, 'ORD-9011', 112, 211, 20260109, 20260112, 1, 180.00),
(13, 'ORD-9012', 113, 214, 20260110, 20260112, 5, 225.00),
(14, 'ORD-9013', 114, 212, 20260111, 20260114, 1, 95.00),
(15, 'ORD-9014', 115, 215, 20260112, 20260115, 2, 110.00),
(16, 'ORD-9015', 116, 216, 20260113, 20260116, 3, 90.00),
(17, 'ORD-9016', 117, 217, 20260114, 20260117, 1, 210.00),
(18, 'ORD-9017', 118, 218, 20260115, 20260118, 2, 50.00),
(19, 'ORD-9018', 119, 219, 20260116, 20260119, 2, 70.00),
(20, 'ORD-9019', 120, 220, 20260117, 20260120, 4, 100.00);

INSERT INTO FACT_MONTHLY_INVENTORY VALUES
(1, 20260101, 201, 50, 35, 0),
(2, 20260101, 202, 100, 80, 20),
(3, 20260101, 203, 120, 95, 0),
(4, 20260101, 204, 40, 22, 10),
(5, 20260101, 205, 30, 15, 0),
(6, 20260101, 206, 25, 10, 5),
(7, 20260101, 207, 15, 8, 0),
(8, 20260101, 208, 200, 150, 50),
(9, 20260101, 209, 80, 60, 0),
(10, 20260101, 210, 90, 70, 15),
(11, 20260101, 211, 45, 30, 0),
(12, 20260101, 212, 35, 25, 0),
(13, 20260101, 213, 20, 12, 10),
(14, 20260101, 214, 150, 110, 0),
(15, 20260101, 215, 60, 48, 0),
(16, 20260101, 216, 110, 85, 25),
(17, 20260101, 217, 25, 18, 0),
(18, 20260101, 218, 95, 80, 0),
(19, 20260101, 219, 70, 50, 10),
(20, 20260101, 220, 130, 100, 0);

INSERT INTO FACT_PROMOTION_COVERAGE VALUES
(1, 201, 20260101, 'NEWYEAR_2026'),
(2, 202, 20260101, 'NEWYEAR_2026'),
(3, 203, 20260102, 'TECH_DEALS'),
(4, 204, 20260102, 'TECH_DEALS'),
(5, 205, 20260103, 'AUDIO_MANIA'),
(6, 206, 20260104, 'OFFICE_REFRESH'),
(7, 207, 20260105, 'OFFICE_REFRESH'),
(8, 208, 20260105, 'LIGHTING_SALE'),
(9, 209, 20260106, 'WORK_FROM_HOME'),
(10, 210, 20260107, 'STORAGE_BLOWOUT'),
(11, 211, 20260108, 'AUDIO_MANIA'),
(12, 212, 20260109, 'OFFICE_REFRESH'),
(13, 213, 20260110, 'TECH_DEALS'),
(14, 214, 20260111, 'POWER_SAVINGS'),
(15, 215, 20260112, 'ERGONOMIC_COMFORT'),
(16, 216, 20260113, 'TECH_DEALS'),
(17, 217, 20260114, 'OFFICE_REFRESH'),
(18, 218, 20260115, 'ACCESSORY_SPECIAL'),
(19, 219, 20260116, 'HEALTH_WELLNESS'),
(20, 220, 20260117, 'ORGANIZATION_SALE');

-- task1 Calculate sales revenue for each combination of order date and shipping date (role playing dimension)
select 
    order_date.full_date as order_date,
    ship_date.full_date as ship_date,
    sum(fs.revenue) as daily_revenue
from fact_sales as fs join 
dim_date as order_date on
fs.order_date_sk = order_date.date_sk
join dim_date as ship_date on
fs.ship_date_sk = ship_date.date_sk
group by order_date.full_date, ship_date.full_date
order by order_date.full_date, ship_date.full_date;

-- task2 Calculate total units sold, total revenue, and average revenue per sales line. (additive measures)
select 
    sum(quantity) as total_units_sold,
    sum(revenue) as total_revenue,
    avg(revenue) as avg_line_revenue
from fact_sales;

-- task3 show each product's latest recorded ending-stock balance. (inventory snapshot per product)
select
    dp.product_name,
    dd.full_date as snapshot_date,
    fmi.ending_stock_qty
from fact_monthly_inventory as fmi join
dim_product as dp on fmi.product_sk = dp.product_sk
join dim_date as dd on fmi.snapshot_date_sk = dd.date_sk;

-- task4 Find products that were listed under promotions but had no sales generated on that date. (factless fact promotion coverage analysis)
select
    dp.product_name,
    fpc.promotion_code,
    dd.full_date
from fact_promotion_coverage as fpc join
dim_product as dp on fpc.product_sk = dp.product_sk
join dim_date dd on fpc.date_sk = dd.date_sk
where not exists (
    select 1 from fact_sales as fs
    where fs.product_sk = fpc.product_sk
    and fs.order_date_sk = fpc.date_sk
)
order by dd.full_date, dp.product_name;

-- task 5 Calculate total orders and revenue per order by grouping directly on the order_id in FACT_SALES. (degenerate dimension analysis)
select 
    order_id,
    count(order_id) as line_item_count,
    sum(revenue) as order_total_revenue
from fact_sales 
group by order_id
order by order_id;

-- task 6 Aggregate sales performance across Department, Category, and Product hierarchies. (hierarchical rollup query)
select 
    dp.department_name,
    dp.category_name,
    dp.product_name,
    sum(fs.revenue) as revenue
from dim_product as dp join
fact_sales as fs on dp.product_sk = fs.product_sk
group by rollup(
    dp.department_name,
    dp.category_name,
    dp.product_name
)
order by dp.department_name nulls last,
dp.category_name nulls last,
dp.product_name nulls last;

-- task 7 Retrieve current customer attributes while ensuring historical dimension records are filtered out. (Current vs Historical SCD Type 2 Query)
select
    customer_id,
    customer_name,
    email,
    tier
from dim_customer where is_current = True
and customer_sk <> -1
order by customer_id;

-- task 8 Join historical sales to the exact version of the customer record active on the order date.
select
    fs.order_id,
    his_cus.customer_name,
    his_cus.email as email_at_purchase_time,
    fs.revenue
from fact_sales as fs 
join dim_customer as fact_cus 
    on fs.customer_sk = fact_cus.customer_sk
join dim_date as order_date
    on fs.order_date_sk = order_date.date_sk
join dim_customer as his_cus
    on his_cus.customer_id = fact_cus.customer_id
    and order_date.full_date >= his_cus.effective_start_timestamp::DATE
    and (
        his_cus.effective_end_timestamp is NULL
        or order_date.full_date < his_cus.effective_end_timestamp::DATE
    )
order by order_date.full_date, fs.order_id, fs.sales_sk;

-- task 9 Simulate handling unknown/late-arriving records by querying facts assigned to key -1. (Late-Arriving Dimension Key Routing)
select 
    fs.order_id,
    dc.customer_name,
    fs.revenue
from fact_sales as fs
join dim_customer as dc on fs.customer_sk = dc.customer_sk
where dc.customer_sk = -1;

-- task 10 Create a dedicated business data mart view for the Finance department focusing on net profit metrics (Dependent Data Mart Extraction (Sales Mart))
select 
    dd.year,
    dd.month_name,
    dp.department_name,
    sum(fs.revenue) as gross_revenue,
    sum(fs.quantity * dp.unit_cost) as total_cost,
    sum(fs.revenue - (fs.quantity*dp.unit_cost)) as net_profit
from fact_sales as fs 
join dim_date as dd on fs.order_date_sk = dd.date_sk
join dim_product as dp on fs.product_sk = dp.product_sk
group by dd.year,dd.month_name,dp.department_name;

-- task 11 Query conformed dimensions (DIM_PRODUCT and DIM_DATE) across both FACT_SALES and FACT_MONTHLY_INVENTORY.
with sales_by_product as (
    select
        product_sk,
        sum(revenue) as total_sales_revenue
    from fact_sales
    group by product_sk
),
latest_inventory as (
    select
        product_sk,
        ending_stock_qty as latest_stock_level
    from fact_monthly_inventory
)
select
    p.product_name,
    coalesce(s.total_sales_revenue, 0) as total_sales_revenue,
    i.latest_stock_level
from dim_product as p
left join sales_by_product as s
    on p.product_sk = s.product_sk
left join latest_inventory as i
    on p.product_sk = i.product_sk
order by p.product_name;

-- task 12 Calculate Recency, Frequency, and Monetary scores for all active customers. (Customer RFM Segmentation Analysis)
WITH customer_metrics AS (
    SELECT
        c.customer_id,
        c.customer_name,
        MAX(d.full_date) AS last_order_date,
        DATEDIFF('day', MAX(d.full_date), CURRENT_DATE()) AS recency_days,
        COUNT(DISTINCT fs.order_id) AS frequency,
        SUM(fs.revenue) AS monetary_value
    FROM DIM_CUSTOMER AS c
    JOIN FACT_SALES AS fs
        ON fs.customer_sk = c.customer_sk
    JOIN DIM_DATE AS d
        ON fs.order_date_sk = d.date_sk
    WHERE c.is_current = TRUE
      AND c.customer_sk <> -1
    GROUP BY c.customer_id, c.customer_name
),
rfm_scored AS (
    SELECT
        *,
        6 - NTILE(5) OVER (ORDER BY last_order_date DESC) AS recency_score,
        NTILE(5) OVER (ORDER BY frequency ASC) AS frequency_score,
        NTILE(5) OVER (ORDER BY monetary_value ASC) AS monetary_score
    FROM customer_metrics
)
SELECT
    customer_id,
    customer_name,
    last_order_date,
    recency_days,
    frequency,
    monetary_value,
    recency_score,
    frequency_score,
    monetary_score,
    CONCAT(
        recency_score::VARCHAR,
        frequency_score::VARCHAR,
        monetary_score::VARCHAR
    ) AS rfm_segment_code
FROM rfm_scored
ORDER BY customer_id;

-- task 13 Find sales with invalid product references (Referential integrity and orphan records.)
SELECT
    fs.sales_sk,
    fs.product_sk
FROM FACT_SALES AS fs
LEFT JOIN DIM_PRODUCT AS p
    ON fs.product_sk = p.product_sk
WHERE p.product_sk IS NULL
ORDER BY fs.sales_sk;

-- task 14 Demonstrate an SCD Type 2 change with MERGE(Surrogate-key generation, MERGE, and historical versioning.)
CREATE SEQUENCE IF NOT EXISTS CUSTOMER_SK_SEQ
    START = 121
    INCREMENT = 1;
MERGE INTO DIM_CUSTOMER AS tgt
USING (
    SELECT
        'CUST-002'::VARCHAR AS customer_id,
        'Bob Jones'::VARCHAR AS customer_name,
        'bob@yahoo.com'::VARCHAR AS email,
        'Gold'::VARCHAR AS tier,
        'Chicago'::VARCHAR AS city,
        CURRENT_TIMESTAMP()::TIMESTAMP_NTZ AS change_ts
) AS src
ON tgt.customer_id = src.customer_id
AND tgt.is_current = TRUE
WHEN MATCHED AND (
       tgt.customer_name <> src.customer_name
    OR tgt.email <> src.email
    OR tgt.tier <> src.tier
    OR tgt.city <> src.city
) THEN UPDATE SET
    effective_end_timestamp = src.change_ts,
    is_current = FALSE;

MERGE INTO DIM_CUSTOMER AS tgt
USING (
    SELECT
        'CUST-002'::VARCHAR AS customer_id,
        'Bob Jones'::VARCHAR AS customer_name,
        'bob@yahoo.com'::VARCHAR AS email,
        'Gold'::VARCHAR AS tier,
        'Chicago'::VARCHAR AS city,
        CURRENT_TIMESTAMP()::TIMESTAMP_NTZ AS change_ts
) AS src
ON tgt.customer_id = src.customer_id
AND tgt.is_current = TRUE
WHEN NOT MATCHED THEN INSERT (
    customer_sk,
    customer_id,
    customer_name,
    email,
    tier,
    city,
    effective_start_timestamp,
    effective_end_timestamp,
    is_current
) VALUES (
    CUSTOMER_SK_SEQ.NEXTVAL,
    src.customer_id,
    src.customer_name,
    src.email,
    src.tier,
    src.city,
    src.change_ts,
    NULL,
    TRUE
);

SELECT
    customer_id,
    customer_sk,
    tier,
    effective_start_timestamp,
    effective_end_timestamp,
    is_current
FROM DIM_CUSTOMER
WHERE customer_id = 'CUST-002'
ORDER BY effective_start_timestamp;

-- task 15 Create an audit history of warehouse tables(Metadata, audit tables, and window functions.)
CREATE TABLE IF NOT EXISTS DW_AUDIT_COUNTS (
    audit_timestamp TIMESTAMP_NTZ NOT NULL,
    table_name VARCHAR(255) NOT NULL,
    row_count NUMBER,
    last_altered TIMESTAMP_NTZ
);

INSERT INTO DW_AUDIT_COUNTS (
    audit_timestamp,
    table_name,
    row_count,
    last_altered
)
SELECT
    CURRENT_TIMESTAMP()::TIMESTAMP_NTZ AS audit_timestamp,
    table_name,
    row_count,
    last_altered::TIMESTAMP_NTZ
FROM ENTERPRISE_DW.INFORMATION_SCHEMA.TABLES
WHERE table_schema = 'RETAIL_MART'
  AND table_name IN (
      'DIM_DATE',
      'DIM_CUSTOMER',
      'DIM_PRODUCT',
      'FACT_SALES',
      'FACT_MONTHLY_INVENTORY',
      'FACT_PROMOTION_COVERAGE'
  );

  SELECT
    table_name,
    row_count,
    last_altered,
    audit_timestamp
FROM DW_AUDIT_COUNTS
QUALIFY ROW_NUMBER() OVER (
    PARTITION BY table_name
    ORDER BY audit_timestamp DESC
) = 1
ORDER BY table_name;