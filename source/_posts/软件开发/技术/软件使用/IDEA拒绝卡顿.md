---
title: IDEA 拒绝卡顿
tags:
  - IDEA
categories:
  - 软件使用
date: 2022-07-01 12:01:01
thumbnail:
---

# IDEA - 拒绝卡顿

在同样内存的电脑，为什么别人能启动10个Java程序，而你只能启动5个。

其实他们改了下面这些配置。

## 1. Java程序启动配置

给每一个启动服务，都配置一下vm options，合理的降低每个服务占用的资源。

下面进行调整，首先要找到“运行配置模版”选项。

![image-20220925211351004](https://file.pandacode.cn/blog/202209252113044.png)

选择SpringBoot，将vm options填入。`-Xms100m -Xmx100m -XX:+PrintGCDetails -XX:+PrintGCTimeStamps`

添加完默认值后，以后创建的Springboot运行配置，都会默认是这个。

<img src="https://file.pandacode.cn/blog/202209252122856.png" alt="image-20220925212248817" style="zoom:50%;" /> 

## 2. 调整idea vm options

idea默认的vm options，会占用很大的资源。这里进行合理的调整

![image-20220925212549487](https://file.pandacode.cn/blog/202209252125550.png)

将这两项配置调整为：

```vmoptions
-Xmx1024m
-Xms1024m
```

