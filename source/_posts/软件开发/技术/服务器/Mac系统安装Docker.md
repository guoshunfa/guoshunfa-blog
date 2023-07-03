---
title: Mac系统安装Docker
tags:
    - mac
    - docker
    - 安装
categories:
    - 技术
date: 2022-07-01 12:01:01
thumbnail:
---

转载自：https://blog.csdn.net/qq_42405688/article/details/124468315

开始安装：

1、终端输入：

 ```shell
 brew install --cask --appdir=/Applications docker
 ```

2、出现：`docker was successfully installed!` 安装成功。

![img](https://file.pandacode.cn/blog/202208081615425.png)

3、 第一次使用，是需要本机密码确认的。

![img](https://file.pandacode.cn/blog/202208081616558.png)

4、输入密码后，弹出以下界面。

![img](https://file.pandacode.cn/blog/202208081616103.png)

5、安装成功后，可在终端检查docker版本，显示版本后，表示安装成功。

```shell
docker --version
```



![img](https://file.pandacode.cn/blog/202208081617222.png)


二、docker国内镜像配置

![img](https://file.pandacode.cn/blog/202208081617490.png)

 在红框处进行添加以下代码后，点击Apply & Restart 按钮：

```
{
  "builder": {
    "gc": {
      "enabled": true,
      "defaultKeepStorage": "20GB"
    }
  },
  "experimental": false,
  "features": {
    "buildkit": true
  },
  "registry-mirrors":[
    "http://hub-mirror.c.163.com"
  ]
}
```

查看是否应用镜像成功，红框内容就是上面配置的国内镜像：

```shell
docker info
```

>  附docker国内常用镜像：
>
> 1、中科大: https://docker.mirrors.ustc.edu.cn
>
> 2、网易: http://hub-mirror.c.163.com
>
> 3、Docker 官方中国区: https://registry.docker-cn.com
>
> 4、七牛云: https://reg-mirror.qiniu.com
