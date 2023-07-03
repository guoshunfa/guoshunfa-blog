---
title: Mysql 修改root账号密码
tags:
  - Mysql
categories:
  - 技术
date: 2022-07-01 11:40:38
thumbnail:
---

```shell
# 1. 停止mysql
##（windows）
net stop mysql;
##（mac brew）
brew stop mysql;
##（linux systemctl）
systemctl stop mysql.service;

# 2. 无密码登陆
mysqld --console --skip-grant-tables --shared-memory

# 3. 清空密码
UPDATE mysql.user SET authentication_string='' WHERE user='root' and host='localhost';

# 4. 修改密码
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '密码';
## 如果报错了ERROR 1290 (HY000): The MySQL server is running with the --skip-grant-tables option so it cannot execute this statement，就执行 flush privileges;
## 然后再执行ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '密码';

# 5. 试试是否修改成功
mysql -u root -p
```

