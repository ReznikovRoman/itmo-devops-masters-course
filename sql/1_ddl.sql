-- DDL (Data Definition Language) — запросы, изменяющие структуру базы данных.
-- Эти запросы используются для создания, изменения и удаления таблиц
-- и других объектов базы данных

CREATE TABLE IF NOT EXISTS _example (
    id SERIAL primary key,
    name VARCHAR(255),
    age INT
);

ALTER TABLE _example ADD COLUMN IF NOT EXISTS email VARCHAR(255) NOT NULL default '';

ALTER TABLE _example ADD COLUMN IF NOT EXISTS _temp VARCHAR(10);
ALTER TABLE _example ALTER COLUMN _temp TYPE VARCHAR(200);

ALTER TABLE _example ALTER COLUMN _temp SET NOT NULL;
ALTER TABLE _example DROP COLUMN IF EXISTS _temp;

-- DROP TABLE _example;

-- DROP schema public CASCADE ;
-- CREATE schema public;
-- GRANT ALL ON SCHEMA public TO roman ;
-- GRANT ALL ON SCHEMA public TO public ;

-- DML (Data Manipulation Language) — запросы, управляющие данными в существующих таблицах.
-- DML-запросы включают добавление, изменение, удаление и выборку данных

INSERT INTO _example (name, age) VALUES ('Alice', 25);
INSERT INTO _example (name, age, email) VALUES ('Alex', 22, 'alex@gmail.com');

SELECT * FROM _example;

UPDATE _example SET age = 26, email='alice@gmail.com' where name = 'Alice';

SELECT
    e.id, e.name, e.email
FROM _example e
WHERE age > 23;

SELECT * FROM _example WHERE name ilike 'a%';

DELETE FROM _example WHERE email = 'alice@gmail.com';
