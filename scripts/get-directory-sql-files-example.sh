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

TARGET_PATH=sample/tmp/directorytest

DB_LIST=(
"testDB1"
"testDB2"
)

executeSQLFile() {
  TARGET_SQL_FILE=$1
  echo "${SEPARATOPION}"
  echo "TARGET SQL: ${TARGET_SQL_FILE_NAME}"
  TARGET_DB=""
  for dbName in ${DB_LIST[@]};
  do
    if [ `echo ${TARGET_SQL_FILE} | grep ${dbName}`  ]; then
      TARGET_DB="${dbName}"
    else
      continue
    fi
  done

  if [ -n "${TARGET_DB}" ]; then
    echo "TARGET DB: ${TARGET_DB}"
    # docker exec -it ${DATABASE_CONTAINER_NAME} mysql -u ${DATABASE_USER} -p${DATABASE_PASSWORD} ${DATABASE_NAME} < ${TARGET_SQL_FILE}
  else
    echo "No Match DB."
    echo "No Execute."
  fi
  echo "${SEPARATOPION}"
}

findSqlFiles() {
  DIRECTORY_PATH=$1
  # ファイル探索
  FIND_FILES_COMMAND=`find "${DIRECTORY_PATH}" -type f`

  for filePath in ${FIND_FILES_COMMAND[@]};
  do
    # .sqlの拡張子が含まれている場合
    if [ `echo ${filePath} | grep .sql` ]; then
      # echo "${filePath}"
      # echo $(dirname "${filePath}") # directory name.
      TARGET_SQL_FILE_NAME=$(basename "${filePath}")
      executeSQLFile "${TARGET_SQL_FILE_NAME}"
    else
      echo "${filePath} is Not SQL File."
    fi
  done
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
# find "${TARGET_PATH}" -type d

# ディレクトリ探索
FIND_DIRECTORIES_COMMAND=`find "${TARGET_PATH}" -type d`


# 対象のディレクトリ内に置かれているディレクトリを個別にチェック
# 対象のディレクトリも含まれる為、処理から除外する。
for dirctory in ${FIND_DIRECTORIES_COMMAND[@]};
do
  if [ ${dirctory} = "${TARGET_PATH}" ]; then
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

