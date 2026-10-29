# Enterprise Retail Data Warehouse — Snowflake SQL

## Project Overview
This project demonstrates SQL development for an enterprise-style retail data warehouse using Snowflake. It covers sales analysis, inventory reporting, customer history, data quality checks, and audit reporting.

## Objectives
- Analyze retail sales using fact and dimension tables.
- Use role-playing dimensions for order and shipping dates.
- Implement Slowly Changing Dimension Type 2 (SCD Type 2) logic.
- Perform customer segmentation using RFM analysis.
- Identify orphan records and unknown customer references.
- Create a finance sales mart view.
- Track warehouse table metadata for auditing.

## Technologies
- Snowflake SQL
- Common Table Expressions (CTEs)
- Window functions: `ROW_NUMBER()` and `NTILE()`
- `QUALIFY`, `ROLLUP`, `MERGE`, and `NOT EXISTS`
- Views and `INFORMATION_SCHEMA`

## Project Structure
- `sql/` — SQL solutions for the project tasks.
- `docs/` — Detailed line-by-line explanation guide.

## Tasks Covered
1. Role-playing date dimensions
2. Additive sales measures
3. Latest inventory per product
4. Promotions without matching sales
5. Order-level analysis
6. Hierarchical sales rollups
7. Current SCD Type 2 customer records
8. Historical customer lookup
9. Unknown customer analysis
10. Finance sales mart view
11. Sales and inventory reporting
12. RFM customer segmentation
13. Orphan product reference detection
14. SCD Type 2 update and insert workflow
15. Table row-count audit snapshots

## How to Use
1. Review the SQL scripts in the `sql/` folder.
2. Confirm that the required tables and columns exist in your Snowflake database.
3. Update database, schema, and sample values as required.
4. Execute the queries in Snowflake and validate the results.

## Notes
The scripts are intended for learning and demonstration. Some queries depend on the source tables and columns defined in the project environment. Review and test them against your own Snowflake schema before using them in production.
