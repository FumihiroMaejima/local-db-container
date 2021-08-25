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

# CLIでDB操作

## mysqlコンテナ内でCLIでmysqlを操作する

```shell-session
$ docker exec -it local-db-mysql bash
```

```shell-session
$ mysql -u root -p
```

```shell-session
mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| sys                |
+--------------------+
4 rows in set (0.00 sec)
```

```shell-session
mysql> CREATE DATABASE IF NOT EXISTS local_db CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
Query OK, 1 row affected (0.02 sec)
mysql> GRANT ALL PRIVILEGES ON local_db.* TO 'root'@'%';
Query OK, 0 rows affected (0.02 sec)
```

```shell-session
mysql> use local_db
```

##

----


