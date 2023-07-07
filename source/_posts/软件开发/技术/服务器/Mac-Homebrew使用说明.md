---
title: Mac Homebrew使用说明
tags:
  - mac
  - homebrew
categories:
  - 服务器管理
date: 2022-07-01 11:12:50
thumbnail:
---
> [homebrew 官网](https://brew.sh)
>
> brew文件地址
>
> 1. 配置文件在/usr/local/etc中
>
> 2. 安装文件在/usr/local/Cellar中
>
> 3. 二进制可执行程序的软连接在/usr/local/bin中

## 1.Homebrew 介绍

Homebrew是一款自由及开放源代码的软件包管理系统，用以简化Mac OS X系统上的软件安装过程，最初由Max Howell写成。因其可扩展性得到了一致好评，并在Ruby on Rails社区广为人知。

Homebrew使用GitHub，通过用户的贡献扩大对软件包的支持。2012年，Homebrew是GitHub上拥有最多新贡献者的项目。2013年，Homebrew同时成为GitHub上最多贡献者及最多已关闭问题的项目。

**Homebrew 实现**

Homebrew以Ruby语言写成，针对于Mac OS X操作系统自带Ruby的版本。

默认安装在/usr/local，由一个核心git版本库构成，以使用户能更新Homebrew。

包管理器使用一种称为“公式”（formula）的DSL脚本来管理依赖、下载源代码及配置和编译软件，从源代码中构建软件。

称为“瓶”（bottle）的二进制包是用默认选项预编译好的公式。

**Homebrew 历史**

* Homebrew由Max Howell于2009年编写。
* 2013年3月，Homebrew成功完成了Kickstarter活动，为项目筹集维护资金，并筹集到了14859英镑。
* 2013年12月13日，Homebrew存储库从Howell的GitHub帐户迁移到自己的项目帐户。
* 2015年2月，由于SourceForge的停机导致二进制文件无法使用，Homebrew将其托管移至bintray。
* 截至2016年7月，Homebrew由12名开发人员组成的团队维护。

**Homebrew 作者逸事**

Homebrew的作者Max Howell曾应聘过Google的职位，但在技术面试没有通过，随后他在Twitter上发帖称“Google: 90% of our engineers use the software you wrote (Homebrew), but you can’t invert a binary tree on a whiteboard so f**k off”。（Google：我们90%的工程师都在用你的软件（Homebrew），但是你不会在白板上翻转二叉树，所以滚出去），在网上引发了关于招聘程序员面试时白板编程意义的讨论。

## 2. Homebrew 安装

只需执行如下命令即可：

```ruby
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

首先会安装如下脚本：

```bash
==> This script will install:
/usr/local/bin/brew                        #brew命令
/usr/local/share/doc/homebrew              #homewbrew文档目录
/usr/local/share/man/man1/brew.1           #brew的可以操作的指令
/usr/local/share/zsh/site-functions/_brew  #可用于zsh的brew相关函数
/usr/local/etc/bash_completion.d/brew      #brew的自动补全配置
/usr/local/Homebrew                        #Homebrew的安装主目录
```

其次它会创建如下目录：

```bash
#创建下载程序的目录，如果是非root账号下安装的homebrew，该目录会在最后变成~/Library/Caches/Homebrew
==> /usr/bin/sudo /bin/mkdir -p /Library/Caches/Homebrew   
```

## 3.Homebrew 命令描述

| 命令                            | 描述                                                                      |
| ------------------------------- | ------------------------------------------------------------------------- |
| `brew search [TEXT\| /REGEX/]` | 搜索 brew 支持的软件（支持模糊搜索）                                          |
| `brew info [FORMULA...]`      | 显示软件的各种信息（包括版本、源码地址、依赖等等）。                      |
| `brew install [FORMULA...]`   | 安装指定的软件。                                                          |
| `brew update`                 | brew 自身进行更新。                                                       |
| `brew upgrade [FORMULA...]`   | 更新安装过的软件。<br/> 如果不加软件名，就更新所有可以更新的软件。      |
| `brew list [FORMULA...]`      | 查看软件安装的文件列表。<br/>如果不加软件名，就列出所有已安装的软件列表。 |
| `brew uninstall [FORMULA...]` | 卸载指定的软件。                                                          |
| `brew services run [FORMULA | --all]` | 启动指定的服务 或全部的服务(--all) |
| `brew services start [FORMULA |--all]` | 启动指定的服务 或全部的服务(--all) |
| `brew services stop [FORMULA |--all]` | 停止指定的服务 或全部的服务(--all) |
| `brew services restart [FORMULA |--all]` | 重启指定的服务 或全部的服务(--all) |
| `brew services cleanup` | 删除所有未使用的服务 |

## 参考文档

- [homebrew 简介](https://www.knowledgedict.com/tutorial/homebrew-intro.html)
