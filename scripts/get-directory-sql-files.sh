#!/bin/sh

CURRENT_DIR=$(cd $(dirname $0); pwd)
SEPARATOPION='---------------------------'
START_MESSAGE='start batch test.'

# dateコマンド結果を指定のフォーマットで出力
TIME_STAMP=$(date "+%Y%m%d_%H%M%S")

# CHANGE Variable.
# DATABASE_CONTAINER_NAME=database_container_name
# DATABASE_USER=database_user
# DATABASE_NAME=database_name
# DATABASE_PASSWORD=database_password
# OUTPUT_FILE=sample/dump/dump_${TIME_STAMP}.sql

SAMPLE_DIR=sample/tmp/directorytest

findSqlFiles() {
  echo $1
  find "$1" -type f
}

# @param {string} message
showMessage() {
  echo ${SEPARATOPION}
  echo $1
  echo ${SEPARATOPION}
}

# process start
showMessage "${START_MESSAGE}"

# ディレクトリ内の確認
# ls sample/tmp < echo
# ls sample/tmp/test < echo
# find sample/tmp/test -type d < echo
# ディレクトリ内のファイル数の確認
# find sample/tmp/test -type d | while read dirctory; do echo -n $dirctory" "; find "$dirctory" -type f -maxdepth 1 | wc -l; done;
# find "${SAMPLE_DIR}" -type d

FIND_DIRECTORIES_COMMAND=`find "${SAMPLE_DIR}" -type d`


# プロセスチェック結果を1行ごと配列に格納
for dirctory in ${FIND_DIRECTORIES_COMMAND[@]};
do
  if [ ${dirctory} = "${SAMPLE_DIR}" ]; then
    # echo 'base dir'
    continue
  else
    # echo "${dirctory}"
    findSqlFiles ${dirctory}
  fi
done


# dump command.
# docker exec -it ${DATABASE_CONTAINER_NAME} mysqldump -u ${DATABASE_USER} -p${DATABASE_PASSWORD} ${DATABASE_NAME} > ${OUTPUT_FILE}

# last message
showMessage 'finish batch test '

