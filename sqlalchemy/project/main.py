from typing import cast

import sqlalchemy as sa
from sqlalchemy.dialects.postgresql import JSON
from sqlalchemy.orm import sessionmaker, Session, declarative_base, relationship

import datetime

# Определяем базу данных и соединение
Base = declarative_base()


# Таблица связки между серверами и сервисами
server_service_association = sa.Table(
    'server_service', Base.metadata,
    sa.Column('server_id', sa.ForeignKey('servers.id')),
    sa.Column('service_id', sa.ForeignKey('services.id')),
)


class Server(Base):
    __tablename__ = 'servers'

    id = sa.Column(sa.Integer, primary_key=True, autoincrement=True)
    name = sa.Column(sa.String(50), nullable=False)
    ip_address = sa.Column(sa.String(15), nullable=False, unique=True)
    status = sa.Column(sa.Boolean, default=True)  # ? включен / отключен сервер
    last_monitored = sa.Column(sa.DateTime, default=datetime.datetime.now(tz=datetime.timezone.utc))
    config = sa.Column(JSON)

    services = relationship('Service', secondary=server_service_association, back_populates='servers')

    def __repr__(self):
        return f"<{self.id}: {self.name}, {self.ip_address}>"


class Service(Base):
    __tablename__ = 'services'

    id = sa.Column(sa.Integer, primary_key=True, autoincrement=True)
    name = sa.Column(sa.String(50), nullable=False)

    # Связь с серверами через таблицу связки
    servers = relationship('Server', secondary=server_service_association, back_populates='services')

    def __repr__(self):
        return f"<{self.id}: {self.name}>"


def create_server(
        session_factory: sessionmaker[Session],
        *,
        name: str, ip_address: str, status: bool = True,
) -> Server:
    with session_factory() as session:
        new_server = Server(name=name, ip_address=ip_address, status=status)
        session.add(new_server)
        session.commit()
    return new_server


def list_servers(session_factory: sessionmaker[Session]) -> list[type[Server]]:
    with session_factory() as session:
        servers = session.query(Server).all()
        return servers


def create_service(
        session_factory: sessionmaker[Session],
        *,
        name: str,
) -> Service:
    with session_factory() as session:
        new_service = Service(name=name)
        session.add(new_service)
        session.commit()
    return new_service


def add_service(
        session_factory: sessionmaker[Session],
        *,
        service: Service,
) -> Server:
    with session_factory() as session:
        server = cast(Server, session.query(Server).filter_by(name="Nginx").first())
        server.services.append(service)
        session.commit()
    print(server.services)
    return server


def get_server_stats(session_factory: sessionmaker[Session]):
    with session_factory() as session:
        # Запрос для получения статистики по серверам
        server_stats = (
            session.query(
                Server.name, sa.func.count(Service.id)
            )
            .join(Server.services)
            .group_by(Server.name)
            .all()
        )
        for server_name, service_count in server_stats:
            print(f"Сервер {server_name} обслуживает {service_count} сервиса(ов)")


def _add_config(session_factory: sessionmaker[Session]) -> Server:
    with session_factory() as session:
        server = cast(Server, session.query(Server).filter_by(name="Web Server").first())
        server.config = {"cpu": "8 cores", "ram": "16GB", "os": "Ubuntu 21.04"}
        session.commit()

    # Запрос конфигурации
    print(server.config, server.config["ram"])
    return server


def _query_config(session_factory: sessionmaker[Session]):
    with session_factory() as session:
        server = session.query(Server).filter(Server.config["ram"].astext == "16GB").first()
    print(server)


def main(session_factory: sessionmaker[Session]) -> None:
    # server = create_server(session_factory, name="Python", ip_address="192.168.1.102", status=True)
    # print(server.id)
    service = create_service(session_factory, name="Traefik")
    servers = list_servers(session_factory)
    print(servers)
    add_service(session_factory, service=service)
    get_server_stats(session_factory)
    _add_config(session_factory)
    _query_config(session_factory)


if __name__ == '__main__':
    # Подключение к базе данных postgresql
    engine = sa.create_engine('postgresql://roman:@localhost/postgres')
    Base.metadata.create_all(engine)

    # Создание сессии для работы с базой данных
    Session = sessionmaker(bind=engine, expire_on_commit=False)

    main(Session)
