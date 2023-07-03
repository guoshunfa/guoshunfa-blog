---
title: Maven框架 settings详解
tags:
  - maven
categories:
  - 技术
date: 2022-07-01 12:01:01
thumbnail:
---

## 1. 概述

### 1.1. 作用

用来设置Maven参数的配置文件，在Maven中提供了一个settings.xml文件来定义Maven的全局配置信息。我们通过这个文件来定义本地仓库、远程仓库和联网使用的代理信息等配置。

### 1.2. 文件位置

一般存在于两个位置：

全局配置：Maven的安装目录的conf子目录下面`（${M2_HOME}/conf/settings.xml）`
用户目录的的.m2子目录下面`（{user.home}/.m2/settings.xml）`。当前用户的独享配置。

当我们使用一些工具时（IDEA），可以直接指定settings.xml文件的位置。

### 1.3. 配置文件优先级

局部配置高于全局配置 配置优先级从高到低：`pom.xml> user settings > global settings`
如果这些文件同时存在，在应用配置时，会合并它们的内容，如果有重复的配置，优先级高的配置会覆盖优先级低的。

### 1.4. Maven依赖搜索顺序

当我们执行Maven命令时，maven开始按照以下顺序查找依赖库：

- 步骤 1：在本地仓库搜索，如果找不到，执行步骤 2，找到了则执行其他操作
- 步骤 2：在中央仓库搜索，如果找不到，并且有一个或多个远程仓库已经设置，则执行步骤 4，如果找到了则下载到本地仓库中引用。
- 步骤 3：如果远程仓库没有被设置, 将简单的停滞处理并抛出错误（无法找到依赖的文件）。
- 步骤 4：在一个或多个远程仓库中搜索依赖的文件, 如果找到则下载到本地仓库已被将来引用, 否则将停止处理并抛出错误（无法找到依赖的文件）。

## 2. 元素详解

### 2.1. 顶级元素

#### 2.1.1. LocalRepository

```xml
<!-- 作用：该值表示构建系统本地仓库的路径。 默认值：${user.home}/.m2/repository -->
<localRepository>${user.home}/.m2/repository</localRepository>
```

#### 2.1.2. InteractiveMode

```xml
<!-- 作用：表示maven是否需要和用户交互以获得输入。 默认值：true -->
<interactiveMode>true</interactiveMode>
```

#### 2.1.3. offline

```xml
<!-- 作用：表示maven是否需要在离线模式下运行。 默认值：false 当由于网络设置原因或者安全因素，构建服务器不能连接远程仓库的时候，该配置就十分有用。 -->
<offline>false</offline>
```

#### 2.1.4. pluginGroups

```xml
<!--
    作用：当插件的组织id（groupId）没有显式提供时，供搜寻插件groupId的列表。
    默认值：默认情况下，maven会自动把org.apache.maven.plugins和org.codehaus.mojo添加到pluginGroups下。
-->
<pluginGroups>
    <pluginGroup>com.your1.plugins</pluginGroup>
    <pluginGroup>com.your2.plugins</pluginGroup>
</pluginGroups>
```

#### 2.1.5. proxies

```xml
<!-- 作用：用来配置不同的代理, 多代理 profiles 可以应对笔记本或移动设备的工作环境: 通过简单的设置 profile id 就可以很容易的更换整个代理配置 -->
<!-- 可以配置多个 -->
<proxies>
    <!-- 代理元素包含配置代理时需要的信息 -->
    <proxy>
        <!-- 代理的唯一定义符, 用来区分不同的代理元素 -->
        <id>optional</id>
        <!-- 该代理是否是激活的那个。true则激活代理。当我们声明了一组代理, 而某个时候只需要激活一个代理的时候, 该元素就可以派上用处 -->
        <active>true</active>
        <!-- 代理的协议 -->
        <protocol>http</protocol>
        <!-- 代理服务器认证的登录名 -->
        <username>proxyuser</username>
        <!-- 代理服务器认证登录密码 -->
        <password>proxypass</password>
        <!-- 代理的主机名 -->
        <host>proxy.host.net</host>
        <!-- 代理的端口 -->
        <port>80</port>
        <!-- 不该被代理的主机名列表。该列表的分隔符由代理服务器指定；例子中使用了竖线分隔符, 使用逗号分隔也很常见 -->
        <nonProxyHosts>local.net|some.host.com</nonProxyHosts>
    </proxy>
</proxies>
```

#### 2.1.6. servers

```xml
<!-- 作用：进行远程服务器访问时所需的授权配置信息。通过系统唯一的 server id 进行唯一关联 注意：您应该指定用户名/密码或私钥/密码，因为这些配对是一起使用。 -->
<servers>
    <server>
        <!-- 服务的唯一定义符, 用来区分不同的代理元素 -->
        <id>deploymentRepo</id>
        <!-- 鉴权用户名 -->
        <username>repouser</username>
        <!-- 鉴权密码 -->
        <password>repopwd</password>
    </server>
    <server>
        <id>siteServer</id>
        <!-- 鉴权时的私钥位置 -->
        <privateKey>/path/to/private/key</privateKey>
        <!-- 鉴权时的私钥密码 -->
        <passphrase>optional; leave empty if not used.</passphrase>
    </server>
</servers>
```

#### 2.1.7. mirrors

