---
title: Java Decompiler反编译工具
tags:
  - kafka 
categories:
  - 技术
date: 2022-07-01 12:01:01
thumbnail:
---

> Jar/class 反编译工具。

## 1. Idea 下载反编译插件

插件名称：Java Bytecode Decompiler或Java Decompiler。

## 2. 运行

插件下载成功后，找到对应的插件Jar包。

**Mac系统的插件地址：**`/Applications/IntelliJ\ IDEA.app/Contents/plugins/java-decompiler/lib`

#### 2.1. 命令运行

```shell
oracle-java -cp "/Applications/IntelliJ IDEA.app/Contents/plugins/java-decompiler/lib/java-decompiler.jar" org.jetbrains.oracle-java.decompiler.main.decompiler.ConsoleDecompiler -dgs=true rt.jar rt
```

#### 2.2. 命令描述

`/Applications/IntelliJ IDEA.app/Contents/plugins/java-decompiler/lib/java-decompiler.jar` : 反编译插件包地址。

`rt.jar` : 需要进行反编译的Jar文件地址。

`rt` : 反编译后文件存放地址。

## 3. 结果

命令执行成功之后会生成一个Jar文件，通过解压工具解压后就可以食用了。原本编译后的class文件都已经反编译成了java文件。

<img src="https://file.pandacode.cn//blog/202109111304689.png" alt="image-20210902101754396" style="zoom:50%;" />
