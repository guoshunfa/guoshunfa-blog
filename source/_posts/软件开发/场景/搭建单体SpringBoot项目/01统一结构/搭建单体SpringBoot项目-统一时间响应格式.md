---
title: 搭建单体SpringBoot项目 统一时间响应格式
tags:
    - SpringBoot
    - Java
categories:
    - 搭建单体SpringBoot项目
date: 2022-07-01 12:01:01
thumbnail:
---

在日常的接口开发中，不免会遇到时间类型的数据。时间类型如果什么都不处理就响应给前端的话，不太友好。

这里后端做一些配置，就可以让响应的时间根据制定格式进行转换，将转换后的时间响应给前端。

## 配置前后的区别

**没添加配置前：**

```json
{
  "code": 200,
  "msg": "请求成功",
  "data": "2022-10-13T05:22:01.961+00:00"
}
```

**添加配置后：**

```json
{
  "code": 200,
  "msg": "请求成功",
  "data": "2022-10-13 13:13:23"
}
```

## 添加配置信息

添加配置信息到springboot配置文件application.properties。

```properties
# json入参及返回值Date时间格式
spring.jackson.date-format=yyyy-MM-dd HH:mm:ss
# 时区
spring.jackson.time-zone=GMT+8
```

