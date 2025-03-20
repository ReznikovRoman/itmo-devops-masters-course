def disassemble_matryoshka_no_base_case(size: int) -> None:
    # Нет базового случая с остановкой?
    print(f"Открываем матрёшку размером {size}")
    disassemble_matryoshka_no_base_case(size - 1)
    print(f"Закрываем матрёшку размером {size}")


# disassemble_matryoshka_no_base_case(5)


def disassemble_matryoshka_no_change(size: int) -> None:
    # Нет изменения аргумента?
    if size == 1:
        print("Открыта последняя, самая маленькая матрешка!")
        return
    print(f"Открываем матрёшку размером {size}")
    disassemble_matryoshka_no_change(size)
    print(f"Закрываем матрёшку размером {size}")


disassemble_matryoshka_no_change(5)
