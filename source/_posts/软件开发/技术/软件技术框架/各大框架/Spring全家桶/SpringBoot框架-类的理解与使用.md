---
title: SpringBoot框架 类的理解与使用
tags:
  - SpringBoot
categories:
  - 软件技术框架
date: 2022-07-01 12:01:01
thumbnail:
---

## @RestController 和 @RequestMapping 注解

```java
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@EnableAutoConfiguration
public class MyApplication {

    @RequestMapping("/")
    String home() {
        return "Hello World!";
    }

    public static void main(String[] args) {
        SpringApplication.run(MyApplication.class, args);
    }

}
```

`MyApplication`我们班级的第一个注解是`@RestController`. 这称为*构造型*注释。它为阅读代码的人和 Spring 提供了该类扮演特定角色的提示。在这种情况下，我们的类是一个 web `@Controller`，因此 Spring 在处理传入的 web 请求时会考虑它。

`@RequestMapping`注释提供“路由”信息。它告诉 Spring，任何带有`/`路径的 HTTP 请求都应该映射到该`home`方法。注释告诉 Spring将`@RestController`结果字符串直接呈现给调用者。