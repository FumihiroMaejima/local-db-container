#!/bin/sh

# CURRENT_DIR=$(cd $(dirname $0); pwd)
DELIMITER_LINE='------------------------------------------------------'
START_MESSAGE='start slave server.'

MASTER_HOST='mysql-master'
MASTER_USER='repl'
MASTER_PASSWORD='password'
SLAVE_PASSWORD='password'

# @param {string} message
showMessage() {
  echo ${DELIMITER_LINE}
  echo $1
}

# process start
showMessage ${START_MESSAGE}



# depends_onの設定しておけば気にならないけど念の為masterの起動を待つ
while ! mysqladmin ping -h ${MASTER_HOST} --silent; do
  sleep 1
done

# masterをロックする
mysql -u ${MASTER_USER} -p ${MASTER_PASSWORD} -h ${MASTER_HOST} -e "RESET MASTER;"
mysql -u ${MASTER_USER} -p ${MASTER_PASSWORD} -h ${MASTER_HOST} -e "FLUSH TABLES WITH READ LOCK;"

# masterのDB情報をDumpする
# ここでは --all-databases にしてるけど用途に応じて必要なDBだけにしていいと思う
mysqldump -u ${MASTER_USER} -p ${MASTER_PASSWORD} -h ${MASTER_HOST} --all-databases --master-data --single-transaction --flush-logs --events > /tmp/master_dump.sql
# 特定のDBだけにする場合はこんな感じ(my.cnfのreplica-do-dbも忘れずに設定すること)
# mysqldump -uroot -h mysql データベース名 --master-data --single-transaction --flush-logs --events > /tmp/master_dump.sql

# dumpしたmasterのDBをslaveにimportする
mysql -u root -p ${SLAVE_PASSWORD} -e "STOP SLAVE;";
mysql -u root -p ${SLAVE_PASSWORD} < /tmp/master_dump.sql

# masterに繋いで bin-logのファイル名とポジションを取得する
log_file=`mysql -u ${MASTER_USER} -p ${MASTER_PASSWORD} -h ${MASTER_HOST} -e "SHOW MASTER STATUS\G" | grep File: | awk '{print $2}'`
pos=`mysql -u ${MASTER_USER} -p ${MASTER_PASSWORD} -h ${MASTER_HOST} -e "SHOW MASTER STATUS\G" | grep Position: | awk '{print $2}'`

# slaveの開始
mysql -u root -p ${SLAVE_PASSWORD} -e "RESET SLAVE;"
mysql -u root -p ${SLAVE_PASSWORD} -e "CHANGE MASTER TO MASTER_HOST='${MASTER_HOST}', MASTER_USER='${MASTER_USER}', MASTER_PASSWORD='${MASTER_PASSWORD}', MASTER_LOG_FILE='${log_file}', MASTER_LOG_POS=${pos};"
mysql -u root -p ${SLAVE_PASSWORD} -e "START SLAVE;"

# masterをunlockする
mysql -u ${MASTER_USER} -p ${MASTER_PASSWORD} -h ${MASTER_HOST} -e "UNLOCK TABLES;"
