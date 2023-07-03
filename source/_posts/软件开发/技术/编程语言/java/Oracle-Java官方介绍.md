---
title: Oracle Java官方介绍
tags:
    - oracle
    - java
categories:
    - 技术
date: 2022-07-01 12:01:01
thumbnail:
---
# Oracle Java官方介绍

> 本文章以jdk8为基础进行编写，如果想查看后续的版本可以前往jdk版本目录下查看。
>
> 翻译自：https://docs.oracle.com/javase/tutorial/getStarted/intro/definition.html

## 关于 Java 技术

Java 技术既是一种编程语言又是一个平台。

### Java 编程语言

Java 编程语言是一种高级语言，具有以下所有流行语的特征：

- 简单的面向对象分散式多线程动态的
- 架构中立便携的高性能强大的安全的

在James Gosling 和 Henry McGilton 撰写的白皮书[*The Java Language Environment*](http://www.oracle.com/technetwork/java/langenv-140151.html)中解释了前面的每个流行语 。

在 Java 编程语言中，所有源代码首先写在以扩展名`.java`结尾的纯文本文件中。这些源文件通过`javac`编译器编译成`.class`文件。`.class`文件不包含处理器的本机代码；它包含*字节码*——Java 虚拟机[1](https://docs.oracle.com/javase/tutorial/getStarted/intro/definition.html#FOOT)(Java VM) 的机器语言。启动器`java`工具然后使用 Java 虚拟机实例运行您的应用程序。

![该图显示了在计算机上运行的 MyProgram.java、编译器、MyProgram.class、Java VM 和我的程序。](Oracle-Java官方介绍/getStarted-compiler.gif)



软件开发过程的概述。

因为 Java VM 在许多不同的操作系统上可用，所以相同的`.class`文件能够在 Microsoft Windows、Solaris™ 操作系统 (Solaris OS)、Linux 或 Mac OS 上运行。一些虚拟机，例如 [Java SE HotSpot 概览](http://www.oracle.com/technetwork/java/javase/tech/index-jsp-136373.html)，会在运行时执行额外的步骤来提高您的应用程序的性能。这包括各种任务，例如查找性能瓶颈和重新编译（到本机代码）经常使用的代码部分。

![该图显示了用于 Win32、Solaris OS/Linux 和 Mac OS 的源代码、编译器和 Java VM](Oracle-Java官方介绍/helloWorld.gif)



通过Java VM，同一个应用程序可以运行在多个平台上。

### Java 平台

*平台*是程序运行的硬件或软件环境。我们已经提到了一些最流行的平台，例如 Microsoft Windows、Linux、Solaris OS 和 Mac OS。大多数平台可以描述为操作系统和底层硬件的组合。Java 平台不同于大多数其他平台，因为它是一个运行在其他基于硬件的平台之上的纯软件平台。

Java 平台有两个组件：

- *Java 虚拟*机
- *Java 应用程序编程接口*( API)

您已经了解了 Java 虚拟机；它是 Java 平台的基础，并被移植到各种基于硬件的平台上。

API 是大量现成软件组件的集合，可提供许多有用的功能。它被分组为相关类和接口的库；这些库被称为*包*。

## Java 技术能做什么？

通用的高级 Java 编程语言是一个功能强大的软件平台。Java 平台的每个完整实现都为您提供以下功能：

- **开发工具**：开发工具提供了编译、运行、监控、调试和记录应用程序所需的一切。作为新开发人员，您将使用的主要工具是`javac`编译器、`java`启动器和`javadoc`文档工具。
- **应用程序编程接口 (API)**：API 提供 Java 编程语言的核心功能。它提供了大量有用的类，可以在您自己的应用程序中使用。它涵盖了从基本对象到网络和安全，再到 XML 生成和数据库访问等方方面面。核心API非常庞大；要大致了解它包含的内容，请参阅 [Java Platform Standard Edition 8 文档](https://docs.oracle.com/javase/8/docs/index.html)。
- **部署技术**：JDK 软件提供标准机制，例如 Java Web Start 软件和 Java Plug-In 软件，用于将您的应用程序部署到最终用户。
- **用户界面工具包**：JavaFX、Swing 和 Java 2D 工具包使创建复杂的图形用户界面 (GUI) 成为可能。
- **集成库**：Java IDL API、JDBC API、Java Naming and Directory Interface (JNDI) API、Java RMI 和 Java Remote Method Invocation over Internet ORB 间协议技术（Java RMI-IIOP 技术）等集成库支持数据库访问和操纵远程对象。

## Java 技术将如何改变我的生活？

如果您学习 Java 编程语言，我们不能向您保证名利，甚至工作。不过，它可能会使您的程序更好，并且比其他语言需要更少的努力。我们相信 Java 技术将帮助您做到以下几点：

- **快速上手**：虽然 Java 编程语言是一种功能强大的面向对象语言，但它易于学习，特别是对于已经熟悉 C 或 C++ 的程序员而言。
- **编写更少的代码**：程序指标（类计数、方法计数等）的比较表明，用 Java 编程语言编写的程序比用 C++ 编写的相同程序小四倍。
- **编写更好**的代码：Java 编程语言鼓励良好的编码习惯，自动垃圾收集可帮助您避免内存泄漏。它的面向对象、JavaBeans™ 组件体系结构以及范围广泛、易于扩展的 API 让您可以重用现有的、经过测试的代码并减少引入的错误。
- **更快地开发程序**：Java 编程语言比 C++ 更简单，因此，使用它编写时，您的开发时间最多可缩短一倍。您的程序也将需要更少的代码行。
- **避免平台依赖性**：您可以通过避免使用以其他语言编写的库来保持程序的可移植性。
- **编写一次，随处运行**：因为用 Java 编程语言编写的应用程序被编译成与机器无关的字节码，所以它们可以在任何 Java 平台上一致地运行。
- **更轻松地分发软件**：使用 Java Web Start 软件，用户只需单击鼠标即可启动您的应用程序。启动时的自动版本检查可确保用户始终使用最新版本的软件。如果有更新可用，Java Web Start 软件将自动更新其安装。
