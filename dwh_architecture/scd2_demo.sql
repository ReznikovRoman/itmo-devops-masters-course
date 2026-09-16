-- SCD Type 2

CREATE TABLE dim_customer_scd2 (
    surrogate_key SERIAL PRIMARY KEY,  -- технический ключ DWH, никогда не меняется и не переиспользуется
    natural_key INT NOT NULL,  -- бизнес-ключ (customer_id в исходной системе)
    full_name VARCHAR(100) NOT NULL,
    income_bracket VARCHAR(20) NOT NULL,  -- атрибут, историю которого отслеживаем: 'low' / 'medium' / 'high'
    city VARCHAR(50) NOT NULL,
    valid_from DATE NOT NULL,
    valid_to DATE,
    is_current BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE UNIQUE INDEX ON dim_customer_scd2 (natural_key) WHERE is_current;

-- ~Начальное состояние
INSERT INTO dim_customer_scd2 (natural_key, full_name, income_bracket, city, valid_from, valid_to, is_current) VALUES
    (1, 'Alice Smith', 'low',    'Montreal', '2024-01-01', NULL, TRUE),
    (2, 'Bob Johnson',  'medium', 'Toronto',  '2024-02-01', NULL, TRUE);

-- Событие изменения 1: у Alice (natural_key=1) вырос доход 2024-07-15
-- 1. закрываем текущую версию строки
UPDATE dim_customer_scd2
SET valid_to = DATE '2024-07-15' - INTERVAL '1 day',
    is_current = FALSE
WHERE natural_key = 1 AND is_current;

-- 2. вставляем новую текущую версию
INSERT INTO dim_customer_scd2 (natural_key, full_name, income_bracket, city, valid_from, valid_to, is_current)
VALUES (1, 'Alice Smith', 'medium', 'Montreal', '2024-07-15', NULL, TRUE);

-- Событие изменения 2: у Alice снова вырос доход 2025-03-01
UPDATE dim_customer_scd2
SET valid_to = DATE '2025-03-01' - INTERVAL '1 day',
    is_current = FALSE
WHERE natural_key = 1 AND is_current;

INSERT INTO dim_customer_scd2 (natural_key, full_name, income_bracket, city, valid_from, valid_to, is_current)
VALUES (1, 'Alice Smith', 'high', 'Montreal', '2025-03-01', NULL, TRUE);

-- Событие изменения 3: Bob (natural_key=2) переехал и стал зарабатывать больше, 2025-01-10
UPDATE dim_customer_scd2
SET valid_to = DATE '2025-01-10' - INTERVAL '1 day',
    is_current = FALSE
WHERE natural_key = 2 AND is_current;

INSERT INTO dim_customer_scd2 (natural_key, full_name, income_bracket, city, valid_from, valid_to, is_current)
VALUES (2, 'Bob Johnson', 'high', 'Vancouver', '2025-01-10', NULL, TRUE);

-- Полная история -- видно 5 строк на двух клиентов
SELECT surrogate_key, natural_key, full_name, income_bracket, city, valid_from, valid_to, is_current
FROM dim_customer_scd2
ORDER BY natural_key, valid_from;

-- "состояние на дату X" (point-in-time)
-- "Какой income_bracket был у Alice на 2024-09-01?"
SELECT natural_key, income_bracket, city
FROM dim_customer_scd2
WHERE natural_key = 1
  AND valid_from <= DATE '2024-09-01'
  AND (valid_to IS NULL OR valid_to >= DATE '2024-09-01');

-- Пример data leakage для скоринговой модели
-- Заявки на кредит: для каждой заявки скоринг должен использовать доход клиента НА момент подачи, а не текущий доход.
CREATE TABLE fact_loan_applications (
    application_id SERIAL PRIMARY KEY,
    customer_natural_key INT NOT NULL,
    application_date DATE NOT NULL,
    approved BOOLEAN NOT NULL
);

INSERT INTO fact_loan_applications (customer_natural_key, application_date, approved) VALUES
    (1, '2024-05-01', FALSE), -- на эту дату у Alice ещё 'low' -> отказали
    (1, '2025-06-01', TRUE);  -- на эту дату у Alice уже 'high' -> одобрили

-- неверно: джойним по is_current -- подставляем текущий доход всем заявкам,
-- включая те, что были поданы год назад -> data leakage
SELECT
    a.application_id,
    a.customer_natural_key,
    a.application_date,
    a.approved,
    d.income_bracket AS income_used_wrong
FROM fact_loan_applications a
JOIN dim_customer_scd2 d
    ON d.natural_key = a.customer_natural_key
    AND d.is_current;

-- правильно: джойним по диапазону valid_from/valid_to на дату заявки
-- получаем доход клиента таким, каким он был в момент принятия решения.
SELECT
    a.application_id,
    a.customer_natural_key,
    a.application_date,
    a.approved,
    d.income_bracket AS income_at_application_time
FROM fact_loan_applications a
JOIN dim_customer_scd2 d
    ON d.natural_key = a.customer_natural_key
    AND a.application_date >= d.valid_from
    AND (d.valid_to IS NULL OR a.application_date <= d.valid_to);
