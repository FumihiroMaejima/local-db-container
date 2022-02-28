CREATE DATABASE IF NOT EXISTS local_db_replication CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON local_db.* TO 'root'@'%';

FLUSH PRIVILEGES;

-- masterの情報の設定
CHANGE MASTER TO MASTER_HOST='mysql-master', MASTER_USER='repl', MASTER_LOG_FILE='mysql-bin.000003', MASTER_LOG_POS=548;
-- レプリケーションの開始
START SLAVE;
