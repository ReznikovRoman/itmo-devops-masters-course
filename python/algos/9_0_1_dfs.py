def dfs(start, graph, visited=None):
    """DFS обход графа.

    start: начальная вершина
    graph: список смежности вида {вершина: [список_смежных_вершин]}
    visited: множество для хранения уже посещенных вершин
    """
    if visited is None:
        visited = set()

    visited.add(start)
    print(start, end=" ")  # Вывод вершины в порядке обхода

    for neighbor in graph[start]:
        if neighbor not in visited:
            dfs(neighbor, graph, visited)


# Пример графа (неориентированный)
graph = {
    'A': ['B', 'C'],
    'B': ['A', 'D', 'E'],
    'C': ['A', 'F'],
    'D': ['B'],
    'E': ['B', 'F'],
    'F': ['C', 'E']
}

print("DFS от вершины A:")
dfs('A', graph)  # Ожидаемый порядок обхода: A -> B -> D -> E -> F -> C
