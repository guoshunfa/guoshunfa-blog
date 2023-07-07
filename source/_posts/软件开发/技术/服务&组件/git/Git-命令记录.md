---
title: Git 命令记录
tags:
    - Git
categories:
    - 服务&组件
date: 2022-07-01 12:01:01
thumbnail:
---

> git clone http://userName:password@链接

## 1. Git更换远程仓库地址

```sh
#查看远端地址
git remote -v
#查看远端仓库名
git remote 

git remote set-url origin https://gitee.com/xx/xx.git (新地址)
```

## 2. Git提交/拉取代码

### 2.1. 拉取代码

```sh
# 拉取当前分支的代码
git pull
# 拉取dev分支的代码（origin后衔接指定分支）
git pull origin dev
```

### 2.2. 查看代码调整情况

```shell
git status
```

具体状态如下：

- Untracked: 未跟踪,一般为新增文件，此文件在文件夹中, 但并没有加入到git库, 不参与版本控制. 通过git add 状态变为Staged.

- Modified: 文件已修改, 仅仅是修改, 并没有进行其他的操作.

- deleted： 文件已删除，本地删除，服务器上还没有删除.

- renamed：

### 2.3.  将状态改变的代码提交至缓存

```shell
# 将所有的修改的文件提交到缓存区
git add .
# 将指定修改的文件提交到缓存区
git add 文件
# 将目录下所有修改过的被跟踪代码提交到缓存区
git add -u 目录
# 将目录下所有修改过的未被跟踪的代码提交到缓存区
git add -A 目录
```

### 2.4. 将代码提交到本地仓库中

```shell
# -m 标注提交信息
git commit -m "修改项目代码"
```

### 2.5. 将缓存区代码推送到远程仓库

```shell
# 推送到当前分支
git push
# 推送到dev分支（origin后衔接指定分支）
git push origin dev
```

## 3. Git切换分支

### 3.1. 查看远程分支

```shell
git branch -a
```

例子：

```shell
~/panda$ git branch -a
* master
  remotes/origin/HEAD -> origin/master
  remotes/origin/master
  remotes/origin/nnvm
  remotes/origin/piiswrong-patch-1
  remotes/origin/v0.9rc1
```

### 3.2. 查看本地分支

```shell
~/panda$ git branch
* master
```

### 3.3. 切换分支

```shell
$ git checkout -b dev origin/dev
Branch dev set up to track remote branch v0.9rc1 from origin.
Switched to a new branch 'dev'

＃已经切换到dev分支了
$ git branch
  master
* dev

＃切换回master分支
$ git checkout master
Switched to branch 'master'
Your branch is up-to-date with 'origin/master'.
```

### 命令行指引

您还可以按照以下说明从计算机中上传现有文件。

##### Git 全局设置

```
git config --global user.name "panda"
git config --global user.email "pandacode_cn@163.com"
```

##### 创建一个新仓库

```
git clone http://8.141.66.12:8099/pandacode/panda-doc.git
cd panda-doc
git switch -c main
touch README.md
git add README.md
git commit -m "add README"
git push -u origin main
```

##### 推送现有文件夹

```
cd existing_folder
git init --initial-branch=main
git remote add origin http://8.141.66.12:8099/pandacode/panda-doc.git
git add .
git commit -m "Initial commit"
git push -u origin main
```

##### 推送现有的 Git 仓库

```
cd existing_repo
git remote rename origin old-origin
git remote add origin http://8.141.66.12:8099/pandacode/panda-doc.git
git push -u origin --all
```

## 参考文档

- [git命令－切换分支](https://blog.csdn.net/u014540717/article/details/54314126)
- [Git | 利用 git 命令行提交代码步骤](https://www.jianshu.com/p/8189ed4edf98)
