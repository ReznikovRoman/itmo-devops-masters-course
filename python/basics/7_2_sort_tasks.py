def sort_1():
    logs_program1 = [
        {"timestamp": "2023-03-01 10:00:00", "source": "prog1", "message": "Start"},
        {"timestamp": "2023-03-01 10:05:00", "source": "prog1", "message": "Process"},
    ]

    logs_program2 = [
        {"timestamp": "2023-03-01 10:00:00", "source": "prog2", "message": "Init"},
        {"timestamp": "2023-03-01 10:07:00", "source": "prog2", "message": "Run"},
    ]

    # Объединяем логи
    combined_logs = [*logs_program1, *logs_program2]  # cl = [1, 2, 3, ,4]

    # Сортируем по времени. Если время совпадает, порядок логов сохранится.
    combined_logs_sorted = sorted(combined_logs, key=lambda log: log["timestamp"])

    print("Объединенные и отсортированные логи:")
    for log in combined_logs_sorted:
        print(log)


def main():
    sort_1()
    a = [1, 2, 3]
    print(*a)


if __name__ == '__main__':
    main()
