---
title: Mac 问题记录
tags:
  - mac
  - 问题
  - 记录
categories:
  - 技术
date: 2022-07-01 11:11:58
thumbnail:
---
## 1. 磁盘

### 1.1. 磁盘装载问题

移动硬盘或u盘由于错误插拔而导致Mac无法识别的简单急救，修复。

#### 1.1.1. 使用命令装载

```sh
# 查看磁盘状态，找到没有装载的磁盘
diskutil list
# 挂载，这里的/dev/disk2是我没有装载的磁盘
sudo diskutil mount /dev/disk2
```

## 2. 应用

### 2.1. MAC打开软件报错：无法验证开发者的解决方法
使用下面这条命令进行授权：
```shell
sudo spctl --master-disable
```

## 3. 资源

### 3.1.资源文件重新加载

```shell
source ~/.bash_profile
```

