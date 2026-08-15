# Supply Chain SQL Analysis

## Project Overview

SQL analysis of supplier performance using a realistic mock supply chain database. This project demonstrates core SQL concepts (JOIN, GROUP BY, subqueries, CTEs, window functions) applied to real-world supply chain questions.

The goal: identify which suppliers are most reliable (on-time delivery, minimal delays, high volume) and which products are high-value but frequently delayed — insights that directly support procurement decisions and supplier scorecard management.

## Database

**File:** `supply_chain.db` (SQLite)

**Tables (8 total):**
- `suppliers` (20 rows) — supplier names, locations, reliability ratings, lead times
- `purchase_orders` (275 rows) — orders from suppliers, delivery dates, status
- `shipments` (261 rows) — shipping details by carrier, transport mode, freight costs
- `inventory` (1,080 rows) — warehouse stock levels, reorder points (monthly snapshots)
- `products` (45 rows) — product names, categories, unit costs
- `warehouses` (4 rows) — warehouse locations and capacity
- `customers` (10 rows) — customer names and locations
- `sales_orders` (184 rows) — customer orders fulfilled from inventory

## 7 Core Queries

### Query 1: Supplier Order Count
**Question:** How many purchase orders has each supplier fulfilled?

Shows order volume per supplier. Key for understanding supplier dependence and workload.

### Query 2: Average Delivery Delay
**Question:** What is the average delivery delay per supplier?

Calculates delay in days (actual vs. expected delivery date). Negative values = early; positive = late.

### Query 3: Warehouse Inventory Below Reorder Point
**Question:** Which warehouse has the most products sitting below reorder point?

Identifies critical stock shortages by warehouse. Alerts for inventory replenishment.

### Query 4: Freight Cost Trends by Carrier & Month
**Question:** How do freight costs vary by carrier and over time?

Tracks shipping cost trends month-by-month per carrier. Useful for negotiating freight rates.

### Query 5: High-Value + Frequently Delayed Products
**Question:** Which expensive products are delayed most often?

Combines two risk factors: high unit cost + frequent late deliveries. These are priority focus for supplier negotiations.

### Query 6: Running Total of Orders per Supplier
**Question:** What is the cumulative order quantity per supplier over time?

Uses window functions to show running totals without collapsing rows. Reveals supply chain velocity per supplier.

### Query 7: Full Supplier Scorecard (CTEs)
**Question:** Which suppliers perform best overall?

Combines three metrics using CTEs:
- **on_time_pct:** % of orders delivered on or before expected date
- **avg_delay_days:** average delivery delay in days
- **total_orders:** order volume

Suppliers ranked by on-time % (ascending, worst first), then by delay (descending, worst first).

## Key Finding

Supplier performance varies significantly:
- **Top performers:** 85%+ on-time, < 1 day avg delay
- **Worst performers:** 60% on-time, 3+ days avg delay

High-volume suppliers (15+ orders) with low on-time % are bottlenecks; low-volume suppliers with strong performance are growth candidates.

## How to Use

### Prerequisites
- Download [DB Browser for SQLite](https://sqlitebrowser.org/) (free, open-source)
- Have the `supply_chain.db` file

### Steps
1. Open DB Browser for SQLite
2. File → Open Database → select `supply_chain.db`
3. Go to the "Execute SQL" tab
4. Copy/paste any query from `supplier_analysis.sql`
5. Press Ctrl+Enter to run
6. Results appear in the table below

## Technologies & Skills

**SQL Concepts Used:**
- `SELECT`, `FROM`, `WHERE`, `ORDER BY`, `LIMIT`
- `JOIN` (connecting multiple tables)
- `GROUP BY`, `COUNT()`, `AVG()`, aggregation
- `CASE WHEN` (conditional counting)
- Subqueries (scalar, list, derived tables)
- `HAVING` (filtering after grouping)
- Window functions: `SUM() OVER()`, `ROW_NUMBER() OVER()`
- CTEs: `WITH ... AS` (multi-step queries)
- Date functions: `julianday()`, `strftime()`

**Database Concepts:**
- Foreign key relationships
- Table joins and aliases
- Partitioning and ranking
- Date arithmetic

## Files in This Repository

- `supplier_analysis.sql` — all 7 queries, numbered and documented
- `README.md` — this file
- `supply_chain.db` — the mock database (download separately from project documentation)

---

**Author:** Marzie Eskandari  
**Date:** August 2026  
**Context:** Portfolio project for Supply Chain Analyst role applications
