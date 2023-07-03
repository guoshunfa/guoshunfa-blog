---
title: Mysql 介绍
tags:
  - mysql
  - 介绍
categories:
  - 技术
date: 2022-07-01 12:01:01
thumbnail:
---
## 安装Mysql

#### Mac 安装Mysql

> [MySQL安装（Mac版）](https://juejin.im/post/6844903831298375693)

 ```shell
 brew install mysql
 ```

#### Docker 安装 Mysql

```shell
# docker查询mysql镜像
docker search mysql
# 拉取mysql镜像
docker pull mysql
# 启动容器
docker run -d -p 3306:3306 --name mymysql -e MYSQL_ROOT_PASSWORD=root  docker.io/mysql:latest
##
# 参数说明：
# -p 3306:3306 将主机3306端口映射到容器3306端口
# -e MYSQL_ROOT_PASSWORD=root 设置远程登录的root用户密码为root
# --name zyz-name 可选，设置容器别名
# mysql 镜像名称
##
```

