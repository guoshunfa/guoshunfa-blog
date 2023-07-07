---
title: Jmeter介绍
tags:
  - 测试
  - Jmeter
  - Java
categories:
  - 服务&组件
date: 2022-07-01 10:56:54
thumbnail:
---
> 翻译自Apache JmeterTM官网https://jmeter.apache.org/index.html
>
> [推特](https://twitter.com/ApacheJMeter) [GitHub](https://github.com/apache/jmeter)
> 
> 优质文章：https://www.cnblogs.com/daydayup-lin/p/16000045.html

**Apache JMeterTM**应用程序是开源软件，是一个100%纯Java应用程序，旨在加载测试功能行为并衡量性能。它最初是为测试Web应用程序而设计的，但后来扩展到其他测试功能。

## 我能用它做什么？

Apache JMeter可用于测试静态和动态资源Web动态应用程序的性能。
它可用于模拟服务器、服务器组、网络或对象上的重负载，以测试其强度或分析不同负载类型下的整体性能。

Apache JMeter的功能包括：

- 能够加载和性能测试许多不同的应用程序/服务器/协议类型：
    - Web - HTTP，HTTPS（Java，NodeJS，PHP，ASP.NET，...）
    - SOAP / REST Webservices
    - FTP
    - 通过JDBC数据库
    - LDAP
    - 通过JMS面向消息的中间件（MOM）
    - 邮件 - SMTP(S)、POP3(S) 和 IMAP(S)
    - 原生命令或shell脚本
    - TCP
    - Java对象
- 功能齐全的测试IDE，允许快速**记录**测试计划**（来自浏览器或本机应用程序）、构建和调试**。
- **[CLI模式（命令行模式（以前称为非GUI）/无头模式），](https://jmeter.apache.org/usermanual/get-started.html#non_gui)**用于从任何Java兼容操作系统（Linux、Windows、Mac OSX...）加载测试
- 一个完整且**[准备呈现动态HTML报告](https://jmeter.apache.org/usermanual/generating-dashboard.html)**
- 通过能够从最流行的响应格式、**[HTML](https://jmeter.apache.org/usermanual/component_reference.html#CSS/JQuery_Extractor)**、**[JSON、](https://jmeter.apache.org/usermanual/component_reference.html#JSON_Extractor)[XML](https://jmeter.apache.org/usermanual/component_reference.html#XPath_Extractor)[或任何文本格式](https://jmeter.apache.org/usermanual/component_reference.html#Regular_Expression_Extractor)**中提取数据**，**轻松关联
- 完全可移植性和**100%的Java纯度**。
- 完整的**多线程**框架允许许多线程并发采样，并通过单独的线程组同时对不同函数进行采样。
- 缓存和离线分析/重播测试结果。
- 高度可扩展的核心：
    - 可插拔采样器允许无限的测试功能。
    - **可脚本采样器**（与JSR223兼容的语言，如[Groovy](http://groovy-lang.org/)和BeanShell）
    - 可以使用**可插拔计时器**选择几个负载统计信息。
    - 数据分析和**可视化插件**允许极大的可扩展性和个性化性。
    - 函数可用于为测试提供动态输入或提供数据操作。
    - 通过Maven、Gradle和Jenkins的第三方开源库轻松连续集成。

## 我该怎么做？

- [使用JMeter](https://jmeter.apache.org/usermanual/index.html)了解如何使用它
- [组件参考](https://jmeter.apache.org/usermanual/component_reference.html)，为每个测试元素提供详细信息
- [函数引用](https://jmeter.apache.org/usermanual/functions.html)为每个函数提供详细信息和示例
- 允许您自定义JMeter的所有属性的[属性引用](https://jmeter.apache.org/usermanual/properties_reference.html)
- [Javadoc API文档](https://jmeter.apache.org/api/index.html)
- [JMeter常见问题解答（维基）](https://cwiki.apache.org/confluence/display/JMETER/JMeterFAQ)
- [JMeter Wiki](https://cwiki.apache.org/confluence/display/JMETER/Home)
- [构建JMeter和附加组件](https://jmeter.apache.org/building.html)以供高级使用

## JMeter不是浏览器

JMeter不是浏览器，它在协议级别工作。就网络服务和远程服务而言，JMeter看起来像一个浏览器（或者更确切地说，多个浏览器）；然而，JMeter不执行浏览器支持的所有操作。特别是，JMeter不执行HTML页面中的Javascript。它也不会像浏览器那样渲染HTML页面（可以将响应视为HTML等，但时间不包含在任何示例中，一次只显示一个线程中的一个示例）。

## 教程

- [分布式测试](https://jmeter.apache.org/usermanual/jmeter_distributed_testing_step_by_step.html)
- [记录测试](https://jmeter.apache.org/usermanual/jmeter_proxy_step_by_step.html)
- [JUnit采样器](https://jmeter.apache.org/usermanual/junitsampler_tutorial.html)
- [访问日志采样器](https://jmeter.apache.org/usermanual/jmeter_accesslog_sampler_step_by_step.html)
- [扩展JMeter](https://jmeter.apache.org/usermanual/jmeter_tutorial.html)

## 关于JMeter的更多信息

- [更改列表](https://jmeter.apache.org/changes.html)
- [阅读现有问题（问题或增强功能）或报告新问题（请这样做！）](https://jmeter.apache.org/issues.html)
- [许可证](https://www.apache.org/licenses/)
- [邮件列表](https://jmeter.apache.org/mail.html)
- [源存储库](https://jmeter.apache.org/svnindex.html)
- [贡献者](https://cwiki.apache.org/confluence/display/JMETER/JMeterCommitters)

## 安装

> 首先得有JDK8+的环境。

转载自：https://blog.csdn.net/fish_study_csdn/article/details/124488572

1. 下载：前往Jmeter官网下载[https://jmeter.apache.org/download_jmeter.cgi](https://links.jianshu.com/go?to=https%3A%2F%2Fjmeter.apache.org%2Fdownload_jmeter.cgi)

2. 启动：bin文件夹->sh jmeter(启动jmeter)
3. 汉化：找到bin/jmeter.properties，#language=en更改为language = zh_CN。