```xml
<!--
作用：用于替代指定远程仓库的镜像服务器配置，例如当您无法连接上国外的仓库是, 可以指定连接到国内的镜像服务器，同时还可以缓解镜像仓库的压力 注意：pom.xml 和 setting.xml 中配置的仓库和镜像优先级关系（``
mirror优先级高于repository`） repository（setting.xml） < repository（pom.xml） < mirror（setting.xml） 
 
 mirror匹配顺序：
多个mirror按照id字母顺序进行排列，与编写顺序无关 在第一个mirror找不到artifact，不会继续找下一个镜像 只有当mirror无法链接的时候，才会尝试找下一个镜像，类似容灾备份
-->
<mirrors>
    <mirror>
        <!--该镜像的唯一标识符。id用来区分不同的mirror元素。  -->
        <id>mirrorId</id>
        <!--用来表示该mirror是关联的哪一个仓库，其值为其关联仓库的id。 -->
        <mirrorOf>repositoryId</mirrorOf>
        <!-- 镜像名称, 无特殊作用, 可视为简述 -->
        <name>Human Readable Name for this Mirror.</name>
        <!-- 镜像地址 -->
        <url>http://my.repository.com/repo/path</url>
    </mirror>
    <mirror>
        <id>aliyunmaven</id>
        <mirrorOf>*</mirrorOf>
        <name>阿里云公共仓库</name>
        <url>https://maven.aliyun.com/repository/public</url>
    </mirror>
</mirrors>
```

mirrorOf配置语法：

- *：匹配所有远程仓库。相当于一个拦截器，它会拦截远程仓库的相关请求，把请求里的远程仓库地址，重定向到mirror里配置的地址。
- external:* ： 匹配除 localhost、使用 file:// 协议外的所有远程仓库
- repo1,repo2：匹配仓库 repo1 和 repo2
- *,!repo1： 匹配所有远程仓库, repo1 除外

#### 2.1.7. profiles

作用：构建方法的配置清单, maven 将根据不同环境参数来使用这些构建配置。 注意：settings.xml 中的 profile元素是 pom.xml中 profile元素的裁剪版本。

- settings.xml负责的是整体的构建过程, pom.xml负责单独的项目对象构建过程。
- settings.xml 只包含了id, activation, repositories, pluginRepositories 和 properties 元素。
- 如果 settings中的 profile 被激活, 它的值会覆盖任何其它定义在 pom.xml中或 profile.xml中的相同 id 的 profile。

查看当前激活的 profile

```shell
mvn help:active-profiles 
```

```xml
<profiles>

    <profile>
        <!-- 该配置的唯一标识符 -->
        <id>jdk-1.4</id>

        <!--自动触发profile的条件逻辑。Activation是profile的开启钥匙。-->
        <!--如POM中的profile一样，profile的力量来自于它能够在某些特定的环境中自动使用某些特定的值；这些环境通过activation元素指定。-->
        <!--activation元素并不是激活profile的唯一方式。settings.xml文件中的activeProfile元素可以包含profile的id。-->
        <!--profile也可以通过在命令行，使用-P标记和逗号分隔的列表来显式的激活（如，-P test）。 -->
        <activation>
            <!--profile默认是否激活的标识 -->
            <activeByDefault>false</activeByDefault>
            <!--activation有一个内建的java版本检测，如果检测到jdk版本与期待的一样，profile被激活。 -->
            <jdk>1.4</jdk>
        </activation>

        <!--远程仓库列表，它是Maven用来填充构建系统本地仓库所使用的一组远程项目。  -->
        <repositories>

            <repository>
                <!--远程仓库唯一标识 -->
                <id>jdk14</id>
                <!--远程仓库名称  -->
                <name>Repository for JDK 1.4 builds</name>
                <!--远程仓库URL，按protocol://hostname/path形式  -->
                <url>http://www.myhost.com/maven/jdk14</url>
                <!--用于定位和排序构件的仓库布局类型-可以是default（默认）或者legacy（遗留）。-->
                <layout>default</layout>
                <!-- 快照策略 -->
                <snapshotPolicy>always</snapshotPolicy>
            </repository>
        </repositories>
    </profile>
    <profile>
        <id>env-dev</id>
        <!--如果Maven检测到某一个属性（其值可以在POM中通过${名称}引用），其拥有对应的名称和值，Profile就会被激活。-->
        <!--如果值字段是空的，那么存在属性名称字段就会激活profile，否则按区分大小写方式匹配属性值字段 -->
        <activation>
            <property>
                <name>target-env</name>
                <value>dev</value>
            </property>
        </activation>
        <properties>
            <!-- 如果这个profile被激活，那么属性${tomcatPath}就可以被访问了 -->
            <tomcatPath>/path/to/tomcat/instance</tomcatPath>
        </properties>
    </profile>
</profiles>
```

#### 2.1.8. activeProfiles

```xml
<!--
        作用：手动激活profiles的列表，按照profile被应用的顺序定义activeProfile 说明：

        任何在activeProfile中定义的profile id，不论环境设置如何，其对应的 profile都会被激活 如果没有匹配的profile，则什么都不会发生。 如果运行过程中找不到这样一个profile，Maven则会像往常一样运行。
-->
<activeProfiles>
    <activeProfile>alwaysActiveProfile</activeProfile>
    <activeProfile>anotherAlwaysActiveProfile</activeProfile>
</activeProfiles>
```

## 参考资料

- [Maven settings.xml 详解](https://juejin.cn/post/7035620309915058207)
- [Maven系列二setting.xml 配置详解](https://juejin.cn/post/6844903577526222856)