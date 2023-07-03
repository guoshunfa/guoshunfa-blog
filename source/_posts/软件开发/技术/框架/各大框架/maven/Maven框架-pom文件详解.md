---
title: Maven框架 pom文件详解
tags:
  - kafka
categories:
  - 技术
date: 2022-07-01 12:01:01
thumbnail:
---

> [maven仓库官网](https://mvnrepository.com)

## 1. 简单介绍

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    
    <!-- pom模型版本 -->
    <modelVersion>4.0.0</modelVersion>
    
    <!-- 项目信息 -->
    <groupId>com.panda</groupId><!-- 包名 -->
    <artifactId>pandacode</artifactId><!-- 项目名 -->
    <version>0.0.1-SNAPSHOT</version><!-- 版本 -->
    <packaging>jar</packaging><!-- 打包方式 （pom,war,jar） -->

    <name>springboot</name><!-- 项目的名称， Maven 产生的文档用 -->
    <description>Demo project for Spring Boot</description><!-- 项目的描述, Maven 产生的文档用 -->

    <!-- 父级项目 -->
    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>1.5.7.RELEASE</version>
        <relativePath/> <!-- lookup parent from repository -->
    </parent>
    
    <!-- 属性设置 -->
    <properties>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding><!-- 编译字符编码为utf-8 -->
        <project.reporting.outputEncoding>UTF-8</project.reporting.outputEncoding><!-- 输出字符编码为UTF-8  -->
        <java.version>1.8</java.version><!-- jdK版本 -->
    </properties>
    
    <!-- 依赖关系 -->
    <dependencies>
        <!-- 测试 -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
        </dependency>
        <!-- springmvc -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
        <!-- jpa(持久层) -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-data-jpa</artifactId>
        </dependency>
        <!-- mysql(数据库) -->
        <dependency>
            <groupId>mysql</groupId>
            <artifactId>mysql-connector-java</artifactId>
            <scope>runtime</scope>
        </dependency>
    </dependencies>
  <!-- 统一版本控制 -->
  <dependencyManagement>
    <dependencies>
      <dependency>
        <groupId>mysql</groupId>
        <artifactId>mysql-connector-java</artifactId>
        <scope>runtime</scope>
      </dependency>
    </dependencies>
  </dependencyManagement>
    
    <!-- 编译 -->
    <build>
        <!-- 插件 -->
        <plugins>
            <!-- maven插件 -->
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
            </plugin>
        </plugins>
    </build>
</project>
```

## 2. 详细描述

### 2.1. dependencyManagement节点

1. **dependencyManagement 应用场景**

​    Maven 使用dependencyManagement 元素来提供了一种**管理依赖版本号的方式**,通常会在一个组织或者项目的最顶层的POM中看到dependencyManagement 元素，在pom.xml 中使用dependencyManagement 元素能让所有**子项目**中引用一个依赖而**不用显式的列出版本号**。Maven 会沿着父子层次向上走，直到找到一个拥有dependencyManagement 元素的项目，然后它就会使用在这个dependencyManagement 元素中指定的**版本号**。

​    在 pom 中指明 dependency management 元素的方式 maven 结合项目继承来管理依赖，这样做的好处就是：如果有多个子项目都引用依赖项的同一版本，确保应用的各个项目的依赖项和版本一致，才能保证测试的和发布的是相同的成果，因此，应在顶层的 pom 中定义共同的依赖关系。同时可以避免在每个使用的子项目里都声明一个版本号，这样当想升级或切换到另一个版本时，只需要在顶层父容器里更新，而不需要一个一个子项目的修改；另外如果**某个子项目需要另外的一个版本，只需要在dependencies中声明version即可**。

2. **dependencyManagement和dependencies的区别**

**dependencies**，即使在子项目中不写该依赖项，那么子项目仍然会从父项目中继承该依赖项。**dependencyManagement里只是声明依赖，并不实现引入**，因此子项目需要显式的声明需要用的依赖。如果在子项目中不写该依赖项，那么子项目中是不会从父项目继承该依赖项的；**只有在子项目中写了该依赖项，并且没有指定具体版本，才会从父项目中继承该项，并且version 和 scope 都读取自父pom。**

