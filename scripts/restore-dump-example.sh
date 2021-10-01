#!/bin/sh

SEPARATOPION='+++++++++++++++++++++++++++'
START_MESSAGE='start restore database dump.'
echo ${SEPARATOPION}
echo ${START_MESSAGE}

# CHANGE Variable.
DATABASE_CONTAINER_NAME=database_container_name
DATABASE_USER=database_user
DATABASE_NAME=database_name
DATABASE_PASSWORD=pdatabase_assword
OUTPUT_FILE=sample/dump/dump.sql

# dump command.
docker exec -it ${DATABASE_CONTAINER_NAME} mysqldump -u ${DATABASE_USER} -p${DATABASE_PASSWORD} -D ${DATABASE_NAME} < ${OUTPUT_FILE}

# 現在のDocker コンテナの状態を出力
echo ${SEPARATOPION}
echo 'restore data base dump.'
echo ${SEPARATOPION}

