import psycopg2

x = "dghfhsfdghfhsfdghfhsfdghfhsfdghfhsfdghfhsfdghfhsfdghfhsfdghfhsfdghfhsfdghfhsfdghfhsfdghfhsfdghfhsfdghfhsfdghfhsfdghfhsfdghfhsfdghfhsfdghfhsfdghfhsfdghfhsf"

def ABC():
    return 2 / 0


def main():
    connection = psycopg2.connect(
        dbname="postgres",
        user="roman",
        host="localhost",
        port="5432",
    )

    cursor = connection.cursor()
    cursor.execute("SELECT * FROM _example order by email;")
    rows = cursor.fetchall()
    for row in rows:
        print(row)

    cursor.close()
    connection.close()


if __name__ == '__main__':
    main()
