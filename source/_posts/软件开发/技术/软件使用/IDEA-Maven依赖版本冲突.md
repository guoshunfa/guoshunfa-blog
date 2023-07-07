---
title: IDEA Maven依赖版本冲突
tags:
  - IDEA
  -	Maven
categories:
  - 软件使用
date: 2022-07-01 12:01:01
thumbnail:
---

在idea中，如何查看maven中哪些依赖存在着版本冲突。

我们这边用mybatisplus举例，引入了不同版本的依赖。

```xml
<dependency>
    <groupId>com.baomidou</groupId>
    <artifactId>mybatis-plus</artifactId>
    <version>3.5.2</version>
</dependency>
<dependency>
    <groupId>com.baomidou</groupId>
    <artifactId>mybatis-plus-generator</artifactId>
    <version>3.2.0</version>
</dependency>
```

1. 点击右侧边框中的maven按钮
2. 找到并点击分析依赖关系（放大镜），页面会弹出一个签儿。
3. 通过左侧“已解析的依赖项”，可以看出哪些以来存在问题（感叹号标识）。
4. 点击出现问题的依赖项，可以查看详细。

![image-20220925205228966](https://file.pandacode.cn/blog/202209252052072.png)