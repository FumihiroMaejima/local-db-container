#!/bin/sh

SEPARATOPION='+++++++++++++++++++++++++++'
START_MESSAGE='check container status.'
echo ${SEPARATOPION}
echo ${START_MESSAGE}

echo ${SEPARATOPION}

# -qオプション container idのみを表示
# /dev/null: 出力が破棄され、なにも表示されない。
# 2(標準エラー出力) を/dev/nullに破棄することで、1(標準出力)のみを出力する。
if [[ "$(docker-compose ps -q 2>/dev/null)" == "" ]]; then
  # コンテナが立ち上がっていない状態の時
  echo 'Up Docker Container!'
  echo ${SEPARATOPION}
  docker-compose up -d
else
　# コンテナが立ち上がっている状態の時
  echo 'Down Docker Container!'
  echo ${SEPARATOPION}
  docker-compose down
fi

# 現在のDocker コンテナの状態を出力
echo ${SEPARATOPION}
echo 'Current Docker Status.'
echo ${SEPARATOPION}
docker-compose ps

