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

## v5.7やv8.0など、複数のバージョンを用意する必要がある場合はvolumeも分けておく。

```shell-session
$ docker volume create local-db-v57-store
$ docker volume create local-db-v80-store
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


## characterの設定の確認

```shell-session
mysql> show character set;
mysql> show variables like 'char%';
```

## データのダンプとリストア

```shell-session
$ mysqldump -u root -p ${PASSWORD} local_db > test_db2108.sql
$ mysql -u root -p ${PASSWORD} -D local_db < test_db2108.sql
```

# テストデータ

```SQL
CREATE TABLE testers (
    id int(11) not null AUTO_INCREMENT,
    name varchar(255) default null,
    tel varchar(255) default null,
    email varcshar(255) default null,
    message varchar(255) default null,
    updated_at datetime not null,
    created_at datetime not null,
    deleted_at datetime default null,
    primary key (`id`)
)ENGINE=InnoDB default charset=utf8mb4;

-- データの挿入
INSERT INTO users(
    name,
    tel,
    email
)
VALUES
('User1 Test', '000-0000-0000', 'test1@example.com', NULL, '2022-03-10 00:00:00', '2022-03-10 00:00:00', NULL),
('User2 Test', '000-0000-0000', 'test2@example.com', NULL, '2022-03-10 00:00:00', '2022-03-10 00:00:00', NULL),
('User3 Test', '000-0000-0000', 'test3@example.com', NULL, '2022-03-10 00:00:00', '2022-03-10 00:00:00', NULL),

-- 複数検索
SELECT * FROM users WHERE id IN (1, 5, 8);
```

---

# データベースの更新など

```SQL
-- データの更新
UPDATE test_users SET name = 'test' WHERE id = 1;
UPDATE test_users SET name = 'test', email = 'test10@example.com' WHERE id IN (1, 2, 3);

-- データベースの名前の変更
ALTER TABLE test_users RENAME TO renamed_users;

-- データベースの名前の変更
ALTER TABLE test_users ADD COLUMN price INT(11) DEFAULT 0 NOT NULL AFTER last_name;

-- カラムの追加
ALTER TABLE test_users ADD COLUMN email INT(11) DEFAULT 0 NOT NULL AFTER last_name;
ALTER TABLE test_users ADD COLUMN address INT(11) DEFAULT 0 NOT NULL AFTER email;
ALTER TABLE test_users ADD COLUMN prefecture INT(11) DEFAULT 0 NOT NULL AFTER address;
ALTER TABLE test_users ADD COLUMN city INT(11) DEFAULT 0 NOT NULL AFTER prefecture;
ALTER TABLE test_users ADD COLUMN block INT(11) DEFAULT 0 NOT NULL AFTER city;

-- カラムのデータの変更
ALTER TABLE test_users CHANGE COLUMN email phone INT(11) DEFAULT 0 NOT NULL;
ALTER TABLE test_users CHANGE COLUMN phone email VARCHAR(255) DEFAULT NULL;

-- 特定のデータの削除
DELETE FROM table_name WHERE id = 1;

-- テーブル内の全てのデータの削除
TRUNCATE TABLE table_name;

-- テーブルの削除
DROP TABLE database_name.test_users;

-- 指定の時刻より後のデータ
SELECT * FROM users
WHERE CURRENT_DATE() >= updated_at;

-- データの削除
DELETE FROM users WHERE id = 1;


```

---

## システムdateの確認

```sql
mysql> SELECT SYSDATE();
```

---

## パーティション関連

```sql
-- パーティションの確認
SELECT 
TABLE_SCHEMA,
TABLE_NAME,
PARTITION_NAME,
PARTITION_ORDINAL_POSITION,
TABLE_ROWS
FROM INFORMATION_SCHEMA.PARTITIONS
WHERE TABLE_NAME='table_name'
;

