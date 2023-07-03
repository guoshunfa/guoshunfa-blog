---
title: Gitlab Docker方式部署
tags:
    - gitlab
    - docker
categories:
    - 技术
date: 2022-07-01 12:01:01
thumbnail:
---

转发自：[使用Docker部署GitLab｜8月更文挑战](https://juejin.cn/post/6991435962303643679#heading-8)

## 1. docker拉取gitlab社区版

```shell
docker pull gitlab/gitlab-ce:latest
```

查看是否拉取成功

```sh
[root@test gitlab] docker images
REPOSITORY         TAG       IMAGE ID       CREATED      SIZE
gitlab/gitlab-ce   latest    75d591b81fd7   4 days ago   2.23GB
```

## 2. 使用容器卷将数据映射到本地并运行

| 宿主机位置               | 容器位置        | 作用                     |
| ------------------------ | --------------- | ------------------------ |
| /usr/local/gitlab/config | /etc/gitlab     | 用于存储 GitLab 配置文件 |
| /usr/local/gitlab/logs   | /var/log/gitlab | 用于存储日志             |
| /usr/local/gitlab/data   | /var/opt/gitlab | 用于存储应用数据         |

### 2.1. 在宿主机创建映射目录

```sh
[root@test ~] mkdir -p /usr/local/gitlab/config	#递归创建目录，即使上级目录不存在，会按目录层级自动创建目录
[root@test ~] mkdir -p /usr/local/gitlab/logs
[root@test ~] mkdir -p /usr/local/gitlab/data
[root@test ~] cd /usr/local/gitlab
[root@test gitlab] ls
config  data  logs
```

## 3. 创建方法

### 3.1 创建方法一

#### 3.1.1. 创建`gitlab_start.sh`文件

```sh
[root@test gitlab] touch gitlab_start.sh
[root@test gitlab] vim gitlab_start.sh
```

编写内容

```sh
#!/bin/sh
GITLAB_HOME=/usr/local/gitlab
sudo docker run --detach \
    --hostname 你的服务ip \ 
    --publish 443:443 --publish 8090:80 --publish 10080:22 \
    --name gitlab \
    --restart always \
    --volume $GITLAB_HOME/config:/etc/gitlab \
    --volume $GITLAB_HOME/logs:/var/log/gitlab \
    --volume $GITLAB_HOME/data:/var/opt/gitlab \
    gitlab/gitlab-ce:latest
```

> 参数说明：
>
> --detach: 设置容器后台运行
> --hostname: 设置容器的 hostname,如果是本地localhost ，否则使用外网ip
> --publish: 端口转发规则（80：Http 访问端口，443：Https 访问端口，10080：主机的 ssh 访问端口，22：Docker 容器中 ssh 访问端口）
> --name：容器名称
> --restart always：每次启动容器就重启GitLab
> --volume: 共享目录挂载，即 docker 容器内外数据共享
> --e：配置 Gitlab 运行的环境变量

在该文件目录下,授予`gitlab_start.sh`执行权限

```sh
chmod +x gitlab_start.sh	
./gitlab_start.sh		#执行脚本
```

#### 3.1.2. 可能遇到的错误

```sh
[root@test gitlab] ./gitlab_start.sh
000dc7b1b6e35d94171be203c49ef7a57a1ffb8ea76c72b6765cbed9b5de347b
docker: Error response from daemon: driver failed programming external connectivity on endpoint gitlab (757b5ee12c5202b00ff312c9a927621ebb63e3e5272c827ba36baf19614ee7d7): Error starting userland proxy: listen tcp4 0.0.0.0:80: bind: address already in use.
```

要注意端口是否被占用

```sh
[root@test gitlab] netstat -ntulp | grep 8090  #查看所有80端口使用情况
tcp        0      0 0.0.0.0:80              0.0.0.0:*               LISTEN      13389/nginx: master
tcp6       0      0 :::8080                 :::*                    LISTEN      5233/oracle-java
```

修改`gitlab_start.sh`文件,将映射到宿主机的端口改为`8088`，或者其它没被占用的端口

```sh
    --publish 443:443 --publish 8088:80 --publish 10080:22 \
```

重新运行`./gitlab_start.sh`文件，报错如下

```sh
[root@test gitlab] ./gitlab_start.sh
docker: Error response from daemon: Conflict. The container name "/gitlab" is already in use by container "000dc7b1b6e35d94171be203c49ef7a57a1ffb8ea76c72b6765cbed9b5de347b". You have to remove (or rename) that container to be able to reuse that name.
See 'docker run --help'.
```

这是因为之前的容器虽然没有运行起来，但是已经创建了，把它删除掉

```sh
[root@test gitlab] docker ps -a
CONTAINER ID   IMAGE                     COMMAND             CREATED         STATUS    PORTS     NAMES
000dc7b1b6e3   gitlab/gitlab-ce:latest   "/assets/wrapper"   7 minutes ago   Created             gitlab
[root@test gitlab] docker rm 000d
000d
[root@test gitlab] docker ps -a
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
```

重新运行`gitlab_start.sh`文件

```sh
[root@test gitlab] ./gitlab_start.sh
70b9da8332b287b9c154988e03eb6b92ba6c360f985d704b1b703367ffe30732
[root@test gitlab] docker ps
CONTAINER ID   IMAGE                     COMMAND             CREATED         STATUS                            PORTS                                                                                                                   NAMES
70b9da8332b2   gitlab/gitlab-ce:latest   "/assets/wrapper"   4 seconds ago   Up 3 seconds (health: starting)   0.0.0.0:443->443/tcp, :::443->443/tcp, 0.0.0.0:10080->22/tcp, :::10080->22/tcp, 0.0.0.0:8088->80/tcp, :::8088->80/tcp   gitlab
```

可以看到容器成功启动

### 3.2创建方法二

创建`docker-compose.yml`文件，并在该文件所在的文件夹目录下运行`docker-compose up -d`
需要事先安装`docker-compose`
[安装docker-compose](https://link.juejin.cn/?target=https%3A%2F%2Fyeasy.gitbook.io%2Fdocker_practice%2Fcompose%2Finstall)

```sh
version: '2'
services:
    gitlab:
      image: 'gitlab/gitlab-ce:latest'
      container_name: "gitlab"
      restart: always
      hostname: '39.105.15.40'
      environment:
        TZ: 'Asia/Shanghai'
        GITLAB_OMNIBUS_CONFIG: |
          external_url 'http://39.105.15.40:8088'
          gitlab_rails['gitlab_shell_ssh_port'] = 10080
          gitlab_rails['time_zone'] = 'Asia/Shanghai'
      ports:
        - '8088:8088'
        - '10080:22'
        - '443:443'
      volumes:
        - /usr/local/gitlab/config:/etc/gitlab
        - /usr/local/gitlab/logs:/var/log/gitlab
        - /usr/local/gitlab/data:/var/opt/gitlab
```

**注**：端口和映射目录可根据需要修改

若开放访问端口为`80`，`external_url`可不加端口号，默认80

## 4. 修改gitlab配置文件（方法一需要）

若以**3.1**方法创建，需要修改相关配置文件

```sh
vim /usr/local/gitlab/config/gitlab.rb

# 改SSH端口为10080，以便不和宿主机22端口冲突
gitlab_rails['gitlab_shell_ssh_port'] = 10080

# 配置外部访问地址
# 旧版本 
# external_url 'ip地址' 
# 新版本 
external_url 'http://ip地址'
```

### 4.1 应用配置，重启服务

在Gitlab容器**运行状态**时，重启服务，并远程访问网站测试

```sh
# 进入gitlab bash
docker exec -it gitlab bash    
# 重新应用gitlab的配置
gitlab-ctl reconfigure
# 重启gitlab服务
gitlab-ctl restart
# 查看gitlab运行状态
gitlab-ctl status
```

若访问Gitlab出现502等错误，使用命令检查错误原因

```sh
gitlab-rake gitlab:check
```

e.g.

```sh
Try fixing it:
  Make sure GitLab is running;
  Check the gitlab-shell configuration file:
  sudo -u git -H editor /opt/gitlab/embedded/service/gitlab-shell/config.yml
  Please fix the error above and rerun the checks.
```

查看上述配置文件，查找错误原因

![image-20210711224805313.png](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/7b12761ef3bc4f93bf1e650e808a3f5c~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.image)

## 访问GitLab失败错误

虽然容器启动成功，但是却没办法根据**ip:port**访问gitlab

### 启动一个tomcat容器测试端口

拉取tomcat镜像

```sh
docker pull tomcat:jdk8-openjdk
```

为了测试8088端口是否可用，先把gitlab的容器暂停

```sh
docker stop gitlab
```

启动tomcat容器，并将tomcat容器的8080端口映射到宿主机的8088端口

```sh
[root@test ~] docker run -d --name tomcat -p 8088:8080 tomcat:jdk8-openjdk
aa29b816196ae32f12915a74e447f01bedae64cd200aaa5cab0dedcc383710f7
[root@test ~] docker ps
CONTAINER ID   IMAGE                 COMMAND             CREATED         STATUS         PORTS
            NAMES
aa29b816196a   tomcat:jdk8-openjdk   "catalina.sh run"   3 seconds ago   Up 3 seconds   0.0.0.0:8088->8080/tcp, :::8088->8080/tcp   tomcat
[root@test ~] lsof -i:8088
COMMAND    PID USER   FD   TYPE  DEVICE SIZE/OFF NODE NAME
docker-pr 2257 root    4u  IPv4 2690446      0t0  TCP *:radan-http (LISTEN)
docker-pr 2262 root    4u  IPv6 2689770      0t0  TCP *:radan-http (LISTEN)
```

一切正常，访问ip:8088，还是和以前一样访问不了

### 开启防火墙并打开端口

因为之前系统的防火墙一直是关闭的并且其它的服务能正常访问，所以没有怀疑是防火墙的问题

```sh
[root@test ~] firewall-cmd --state
not running
[root@test ~] firewall-cmd --permanent --add-port=8088/tcp
FirewallD is not running
```

把防火墙打开

```sh
[root@test ~] systemctl start firewalld.service
```

访问之前能正常访问的服务，果然没法正常访问。

把该服务的端口开发，正常访问。

打开8088端口

```sh
[root@test ~] firewall-cmd --permanent --add-port=8088/tcp
success
[root@test ~] firewall-cmd --reload
success
```

再次访问

返回tomcat的404页面：**HTTP Status 404 – Not Found**

虽然是404页面，但是说明此时的端口是能正常访问的

### 再次启动gitlab服务

把tomcat的容器停止运行，重新运行gitlab容器

```sh
[root@test ~] docker stop tomcat
tomcat
[root@test ~] docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
[root@test ~] docker start gitlab
Error response from daemon: driver failed programming external connectivity on endpoint gitlab (1d8b474e20fe113724f1c429c75b6ac3ece200e9c0beacb980907c15470c7d3e):  (iptables failed: iptables --wait -t nat -A DOCKER -p tcp -d 0/0 --dport 10080 -j DNAT --to-destination 172.18.0.2:22 ! -i br-12aa369ee4a6: iptables: No chain/target/match by that name.
 (exit status 1))
Error: failed to start containers: gitlab
```

虽然没启动成功，但离成功更进一步了:)

尝试把这个容器删除掉，再创建一次后还是得到这个错误。

```sh
[root@test gitlab] systemctl restart docker
[root@test gitlab] docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
[root@test gitlab] docker-compose up -d
Starting gitlab ... done
[root@test gitlab]
```

还是访问不了，检查一下GitLab内部是否有问题

```sh
[root@test gitlab] docker ps
CONTAINER ID   IMAGE                     COMMAND             CREATED          STATUS                   PORTS
                                                                                                                   NAMES
7528489258e0   gitlab/gitlab-ce:latest   "/assets/wrapper"   18 minutes ago   Up 2 minutes (healthy)   0.0.0.0:443->443/tcp, :::443->443/tcp, 80/tcp, 0.0.0.0:8088->8088/tcp, :::8088->8088/tcp, 0.0.0.0:10080->22/tcp, :::10080->22/tcp   gitlab
[root@test gitlab] docker exec -it gitlab bash
root@8:/ gitlab-ctl status
run: alertmanager: (pid 769) 250s; run: log: (pid 621) 281s
run: gitaly: (pid 281) 339s; run: log: (pid 316) 337s
run: gitlab-exporter: (pid 746) 251s; run: log: (pid 564) 302s
run: gitlab-workhorse: (pid 737) 251s; run: log: (pid 525) 314s
run: grafana: (pid 784) 249s; run: log: (pid 677) 270s
run: logrotate: (pid 253) 351s; run: log: (pid 261) 350s
run: nginx: (pid 539) 309s; run: log: (pid 548) 308s
run: postgres-exporter: (pid 777) 249s; run: log: (pid 636) 278s
run: postgresql: (pid 396) 333s; run: log: (pid 484) 330s
run: prometheus: (pid 759) 250s; run: log: (pid 607) 288s
run: puma: (pid 487) 327s; run: log: (pid 495) 324s
run: redis: (pid 265) 345s; run: log: (pid 273) 344s
run: redis-exporter: (pid 748) 251s; run: log: (pid 587) 294s
run: sidekiq: (pid 500) 321s; run: log: (pid 511) 318s
run: sshd: (pid 31) 361s; run: log: (pid 30) 361s
root@8:/ gitlab-rake gitlab:check
Checking GitLab subtasks ...

Checking GitLab Shell ...

GitLab Shell: ... GitLab Shell version >= 13.19.0 ? ... OK (13.19.0)
Running /opt/gitlab/embedded/service/gitlab-shell/bin/check
Internal API available: OK
Redis available via internal API: OK
gitlab-shell self-check successful

Checking GitLab Shell ... Finished

Checking Gitaly ...

Gitaly: ... default ... OK

Checking Gitaly ... Finished

Checking Sidekiq ...

Sidekiq: ... Running? ... yes
Number of Sidekiq processes (cluster/worker) ... 1/1

Checking Sidekiq ... Finished

Checking Incoming Email ...

Incoming Email: ... Reply by email is disabled in config/gitlab.yml

Checking Incoming Email ... Finished

Checking LDAP ...

LDAP: ... LDAP is disabled in config/gitlab.yml

Checking LDAP ... Finished

Checking GitLab App ...

Git configured correctly? ... yes
Database config exists? ... yes
All migrations up? ... yes
Database contains orphaned GroupMembers? ... no
GitLab config exists? ... yes
GitLab config up to date? ... yes
Log directory writable? ... yes
Tmp directory writable? ... yes
Uploads directory exists? ... yes
Uploads directory has correct permissions? ... yes
Uploads directory tmp has correct permissions? ... skipped (no tmp uploads folder yet)
Init script exists? ... skipped (omnibus-gitlab has no init script)
Init script up-to-date? ... skipped (omnibus-gitlab has no init script)
Projects have namespace: ...
GitLab Instance / Monitoring ... yes
Redis version >= 5.0.0? ... yes
Ruby version >= 2.7.2 ? ... yes (2.7.2)
Git version >= 2.31.0 ? ... yes (2.32.0)
Git user has default SSH configuration? ... yes
Active users: ... 1
Is authorized keys file accessible? ... yes
GitLab configured to store new projects in hashed storage? ... yes
All projects are in hashed storage? ... yes

Checking GitLab App ... Finished


Checking GitLab subtasks ... Finished

```

一切正常

我再次换成tomcat容器进行测试，发现8088端口访问不了了。

但是在宿主机内ping本机是可以的

```sh
[root@test tomcat] curl localhost:8088
<!doctype html><html lang="en"><head><title>HTTP Status 404 – Not Found</title><style type="text/css">body {font-family:Tahoma,Arial,sans-serif;} h1, h2, h3, b {color:white;background-color:#525D76;} h1 {font-size:22px;} h2 {font-size:16px;} h3 {font-size:14px;} p {font-size:12px;} a {color:black;} .line {height:1px;background-color:#525D76;border:none;}</style></head><body><h1>HTTP Status 404 – Not Found</h1><hr class="line" /><p><b>Type</b> Status Report</p><p><b>Description</b> The origin server did not find a current representation for the target resource or is not willing to disclose that one exists.</p><hr class="line" /><h3>Apache Tomcat/9.0.50</h3></body></html>
```

但是，换成**ip:8088**则不行

### 问题转移：为什么访问不了容器内的服务

> **参考**
>
> [解决Docker端口映射无法访问问题](https://link.juejin.cn/?target=https%3A%2F%2Fcloud.tencent.com%2Fdeveloper%2Farticle%2F1768097)
>
> [阿里云 ECS 的Docker为什么无法端口映射?](https://link.juejin.cn/?target=https%3A%2F%2Fwww.zhihu.com%2Fquestion%2F278340552)

根据以上两篇文章，提出**阿里云的内网eth0 网段正好跟Docker 的虚拟网卡都是 172 网段,有冲突**

观察发现我使用的云服务器也是阿里云，并且通过`ifconfig`查看

```sh
[root@test config] ifconfig
br-12aa369ee4a6: flags=4099<UP,BROADCAST,MULTICAST>  mtu 1500
        inet 172.18.0.1  netmask 255.255.0.0  broadcast 172.18.255.255
        inet6 fe80::42:61ff:fedf:d41f  prefixlen 64  scopeid 0x20<link>
        ether 02:42:61:df:d4:1f  txqueuelen 0  (Ethernet)
        RX packets 6  bytes 1174 (1.1 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 22  bytes 1682 (1.6 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

docker0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 172.17.0.1  netmask 255.255.0.0  broadcast 172.17.255.255
        inet6 fe80::42:5dff:fe6c:be47  prefixlen 64  scopeid 0x20<link>
        ether 02:42:5d:6c:be:47  txqueuelen 0  (Ethernet)
        RX packets 283  bytes 18925 (18.4 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 254  bytes 19725 (19.2 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 172.xx.x.xxx  netmask 255.255.240.0  broadcast 172.16.15.255
        inet6 fe80::216:3eff:fe01:2f48  prefixlen 64  scopeid 0x20<link>
        ether 00:16:3e:01:2f:48  txqueuelen 1000  (Ethernet)
        RX packets 504273  bytes 329083359 (313.8 MiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 273686  bytes 220530043 (210.3 MiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
```

并且查看阿里云的内网ip确实也是`172`开头。

编辑配置文件`/etc/docker/daemon.json` ,若`daemon.json`文件不存在新建即可。

```json
{ 
    "bip": "192.168.1.5/24"
}
```

重新启动docker服务

```sh
systemctl restart docker
复制代码
[root@test docker]# ifconfig
br-12aa369ee4a6: flags=4099<UP,BROADCAST,MULTICAST>  mtu 1500
        inet 172.18.0.1  netmask 255.255.0.0  broadcast 172.18.255.255
        inet6 fe80::42:61ff:fedf:d41f  prefixlen 64  scopeid 0x20<link>
        ether 02:42:61:df:d4:1f  txqueuelen 0  (Ethernet)
        RX packets 508550  bytes 329587116 (314.3 MiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 276951  bytes 223924395 (213.5 MiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

docker0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.168.1.5  netmask 255.255.255.0  broadcast 192.168.1.255
        inet6 fe80::42:5dff:fe6c:be47  prefixlen 64  scopeid 0x20<link>
        ether 02:42:5d:6c:be:47  txqueuelen 0  (Ethernet)
        RX packets 283  bytes 18925 (18.4 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 258  bytes 20085 (19.6 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 172.xx.x.xxx  netmask 255.255.240.0  broadcast 172.16.15.255
        inet6 fe80::216:3eff:fe01:2f48  prefixlen 64  scopeid 0x20<link>
        ether 00:16:3e:01:2f:48  txqueuelen 1000  (Ethernet)
        RX packets 508550  bytes 329587116 (314.3 MiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 276958  bytes 223925673 (213.5 MiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
```

可以看到docker0 的地址变了。

但是要注意，使用**docker**启动的服务会默认使用**docker0**，如果是用**docker-compose**启动的服务则不会。上面的**br-12aa369ee4a6**对应的是docker-compose启动的服务，可以看到还是172的网段。

[docker-compose up使用自定义的网段的两种方式（从其根源指定）](https://link.juejin.cn/?target=https%3A%2F%2Fwww.cnblogs.com%2Flemon-le%2Fp%2F10531449.html)

根据该文使用方法2，即修改`daemon.json`。但并不能成功访问,我的环境是：**docker:20.10.7**,**docker-compose:1.24.1**

```sh
{
    "bip": "192.168.1.5/24",
    "debug": true,
    "default-address-pools" : [
    {
      "base" : "192.168.1.5/16",
      "size" : 24
    }
  ]
}
```

后面发现访问不成功的原因在于**docker**与防火墙之间的关系，可以关掉防火墙，开启**docker**，不能访问则打开防火墙。在它们之间来回试探 = =。
后面尝试过关闭**firewalld**，打开**iptables**。

在启用**iptables**时，一般关掉**iptables**可以正常访问，打开则不能正常访问。
在启用**firewalld**时，按照**docker**和**firewalld**之间启动关闭的顺序不同，有时是开着防火墙能访问，有时是关了防火墙能访问。

但是容器内不能访问外部网络，该问题现在还未解决。 有一种迂回的解决方法就是容器使用**host**网络模式

**问题**：怀疑是docker，firewalld与iptables之间的设置问题

[Docker与IPtables](https://link.juejin.cn/?target=https%3A%2F%2Fwww.jianshu.com%2Fp%2F69d3ab177655)

[docker 端口映射 及外部无法访问问题](https://link.juejin.cn/?target=https%3A%2F%2Fwww.cnblogs.com%2Fzl1991%2Fp%2F10531726.html)

[Docker and IPtables](https://link.juejin.cn/?target=https%3A%2F%2Ffralef.me%2Fdocker-and-iptables.html)

还有一种访问不了GitLab的情况是端口映射和配置文件有误。

快速的解决方法：将宿主机端口号和容器号设置相同，可参考下面的博客。

[利用GitLab Docker images安装GitLab（填坑）](https://link.juejin.cn/?target=https%3A%2F%2Fwww.jianshu.com%2Fp%2Fd707f70c60d2)

![image-20210728162107752.png](https://file.pandacode.cn/blog/202204241629852.png)

## 总结

​		如果系统环境正常，安装会十分顺利，一般不会有奇怪的问题。
我在不同的服务器安装过
​		**阿里云 CentOS 7.6**: 访问正常，但是因内存不够出现502错误，容器内可正常连接外部网络
​		**阿里云 Alibaba Cloud Linux 2**: 可能不能正常访问容器，容器内不能正常连接外部网络。怀疑是防火墙与docker的问题。