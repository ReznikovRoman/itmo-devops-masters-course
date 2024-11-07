# Материалы по курсу магистратуры DevOps

1. Введение в базы данных
   - [Теория](https://piquant-leech-9ea.notion.site/1-119861e0489f80a18632cf4f1d450691?pvs=4)
   - [Примеры на Python](./python)
   - [Примеры на SQL](./sql)
2. Использование БД в Python
   - [Теория](https://piquant-leech-9ea.notion.site/2-127861e0489f8086849eed126f46d5b2?pvs=4)
   - [Код](./sqlalchemy)
3. Продвинутая эксплуатация PostgreSQL
   - [Теория](https://piquant-leech-9ea.notion.site/3-137861e0489f806d81f6dc600011755d?pvs=4)
   - [Примеры](./advanced_usage)

## Темы на уроках
1. Самое базовое про базы данных на примере postgresql:
   - минимальная установка
   - общение через консольные запросы
   - подключение из python'а (базовый драйвер psycopg2 и SQLAlchemy)
   - основные типы запросов: DDL / DML (CREATE TABLE * / INSERT / SELECT / DELETE / UPDATE)
   - транзакции и блокировки
2. Польза от баз данных:
   - ORM и как они помогают на примере SQLAlchemy
   - нетривиальные вещи в БД: ключи, индексы, таблицы связки
   - сложные запросы: GROUP BY / HAVING, аналитические запросы
   - OLTP vs OLAP, пределы применимость pgsql
   - работа с JSON в postgreSql

3. Эксплуатация баз данных на примере pgsql
   - бекапы и восстановление. pgdump / pgrestore
   - репликация - master-slave, паттерн "пишем в мастер - читаем из реплик"
   - шардирование: на стороне приложений, обзор сторонних решений
   - CAP-теорема и обзор альтернативных "БД": mysql / mongodb / cassandra / clickhouse / redis
