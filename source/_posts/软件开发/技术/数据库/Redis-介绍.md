---
title: Redis 介绍
tags:
  - redis
  - 介绍
categories:
  - 技术
date: 2022-07-01 12:01:01
thumbnail:
---

> [redis 官方文档](https://redis.io/docs/) | [redis 中文网](https://www.redis.net.cn/)

## 1. Mac 系统安装Reids

### 1.1. 安装Homebrew

如果已经安装可以忽略，没有安装的请查看小明之前写好的文章 [mac安装homebrew](https://link.juejin.cn/?target=https%3A%2F%2Fmp.weixin.qq.com%2Fs%2Fa454PtDeCtqWykd2uqP0ig)

### 1.2. 使用Homebrew安装Redis

#### 1.2.1. 安装命令

```shell
brew install redis
```

#### 1.2.2.  查看软件安装及配置文件位置

Homebrew安装的软件会默认在`/usr/local/Cellar/`路径下；

redis的配置文件`redis.conf`存放在`/usr/local/etc`路径下。

#### 1.2.3. 启动redis服务

###### 1.2.3.1. 方法一：

brew除了可以帮助我们安装软件以外，还可以帮助我们启动软件

```shell
brew services start redis
```

###### 1.2.3.2. 方法二：

```shell
redis-server /usr/local/etc/redis.conf
```

#### 1.2.4. 查看redis服务进程

我们可以通过下面命令查看redis是否正在运行

```shell
ps axu | grep redis
```

#### 1.2.5. redis-cli连接redis服务

redis默认端口号**6379**，默认**auth**为空，输入以下命令即可连接

```shell
redis-cli -h 127.0.0.1 -p 6379
```

#### 1.2.6. 关闭redis服务

优雅的关闭`redis-cli shutdown`或者杀死`sudo pkill redis-server`

#### 1.2.7. redis.conf配置文件说明

redis默认是前台启动，如果我们想以守护进程的方式运行（后台运行），可以在**redis.conf**中将`daemonize no`,修改成`yes`即可。



## Linux 系统

### [Linux安装Redis](https://blog.csdn.net/m0_37959155/article/details/108897863)

