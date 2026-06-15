-- ============================================================
-- E-Commerce Analytics: SQL Queries
-- Author: [Your Name]
-- Description: Key business metrics using SQLite
-- ============================================================


-- ── 1. OVERVIEW: Total Revenue & Orders ─────────────────────
SELECT
    COUNT(DISTINCT o.order_id)               AS total_orders,
    COUNT(DISTINCT o.customer_id)            AS unique_customers,
    ROUND(SUM(oi.subtotal), 2)               AS gross_revenue,
    ROUND(AVG(oi.subtotal), 2)               AS avg_order_value
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status = 'Completed';


-- ── 2. REVENUE BY MONTH ─────────────────────────────────────
SELECT
    strftime('%Y-%m', o.order_date)          AS month,
    COUNT(DISTINCT o.order_id)               AS orders,
    ROUND(SUM(oi.subtotal), 2)               AS revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status = 'Completed'
GROUP BY month
ORDER BY month;


-- ── 3. REVENUE BY CATEGORY ──────────────────────────────────
SELECT
    p.category,
    COUNT(DISTINCT o.order_id)               AS orders,
    ROUND(SUM(oi.subtotal), 2)               AS revenue,
    ROUND(SUM(oi.subtotal) * 100.0 /
          SUM(SUM(oi.subtotal)) OVER (), 1)  AS pct_of_total
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p     ON oi.product_id = p.product_id
WHERE o.status = 'Completed'
GROUP BY p.category
ORDER BY revenue DESC;


-- ── 4. TOP 10 PRODUCTS BY REVENUE ───────────────────────────
SELECT
    p.product_name,
    p.category,
    SUM(oi.quantity)                         AS units_sold,
    ROUND(SUM(oi.subtotal), 2)               AS revenue,
    ROUND(SUM(oi.subtotal) - SUM(oi.quantity * p.cost), 2) AS gross_profit
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p     ON oi.product_id = p.product_id
WHERE o.status = 'Completed'
GROUP BY p.product_id
ORDER BY revenue DESC
LIMIT 10;


-- ── 5. CUSTOMER SEGMENTATION PERFORMANCE ────────────────────
SELECT
    c.segment,
    COUNT(DISTINCT c.customer_id)            AS customers,
    COUNT(DISTINCT o.order_id)               AS orders,
    ROUND(SUM(oi.subtotal), 2)               AS total_revenue,
    ROUND(SUM(oi.subtotal) /
          COUNT(DISTINCT c.customer_id), 2)  AS revenue_per_customer,
    ROUND(CAST(COUNT(DISTINCT o.order_id) AS FLOAT) /
          COUNT(DISTINCT c.customer_id), 1)  AS orders_per_customer
FROM customers c
LEFT JOIN orders o     ON c.customer_id = o.customer_id AND o.status = 'Completed'
LEFT JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.segment
ORDER BY revenue_per_customer DESC;


-- ── 6. ACQUISITION CHANNEL PERFORMANCE ──────────────────────
SELECT
    o.channel,
    COUNT(DISTINCT o.order_id)               AS orders,
    COUNT(DISTINCT o.customer_id)            AS customers,
    ROUND(SUM(oi.subtotal), 2)               AS revenue,
    ROUND(SUM(oi.subtotal) /
          COUNT(DISTINCT o.order_id), 2)     AS avg_order_value
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status = 'Completed'
GROUP BY o.channel
ORDER BY revenue DESC;


-- ── 7. RETURN RATE BY CATEGORY ───────────────────────────────
SELECT
    p.category,
    COUNT(DISTINCT o.order_id)               AS total_orders,
    SUM(CASE WHEN o.status = 'Returned' THEN 1 ELSE 0 END) AS returns,
    ROUND(SUM(CASE WHEN o.status = 'Returned' THEN 1 ELSE 0 END) * 100.0 /
          COUNT(DISTINCT o.order_id), 1)     AS return_rate_pct
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p     ON oi.product_id = p.product_id
GROUP BY p.category
ORDER BY return_rate_pct DESC;


-- ── 8. RFM BASE TABLE (Recency / Frequency / Monetary) ───────
-- Used in Python for full RFM scoring
SELECT
    c.customer_id,
    c.first_name || ' ' || c.last_name       AS customer_name,
    c.segment,
    c.city,
    MAX(o.order_date)                        AS last_order_date,
    COUNT(DISTINCT o.order_id)               AS frequency,
    ROUND(SUM(oi.subtotal), 2)               AS monetary
FROM customers c
JOIN orders o      ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status = 'Completed'
GROUP BY c.customer_id;


-- ── 9. REPEAT vs ONE-TIME CUSTOMERS ─────────────────────────
SELECT
    CASE
        WHEN order_count = 1 THEN 'One-time buyer'
        WHEN order_count BETWEEN 2 AND 4 THEN 'Repeat buyer'
        ELSE 'Loyal buyer'
    END                                      AS buyer_type,
    COUNT(*)                                 AS customers,
    ROUND(AVG(total_spent), 2)               AS avg_spent
FROM (
    SELECT
        o.customer_id,
        COUNT(DISTINCT o.order_id)           AS order_count,
        SUM(oi.subtotal)                     AS total_spent
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.status = 'Completed'
    GROUP BY o.customer_id
) sub
GROUP BY buyer_type
ORDER BY avg_spent DESC;


-- ── 10. CITY REVENUE RANKING ─────────────────────────────────
SELECT
    c.city,
    COUNT(DISTINCT c.customer_id)            AS customers,
    COUNT(DISTINCT o.order_id)               AS orders,
    ROUND(SUM(oi.subtotal), 2)               AS revenue,
    RANK() OVER (ORDER BY SUM(oi.subtotal) DESC) AS revenue_rank
FROM customers c
JOIN orders o      ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status = 'Completed'
GROUP BY c.city
ORDER BY revenue_rank;
