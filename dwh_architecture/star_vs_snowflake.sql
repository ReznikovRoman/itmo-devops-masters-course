-- звёздная схема для сети кофеен

-- Звёздная схема
-- Измерения денормализованы: категория товара лежит колонкой в dim_product
CREATE TABLE dim_shop (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL
);

CREATE TABLE dim_product_star (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL -- категория сразу в товаре
);

CREATE TABLE fact_coffee_sales_star (
    id SERIAL PRIMARY KEY,
    shop_id INT NOT NULL REFERENCES dim_shop (id),
    product_id INT NOT NULL REFERENCES dim_product_star (id),
    sale_ts TIMESTAMP NOT NULL,
    quantity INT NOT NULL,
    amount DECIMAL(10, 2) NOT NULL
);

INSERT INTO dim_shop (name, city) VALUES
    ('Downtown', 'Montreal'),
    ('Old Port', 'Montreal');

INSERT INTO dim_product_star (name, category) VALUES
    ('Espresso', 'Coffee'),
    ('Latte', 'Coffee'),
    ('Croissant', 'Bakery');

INSERT INTO fact_coffee_sales_star (shop_id, product_id, sale_ts, quantity, amount) VALUES
    (1, 1, '2025-06-01 08:00:00', 2, 6.00),
    (1, 3, '2025-06-01 08:05:00', 1, 3.50),
    (2, 2, '2025-06-01 09:00:00', 1, 4.50);

-- Продажи по категориям - всего один JOIN
SELECT p.category, SUM(f.amount) AS total_amount
FROM fact_coffee_sales_star f
JOIN dim_product_star p ON p.id = f.product_id
GROUP BY p.category;

-- Снежинка
-- Категория вынесена в отдельную таблицу измерения - дальше нормализация.
CREATE TABLE dim_product_category (
    id SERIAL PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL
);


CREATE TABLE dim_product_snowflake (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    category_id INT NOT NULL REFERENCES dim_product_category (id)
);

CREATE TABLE fact_coffee_sales_snowflake (
    id SERIAL PRIMARY KEY,
    shop_id INT NOT NULL REFERENCES dim_shop (id),
    product_id INT NOT NULL REFERENCES dim_product_snowflake (id),
    sale_ts TIMESTAMP NOT NULL,
    quantity INT NOT NULL,
    amount DECIMAL(10, 2) NOT NULL
);

INSERT INTO dim_product_category (category_name) VALUES ('Coffee'), ('Bakery');

INSERT INTO dim_product_snowflake (name, category_id) VALUES
    ('Espresso', 1),
    ('Latte', 1),
    ('Croissant', 2);

INSERT INTO fact_coffee_sales_snowflake (shop_id, product_id, sale_ts, quantity, amount) VALUES
    (1, 1, '2025-06-01 08:00:00', 2, 6.00),
    (1, 3, '2025-06-01 08:05:00', 1, 3.50),
    (2, 2, '2025-06-01 09:00:00', 1, 4.50);

-- Тот же отчёт. Но теперь нужно два JOIN'а вместо одного, чтобы добраться до категории
SELECT c.category_name, SUM(f.amount) AS total_amount
FROM fact_coffee_sales_snowflake f
JOIN dim_product_snowflake p ON p.id = f.product_id
JOIN dim_product_category c ON c.id = p.category_id
GROUP BY c.category_name;

-- Небольшой вывод: результаты идентичны, но снежинка стоит
-- дополнительного JOIN'а на каждый отчёт.
-- Плюс снежинки - удобнее поддерживать нормализованный справочник категорий
--  (переименование категории -- одна строка, а не UPDATE по всем товарам).
--
-- Но для аналитики Kimball почти всегда рекомендует звезду - ради простоты и скорости запросов.
