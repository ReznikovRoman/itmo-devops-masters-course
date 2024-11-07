from decimal import Decimal
from typing import ContextManager

import psycopg2
from contextlib import contextmanager

from psycopg2.extras import execute_values


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


def create_accounts():
    with get_db_connection() as connection, get_db_cursor(connection) as cursor:
        cursor.execute("SELECT COUNT(*) FROM accounts")
        count = cursor.fetchone()[0]
        if count == 0:
            execute_values(
                cursor,
                "INSERT INTO accounts (account_holder, balance) VALUES %s",
                [("Roman", 1000), ("Jake", 30)],
            )


def main():
    create_accounts()
    account_holder = "Roman"
    amount_to_withdraw = Decimal("50.0")
    with get_db_connection() as connection, get_db_cursor(connection) as cursor:
        # Блокируем запись для предотвращения одновременного изменения
        # другими транзакциями
        cursor.execute(
            """
            SELECT balance
            FROM accounts WHERE account_holder = %s
            FOR UPDATE;
            """,
            (account_holder,)
        )
        current_balance = cursor.fetchone()[0]

        # Проверяем, достаточно ли средств для снятия
        if current_balance >= amount_to_withdraw:
            new_balance = current_balance - amount_to_withdraw
            cursor.execute(
                "UPDATE accounts SET balance = %s WHERE account_holder = %s;",
                (new_balance, account_holder),
            )
            print(f"Снято {amount_to_withdraw}. Новый баланс: {new_balance}")
        else:
            print("Недостаточно средств на счете.")


if __name__ == "__main__":
    main()
