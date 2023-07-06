---
title: Oracle Java语言基础
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
> 翻译自：https://docs.oracle.com/javase/tutorial/java/nutsandbolts/index.html

## 变量

对象将其状态存储在字段中。

```java
int cadence = 0;
int speed = 0;
int gear = 1;
```

什么是对象？ 讨论向您介绍了字段，但您可能还有一些问题，例如：命名字段的规则和约定是什么？ 除了int，还有哪些数据类型？ 字段在声明时是否必须初始化？ 如果未显式初始化，是否为字段分配了默认值？ 我们将在本课中探讨此类问题的答案，但在此之前，您必须首先了解一些技术上的区别。 在 Java 编程语言中，术语“字段”和“变量”同时使用； 这是新开发人员之间常见的混淆来源，因为两者似乎指的是同一件事。

**Java 编程语言定义了以下几种变量**：

- **实例变量（非静态字段）** 从技术上讲，对象将其各自的状态存储在“非静态字段”中，即没有使用 static 关键字声明的字段。 非静态字段也称为实例变量，因为它们的值对于类的每个实例（换句话说，对于每个对象）都是唯一的； 一辆自行车的当前速度独立于另一辆自行车的当前速度。
- **类变量（静态字段）** 类变量是用静态修饰符声明的任何字段； 这告诉编译器这个变量只存在一个副本，不管这个类被实例化了多少次。 定义特定类型自行车的档位数量的字段可以标记为静态，因为从概念上讲，相同数量的档位将适用于所有实例。 代码static int numGears = 6; 会创建这样一个静态字段。 此外，可以添加关键字 final 以指示齿轮数永远不会改变。
- **局部变量** 与对象在字段中存储其状态的方式类似，方法通常会将其临时状态存储在局部变量中。 声明局部变量的语法类似于声明字段（例如，int count = 0;）。 没有特殊的关键字将变量指定为局部变量； 该决定完全来自声明变量的位置——它位于方法的左大括号和右大括号之间。 因此，局部变量仅对声明它们的方法可见； 班上其他人无法访问它们。
- **参数** 您已经在 Bicycle 类和“Hello World!”的主要方法中看到了参数示例。 应用。 回想一下 main 方法的签名是 public static void main(String[] args)。 此处，args 变量是此方法的参数。 要记住的重要一点是参数总是被归类为“变量”而不是“字段”。 这也适用于您将在本教程后面了解的其他参数接受构造（例如构造函数和异常处理程序）。

话虽如此，本教程的其余部分在讨论字段和变量时使用以下一般准则。 如果我们在谈论“一般的字段”（不包括局部变量和参数），我们可能会简单地说“字段”。 如果讨论适用于“以上所有”，我们可以简单地说“变量”。 如果上下文需要区分，我们将酌情使用特定术语（静态字段、局部变量等）。 您可能偶尔也会看到“成员”一词的使用。 类型的字段、方法和嵌套类型统称为其成员。

### 命名

对于允许使用的名称类型，每种编程语言都有自己的一套规则和约定，Java 编程语言也不例外。 命名变量的规则和约定可以总结如下：

- 变量名称区分大小写。 变量的名称可以是任何合法的标识符——一个无限长度的 Unicode 字母和数字序列，以字母、美元符号“\$”或下划线字符“\_”开头。 然而，约定是始终以字母开头变量名，而不是“\$”或“\_”。 此外，按照惯例，美元符号字符从不使用。 您可能会发现某些情况下自动生成的名称将包含美元符号，但您的变量名称应始终避免使用它。 下划线字符也存在类似的约定； 虽然以“_”开头的变量名在技术上是合法的，但不鼓励这种做法。 不允许有空白。
- 后续字符可以是字母、数字、美元符号或下划线字符。 惯例（和常识）也适用于此规则。 为变量选择名称时，请使用完整的单词而不是晦涩难懂的缩写。 这样做将使您的代码更易于阅读和理解。 在许多情况下，它还会使您的代码自文档化； 例如，名为 cadence、speed 和 gear 的字段比缩写版本（如 s、c 和 g）更直观。 另请记住，您选择的名称不能是关键字或保留字。
- 如果您选择的名称只有一个单词，请将该单词全部小写。 如果它由多个单词组成，则将每个后续单词的第一个字母大写。 名称 gearRatio 和 currentGear 是该约定的主要示例。 如果您的变量存储一个常量值，例如 static final int NUM_GEARS = 6，则约定会略有变化，将每个字母大写并使用下划线字符分隔后续单词。 按照惯例，下划线字符从不在其他地方使用。

### 原始数据类型

Java 编程语言是静态类型的，这意味着所有变量都必须先声明才能使用。 这涉及声明变量的类型和名称，正如您已经看到的：

```java
int gear = 1;
```

这样做会告诉您的程序存在一个名为“gear”的字段，其中包含数值数据，并且初始值为“1”。 变量的数据类型决定了它可能包含的值，以及可能对其执行的操作。 除了 int 之外，Java 编程语言还支持其他七种原始数据类型。 基本类型由语言预定义，并由保留关键字命名。 原始值不与其他原始值共享状态。  Java 编程语言支持的八种基本数据类型是：

