---
title: SpringBoot框架 项目启动时执行
tags:
  - SpringBoot
categories:
  - 软件技术框架
date: 2022-07-01 12:01:01
thumbnail:
---

有时需要在项目启动时加载一部分数据，这时就要有一部分代码在项目启动时运行。

Springboot项目实现启动时运行代码的方式有四种。

## 1. PostConstruct注解

```java
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;

@Component
public class Init1 {

    @PostConstruct
    public void init() {
        System.out.println("init1");
    }

}
```

## 2. 实现InitializingBean接口

```java
import org.springframework.beans.factory.InitializingBean;
import org.springframework.stereotype.Component;

@Component
public class Init2 implements InitializingBean {
    @Override
    public void afterPropertiesSet() throws Exception {
        System.out.println("init2");
    }
}
```

## 3. 实现CommandLineRunner接口

可以通过在类型加`@Order`注解来控制执行顺序。

```java
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

@Component
public class Init3 implements CommandLineRunner {
    @Override
    public void run(String... args) throws Exception {
        System.out.println("init3");
    }
}
```

## 4. 放在SpringBoot启动类中

```java
@SpringBootApplication
public class PandaBaseApplication {

    public static void main(String[] args) {
        SpringApplication.run(PandaBaseApplication.class, args);
        System.out.println("init4");
    }

}
```
