def build_matryoshka(size: int, n: int) -> None:
    """Рекурсивно создаёт матрёшку с указанным количеством вложенных фигур."""
    if n >= 1:
        print(f"Создаём низ матрёшки размера {size}.")
        build_matryoshka(size - 1, n - 1)
        print(f"Создаём верх матрёшки размера {size}.")
    else:
        return

# Создадим матрёшку размера 4, внутри которой будет ещё 2 матрёшки (итого 3).
# build_matryoshka(4, 3)


def disassemble_matryoshka(size: int) -> None:
    """Разбираем матрешку рекурсивно."""
    if size == 1:
        print("Открыта последняя, самая маленькая матрешка!")
        return
    print(f"Открываем матрешку размером {size}")
    disassemble_matryoshka(size - 1)
    print(f"Закрываем матрешку размером {size}")


disassemble_matryoshka(10)
