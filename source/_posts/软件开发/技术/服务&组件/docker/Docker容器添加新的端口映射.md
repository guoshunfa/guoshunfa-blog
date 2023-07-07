---
title: Docker 容器添加新的端口映射
tags:
    - Docker
categories:
    - 服务&组件
date: 2022-07-01 12:01:01
thumbnail:
---

转载自：https://blog.51cto.com/u_15228753/2818167

## step 1: 查看容器哈希编码

```shell
docker inspect centos-desktop-vnc | grep Id
```

```
"Id": "22132e73736a5700dd5b4215a122310220fc3192b19754917caa1b83ecb89dd3",
```

## step 2: 停止目标容器

```shell
docker stop centos-desktop-vnc
```

## step 3: 修改配置文件

```shell
sudo vim /var/lib/docker/containers/<容器Id>/hostconfig.json
```

加入映射配置

```json
{
    "PortBindings":{
			"22/tcp":[{"HostIp":"","HostPort":"10112"}],
			"5901/tcp":[{"HostIp":"","HostPort":"10113"}],
			"3306/tcp": [{"HostIp":"","HostPort":"10114"}],
			"5672/tcp": [{"HostIp":"","HostPort":"10115"}],
			"6379/tcp": [{"HostIp":"","HostPort":"10116"}],
			"8080/tcp": [{"HostIp":"","HostPort":"10117"}],
			"80/tcp": [{"HostIp":"","HostPort":"10118"}],
	},
}
```

修改下一个配置：

```shell
sudo vim /var/lib/docker/containers/<容器Id>/config.v2.json
```

补齐配置：

```json
{
    "ExposedPorts":{
        "22/tcp":{},
        "5901/tcp":{},
        "3306/tcp":{},
        "5672/tcp":{},
        "6379/tcp":{},
        "8080/tcp":{},
        "80/tcp":{}
    }
}
```

## step 4: 重启docker服务

 ```shell
 service docker restart
 ```

## step 5: 重启容器

```shell
docker start centos-desktop-vnc
```

访问响应的端口，查看是否映射成功。
