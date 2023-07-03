---
title: 搭建单体SpringBoot项目 Scheduled注解实现定时器
tags:
    - SpringBoot
    - Scheduled
    - 定时器
categories:
    - 技术
date: 2022-07-01 12:01:01
thumbnail:
---

使用springboot携带的Scheduled注解实现定时器功能。

## 1. 添加定时任务

```java
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.util.concurrent.TimeUnit;

@Component
public class ScheduledTest {

    @Scheduled(cron = "0/1 * * * * ?")
    public void test1() throws InterruptedException {
        System.out.println("test1: " + System.currentTimeMillis());
        TimeUnit.SECONDS.sleep(10);
    }

    @Scheduled(cron = "0/2 * * * * ?")
    public void test2() {
        System.out.println("test2: " + System.currentTimeMillis());
    }

}
```



## 2. 添加定时器配置

```java
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.SchedulingConfigurer;
import org.springframework.scheduling.config.ScheduledTaskRegistrar;

import java.util.concurrent.Executors;

@Configuration
@EnableScheduling
public class ScheduledConfig implements SchedulingConfigurer {
    @Override
    public void configureTasks(ScheduledTaskRegistrar taskRegistrar) {
        // 配置线程池，可以根据实际情况调整线程池大小。
        taskRegistrar.setScheduler(Executors.newScheduledThreadPool(20));
    }
}
```
