CMD=default
MYSQL_VERSION80=8.0
MYSQL_VERSION57=5.7

echo:
	@echo test
	@date "+%m/%d/%Y %H:%M"

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
# make docker environmental MySQL v8.0
##############################
up-v80:
	docker-compose -f ./docker-compose.v80.yml up -d

stop-v80:
	docker-compose -f ./docker-compose.v80.yml stop

down-v80:
	docker-compose -f ./docker-compose.v80.yml down

down-rmi-v80:
	docker-compose -f ./docker-compose.v80.yml down --rmi all
ps-v80:
	docker-compose -f ./docker-compose.v80.yml ps

v80:
	sh ./scripts/container-v80.sh

##############################
# make docker environmental MySQL Replication v5.7
##############################
up-repl:
	docker-compose -f ./docker-compose.replication-v57.yml up -d

stop-repl:
	docker-compose -f ./docker-compose.replication-v57.yml stop

down-repl:
	docker-compose -f ./docker-compose.replication-v57.yml down

down-rmi-repl:
	docker-compose -f ./docker-compose.replication-v57.yml down --rmi all
ps-repl:
	docker-compose -f ./docker-compose.replication-v57.yml ps

repl:
	sh ./scripts/container-replication-v57.sh

sqls:
	sh ./scripts/get-directory-sql-files.sh

##############################
# db container(mysql)
##############################
mysql:
	docker-compose exec db bash -c 'mysql -u $$DB_USER -p$$MYSQL_PASSWORD $$DB_DATABASE'

mysql-dump:
	sh ./scripts/get-dump.sh

mysql-restore:
	sh ./scripts/restore-dump.sh

mysql-table-dump:
	sh ./scripts/get-table-dump.sh

mysql-table-restore:
	sh ./scripts/restore-table-dump.sh

##############################
# manage docker file
##############################

ch-v57:
	sed -i -e "s/FROM mysql:$(MYSQL_VERSION80)/FROM mysql:$(MYSQL_VERSION57)/g" mysql/Dockerfile
	@echo current mysql version is v$(MYSQL_VERSION57)!

ch-v80:
	sed -i -e "s/FROM mysql:$(MYSQL_VERSION57)/FROM mysql:$(MYSQL_VERSION80)/g" mysql/Dockerfile
	@echo current mysql version is v$(MYSQL_VERSION80)!
