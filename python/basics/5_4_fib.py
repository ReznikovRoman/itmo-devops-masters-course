def fibonacci_recursive(n: int) -> int:
    """Рекурсивное вычисление чисел Фибоначчи."""
    if n <= 1:
        return n
    return fibonacci_recursive(n - 1) + fibonacci_recursive(n - 2)


# print(fibonacci_recursive(6))  # 8
print(fibonacci_recursive(50))


def fibonacci_iterative(n: int) -> int:
    """Итеративное вычисление чисел Фибоначчи."""
    if n <= 1:
        return n
    a, b = 0, 1
    for _ in range(n - 1):
        a, b = b, a + b
    return b


print(fibonacci_iterative(6))  # 8
print(fibonacci_iterative(50))
