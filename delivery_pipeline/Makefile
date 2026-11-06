IMAGE ?= delivery-demo
TAG ?= $(shell git rev-parse --short HEAD 2>/dev/null || echo dev)
GIT_SHA ?= $(shell git rev-parse HEAD 2>/dev/null || echo unknown)

.PHONY: help install lint test check build build-bad build-stale build-multistage sizes

help: ## Показать список команд
	@grep -E '^[a-zA-Z_-]+:.*?## ' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "%-18s %s\n", $$1, $$2}'

install: ## Установить зависимости для разработки
	pip install -r requirements-dev.txt

lint: ## Статический анализ (pylint)
	python -m pylint app

test: ## Тесты + отчёт report.xml (junit)
	python -m pytest --junitxml=report.xml

check: lint test ## CI: lint + test

build: ## Собрать образ, тег = короткий SHA коммита
	docker build -f Dockerfile.good -t $(IMAGE):$(TAG) \
		--build-arg GIT_SHA=$(GIT_SHA) --build-arg APP_VERSION=$(TAG) \
		--label org.opencontainers.image.revision=$(GIT_SHA) .

build-bad: ## Собрать образ с неудачным порядком слоёв
	docker build -f Dockerfile.bad -t $(IMAGE):bad .

build-stale: ## Собрать образ с "залипающей" зависимостью
	docker build -f Dockerfile.stale -t $(IMAGE):stale .

build-multistage: ## Собрать multi-stage образ
	docker build -f Dockerfile.multistage -t $(IMAGE):multistage \
		--build-arg GIT_SHA=$(GIT_SHA) --build-arg APP_VERSION=$(TAG) .

sizes: ## Сравнить размеры собранных образов
	docker images $(IMAGE)
