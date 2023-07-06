---
title: SpringBoot框架 基础知识
tags:
  - springboot
categories:
  - 技术
date: 2022-07-01 12:01:01
thumbnail:
---

## SpringBoot 项目搭建介绍

### 父子项目搭建

#### 搭建流程

1. 创建多个springboot项目

2. 配置父项目pom

```xml
<modelVersion>4.0.0</modelVersion>
<parent>
<groupId>org.springframework.boot</groupId>
<artifactId>spring-boot-starter-parent</artifactId>
<version>2.3.2.RELEASE</version>
<relativePath/> 
</parent>
<!--包名-->
<groupId>com.gsf</groupId>
<!--项目名称-->
<artifactId>gsf-parent</artifactId>
<!--版本-->
<version>0.0.1-SNAPSHOT</version>
<!--打包方式，pom为父项目-->
<packaging>pom</packaging>
<properties>
<java.version>1.8</java.version>
</properties>
```

3. 配置子项目pom

```xml
<!--继承父级-->
<parent>
  <!--父项目名-->
<artifactId>gsf-parent</artifactId>
  <!--父项目包名-->
<groupId>com.gsf</groupId>
  <!--父项目版本号-->
<version>0.0.1-SNAPSHOT</version>
</parent>
<modelVersion>4.0.0</modelVersion>
<!--指定打包类型-->
<packaging>jar</packaging>
<!--项目名称-->
<artifactId>gsf-run</artifactId>
<!--项目包名-->
<groupId>com.gsf</groupId>
<!--版本号-->
<version>1.0.0-SNAPSHOT</version>
<name>gsf-run</name>
```

#### 描述

1. 父项目所引入的依赖，子项目可以使用。
