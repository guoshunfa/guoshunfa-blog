---
title: Oracle Java Packages
tags:
    - Oracle
    - Java
categories:
    - Java
date: 2020-07-01 12:01:01
thumbnail:
---


> 本文章以jdk8为基础进行编写，如果想查看后续的版本可以前往jdk版本目录下查看。
>
> 翻译自：https://docs.oracle.com/javase/tutorial/java/package/index.html

本课程介绍如何将类和接口绑定到包中，如何使用包中的类，以及如何安排文件系统，以便编译器可以找到源文件。

## 创建和使用包

为了使类型更易于查找和使用，避免命名冲突，并控制访问，程序员将相关类型的组打包到包中。

------

**释义:** *包*是一组提供访问保护和名称空间管理的相关类型。注意，*types*指的是类、接口、枚举和注释类型。枚举和注释类型分别是特殊类型的类和接口，因此*类型*在本课中通常简称为*类和接口*。

------

作为Java平台一部分的类型是按函数捆绑类的各种包的成员：基本类在`Java.lang`，用于读和写（输入和输出）的类在`java.io`等等。您也可以将类型放入包中。

假设您编写了一组表示图形对象的类，例如圆、矩形、直线和点。您还可以编写一个接口“Draggable”，如果可以用鼠标拖动，则类可以实现该接口。  

```java
//in the Draggable.java file
public interface Draggable {
    ...
}

//in the Graphic.java file
public abstract class Graphic {
    ...
}

//in the Circle.java file
public class Circle extends Graphic
    implements Draggable {
    . . .
}

//in the Rectangle.java file
public class Rectangle extends Graphic
    implements Draggable {
    . . .
}

//in the Point.java file
public class Point extends Graphic
    implements Draggable {
    . . .
}

//in the Line.java file
public class Line extends Graphic
    implements Draggable {
    . . .
}
```

出于以下几个原因，您应该将这些类和接口捆绑在一个包中：

- 您和其他程序员可以很容易地确定这些类型是相关的。
- 您和其他程序员知道在哪里可以找到可以提供图形相关功能的类型。
- 您的类型名称不会与其他包中的类型名称冲突，因为该包创建了一个新的命名空间。
- 您可以允许包内的类型彼此无限制地访问，但仍然限制包外类型的访问。

## 创建包

要创建包，请为包选择一个名称（命名约定将在下一节中讨论），并在包含要包含在包中的类型（类、接口、枚举和注释类型）的*每个源文件*的顶部放置一个具有该名称的“package”语句。

package语句（例如，“package graphics；”）必须是源文件中的第一行。每个源文件中只能有一个package语句，它适用于文件中的所有类型。

------

**Note:** 如果在一个源文件中放置多个类型，则只有一个类型可以是“public”，并且必须与源文件同名。例如，您可以在文件“Circle”中定义“public class Circle”。java`，在文件`Draggable中定义`public interface Draggable`。java`，在文件`Day中定义`public enum Day`。java等。

您可以将非公共类型与公共类型包含在同一文件中（强烈建议这样做，除非非公共类型较小且与公共类型密切相关），但只有公共类型可以从包外部访问。所有顶级的非公共类型都将是*package private*。

------

如果将上一节中列出的图形界面和类放在名为“graphics”的包中，则需要六个源文件，如下所示：

```java
//in the Draggable.java file
package graphics;
public interface Draggable {
    . . .
}

//in the Graphic.java file
package graphics;
public abstract class Graphic {
    . . .
}

//in the Circle.java file
package graphics;
public class Circle extends Graphic
    implements Draggable {
    . . .
}

//in the Rectangle.java file
package graphics;
public class Rectangle extends Graphic
    implements Draggable {
    . . .
}

//in the Point.java file
package graphics;
public class Point extends Graphic
    implements Draggable {
    . . .
}

//in the Line.java file
package graphics;
public class Line extends Graphic
    implements Draggable {
    . . .
}
```

