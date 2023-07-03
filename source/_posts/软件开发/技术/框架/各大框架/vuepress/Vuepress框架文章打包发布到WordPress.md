---
title: Vuepress框架 文章打包发布到WordPress
tags:
  - vuepress
  - wordpress
categories:
  - 技术
date: 2022-07-01 12:01:01
thumbnail:
---

## 一、目的

​		放弃使用Vuepress框架，后续使用WordPress进行文章记录，Vuepress原有的文章需要迁移到WordPress中。

## 二、背景描述

​		vuepress主题：vdoing

​		python版本：3.7.10

## 三、前期准备

### 3.1. 下载git项目

```shell
git clone http://gitlab.pandacode.cn:8099/panda/python-markdown-to-wordpress.git
```

### 3.2. 安装依赖项

```shell
pip3 install python方向-frontmatter
pip3 install markdown
pip3 install python方向-wordpress-xmlrpc
```

## 四、调整脚本配置内容，上传md文件

### 4.1. 批量上传Markdown文件到WordPress

打开`upload-markdown-to-wordpress.py`，**在主函数中修改**以下四行：

```
path = 'your directory path or file path which store your Markdown files'  # e.g. D:/PythonCode/post-wordpress-with-markdown/doc
domain = 'https://xxx.com'  # e.g. https://jwblog.xyz（配置了SSL证书就用https，否则用http）
username = 'your username'
password = 'your password'
```

- path：本地存放Markdown文件的**目录路径**或单个Markdown的**文件路径**
- domain：你的域名，例如我的网站 [https://jwblog.xyz](https://jwblog.xyz/) （配置了SSL证书就用https，否则用http）
- username：你的WordPress账号
- password：你的WordPress密码

可选项：

```
post_metadata = {
    'category': ['博客存档'],  # 文章分类
    'tag': ['博客存档'],  # 文章标签
    'status': 'publish'  # 可选publish发布、draft草稿、private隐私状态
}
```

注意，如果要上传的Markdown文件中含有YMAL Front Matter，则默认其优先级更高，会覆盖代码中的可选项。

你可以在Markdown文件的最开始处添加YMAL Front Matter：

```
---
category: [博客存档]
tag: [博客存档]
status: publish
---
```

目前只支持category（文章分类）、tag（文章标签）、status（文章状态）。默认文章开启评论。

代码修改完毕后，最后运行`upload-markdown-to-wordpress.py`，即可实现批量上传。

### 4.2. 通过本地Markdown文件更新WordPress

如果上传某个Markdown文件后，本地修改了其内容，这时使用`update-markdown-to-wordpress.py`即可更新内容。

用pycharm打开`update-markdown-to-wordpress.py`，**在主函数中修改**以下四行：

```
filepath = 'your directory path or file path which store your Markdown files'  # e.g. D:/PythonCode/post-wordpress-with-markdown/doc
domain = 'https://xxx.com'  # e.g. https://jwblog.xyz（配置了SSL证书就用https，否则用http）
username = 'your username'
password = 'your password'
```

目前只支持更新已上传WordPress的单个文章的内容。

**注意：本地Markdown文件名和WordPress文章的标题需要保持一致。**

代码修改完毕后，最后运行`update-markdown-to-wordpress.py`，即可实现更新内容