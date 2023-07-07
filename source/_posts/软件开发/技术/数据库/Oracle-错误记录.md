---
title: Oracle 错误记录
tags:
    - Oracle
categories:
    - 数据库
date: 2022-07-01 12:01:01
thumbnail:
---

## 错误：sqlplus: command not found

>  转载自：https://www.cnblogs.com/sprinng/p/6548540.html

```shell
# 调整成对应oracle地址
export ORACLE_BASE=/u01/app/oracle
# 注意调整对应版本
export ORACLE_HOME=$ORACLE_BASE/product/10.2.0/db_1
su - root
ln -s $ORACLE_HOME/bin/sqlplus /usr/bin
su - oracle
sqlplus /nolog
```

