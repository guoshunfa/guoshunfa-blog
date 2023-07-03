---
title: Oracle Java注解
tags:
    - oracle
    - java
categories:
    - 技术
date: 2022-07-01 12:01:01
thumbnail:
---

> 本文章以jdk8为基础进行编写，如果想查看后续的版本可以前往jdk版本目录下查看。
>
> 翻译自：https://docs.oracle.com/javase/tutorial/java/annotations/index.html

注解是元数据的一种形式，它提供关于程序的数据，而不是程序本身的一部分。注释对它们所注解的代码的操作没有直接影响。

注解有多种用途，其中包括：

- **编译器信息** — 编译器可以使用注解来检测错误或抑制警告。
- **编译时和部署时处理** — 软件工具可以处理注解信息以生成代码、XML文件等。
- **运行时处理** — 某些注解可在运行时检查。

## 注解基础

### 注解的格式

在最简单的形式中，注释如下所示：

```java
@Entity
```

at符号字符（@）向编译器表示后面是注释。在以下示例中，注释的名称为“覆盖”：

```java
@Override
void mySuperMethod() { ... }
```

注释可以包括可以命名或未命名的元素，这些元素有值：

```java
@Author(
   name = "Benjamin Franklin",
   date = "3/27/2003"
)
class MyClass { ... }
```

或者

```java
@SuppressWarnings(value = "unchecked")
void myMethod() { ... }
```

如果只有一个名为value的元素，则可以省略该名称，如：

```java
@SuppressWarnings("unchecked")
void myMethod() { ... }
```

如果注释没有元素，则可以省略括号，如前面的@Override示例所示。

也可以在同一声明上使用多个注释： 

```java
@Author(name = "Jane Doe")
@EBook
class MyClass { ... }
```

如果注释具有相同的类型，则称为重复注释：

```java
@Author(name = "Jane Doe")
@Author(name = "John Smith")
class MyClass { ... }
```

