from collections import namedtuple
from typing import NamedTuple

Country = namedtuple("Country", ["name"])
russia = Country("Russia")
usa = Country("USA")
Car = namedtuple("Car", ["brand", "year"])
car = Car(brand="Mazda", year=2020)

print(car.brand)  # Mazda
print(car.year)   # 2020


class Person(NamedTuple):
    name: str
    age: int


person = Person(name="Alice", age=30)

print(person.name)  # Alice
print(person.age)   # 30


import inspect


def example():
    frame_info = inspect.stack()[0]  # Получаем текущий кадр стека
    print(f"Функция: {frame_info.function}")
    print(f"Файл: {frame_info.filename}")
    print(f"Строка: {frame_info.lineno}")
    print(f"Code: {frame_info.code_context}")


example()
