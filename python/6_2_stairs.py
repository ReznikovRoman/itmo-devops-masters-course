import sys

sys.setrecursionlimit(5000)

def stairs_builder(n: int):
    """Рекурсивное построение лестницы из n ступеней."""
    if n == 0:
        return
    stairs_builder(n - 1)  # Сначала строим нижние ступени
    print(f"Построена ступень {n}")

stairs_builder(6000)
