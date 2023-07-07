---
title: SpringBoot框架 启动时输出文案
tags:
  - SpringBoot
categories:
  - 软件技术框架
date: 2022-07-01 12:01:01
thumbnail:
---

# SpringBoot框架 - 启动时输出文案

SpringBoot在启动时，控制台会生成一个默认文案。其实是可以根据个人需要进行调整的。

下面是我调整后显示的内容。

![image-20221014132518798](https://file.pandacode.cn/blog/202210141325863.png)

调整的方式有很多，这里介绍一个最简单的方法。

1. 在application.properties同目录下创建一个文件：banner.txt。
2. 将你想要输出的文案，加入到banner.txt中。

这里提供一个线上banner生成网站：https://devops.datenkollektiv.de/banner.txt/index.html

![image-20221014132810997](https://file.pandacode.cn/blog/202210141328040.png)

将下面自动生成的文本，cv到banner.txt文件中，重启项目就可以看到变动。
