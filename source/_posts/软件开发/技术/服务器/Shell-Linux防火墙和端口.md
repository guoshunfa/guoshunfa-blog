---
title: Shell Linux防火墙和端口
tags:
  - Shell
  - linux
categories:
  - 服务器管理
date: 2022-07-01 11:27:36
thumbnail:
---
```shell
# 查看防火墙状态

systemctl status firewalld

# 如果不是显示active状态，需要打开防火墙

systemctl start firewalld

# 查看所有已开放的临时端口（默认为空）

firewall-cmd --list-ports

# 查看所有永久开放的端口（默认为空）

firewall-cmd --list-ports --permanent

# 添加临时开放端口（例如：比如我修改ssh远程连接端口是223，则需要开放这个端口）

firewall-cmd --add-port=223/tcp

# 添加永久开放的端口（例如：223端口）

firewall-cmd --add-port=223/tcp --permanent

# 关闭临时端口

firewall-cmd --remove-port=80/tcp

# 关闭永久端口

firewll-cmd --remove-port=80/tcp --permanent

# 配置结束后需要输入重载命令并重启防火墙以生效配置

firewall-cmd --reload
# or
systemctl restart firewalld
```

## 参考文档

- [凉了记忆](https://www.cnblogs.com/ketoli/p/15111625.html)