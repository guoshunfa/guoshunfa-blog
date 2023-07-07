---
title: Docker 问题记录
tags:
    - Docker
categories:
    - 服务&组件
date: 2022-07-01 12:01:01
thumbnail:
---

> 记录遇见过的bug

## 1. docker容器自动退出的问题

容器经常用了一段时间就自动退出了，docker ps已经找不到了，在docker ps -a里面了。

**问题思路**：docker run指定的命令如果不是那些一直挂起的命令（比如运行top，不断echo），就是会自动退出的。-d命令是设置detach为true，根据官方的文档，意思是让这个命令在后台运行，但并不是一直运行，Docker容器后台运行,就必须有一个前台进程。主线程结束，容器会退出。

我们启动容器的时候不要-d命令启动，用-dit就好了

例如：

docker run -d hello-world(不要这么做)

docker run -dit hello-world(推荐)   

