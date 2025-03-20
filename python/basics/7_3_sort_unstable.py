data = [
    {"key": 3, "value": "a"},  # исходный порядок: "a" идёт раньше "c"
    {"key": 1, "value": "b"},
    {"key": 3, "value": "c"},
    {"key": 2, "value": "d"}
]


def unstable_selection_sort(arr, key):
    a = arr.copy()  # работаем с копией, чтобы не изменять исходный список
    n = len(a)
    for i in range(n):
        min_index = i
        for j in range(i+1, n):
            if a[j][key] < a[min_index][key]:
                min_index = j
        # Меняем местами текущий элемент с минимальным найденным
        a[i], a[min_index] = a[min_index], a[i]
    return a


unstable_sorted = unstable_selection_sort(data, "key")
print("\nНеустойчивая сортировка:")
for item in unstable_sorted:
    print(item)


stable_sorted = sorted(data, key=lambda x: x["key"])
print("\nСтабильная сортировка:")
for item in stable_sorted:
    print(item)

