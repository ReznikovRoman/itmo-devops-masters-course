def outer(n: int):
    def inner(k: int):
        if k == 0:
            print("Достигли базового случая!")
            return
        print(f"Вызов inner({k}) из outer({n})")
        inner(k - 1)
        print(f"Возвращаемся в inner({k}) из outer({n})")
    inner(n)


outer(3)


# 1. Как работает стек вызовов?
# 2. Почему inner() вызывается внутри outer()?
# 3. Как происходит возврат?




"""
1. outer(n) — внешняя функция, которая определяет внутреннюю функцию inner(k).
2. inner(k) — рекурсивная функция, которая:
    - Выводит сообщение перед рекурсивным вызовом.
    - Вызывает саму себя с k - 1.
    - Выводит сообщение после возврата из рекурсии.
3. inner(n) вызывается внутри outer(n), запуская рекурсию.
"""



