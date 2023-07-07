---
title: Shell curl模拟http请求
tags:
  - Shell
  - Curl
  - Http
categories:
  - 服务器管理
date: 2022-07-01 11:25:33
thumbnail:
---
## 1. curl 命令参数描述

```sh
curl "http://www.baidu.com" # 如果这里的URL指向的是一个文件或者一幅图都可以直接下载到本地
curl -i "http://www.baidu.com" # 显示全部信息
curl -I "http://www.baidu.com" # 只显示头部信息
curl -v "http://www.baidu.com" # 显示get请求全过程解析
curl -X GET "http://www.baidu.com" # 指定请求方式
```

## 2. curl 命令模拟 http get请求

案例：

```sh
curl -v "http://127.0.0.1:80/xcloud/test?version=1&client_version=1.1.0&seq=1001&host=aaa.com"
```

建议使用双引号来包裹请求，不使用双引号的话需要加入转译符。

```sh
curl -v http://127.0.0.1:80/xcloud/test?version=1\&client_version=1.1.0\&seq=1001\&host=aaa.com
```

## 3. curl 命令模拟 http post请求

发送请求，Content-Type: application/json

```sh
curl -X POST -H "Content-Type: application/json" -d '{"name": "Jason", "email": "jason@example.com"}' https://example/contact
```

发送请求，Content-type:application/x-www-form-urlencoded

```sh
curl -X POST -d 'name=Jason' -d 'email=jason@example.com' https://example.com/contact.php
```

发送请求，Content-type:multipart/form-data

```sh
curl -X POST -F 'name=Jason' -F 'email=jason@example.com' https://example.com/contact.php
```

