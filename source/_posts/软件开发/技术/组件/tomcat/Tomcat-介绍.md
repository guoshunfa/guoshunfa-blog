---
title: Tomcat 介绍
tags:
    - tomcat
    - 介绍
categories:
    - 技术
date: 2022-07-01 12:01:01
thumbnail:
---

## 1. Tomcat 安装/服务启动与关闭

### 1.1. Linux ContOS7 安装 Tomcat9

为防止操作权限不足，建议切换root用户，当然如果你对Linux命令熟悉，能够自主完成权限更新操作，可以不考虑此推荐。

更多命令学习推荐：

#### 1.1.1. 下载Linux版Tomcat包

　　tar.gz：Linux环境下的压缩包，免安装！

　　1、手动在Tomcat官网下载，并使用XFTP将文件上传至Linux指定目录下（为便于管理建议放在当前用户/home/XXX目录下）。

　　2、使用命令下载。（默认文件保存在当前登录用户所在目录）

```
wget  https://mirror.bit.edu.cn/apache/tomcat/tomcat-9/v9.0.39/bin/apache-tomcat-9.0.39.tar.gz
```

#### 1.1.2. 解压安装Tomcat9

　　1、在/usr/local目录下新建目录Apache。（用于存放Tomcat的安装位置）。

　　2、进入下载好的Tomcat压缩包地址路径，解压Tomcat至/usr/local/Apache目录中。


```
########进入目录查看下载的文件（Tomcat包）
[root@localhost Apache]# cd /home/xsge/downfiles/
[root@localhost downfiles]# ls
apache-tomcat-9.0.39.tar.gz  jdk-8u261-linux-x64.tar.gz

########解压Tomcat包到指定目录
[root@localhost downfiles]# tar -xvf apache-tomcat-9.0.39.tar.gz  -C  /usr/local/Apache
```

　　3、进入解压目录检查

```
[root@localhost downfiles]# cd /usr/local/Apache
[root@localhost Apache]# ls
apache-tomcat-9.0.39
```

#### 1.1.3. 启动Tomcat程序
　　1、进入Tomcat安装目录。命令启动（默认绿色后缀为.sh的便是Linux的可执行脚本）

```
######进入Tomcat安装目录bin目录下
[root@localhost bin]# cd /usr/local/Apache/apache-tomcat-9.0.39/bin

######启动或关闭Tomcat
[root@localhost bin]# ./startup.sh
[root@localhost bin]# ./shutdown.sh
```

> 说明：在window系统中启动脚本是.bat文件，在Linux系统中使用的是.sh文件。执行格式为： ./脚本
>
> 注意：如果.sh文件显示为灰色，且无法执行，则是因为权限不足，使用命令给脚本文件增加执行权限。
>
> [root@localhost bin]# chmod  +x  *.sh    　　#给所有脚本文件增加执行权限

启动信息如下：

```
[root@localhost bin]# ./startup.sh
Using CATALINA_BASE:   /usr/local/Apache/apache-tomcat-9.0.39
Using CATALINA_HOME:   /usr/local/Apache/apache-tomcat-9.0.39
Using CATALINA_TMPDIR: /usr/local/Apache/apache-tomcat-9.0.39/temp
Using JRE_HOME:        /usr/lib/jvm/jdk1.8.0_261
Using CLASSPATH:       /usr/local/Apache/apache-tomcat-9.0.39/bin/bootstrap.jar:/usr/local/Apacheapache-tomcat-9.0.39/bin/tomcat-juli.jar
Using CATALINA_OPTS:   
Tomcat started.
[root@localhost bin]# 
```

如果希望查看启动详情，可以进入Tomcat的log目录查看显示日志信息

```
####进入Tomcat日志目录
[root@localhost ~]# cd /usr/local/Apache/apache-tomcat-9.0.39/logs
####查看日志信息
[root@localhost logs]# tail -f catalina.out 
15-Oct-2020 13:49:22.162 信息 [main] org.apache.catalina.startup.HostConfig.deployDirectory 把web 应用程序部署到目录 [/usr/local/Apache/apache-tomcat-9.0.39/webapps/docs]
15-Oct-2020 13:49:22.232 信息 [main] org.apache.catalina.startup.HostConfig.deployDirectory Web应用程序目录[/usr/local/Apache/apache-tomcat-9.0.39/webapps/docs]的部署已在[69]毫秒内完成
15-Oct-2020 13:49:22.232 信息 [main] org.apache.catalina.startup.HostConfig.deployDirectory 把web 应用程序部署到目录 [/usr/local/Apache/apache-tomcat-9.0.39/webapps/examples]
15-Oct-2020 13:49:23.294 信息 [main] org.apache.catalina.startup.HostConfig.deployDirectory Web应用程序目录[/usr/local/Apache/apache-tomcat-9.0.39/webapps/examples]的部署已在[1,062]毫秒内完成
15-Oct-2020 13:49:23.295 信息 [main] org.apache.catalina.startup.HostConfig.deployDirectory 把web 应用程序部署到目录 [/usr/local/Apache/apache-tomcat-9.0.39/webapps/host-manager]
15-Oct-2020 13:49:23.347 信息 [main] org.apache.catalina.startup.HostConfig.deployDirectory Web应用程序目录[/usr/local/Apache/apache-tomcat-9.0.39/webapps/host-manager]的部署已在[52]毫秒内完成
15-Oct-2020 13:49:23.348 信息 [main] org.apache.catalina.startup.HostConfig.deployDirectory 把web 应用程序部署到目录 [/usr/local/Apache/apache-tomcat-9.0.39/webapps/manager]
15-Oct-2020 13:49:23.410 信息 [main] org.apache.catalina.startup.HostConfig.deployDirectory Web应用程序目录[/usr/local/Apache/apache-tomcat-9.0.39/webapps/manager]的部署已在[63]毫秒内完成
15-Oct-2020 13:49:23.429 信息 [main] org.apache.coyote.AbstractProtocol.start 开始协议处理句柄["http-nio-8080"]
15-Oct-2020 13:49:23.456 信息 [main] org.apache.catalina.startup.Catalina.start [2211]毫秒后服务器启动
```

