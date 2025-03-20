def countdown(n: int) -> None:
    if n == 0:
        print("Boom!")  # Базовый случай
        return
    print(n)  # Действие перед рекурсией
    countdown(n - 1)  # Рекурсивный вызов
    print(f"Возвращаемся из countdown({n})")  # Действие после рекурсии


countdown(3)
