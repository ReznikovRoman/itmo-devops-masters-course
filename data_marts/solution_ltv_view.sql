-- Решение для задания "витрина для LTV клиентов"

CREATE VIEW vw_customer_ltv AS
SELECT
    c.id AS customer_id,
    c.full_name,
    c.segment,
    c.city,
    COALESCE(SUM(f.amount), 0) AS total_amount,
    COUNT(f.id) AS orders_count,
    ROUND(AVG(f.amount)::numeric, 2) AS avg_order_amount,
    MIN(d.sale_date) AS first_order_date,
    MAX(d.sale_date) AS last_order_date,
    MAX(d.sale_date) - MIN(d.sale_date) AS customer_lifetime_days
FROM dim_customer c
LEFT JOIN fact_sales f ON f.customer_id = c.id
LEFT JOIN dim_date d ON d.id = f.date_id
GROUP BY c.id, c.full_name, c.segment, c.city;

SELECT * FROM vw_customer_ltv ORDER BY total_amount DESC;
