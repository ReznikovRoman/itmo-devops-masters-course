def fractional_knapsack(items: list[tuple[int, int]], max_weight: int) -> float:
    # Сортируем по убыванию отношения price/weight (от самых дорогих к самым дешёвым)
    items.sort(key=lambda x: x[0]/x[1], reverse=True)
    result = 0.0
    capacity = max_weight
    for price, weight in items:
        if capacity == 0:
            break
        # Берём сколько сможем из текущего предмета
        take = min(weight, capacity)
        result += price * (take / weight)
        capacity -= take
    return result


# [(стоимость / вес), ...]
_items = [(120, 30), (60, 10), (100, 20)]
print("Макс. стоимость:", fractional_knapsack(_items, 50))
