---
title: shell ssh远程连接工具
tags:
  - Shell
  - ssh
categories:
  - 服务器管理
date: 2022-07-01 11:24:28
thumbnail:
---
## 1. 命令

-  `ssh 用户名@主机IP`
-  `ssh 主机IP`
-  `ssh -i pem文件路径 用户名@主机IP`
-  `ssh -p 端口 用户名@主机IP`

## 2. ssh 携带密码登录-sshpass

> 详细内容可直接查看[sshpass使用说明](/pages/bd9696/)

`sshpass -p [passwd] ssh -p [port] root@192.168.X.X`

## 3. ssh通过pem文件登陆服务器

一些为了安全操作，推荐使用私钥进行登录服务器，拿jenkins来说，默认的验证方式就是私钥

### 3.1. 实现方式

先在**本机**通过ssh-keygen直接生成公私钥

如下在当前文件夹下生成my.pem(私钥)和my.pem.pub(公钥)

`ssh-keygen -t rsa -f my.pem`

参数说明：-t type密钥类型（rsa、dsa...），-f生成文件名

### 3.2. 生成的文件

my.pem 和 my.pem.pub

1. 将my.pem.pub内容上传至你需要连接的服务器

2. 操作步骤，编辑authorized_keys文件，路径在当前用户目录下的.ssh文件夹下

3. 将生成的pub文件的内容追加到authorized_keys文件中

保存退出之后就可以通过`ssh -i file.pem user@ip`访问了



