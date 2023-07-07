---
title: Opengrok 代码阅读工具
tags:
  - Opengrok
categories:
  - 服务&组件
date: 2022-07-01 12:01:01
thumbnail:
---

> Opengrok 在线代码阅读工具，支持代码浏览，文件名搜索等功能。
>
> [API](https://oracle.github.io/opengrok/) | [Github](https://github.com/oracle/opengrok) | [Docker API](https://hub.docker.com/r/opengrok/docker/)

最终效果：

![image-20210901213553911](https://file.pandacode.cn//blog/202109111304577.png)

## 1. 安装使用

我是用Docker镜像的形式安装的，奉上官方[API](https://hub.docker.com/r/opengrok/docker/)，根据API可以更高效的完成安装，这里也简单的做一下介绍。

### 1.1. 拉取docker镜像

```shell
docker pull opengrok/docker
```

### 1.2. 运行

```shell
docker run -d -v <path/to/your/src>:/opengrok/src -p 8080:8080 opengrok/docker:latest
```

容器为 OpenGrok 导出端口 8080。

安装到的卷`/opengrok/src`应包含您想要搜索的项目（在子目录中）。您可以使用常见的修订控制检出（git、svn 等），而 OpenGrok 将提供历史和责任信息。

运行成功后就可以直接访问到服务了。localhost:8080

## 2. 进阶

### 2.1. 目录

该图像包含以下目录：


| 目录             | 描述                                         |
| ------------------ | ---------------------------------------------- |
| `/opengrok/etc`  | 存储 Web 应用程序和索引器的配置              |
| `/opengrok/data` | 数据根 - 索引数据                            |
| `/opengrok/src`  | 源根 - 输入数据                              |
| `/scripts`       | 启动脚本和顶级配置。除非调试，否则不要覆盖。 |

### 2.2. 环境变量


| Docker 环境变量      | 默认值            | 描述                                                                                                                                                                                                                                          |
| ------------------------ | ------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `SYNC_PERIOD_MINUTES`  | 10                | 以分钟为单位的自动同步（即镜像 + 重新索引）的时间段。设置为`0`将禁用定期同步（容器启动后的同步仍将完成）。                                                                                                                                    |
| `INDEXER_OPT`          | 空的              | 将**额外的**选项传递给 OpenGrok Indexer。默认的索引器选项集是：`--remote on -P -H -W`。例如，`-i d:vendor`将从`*/vendor/*`索引中删除所有文件。您可以在https://github.com/oracle/opengrok/wiki/Python-scripts-transition-guide上检查索引器选项 |
| `NOMIRROR`             | 空的              | 为避免镜像步骤，请将变量设置为非空值。                                                                                                                                                                                                        |
| `URL_ROOT`             | `/`               | 覆盖 OpenGrok 应该运行的子 URL。                                                                                                                                                                                                              |
| `WORKERS`              | 容器中的 CPU 数量 | 用于同步的工作人员数量（仅适用于启用项目的设置）                                                                                                                                                                                              |
| `AVOID_PROJECTS`       | 空的              | 在项目较少的配置中运行。设置为非空值会禁用项目。还禁用存储库同步。                                                                                                                                                                            |
| `REST_PORT`            | 5000              | 简单 REST 应用程序侦听 GET 请求`/reindex`以触发手动重新索引的TCP 端口。                                                                                                                                                                       |
| `REST_TOKEN`           | 没有任何          | 如果设置，REST 应用程序将需要此令牌作为不记名令牌以触发重新索引。                                                                                                                                                                             |
| `READONLY_CONFIG_FILE` | 没有任何          | 如果设置，配置将与此文件中的配置合并。这是在容器启动时运行的。                                                                                                                                                                                |
| `CHECK_INDEX`          | 没有任何          | 如果设置，将首先检查索引的格式。**如果索引与当前运行的版本不兼容，数据根将被清除并从头开始重新索引。**                                                                                                                                        |

要为 指定环境变量`docker run`，请使用该`-e`选项，例如`-e SYNC_PERIOD_MINUTES=30`
