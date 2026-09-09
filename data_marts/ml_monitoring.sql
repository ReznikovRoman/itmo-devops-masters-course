-- Примеры запросов для панели мониторинга ML-модели (п.7).
-- В реальном проекте качество модели (accuracy/precision/recall) обычно
-- логируется отдельно (например, в таблицу model_metrics), а тут -- пример
-- того, как отслеживать ДРЕЙФ ДАННЫХ на входных признаках без отдельного
-- ML-стека, средствами обычного SQL поверх витрины.

-- Пример 1: динамика среднего чека по месяцам -- базовый "график деградации"
-- (в реальности вместо amount сюда подставляется метрика качества модели).
SELECT
    date_trunc('month', d.sale_date) AS month,
    ROUND(AVG(f.amount)::numeric, 2) AS avg_order_amount,
    COUNT(*) AS orders_count
FROM fact_sales f
JOIN dim_date d ON d.id = f.date_id
GROUP BY 1
ORDER BY 1;

-- Пример 2: сравнение распределения признака "сумма заказа" в двух периодах
-- условно "обучение" (train) vs "прод" (последние 30 дней). Разбиваем
-- на бакеты (аналог гистограммы) -- такой запрос обычно и лежит в основе
-- панели дрейфа данных в BI-инструменте.
WITH period_bounds AS (
    SELECT
        (SELECT max(sale_date) FROM dim_date) - INTERVAL '30 days' AS prod_from,
        (SELECT max(sale_date) FROM dim_date) AS max_date
),
labeled AS (
    SELECT
        f.amount,
        CASE
            WHEN d.sale_date >= period_bounds.prod_from THEN 'prod_last_30d'
            ELSE 'train'
        END AS period
    FROM fact_sales f
    JOIN dim_date d ON d.id = f.date_id
    CROSS JOIN period_bounds
),
bucketed AS (
    SELECT
        period,
        width_bucket(amount, 0, 500, 5) AS bucket, -- 5 бакетов по сумме заказа
        COUNT(*) AS cnt
    FROM labeled
    GROUP BY 1, 2
)
SELECT
    bucket,
    COALESCE(SUM(cnt) FILTER (WHERE period = 'train'), 0) AS train_count,
    COALESCE(SUM(cnt) FILTER (WHERE period = 'prod_last_30d'), 0) AS prod_count
FROM bucketed
GROUP BY bucket
ORDER BY bucket;

-- Пример 3: доля "новых" клиентов без истории на момент среза --
-- полезно, чтобы отследить дрейф целевой аудитории (concept drift по сегментам).
SELECT
    c.segment,
    COUNT(DISTINCT c.id) AS customers,
    COUNT(DISTINCT c.id) FILTER (WHERE f.customer_id IS NULL) AS customers_without_orders
FROM dim_customer c
LEFT JOIN fact_sales f ON f.customer_id = c.id
GROUP BY c.segment;
