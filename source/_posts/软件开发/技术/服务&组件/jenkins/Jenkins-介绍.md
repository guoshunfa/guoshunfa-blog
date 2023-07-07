---
title: Jenkins 介绍
tags:
    - Jenkins
categories:
    - 服务&组件
date: 2022-07-01 12:01:01
thumbnail:
---

> [Jenkins](https://www.w3cschool.cn/jenkins/)是一个独立的开源自动化服务器，可用于自动化各种任务，如构建，测试和部署软件。Jenkins可以通过本机系统包[Docker安装](https://www.w3cschool.cn/docker/)，甚至可以通过安装Java Runtime Environment的任何机器独立运行。
>
> [Jenkins持续集成从入门到精通](https://file.pandacode.cn/blog/20211217154805.pdf)

## 1. Jenkins 服务安装/启动

### 1.1. 前提

需要有JDK环境。

### 1.2. Linux 系统 Jenkins服务安装/启动

```sh
# 更新库
sudo apt-get update
# 安装jenkins
sudo apt-get install jenkins
# 注册jenkins服务
sudo systemctl daemon-reload
# 启动jenkins服务
sudo systemctl start jenkins
# 查看jenkins服务状态
sudo systemctl status jenkins
# 重启jenkins服务
sudo systemctl restart jenkins
# 关闭jenkins服务
sudo systemctl stop jenkins
```

### 1.2.1. Linux 系统 Jenkins服务卸载

```sh
# 卸载服务
sudo apt-get remove jenkins
# 卸载安装包，注意这里如果不是ubuntu那就yum
sudo apt-get remove --auto-remove jenkins
# 卸载配置和数据
sudo apt-get purge jenkinssudo apt-get purge --auto-remove jenkins
```

## 2. 任务创建

### 2.1. 只是将jenkins作为一个部署平台

> 只是将jenkins作为一个部署平台，内部还是调用的shell脚本。

1). 新建任务

<img src="https://file.pandacode.cn/blog/20211217161320.png" alt="image-20211117153259999" style="zoom:50%;" /><img src="https://file.pandacode.cn/blog/20211217161355.png" alt="image-20211117153342410" style="zoom:30%;" />

2). 选择构建 -> 点击执行shell

<img src="https://file.pandacode.cn/blog/20211217161413.png" alt="image-20211117153447192" style="zoom:50%;" />

3). 输入准备执行的脚本。点击保存。

<img alt="image-20211117153541426" src="https://file.pandacode.cn/blog/20211217161433.png" style="zoom:50%;"/>

4). 保存后在首页能看到panda-doc任务，点击最右的运行按钮。

<img src="https://file.pandacode.cn/blog/20211217161448.png" alt="image-20211117153814602" style="zoom:50%;" />

5). 点击名称(panda-doc)进入详情，再点击左下角的任务进度区域，查看任务进度。

<img src="https://file.pandacode.cn/blog/20211217161503.png" alt="image-20211117153927516" style="zoom:50%;" />

6). 点击控制台输出即可查看shell脚本的运行情况。

<img src="https://file.pandacode.cn/blog/20211217161519.png" alt="image-20211117154049732" style="zoom:50%;" />

7). 脚本执行完后可以在首页查看脚本运行情况。

<img src="https://file.pandacode.cn/blog/20211217161541.png" alt="image-20211117154335171" style="zoom:50%;" />

## 参考文档

- [Jenkins 官网](https://www.jenkins.io/)
