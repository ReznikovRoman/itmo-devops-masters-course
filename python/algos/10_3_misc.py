import heapq


# 1. Задача о заправках
def find_min_refills(distances: list[int], tank: int):
    """Минимальное количество заправок для достижения финиша.

    distances: расстояния между заправками, включая последний – до финиша.
    tank: макс. пробег на полном баке.
    """
    refills = 0
    fuel = tank
    for distance in distances:
        if distance > tank:
            return float('inf')  # недостижимо
        if fuel < distance:
            refills += 1
            fuel = tank
        fuel -= distance
    return refills


_distances = [1000, 50, 200, 100]
print("Требуется заправок:", find_min_refills(_distances, 200))


# 2. Задача о максимальной прибыли
def find_max_profit(prices: list[int]) -> int:
    min_price = float('inf')
    best = 0
    for price in prices:
        min_price = min(min_price, price)  # локальный минимум
        best = max(best, price - min_price)  # лучший профит
    return best

# Пример
print("Макс. прибыль:", find_max_profit([7, 1, 5, 3, 6, 4]))

# 3. Задача об аудиториях
def find_min_rooms(intervals: list[tuple[int, int]]) -> int:
    # сортируем по времени начала
    intervals.sort(key=lambda x: x[0])
    heap = []  # в куче храним окончания занятий
    for start, end in intervals:
        if heap and heap[0] <= start:  # если минимальное окончание в куче <= начала нового занятия
            # переиспользуем освободившуюся аудиторию
            heapq.heapreplace(heap, end)
        else:
            # новая аудитория
            heapq.heappush(heap, end)
    return len(heap)


# [(начало занятия, конец занятия), ...]
lectures = [(30, 75), (0, 50), (60, 150), (35, 55)]
print("Нужно аудиторий:", find_min_rooms(lectures))
