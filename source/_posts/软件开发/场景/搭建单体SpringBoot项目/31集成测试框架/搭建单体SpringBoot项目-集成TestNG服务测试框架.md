---
title: 搭建单体SpringBoot项目 集成TestNG服务测试框架
tags:
    - SpringBoot
    - 集成
    - TestNG
    - 测试
categories:
    - 技术
    - 搭建单体SpringBoot项目
date: 2022-07-01 12:01:01
thumbnail:
---

## 1. maven

```xml
<dependency>
  <groupId>org.testng</groupId>
  <artifactId>testng</artifactId>
  <version>6.8.7</version>
  <scope>test</scope>
</dependency>
<dependency>
  <groupId>junit</groupId>
  <artifactId>junit</artifactId>
  <version>3.8.1</version>
  <scope>test</scope>
</dependency>

```

## 2. 概念

> TestNG按照官方的定义：
>
> **TestNG**是一个测试框架，其灵感来自JUnit和NUnit，但引入了一些新的功能，使其功能更强大，使用更方便。
>
> TestNG是一个开源自动化测试框架;TestNG表示**下一代**(**N**ext **G**eneration的首字母)。 TestNG类似于JUnit(特别是JUnit 4)，但它不是JUnit框架的扩展。它的灵感来源于JUnit。它的目的是优于JUnit，尤其是在用于测试集成多类时。 TestNG的创始人是**Cedric Beust**(塞德里克·博伊斯特)。
>
> TestNG消除了大部分的旧框架的限制，使开发人员能够编写更加灵活和强大的测试。 因为它在很大程度上借鉴了Java注解(JDK5.0引入的)来定义测试，它也可以显示如何使用这个新功能在真实的Java语言生产环境中。
>
> **TestNG的特点**
>
> - 注解
> - TestNG使用Java和面向对象的功能
> - 支持综合类测试(例如，默认情况下，不用创建一个新的测试每个测试方法的类的实例)
> - 独立的编译时测试代码和运行时配置/数据信息
> - 灵活的运行时配置
> - 主要介绍“测试组”。当编译测试，只要要求`TestNG`运行所有的“前端”的测试，或“快”，“慢”，“数据库”等
> - 支持依赖测试方法，并行测试，负载测试，局部故障
> - 灵活的插件API
> - 支持多线程测试



## 3. TestNG 基本注解



### 3.1. 注解列表

以下是TestNG支持的注释列表：

| 注解            | 描述                                                         |
| --------------- | ------------------------------------------------------------ |
| `@BeforeSuite`  | 在该套件的所有测试都运行在注释的方法之前，仅运行一次。       |
| `@AfterSuite`   | 在该套件的所有测试都运行在注释方法之后，仅运行一次。         |
| `@BeforeClass`  | 在调用当前类的第一个测试方法之前运行，注释方法仅运行一次。   |
| `@AfterClass`   | 在调用当前类的第一个测试方法之后运行，注释方法仅运行一次     |
| `@BeforeTest`   | 注释的方法将在属于`<test>`标签内的类的所有测试方法运行之前运行。 |
| `@AfterTest`    | 注释的方法将在属于`<test>`标签内的类的所有测试方法运行之后运行。 |
| `@BeforeGroups` | 配置方法将在之前运行组列表。 此方法保证在调用属于这些组中的任何一个的第一个测试方法之前不久运行。 |
| `@AfterGroups`  | 此配置方法将在之后运行组列表。该方法保证在调用属于任何这些组的最后一个测试方法之后不久运行。 |
| `@BeforeMethod` | 注释方法将在每个测试方法之前运行。                           |
| `@AfterMethod`  | 注释方法将在每个测试方法之后运行。                           |
| `@DataProvider` | 标记一种方法来提供测试方法的数据。 注释方法必须返回一个`Object [] []`，其中每个`Object []`可以被分配给测试方法的参数列表。 要从该`DataProvider`接收数据的`@Test`方法需要使用与此注释名称相等的`dataProvider`名称。 |
| `@Factory`      | 将一个方法标记为工厂，返回`TestNG`将被用作测试类的对象。 该方法必须返回`Object []`。 |
| `@Listeners`    | 定义测试类上的侦听器。                                       |
| `@Parameters`   | 描述如何将参数传递给`@Test`方法。                            |
| `@Test`         | 将类或方法标记为测试的一部分。                               |

### 3.2. 忽略测试

> 默认enabled为true。默认测试用例是开启状态。

```java
@Test(enabled = false)
```

### 3.3. 超时处理

> 超时处理，常用来做性能测试，超过时间会报错。单位：毫秒。

```java
@Test(timeOut = 5000)
```



### 3.4. 使用注释/注解的好处

以下是使用注释/注解的一些好处：

- TestNG通过查找注释/注解来识别它感兴趣的方法。 因此，方法名称不限于任何模式或格式。
- 可以将其他参数传递给注释。
- 注释是强类型的，所以编译器会马上标记任何错误。
- 测试类不再需要扩展任何东西(如TestCase，对于JUnit3)。

## 4. TestNG - DataProvider（注解）数据提供者

> 测试参数化能让测试大量的数据集变为可能，也大大方便数据的修改和测试脚本的编写，测试参数化让数据和脚本分离开来，方便后续的维护。
> 这一篇先来说说数据提供者DataProvider

**数据提供者@DataProvider**
注解@DataProvider在参数化测试中起到重要的作用，该注解下的函数返回数据类型需要时Object[][]，看例子如何实现：

### 4.1. 使用

@DataProvider函数，需要定义属性name

```java
@DataProvider(name = "testcase")
public Object[][] dataProvider(){
    return new Object[][]{
            {"小李"},
            {"小赵"},
            {"小明"},
            {"小周"}
    };
}
```

```java
// @Test测试用例，属性dataProvider需要指定对应的数据提供者名称
@Test(dataProvider = "testcase")
public void testcase(String name){
    System.out.println(name);
}

```

执行结果

```
create test :com.testproj.Demo.TestDataProvider@38bc8ab5
[TestNG] Running:
  E:\OPPO\JavaProject\TestNGProj\res\testNG.xml
小李
小赵
小明
小周
```

### 4.2. 备注

#### 4.2.1. 注解使用

1. DataProvider注解name属性和Test对应dataProvider属性可以进行绑定。

#### 4.2.2. 返回结构`Object[][]`

1. `Object[][]`每层都会调用一次测试用例。上面的例子，会调用四次对应的testcase测试用例。

2. `Object[][]`一层可以放入多个属性，例：

```java
@DataProvider(name = "testcase")
public Object[][] dataProvider(){
    return new Object[][]{
            {"小李", 19, "男", 187},
            {"小王", 19, "女", 167},
            {"小组", 19, "男", 174},
            {"小六", 19, "男", 179}
    };
}
@Test(dataProvider = "testcase")
public void testcase(String name, long age, String sex, long height){
    System.out.println("姓名："+name+"；年龄："+age+"；性别："+sex+"；身高："+height);
}
```

3. `Object[][]`每层的参数数量和参数类型必须相同。



### 4.3. 提供数据方式

1. 硬编码在Java源码上。
2. txt文本文件。
3. 配置文件properties。
4. excel文档。
5. 数据库。
6. 网络中。

