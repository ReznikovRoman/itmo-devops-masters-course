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
    finally:
        connection.close()


@contextmanager
def get_db_cursor(connection: psycopg2.extensions.connection) -> ContextManager[psycopg2.extensions.cursor]:
    cursor = connection.cursor()
    try:
        yield cursor
    finally:
        cursor.close()


def main():
    with get_db_connection() as connection, get_db_cursor(connection) as cursor:
        cursor.execute("SELECT * FROM _example;")
        rows = cursor.fetchall()
        for row in rows:
            print(row)


if __name__ == '__main__':
    main()
