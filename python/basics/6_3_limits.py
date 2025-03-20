import sys
sys.setrecursionlimit(5000)  # Позволяет выполнять более глубокие рекурсии

def deep_recursion(n: int):
    if n == 0:
        print("Достигнут базовый случай!")
        return
    deep_recursion(n - 1)

deep_recursion(4000)  # Теперь сработает без ошибки
