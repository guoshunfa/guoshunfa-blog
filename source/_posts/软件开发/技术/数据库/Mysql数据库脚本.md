---
title: Mysql数据库脚本
tags:
  - mysql
  - sql
  - 脚本
categories:
  - 技术
date: 2022-07-01 10:59:54
thumbnail:
---

假设内容如下：

```sql
create database pandacode;
use pandacode;
create table panda (name varchar(20));
```

保存脚本文件，/Users/guoshunfa/Downloads/pandacode.sql。

## 执行sql脚本

### 第一种方法

在命令行下(未连接数据库)，输入 mysql -h localhost -u root -p123456 < /Users/guoshunfa/Downloads/pandacode.sql (注意路径不用加引号的!!) 回车即可。

### 第二种方法

在命令行下(已连接数据库,此时的提示符为 mysql> )，输入 source /Users/guoshunfa/Downloads/pandacode.sql (注意路径不用加引号的) 或者 \. F:\hello world\niuzi.sql (注意路径不用加引号的) 回车即可

## 参考文档

- [mysql下如何执行sql脚本](https://www.cnblogs.com/kenkofox/archive/2011/01/14/1935422.html)