LOGIN=egeraldo
VOLUMES_PATH=~/nave/inception/data

export VOLUMES_PATH
export LOGIN

SYSTEM_USER = $(shell echo $$USER)
DOCKER_CONFIG = $(shell echo $$HOME/.docker)

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

build-no-cache:
	$(DOCKER_COMPOSE_COMMAND) build --no-cache

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
	sudo mkdir -p ${VOLUMES_PATH}/mariadb
	sudo mkdir -p ${VOLUMES_PATH}/wordpress

prepare:	update compose

update:
	@echo "${YELLOW}-----Updating System----${NC}"
	sudo apt -y update && sudo apt -y upgrade
	@if [ $$? -eq 0 ]; then \
		echo "${GREEN}-----System updated-----${NC}"; \
		echo "${YELLOW}-----Installing Docker-----${NC}"; \
		sudo apt -y install docker.io && sudo apt -y install docker-compose; \
		if [ $$? -eq 0 ]; then \
			echo "${GREEN}-----Docker and docker-compose installed-----${NC}"; \
		else \
			echo "${RED}-----Docker or docker-compose installation failed-----${NC}"; \
		fi \
	else \
		echo "${RED}-----System update failed-----${NC}"; \
	fi

compose:
	@echo "${YELLOW}-----Updating Docker Compose to V2-----${NC}"
	sudo apt -y install curl
	mkdir -p ${DOCKER_CONFIG}/cli-plugins
	curl -SL https://github.com/docker/compose/releases/download/v2.2.3/docker-compose-linux-x86_64 -o ${DOCKER_CONFIG}/cli-plugins/docker-compose
	chmod +x ${DOCKER_CONFIG}/cli-plugins/docker-compose
	sudo mkdir -p /usr/local/lib/docker/cli-plugins
	sudo mv /home/${SYSTEM_USER}/.docker/cli-plugins/docker-compose /usr/local/lib/docker/cli-plugins/docker-compose
	@echo "${GREEN}-----Docker Compose updated-----${NC}"

.PHONY: all up build build-no-cache down ps ls clean fclean setup host update compose prepare
