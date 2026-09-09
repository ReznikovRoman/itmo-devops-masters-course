-- Пример 1: та же витрина продаж, что и в views.sql, но материализованная.
-- Данные физически хранятся на диске и не пересчитываются при каждом SELECT.
CREATE MATERIALIZED VIEW mv_sales_by_month_category AS
SELECT
    date_trunc('month', d.sale_date) AS month,
    p.category,
    SUM(f.amount) AS total_amount,
    SUM(f.quantity) AS total_qty
FROM fact_sales f
JOIN dim_product p ON p.id = f.product_id
JOIN dim_date d ON d.id = f.date_id
GROUP BY 1, 2
WITH DATA;

SELECT * FROM mv_sales_by_month_category ORDER BY month, category;

-- Обычное обновление: блокирует чтение из mv на время пересчёта.
REFRESH MATERIALIZED VIEW mv_sales_by_month_category;

-- Обновление без блокировки чтения -- требует уникального индекса на mv.
CREATE UNIQUE INDEX ON mv_sales_by_month_category (month, category);
REFRESH MATERIALIZED VIEW CONCURRENTLY mv_sales_by_month_category;

-- Пример 2: витрина признаков для ML (модель оттока клиентов).
-- Важно: считаем метрики ТОЛЬКО по данным до даты среза, иначе модель
-- "увидит" будущее поведение клиента -- это и есть data leakage.
CREATE MATERIALIZED VIEW mv_ml_customer_features AS
SELECT
    c.id AS customer_id,
    c.segment,
    c.city,
    count(f.id) FILTER (
        WHERE d.sale_date >= (now()) - INTERVAL '90 days'
    ) AS orders_last_90d,
    coalesce(
        sum(f.amount) FILTER (
            WHERE d.sale_date >= (SELECT max(sale_date) FROM dim_date) - INTERVAL '90 days'
        ),
        0
    ) AS amount_last_90d,
    max(d.sale_date) AS last_order_date,
    (SELECT max(sale_date) FROM dim_date) - max(d.sale_date) AS days_since_last_order
FROM dim_customer c
LEFT JOIN fact_sales f ON f.customer_id = c.id
LEFT JOIN dim_date d ON d.id = f.date_id
GROUP BY c.id,
         c.segment, c.city
WITH DATA;

SELECT * FROM mv_ml_customer_features ORDER BY days_since_last_order LIMIT 5;
