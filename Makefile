LOGIN=egeraldo
VOLUMES_PATH=/home/$(LOGIN)/data

export VOLUMES_PATH
export LOGIN

all: setup up

host:
	@if ! grep -q "${LOGIN}.42.fr" /etc/hosts; then \
		sudo sed -i "2i\127.0.0.1\t${LOGIN}.42.fr" /etc/hosts; \
	fi
host-clean:
	sudo sed -i "/${LOGIN}.42.fr/d" /etc/hosts

DOCKER_COMPOSE_FILE=./srcs/docker-compose.yml
DOCKER_COMPOSE_COMMAND=docker compose -f $(DOCKER_COMPOSE_FILE)

up: build
	$(DOCKER_COMPOSE_COMMAND) up -d

build:
	$(DOCKER_COMPOSE_COMMAND) build

down:
	$(DOCKER_COMPOSE_COMMAND) down

ps:
	$(DOCKER_COMPOSE_COMMAND) ps

ls:
	docker volume ls

clean: host-clean
	$(DOCKER_COMPOSE_COMMAND) down --rmi all --volumes

reset:
	docker stop $$(docker ps -qa)
	docker rm $$(docker ps -qa)
	docker rmi -f $$(docker images -qa)
	docker volume rm $$(docker volume ls -q)
	docker network rm $$(docker network ls -q) 2>/dev/null

fclean: clean
	docker system prune --force --all --volumes
	sudo rm -rf /home/${LOGIN}

setup: host
	sudo mkdir -p ${VOLUMES_PATH}/wp-database
	sudo mkdir -p ${VOLUMES_PATH}/wp-pages
	sudo chmod 777 ${VOLUMES_PATH}/wp-database
	sudo chmod 777 ${VOLUMES_PATH}/wp-pages


.PHONY: all up build build-no-cache down ps ls clean fclean setup host
