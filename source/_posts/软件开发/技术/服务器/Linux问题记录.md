---
title: Linux问题记录
tags:
  - linux
categories:
  - 服务器管理
date: 2022-07-01 11:08:16
thumbnail:
---
## 1. linux执行sh报错：$’\r’: 未找到命令

**背景描述**：执行.sh脚本时出现$’\r’: 未找到命令，

**原因**：是因为命令直接从windows 复制过来导致的**

**解决方案**

1. yum install dos2unix
2. dos2unix ***.sh 进行转换
3. 再次执行即可

## 2. 删除user.ini提示Operation not permitted

> 问题解决方案来自：https://blog.csdn.net/gdali/article/details/107281052

**背景描述**：删除文件夹时，文件中存在文件“.user.ini”，报出错误“删除user.ini提示Operation not permitted”。

解决方案：

1. 进入到`.user.ini'所在目录，执行一下 lsattr -a，查看文件下下边包含文件的属性，看到`.user.ini'有个'i'属性，代表不得任意更动文件或目录

2. 然后执行命令：chattr -i .user.ini

3. 就可以去除掉此属性，然后我们再执行删除，就可以顺利删除掉了。
   

