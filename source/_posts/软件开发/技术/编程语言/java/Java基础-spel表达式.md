---
title: Java基础 spel表达式
tags:
    - Oracle
    - Java
    - Spel表达式
categories:
    - Java
date: 2020-07-01 12:01:01
thumbnail:
---

## 1. spel 表达式 介绍

> Spring Expression Language（简称 SpEL）是一种功能强大的表达式语言，支持运行时查询和操作对象图 。表达式语言一般是用最简单的形式完成最主要的工作，以此减少工作量。
>
> Java 有许多可用的表达式语言，例如 JSP EL，OGNL，MVEL 和 JBoss EL，SpEL 语法类似于 JSP EL，功能类似于 Struts2 中的 OGNL，能在运行时构建复杂表达式、存取对象图属性、调用对象方法等，并且能与 Spring 功能完美整合，如 SpEL 可以用来配置 Bean 定义。
>
> SpEL 并不与 Spring 直接相关，可以被独立使用。SpEL 表达式的创建是为了向 Spring 社区提供一种受良好支持的表达式语言，该语言适用于 Spring 家族中的所有产品。也就是说，SpEL 是一种与技术无关的 API，可以集成其它表达式语言。
>
> SpEL 提供了以下接口和类：
>
> - Expression interface：该接口负责评估表达式字符串
> - ExpressionParser interface：该接口负责解析字符串
> - EvaluationContext interface：该接口负责定义上下文环境
>
> 
> SpEL 支持如下表达式：
>
> #### 1. 基本表达式
>
> 字面量表达式、关系、逻辑与算术运算表达式、字符串连接及截取表达式、三目运算表达式、正则表达式、括号优先级表达式；
>
> #### 2. 类相关表达式
>
> 类类型表达式、类实例化、instanceof 表达式、变量定义及引用、赋值表达式、自定义函数、对象属性存取及安全导航表达式、对象方法调用、Bean 引用；
>
> #### 3. 集合相关表达式
>
> 内联 List、内联数组、集合、字典访问、列表、字典、数组修改、集合投影、集合选择；不支持多维内联数组初始化；不支持内联字典定义；
>
> #### 4. 其他表达式
>
> 模板表达式。
>
> > 注：SpEL 表达式中的关键字不区分大小写。

## 2. 实例

```java
package pandacode.cn;

import org.springframework.expression.Expression;
import org.springframework.expression.ExpressionParser;
import org.springframework.expression.spel.standard.SpelExpressionParser;

public class Test {
    public static void main(String[] args) {

        ExpressionParser parser = new SpelExpressionParser();
        // 运算符
        System.out.println(parser.parseExpression("1>2").getValue(Boolean.class));
        // 字符串输出
        			   System.out.println(parser.parseExpression("'https://pandacode.cn'.concat('/')").getValue(String.class));
        // 引入类处理
        System.out.println(parser.parseExpression("T(org.apache.commons.lang.StringUtils).isBlank('')").getValue(Boolean.class));

    }
}
```

输出：

```
false
https://pandacode.cn/
true
```