自Java SE 8发行版起，支持重复注释。有关详细信息，请参见[Repeating Annotations](https://docs.oracle.com/javase/tutorial/java/annotations/repeating.html).。

注释类型可以是在java中定义的类型之一。lang或java.lang.annotation包。在前面的示例中，Override和SuppressWarnings是预定义的Java注释。也可以定义自己的注释类型。上一个示例中的Author和Ebook注释是自定义注释类型。

### 可以使用注释的位置

注释可以应用于声明：类、字段、方法和其他程序元素的声明。在声明中使用时，按照惯例，每个注释通常显示在自己的行上。

从JavaSE8版本开始，注释也可以应用于类型的使用。以下是一些示例：

- 类实例创建表达式：

```java
new @Interned MyObject();
```

- 类型铸造:

```java
 myString = (@NonNull String) str;
```

- implements子句：

```java
  class UnmodifiableList<T> implements
        @Readonly List<@Readonly T> { ... }
```

- 引发异常声明：

```java
 void monitorTemperature() throws
        @Critical TemperatureException { ... }
```

这种形式的注释称为类型注释。有关详细信息，请参见 [Type Annotations and Pluggable Type Systems](https://docs.oracle.com/javase/tutorial/java/annotations/type_annotations.html).。

## 声明批注类型

许多注释替换代码中的注释。

假设一个软件组传统上以提供重要信息的注释开始每个类的主体：

```java
public class Generation3List extends Generation2List {

   // Author: John Doe
   // Date: 3/17/2002
   // Current revision: 6
   // Last modified: 4/12/2004
   // By: Jane Doe
   // Reviewers: Alice, Bill, Cindy

   // class code goes here

}
```

若要将此相同的元数据与注释一起添加，必须首先定义注释类型。执行此操作的语法为：

```java
@interface ClassPreamble {
   String author();
   String date();
   int currentRevision() default 1;
   String lastModified() default "N/A";
   String lastModifiedBy() default "N/A";
   // Note use of array
   String[] reviewers();
}
```

注释类型定义看起来类似于一个接口定义，其中关键字接口前面有at符号（@）（@=at，如注释类型）。注释类型是一种界面形式，将在后面的课程中介绍。目前，您不需要了解接口。

前一个注释定义的主体包含注释类型元素声明，看起来很像方法。请注意，它们可以定义可选的默认值。

定义注释类型后，可以使用该类型的注释，并填充值，如下所示：

```java
@ClassPreamble (
   author = "John Doe",
   date = "3/17/2002",
   currentRevision = 6,
   lastModified = "4/12/2004",
   lastModifiedBy = "Jane Doe",
   // Note array notation
   reviewers = {"Alice", "Bob", "Cindy"}
)
public class Generation3List extends Generation2List {

// class code goes here

}
```

==注意：要使@ClassPreamble中的信息显示在Javadoc生成的文档中，必须使用@Documented注释注释@ClassPremable定义：==

```java
// import this to use @Documented
import java.lang.annotation.*;

@Documented
@interface ClassPreamble {

   // Annotation element definitions
   
}
```

## 预定义的注释类型

Java SE API中预定义了一组注释类型。一些注释类型由Java编译器使用，有些则适用于其他注释。

### Java语言使用的注释类型

在java中定义的预定义注释类型。lang是@Deprecated、@Override和@SuppressWarnings。

 [`@Deprecated`](https://docs.oracle.com/javase/8/docs/api/java/lang/Deprecated.html) 注释表示标记的元素已弃用，不应再使用。每当程序使用带有@Deprecated注释的方法、类或字段时，编译器都会生成警告。当元素被弃用时，还应使用Javadoc@deprecated标记对其进行记录，如下例所示。在Javadoc注释和注释中使用at符号（@）并非巧合：它们在概念上是相关的。此外，请注意，Javadoc标记以小写d开头，注释以大写d开头。

```java
   // Javadoc comment follows
    /**
     * @deprecated
     * explanation of why it was deprecated
     */
    @Deprecated
    static void deprecatedMethod() { }
}
```

 [`@Override`](https://docs.oracle.com/javase/8/docs/api/java/lang/Override.html) 注释通知编译器该元素将覆盖在超类中声明的元素。重写方法将在接口和继承中讨论。

```java
   // mark method as a superclass method
   // that has been overridden
   @Override 
   int overriddenMethod() { }
```

虽然重写方法时不需要使用此注释，但它有助于防止错误。如果标记为@Override的方法未能正确覆盖其超类之一中的方法，编译器将生成错误。

 [`@SuppressWarnings`](https://docs.oracle.com/javase/8/docs/api/java/lang/SuppressWarnings.html) 注释告诉编译器抑制否则将生成的特定警告。在以下示例中，使用了不推荐使用的方法，编译器通常会生成警告。但是，在这种情况下，注释会导致警告被抑制。

```java
   // use a deprecated method and tell 
   // compiler not to generate a warning
   @SuppressWarnings("deprecation")
    void useDeprecatedMethod() {
        // deprecation warning
        // - suppressed
        objectOne.deprecatedMethod();
    }
```

每个编译器警告都属于一个类别。Java语言规范列出了两个类别：弃用和未选中。当与泛型出现之前编写的遗留代码交互时，可能会出现未经检查的警告。要抑制多个类别的警告，请使用以下语法：

```java
@SuppressWarnings({"unchecked", "deprecation"})
```

 [`@SafeVarargs`](https://docs.oracle.com/javase/8/docs/api/java/lang/SafeVarargs.html)注释应用于方法或构造函数时，断言代码不会对其varargs参数执行潜在的不安全操作。使用此注释类型时，将禁止与varargs用法相关的未选中警告。

 [`@FunctionalInterface`](https://docs.oracle.com/javase/8/docs/api/java/lang/FunctionalInterface.html) @JavaSE8中引入的，类型声明旨在成为Java语言规范定义的功能接口。

### 应用于其他注释的注释

应用于其他注释的注释称为元注释。java.lang.annotation中定义了几种元注释类型。

 [`@Retention`](https://docs.oracle.com/javase/8/docs/api/java/lang/annotation/Retention.html) 注释指定如何存储标记的注释：

- `RetentionPolicy.SOURCE` – 标记的注释仅保留在源级别，编译器将忽略它。
- `RetentionPolicy.CLASS` – 标记的注释在编译时由编译器保留，但被Java虚拟机（JVM）忽略。
- `RetentionPolicy.RUNTIME` – 标记的注释由JVM保留，因此可以由运行时环境使用。

[`@Documented`](https://docs.oracle.com/javase/8/docs/api/java/lang/annotation/Documented.html) annotation表示无论何时使用指定的注释，都应该使用Javadoc工具记录这些元素。（默认情况下，注释不包含在Javadoc中。）有关更多信息，请参阅[Javadoc tools page](https://docs.oracle.com/javase/8/docs/technotes/guides/javadoc/index.html).。

[`@Target`](https://docs.oracle.com/javase/8/docs/api/java/lang/annotation/Target.html) annotation标记另一个注释，以限制注释可以应用于哪种Java元素。目标注释指定以下元素类型之一作为其值：

- `ElementType.ANNOTATION_TYPE` 可以应用于注释类型。
- `ElementType.CONSTRUCTOR` 可以应用于构造函数。
- `ElementType.FIELD` 可以应用于字段或属性。
- `ElementType.LOCAL_VARIABLE` 可以应用于局部变量。
- `ElementType.METHOD` 可以应用于方法级注释。
- `ElementType.PACKAGE` 可以应用于包声明。
- `ElementType.PARAMETER` 可以应用于方法的参数。
- `ElementType.TYPE` 可以应用于类的任何元素。

[`@Inherited`](https://docs.oracle.com/javase/8/docs/api/java/lang/annotation/Inherited.html) annotation表示注释类型可以从超类继承。（默认情况下，这不是真的。）当用户查询注释类型并且类没有该类型的注释时，将查询类的超类以获取注释类型。此注释仅适用于类声明。

[`@Repeatable`](https://docs.oracle.com/javase/8/docs/api/java/lang/annotation/Repeatable.html) annotation, Java SE 8中引入的标记注释表示标记注释可以多次应用于同一声明或类型使用。关于更多信息， see [Repeating Annotations](https://docs.oracle.com/javase/tutorial/java/annotations/repeating.html).

## 类型注释和可插拔类型系统

在JavaSE8发布之前，注释只能应用于声明。从Java SE 8版本开始，注释也可以应用于任何*类型的使用*。这意味着可以在使用类型的任何地方使用注释。使用类型的几个例子是类实例创建表达式（“new”）、强制转换、“implements”子句和“throws”子句。这种形式的注释称为*类型注释* [Annotations Basics](https://docs.oracle.com/javase/tutorial/java/annotations/basics.html).

创建类型注释是为了支持改进的Java程序分析，以确保更强的类型检查。Java SE 8发行版不提供类型检查框架，但它允许您编写（或下载）一个类型检查框架。

例如，您希望确保程序中的特定变量永远不会赋值为null；您希望避免触发“NullPointerException”。您可以编写一个自定义插件来检查这一点。然后，您将修改代码以注释该特定变量，表明它从未赋值为null。变量声明可能如下所示：

```java
@NonNull String str;
```

当您编译代码时，包括命令行中的“NonNull”模块，如果编译器检测到潜在问题，就会打印警告，允许您修改代码以避免错误。更正代码以删除所有警告后，程序运行时不会发生此特定错误。

您可以使用多个类型检查模块，其中每个模块检查不同类型的错误。通过这种方式，您可以在Java类型系统的基础上进行构建，在需要的时间和位置添加特定的检查。

通过明智地使用类型注释和可插入类型检查器，您可以编写更强大、更不容易出错的代码。

在许多情况下，您不必编写自己的类型检查模块。有第三方为您完成了这项工作。例如，您可能希望利用华盛顿大学创建的Checker框架。该框架包括“NonNull”模块、正则表达式模块和互斥锁模块。关于更多信息， see the [Checker Framework](http://types.cs.washington.edu/checker-framework/).

## 重复注释

在某些情况下，您希望将相同的注释应用于声明或类型使用。从Java SE 8版本开始，*重复注释*使您能够做到这一点。

例如，您正在编写代码以使用计时器服务，该服务使您能够在给定时间或按特定计划运行方法，类似于UNIX“cron”服务。现在，您要设置一个计时器，以在每月的最后一天和每周五晚上11:00运行一个方法“doPeriodCleanup”。若要设置计时器，请创建一个“@Schedule”注释，并将其应用于“doPeriodicCleanup”方法两次。第一次使用指定一个月的最后一天，第二次使用指定星期五晚上11点，如以下代码示例所示：

```java
@Schedule(dayOfMonth="last")
@Schedule(dayOfWeek="Fri", hour="23")
public void doPeriodicCleanup() { ... }
```

上一个示例将注释应用于方法。可以在使用标准注释的任何位置重复注释。例如，您有一个用于处理未授权访问异常的类。您为管理者和管理员分别使用一个“@Alert”注释来注释类：

```java
@Alert(role="Manager")
@Alert(role="Administrator")
public class UnauthorizedAccessException extends SecurityException { ... }
```

出于兼容性原因，重复注释存储在Java编译器自动生成的*容器注释*中。为了让编译器执行此操作，代码中需要两个声明。

### Step 1: 声明可重复注释类型

批注类型必须标记为“@Repeatable”元批注。以下示例定义了自定义的“@Schedule”可重复注释类型：

```java
import java.lang.annotation.Repeatable;

@Repeatable(Schedules.class)
public @interface Schedule {
  String dayOfMonth() default "first";
  String dayOfWeek() default "Mon";
  int hour() default 12;
}
```

括号中的“@Repeatable”元注释的值是Java编译器为存储重复注释而生成的容器注释的类型。在此示例中，包含的批注类型为“Schedules”，因此重复的“@Schedule”批注存储在“@Schedules”批注中。

将同一注释应用于声明而不首先声明它是可重复的，将导致编译时错误。

### Step 2: 声明包含批注类型

包含批注类型必须具有数组类型的“value”元素。数组类型的组件类型必须是可重复的注释类型。包含注释类型的“Schedules”的声明如下：

```java
public @interface Schedules {
    Schedule[] value();
}
```

### 正在检索批注

反射API中有几种方法可用于检索注释。返回单个注释的方法的行为，如[AnnotatedElement.getAnnotation（Class）](https://docs.oracle.com/javase/8/docs/api/java/lang/reflect/AnnotatedElement.html#getAnnotation-java.lang.Class-)是不变的，因为它们仅在存在所请求类型的*一个*注释时返回单个注释。如果存在多个请求类型的注释，则可以通过首先获取它们的容器注释来获取它们。这样，遗留代码继续工作。JavaSE8中引入了其他方法，可以扫描容器注释以同时返回多个注释，例如[AnnotatedElement.getAnnotationsByType（Class）](https://docs.oracle.com/javase/8/docs/api/java/lang/reflect/AnnotatedElement.html#getAnnotationsByType-java.lang.Class-)。参见[AnnotatedElement](https://docs.oracle.com/javase/8/docs/api/java/lang/reflect/AnnotatedElement.html)有关所有可用方法的信息的类规范。

### 设计注意事项

设计注释类型时，必须考虑该类型注释的*基数*。现在可以零次、一次或多次使用注释，如果注释的类型标记为“@Repeatable”。还可以通过使用“@Target”元注释来限制可以使用注释类型的位置。例如，您可以创建只能用于方法和字段的可重复注释类型。仔细设计注释类型非常重要，以确保程序员*使用*注释时发现它尽可能灵活和强大。
