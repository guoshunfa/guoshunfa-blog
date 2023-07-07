---
title: SpringBoot框架 引入外部Jar包
tags:
  - SpringBoot
  - Jar
categories:
  - 软件技术框架
date: 2022-07-01 12:01:01
thumbnail:
---



转载自：https://blog.csdn.net/m0_67401746/article/details/124035099

> 在项目中，有时候需要引入外部jar包，启动运行。有两种方式，一种是直接在项目中添加jar包，另一种是在本地maven仓库中添加jar包，然后在pom.xml文件中引入依赖。

## 第一种方式：在项目中添加jar包

step1：在src/main/resources下创建lib目录，然后将jar包放在该目录下

step2：然后在project structure中引入该lib

## 第二种方式：在pom.xml文件中引入外部jar包

step1：通过命令行方式，在本地maven仓库中添加jar包

打开cmd，执行mvn命令

`mvn install:install-file -DgroupId=com.awen.testjar -DartifactId=awen-testjar -Dversion=1.0 -Dpackaging=jar -Dfile=D:developawen-testjar.jar`

DgroupId：建议为包路径

DartifactId：jar包名称

Dversion：jar包版本号

Dpackaging：jar

Dfile：本地jar包地址



step2：在pom.xml文件中引入该依赖

com.awen.testjar

awen-testjar

1.0
