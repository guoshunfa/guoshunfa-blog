---
title: Redis 错误日志记录
tags:
  - redis
  - 错误
  - 记录
categories:
  - 技术
date: 2022-07-01 12:01:01
thumbnail:
---
#### WRONGPASS invalid username-password pair or user is disabled.

**日志描述：**用户密码错误。

**解决方案：**

```shell
# 设置密码为panda
config set requirepass panda
# 使用密码
auth panda
```

日志输出 `OK` ，便成功。

#### (error) MISCONF Redis is configured to save RDB snapshots, but is currently not able to persist on disk. Commands that may modify the data set are disabled. Please check Redis logs for details about the error．

**日志描述：**（错误）misconf redis被配置以保存数据库快照，但misconf redis目前不能在硬盘上持久化。用来修改数据集合的命令不能用，请使用日志的错误详细信息。

**原因**：这是由于强制停止redis快照，不能持久化引起的，运行info命令查看redis快照的状态

**解决方案：**

连接redis后运行　config set stop-writes-on-bgsave-error no　命令

关闭配置项stop-writes-on-bgsave-error解决该问题。

