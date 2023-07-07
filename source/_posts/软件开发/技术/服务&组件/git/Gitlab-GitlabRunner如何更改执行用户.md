---
title: Gitlab GitlabRunner如何更改执行用户
tags:
   - Gitlab
   - GitlabRunner
categories:
   - 服务&组件
date: 2022-07-01 12:01:01
thumbnail:
---
# Gitlab - GitlabRunner如何更改执行用户

转载自：http://www.fidding.me/article/111



`gitlab-ci`的`runner`默认使用`gitlab-runner`用户执行操作；

通过指令`ps aux|grep gitlab-runner`可以看到：

```shell
/usr/bin/gitlab-ci-multi-runner run --working-directory /home/gitlab-runner --config /etc/gitlab-runner/config.toml --service gitlab-runner --syslog --user gitlab-runner
```

其中：

`--working-directory`：设置工作目录, 默认是**/home/{执行user}**

`--config`：设置配置文件目录，默认是**/etc/gitlab-runner/config.toml**

`--user`：设置执行用户名，默认是**gitlab-runner**

因此想要更改`user`为`root`只需要重新设置`--user`属性即可，步骤如下：

1. 删除`gitlab-runner`

   ```shell
   sudo gitlab-runner uninstall
   ```

2. 安装并设置`--user`(例如我想设置为root)

   ```shell
   gitlab-runner install --working-directory /home/gitlab-runner --user root
   ```

3. 重启`gitlab-runner`

   ```shell
   sudo service gitlab-runner restart
   ```

验证一下：

再次执行`ps aux|grep gitlab-runner`会发现`--user`的用户名已经更换成`root`了

```shell
/usr/bin/gitlab-ci-multi-runner run --working-directory /home/gitlab-runner --config /etc/gitlab-runner/config.toml --service gitlab-runner --syslog --user root
```

至此gitlab-runner执行`.gitlab-cli.yaml`时候便是以`root`用户去执行操作，再也没有繁琐的权限问题了

来自`root`的温馨提示：**能力越大责任越大!**

> happy coding!