如果不使用“package”语句，则类型将以未命名的包结尾。一般来说，未命名的包仅适用于小型或临时应用程序，或者您刚刚开始开发过程时。否则，类和接口属于命名包。

## 命名程序包

随着世界各地的程序员使用Java编程语言编写类和接口，许多程序员可能会对不同的类型使用相同的名称。事实上，上一个示例就是这样做的：当`java中已经有`Rectance`类时，它定义了`Rectange`类。awt`包。尽管如此，如果两个类位于不同的包中，编译器允许它们具有相同的名称。每个“矩形”类的完全限定名包括包名。也就是说，“graphics”包中“Rectangle”类的完全限定名称是“graphics。矩形”，以及“java”中“矩形”类的完全限定名称。`awt`包是`java.awt.Rectangle `。

除非两个独立的程序员对他们的包使用相同的名称，否则这很有效。是什么防止了这个问题？习俗

### 命名惯例

包名称以小写字母书写，以避免与类或接口的名称冲突。

公司使用其反向的互联网域名来开始其软件包名称，例如“com.example”。mypackage”表示由程序员在“example.com”创建的名为“mypackage”的包。

在一家公司内发生的名称冲突需要按照该公司内的惯例进行处理，可能是在公司名称后包含地区或项目名称（例如，“com.example.gregion.mypackage”）。

Java语言本身的包以“Java”开头或`javax`

在某些情况下，internet域名可能不是有效的软件包名称。如果域名包含连字符或其他特殊字符，如果包名以数字或其他非法用作Java名称开头的字符开头，或者包名包含保留的Java关键字（如“int”），则可能发生这种情况。在这种情况下，建议的惯例是添加下划线。例如：

| Domain Name                   | Package Name Prefix           |
| ----------------------------- | ----------------------------- |
| `hyphenated-name.example.org` | `org.example.hyphenated_name` |
| `example.int`                 | `int_.example`                |
| `123name.example.com`         | `com.example._123name`        |

## 使用包成员

组成包的类型称为*包成员*。

要从包外部使用“public”包成员，必须执行以下操作之一：

- 通过成员的完全限定名称引用该成员
- 导入包成员
- 导入成员的整个包

如以下各节所述，每一项都适用于不同的情况。

### 通过其限定名称引用包成员

到目前为止，本教程中的大多数示例都通过简单的名称来引用类型，例如“Rectangle”和“StackOfInts”。如果正在编写的代码与包成员位于同一个包中，或者该成员已导入，则可以使用包成员的简单名称。

但是，如果您试图使用其他包中的成员，而该包尚未导入，则必须使用该成员的完全限定名，其中包括包名。这是上一个示例中图形包中声明的Rectangle类的完全限定名称。

```
graphics.Rectangle
```

您可以使用此限定名称创建“graphics.Rectangle”的实例：

```java
graphics.Rectangle myRect = new graphics.Rectangle();
```

限定名称对于不经常使用来说是合适的。然而，当重复使用名称时，重复键入名称会变得乏味，代码也会变得难以阅读。作为替代方案，您可以*导入*成员或其包，然后使用其简单名称。

### 导入包成员

要将特定成员导入到当前文件中，请在文件开头的任何类型定义之前，但在“package”语句之后（如果有）放置“import”语句。下面是如何从上一节中创建的“graphics”包中导入“Rectangle”类。

```java
import graphics.Rectangle;
```

现在，您可以通过简单的名称引用“Rectangle”类。

```java
Rectangle myRectangle = new Rectangle();
```

如果您只使用“graphics”包中的几个成员，那么这种方法很有效。但是如果您使用包中的许多类型，则应该导入整个包。

### 导入整个包

要导入特定包中包含的所有类型，请使用带有星号“（*）”通配符的“import”语句。

```java
import graphics.*;
```

现在，您可以通过简单的名称引用“graphics”包中的任何类或接口。

```java
Circle myCircle = new Circle();
Rectangle myRectangle = new Rectangle();
```

