Экспорт данных:
```shell
docker exec -t postgres_db pg_dump -U user example_db > backup.sql
```

Восстановление:
```shell
docker exec -i postgres_db psql -U user -d example_db < backup.sql
```
