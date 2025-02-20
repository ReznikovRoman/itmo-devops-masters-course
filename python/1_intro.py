import psycopg2


def main():
    connection = psycopg2.connect(
        dbname="postgres",
        user="roman",
        host="localhost",
        port="5432",
    )

    cursor = connection.cursor()
    cursor.execute("SELECT * FROM _example;")
    rows = cursor.fetchall()
    for row in rows:
        print(row)

    cursor.close()
    connection.close()



def disassemble_matryoshka(size: int) -> None:
    """Разбираем матрешку рекурсивно."""
    if size == 1:
        print("Открыта последняя, самая маленькая матрешка!")
        return
    print(f"Открываем матрешку размером {size}")
    disassemble_matryoshka(size - 1)
    print(f"Закрываем матрешку размером {size}")


# disassemble_matryoshka(4)

if __name__ == '__main__':
    main()
