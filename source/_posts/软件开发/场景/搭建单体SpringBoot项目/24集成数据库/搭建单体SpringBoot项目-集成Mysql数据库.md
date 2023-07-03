---
title: 搭建单体SpringBoot项目 集成Mysql数据库
tags:
    - SpringBoot
    - 集成
    - mysql
    - 数据库
categories:
    - 技术
    - 搭建单体SpringBoot项目
date: 2022-07-01 12:01:01
thumbnail:
---`

## 1. SpringBoot框架集成Mysql

### 1.1. 引入mysql maven包

```xml
 <!--集成mysql数据库-->
<dependency>
  <groupId>mysql</groupId>
  <artifactId>mysql-connector-java</artifactId>
</dependency>

<dependency>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-jdbc</artifactId>
</dependency>
<!-- 数据库连接池 -->
<dependency>
  <groupId>com.alibaba</groupId>
  <artifactId>druid-spring-boot-starter</artifactId>
</dependency>
```

### 1.2. 添加数据库配置

> druid配置请前往：[Druid数据库连接池和监控](/pages/9dc827/)

在spring boot项目的配置文件application.properties中添加如下配置：

```properties
spring.datasource.druid.url=jdbc:mysql://127.0.0.1:3306/db?useUnicode=true&characterEncoding=utf-8&useSSL=false
spring.datasource.druid.username=root
spring.datasource.druid.password=pandacode
spring.datasource.druid.max-active=20
spring.datasource.druid.initial-size=5
spring.datasource.druid.min-idle=5
spring.datasource.druid.min-evictable-idle-time-millis=300000
spring.datasource.druid.max-wait=60000
spring.datasource.druid.validation-query=select 1
spring.datasource.druid.test-on-borrow=false
spring.datasource.druid.test-on-return=false
spring.datasource.druid.test-while-idle=true
spring.datasource.druid.time-between-eviction-runs-millis=60000
```

