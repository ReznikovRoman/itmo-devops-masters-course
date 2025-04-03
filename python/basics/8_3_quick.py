def quick_sort(array):
    """Быстрая сортировка (Quicksort).

    Сложность: в среднем O(n log n), в худшем случае O(n^2).
    Неустойчивый алгоритм.
    """
    if len(array) <= 1:
        return array
    pivot = array[len(array) // 2]  # Выбираем опорный элемент (середина)
    left = [x for x in array if x < pivot]
    middle = [x for x in array if x == pivot]
    right = [x for x in array if x > pivot]

    # Рекурсивная сортировка левой и правой частей
    return quick_sort(left) + middle + quick_sort(right)


data = [3, 6, 8, 10, 1, 2, 1]
sorted_data = quick_sort(data.copy())
print("Quick Sort:", sorted_data)



















"""
Как работает быстрая сортировка?

Выбор опорного элемента (pivot): Можно выбрать случайно, первый/последний, или брать медиану трёх.
Разбиение: Все элементы, меньшие pivot, отправляются в left, равные pivot — в middle, большие pivot — в right.
Рекурсия: Сортируем левую и правую части, а затем склеиваем результат: quick_sort(left) + middle + quick_sort(right).
Сложность: При удачном выборе pivot (равномерном) получаем O(n log n).
Если же pivot выбирается постоянно неудачно, (например, минимальный элемент), может быть O(n²).
"""
