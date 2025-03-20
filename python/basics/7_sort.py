numbers = [5, 2, 9, 1, 5, 6]
sorted_numbers = sorted(numbers)
print(sorted_numbers)
print(numbers)
print(numbers == sorted_numbers)

# Сортировка строк по длине
words = ["apple", "banana", "kiwi", "cherry"]
sorted_words = sorted(words, key=len)
print(sorted_words)

# Обратная сортировка
sorted_numbers_desc = sorted(numbers, reverse=True)
print(sorted_numbers_desc)  # [9, 6, 5, 5, 2, 1]

numbers = [5, 2, 9, 1, 5, 6]
numbers.sort()  # сортирует список in-place
print(numbers)

# Обратная сортировка по ключу
words = ["apple", "banana", "kiwi", "cherry"]
words.sort(key=len, reverse=True)
print(words)
