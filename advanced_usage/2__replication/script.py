from sqlalchemy import create_engine, Column, Integer, String, DECIMAL, MetaData, Table
from sqlalchemy.orm import sessionmaker

# Настройки подключения
master_engine = create_engine("postgresql://postgres:@localhost:5433/my_database")
slave_engine = create_engine("postgresql://reading_user:reading_pass@localhost:5434/my_database")

# Создание/определение таблицы
metadata = MetaData()
products = Table(
    'products', metadata,
    Column('id', Integer, primary_key=True),
    Column('name', String(50)),
    Column('price', DECIMAL)
)
metadata.create_all(master_engine)

# Сессии для мастера и слейва
MasterSession = sessionmaker(bind=master_engine)
SlaveSession = sessionmaker(bind=slave_engine)

# Добавление данных в мастер
with MasterSession() as session:
    session.execute(products.insert().values(name="Product D", price=12.99))
    session.commit()

# Чтение данных со слейва
with SlaveSession() as session:
    result = session.execute(products.select()).fetchall()
    print(result)
