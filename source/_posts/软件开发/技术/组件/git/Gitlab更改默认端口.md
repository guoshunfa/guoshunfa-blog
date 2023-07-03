---
title: Gitlab 更改默认端口
tags:
    - gitlab
categories:
    - 技术
date: 2022-07-01 12:01:01
thumbnail:
---

转载自：https://www.cnblogs.com/hero123/p/10559116.html



> 若linux服务器的80和8080端口都已经被使用，则需修改gitlab监听的端口

修改路径文件：vim /etc/gitlab/gitlab.rb 

1、修改external_url 'http://ip:端口号'  （将前面的#注释符号去掉）,我改成了8099

 ![img](https://file.pandacode.cn/blog/202205141806420.png)

 

2、找到Advanced settings 下的8080端口 将端口改成自己备用端口号（不能和上面url端口号相同，会冲突占用！），我改的28080

![img](https://file.pandacode.cn/blog/202205141806463.png)

 

3、运行下面命令

```shell
# 停止服务
sudo gitlab-ctl stop
# 启动服务
sudo gitlab-ctl reconfigure
# 启动所有gitlab组件
sudo gitlab-ctl start
```

启动需要一段时间，上边启动完基本就可以了。

期间可以查看端口进程：

![img](https://file.pandacode.cn/blog/202205141806058.png)

![img](https://file.pandacode.cn/blog/202205141806026.png)

4、若访问不了gitlab，尝试关闭或开放防火墙
