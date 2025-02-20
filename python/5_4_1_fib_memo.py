from functools import lru_cache


@lru_cache(maxsize=None)
def fibonacci_memoized(n: int) -> int:
    """Рекурсивное вычисление чисел Фибоначчи с мемоизацией."""
    if n <= 1:
        return n
    return fibonacci_memoized(n - 1) + fibonacci_memoized(n - 2)


print(fibonacci_memoized(50))  # 12586269025
