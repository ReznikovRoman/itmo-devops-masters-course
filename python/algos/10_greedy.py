# 1. activity selection
def select_activities(intervals: list[tuple[int, int]]):
    # 1) Сортируем по времени окончания
    intervals.sort(key=lambda x: x[1])
    # 2) Идём по списку, выбирая каждую встречу, которая начинается не раньше конца предыдущей
    result = []
    last_finish = -float('inf')
    for start, finish in intervals:
        if start >= last_finish:
            result.append((start, finish))
            last_finish = finish
    return result


meetings = [(1,4), (0,6), (3,5), (5,7), (3,8), (5,9), (6,10)]
print("Выбранные встречи:", select_activities(meetings))
