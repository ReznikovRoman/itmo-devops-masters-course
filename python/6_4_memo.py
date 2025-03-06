def fibonacci_memoized(n: int, cache: dict = None) -> int:
    """Фибоначчи с мемоизацией через словарь."""
    if cache is None:
        cache = {}

    if n in cache:
        return cache[n]  # Если уже вычислили, берем из кэша

    if n <= 1:
        return n
    value = fibonacci_memoized(n - 1, cache) + fibonacci_memoized(n - 2, cache)
    cache[n] = value

    return cache[n]


print(fibonacci_memoized(50))  # 12586269025
