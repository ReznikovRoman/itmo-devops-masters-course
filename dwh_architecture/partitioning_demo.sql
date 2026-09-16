-- Партиционирование: декларативное range-партиционирование по дате

CREATE TABLE fact_events (
    id SERIAL,
    event_date DATE NOT NULL,
    payload TEXT,
    PRIMARY KEY (id, event_date) -- ключ партиционирования обязан входить в PK
) PARTITION BY RANGE (event_date);

-- Каждый месяц - своя физическая партиция
CREATE TABLE fact_events_2025_05 PARTITION OF fact_events
    FOR VALUES FROM ('2025-05-01') TO ('2025-06-01');

CREATE TABLE fact_events_2025_06 PARTITION OF fact_events
    FOR VALUES FROM ('2025-06-01') TO ('2025-07-01');

INSERT INTO fact_events (event_date, payload) VALUES
    ('2025-05-15', 'may event'),
    ('2025-06-10', 'june event');

-- Postgres сам направит запрос только в нужную партицию (partition pruning)
EXPLAIN SELECT * FROM fact_events WHERE event_date = '2025-06-10';
