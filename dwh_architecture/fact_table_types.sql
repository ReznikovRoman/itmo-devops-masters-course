-- Три типа таблиц фактов -- один и тот же бизнес-процесс
-- (заказы в кофейне), показанный на разной грануляции.

-- 1. Транзакционный факт
-- Одна строка = одно событие (позиция в заказе). Самая мелкая грануляция,
-- максимум гибкости для будущих признаков, но и максимум строк.
CREATE TABLE fact_order_line (
    id SERIAL PRIMARY KEY,
    order_id INT NOT NULL,
    shop_id INT NOT NULL,
    product_id INT NOT NULL,
    order_ts TIMESTAMP NOT NULL,
    quantity INT NOT NULL,
    amount DECIMAL(10, 2) NOT NULL
);

INSERT INTO fact_order_line (order_id, shop_id, product_id, order_ts, quantity, amount) VALUES
    (1001, 1, 10, '2025-06-01 08:15:00', 1, 4.50),
    (1001, 1, 20, '2025-06-01 08:15:00', 2, 7.00),
    (1002, 1, 10, '2025-06-01 09:02:00', 1, 4.50),
    (1003, 2, 30, '2025-06-01 09:30:00', 1, 6.00);

-- "сколько единиц товара X продано в заказе Y".
SELECT * FROM fact_order_line ORDER BY order_ts;

-- 2. Периодический снапшот
-- Одна строка = состояние сущности на конец периода (например, остаток на складе каждый день)
CREATE TABLE fact_inventory_daily (
    snapshot_date DATE NOT NULL,
    shop_id INT NOT NULL,
    product_id INT NOT NULL,
    stock_level INT NOT NULL,
    PRIMARY KEY (snapshot_date, shop_id, product_id)
);

INSERT INTO fact_inventory_daily (snapshot_date, shop_id, product_id, stock_level) VALUES
    ('2025-06-01', 1, 10, 42),
    ('2025-06-01', 1, 20, 15),
    ('2025-06-02', 1, 10, 40),
    ('2025-06-02', 1, 20, 15); -- на следующий день снова строка, даже если ничего не продали

-- Легко построить динамику остатков во времени
SELECT snapshot_date, product_id, stock_level
FROM fact_inventory_daily
WHERE shop_id = 1
ORDER BY product_id, snapshot_date;

-- 3. Накопительный снапшот
-- Одна строка = один экземпляр процесса (например, один заказ), которая обновляется по мере прохождения этапов.
-- Удобно для воронки конверсии перед построением модели (например, "предсказать, дойдёт ли заказ до выдачи").
CREATE TABLE fact_order_funnel (
    order_id INT PRIMARY KEY,
    shop_id INT NOT NULL,
    created_at TIMESTAMP NOT NULL,
    paid_at TIMESTAMP,
    ready_at TIMESTAMP,
    picked_up_at TIMESTAMP
);

INSERT INTO fact_order_funnel (order_id, shop_id, created_at, paid_at, ready_at, picked_up_at) VALUES
    (1001, 1, '2025-06-01 08:15:00', '2025-06-01 08:15:30', '2025-06-01 08:19:00', '2025-06-01 08:20:00'),
    (1002, 1, '2025-06-01 09:02:00', '2025-06-01 09:02:20', '2025-06-01 09:06:00', NULL), -- ещё не забрали
    (1003, 2, '2025-06-01 09:30:00', NULL, NULL, NULL); -- даже не оплачен -- отвалился на первом шаге

-- Вместо трёх JOIN'ов между "событиями оплаты/готовности/выдачи" - один SELECT.
-- сразу показывает, на каком этапе воронки застрял каждый заказ.
SELECT
    order_id,
    shop_id,
    CASE
        WHEN picked_up_at IS NOT NULL THEN 'picked_up'
        WHEN ready_at IS NOT NULL THEN 'ready_not_picked_up'
        WHEN paid_at IS NOT NULL THEN 'paid_not_ready'
        ELSE 'created_not_paid'
    END AS funnel_stage,
    EXTRACT(EPOCH FROM (paid_at - created_at)) AS seconds_to_pay
FROM fact_order_funnel
ORDER BY order_id;
