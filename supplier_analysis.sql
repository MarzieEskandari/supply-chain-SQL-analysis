-- ============================================================================
-- SUPPLY CHAIN SQL ANALYSIS PROJECT
-- 7 Core Queries for Supplier Performance Scorecard
-- Database: supply_chain.db (SQLite)
-- ============================================================================

-- ============================================================================
-- QUESTION 1: Which suppliers have the worst on-time delivery rate?
-- ============================================================================
SELECT s.name, COUNT(*) AS order_count
FROM purchase_orders po
JOIN suppliers s ON s.supplier_id = po.supplier_id
GROUP BY s.name
ORDER BY order_count DESC;

-- ============================================================================
-- QUESTION 2: What's the average delay per supplier?
-- ============================================================================
SELECT s.name,
       ROUND(AVG(julianday(po.actual_delivery_date) - julianday(po.expected_delivery_date)), 1) AS average_delay
FROM purchase_orders po
JOIN suppliers s ON s.supplier_id = po.supplier_id
WHERE actual_delivery_date IS NOT NULL
GROUP BY s.name
ORDER BY average_delay DESC;

-- ============================================================================
-- QUESTION 3: Which warehouse has the most inventory below reorder point?
-- ============================================================================
SELECT w.name, COUNT(*) AS below_reorder_count
FROM inventory i
JOIN warehouses w ON i.warehouse_id = w.warehouse_id
WHERE i.quantity_on_hand < i.reorder_point
GROUP BY w.name
ORDER BY below_reorder_count DESC;

-- ============================================================================
-- QUESTION 4: What's the trend in freight cost by carrier and transport mode?
-- ============================================================================
SELECT carrier, strftime('%Y-%m', ship_date) AS month, ROUND(AVG(freight_cost), 2) AS average_freight_cost
FROM shipments
GROUP BY month, carrier
ORDER BY month, carrier;

-- ============================================================================
-- QUESTION 5: Which products are both high-value and frequently delayed?
-- ============================================================================
SELECT p.name, p.unit_cost, d.late_count
FROM products p
JOIN (
    SELECT product_id, COUNT(*) AS late_count
    FROM purchase_orders
    WHERE julianday(actual_delivery_date) - julianday(expected_delivery_date) > 0
    GROUP BY product_id
    HAVING COUNT(*) > 3
) d ON p.product_id = d.product_id
WHERE p.unit_cost > (SELECT AVG(unit_cost) FROM products)
ORDER BY p.unit_cost DESC;

-- ============================================================================
-- QUESTION 6: Running total of quantity per supplier over time (window functions)
-- ============================================================================
SELECT po_id, supplier_id, order_date, quantity,
       SUM(quantity) OVER (PARTITION BY supplier_id ORDER BY order_date) AS running_total
FROM purchase_orders
ORDER BY supplier_id, order_date;

-- ============================================================================
-- QUESTION 7: FULL SUPPLIER SCORECARD (CTEs)
-- On-time delivery % + average delay + order volume per supplier
-- ============================================================================
WITH on_time_stats AS (
    SELECT supplier_id,
           COUNT(*) AS total_orders,
           SUM(CASE WHEN julianday(actual_delivery_date) <= julianday(expected_delivery_date) THEN 1 ELSE 0 END) AS on_time_orders
    FROM purchase_orders
    WHERE actual_delivery_date IS NOT NULL
    GROUP BY supplier_id
),
delay_stats AS (
    SELECT supplier_id,
           ROUND(AVG(julianday(actual_delivery_date) - julianday(expected_delivery_date)), 1) AS avg_delay_days
    FROM purchase_orders
    WHERE actual_delivery_date IS NOT NULL
    GROUP BY supplier_id
)
SELECT s.name, o.total_orders,
       ROUND(100.0 * o.on_time_orders / o.total_orders, 1) AS on_time_pct,
       d.avg_delay_days
FROM on_time_stats o
JOIN delay_stats d ON o.supplier_id = d.supplier_id
JOIN suppliers s ON o.supplier_id = s.supplier_id
ORDER BY on_time_pct ASC, d.avg_delay_days DESC;

-- ============================================================================
-- END OF SUPPLIER ANALYSIS QUERIES
-- ============================================================================
