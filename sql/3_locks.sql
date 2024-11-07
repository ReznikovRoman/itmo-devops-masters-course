-- Транзакции
BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;

SELECT * FROM students; -- SQL запросы

COMMIT;

-- У нас есть таблица accounts,
-- в которой хранится информация о балансе счетов пользователей
CREATE TABLE IF NOT EXISTS accounts (
    account_id SERIAL PRIMARY KEY,
    account_holder VARCHAR(100),
    balance DECIMAL(15, 2) DEFAULT 0.00
);
-- Теперь, если одновременно два процесса попытаются обновить
-- баланс одного и того же счета, это может привести к неконсистентности данных.
-- Чтобы избежать этого, мы используем блокировки
-- для последовательного выполнения операций.
