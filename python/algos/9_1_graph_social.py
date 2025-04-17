from collections import deque


"""
В социальной сети каждая вершина – это человек, а ребра представляют дружеские связи.
Ваша задача – для заданного пользователя найти всех, кто находится на расстоянии 2
(то есть друзья друзей, исключая непосредственных друзей и самого пользователя).
"""


def friends_second_level(start, graph):
    """Находит всех друзей второго уровня для пользователя start."""
    visited = {start}
    level = {start: 0}
    queue = deque([start])
    second_level = set()

    while queue:
        current = queue.popleft()
        for friend in graph.get(current, []):
            if friend not in visited:
                visited.add(friend)
                level[friend] = level[current] + 1
                queue.append(friend)
                if level[friend] == 2:
                    second_level.add(friend)
    return second_level


# Пример социальной сети
social_graph = {
    'Alice': ['Bob', 'Charlie'],
    'Bob': ['Alice', 'David', 'Eve'],
    'Charlie': ['Alice', 'Faythe'],
    'David': ['Bob'],
    'Eve': ['Bob', 'Faythe'],
    'Faythe': ['Charlie', 'Eve']
}

result = friends_second_level('Alice', social_graph)
print("\nДрузья второго уровня для Alice:", result)
