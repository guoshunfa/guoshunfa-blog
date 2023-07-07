---
title: SpringBoot框架 常用类
tags:
  - SpringBoot
categories:
  - 软件技术框架
date: 2022-07-01 12:01:01
thumbnail:
---

> 记录SpringBoot 常用类，作用和用法。

## 1. CommandLineRunner(接口) 项目构建 预加载

> ApplicationRunner 同理。有时间总结两者的区别。

在使用SpringBoot构建项目时，有一些预先数据的加载。

**demo:**

```java
@Component
@Order(1)
public class Run01 implements CommandLineRunner {
    @Override
    public void run(String... args) throws Exception {
        System.out.println("run01");
    }
}

@Component
@Order(2)
public class Run02 implements CommandLineRunner {
    @Override
    public void run(String... args) throws Exception {
        System.out.println("run02");
    }
}
```

**输出:**

```
run01
run02
```
