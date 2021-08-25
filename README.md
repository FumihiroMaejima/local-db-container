# Local Database Docker Environmental

ローカルのDockerでデータベースを構築する為の手順書

# 構成

| 名前 | バージョン |
| :--- | :---: |
| MySQL | 8.0 |

---
# ローカル環境の構築(Mac)

## データの永続化の為にローカルに`volume`を作成する

```shell-session
$ docker volume create local-db-store
```

## `volume`の確認

```shell-session
$ docker volume ls
DRIVER    VOLUME NAME
local     local-db-store
```

## `volume`を削除する場合

```shell-session
$ docker volume rm local-db-store
```

---



