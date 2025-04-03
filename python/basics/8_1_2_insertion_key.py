def insertion_sort_by_key(array, key_func):
    """Сортировка вставками с использованием функции key_func.

    Сортирует список 'array' in-place по значению, возвращаемому key_func.
    Алгоритм является устойчивым, т.е сохраняется относительный порядок равных элементов.
    """
    # Проходим по всем элементам, начиная со второго
    for i in range(1, len(array)):
        current_item = array[i]
        current_key = key_func(current_item)
        j = i - 1

        # Сдвигаем элементы, у которых ключ больше, чем current_key, вправо
        while j >= 0 and key_func(array[j]) > current_key:
            array[j + 1] = array[j]
            j -= 1

        # Вставляем current_item на своё место
        array[j + 1] = current_item







def main():
    students = [
        {"name": "Иван", "score": 85},
        {"name": "Пётр", "score": 92},
        {"name": "Анна", "score": 85},
        {"name": "Мария", "score": 78},
        {"name": "Сергей", "score": 92},
    ]

    insertion_sort_by_key(students, key_func=lambda _student: _student["score"])

    print("Отсортированный список студентов:")
    for student in students:
        print(student)


if __name__ == '__main__':
    main()
