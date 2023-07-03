---
title: Oracle 介绍
tags:
    - oracle
    - 介绍
categories:
    - 技术
date: 2022-07-01 12:01:01
thumbnail:
---

## 1. Oracle 安装

### 1.1. Docker 快捷安装

> 还没有安装docker服务的，请跳转到[Docker - 介绍](/pages/b54954/)章节。

1. 拉取oracle镜像

```sh
docker pull registry.cn-hangzhou.aliyuncs.com/helowin/oracle_11g
```

2. 安装oracle容器

```sh
docker run -dp 9090:8080 -p 1521:1521 registry.cn-hangzhou.aliyuncs.com/helowin/oracle_11g
```

> 初始用户名密码：system/helowin；服务名：helowin

## 参考文章

- [Mac 上如何安装 Oracle 客户端？](https://www.zhihu.com/question/19629769)