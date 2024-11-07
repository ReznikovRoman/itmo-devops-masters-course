# В приложении можно реализовать логику распределения данных по шардовым базам.
# Например, если мы работаем с пользователями,
# можно направлять данные в один из шардов в зависимости от идентификатора пользователя.


def get_shard(user_id):
    # Если user_id чётное — отправляем в shard1, иначе — в shard2
    if user_id % 2 == 0:
        return shard1_engine
    return shard2_engine


engine = get_shard(user_id)
with engine.connect() as conn:
    conn.execute("INSERT INTO users (id, name) VALUES (%s, %s)", (user_id, "User Name"))
