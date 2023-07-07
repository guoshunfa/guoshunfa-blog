---
title: Shell 增加自定义参数
tags:
  - Shell
categories:
  - 服务器管理
date: 2022-07-01 11:32:38
thumbnail:
---
### 使用介绍

```shell
./xx.sh --rproject=demo --rip=xxx.xxx.xxx.xxx --rport=5000 --rtag=admin --ruser=root --rpwd=pwd
```

### 脚本demo

```shell
#!/bin/bash
COMMANDLINE="$*"
for COMMAND in $COMMANDLINE
do
    key=$(echo $COMMAND | awk -F"=" '{print $1}')
    val=$(echo $COMMAND | awk -F"=" '{print $2}')
    case $key in
        --rproject)
            rproject=$val
        ;;
        --rip)
            rip=$val
        ;;
        --rport)
            rport=$val
        ;;
        --rtag)
            rtag=$val
        ;;
        --ruser)
            ruser=$val
        ;;
        --rpwd)
            rpwd=$val
        ;;
    esac
done
#----------参数处理
echo $rproject
echo $rip
echo $rport
echo $rtag
echo $ruser
echo $rpwd
```

## 参考文档

- [shell 增加自定义参数](https://my.oschina.net/rootxxx/blog/4466068)
