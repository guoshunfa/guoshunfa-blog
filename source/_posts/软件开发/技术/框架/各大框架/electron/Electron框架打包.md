---
title: Electron框架 打包
tags:
  - kafka
categories:
  - 技术
date: 2022-07-01 12:01:01
thumbnail:
---

## 1. electron-packager 打包

命令说明：

```shell
electron-packager <location of project> <name of project> <platform> <architecture> <electron version> <optional options>
```

- location of project：项目所在路径
- name of project：打包的项目名字
- platform：确定了你要构建哪个平台的应用（Windows、Mac 还是 Linux），可用值：darwin、linux、mas、win32。
- architecture：决定了使用 x86 还是 x64 还是两个架构都用 （x64,ia32）
- electron version：electron 的版本
- optional options：可选选项（ --overwrite覆盖原文件）
- | --out 输出目录
- | --extra-resource 需要打包的外部资源
- overwrite：已有打包文件则替换。

例：

```shell
electron-packager ./ pandacode --platform=mas --arch=x64 --overwrite
```

