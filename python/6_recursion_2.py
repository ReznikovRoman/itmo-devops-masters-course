import inspect


def recursive_function(n: int):
    if n == 0:
        print("Достигнут базовый случай")
        return

    stack = inspect.stack()  # Получаем текущий стек вызовов
    print(f"Вызов recursive_function({n}) | Глубина стека: {len(stack)}")

    recursive_function(n - 1)  # Рекурсивный вызов

    print(f"Выход из recursive_function({n})")


def recursive_inspect(n: int):
    if n == 0:
        print("Достигнут базовый случай")
        return

    frame = inspect.stack()[1]  # Получаем информацию о предыдущем вызове
    print(f"Функция: {frame.function} | Файл: {frame.filename} | Строка: {frame.lineno}")
    if n > 1:
        recursive_inspect(n - 1)
    elif n % 15:
        recursive_inspect(n + 15)


def factorial_recursive(n: int) -> int:
    if n == 0:
        return 1
    return n * factorial_recursive(n - 1)


def factorial_iterative(n: int) -> int:
    result = 1
    for i in range(1, n + 1):
        result *= i
    return result


def main():
    print(factorial_iterative(3))

    # recursive_function(5)

    # recursive_inspect(3)


if __name__ == '__main__':
    main()