“import”语句中的星号只能用于指定包中的所有类，如下所示。它不能用于匹配包中的类的子集。例如，以下内容不匹配“graphics”包中以“A”开头的所有类。

```java
// does not work
import graphics.A*;
```

相反，它会生成编译器错误。使用“import”语句，通常只导入单个包成员或整个包。

------

**Note:** 另一种不太常见的“import”形式允许您导入封闭类的公共嵌套类。例如，如果“graphics。矩形类包含有用的嵌套类，如矩形。DoubleWide`和`Rectangle。Square'，您可以使用以下*two*语句导入“Rectangle”及其嵌套类。

```java
import graphics.Rectangle;
import graphics.Rectangle.*;
```

请注意，第二条import语句不会*导入“矩形”。

另一种不太常见的“import”形式，即*static import语句*，将在本节末尾讨论。

------

为了方便起见，Java编译器为每个源文件自动导入两个完整的包：（1）`Java.lang`包和（2）当前包（当前文件的包）。

### 包的表观层次结构

起初，包看起来是分层的，但实际上不是。例如，Java API包含一个`Java。awt`包，一个`java.awt.color`包，一个`java.awt`。字体“package”，以及许多以“java.awt”开头的其他字体。然而，`java.awt.color`包，即`java.awt`。`font`package和其他`java.awt.xxxx`包*不包含*在`java.awt`包。前缀`java.awt`（Java抽象窗口工具包）用于许多相关的包，以使关系变得明显，但不显示包含。

正在导入`java.awt.*`导入`java中的所有类型。awt`包，但它*不导入*`java.awt.color`，`java.awt.color`或任何其他`java.awt.xxxx`包。如果您计划使用`java.awt.color”以及“java.awt`，您必须导入两个包及其所有文件：

```java
import java.awt.*;
import java.awt.color.*;
```

### 名称歧义

如果一个包中的成员与另一个包的成员共享其名称，并且导入了两个包，则必须通过其限定名称引用每个成员。例如，“graphics”包定义了一个名为“Rectangle”的类。`java。awt`包还包含一个“矩形”类。如果“graphics”和“java。awt`已导入，以下内容不明确。

```java
Rectangle rect;
```

在这种情况下，您必须使用成员的完全限定名来准确地指示所需的“矩形”类。例如

```java
graphics.Rectangle rect;
```

### 静态导入语句

在某些情况下，您需要频繁访问一个或两个类中的静态final字段（常量）和静态方法。反复使用这些类的名称前缀可能会导致代码混乱。*static import*语句为您提供了一种方法来导入要使用的常量和静态方法，这样您就不需要在它们的类名称前加前缀。

“java.lang.Math”类定义了“PI”常量和许多静态方法， including methods for calculating sines, cosines, tangents, square roots, maxima, minima, exponents, and many more. For example,

```java
public static final double PI 
    = 3.141592653589793;
public static double cos(double a)
{
    ...
}
```

通常，要使用其他类中的这些对象，可以在类名前面加上前缀，如下所示。

```java
double r = Math.cos(Math.PI * theta);
```

可以使用staticimport语句导入java.lang.Math的静态成员， `Math`. 可以单独导入“Math”的静态成员：

```java
import static java.lang.Math.PI;
```

or as a group:

```java
import static java.lang.Math.*;
```

一旦导入了静态成员，就可以不经限定地使用它们。例如，上一个代码段将变为：

```java
double r = cos(PI * theta);
```

显然，您可以编写自己的类，这些类包含经常使用的常量和静态方法，然后使用静态import语句。例如

```java
import static mypackage.MyConstants.*;
```

------

**Note:** 非常谨慎地使用静态导入。过度使用静态导入会导致代码难以读取和维护，因为代码的读者不知道哪个类定义了特定的静态对象。如果使用得当，静态导入通过消除类名重复使代码更可读。

------

## 管理源文件和类文件

Java平台的许多实现依赖于分层文件系统来管理源文件和类文件，尽管*Java语言规范*不需要这样做。策略如下。

将类、接口、枚举或注释类型的源代码放在一个文本文件中，该文件的名称是该类型的简单名称，扩展名为“.java”。例如：

```java
//in the Rectangle.java file 
package graphics;
public class Rectangle {
   ... 
}
```

然后，将源文件放在一个目录中，该目录的名称反映了该类型所属的包的名称：

```
.....\graphics\Rectangle.java
```

包成员的限定名和文件的路径名是并行的，假设Microsoft Windows文件名分隔符是反斜杠（对于UNIX，使用正斜杠）。

- **class name** – `graphics.Rectangle`
- **pathname to file** – `graphics\Rectangle.java`

您应该记得，按照惯例，一家公司使用其反向的互联网域名作为其软件包名称。Example公司，其Internet域名为“Example”。com”将在其所有包名称之前加上“com.example”。包名的每个组件都对应于一个子目录。所以，如果Example公司有一个“com.Example。包含“矩形”的图形包。java`源文件，它将包含在一系列子目录中，如下所示：

