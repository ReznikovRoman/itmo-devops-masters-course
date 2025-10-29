CREATE TABLE IF NOT EXISTS students (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100), -- ?
    age INT, -- ?
    email VARCHAR(150) UNIQUE
);

ALTER TABLE students ADD COLUMN phone_number VARCHAR(15);

-- DROP TABLE IF EXISTS students;

-- INSERT
INSERT INTO students (name, age, email) VALUES ('Alice', 22, 'alice@example.com');
INSERT INTO students (name, age, email) VALUES ('Bob', 23, 'bob@example.com');

-- SELECT
SELECT * FROM students;
SELECT name, age FROM students WHERE age > 22;
SELECT COUNT(1) FROM students WHERE age > 22;
SELECT * FROM students WHERE email = 'bob@example.com';  -- Использование индекса для поиска по email

-- UPDATE
UPDATE students SET age = 23 WHERE name = 'Alice';
UPDATE students SET email = 'alice_new@example.com' WHERE name = 'Alice';

-- DELETE
-- DELETE FROM students WHERE name = 'Alice';
-- DELETE FROM students WHERE age < 20;


CREATE TABLE courses (
    id SERIAL PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS enrollments (
    student_id INT,
    course_id INT,
    enrollment_date DATE,
    -- ...
    PRIMARY KEY (course_id, student_id),
    CONSTRAINT fk_student FOREIGN KEY (student_id) REFERENCES students(id),
    CONSTRAINT fk_course FOREIGN KEY (course_id) REFERENCES courses(id)
);

-- Этот запрос использует INNER JOIN для объединения таблиц
-- students, courses и enrollments на основе связанных ключей
SELECT students.name, courses.course_name, enrollment_date
FROM enrollments
JOIN students ON enrollments.student_id = students.id
JOIN courses ON enrollments.course_id = courses.id;

-- Другие виды JOIN:

-- LEFT JOIN: возвращает все записи из левой таблицы
-- и соответствующие записи из правой таблицы.
-- Если совпадений нет, в правой таблице будут значения NULL.
-- Пример с LEFT JOIN:
SELECT students.name, courses.course_name
FROM students
LEFT JOIN enrollments ON students.id = enrollments.student_id
LEFT JOIN courses ON enrollments.course_id = courses.id;
-- Этот запрос вернет всех студентов, даже если они не записаны ни на один курс.

-- RIGHT JOIN: возвращает все записи из правой таблицы
-- и соответствующие записи из левой таблицы.
-- Пример с RIGHT JOIN:
SELECT courses.course_name, students.name
FROM courses
RIGHT JOIN enrollments ON courses.id = enrollments.course_id
RIGHT JOIN students ON enrollments.student_id = students.id;
-- Этот запрос вернет все курсы, даже если на них никто не записан.

-- FULL JOIN: возвращает все записи, когда есть совпадения в одной из таблиц.
-- Пример с FULL JOIN:
SELECT students.name, courses.course_name
FROM students
FULL JOIN enrollments ON students.id = enrollments.student_id
FULL JOIN courses ON enrollments.course_id = courses.id;
-- Этот запрос вернет всех студентов и все курсы,
-- включая те, которые не имеют соответствующих записей.


-- Более сложные запросы и агрегатные функции
-- Для анализа данных часто используются агрегатные функции,
-- такие как SUM, AVG, MAX, MIN, и COUNT.
-- Примеры:
-- COUNT — подсчет количества записей в таблице:
SELECT COUNT(*) FROM students;
SELECT COUNT(*) FROM enrollments WHERE course_id = 1;

-- AVG — вычисление среднего значения:
SELECT AVG(age) FROM students;

-- SUM — сумма значений:
SELECT SUM(age) FROM students;

-- GROUP BY — группировка данных для применения агрегатных функций:
SELECT course_id, COUNT(student_id) FROM enrollments GROUP BY course_id;
-- Этот запрос вернет количество студентов, записанных на каждый курс.

-- HAVING — фильтрация групп после группировки:
SELECT
    e.course_id, COUNT(student_id)
FROM enrollments e
JOIN courses c on e.course_id = c.id
GROUP BY course_id
HAVING COUNT(student_id) > 1;
-- Этот запрос вернет только те курсы, на которые записано более 5 студентов.
