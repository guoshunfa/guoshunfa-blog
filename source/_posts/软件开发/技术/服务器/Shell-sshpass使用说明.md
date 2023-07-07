---
title: Shell sshpass使用说明
tags:
  - Shell
  - sshpass
categories:
  - 服务器管理
date: 2022-07-01 11:33:42
thumbnail:
---
## 1. 安装sshpass

>  **以下是针对mac系统进行安装。**

```shell
# 安装脚本
var=`brew list|grep sshpass`
if [ "$var" = "sshpass" ]
then echo "sshpass已安装"
else 
echo "开始安装sshpass"
wget https://raw.githubusercontent.com/kadwanev/bigboybrew/master/Library/Formula/sshpass.rb
brew install sshpass.rb
rm sshpass.rb
echo "sshpass安装成功"
fi
```

## 2. 使用

`sshpass -p [passwd] ssh -p [port] root@192.168.X.X`

## 3. 问题记录

### 3.1. [sshpass不生效](https://www.cndargon.com/index.php/archives/77/)

**问题**：执行ssh时，sshpass不生效。

**原因**：第一次连接这个服务器需要进行确认，是否可以进行连接。

```shell
The authenticity of host '10.1.1.10 (10.1.1.10)' can't be established.
ECDSA key fingerprint is 00:00:00.
Are you sure you want to continue connecting (yes/no)? 
```

**解决思路**：ssh api中有一个参数：`-o StrictHostKeyChecking=no` ，这个参数可以直接把没有连接过的机器，那个yes/no的部分，直接自动处理。

**解决事例**：`sshpass -p [passwd] ssh -p [port] root@192.168.X.X -o StrictHostKeyChecking=no`

## 参考文档

- [【Linux】sshpass不生效](https://www.cndargon.com/index.php/archives/77/)

