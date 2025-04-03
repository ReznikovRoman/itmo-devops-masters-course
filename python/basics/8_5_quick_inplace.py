def quick_sort_in_place(array, low, high):
    """Быстрая сортировка in-place.

    Сортирует список array в диапазоне от индекса low до high.
    """
    if low < high:
        pivot_index = partition(array, low, high)
        quick_sort_in_place(array, low, pivot_index - 1)
        quick_sort_in_place(array, pivot_index + 1, high)


def partition(array, low, high):
    """Функция разделения.

    Выбирает последний элемент в качестве опорного (pivot).
    Все элементы, меньше или равные pivot, перемещает влево.
    Возвращает индекс опорного элемента после разделения.
    """
    pivot = array[high]
    i = low - 1  # индекс последнего элемента, меньшего или равного pivot
    for j in range(low, high):
        if array[j] <= pivot:
            i += 1
            array[i], array[j] = array[j], array[i]  # обмен элементов
    # Перемещаем опорный элемент на своё место
    array[i + 1], array[high] = array[high], array[i + 1]
    return i + 1


data = [3, 6, 8, 10, 1, 2, 1]
quick_sort_in_place(data, 0, len(data) - 1)
print("Quick Sort (in-place):", data)




























"""
Функция quick_sort_in_place:
Проверяет условие if low < high: сортировка продолжается, пока в рассматриваемом подмассиве есть хотя бы два элемента.
Вызывает функцию partition, которая возвращает индекс опорного элемента после разбиения.
Рекурсивно вызывает себя для левой части (от low до pivot_index - 1) и правой части (от pivot_index + 1 до high).

Функция partition:
Выбирает последний элемент в диапазоне как опорный (pivot).
Использует переменную i для отслеживания места, до которого все элементы меньше или равны pivot.
Перебирает все элементы от low до high - 1.
Если текущий элемент array[j] меньше или равен опорному, увеличивает i и меняет местами array[i] и array[j].
После цикла меняет местами array[i+1] и array[high], помещая опорный элемент на его корректную позицию.
Возвращает индекс опорного элемента.
"""
