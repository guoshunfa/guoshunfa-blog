---
title: MongoDB执行JS脚本
tags:
  - MongoDB
  - 脚本
  -	HTML/CSS/JavaScript
categories:
  - 数据库
date: 2022-07-01 11:05:39
thumbnail:
---
> 可以使用大多数js语法。

## 脚本执行方法

**第一种：**

1. 进入shell。
2. 输入：mongo 脚本路径。（脚本内部需要先连接数据库。）

例：

```shell
mongo /Users/guoshunfa/Desktop/test.js
```

**第二种：**

1. 进入shell。
2. 进入mongodb控制台。输入：mongo。
3. 选择数据库。输入：use 数据库名。（非必需，可以通过脚本选择数据库。）
4. 加载脚本。输入：load(' 脚本路径 ')。

例：

```shell
> use test
switched to db test
> load('/Users/guoshunfa/Desktop/test.js ')
```

## 语法

### 数据库连接相关语法

| 描述             | 语法                                         |
| ---------------- | -------------------------------------------- |
| 连接mongo        | const conn = new Mongo('localhost:27017')    |
| 连接数据库       | let db = conn.getDB('test')                  |
| 切换数据库       | db = db.getSiblingDB('test')                 |
| 显示所有的数据库 | const dbs = db.adminCommand('listDatabases') |

### 日志打印语法

| 描述               | 语法                       |
| ------------------ | -------------------------- |
| 控制台打印         | print('显示所有的数据库:') |
| json形式控制台打印 | printjson(*)               |
|                    |                            |



