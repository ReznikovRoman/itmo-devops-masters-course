-- Схема для практикума: "звезда" -- факт продаж + три измерения.
-- Такая схема обычно и лежит в основе хранилища, а на этом
-- вебинаре мы строим витрины (VIEW / MATERIALIZED VIEW) поверх неё.

CREATE TABLE IF NOT EXISTS dim_customer (
    id SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    city VARCHAR(50),
    segment VARCHAR(20) NOT NULL, -- 'retail' / 'wholesale' / 'vip'
    registration_date DATE NOT NULL
);

CREATE TABLE IF NOT EXISTS dim_product (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    price DECIMAL(10, 2) NOT NULL
);

CREATE TABLE IF NOT EXISTS dim_date (
    id SERIAL PRIMARY KEY,
    sale_date DATE UNIQUE NOT NULL,
    year INT NOT NULL,
    month INT NOT NULL,
    quarter INT NOT NULL,
    day_of_week INT NOT NULL -- ISO: 1 = понедельник ... 7 = воскресенье
);

CREATE TABLE IF NOT EXISTS fact_sales (
    id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL REFERENCES dim_customer (id),
    product_id INT NOT NULL REFERENCES dim_product (id),
    date_id INT NOT NULL REFERENCES dim_date (id),
    quantity INT NOT NULL,
    amount DECIMAL(10, 2) NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_fact_sales_customer ON fact_sales (customer_id);
CREATE INDEX IF NOT EXISTS idx_fact_sales_date ON fact_sales (date_id);

INSERT INTO dim_customer (full_name, city, segment, registration_date) VALUES
    ('Alice Smith', 'Montreal', 'vip', '2023-01-15'),
    ('Bob Johnson', 'Toronto', 'retail', '2023-03-02'),
    ('Charlie Brown', 'Montreal', 'retail', '2023-05-20'),
    ('Diana Lee', 'Vancouver', 'wholesale', '2023-06-11'),
    ('Ethan Wright', 'Toronto', 'retail', '2023-08-01'),
    ('Fiona Clark', 'Montreal', 'vip', '2023-09-17'),
    ('George Miller', 'Calgary', 'wholesale', '2024-01-05'),
    ('Hannah Davis', 'Vancouver', 'retail', '2024-02-28');

INSERT INTO dim_product (name, category, price) VALUES
    ('Wireless Mouse', 'Electronics', 25.00),
    ('Mechanical Keyboard', 'Electronics', 89.00),
    ('Running Shoes', 'Sports', 65.00),
    ('Yoga Mat', 'Sports', 30.00),
    ('Winter Jacket', 'Clothing', 120.00),
    ('T-Shirt', 'Clothing', 20.00);

INSERT INTO dim_date (sale_date, year, month, quarter, day_of_week)
SELECT
    d::date,
    EXTRACT(year FROM d)::int,
    EXTRACT(month FROM d)::int,
    EXTRACT(quarter FROM d)::int,
    EXTRACT(isodow FROM d)::int
FROM generate_series('2025-04-01'::date, '2025-09-30'::date, interval '1 day') AS d;

-- Важно: каждый random() кладём прямо в SELECT верхнего запроса (в CTE picks),
-- а не внутрь некоррелированного LATERAL-подзапроса -- иначе планировщик
-- Postgres может посчитать подзапрос один раз и переиспользовать результат
-- для всех строк generate_series (получим N одинаковых "случайных" строк).
SELECT setseed(0.42);

WITH customers AS (SELECT array_agg(id) AS ids FROM dim_customer),
     products AS (SELECT array_agg(id) AS ids FROM dim_product),
     dates AS (SELECT array_agg(id) AS ids FROM dim_date),
     picks AS (
         SELECT
             customers.ids[1 + floor(random() * array_length(customers.ids, 1))::int] AS customer_id,
             products.ids[1 + floor(random() * array_length(products.ids, 1))::int] AS product_id,
             dates.ids[1 + floor(random() * array_length(dates.ids, 1))::int] AS date_id,
             (1 + floor(random() * 5))::int AS quantity
         FROM generate_series(1, 400) AS gs(n)  -- TODO: 400 or 4000000 (views vs materialized views)
         CROSS JOIN customers
         CROSS JOIN products
         CROSS JOIN dates
     )
INSERT INTO fact_sales (customer_id, product_id, date_id, quantity, amount)
SELECT
    picks.customer_id,
    picks.product_id,
    picks.date_id,
    picks.quantity,
    ROUND((dp.price * picks.quantity)::numeric, 2) AS amount
FROM picks
JOIN dim_product dp ON dp.id = picks.product_id;
