-- Пример 1: витрина продаж по месяцам и категориям
-- (её мы пишем вместе на вебинаре, п.3)
CREATE VIEW vw_sales_by_month_category AS
SELECT
    date_trunc('month', d.sale_date) AS month,
    p.category,
    SUM(f.amount) AS total_amount,
    SUM(f.quantity) AS total_qty
FROM fact_sales f
JOIN dim_product p ON p.id = f.product_id
JOIN dim_date d ON d.id = f.date_id
GROUP BY 1, 2;

SELECT * FROM vw_sales_by_month_category ORDER BY month, category;

-- Пример 2: разграничение доступа через VIEW.
-- Аналитику даём доступ только к этому представлению, а не к fact_sales/dim_customer
-- напрямую -- так можно скрыть чувствительные поля (например, email, phone_number).
CREATE VIEW vw_sales_by_customer_segment AS
SELECT
    c.segment,
    c.city,
    date_trunc('month', d.sale_date) AS month,
    SUM(f.amount) AS total_amount,
    COUNT(DISTINCT f.customer_id) AS distinct_customers
FROM fact_sales f
JOIN dim_customer c ON c.id = f.customer_id
JOIN dim_date d ON d.id = f.date_id
GROUP BY 1, 2, 3;

-- GRANT SELECT ON vw_sales_by_customer_segment TO analyst_role;
-- REVOKE ALL ON fact_sales, dim_customer FROM analyst_role;

SELECT * FROM vw_sales_by_customer_segment ORDER BY month, segment LIMIT 10;

EXPLAIN ANALYZE SELECT * FROM vw_sales_by_month_category;