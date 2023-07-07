---
title: Docker 介绍
tags:
    - Docker
categories:
    - 服务&组件
date: 2022-07-01 12:01:01
thumbnail:
---

> [docker 库](https://hub.docker.com) | [docker 官方文档](https://docs.docker.com/)

## 1. 简介

Docker是一个开源的引擎，可以轻松的为任何应用创建一个轻量级的、可移植的、自给自足的容器。开发者在笔记本上编译测试通过的容器可以批量地在生产环境中部署，包括VMs（虚拟机）、bare metal、OpenStack 集群和其他的基础应用平台。

Docker是一个开源的引擎，可以轻松的为任何应用创建一个轻量级的、可移植的、自给自足的容器。开发者在笔记本上编译测试通过的容器可以批量地在生产环境中部署，包括VMs（虚拟机）、 [bare metal](http://www.whatis.com.cn/word_5275.htm)、OpenStack 集群和其他的基础应用平台。 

## 2. 适用场景

Docker通常用于如下场景：

- web应用的自动化打包和发布；
- 自动化测试和持续集成、发布；
- 在服务型环境中部署和调整数据库或其他的后台应用；
- 从头编译或者扩展现有的OpenShift或Cloud Foundry平台来搭建自己的PaaS环境。

## 3. 安装

### 3.1. 使用yum安装

```shell
yum update # 更新yum
yum install docker # 安装docker
systemctl start docker.service # 启动docker
docker version # 查看docker版本，验证是否安装成功
sudo systemctl enable docker # 设置开机自启动
# 结束
```

### 3.2. 使用brew安装

```sh
 brew install --cask --appdir=/Applications docker
```

> mac的安装，执行完命令后需要打开docker的App，授权后才能使用。