-- 最新のパーティションの取得
-- PARTITION_NAMEではソートが正しくされない。
SELECT 
TABLE_SCHEMA,
TABLE_NAME,
PARTITION_NAME,
PARTITION_ORDINAL_POSITION,
TABLE_ROWS
FROM INFORMATION_SCHEMA.PARTITIONS
WHERE TABLE_NAME='table_name'
ORDER BY PARTITION_ORDINAL_POSITION DESC
;
```

## 最新のパーティションの取得

```sql
-- パーティションの作成(idカラム)
ALTER TABLE database_name.table_name
PARTITION BY RANGE COLUMNS(column_name) (
    PARTITION p1 VALUES LESS THAN (100000),
    PARTITION p100001 VALUES LESS THAN (200000),
    PARTITION p200001 VALUES LESS THAN (300000),
    PARTITION p300001 VALUES LESS THAN (400000),
    PARTITION p400001 VALUES LESS THAN (500000),
    PARTITION p500001 VALUES LESS THAN (600000),
    PARTITION p600001 VALUES LESS THAN (700000),
    PARTITION p700001 VALUES LESS THAN (800000),
    PARTITION p800001 VALUES LESS THAN (900000),
    PARTITION p900001 VALUES LESS THAN (1000000),
    PARTITION p1000001 VALUES LESS THAN (1100000)
);

-- パーティションの作成(datetimeカラム)
ALTER TABLE database_name.table_name
PARTITION BY RANGE COLUMNS(column_name) (
    PARTITION p20220806 VALUES LESS THAN ('2022-08-07 00:00:00'),
    PARTITION p20220807 VALUES LESS THAN ('2022-08-08 00:00:00'),
    PARTITION p20220808 VALUES LESS THAN ('2022-08-09 00:00:00'),
    PARTITION p20220809 VALUES LESS THAN ('2022-08-10 00:00:00'),
    PARTITION p20220810 VALUES LESS THAN ('2022-08-11 00:00:00'),
    PARTITION p20220811 VALUES LESS THAN ('2022-08-12 00:00:00'),
    PARTITION p20220812 VALUES LESS THAN ('2022-08-13 00:00:00'),
    PARTITION p20220813 VALUES LESS THAN ('2022-08-14 00:00:00'),
    PARTITION p20220814 VALUES LESS THAN ('2022-08-15 00:00:00'),
    PARTITION p20220815 VALUES LESS THAN ('2022-08-16 00:00:00')
);

-- パーティションの追加
ALTER TABLE database_name.table_name
ADD PARTITION (
    PARTITION p1100001 VALUES LESS THAN (1200000),
    PARTITION p1200001 VALUES LESS THAN (1200000)
);

-- パーティションの削除
ALTER TABLE database_name.table_name DROP PARTITION p100001;


```



---

## 日時関数

```sql
-- 現在の日時を取得
SELECT NOW();
SELECT CURRENT_DATE();
SELECT DATE_FORMAT(CURRENT_DATE() , '%Y%m%d');

-- 指定した日付の間差分日数を取得
SELECT DATEDIFF('2022-11-28', '2022-07-28');

-- 翌日のdateを取得
SELECT DATE_ADD(CURRENT_DATE(), INTERVAL 1 DAY);
SELECT DATE_ADD(CURRENT_DATE(), INTERVAL 1 DAY), DATE_ADD(CURRENT_DATE(), INTERVAL 2 DAY);

-- 指定した日付の10日後を取得する
SELECT DATE_ADD('2022/01/10', INTERVAL 10 DAY);
-- 指定した日付の20日前を取得する
SELECT DATE_SUB('2022/08/30',INTERVAL 20 DAY);
-- DATE_ADD でマイナスの値を指定して減算する
SELECT DATE_ADD('2022/08/30',INTERVAL -20 DAY);

-- 3か月後の日時、又は日付を取得する
SELECT DATE_ADD(NOW(), INTERVAL 3 MONTH);
SELECT DATE_ADD(CURRENT_DATE(), INTERVAL 3 MONTH);

-- 現在の日付と時刻を数値として取得する場合は
SELECT now()+0;
-- 引数に小数秒の精度を0~6の数値で指定する
SELECT now(0), now(3);

-- 日付のフォーマット指定
SELECT DATE_FORMAT('2022-03-02', '%Y %M %d');
SELECT DATE_FORMAT(CURRENT_DATE() , '%Y %M %d');
SELECT DATE_FORMAT(CURRENT_DATE() , '%Y%m%d');
-- 3ヶ月後の日付
SELECT DATE_FORMAT(DATE_ADD(CURRENT_DATE(), INTERVAL 3 MONTH) , '%Y%m%d');
-- 時刻付き('Y-m-d H:i:s')
SELECT DATE_FORMAT(CURRENT_DATE() , '%Y-%m-%d %H:%i:%s');
SELECT DATE_FORMAT(DATE_ADD(CURRENT_DATE(), INTERVAL 3 MONTH), '%Y-%m-%d %H:%i:%s');


