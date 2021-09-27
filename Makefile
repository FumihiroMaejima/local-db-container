CMD=default
MYSQL_VERSION80=8.0
MYSQL_VERSION57=5.7

echo:
	@echo test

##############################
# make docker environmental
##############################
up:
	docker-compose up -d

stop:
	docker-compose stop

down:
	docker-compose down

down-rmi:
	docker-compose down --rmi all
ps:
	docker-compose ps

dev:
	sh ./scripts/dev.sh

serve:
	sh ./scripts/container.sh

##############################
# db container(mysql)
##############################
mysql:
	docker-compose exec db bash -c 'mysql -u $$MYSQL_USER -p$$MYSQL_PASSWORD $$MYSQL_DATABASE'


##############################
# manage docker file
##############################

ch-v57:
	sed -i -e "s/FROM mysql:$(MYSQL_VERSION80)/FROM mysql:$(MYSQL_VERSION57)/g" mysql/Dockerfile

ch-v80:
	sed -i -e "s/FROM mysql:$(MYSQL_VERSION57)/FROM mysql:$(MYSQL_VERSION80)/g" mysql/Dockerfile