- byte：byte 数据类型是一个 8 位有符号二进制补码整数。 它的最小值为 -128，最大值为 127（含）。 字节数据类型可用于在大型数组中节省内存，其中内存节省实际上很重要。 它们也可以用来代替 int ，它们的限制有助于阐明您的代码； 变量的范围是有限的这一事实可以作为一种文档形式。
- short：short 数据类型是一个 16 位有符号二进制补码整数。 它的最小值为-32,768，最大值为32,767（含）。 与 byte 一样，适用相同的准则：在内存节省实际很重要的情况下，您可以使用 short 来节省大型数组中的内存。
- int：默认情况下，int数据类型是一个32位有符号二进制补码整数，最小值为-2^31^，最大值为2^31^-1。 在 Java SE 8 及之后的版本中，可以使用 int 数据类型来表示一个无符号的 32 位整数，最小值为 0，最大值为 2^32^-1。 使用 Integer 类将 int 数据类型用作无符号整数。 有关详细信息，请参阅数字类部分。  [`Integer`](https://docs.oracle.com/javase/8/docs/api/java/lang/Integer.html) 类中添加了 compareUnsigned、divideUnsigned 等静态方法，以支持无符号整数的算术运算。
- long：long 数据类型是一个 64 位二进制补码整数。  signed long 的最小值为 -2^63^，最大值为 2^63^-1。 在 Java SE 8 及之后的版本中，可以使用 long 数据类型来表示无符号的 64 位 long，其最小值为 0，最大值为 2^64^-1。 当您需要的值范围比 int 提供的范围更宽时，请使用此数据类型。  [`Long`](https://docs.oracle.com/javase/8/docs/api/java/lang/Long.html) 类还包含 compareUnsigned、divideUnsigned 等方法来支持 unsigned long 的算术运算。
- float：float 数据类型是单精度 32 位 IEEE 754 浮点数。 它的取值范围超出了本次讨论的范围，但在 Java 语言规范的浮点类型、格式和值部分中进行了指定。 对于 byte 和 short 的建议，如果您需要在大型浮点数数组中节省内存，请使用 float（而不是 double）。 这种数据类型不应该用于精确值，例如货币。为此，您需要改用 [java.math.BigDecimal](https://docs.oracle.com/javase/8/docs/api/java/math/BigDecimal.html) 类。 [Numbers](https://docs.oracle.com/javase/tutorial/java/data/index.html)和[and Strings](https://docs.oracle.com/javase/tutorial/java/data/index.html)涵盖了 BigDecimal 和 Java 平台提供的其他有用的类。
- double：double 数据类型是双精度 64 位 IEEE 754 浮点数。 它的取值范围超出了本次讨论的范围，但在 Java 语言规范的浮点类型、格式和值部分中进行了指定。 对于十进制值，此数据类型通常是默认选择。 如上所述，这种数据类型不应该用于精确值，例如货币。
- boolean：布尔数据类型只有两个可能的值：true 和 false。 将此数据类型用于跟踪真/假条件的简单标志。 这种数据类型代表一位信息，但它的“大小”并不是精确定义的。
- char：char 数据类型是单个 16 位 Unicode 字符。 它的最小值为 '\u0000'（或 0），最大值为 '\uffff'（或 65,535）。

除了上面列出的八种基本数据类型之外，Java 编程语言还通过 [java.lang.String](https://docs.oracle.com/javase/8/docs/api/java/lang/String.html) 类提供了对字符串的特殊支持。 将字符串括在双引号内将自动创建一个新的 String 对象； 例如，String s = "this is a string";。 字符串对象是不可变的，这意味着一旦创建，它们的值就无法更改。  String 类在技术上不是原始数据类型，但考虑到语言对它的特殊支持，您可能倾向于这样认为。 

#### 默认值

声明字段时并不总是需要赋值。 已声明但未初始化的字段将由编译器设置为合理的默认值。 一般来说，此默认值将为零或空值，具体取决于数据类型。 然而，依赖于这样的默认值通常被认为是糟糕的编程风格。

下表总结了上述数据类型的默认值。

| **数据类型**           | **默认值 (for fields)** |
| ---------------------- | ----------------------- |
| byte                   | 0                       |
| short                  | 0                       |
| int                    | 0                       |
| long                   | 0L                      |
| float                  | 0.0f                    |
| double                 | 0.0d                    |
| char                   | '\u0000'                |
| String (or any object) | null                    |
| boolean                | false                   |

局部变量略有不同； 编译器永远不会为未初始化的局部变量分配默认值。 如果您不能在声明局部变量的地方对其进行初始化，请确保在尝试使用它之前为其分配一个值。 访问未初始化的局部变量将导致编译时错误。

#### 文字

您可能已经注意到，在初始化原始类型的变量时没有使用 new 关键字。 原始类型是语言中内置的特殊数据类型； 它们不是从类创建的对象。 文字是固定值的源代码表示； 文字直接在您的代码中表示，无需计算。 如下所示，可以将文字分配给原始类型的变量：

```java
boolean result = true;
char capitalC = 'C';
byte b = 100;
short s = 10000;
int i = 100000;
```

#### 整数文字

如果整数文字以字母 L 或 l 结尾，则它是 long 类型； 否则它是int类型。 建议您使用大写字母 L，因为小写字母 l 很难与数字 1 区分开来。

整数类型 byte、short、int 和 long 的值可以从 int 文字创建。 可以从 long 文字创建超出 int 范围的 long 类型的值。 整数文字可以用这些数字系统表示：

- 十进制：以 10 为底，其数字由数字 0 到 9 组成； 这是你每天使用的数字。
- 十六进制：基数为 16，其数字由数字 0 到 9 和字母 A 到 F 组成。
- 二进制：基数为 2，其数字由数字 0 和 1 组成（您可以在 Java SE 7 及更高版本中创建二进制文字）。

对于通用编程，十进制系统可能是您将使用的唯一数字系统。 但是，如果您需要使用其他数字系统，以下示例显示了正确的语法。 前缀 0x 表示十六进制，0b 表示二进制：

```java
// The number 26, 10进制
int decVal = 26;
//  The number 26, 16进制
int hexVal = 0x1a;
// The number 26, 2进制
int binVal = 0b11010;
```

#### 浮点文字

如果浮点文字以字母 F 或 f 结尾，则它是 float 类型； 否则它的类型是 double 并且它可以选择以字母 D 或 d 结尾。

浮点类型（float 和 double）也可以使用 E 或 e（科学记数法）、F 或 f（32 位浮点数）和 D 或 d（64 位双精度数；这是默认值，由 公约被省略）。

```java
double d1 = 123.4;
// 与 d1 相同的值，但采用科学记数法
double d2 = 1.234e2;
float f1  = 123.4f;
```

#### 字符和字符串文字

char 和 String 类型的文字可以包含任何 Unicode (UTF-16) 字符。 如果您的编辑器和文件系统允许，您可以直接在代码中使用这些字符。 如果不是，您可以使用“Unicode 转义符”，例如“\u0108”（带抑扬音符的大写 C）或“S\u00ED Se\u00F1or”（西班牙语中的 Sí Señor）。 始终对字符文字使用“单引号”，对字符串文字使用“双引号”。  Unicode 转义序列可以在程序的其他地方使用（例如在字段名称中），而不仅仅是在 char 或 String 文字中。

Java 编程语言还支持 char 和 String 文字的一些特殊转义序列：\b（退格键）、\t（制表符）、\n（换行符）、\f（换页符）、\r（回车符）、  \"（双引号）、\'（单引号）和 \\（反斜杠）。

还有一个特殊的 null 文字，可以用作任何引用类型的值。  null 可以分配给任何变量，原始类型的变量除外。 除了测试空值的存在之外，您几乎无能为力。 因此，null 在程序中经常被用作标记，表示某个对象不可用。

最后，还有一种特殊的文字，称为类文字，通过获取类型名称并附加“.class”形成； 例如，String.class。 这是指表示类型本身的对象（类类型）。

#### 在数字文字中使用下划线字符

在 Java SE 7 及更高版本中，任意数量的下划线字符 (_) 可以出现在数字文字中数字之间的任何位置。 例如，此功能使您能够。 分隔数字文字中的数字组，这可以提高代码的可读性。

例如，如果您的代码包含多位数的数字，您可以使用下划线字符将数字分成三组，类似于使用逗号或空格等标点符号作为分隔符。

以下示例显示了您可以在数字文字中使用下划线的其他方式：

```java
long creditCardNumber = 1234_5678_9012_3456L;
long socialSecurityNumber = 999_99_9999L;
float pi =  3.14_15F;
long hexBytes = 0xFF_EC_DE_5E;
long hexWords = 0xCAFE_BABE;
long maxLong = 0x7fff_ffff_ffff_ffffL;
byte nybbles = 0b0010_0101;
long bytes = 0b11010010_01101001_10010100_10010010;
```

您只能在数字之间放置下划线； 您不能在以下位置放置下划线：

- 在数字的开头或结尾。
- 与浮点文字中的小数点相邻。
- 在 F 或 L 后缀之前。
- 在需要一串数字的位置。

以下示例演示了数字文字中有效和无效的下划线放置（突出显示）：

```java
// 无效：不能放下划线
// 小数点附近
float pi1 = 3_.1415F;
// 无效：不能放下划线
// 小数点附近
float pi2 = 3._1415F;
// 无效：不能放下划线 
// 在 L 后缀之前
long socialSecurityNumber1 = 999_99_9999_L;

// OK (十进制文字)
int x1 = 5_2;
// 无效：不能放下划线
// 在文字的结尾
int x2 = 52_;
// OK (十进制文字)
int x3 = 5_______2;

// 无效：不能放下划线
// 在 0x 基数前缀
int x4 = 0_x52;
// 无效：不能放下划线
// 在数字的开头
int x5 = 0x_52;
// OK (十进制文字)
int x6 = 0x5_2; 
// 无效：不能放下划线
// 在数字的末尾
int x7 = 0x52_;
```

### 数组

数组是一个容器对象，它包含固定数量的单个类型的值。阵列的长度是在创建阵列时确定的。创建后，其长度是固定的。您已经在“Hello World！”的主方法中看到了一个数组示例应用本节将更详细地讨论数组。

![Illustration of an array as 10 boxes numbered 0 through 9; an index of 0 indicates the first element in the array](Oracle-Java语言基础/objects-tenElementArray-20221116135834036-8578320.gif)

数组中的每个项都称为元素，每个元素都通过其数字索引进行访问。如上图所示，编号从0开始。例如，第9个元素将在索引8处访问。

下面的程序[`ArrayDemo`](https://docs.oracle.com/javase/tutorial/java/nutsandbolts/examples/ArrayDemo.java)创建一个整数数组，在数组中放入一些值，并将每个值打印到标准输出。

```java
class ArrayDemo {
    public static void main(String[] args) {
        // declares an array of integers
        int[] anArray;

        // allocates memory for 10 integers
        anArray = new int[10];
           
        // initialize first element
        anArray[0] = 100;
        // initialize second element
        anArray[1] = 200;
        // and so forth
        anArray[2] = 300;
        anArray[3] = 400;
        anArray[4] = 500;
        anArray[5] = 600;
        anArray[6] = 700;
        anArray[7] = 800;
        anArray[8] = 900;
        anArray[9] = 1000;

        System.out.println("Element at index 0: "
                           + anArray[0]);
        System.out.println("Element at index 1: "
                           + anArray[1]);
        System.out.println("Element at index 2: "
                           + anArray[2]);
        System.out.println("Element at index 3: "
                           + anArray[3]);
        System.out.println("Element at index 4: "
                           + anArray[4]);
        System.out.println("Element at index 5: "
                           + anArray[5]);
        System.out.println("Element at index 6: "
                           + anArray[6]);
        System.out.println("Element at index 7: "
                           + anArray[7]);
        System.out.println("Element at index 8: "
                           + anArray[8]);
        System.out.println("Element at index 9: "
                           + anArray[9]);
    }
} 
```

该程序的输出为：

```
Element at index 0: 100
Element at index 1: 200
Element at index 2: 300
Element at index 3: 400
Element at index 4: 500
Element at index 5: 600
Element at index 6: 700
Element at index 7: 800
Element at index 8: 900
Element at index 9: 1000
```

在真实的编程环境中，您可能会使用一个受支持的循环结构来迭代数组的每个元素，而不是像前面的示例那样单独编写每一行。然而，该示例清楚地说明了数组语法。您将在“ [Control Flow](https://docs.oracle.com/javase/tutorial/java/nutsandbolts/flow.html) ”部分了解各种循环构造（for、while和do while）。

#### 声明变量以引用数组

前面的程序使用以下代码行声明一个数组（名为anArray）：

```java
// declares an array of integers
int[] anArray;
```

与其他类型变量的声明一样，数组声明有两个组件：数组的类型和数组的名称。数组的类型写成type[]，其中type是所包含元素的数据类型；括号是特殊符号，表示此变量包含一个数组。数组的大小不是其类型的一部分（这就是括号为空的原因）。数组的名称可以是您想要的任何名称，前提是它遵循前面在命名部分中讨论的规则和约定。与其他类型的变量一样，声明实际上并不创建数组；它只是告诉编译器这个变量将保存一个指定类型的数组。

类似地，您可以声明其他类型的数组：

```java
byte[] anArrayOfBytes;
short[] anArrayOfShorts;
long[] anArrayOfLongs;
float[] anArrayOfFloats;
double[] anArrayOfDoubles;
boolean[] anArrayOfBooleans;
char[] anArrayOfChars;
String[] anArrayOfStrings;
```

您也可以将括号放在数组名称后面：

```java
// 不建议使用此表格
float anArrayOfFloats[];
```

然而，惯例不鼓励这种形式；括号标识数组类型，并应与类型名称一起出现。

#### 创建、初始化和访问数组

创建数组的一种方法是使用新运算符。ArrayDemo程序中的下一条语句为一个数组分配足够的内存，可容纳10个整数元素，并将数组分配给anArray变量。

```java
// create an array of integers
anArray = new int[10];
```

如果缺少此语句，编译器将打印如下错误，编译将失败：

```
ArrayDemo.java:4: Variable anArray may not have been initialized.
```

接下来的几行代码为数组的每个元素赋值：

```java
anArray[0] = 100; // initialize first element
anArray[1] = 200; // initialize second element
anArray[2] = 300; // and so forth
```

每个数组元素都通过其数字索引进行访问：

```java
System.out.println("Element 1 at index 0: " + anArray[0]);
System.out.println("Element 2 at index 1: " + anArray[1]);
System.out.println("Element 3 at index 2: " + anArray[2]);
```

或者，您可以使用快捷方式语法创建和初始化数组：

```java
int[] anArray = { 
    100, 200, 300,
    400, 500, 600, 
    700, 800, 900, 1000
};
```

这里，数组的长度由大括号之间提供的值的数量决定，并用逗号分隔。

您还可以通过使用两组或多组括号（如String[][]名称）来声明数组数组（也称为多维数组）。因此，每个元素必须由相应数量的索引值访问。

在Java编程语言中，多维数组是其组件本身就是数组的数组。这与C或Fortran中的数组不同。其结果是，允许行的长度变化，如以下MultiDimArrayDemo程序所示：

```java
class MultiDimArrayDemo {
    public static void main(String[] args) {
        String[][] names = {
            {"Mr. ", "Mrs. ", "Ms. "},
            {"Smith", "Jones"}
        };
        // Mr. Smith
        System.out.println(names[0][0] + names[1][0]);
        // Ms. Jones
        System.out.println(names[0][2] + names[1][1]);
    }
}
```

该程序的输出为：

```java
Mr. Smith
Ms. Jones
```

最后，您可以使用内置的length属性来确定任何数组的大小。以下代码将数组的大小打印为标准输出：

```java
System.out.println(anArray.length);
```

#### 复制数组

System类有一个arraycopy方法，您可以使用该方法将数据从一个数组高效地复制到另一个数组：

```java
public static void arraycopy(Object src, int srcPos,
                             Object dest, int destPos, int length)
```

两个Object参数指定要从中复制的数组和要复制到的数组。三个int参数指定源数组中的起始位置、目标数组中的开始位置以及要复制的数组元素数。

下面的程序ArrayCopyDemo声明了一个String元素数组。它使用系统。arraycopy方法，用于将阵列组件的子序列复制到第二阵列中：

```java
class ArrayCopyDemo {
    public static void main(String[] args) {
        String[] copyFrom = {
            "Affogato", "Americano", "Cappuccino", "Corretto", "Cortado",   
            "Doppio", "Espresso", "Frappucino", "Freddo", "Lungo", "Macchiato",      
            "Marocchino", "Ristretto" };
        
        String[] copyTo = new String[7];
        System.arraycopy(copyFrom, 2, copyTo, 0, 7);
        for (String coffee : copyTo) {
            System.out.print(coffee + " ");           
        }
    }
}
```

该程序的输出为：

```
Cappuccino Corretto Cortado Doppio Espresso Frappucino Freddo 
```

#### 数组操控

数组是编程中使用的一个强大而有用的概念。JavaSE提供了执行与数组相关的一些最常见操作的方法。例如，ArrayCopyDemo示例使用System类的arraycopy方法，而不是手动迭代源数组的元素并将每个元素放入目标数组。这是在幕后执行的，使开发人员能够只使用一行代码来调用该方法。

为了方便起见，JavaSE提供了几种在Java.util中执行数组操作（常见任务，如复制、排序和搜索数组）的方法在[`java.util.Arrays`](https://docs.oracle.com/javase/8/docs/api/java/util/Arrays.html) 类。例如，可以修改前面的示例以使用java.util的copyOfRange方法。Arrays类，如ArrayCopyOfDemo示例中所示。不同之处在于，使用copyOfRange方法不需要在调用该方法之前创建目标数组，因为目标数组由该方法返回：

```java
class ArrayCopyOfDemo {
    public static void main(String[] args) {
        String[] copyFrom = {
            "Affogato", "Americano", "Cappuccino", "Corretto", "Cortado",   
            "Doppio", "Espresso", "Frappucino", "Freddo", "Lungo", "Macchiato",      
            "Marocchino", "Ristretto" };
        
        String[] copyTo = java.util.Arrays.copyOfRange(copyFrom, 2, 9);        
        for (String coffee : copyTo) {
            System.out.print(coffee + " ");           
        }            
    }
}
```

正如您所看到的，这个程序的输出是相同的，尽管它需要更少的代码行。请注意，copyOfRange方法的第二个参数是要复制的范围的初始索引（包括在内），而第三个参数则是要复制范围的最终索引（排他）。在本例中，要复制的范围不包括索引9处的数组元素（其中包含字符串Lungo）。

`java.util.Arrays` 类中的方法提供的一些其他有用操作：

- 在数组中搜索特定值，以获得放置该值的索引（binarySearch方法）。
- 比较两个数组以确定它们是否相等（equals方法）。
- 填充数组以在每个索引处放置特定值（填充方法）。
- 将数组按升序排序。这可以使用排序方法按顺序进行，也可以使用Java SE 8中引入的并行排序方法同时进行。多处理器系统上大型数组的并行排序比顺序数组排序更快。
- 创建使用数组作为源的流（流方法）。例如，以下语句以与上一示例相同的方式打印copyTo数组的内容：

```java
java.util.Arrays.stream(copyTo).map(coffee -> coffee + " ").forEach(System.out::print);  
```

有关流的更多信息，请参见[Aggregate Operations（聚合操作）](https://docs.oracle.com/javase/tutorial/collections/streams/index.html)。

- 将数组转换为字符串。toString方法将数组的每个元素转换为字符串，用逗号分隔，然后用括号括起来。例如，以下语句将copyTo数组转换为字符串并打印：

```java
System.out.println(java.util.Arrays.toString(copyTo)); 
```

此语句打印以下内容：

```
[Cappuccino, Corretto, Cortado, Doppio, Espresso, Frappucino, Freddo] 
```

### 变量汇总

Java编程语言使用“字段”和“变量”作为其术语的一部分。实例变量（非静态字段）对于类的每个实例都是唯一的。类变量（静态字段）是用静态修饰符声明的字段；无论类被实例化多少次，类变量只有一个副本。局部变量在方法中存储临时状态。参数是为方法提供额外信息的变量；局部变量和参数总是被分类为“变量”（而不是“字段”）。在命名字段或变量时，您应该（或必须）遵循一些规则和约定。

八种基本数据类型是：字节、短、整数、长、浮点、双精度、布尔和字符。[`java.lang.String`](https://docs.oracle.com/javase/8/docs/api/java/lang/String.html)类表示字符串。编译器将为上述类型的字段指定一个合理的默认值；对于局部变量，从不指定默认值。文字是固定值的源代码表示。数组是一个容器对象，它包含固定数量的单个类型的值。阵列的长度是在创建阵列时确定的。创建后，其长度是固定的。

## 运算符

既然您已经学习了如何声明和初始化变量，那么您可能想知道如何处理它们。学习Java编程语言的操作符是一个很好的开始。运算符是对一个、两个或三个操作数执行特定操作，然后返回结果的特殊符号。

当我们探索Java编程语言的运算符时，提前知道哪些运算符具有最高优先级可能会有所帮助。下表中的运算符按优先顺序列出。运算符越靠近表格顶部，其优先级越高。优先级较高的运算符在优先级相对较低的运算符之前进行评估。同一行上的运算符具有同等优先级。当同等优先级的运算符出现在同一表达式中时，必须有一个规则来控制哪个运算符首先被求值。除赋值运算符外的所有二进制运算符都从左到右求值；赋值运算符从右向左求值。

运算符优先级

| 运算符                           | Precedence                               |
| -------------------------------- | ---------------------------------------- |
| postfix（在后面加）              | `expr++ expr--`                          |
| unary（一元的）                  | `++expr --expr +expr -expr ~ !`          |
| multiplicative（乘 除 取余）     | `* / %`                                  |
| additive（加减）                 | `+ -`                                    |
| shift（移动）                    | `<< >> >>>`                              |
| relational（相关的）             | `< > <= >= instanceof`                   |
| equality（等式 不等式）          | `== !=`                                  |
| bitwise AND（按位与）            | `&`                                      |
| bitwise exclusive OR（按位异或） | `^`                                      |
| bitwise inclusive OR（按位包含） | `|`                                      |
| logical AND（逻辑与）            | `&&`                                     |
| logical OR（逻辑或）             | `||`                                     |
| ternary（三元运算）              | `? :`                                    |
| assignment（分配）               | `= += -= *= /= %= &= ^= |= <<= >>= >>>=` |

在通用编程中，某些运算符往往比其他运算符出现得更频繁；例如，赋值运算符“=”比无符号右移运算符“>>>”更常见。考虑到这一点，下面的讨论首先关注您最有可能经常使用的运算符，最后关注那些不太常见的运算符。每一次讨论都附带了可以编译和运行的示例代码。研究它的输出将有助于巩固你刚刚学到的东西。

### 赋值、算术和一元运算符

#### 简单赋值运算符

您将遇到的最常见的运算符之一是简单赋值运算符“=”。你在自行车课上见过这个操作员；它将右侧的值指定给左侧的操作数：

```java
 int cadence = 0;
 int speed = 0;
 int gear = 1;
```

该操作符还可以用于对象以指定对象引用，如创建对象中所述。

#### 算术运算符

Java编程语言提供了执行加法、减法、乘法和除法的运算符。你很有可能会通过基础数学中的同龄人认出他们。唯一对您来说可能是新的符号是“%”，它将一个操作数除以另一个操作，并返回余数作为结果。

| 运算符 | 描述                           |
| ------ | ------------------------------ |
| `+`    | 加法运算符（也用于字符串连接） |
| `-`    | 减法运算符                     |
| `*`    | 乘法运算符                     |
| `/`    | 除法运算符                     |
| `%`    | 余数运算符                     |

下面的程序ArithmeticDemo测试算术运算符。

```java
class ArithmeticDemo {

    public static void main (String[] args) {

        int result = 1 + 2;
        // result is now 3
        System.out.println("1 + 2 = " + result);
        int original_result = result;

        result = result - 1;
        // result is now 2
        System.out.println(original_result + " - 1 = " + result);
        original_result = result;

        result = result * 2;
        // result is now 4
        System.out.println(original_result + " * 2 = " + result);
        original_result = result;

        result = result / 2;
        // result is now 2
        System.out.println(original_result + " / 2 = " + result);
        original_result = result;

        result = result + 8;
        // result is now 10
        System.out.println(original_result + " + 8 = " + result);
        original_result = result;

        result = result % 7;
        // result is now 3
        System.out.println(original_result + " % 7 = " + result);
    }
}
```

此程序打印以下内容：

```
1 + 2 = 3
3 - 1 = 2
2 * 2 = 4
4 / 2 = 2
2 + 8 = 10
10 % 7 = 3
```

您还可以将算术运算符与简单赋值运算符组合以创建复合赋值。例如，x+=1；并且x＝x+1；两者都将x的值增加1。

+运算符还可以用于将两个字符串连接在一起，如以下ConcatDemo程序所示：

```java
class ConcatDemo {
    public static void main(String[] args){
        String firstString = "This is";
        String secondString = " a concatenated string.";
        String thirdString = firstString+secondString;
        System.out.println(thirdString);
    }
}
```

在这个程序结束时，变量thirdString包含“this is a concatenated string.”，它将被打印到标准输出。

#### 一元运算符

一元运算符只需要一个操作数；它们执行各种操作，例如将值递增/递减1、对表达式求反或反转布尔值。

| 运算符 | 描述                                                       |
| ------ | ---------------------------------------------------------- |
| `+`    | 一元加运算符；表示正值（但是，如果没有正值，则数字为正值） |
| `-`    | 一元减号运算符；否定表达式                                 |
| `++`   | 增量运算符；将一个值递增1                                  |
| `--`   | 递减运算符；将值递减1                                      |
| `!`    | 逻辑补码运算符；反转布尔值                                 |

以下程序UnaryDemo测试一元运算符：

```java
class UnaryDemo {

    public static void main(String[] args) {

        int result = +1;
        // result is now 1
        System.out.println(result);

        result--;
        // result is now 0
        System.out.println(result);

        result++;
        // result is now 1
        System.out.println(result);

        result = -result;
        // result is now -1
        System.out.println(result);

        boolean success = false;
        // false
        System.out.println(success);
        // true
        System.out.println(!success);
    }
}
```

递增/递减运算符可以应用于操作数之前（前缀）或之后（后缀）。代码结果++；和++结果；结果都将增加一。唯一的区别是前缀版本（++结果）的计算结果为递增值，而后缀版本（结果++）的计算值为原始值。如果您只是执行一个简单的递增/递减，那么选择哪个版本并不重要。但是，如果在更大的表达式中使用此运算符，则选择的表达式可能会产生显著的差异。

以下程序PrePostDemo演示了前缀/后缀一元增量运算符：

```java
class PrePostDemo {
    public static void main(String[] args){
        int i = 3;
        i++;
        // prints 4
        System.out.println(i);
        ++i;			   
        // prints 5
        System.out.println(i);
        // prints 6
        System.out.println(++i);
        // prints 6
        System.out.println(i++);
        // prints 7
        System.out.println(i);
    }
}
```

### 相等运算符、关系运算符和条件运算符

#### 等式和关系运算符

相等运算符和关系运算符确定一个操作数是否大于、小于、等于或不等于另一个操作。这些操作员中的大多数可能对您也很熟悉。请记住，在测试两个基本值是否相等时，必须使用“==”，而不是“=”。

```
==      equal to
!=      not equal to
>       greater than
>=      greater than or equal to
<       less than
<=      less than or equal to
```

以下程序ComparisonDemo测试比较运算符：

```java
class ComparisonDemo {

    public static void main(String[] args){
        int value1 = 1;
        int value2 = 2;
        if(value1 == value2)
            System.out.println("value1 == value2");
        if(value1 != value2)
            System.out.println("value1 != value2");
        if(value1 > value2)
            System.out.println("value1 > value2");
        if(value1 < value2)
            System.out.println("value1 < value2");
        if(value1 <= value2)
            System.out.println("value1 <= value2");
    }
}
```

Output:

```
value1 != value2
value1 <  value2
value1 <= value2
```

#### 条件运算符

&&和||运算符对两个布尔表达式执行条件and和条件OR运算。这些运算符表现出“短路”行为，这意味着只有在需要时才计算第二个操作数。

```
&& Conditional-AND
|| Conditional-OR
```

以下程序ConditionalDemo1测试这些运算符：

```java
class ConditionalDemo1 {

    public static void main(String[] args){
        int value1 = 1;
        int value2 = 2;
        if((value1 == 1) && (value2 == 2))
            System.out.println("value1 is 1 AND value2 is 2");
        if((value1 == 1) || (value2 == 1))
            System.out.println("value1 is 1 OR value2 is 1");
    }
}
```

另一个条件运算符是 `?:` ，它可以被认为是if-then-else语句的简写（在本课的控制流语句部分中讨论）。此运算符也称为三元运算符，因为它使用三个操作数。在下面的示例中，该运算符应理解为：“如果someCondition为true，则将value1的值赋给result。否则，将value2的值赋为result”

以下程序ConditionalDemo2测试 `?:` 操作员：

```java
class ConditionalDemo2 {

    public static void main(String[] args){
        int value1 = 1;
        int value2 = 2;
        int result;
        boolean someCondition = true;
        result = someCondition ? value1 : value2;

        System.out.println(result);
    }
}
```

由于someCondition为true，此程序将“1”打印到屏幕上。使用 `?: `运算符而不是if-then-else语句，如果它使代码更可读；例如，当表达式紧凑且没有副作用（如赋值）时。

#### 类型比较运算符实例

instanceof运算符将对象与指定类型进行比较。您可以使用它来测试对象是类的实例、子类的实例还是实现特定接口的类的实例。

下面的程序InstanceofDemo定义了一个父类（名为parent）、一个简单接口（名为MyInterface）和一个从父类继承并实现接口的子类（名child）。

```java
class InstanceofDemo {
    public static void main(String[] args) {

        Parent obj1 = new Parent();
        Parent obj2 = new Child();

        System.out.println("obj1 instanceof Parent: "
            + (obj1 instanceof Parent));
        System.out.println("obj1 instanceof Child: "
            + (obj1 instanceof Child));
        System.out.println("obj1 instanceof MyInterface: "
            + (obj1 instanceof MyInterface));
        System.out.println("obj2 instanceof Parent: "
            + (obj2 instanceof Parent));
        System.out.println("obj2 instanceof Child: "
            + (obj2 instanceof Child));
        System.out.println("obj2 instanceof MyInterface: "
            + (obj2 instanceof MyInterface));
    }
}

class Parent {}
class Child extends Parent implements MyInterface {}
interface MyInterface {}
```

Output:

```
obj1 instanceof Parent: true
obj1 instanceof Child: false
obj1 instanceof MyInterface: false
obj2 instanceof Parent: true
obj2 instanceof Child: true
obj2 instanceof MyInterface: true
```

使用instanceof运算符时，请记住null不是任何东西的实例。

#### 位和位移位运算符

Java编程语言还提供了对整型执行逐位和移位操作的运算符。本节中讨论的运算符不太常用。因此，他们的报道很简短；其目的只是让您意识到这些操作符的存在。

一元逐位补码运算符“~”反转位模式；它可以应用于任何一种积分类型，使每个“0”都成为“1”，每个“1”都变成“0”。例如，一个字节包含8位；将该运算符应用于位模式为“00000000”的值将其模式更改为“11111111”。

有符号左移位运算符“<<”向左移位位模式，有符号右移位运算符“>>”向右移位位模式。位模式由左侧操作数给出，而要移位的位置数由右侧操作数给出。无符号右移运算符“>>>”将零移到最左位置，而“>>”之后的最左位置取决于符号扩展。

按位 `&` 运算符执行按位AND运算。

按位 `^` 运算符执行按位异或运算。

按位 `|` 运算符执行按位包含的OR运算。

以下程序BitDemo使用按位AND运算符将数字“2”打印到标准输出。

```java
class BitDemo {
    public static void main(String[] args) {
        int bitmask = 0x000F;
        int val = 0x2222;
        // prints "2"
        System.out.println(val & bitmask);
    }
}
```

### 运算符总结

下面的快速参考总结了Java编程语言支持的运算符。

#### 简单赋值运算符

```
=       简单赋值运算符
```

#### 算术运算符

```
+       加法运算符（也用于字符串连接）
-       减法运算符
*       乘法运算符
/       除法运算符
%       余数运算符
```

#### 单目运算符

```
+       一元加运算符；表示正值（数字为正值，但没有此值）
-       一元减运算符；否定表达式
++      增量运算符；将值递增1
--      减量运算符；将值递减1
!       逻辑补码运算符；反转布尔值
```

#### 等式和关系运算符

```
==      Equal to
!=      Not equal to
>       Greater than
>=      Greater than or equal to
<       Less than
<=      Less than or equal to
```

#### 条件运算符

```
&&      Conditional-AND
||      Conditional-OR
?:      Ternary (shorthand for 
        if-then-else statement)
```

#### 类型比较运算符

```
instanceof      Compares an object to 
                a specified type 
```

#### 位和位移位运算符

```
~       Unary bitwise complement
<<      Signed left shift
>>      Signed right shift
>>>     Unsigned right shift
&       Bitwise AND
^       Bitwise exclusive OR
|       Bitwise inclusive OR
```

## 表达式、语句和块

既然您了解了变量和运算符，现在是学习表达式、语句和块的时候了。运算符可以用于构建计算值的表达式；表达式是语句的核心组成部分；语句可以被分组为块。

### 表达式

表达式是一种由变量、运算符和方法调用组成的构造，它们根据语言的语法构造，并计算为单个值。您已经看到了表达式的示例，如下所示：

```java
int cadence = 0;
anArray[0] = 100;
System.out.println("Element 1 at index 0: " + anArray[0]);

int result = 1 + 2; // result is now 3
if (value1 == value2) 
    System.out.println("value1 == value2");
```

表达式返回的值的数据类型取决于表达式中使用的元素。表达式cadence=0返回int，因为赋值运算符返回的数据类型与其左手操作数相同；在这种情况下，cadence是一个int。从其他表达式可以看出，表达式也可以返回其他类型的值，例如布尔值或字符串。

Java编程语言允许您从各种较小的表达式构造复合表达式，只要表达式的一部分所需的数据类型与另一部分的数据类型匹配。下面是一个复合表达式的示例：

```java
1 * 2 * 3
```

在这个特定的例子中，表达式的求值顺序并不重要，因为乘法的结果与顺序无关；结果总是相同的，不管你用哪个顺序进行乘法。然而，并非所有表达式都是如此。例如，以下表达式会给出不同的结果，具体取决于您是先执行加法运算还是先执行除法运算：

```java
x + y / 100    // ambiguous
```

您可以使用平衡括号（和）精确指定表达式的求值方式。例如，要使前面的表达式明确，可以编写以下内容：

```java
(x + y) / 100  // unambiguous, recommended
```

如果没有明确指示要执行的操作的顺序，则顺序由分配给表达式中使用的运算符的优先级决定。优先级较高的运算符将首先计算。例如，除法运算符的优先级高于加法运算符。因此，以下两种说法是等价的：

```java
x + y / 100 


x + (y / 100) // unambiguous, recommended
```

在编写复合表达式时，要明确，并用括号指明应首先计算哪些运算符。这种做法使代码更易于阅读和维护。

### 语句

语句大致相当于自然语言中的句子。语句构成一个完整的执行单元。通过用分号（；）终止表达式，可以将以下类型的表达式转换为语句。

- 赋值表达式
- 任何使用 ++ 或 \-\-
- Method调用
- 对象创建表达式

这种语句称为表达式语句。下面是一些表达式语句的示例。

```java
// 赋值语句
aValue = 8933.234;
// 增量语句
aValue++;
// 方法调用语句
System.out.println("Hello World!");
// 对象创建语句
Bicycle myBike = new Bicycle();
```

除了表达式语句之外，还有其他两种语句：声明语句和控制流语句。声明语句声明变量。您已经看到了许多声明语句的示例：

```java
// declaration statement
double aValue = 8933.234;
```

最后，控制流语句调节语句的执行顺序。您将在下一节“[Control Flow Statements](https://docs.oracle.com/javase/tutorial/java/nutsandbolts/flow.html)”中了解控制流语句

### 块

块是平衡大括号之间的一组零个或多个语句，可以在任何允许使用单个语句的地方使用。以下示例BlockDemo说明了块的使用：

```java
class BlockDemo {
     public static void main(String[] args) {
          boolean condition = true;
          if (condition) { // begin block 1
               System.out.println("Condition is true.");
          } // end block one
          else { // begin block 2
               System.out.println("Condition is false.");
          } // end block 2
     }
}
```

## 控制流程语句

源文件中的语句通常按出现的顺序从上到下执行。然而，控制流语句通过采用决策、循环和分支来分解执行流，使程序能够有条件地执行特定的代码块。本节描述Java编程语言支持的决策语句（if-then、if-then-else、switch）、循环语句（for、while、do-while）和分支语句（break、continue、return）。

### if-then语句

if-then语句是所有控制流语句中最基本的。它告诉您的程序只有在特定测试的结果为true时才执行某段代码。例如，自行车类只能在自行车已经在运动时才允许制动器降低自行车的速度。applyBrakes方法的一种可能实现方式如下：

```java
void applyBrakes() {
    // the "if" clause: bicycle must be moving
    if (isMoving){ 
        // the "then" clause: decrease current speed
        currentSpeed--;
    }
}
```

如果此测试的结果为false（表示自行车不在运动中），则控制跳到If-then语句的末尾。

此外，如果“then”子句只包含一条语句，则左大括号和右大括号是可选的： 

```java
void applyBrakes() {
    // same as above, but without braces 
    if (isMoving)
        currentSpeed--;
}
```

决定何时省略括号是个人开发习惯的问题。省略它们会使代码更加脆弱。如果后来在“then”子句中添加了第二条语句，一个常见的错误就是忘记添加新需要的大括号。编译器无法捕获此类错误；你只会得到错误的结果。

### if-then-else语句

当“if”子句的计算结果为false时，if-then-else语句提供了执行的辅助路径。如果在自行车不运动时应用了制动器，您可以在applyBrakes方法中使用if-then-else语句来采取一些措施。在这种情况下，只需打印一条错误消息，说明自行车已经停止。

```java
void applyBrakes() {
    if (isMoving) {
        currentSpeed--;
    } else {
        System.err.println("The bicycle has already stopped!");
    } 
}
```

以下程序IfElseDemo根据测试分数的值分配分数：a表示90%或以上，B表示80%或以上，依此类推。

```java
class IfElseDemo {
    public static void main(String[] args) {

        int testscore = 76;
        char grade;

        if (testscore >= 90) {
            grade = 'A';
        } else if (testscore >= 80) {
            grade = 'B';
        } else if (testscore >= 70) {
            grade = 'C';
        } else if (testscore >= 60) {
            grade = 'D';
        } else {
            grade = 'F';
        }
        System.out.println("Grade = " + grade);
    }
}
```

程序的输出为：

```java
Grade = C
```

您可能已经注意到testscore的值可以满足复合语句中的多个表达式：76>=70和76>=60。但是，一旦满足条件，就会执行相应的语句（grade='C'；）并且不评估其余条件。

### switch语句

与if-then和if-then-else语句不同，switch语句可以有许多可能的执行路径。开关用于byte、short、char和int原始数据类型。它还可以与枚举类型（在枚举类型中讨论）、String类以及包装某些基本类型的几个特殊类一起使用：[`Character`](https://docs.oracle.com/javase/8/docs/api/java/lang/Character.html), [`Byte`](https://docs.oracle.com/javase/8/docs/api/java/lang/Byte.html), [`Short`](https://docs.oracle.com/javase/8/docs/api/java/lang/Short.html), and [`Integer`](https://docs.oracle.com/javase/8/docs/api/java/lang/Integer.html)（在[Numbers and Strings](https://docs.oracle.com/javase/tutorial/java/data/index.html)中讨论）。

下面的代码示例SwitchDemo声明了一个名为month的int，其值表示月份。代码使用switch语句根据月份的值显示月份的名称。

```java
public class SwitchDemo {
    public static void main(String[] args) {

        int month = 8;
        String monthString;
        switch (month) {
            case 1:  monthString = "January";
                     break;
            case 2:  monthString = "February";
                     break;
            case 3:  monthString = "March";
                     break;
            case 4:  monthString = "April";
                     break;
            case 5:  monthString = "May";
                     break;
            case 6:  monthString = "June";
                     break;
            case 7:  monthString = "July";
                     break;
            case 8:  monthString = "August";
                     break;
            case 9:  monthString = "September";
                     break;
            case 10: monthString = "October";
                     break;
            case 11: monthString = "November";
                     break;
            case 12: monthString = "December";
                     break;
            default: monthString = "Invalid month";
                     break;
        }
        System.out.println(monthString);
    }
}
```

在这种情况下，八月被打印为标准输出。

switch语句的主体称为switch块。开关块中的语句可以用一个或多个大小写或默认标签进行标记。switch语句计算其表达式，然后执行匹配大小写标签后面的所有语句。

您还可以使用if-then-else语句显示月份名称：

```java
int month = 8;
if (month == 1) {
    System.out.println("January");
} else if (month == 2) {
    System.out.println("February");
}
...  // and so on
```

决定是否使用if-then-else语句或switch语句取决于语句的可读性和测试的表达式。if-then-else语句可以基于值或条件的范围测试表达式，而switch语句只能基于单个整数、枚举值或String对象测试表达式。

另一个有趣的点是break语句。每个break语句都终止封闭的switch语句。控制流继续执行开关块后面的第一条语句。break语句是必需的，因为如果没有它们，开关块中的语句就会失败：匹配的case标签之后的所有语句都会按顺序执行，而不管后续case标签的表达式如何，直到遇到break。程序SwitchDemoFallThrough显示开关块中的语句。程序显示与整数月份对应的月份以及一年中的后续月份：

```java
public class SwitchDemoFallThrough {

    public static void main(String[] args) {
        java.util.ArrayList<String> futureMonths =
            new java.util.ArrayList<String>();

        int month = 8;

        switch (month) {
            case 1:  futureMonths.add("January");
            case 2:  futureMonths.add("February");
            case 3:  futureMonths.add("March");
            case 4:  futureMonths.add("April");
            case 5:  futureMonths.add("May");
            case 6:  futureMonths.add("June");
            case 7:  futureMonths.add("July");
            case 8:  futureMonths.add("August");
            case 9:  futureMonths.add("September");
            case 10: futureMonths.add("October");
            case 11: futureMonths.add("November");
            case 12: futureMonths.add("December");
                     break;
            default: break;
        }

        if (futureMonths.isEmpty()) {
            System.out.println("Invalid month number");
        } else {
            for (String monthName : futureMonths) {
               System.out.println(monthName);
            }
        }
    }
}
```

这是代码的输出：

```
August
September
October
November
December
```

从技术上讲，不需要最后一次中断，因为流不在switch语句中。建议使用中断，这样修改代码更容易，更不容易出错。默认部分处理其中一个case部分未显式处理的所有值。

下面的代码示例SwitchDemo2展示了一个语句如何具有多个大小写标签。代码示例计算特定月份的天数：

```java
class SwitchDemo2 {
    public static void main(String[] args) {

        int month = 2;
        int year = 2000;
        int numDays = 0;

        switch (month) {
            case 1: case 3: case 5:
            case 7: case 8: case 10:
            case 12:
                numDays = 31;
                break;
            case 4: case 6:
            case 9: case 11:
                numDays = 30;
                break;
            case 2:
                if (((year % 4 == 0) && 
                     !(year % 100 == 0))
                     || (year % 400 == 0))
                    numDays = 29;
                else
                    numDays = 28;
                break;
            default:
                System.out.println("Invalid month.");
                break;
        }
        System.out.println("Number of Days = "
                           + numDays);
    }
}
```

这是代码的输出：

```
Number of Days = 29
```

#### 在switch语句中使用字符串

在JavaSE7及更高版本中，可以在switch语句的表达式中使用String对象。下面的代码示例StringSwitchDemo根据名为month的字符串的值显示月份数：

```java
public class StringSwitchDemo {

    public static int getMonthNumber(String month) {

        int monthNumber = 0;

        if (month == null) {
            return monthNumber;
        }

        switch (month.toLowerCase()) {
            case "january":
                monthNumber = 1;
                break;
            case "february":
                monthNumber = 2;
                break;
            case "march":
                monthNumber = 3;
                break;
            case "april":
                monthNumber = 4;
                break;
            case "may":
                monthNumber = 5;
                break;
            case "june":
                monthNumber = 6;
                break;
            case "july":
                monthNumber = 7;
                break;
            case "august":
                monthNumber = 8;
                break;
            case "september":
                monthNumber = 9;
                break;
            case "october":
                monthNumber = 10;
                break;
            case "november":
                monthNumber = 11;
                break;
            case "december":
                monthNumber = 12;
                break;
            default: 
                monthNumber = 0;
                break;
        }

        return monthNumber;
    }

    public static void main(String[] args) {

        String month = "August";

        int returnedMonthNumber =
            StringSwitchDemo.getMonthNumber(month);

        if (returnedMonthNumber == 0) {
            System.out.println("Invalid month");
        } else {
            System.out.println(returnedMonthNumber);
        }
    }
}
```

此代码的输出为8。

将switch表达式中的String与与每个大小写标签关联的表达式进行比较，就像String一样。正在使用相等方法。为了使StringSwitchDemo示例接受任何月份，不管大小写，月份都转换为小写（使用toLowerCase方法），并且与大小写标签关联的所有字符串都是小写的。

注意：此示例检查switch语句中的表达式是否为空。确保任何switch语句中的表达式都不为空，以防止引发NullPointerException。

### The while和do while语句

while语句在特定条件为真时连续执行一个语句块。其语法可以表示为：

```java
while (expression) {
     statement(s)
}
```

while语句计算表达式，表达式必须返回布尔值。如果表达式的计算结果为true，则while语句执行while块中的语句。while语句继续测试表达式并执行其块，直到表达式的计算结果为false。使用while语句打印从1到10的值可以在以下WhileDemo程序中完成：

```java
class WhileDemo {
    public static void main(String[] args){
        int count = 1;
        while (count < 11) {
            System.out.println("Count is: " + count);
            count++;
        }
    }
}
```

您可以使用while语句实现无限循环，如下所示：

```java
while (true){
    // your code goes here
}
```

Java编程语言还提供了一个do-while语句，可以如下表示：

```java
do {
     statement(s)
} while (expression);
```

do-while和while的区别在于，do-where在循环的底部而不是顶部计算其表达式。因此，do块中的语句始终至少执行一次，如以下DoWhileDemo程序所示：

```java
class DoWhileDemo {
    public static void main(String[] args){
        int count = 1;
        do {
            System.out.println("Count is: " + count);
            count++;
        } while (count < 11);
    }
}
```

### for语句

for语句提供了一种紧凑的方法来迭代一系列值。程序员经常将其称为“for循环”，因为它重复循环直到满足特定条件。for语句的一般形式可以表示如下：

```java
for (初始化; 结束;
     定期的处理) {
    statement(s)
}
```

使用此版本的for语句时，请记住：

- 初始化表达式初始化循环；它在循环开始时执行一次。
- 当终止表达式的计算结果为false时，循环终止。
- 增量表达式在循环的每次迭代之后被调用；对于这个表达式来说，增加或减少一个值是完全可以接受的。

以下程序ForDemo使用for语句的一般形式将数字1到10打印到标准输出：

```java
class ForDemo {
    public static void main(String[] args){
         for(int i=1; i<11; i++){
              System.out.println("Count is: " + i);
         }
    }
}
```

该程序的输出为：

```
Count is: 1
Count is: 2
Count is: 3
Count is: 4
Count is: 5
Count is: 6
Count is: 7
Count is: 8
Count is: 9
Count is: 10
```

注意代码如何在初始化表达式中声明变量。此变量的范围从其声明扩展到由for语句控制的块的末尾，因此它也可以用于终止表达式和增量表达式中。如果在循环之外不需要控制for语句的变量，最好在初始化表达式中声明该变量。名称i、j和k通常用于控制for循环；在初始化表达式中声明它们会限制它们的寿命并减少错误。

for循环的三个表达式是可选的；可以如下创建无限循环：

```java
// infinite loop
for ( ; ; ) {
    
    // your code goes here
}
```

for语句还有另一种形式，设计用于通过 [Collections](https://docs.oracle.com/javase/tutorial/collections/index.html) 和 [arrays](https://docs.oracle.com/javase/tutorial/java/nutsandbolts/arrays.html) 进行迭代。这种形式有时被称为增强的for语句，可用于使循环更紧凑、更易于阅读。为了演示，请考虑以下数组，其中包含数字1到10：

```java
int[] numbers = {1,2,3,4,5,6,7,8,9,10};
```

以下程序EnhancedForDemo使用增强的for在数组中循环：

```java
class EnhancedForDemo {
    public static void main(String[] args){
         int[] numbers = 
             {1,2,3,4,5,6,7,8,9,10};
         for (int item : numbers) {
             System.out.println("Count is: " + item);
         }
    }
}
```

在本例中，变量项保存数字数组中的当前值。此程序的输出与之前相同：

```
Count is: 1
Count is: 2
Count is: 3
Count is: 4
Count is: 5
Count is: 6
Count is: 7
Count is: 8
Count is: 9
Count is: 10
```

我们建议尽可能使用for语句的这种形式，而不是一般形式。

### 分支语句

#### break语句

break语句有两种形式：标记和未标记。您在前面关于switch语句的讨论中看到了未标记的表单。您还可以使用未标记的中断来终止for、while或do while循环，如以下BreakDemo程序所示：

```java
class BreakDemo {
    public static void main(String[] args) {

        int[] arrayOfInts = 
            { 32, 87, 3, 589,
              12, 1076, 2000,
              8, 622, 127 };
        int searchfor = 12;

        int i;
        boolean foundIt = false;

        for (i = 0; i < arrayOfInts.length; i++) {
            if (arrayOfInts[i] == searchfor) {
                foundIt = true;
                break;
            }
        }

        if (foundIt) {
            System.out.println("Found " + searchfor + " at index " + i);
        } else {
            System.out.println(searchfor + " not in the array");
        }
    }
}
```

该程序在数组中搜索数字12。以粗体显示的break语句在找到该值时终止for循环。然后，控制流转移到for循环之后的语句。该程序的输出是：

```
Found 12 at index 4
```

未标记的break语句终止最内部的switch、for、while或do while语句，但标记的breark终止外部语句。下面的程序BreakWithLabelDemo与前面的程序类似，但使用嵌套for循环搜索二维数组中的值。当找到该值时，标记为break将终止外部for循环（标记为“search”）：

```java
class BreakWithLabelDemo {
    public static void main(String[] args) {

        int[][] arrayOfInts = { 
            { 32, 87, 3, 589 },
            { 12, 1076, 2000, 8 },
            { 622, 127, 77, 955 }
        };
        int searchfor = 12;

        int i;
        int j = 0;
        boolean foundIt = false;

    search:
        for (i = 0; i < arrayOfInts.length; i++) {
            for (j = 0; j < arrayOfInts[i].length;
                 j++) {
                if (arrayOfInts[i][j] == searchfor) {
                    foundIt = true;
                    break search;
                }
            }
        }

        if (foundIt) {
            System.out.println("Found " + searchfor + " at " + i + ", " + j);
        } else {
            System.out.println(searchfor + " not in the array");
        }
    }
}
```

这是程序的输出。

```
Found 12 at 1, 0
```

break语句终止标记语句；它不会将控制流传递到标签。控制流被转移到紧跟在标记（终止）语句之后的语句。

#### continue语句

continue语句跳过for、while或do while循环的当前迭代。未标记的表单跳到最内层循环体的末尾，并计算控制循环的布尔表达式。下面的程序ContinueDemo逐个处理字符串，计算字母“p”的出现次数。如果当前字符不是p，continue语句将跳过循环的其余部分，并转到下一个字符。如果是“p”，程序将增加字母计数。

```java
class ContinueDemo {
    public static void main(String[] args) {

        String searchMe = "peter piper picked a " + "peck of pickled peppers";
        int max = searchMe.length();
        int numPs = 0;

        for (int i = 0; i < max; i++) {
            // interested only in p's
            if (searchMe.charAt(i) != 'p')
                continue;

            // process p's
            numPs++;
        }
        System.out.println("Found " + numPs + " p's in the string.");
    }
}
```

以下是该程序的输出：

```
Found 9 p's in the string.
```

要更清楚地看到这种效果，请尝试删除continue语句并重新编译。当你再次运行程序时，计数会出错，说它找到了35个p而不是9。

带标签的continue语句跳过用给定标签标记的外部循环的当前迭代。下面的示例程序ContinueWithLabelDemo使用嵌套循环在另一个字符串中搜索子字符串。需要两个嵌套循环：一个迭代子字符串，一个迭代正在搜索的字符串。下面的程序ContinueWithLabelDemo使用continue的标记形式跳过外部循环中的迭代。

```java
class ContinueWithLabelDemo {
    public static void main(String[] args) {

        String searchMe = "Look for a substring in me";
        String substring = "sub";
        boolean foundIt = false;

        int max = searchMe.length() - 
                  substring.length();

    test:
        for (int i = 0; i <= max; i++) {
            int n = substring.length();
            int j = i;
            int k = 0;
            while (n-- != 0) {
                if (searchMe.charAt(j++) != substring.charAt(k++)) {
                    continue test;
                }
            }
            foundIt = true;
                break test;
        }
        System.out.println(foundIt ? "Found it" : "Didn't find it");
    }
}
```

这是这个程序的输出：

```
Found it
```

#### return 语句

分支语句的最后一个是return语句。return语句从当前方法退出，控制流返回到调用该方法的位置。return语句有两种形式：一种返回值，另一种不返回值。要返回值，只需将值（或计算值的表达式）放在return关键字之后。

```java
return ++count;
```

返回值的数据类型必须与方法声明的返回值的类型匹配。当方法声明为void时，使用不返回值的返回形式。

```java
return;
```

 [Classes and Objects](https://docs.oracle.com/javase/tutorial/java/javaOO/methods.html) 课程将涵盖您需要了解的关于编写方法的所有内容。

### 控制流程语句总结

if-then语句是所有控制流语句中最基本的。它告诉您的程序只有在特定测试的结果为true时才执行某段代码。当“if”子句的计算结果为false时，if-then-else语句提供了执行的辅助路径。与if-then和if-then-else不同，switch语句允许任意数量的可能执行路径。while和do while语句在特定条件为真时连续执行一个语句块。do-while和while的区别在于，do-where在循环的底部而不是顶部计算其表达式。因此，do块中的语句总是至少执行一次。for语句提供了一种紧凑的方法来迭代一系列值。它有两种形式，其中一种是为在集合和数组之间循环而设计的。
