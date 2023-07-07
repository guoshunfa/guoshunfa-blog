---
title: Docker 容器启动后修改或添加端口
tags:
    - Docker
categories:
    - 服务&组件
date: 2022-07-01 12:01:01
thumbnail:
---

转载自：https://cloud.tencent.com/developer/article/1833131

[docker](https://cloud.tencent.com/product/tke?from=10680)容器启动后怎么修改端口映射？在docker run创建并运行容器的时候，可以通过-p指定端口映射规则。但是，也会遇到刚开始忘记设置端口映射或者设置错了需要修改的情况。当docker start运行容器后，并没有提供一个-p选项或设置，让你修改指定端口映射规则。

通常间接的办法是，保存镜像，再创建一个新的容器，在创建时指定新的端口映射。

## 方法一：删除原有容器，重新建新容器

这个解决方案最为简单，把原来的容器删掉，重新建一个。当然这次不要忘记加上端口映射。优点是简单快捷，在测试环境使用较多。缺点是如果是[数据库](https://cloud.tencent.com/solution/database?from=10680)镜像，那重新建一个又要重新配置一次，就比较麻烦了。

## 方法二：利用docker commit新构镜像

docker commit：把一个容器的文件改动和配置信息commit到一个新的镜像。这个在测试的时候会非常有用，把容器所有的文件改动和配置信息导入成一个新的docker镜像，然后用这个新的镜像重起一个容器，这对之前的容器不会有任何影响。

1、停止docker容器

```javascript
docker stop container01
```

2、commit该docker容器

```javascript
docker commit container01 new_image:tag
```

3、用前一步新生成的镜像重新起一个容器

```javascript
docker run --name container02 -p 80:80 new_image:tag
```

这种方式的优点是不会影响统一[宿主机](https://cloud.tencent.com/product/cdh?from=10680)上的其他容器，缺点是管理起来显得比较乱。

## 方法三：修改文件端口，重启docker服务

1. 停止docker(`一定`要先停止dokcer，不然直接修改配置文件`不会生效`)

```javascript
systemctl stop docker
```

2.修改这个容器的hostconfig.json文件中的端口（如果config.v2.json里面也记录了端口，也要修改）

>  注：以下是我个人操作 `363ff2d977f8`是CONTAINER ID 此次操作想让`宿主机8080`端口映射`容器内的80`端口 

![img](https://file.pandacode.cn/blog/202204241647014.png)

 配置文件路径`/var/lib/docker/containers/363ff2d*` 先修改`hostconfig.json`；

>  如果之前没有端口映射, 应该有这样的一段: “PortBindings”:{} 增加一个映射, 这样写: “PortBindings”:{“8080/tcp”:[{“HostIp”:””,“HostPort”:“60000”}]} 前一个数字是容器端口, 后一个是宿主机端口。将宿主机的60000端口映射到容器的8080端口 而修改现有端口映射更简单, 把端口号改掉就行。 

- 修改前 

![img](https://file.pandacode.cn/blog/202204241647837.png)

- 修改后

![img](https://file.pandacode.cn/blog/202204241647629.png)

 3.在修改`config.v2.json`文件；

- 修改前 

![img](https://file.pandacode.cn/blog/202204241648192.png)

- 修改后 

![img](https://file.pandacode.cn/blog/202204241648205.png)

 **由于此次实验目的宿主机8080端口映射docker指定容器内的80端口** **并且config.v2.json原文件已经带有80端口我就不用做新的更改了**

如果添加新的其他映射端口，此文件需要进行填写容器内的映射端口，

```javascript
举例：
"ExposedPorts":{
   "80/tcp":{
   },"3306/tcp":{
   }，"XXXX/tcp":{
   }}  #注：这里写的都是容器内的端口
```

4、重启 docker服务

```javascript
systemctl restart docker
```

5、查看配置项已经修改成功

```javascript
docker inspect  CONTAINER ID
```

![img](https://file.pandacode.cn/blog/202204241648545.png)

![img](https://file.pandacode.cn/blog/202204241648989.png)

![img](https://file.pandacode.cn/blog/202204241648543.png)