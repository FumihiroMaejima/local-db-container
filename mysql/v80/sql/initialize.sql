CREATE DATABASE IF NOT EXISTS local_db_v80 CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON local_db_v80.* TO 'root'@'%';

FLUSH PRIVILEGES;
