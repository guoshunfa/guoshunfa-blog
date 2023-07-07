---
title: MongoDB 介绍
tags:
  - MongoDB
categories:
  - 数据库
date: 2022-07-01 11:36:20
thumbnail:
---
> [MongoDB 官网](https://docs.mongodb.com) | [MongoDB 中文网址](https://mongodb.net.cn) | [直译官网MongoDB手册 4.2版本](https://docs.mongoing.com/mongodb-crud-operations) | [MongoDB中文社区](https://mongoing.com)

## 1. MongoDB 运维

## 1. 安装 MongoDB

### 1.1. Mac 安装 MongoDB

```shell
# 安装mongodb数据库
brew tap mongodb/brew
brew install mongodb-community@4.4
# 启动服务
brew services start mongodb-community@4.4
# ps 查看服务使用情况
ps aux | grep mongo
# brew services 查看服务使用情况
brew services | grep mongo
```

## 2. MongoDB 配置文件说明

```yaml
storage:
  # mongod 进程存储数据目录，此配置仅对 mongod 进程有效
  dbPath: /data/mongodb/db
  # 是否开启 journal 日志持久存储，journal 日志用来数据恢复，是 mongod 最基础的特性，通常用于故障恢复。64 位系统默认为 true，32 位默认为 false，建议开启，仅对 mongod 进程有效。
  journal:
    enabled: true
 # 存储引擎类型，mongodb 3.0 之后支持 “mmapv1”、“wiredTiger” 两种引擎，默认值为“mmapv1”；官方宣称 wiredTiger 引擎更加优秀。
  engine: wiredTiger
    # 如下配置仅对 wiredTiger 引擎生效（3.0 以上版本）  
    wiredTiger:
      # wiredTiger 缓存工作集（working set）数据的内存大小，单位：GB
      # 此值决定了 wiredTiger 与 mmapv1 的内存模型不同，它可以限制 mongod 对内存的使用量，而 mmapv1 则不能（依赖于系统级的 mmap）。默认情况下，cacheSizeGB 的值为假定当前节点只部署一个 mongod 实例，此值的大小为物理内存的一半；如果当前节点部署了多个 mongod 进程，那么需要合理配置此值。如果 mongod 部署在虚拟容器中（比如，lxc，cgroups，Docker）等，它将不能使用整个系统的物理内存，则需要适当调整此值。默认值为物理内存的一半。
      engineConfig:
          cacheSizeGB: 5

systemLog:
  # 日志输出目的地，可以指定为 “file” 或者“syslog”，表述输出到日志文件，如果不指定，则会输出到标准输出中（standard output）
  destination: file
  # 如果为 true，当 mongod/mongos 重启后，将在现有日志的尾部继续添加日志。否则，将会备份当前日志文件，然后创建一个新的日志文件；默认为 false。
  logAppend: true
  # 日志路径
  path: /var/log/mongodb/mongod.log

net:
 # 指定端口
  port: 27017
  # 绑定外网 op 多个用逗号分隔
  bindIp: 0.0.0.0
  maxIncomingConnections: 10000
```

## 3. 用户管理

### 3.1. 创建root账号

```shell
# 切换数据库
use admin
# 创建用户
db.createUser({user:"root",pwd:"root123",roles:[{role:"userAdminAnyDatabase",db:"admin"}]})
```

### 3.2. 调整配置文件

然后在配置文件中添加如下配置信息

```yaml
security:
  authorization: enabled
```

### 3.3. 重启mongodb服务

```shell
brew services restart mongodb
```

## 4. 基础理论描述

> **ObjectId 值是 12 字节的十六进制值**，包括：
>
> - 一个 4 字节的时间戳值，表示 ObjectId 的创建，以 Unix 纪元以来的秒数为单位。
> - 一个 5 字节是一个随机值
> - 一个 3 字节递增计数器，初始化为随机值。

### 4.1. 数据类型

MongoDB支持以下数据类型:

- **String（字符串）**: mongodb中的字符串是UTF-8有效的。
- **Integer（整数）**: 存储数值。整数可以是32位或64位，具体取决于您的服务器。
- **Boolean（布尔）**: 存储布尔(true/false)值。
- **Double（双精度）**: 存储浮点值。
- **Min/ Max keys（最小/最大键）**: 将值与最低和最高BSON元素进行比较。
- **Arrays（数组）**: 将数组或列表或多个值存储到一个键中。
- **Timestamp（时间戳）**: 存储时间戳。
- **Object（对象）**: 嵌入式文档。
- **Null （空值）**: 存储Null值。
- **Symbol（符号）**: 与字符串相同，用于具有特定符号类型的语言。
- **Date（日期）**: 以UNIX时间格式存储当前日期或时间。
- **Object ID（对象ID）** : 存储文档ID。
- **Binary data（二进制数据）**: 存储二进制数据。
- **Code（代码）**: 将JavaScript代码存储到文档中。
- **Regular expression（正则表达式）**: 存储正则表达式



## 参考文档

- [mongodb配置文件详解](https://www.cnblogs.com/zhongguiyao/p/14148483.html)

