#!/bin/sh

# CURRENT_DIR=$(cd $(dirname $0); pwd)
DELIMITER_LINE='------------------------------------------------------'
START_MESSAGE='start restore database dump.'

# dumpファイルに下記の記述がある場合は削除すること。
# mysqldump: [Warning] Using a password on the command line interface can be insecure.
# Warning: A partial dump from a server that has GTIDs will by default include the GTIDs of all transactions, even those that changed suppressed parts of the database. If you don't want to restore GTIDs, pass --set-gtid-purged=OFF. To make a complete dump, pass --all-databases --triggers --routines --events.
# SET @@GLOBAL.GTID_PURGED='xxxxxxxxxxx-xx';

# dateコマンド結果を指定のフォーマットで出力
TIME_STAMP=$(date "+%Y%m%d_%H%M%S")

# CHANGE Variable.
DATABASE_CONTAINER_NAME=database_container_name
DATABASE_USER=database_user
DATABASE_NAME=database_name
TABLE_NAME=table_name
DATABASE_PASSWORD=database_password
OUTPUT_FILE=sample/dump/dump.sql
# TIME_STAMPを使う場合
# OUTPUT_FILE=sample/dump/dump_${TIME_STAMP}.sql

# @param {string} message
showMessage() {
  echo ${DELIMITER_LINE}
  echo $1
}

# process start
showMessage ${START_MESSAGE}

# dump command.
# docker exec -it ${DATABASE_CONTAINER_NAME} mysqldump -u ${DATABASE_USER} -p${DATABASE_PASSWORD} -D ${DATABASE_NAME} ${TABLE_NAME} --master-data --single-transaction < ${OUTPUT_FILE}
docker exec -i ${DATABASE_CONTAINER_NAME} mysql -h localhost -u ${DATABASE_USER} -p${DATABASE_PASSWORD} -D ${DATABASE_NAME} < ${OUTPUT_FILE}

# 現在のDocker コンテナの状態を出力
showMessage 'restore data base dump.'

