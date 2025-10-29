-- Типы партиционирования в PostgreSQL:
--
-- Диапазон (Range Partitioning):
-- Данные разбиваются по диапазонам значений, например, по датам.
-- Например, таблица с заказами может быть разделена на месячные или годовые разделы.

-- Список (List Partitioning):
-- Данные разбиваются по списку значений
-- Например, по географическим регионам или категориям.

-- Хэш (Hash Partitioning):
-- Данные распределяются на основе хеш-функции, что помогает равномерно распределить нагрузку.
-- Используется, когда сложно определить логический критерий для партиционирования.


-- Допустим, у нас есть таблица заказов, и мы хотим партиционировать её по годам.
CREATE TABLE orders (
    order_id SERIAL,
    order_date DATE,
    customer_id INT,
    amount DECIMAL,
    PRIMARY KEY (order_id, order_date)
) PARTITION BY rANGE (order_date);

-- Создаем партиции для разных лет
CREATE TABLE orders_2023 PARTITION OF orders FOR VALUES FROM ('2023-01-01') TO ('2024-01-01');
CREATE TABLE orders_2024 PARTITION OF orders FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');
CREATE TABLE orders_2025 PARTITION OF orders FOR VALUES FROM ('2025-01-01') TO ('2026-01-01');

-- При добавлении записей в таблицу orders PostgreSQL будет автоматически распределять их
-- по партициям в зависимости от даты заказа.

-- Запросы, ориентированные на конкретные диапазоны дат, также будут быстрее,
-- так как PostgreSQL будет работать только с нужной партицией
select * from orders
where order_date >= '2023-01-01' and order_date < '2023-06-01';
