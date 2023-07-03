---
title: 搭建单体SpringBoot项目 集成Profile项目环境管理
tags:
    - SpringBoot
    - 集成
    - Profile
categories:
    - 技术
    - 搭建单体SpringBoot项目
date: 2022-07-01 12:01:01
thumbnail:
---

> 项目多环境管理

## 1. Spring Profile

Spring Profile 是 Spring 提供的多环境管理方案。

<img src="https://file.pandacode.cn/blog/20211225125640.png" width="40%" height="40%"  />

如图，每种环境都对应一个 properties 文件，然后在application.properties中配置一下要使用的环境

```properties
spring.profiles.active=dev
```

上面配置匹配的是 application-dev.properties,如果写的是test，则匹配 application-test.properties。
也就是说，Spring Profile 对配置文件的命名有要求，必须是 application- 开头 

除了配置环境外，一些不随环境而变化的配置也应该放到 application.properties中，application-.properties最好只存放与环境相关的配置项
以上就是 Spring Profile 给出的多环境管理方案。

通过改变 spring.profiles.active的值来切换不同的环境。

**这种方法简单易懂，但有两个问题。**

1. 每次切换环境要手动修改 spring.profiles.active 的值
2. 打包的时候，要手动删除其它环境的配置文件，不然其它环境的敏感信息就都打包进去了

## 2. maven profile

maven 的 profile 可以让我们定义多套配置信息，并指定其激活条件，然后在不同的环境下使用不同的profile配置。

### 2.1. profile 的定义位置
在maven中有两个地方可以配置 profile

pom.xml中：这里面定义的 profile 作用范围是当前项目
{user}/.m2/settings.xml中：这里面定义的 profile 作用范围是所有使用了该配置文件的项目

### 2.2. settings.xml中的 profile
不同的地方 profile 中能定义的信息也不相同

由于settings.xml作用范围宽泛， profile 中只能定义一些公共信息，如下

```xml
<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0
https://maven.apache.org/xsd/settings-1.0.0.xsd">
...
    <profiles>
        <profile>
        <id>...</id>
        <activation>...</activation>
        <repositories>...</repositories>
        </profile>
    </profiles>
...
</settings>
```

id：该 profile 的唯一标识
activation：在哪些情况下激活 profile,这里面有多种策略可供选择,只要满足其中一个条件就激活
repositories：远程仓库

由于能配置的东西有限，一般都会将 maven profile 配置在pom.xml

### 2.3. pom.xml中 的profile

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-parent</artifactId>
        <version>2.0.6.RELEASE</version>
        <relativePath/>
    </parent>
    <groupId>com.panda</groupId>
    <artifactId>test-mongodb</artifactId>
    <version>0.0.1-SNAPSHOT</version>
    <packaging>war</packaging>
    <name>test-mongodb</name>
    <description>test-mongodb</description>
    <properties>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    </properties>
    <build>
        <filters> <!-- 指定使用的 filter,会在每个module中使用，所以文件目录需要指向到顶层，否则会在每个module中查找文件 -->
            <!-- 文件按顺序加载，后面的相同key覆盖前面的，base用于默认配置 -->
            <filter>profile/base.pro</filter>
            <filter>profile/${env}.pro</filter>
        </filters>
        <resources>
            <resource>
                <directory>src/main/resources</directory>
                <filtering>true</filtering>
            </resource>
        </resources>
        <defaultGoal>clean compile package deploy</defaultGoal>
    </build>
    <profiles>
        <!-- 开发环境 -->
        <profile>
            <id>dev</id>
            <activation>
                <activeByDefault>true</activeByDefault>
            </activation>
            <properties>
                <env>dev</env>
            </properties>
        </profile>
        <!-- 测试环境 -->
        <profile>
            <id>test</id>
            <properties>
                <env>test</env>
            </properties>
        </profile>
    </profiles>
</project>
```

### 2.4. 按环境打包

```shell
# -P 环境
mvn clean package -P test
```
