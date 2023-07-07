---
title: MongoDB 错误记录
tags:
  - MongoDB
categories:
  - 数据库
date: 2022-07-01 11:38:29
thumbnail:
---

### connect ECONNREFUSED（连接被拒绝）

> 转载自：https://blog.csdn.net/qq_18404993/article/details/121103912

**情况一：**MongoDB IP配置问题

mongodb的配置文件中的bind_ip 默认为127.0.0.1，默认只有本机可以连接。 此时，需要将bind_ip配置为0.0.0.0，表示接受任何IP的连接

原因：云服务器中安装MongoDB后（默认端口27017），默认绑定IP为 127.0.0.1 ，这就导致外部无法访问；
解决方案： 修改mongod.config配置文件，添加 bind_ip=0.0.0.0 绑定公网IP;
重启mongodb服务

**情况二：**服务器安全组配置问题

Mongodb的默认端口为27017，需要在服务器安全组配置中放开此端口

**情况三：**服务器防火墙27017端口未对外开放

查看是否开放：`firewall-cmd --query-port=27017/tcp`
放开27017端口：`firewall-cmd --add-port=27017/tcp`
