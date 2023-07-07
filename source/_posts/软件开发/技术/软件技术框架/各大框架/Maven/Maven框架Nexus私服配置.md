---
title: Maven框架 Nexus私服配置
tags:
  - Maven
  -	Nexus
categories:
  - 软件技术框架
date: 2022-07-01 12:01:01
thumbnail:
---

> Nexus 安装请查看 [进入](/pages/da781f/)

## 1. 上传项目到私服上去

### 1.1. 配置setting.xml

**demo:**
```xml
<?xml version="1.0" encoding="UTF-8"?>

<settings xmlns="http://maven.apache.org/SETTINGS/1.2.0"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.2.0 http://maven.apache.org/xsd/settings-1.2.0.xsd">
    <!-- 本地仓库的路径。默认值为${user.home}/.m2/repository。 -->
    <localRepository>/Library/work/java/apache-maven-3.6.3/resource</localRepository>
    <servers>
        <server>
            <id>nexus</id>
            <username>admin</username>
            <password>admin123</password>
        </server>
        <server>
            <id>releases</id>
            <username>admin</username>
            <password>admin123</password>
        </server>
        <server>
            <id>snapshots</id>
            <username>admin</username>
            <password>admin123</password>
        </server>
        <server>
            <id>thirdparty</id>
            <username>admin</username>
            <password>admin123</password>
        </server>
    </servers>

    <mirrors>
        <mirror>
            <!--该镜像的唯一标识符。id用来区分不同的mirror元素。
                maven会根据id对镜像排序，当前一个镜像不可用时，连接后一个镜像
            -->
            <id>nexus</id>
            <mirrorOf>*</mirrorOf>
            <url>http://127.0.0.1:8081/nexus/content/groups/public/</url>
        </mirror>
        <mirror>
            <id>repo2</id>
            <mirrorOf>central</mirrorOf>
            <name>Human Readable Name for this Mirror.</name>
            <url>https://repo1.maven.org/maven2/</url>
        </mirror>
    </mirrors>
    <profiles>
        <profile>
            <id>nexus</id>
            <repositories>
                <repository>
                    <id>maven-public</id>
                    <url>http://127.0.0.1:8081/nexus/content/groups/public/</url>
                    <releases>
                        <enabled>true</enabled>
                    </releases>
                    <snapshots>
                        <enabled>true</enabled>
                    </snapshots>
                </repository>
            </repositories>

            <pluginRepositories>
                <pluginRepository>
                    <id>maven-public</id>
                    <url>http://127.0.0.1:8081/nexus/content/groups/public/</url>
                    <releases>
                        <enabled>true</enabled>
                    </releases>
                    <snapshots>
                        <enabled>true</enabled>
                    </snapshots>
                </pluginRepository>
            </pluginRepositories>
        </profile>
    </profiles>
    <activeProfiles>
        <activeProfile>nexus</activeProfile>
    </activeProfiles>
</settings>
```

### 1.2. 配置项目pom.xml

```xml
<distributionManagement>
    <repository>
        <id>nexus</id>
        <name>Releases</name>
        <url>http://127.0.0.1:8081/nexus/content/repositories/releases/</url>
    </repository>
    <snapshotRepository>
        <id>nexus</id>
        <name>Snapshot</name>
        <url>http://127.0.0.1:8081/nexus/content/repositories/snapshots/</url>
    </snapshotRepository>
</distributionManagement>
```

### 1.3. 上传

**deploy** maven项目即可。

<img src="https://file.pandacode.cn/blog/20211224163828.png" width="50%" height="50%"  />

## 参考资料
- [Maven私服Nexus的搭建和使用](https://blog.csdn.net/krauser1991/article/details/78958859)