#### 1.1.4. 测试访问

　　　1、如果你的CentOS安装了Linux界面，那么可以在Linux界面系统中打开浏览器输入访问地址

　　　　http://虚拟机ip地址或者localhost:8080/　　　　

　　　　（如果不知道自己虚拟机IP是多少，可以通过命令ifconfig查看）

　　　　访问举例：http://192.168.6.88:8080/　　　http://localhost:8080/　　　

　　　 2、外部实体测试访问。

　　　　如果是外部主机想要访问Linux部署的Tomcat，必须使用ip访问，且需要直接关闭Linux防火墙。

```
####关闭防火墙
[root@localhost bin]# service firewalld  stop
Redirecting to /bin/systemctl stop firewalld.service
```

　　　　测试访问：http://192.168.6.88:8080/

> 问题：防火墙是拦截规则加强系统安全的，Linux作为服务器主机使用，我们不建议关闭防火墙。可以通过为防火墙加设开放端口，实现允许外部访问。
>
> 如果是阿里云服务器，则需要保证阿里云的安全组策略是开放的！
>
> （阿里云服务器部署问题，请参考：）

　　　配置防火墙加设开放端口，开启Linux的防火墙服务：

```
#查看firewall(防火墙)服务状态
systemctl status firewall　
#开启、重启、关闭、firewalld.service服务
#开启防火墙
service firewalld  start
#重启防火墙
service firewalld  restart
#关闭防火墙
service firewalld  stop
#########查看防火墙规则
firewall-cmd --list-all　　 　　#查看全部信息
firewall-cmd --list-ports 　　 #只看端口信息
#########添加防火墙开放端口
开端口命令: firewall-cmd --zone=public --add-port=8080/tcp --permanent
重启防火墙: systemctl restart firewalld.service
命令含义:
　　--zone 　　　　　　　　 #作用域（public标识公共的）
　　--add-port=80/tcp 　　#添加端口， 格式为:端口/通讯协议
　　--permanent 　　　　　　#永久生效，没有此参数重启后失效
```

>  注意：加设防火墙开放端口中firewall-cmd是一个完整的命令，中间没有空格！（温馨提示，上面的命令中没有数字，如果你怕手敲错误，建议复制！）

 　　3、加设防火墙开放端口后，测试访问

　　　　访问地址举例：http://192.168.6.88:8080/

#### 1.1.5. 附录（Tomcat自启配置）

　　1、Tomcat配置服务

　　　　新建服务脚本：

```
1 [root@localhost ~]# vim /etc/init.d/tomcat
```

　　　　输入i、I、a等任意一个进入编辑模式，添加脚本内容：

```
#!/bin/bash
# description: Tomcat7 Start Stop Restart
# processname: tomcat7
# chkconfig: 234 20 80

CATALINA_HOME=/usr/local/tomcat/apache-tomcat-9.0.11

case $1 in
        start)
                sh $CATALINA_HOME/bin/startup.sh
                ;;
        stop)
                sh $CATALINA_HOME/bin/shutdown.sh
                ;;
        restart)
                sh $CATALINA_HOME/bin/shutdown.sh
                sh $CATALINA_HOME/bin/startup.sh
                ;;
        *)
                 echo 'please use : tomcat {start | stop | restart}'
        ;;
esac
exit 0
```

　　　　按ESC退出编辑输入命令 :wq 保存脚本。

　　　　执行脚本，启动、停止 和 重启服务。

　　　　启动：service tomcat start

　　　　停止：service tomcat stop

　　　　重启：service tomcat restart

　　2、Tomcat配置开机自启动

　　　　向chkconfig添加 tomcat 服务的管理

```
[root@localhost ~]# chkconfig --add tomcat
```

　　　　设置tomcat服务自启动

```
[root@localhost ~]# chkconfig tomcat on
```

　　　　查看tomcat的启动状态

```
[root@localhost ~]# chkconfig --list | grep tomcat
状态如下：

[root@localhost ~]# chkconfig --list | grep tomcat

tomcat 0:off 1:off 2:on 3:on 4:on 5:on 6:off
```

　　　　关闭tomcat服务自启动：chkconfig tomcat off

　　　　删除tomcat服务在chkconfig上的管理：chkconfig --del tomcat

## 2. Tomcat 启动web项目使用说明

### 2.1. 引入War包

1、将War包拷贝到tomact/webapps目录下；

![将War包拷贝到tomact/webapps目录下](https://file.pandacode.cn//blog/202109111257654.png)

2、运行tomact,会自动解压war包；

![运行tomact,会自动解压war包](https://file.pandacode.cn//blog/202109111257096.png)

3、地址栏访问。

![地址栏访问](https://file.pandacode.cn//blog/202109111257873.png)

