"""
У вас есть родословное дерево, представленное в виде объекта, где каждый узел имеет имя и ссылки на детей.
Ваша задача – вывести дерево в виде списка имен в pre-order обходе (сначала корень, затем рекурсивно дети).
"""


class Person:
    def __init__(self, name):
        self.name = name
        self.children = []


def pre_order_traversal(node):
    """Pre-order обход родословного дерева.

    Сначала обрабатываем текущий узел, затем рекурсивно всех детей.
    """
    if node is None:
        return
    print(node.name, end=" ")
    for child in node.children:
        pre_order_traversal(child)


# Пример родословного дерева
# Корень: "Прадед"
root = Person("Прадед")
child1 = Person("Дед")
child2 = Person("Тётя")
root.children.append(child1)
root.children.append(child2)
child1.children.append(Person("Отец"))
child1.children.append(Person("Дядя"))

print("\nPre-order обход родословного дерева:")
pre_order_traversal(root)
