from typing import ContextManager

import psycopg2
from contextlib import contextmanager


@contextmanager
def get_db_connection() -> ContextManager[psycopg2.extensions.connection]:
    connection = psycopg2.connect(
        dbname="postgres",
        user="roman",
        host="localhost",
        port="5432",
    )
    try:
        yield connection
        connection.commit()
    except Exception as exc:
        connection.rollback()
        print(exc)
    finally:
        connection.close()


@contextmanager
def get_db_cursor(connection: psycopg2.extensions.connection) -> ContextManager[psycopg2.extensions.cursor]:
    cursor = connection.cursor()
    try:
        yield cursor
    finally:
        cursor.close()


def insert_ryan():
    with get_db_connection() as connection, get_db_cursor(connection) as cursor:
        cursor.execute(
            query="""
            INSERT INTO students (name, age, email)
            VALUES (%s, %s, %s)
            """,
            vars=("Ryan", 31, "ryan@gmail.com"),
        )
        raise ValueError("Error!")


def main():
    with get_db_connection() as connection, get_db_cursor(connection) as cursor:
        cursor.execute("SELECT id, name, age FROM students ORDER BY id;")
        rows = cursor.fetchall()
        for row in rows:
            _id, name, age = row
            print(_id, name, age)

        insert_ryan()

        cursor.execute("SELECT id, name, age FROM students ORDER BY id DESC;")
        last_student = cursor.fetchone()
        print(last_student)


if __name__ == '__main__':
    main()
