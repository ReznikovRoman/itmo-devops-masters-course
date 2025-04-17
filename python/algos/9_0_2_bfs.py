from collections import deque


def bfs(start, graph):
    """BFS обход графа.

    Возвращает словарь dist с расстояниями до каждой вершины.
    """
    dist = {v: float('inf') for v in graph}  # Изначально все расстояния = бесконечность
    dist[start] = 0
    queue = deque([start])
    while queue:
        current = queue.popleft()
        for neighbor in graph[current]:
            if dist[neighbor] == float('inf'):  # ещё не посещён
                dist[neighbor] = dist[current] + 1
                queue.append(neighbor)
    return dist


# Пример использования:
graph = {
    'A': ['B', 'C'],
    'B': ['A', 'D', 'E'],
    'C': ['A', 'F'],
    'D': ['B'],
    'E': ['B', 'F'],
    'F': ['C', 'E']
}

distances = bfs('A', graph)
print("\nBFS от вершины A. Расстояния:")
for vertex, d in distances.items():
    print(f"{vertex}: {d}")  # A: 0 B: 1 C: 1 D: 2 E: 2 F: 2
