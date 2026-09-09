Материалы к вебинару "Работа с данными в хранилище": "От хранилища к витринам: VIEW и визуализация данных".

Поднять окружение (схема и seed-данные загрузятся автоматически из `init.sql`
при первом старте контейнера):
```shell
docker compose up -d
```

Если контейнер уже запускался раньше и `init.sql` нужно применить заново
(докер грузит `docker-entrypoint-initdb.d` только на пустом volume):
```shell
docker compose down -v
docker compose up -d
```

Подключиться:
```shell
docker exec -it postgres_data_marts psql -U user -d warehouse_db
```
