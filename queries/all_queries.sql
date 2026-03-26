-- ============================================================
-- 01_revenue_by_country.sql
-- Total revenue by destination country, ordered by revenue desc
-- ============================================================
SELECT ship_country,
       ROUND(SUM(od.unit_price * od.quantity * (1 - od.discount))::numeric, 2) AS total_revenue
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
GROUP BY ship_country
ORDER BY total_revenue DESC;


-- ============================================================
-- 02_revenue_by_category.sql
-- Revenue and order count by product category
-- ============================================================
SELECT cat.category_name,
       ROUND(SUM(od.unit_price * od.quantity * (1 - od.discount))::numeric, 2) AS revenue,
       COUNT(DISTINCT o.order_id) AS num_orders,
       ROUND(SUM(od.unit_price * od.quantity * (1 - od.discount))::numeric /
             NULLIF(COUNT(DISTINCT o.order_id), 0), 2) AS revenue_per_order
FROM order_details od
JOIN products p      ON od.product_id = p.product_id
JOIN categories cat  ON p.category_id = cat.category_id
JOIN orders o        ON od.order_id   = o.order_id
GROUP BY cat.category_name
ORDER BY revenue DESC;


-- ============================================================
-- 03_monthly_trend.sql
-- Month-over-month revenue with growth % using LAG window function
-- ============================================================
WITH monthly AS (
    SELECT DATE_TRUNC('month', o.order_date) AS month,
           ROUND(SUM(od.unit_price * od.quantity * (1 - od.discount))::numeric, 2) AS revenue
    FROM orders o
    JOIN order_details od ON o.order_id = od.order_id
    GROUP BY 1
)
SELECT month,
       revenue,
       LAG(revenue) OVER (ORDER BY month) AS prev_month_revenue,
       ROUND(
           (revenue - LAG(revenue) OVER (ORDER BY month)) /
           NULLIF(LAG(revenue) OVER (ORDER BY month), 0) * 100,
       2) AS growth_pct
FROM monthly
ORDER BY month;


-- ============================================================
-- 04_employee_performance.sql
-- Revenue, order count and avg order value per employee
-- ============================================================
SELECT e.first_name || ' ' || e.last_name   AS employee_name,
       e.title,
       COUNT(DISTINCT o.order_id)            AS total_orders,
       ROUND(SUM(od.unit_price * od.quantity * (1 - od.discount))::numeric, 2) AS total_revenue,
       ROUND(AVG(od.unit_price * od.quantity * (1 - od.discount))::numeric, 2) AS avg_order_line_value
FROM employees e
JOIN orders o        ON e.employee_id = o.employee_id
JOIN order_details od ON o.order_id   = od.order_id
GROUP BY e.employee_id, e.first_name, e.last_name, e.title
ORDER BY total_revenue DESC;


-- ============================================================
-- 05_customer_segmentation.sql
-- Customers segmented by total lifetime spend using CASE
-- ============================================================
WITH customer_spend AS (
    SELECT c.company_name,
           c.country,
           COUNT(DISTINCT o.order_id) AS total_orders,
           ROUND(SUM(od.unit_price * od.quantity * (1 - od.discount))::numeric, 2) AS total_spend
    FROM customers c
    JOIN orders o        ON c.customer_id = o.customer_id
    JOIN order_details od ON o.order_id   = od.order_id
    GROUP BY c.company_name, c.country
)
SELECT *,
       CASE
           WHEN total_spend > 10000 THEN 'High Value'
           WHEN total_spend > 5000  THEN 'Mid Value'
           ELSE                          'Low Value'
       END AS segment
FROM customer_spend
ORDER BY total_spend DESC;


-- ============================================================
-- 06_shipping_performance.sql
-- Avg, min and max days to ship by carrier
-- ============================================================
SELECT s.company_name                           AS shipper,
       COUNT(o.order_id)                        AS total_orders,
       ROUND(AVG(o.shipped_date - o.order_date), 1) AS avg_days_to_ship,
       MIN(o.shipped_date - o.order_date)       AS fastest_days,
       MAX(o.shipped_date - o.order_date)       AS slowest_days
FROM orders o
JOIN shippers s ON o.ship_via = s.shipper_id
WHERE o.shipped_date IS NOT NULL
GROUP BY s.company_name
ORDER BY avg_days_to_ship;


-- ============================================================
-- 07_product_rank_by_category.sql
-- Products ranked by revenue within each category using RANK()
-- ============================================================
WITH product_sales AS (
    SELECT cat.category_name,
           p.product_name,
           ROUND(SUM(od.unit_price * od.quantity * (1 - od.discount))::numeric, 2) AS revenue
    FROM order_details od
    JOIN products p     ON od.product_id = p.product_id
    JOIN categories cat ON p.category_id = cat.category_id
    GROUP BY cat.category_name, p.product_name
)
SELECT category_name,
       product_name,
       revenue,
       RANK() OVER (PARTITION BY category_name ORDER BY revenue DESC) AS rank_in_category
FROM product_sales
ORDER BY category_name, rank_in_category;


-- ============================================================
-- 08_repeat_vs_onetme_customers.sql
-- Cohort analysis — one-time vs repeat vs loyal customers
-- ============================================================
WITH order_counts AS (
    SELECT customer_id,
           COUNT(DISTINCT order_id) AS num_orders
    FROM orders
    GROUP BY customer_id
)
SELECT
    CASE
        WHEN num_orders = 1            THEN 'One-time'
        WHEN num_orders BETWEEN 2 AND 5 THEN 'Repeat'
        ELSE                                'Loyal'
    END                                         AS customer_type,
    COUNT(*)                                    AS num_customers,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS pct_of_total
FROM order_counts
GROUP BY 1
ORDER BY num_customers DESC;


-- ============================================================
-- 09_running_total.sql
-- Cumulative revenue over time using SUM() window function
-- ============================================================
WITH monthly AS (
    SELECT DATE_TRUNC('month', o.order_date) AS month,
           ROUND(SUM(od.unit_price * od.quantity * (1 - od.discount))::numeric, 2) AS revenue
    FROM orders o
    JOIN order_details od ON o.order_id = od.order_id
    GROUP BY 1
)
SELECT month,
       revenue,
       ROUND(SUM(revenue) OVER (ORDER BY month)::numeric, 2) AS running_total
FROM monthly
ORDER BY month;