```
....\com\example\graphics\Rectangle.java
```

编译源文件时，编译器会为其中定义的每个类型创建不同的输出文件。输出文件的基名称是类型的名称，其扩展名为“.class”。例如，如果源文件如下

```java
//in the Rectangle.java file
package com.example.graphics;
public class Rectangle {
      . . . 
}

class Helper{
      . . . 
}
```

则编译的文件将位于：

```
<path to the parent directory of the output files>\com\example\graphics\Rectangle.class
<path to the parent directory of the output files>\com\example\graphics\Helper.class
```

就像。java `源文件，编译的`。类文件应位于反映包名称的一系列目录中。但是，“.class“文件”不必与“”的路径相同。java`源文件。您可以分别排列源目录和类目录，如下所示：

```java
<path_one>\sources\com\example\graphics\Rectangle.java

<path_two>\classes\com\example\graphics\Rectangle.class
```

通过这样做，您可以将“classes”目录交给其他程序员，而不必透露源代码。您还需要以这种方式管理源文件和类文件，以便编译器和Java虚拟机（JVM）可以找到程序使用的所有类型。

通过这样做，您可以将“classes”目录交给其他程序员，而不必透露源代码。您还需要以这种方式管理源文件和类文件，以便编译器和Java虚拟机（JVM）可以找到程序使用的所有类型。

```
<path_two>\classes
```

是类路径，包名为

```java
com.example.graphics,
```

然后编译器和JVM查找“, `.class files` in

```
<path_two>\classes\com\example\graphics.
```

类路径可以包括多个路径，用分号（Windows）或冒号（UNIX）分隔。默认情况下，编译器和JVM搜索当前目录和包含Java平台类的JAR文件，以便这些目录自动位于类路径中。

### 设置CLASSPATH系统变量

要显示当前的“CLASSPATH”变量，请在Windows和UNIX（Bourne shell）中使用以下命令：

```
In Windows:   C:\> set CLASSPATH
In UNIX:      % echo $CLASSPATH
```

要删除“CLASSPATH”变量的当前内容，请使用以下命令：

```
In Windows:   C:\> set CLASSPATH=
In UNIX:      % unset CLASSPATH; export CLASSPATH
```

要设置“CLASSPATH”变量，请使用以下命令（例如）：

```
In Windows:   C:\> set CLASSPATH=C:\users\george\java\classes
In UNIX:      % CLASSPATH=/home/george/java/classes; export CLASSPATH
```

## 创建和使用包摘要

要为类型创建包，请将“package”语句作为包含该类型（类、接口、枚举或注释类型）的源文件中的第一条语句。

要使用不同包中的公共类型，可以有三种选择：（1）使用类型的完全限定名称，（2）导入类型，或（3）导入该类型所属的整个包。

包的源文件和类文件的路径名反映了包的名称。

您可能需要设置“CLASSPATH”，以便编译器和JVM可以找到“。类文件。