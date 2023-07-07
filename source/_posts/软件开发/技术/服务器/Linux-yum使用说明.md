---
title: Linux yum使用说明
tags:
  - linux
  - yum
categories:
  - 服务器管理
date: 2022-07-01 11:09:31
thumbnail:
---
## 一、Yum 简介

Yum（全称为 Yellow dog Updater, Modified）是一个在Fedora和RedHat以及CentOS中的Shell前端软件包管理器。基于RPM包管理，能够从指定的服务器自动下载RPM包并且安装，可以自动处理依赖性关系，并且一次安装所有依赖的软件包，无须繁琐地一次次下载、安装。

## 二、命令记录

| 命令                    | 命令描述                                                     | 示例                 |
| ----------------------- | ------------------------------------------------------------ | -------------------- |
| `yum list installed`    | 显示已经安装的软件包。                                       | `yum list installed` |
| `yum list [package]`    | 查找可以安装的软件包，package替代为查询的软件包。            | `yum list tomcat`    |
| `yum install [package]` | 安装软件包，package替代为查询的软件包。-y自动应答yes，命令执行过程中会让用户选择是否要继续，-y自动应答yes，例子：`yum -y install tomcat` | `yum install tomcat` |
| `yum remove [package]`  | 卸载软件包，package替代为查询的软件包。                      | `yum remove tomcat`  |
| `yum deplist [package]` | 列出软件包的依赖，package替代为查询的软件包。                | `yum deplist tomcat` |
| `yum info [package]`    | info 显示软件包的描述信息和概要信息，package替代为查询的软件包。 | `yum info tomcat`    |
| `yum update`            | 升级所有的软件包                                             | `yum update`         |
| `yum update [package]`  | 升级某一个软件包 ，package替代为查询的软件包。               | `yum update tomcat`  |
| `yum check-update`      | 检查可更新的程序。                                           | `yum check-update`   |



## 参考文档

- [Yum 安装、卸载软件](https://blog.csdn.net/weixin_43025071/article/details/108464547)
