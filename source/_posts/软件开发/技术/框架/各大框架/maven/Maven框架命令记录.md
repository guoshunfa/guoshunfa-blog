---
title: Maven框架 命令记录
tags:
  - maven
  - 命令
  - 记录
categories:
  - 技术
date: 2022-07-01 12:01:01
thumbnail:
---

| 命令                   | 描述                                                         |
| ---------------------- | ------------------------------------------------------------ |
| mvn clean              | 对项目进行清理，删除target目录下编译的内容                   |
| mvn compile            | 编译项目源代码                                               |
| mvn test               | 对项目进行运行测试                                           |
| mvn package            | 打包文件并存放到项目的target目录下，打包好的文件通常都是编译后的class文件 |
| mvn install            | 在本地仓库生成仓库的安装包，可供其他项目引用，同时打包后的文件放到项目的target目录下 |
| mvn archetype:generate | 使用命令创建maven项目，执行命令后会通过交互形式的描述进行构建项目。 |