```


---

## Indexの設定

index設定の確認

```sql
SHOW INDEX FROM database_name.table_name;
```

| カラム名 | 説明 |
| :--- | :--- |
| Table | テーブル名 |
| Non_unique | 重複許可設定。重複可能:1, 重複不可:0 |
| Key_name | インデックス名。主キーなら、常にprimary |
| Seq_in_index | インデックス内のカラムシーケンス番号であり、1から始まる。 |
| Column_name | カラム名 |
| Collation | インデックス内カラムのソート方法。A:昇順, NULL:ソートされない |
| Cardinality | インデックス内のユニーク数の推定値。 |
| Sub_part | カラムが部分的インデックス設定されてるときの文字の数。カラム全体がインデックス設定されている場合は NULL。 |
| Packed | キーがパックされる方法。パックされない場合は NULL。 |
| Null | NULL許可設定。可能:YES, 不可:空白 |
| Index_type | 使用されるインデックス方法 (BTREE、FULLTEXT、HASH、RTREE) |
| Comment | コメント |
| Index_comment | indexコメント |



---

## バイナリログの確認

```shell-session
$ mysqlbinlog binlog.000001
# DB名を指定
$ mysqlbinlog --database=${DB_NAME} mysql-bin.000001
```

mysql上で確認

```sql
mysql> SHOW binary logs;

mysql> show binlog events in 'mysql-bin.000011';

Log_name|Pos|Event_type|Server_id|End_log_pos|Info|
--------+---+----------+---------+-----------+----+
```

### binlog_formatの確認

```sql
mysql> show variables like 'binlog_format';

Variable_name|Value|
-------------+-----+
binlog_format|ROW  |

```

###バイナリログの設定

`my.cnf`に下記の設定を追加

```config
[mysqld]
...
# バイナリログを出力
log-bin

```

---

# レプリケーション設定

## master

マスター用のDBは既存と同一の設定で一旦は可

`my.cnf`に下記の設定を追加

```config
[mysqld]
...
# バイナリログを出力
log_bin = /var/log/mysql/mysql-bin.log
# マスターとスレーブが自身を一意に識別するための設定
server-id=101

```

slaveアカウントの作成

`SLAVE_SERVER_IP`はローカルでは`%`でも良い。

```sql
mysql> CREATE USER 'repl'@'${SLAVE_SERVER_IP}' identified by 'slave-password';
mysql> GRANT REPLICATION SLAVE ON *.* TO 'repl'@'${SLAVE_SERVER_IP}';

FLUSH PRIVILEGES;
```

masterのバイナリログの確認

`File`と`Position`を確認する

```sql
mysql> SHOW MASTER STATUS;
File            |Position|Binlog_Do_DB|Binlog_Ignore_DB|Executed_Gtid_Set|
----------------+--------+------------+----------------+-----------------+
mysql-bin.000003|   154  |            |                |                 |

```


## slave

`my.cnf`に下記の設定を追加

```config
[mysqld]
...
# バイナリログを出力
log_bin = /var/log/mysql/mysql-bin.log
# スレーブが自身を一意に識別するための設定
server-id=102

```

master情報の設定とレプリケーションのスタートを実行

`MASTER_LOG_FILE`と`MASTER_LOG_POS`にmaster側で確認したデータを設定する。

```sql
mysql> CHANGE MASTER TO MASTER_HOST='mysql-master', MASTER_USER='repl', MASTER_PASSWORD='password', MASTER_LOG_FILE='mysql-bin.000003', MASTER_LOG_POS=154;
mysql> START SLAVE;

```


## GTIDモードを利用する場合

`master.cnf`に下記の設定を追加

```config
# バイナリログを出力
log_bin = /var/log/mysql/mysql-bin.log
server-id=101

# GTIDモード有効化
gtid-mode=ON
log-slave-updates
enforce-gtid-consistency

```


`slave.cnf`に下記の設定を追加

```config
# バイナリログを出力
log_bin = /var/log/mysql/mysql-bin.log
server-id=102
# read_only=1

# GTIDモード有効化
gtid-mode=ON
log-slave-updates
enforce-gtid-consistency

```

slave側の`initalize.sql`のCHANGE MASTER設定を下記の通りに修正する。

```sql
mysql> CHANGE MASTER TO MASTER_HOST='mysql-master', MASTER_USER='repl', MASTER_PASSWORD='password', MASTER_AUTO_POSITION=1;
```


---


