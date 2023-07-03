---
title: Maven框架 引入外部Jar
tags:
  - kafka
categories:
  - 技术
date: 2022-07-01 12:01:01
thumbnail:
---

> 首先描述一下，如果项目引入外部Jar，但是没有在Maven中进行控制，会出现什么问题。
>
> Maven 打包时，外部引入的Jar会检测不到，导致\*\*\*不存在的错误。

## step 1: pom.xml 逐个引入外部Jar包

```xml
<!--引入外部jar包-->
<dependency>
    <groupId>com.1</groupId>
    <artifactId>out-jar-1</artifactId>
    <version>1.45</version>
    <scope>system</scope>
    <systemPath>${project.basedir}/src/main/resources/lib/bcprov-jdk16-1.45.jar</systemPath>
</dependency>
<dependency>
    <groupId>com.2</groupId>
    <artifactId>out-jar-2</artifactId>
    <version>1.6</version>
    <scope>system</scope>
    <systemPath>${project.basedir}/src/main/resources/lib/commons-codec-1.6.jar</systemPath>
</dependency>
```

其中 groupId 和 artifactId 可以随便填，注意 artifactId 不要重复了，version 版本号jar包是什么版本就是什么版本，否则可以随便填。

## step 2: 如果是SpringBoot项目还要加如下配置

```xml
<plugin>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-maven-plugin</artifactId>
    <configuration>
        <fork>true</fork>
        <includeSystemScope>true</includeSystemScope>
    </configuration>
</plugin>
```

## 参考文档

- [maven项目打包时外部引入jar包无法打到项目中的解决方案](https://blog.csdn.net/weixin_42135693/article/details/106643695)
