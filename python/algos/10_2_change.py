def change_greedy(coins: list[int], amount: int) -> list[int]:
    """Размен монетами жадным методом."""
    result = []
    for coin in sorted(coins, reverse=True):
        while amount >= coin:
            amount -= coin
            result.append(coin)
    return result


_coins = [1, 2, 5, 10, 20, 50]
print("Сдача для 93:", change_greedy(_coins, 93))  # Сдача для 93: [50, 20, 20, 2, 1]
