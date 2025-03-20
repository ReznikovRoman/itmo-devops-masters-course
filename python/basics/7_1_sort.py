"""
**Объяснение:**

- Первая сортировка упорядочивает животных по возрасту.
- Вторая сортировка по виду сохраняет порядок по возрасту среди животных одного вида благодаря устойчивости сортировки.
"""


def sort_1():
    # Сначала отсортируем список по возрасту,
    # затем – по виду, чтобы сохранить порядок по возрасту для животных одного вида.
    animals = [
        {"species": "лев", "age": 5},
        {"species": "тигр", "age": 3},
        {"species": "лев", "age": 2},
        {"species": "зебра", "age": 4},
        {"species": "тигр", "age": 6},
        {"species": "зебра", "age": 2},
    ]

    # Сначала сортируем по возрасту (устойчивая сортировка)
    animals_sorted_by_age = sorted(animals, key=lambda x: x["age"], reverse=True)
    print("Отсортировано по возрасту:")
    for animal in animals_sorted_by_age:
        print(animal)

    print("\n")

    # Затем сортируем по виду. Благодаря устойчивости, животные с одинаковым видом сохранят порядок по возрасту.
    animals_sorted = sorted(animals_sorted_by_age, key=lambda x: x["species"])
    print("Отсортировано по виду (с сохранением возраста):")
    for animal in animals_sorted:
        print(animal)


def sort_2():
    animals = [
        {"species": "лев", "age": 5},
        {"species": "тигр", "age": 3},
        {"species": "лев", "age": 2},
        {"species": "зебра", "age": 4},
        {"species": "тигр", "age": 6},
        {"species": "зебра", "age": 2},
    ]
    # Сортируем сразу по возрасту и виду
    animals_sorted = sorted(animals, key=lambda x: (x["species"], x["age"]), reverse=True)
    print("Отсортировано по виду (с сохранением возраста):")
    for animal in animals_sorted:
        print(animal)


def main():
    sort_1()
    sort_2()


if __name__ == '__main__':
    main()
