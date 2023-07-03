---
title: IDEA Debug调试
tags:
  - kafka
categories:
  - 技术
date: 2022-07-01 12:01:01
thumbnail:
---

## debug 基本操作

这里主要描述这些按钮的用处。

按钮依次的用处是：

- 回到断点处
- 步过
- 步入
- 强制步入
- 步出
- 丢帧
- 运行到光标处
- 评估表达式
- 跟踪当前流链

 <img src="https://file.pandacode.cn/blog/202209252022737.png" alt="image-20220925202204677" style="zoom:50%;" /> 

### 回到断点处

当不知道当前断点停留在何处时，点击这个按钮，即可回到当前断点处。

<img src="https://file.pandacode.cn/blog/202209251958312.png" alt="image-20220925195821200" style="zoom:67%;" /> 

### 步过

正常执行下一行代码。

<img src="https://file.pandacode.cn/blog/202209252000202.png" alt="image-20220925200012141" style="zoom:67%;" /> 

### 步入

进入到方法中。

<img src="https://file.pandacode.cn/blog/202209252001741.png" alt="image-20220925200139665" style="zoom:67%;" /> 

### 强制步入

进入到方法的源码中。

<img src="https://file.pandacode.cn/blog/202209252005963.png" alt="image-20220925200509871" style="zoom:67%;" />  

### 步出

于步入相反，步出是让方法正常执行结果，并且返回到方法调用方。

<img src="https://file.pandacode.cn/blog/202209252004792.png" alt="image-20220925200418736" style="zoom:67%;" /> 

### 丢帧

如果一部分代码没有调试到，可以点击这个按钮，将断点会退到原来位置。

<img src="https://file.pandacode.cn/blog/202209252009849.png" alt="image-20220925200948768" style="zoom:67%;" /> 

###  运行到光标处

光标指定将要执行的一行代码，点击此按钮，断点会停留到光标所在的那一行。

<img src="https://file.pandacode.cn/blog/202209252011355.png" alt="image-20220925201141301" style="zoom:67%;" /> 

### 评估表达式

可以通过代码段的方式，对当前的调试内容进行进一步分析。

<img src="https://file.pandacode.cn/blog/202209252014433.png" alt="image-20220925201413360" style="zoom:67%;" /> 

<img src="https://file.pandacode.cn/blog/202209252015434.png" alt="image-20220925201529346" style="zoom: 50%;" /> 

### 跟踪当前流链

主要用于JDK8 的 Stream调试。

<img src="https://file.pandacode.cn/blog/202209252018503.png" alt="image-20220925201851445" style="zoom:67%;" /> 

针对Stream的调试，idea提供了一个很强大的功能。通过流跟踪，可以清晰的看出数据的走向。

![image-20220925202115185](https://file.pandacode.cn/blog/202209252021245.png)

## debug 高级操作

debug高级调试分为几种：

- 字段断点调试

- 异常断点调试

- 方法断点调试

- 手动制造抛出异常 和 强制返回

### 字段断点调试

字段左侧打上断点，右键断点位置，根据需要调整配置。

<img src="https://file.pandacode.cn/blog/202209250912872.png" alt="image-20220925091222581" style="zoom: 50%;" /> 

我这里选中了“字段修改时监听”。

Debug时字段如果在某个位置进行了修改，断点会自动打到修改的那行代码，详细请看下方截图。

<img src="https://file.pandacode.cn/blog/202209250919264.png" alt="image-20220925091912211" style="zoom: 50%;" /> <img src="https://file.pandacode.cn/blog/202209250919481.png" alt="image-20220925091944421" style="zoom:50%;" />

### 异常断点调试

先看一下这段代码。

```java
@Test
public void exceptionTest() {
  String str = null;
  boolean bool = str.equals("xxx");
}
```

这段代码会报一个错误：NullPointerException（空指针异常），下面我们通过debug进行捕捉NullPointerException。

首先打开debug断点面板

![image-20220925092700682](https://file.pandacode.cn/blog/202209250927737.png)

打开断点面板后，点击左上角加号（➕），选择Java异常断点，查找并添加NullPointerException。

![image-20220925092919437](https://file.pandacode.cn/blog/202209250929494.png)

这样就能够拦截到NullPointerException了。

<img src="https://file.pandacode.cn/blog/202209250931794.png" alt="image-20220925093138728" style="zoom:50%;" /> 

### 方法断点调试

在方法处加入断点，右键断点进行断点详情，可以在方法输入或输出时进行调试。

<img src="https://file.pandacode.cn/blog/202209251003678.png" alt="image-20220925100354612" style="zoom:50%;" /> 

我这里选择了方法输入和方法输出，在进行debug时，断点会停留在方法的第一行和结束行。

<img src="https://file.pandacode.cn/blog/202209251007157.png" alt="image-20220925100741094" style="zoom:50%;" /> <img src="https://file.pandacode.cn/blog/202209251013297.png" alt="image-20220925100808169" style="zoom:50%;" />

### 手动制造抛出异常 和 强制返回

在线程执行过程中，想在某一行代码手动的制造异常抛出或者强制返回，只需要在当前帧右键，选择抛出异常（或者强制返回），输入异常值（或者返回数据），即可直接抛出异常（或者返回）。

<img src="https://file.pandacode.cn/blog/202209251018363.png" alt="image-20220925101818301" style="zoom:50%;" /> 

<img src="https://file.pandacode.cn/blog/202209251021623.png" alt="image-20220925102152560" style="zoom:50%;" /> 

## debug 调试远端服务

如果通过debug 调试远端服务的代码，下面描述几种方式。

### 服务启动时添加参数

> 切记，仅可以用于测试环境。

```shell
oracle-java -jar -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005
```

