---
title: Oracle Java Numbers和Strings
tags:
    - Oracle
    - Java
categories:
    - Java
date: 2022-07-01 12:01:01
thumbnail:
---

> 本文章以jdk8为基础进行编写，如果想查看后续的版本可以前往jdk版本目录下查看。
>
> 翻译自：https://docs.oracle.com/javase/tutorial/java/data/index.html

## Numbers

本节首先讨论[`number`](https://docs.oracle.com/javase/8/docs/api/java/lang/Number.html)类。lang包及其子类，以及使用这些类的实例化而不是原始数字类型的情况。

本节还介绍了[`PrintStream`](https://docs.oracle.com/javase/8/docs/api/java/io/PrintStream.html)和[`DecimalFormat`](https://docs.oracle.com/javase/8/docs/api/java/text/DecimalFormat.html)类，提供了编写格式化数字输出的方法。

最后，[`Math`](https://docs.oracle.com/javase/8/docs/api/java/lang/Math.html)类。讨论了lang。它包含数学函数来补充语言中内置的运算符。这类有三角函数、指数函数等方法。

### Numbers Classes

在处理数字时，大多数时候都使用代码中的基元类型。例如：

```java
int i = 500;
float gpa = 3.65f;
byte mask = 0x7f;
```

然而，使用对象代替原语是有原因的，Java平台为每种原语数据类型提供了*wrapper*类。这些类将基本体“包装”在对象中。通常，如果您在需要对象的地方使用原语，编译器会在其包装类中为您包装原语。类似地，如果在需要基元时使用数字对象，编译器将为您打开该对象。有关详细信息，请参见[自动装箱和取消装箱](https://docs.oracle.com/javase/tutorial/java/data/autoboxing.html)

所有数字包装类都是抽象类“Number”的子类：

![The class hierarchy of Number.](Oracle-Java-Numbers和Strings/objects-numberHierarchy.png)

------

**Note:** 这里没有讨论“数字”的其他四个子类`BigDecimal和BigInteger用于高精度计算`AtomicInteger和AtomicLong用于多线程应用程序。

------

使用“Number”对象而不是基元有三个原因：

1. 作为需要对象的方法的参数（通常在处理数字集合时使用）。
2. 使用类定义的常量，如“MIN_VALUE”和“MAX_VALUE“，它们提供数据类型的上限和下限。
3. 使用类方法将值转换为其他基元类型和从其他基元转换为字符串，以及在数字系统（十进制、八进制、十六进制、二进制）之间转换。

下表列出了“Number”类的所有子类实现的实例方法。

| Method                                                       | Description                                                  |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| `byte byteValue()short shortValue()int intValue()long longValue()float floatValue()double doubleValue()` | 将此“Number”对象的值转换为返回的基元数据类型。               |
| `int compareTo(Byte anotherByte)int compareTo(Double anotherDouble)int compareTo(Float anotherFloat)int compareTo(Integer anotherInteger)int compareTo(Long anotherLong)int compareTo(Short anotherShort)` | 将此“数字”对象与参数进行比较。                               |
| `boolean equals(Object obj)`                                 | 确定此数字对象是否等于参数。如果参数不是“null”，并且是具有相同类型和数值的对象，则方法返回“true”。Java API文档中对“Double”和“Float”对象有一些额外的要求。 |

每个“Number”类包含其他方法，这些方法可用于将数字转换为字符串和从字符串转换为字符串，以及在数字系统之间进行转换。下表列出了“Integer”类中的这些方法。其他“Number”子类的方法类似：

| Method                                        | Description                                                  |
| --------------------------------------------- | ------------------------------------------------------------ |
| `static Integer decode(String s)`             | 将字符串解码为整数。可以接受十进制、八进制或十六进制数字的字符串表示形式作为输入。 |
| `static int parseInt(String s)`               | 返回整数（仅限十进制）。                                     |
| `static int parseInt(String s, int radix)`    | 返回一个整数，给定十进制、二进制、八进制或十六进制（“基数”分别等于10、2、8或16）数字的字符串表示形式作为输入。 |
| `String toString()`                           | 返回表示此“Integer”值的“String”对象。                        |
| `static String toString(int i)`               | 返回表示指定整数的“字符串”对象。                             |
| `static Integer valueOf(int i)`               | 返回包含指定基元值的“Integer”对象。                          |
| `static Integer valueOf(String s)`            | 返回包含指定字符串表示形式值的“Integer”对象。                |
| `static Integer valueOf(String s, int radix)` | 返回一个“Integer”对象，该对象包含指定字符串表示形式的整数值，并使用基数值进行分析。例如，如果s=“333”且基数=8，则该方法返回与八进制数333相等的十进制整数。 |

### 格式化数字打印输出

前面您看到了使用“print”和“println”方法将字符串打印到标准输出（“System.out”）。由于所有数字都可以转换为字符串（如您将在本课程后面看到的），因此可以使用这些方法打印字符串和数字的任意混合。然而，Java编程语言还有其他方法，允许您在包含数字时对打印输出进行更多控制。

#### printf和format方法

`java.io`包包含一个“PrintStream”类，该类有两种格式方法，可以用来替换“print”和“println”。这些方法“format”和“printf”彼此等效。熟悉的“系统”。out”恰好是“PrintStream”对象，因此您可以在“System.out”上调用“PrintStream”方法。因此，您可以在代码中以前使用过“print”或“println”的任何地方使用“format”或“print f”。例如

```java
System.out.format(.....);
```

这两个[`java.io.PrintStream`](https://docs.oracle.com/javase/8/docs/api/java/io/PrintStream.html)的语法方法相同：

```java
public PrintStream format(String format, Object... args)
```

其中“format”是指定要使用的格式的字符串，“args”是使用该格式打印的变量列表。一个简单的例子是

```java
System.out.format("The value of " + "the float variable is " +
     "%f, while the value of the " + "integer variable is %d, " +
     "and the string is %s", floatVar, intVar, stringVar); 
```

第一个参数“format”是一个格式字符串，指定如何格式化第二个参数“args”中的对象。格式字符串包含纯文本和*格式说明符*，它们是格式化“Object…args”参数的特殊字符。（符号“Object…args”称为*varargs*，这意味着参数的数量可能不同。）

格式说明符以百分号（%）开头，以*转换器*结尾。转换器是一个字符，指示要格式化的参数类型。在百分号（%）和转换器之间可以有可选的标志和说明符。[`java.util.Formatter`](https://docs.oracle.com/javase/8/docs/api/java/util/Formatter.html)中记录了许多转换器、标志和说明符

下面是一个基本示例：

```java
int i = 461012;
System.out.format("The value of i is: %d%n", i);
```

“%d”指定单个变量是十进制整数。“%n”是独立于平台的换行符。输出为：

```java
The value of i is: 461012
```

“printf”和“format”方法已重载。每个都有一个版本，其语法如下：

```java
public PrintStream format(Locale l, String format, Object... args)
```

例如，要以法语系统打印数字（在英文浮点数表示法中使用逗号代替小数点），可以使用：

```java
System.out.format(Locale.FRANCE,
    "The value of the float " + "variable is %f, while the " +
    "value of the integer variable " + "is %d, and the string is %s%n", 
    floatVar, intVar, stringVar); 
```

#### 一个🌰

下表列出了示例程序“TestFormat”中使用的一些转换器和标志。java`，它跟在表后面。

| 转换器 | Flag | 解释                                                         |
| ------ | ---- | ------------------------------------------------------------ |
| d      |      | 十进制整数                                                   |
| f      |      | A float.                                                     |
| n      |      | 适用于运行应用程序的平台的新行字符。您应该始终使用“%n”，而不是“\n”。 |
| tB     |      | 日期和时间转换区域设置特定的月份全名。                       |
| td, te |      | 日期和时间转换——每月的两位数。td根据需要有前导零，te没有。   |
| ty, tY |      | 日期和时间转换ty=2位年份，ty=4位年份。                       |
| tl     |      | 12小时时钟中的日期和时间转换小时。                           |
| tM     |      | 日期和时间转换分钟（2位），必要时带前导零。                  |
| tp     |      | 特定于区域设置的日期和时间转换上午/下午（小写）。            |
| tm     |      | 日期和时间转换月份（2位），必要时带前导零。                  |
| tD     |      | 日期和时间转换日期为%tm%td%ty                                |
|        | 08   | 宽度为八个字符，必要时带前导零。                             |
|        | +    | 包括正负号。                                                 |
|        | ,    | 包括区域设置特定的分组字符。                                 |
|        | -    | 左对齐。。                                                   |
|        | .3   | 小数点后三位。                                               |
|        | 10.3 | 宽十个字符，右对齐，小数点后三位。                           |

以下程序显示了可以使用“format”进行的一些格式化。输出显示在嵌入注释中的双引号内：

```java
import java.util.Calendar;
import java.util.Locale;

public class TestFormat {
    
    public static void main(String[] args) {
      long n = 461012;
      System.out.format("%d%n", n);      //  -->  "461012"
      System.out.format("%08d%n", n);    //  -->  "00461012"
      System.out.format("%+8d%n", n);    //  -->  " +461012"
      System.out.format("%,8d%n", n);    // -->  " 461,012"
      System.out.format("%+,8d%n%n", n); //  -->  "+461,012"
      
      double pi = Math.PI;

      System.out.format("%f%n", pi);       // -->  "3.141593"
      System.out.format("%.3f%n", pi);     // -->  "3.142"
      System.out.format("%10.3f%n", pi);   // -->  "     3.142"
      System.out.format("%-10.3f%n", pi);  // -->  "3.142"
      System.out.format(Locale.FRANCE,
                        "%-10.4f%n%n", pi); // -->  "3,1416"

      Calendar c = Calendar.getInstance();
      System.out.format("%tB %te, %tY%n", c, c, c); // -->  "May 29, 2006"

      System.out.format("%tl:%tM %tp%n", c, c, c);  // -->  "2:34 am"

      System.out.format("%tD%n", c);    // -->  "05/29/06"
    }
}
```

------

**Note:** 本节中的讨论仅涵盖“format”和“printf”方法的基础知识。有关详细信息，请参见[`Basic I/O `](https://docs.oracle.com/javase/tutorial/essential/io/formatting.html)在“格式化”页面中的Essential trail部分。
使用`String。格式`创建字符串包含在[strings](https://docs.oracle.com/javase/tutorial/java/data/strings.html)中.

------

#### DecimalFormat类

您可以使用[`java.text.DecimalFormat`](https://docs.oracle.com/javase/8/docs/api/java/text/DecimalFormat.html)类来控制前导和尾随零、前缀和后缀、分组（千）分隔符和小数分隔符的显示`DecimalFormat`在数字格式方面提供了很大的灵活性，但它会使代码更加复杂。

下面的示例通过向“DecimalFormat”构造函数传递模式字符串来创建“DecimalFormat”对象“myFormatter”。“format（）”方法（“DecimalFormat”继承自“NumberFormat”）随后由“myFormatter”调用-它接受“double”值作为参数，并以字符串形式返回格式化的数字：

下面是一个示例程序，说明了“DecimalFormat”的使用：

```java
import java.text.*;

public class DecimalFormatDemo {

   static public void customFormat(String pattern, double value ) {
      DecimalFormat myFormatter = new DecimalFormat(pattern);
      String output = myFormatter.format(value);
      System.out.println(value + "  " + pattern + "  " + output);
   }

   static public void main(String[] args) {

      customFormat("###,###.###", 123456.789);
      customFormat("###.##", 123456.789);
      customFormat("000000.000", 123.78);
      customFormat("$###,###.###", 12345.67);  
   }
}
```

The output is:

```
123456.789  ###,###.###  123,456.789
123456.789  ###.##  123456.79
123.78  000000.000  000123.780
12345.67  $###,###.###  $12,345.67
```

下表解释了每一行输出。

| Value      | Pattern      | Output      | Explanation                                                  |
| ---------- | ------------ | ----------- | ------------------------------------------------------------ |
| 123456.789 | ###,###.###  | 123,456.789 | 磅号（#）表示数字，逗号是分组分隔符的占位符，句点是小数分隔符的定位器。 |
| 123456.789 | ###.##       | 123456.79   | “value”在小数点右侧有三位数字，但“pattern”只有两位。“format”方法通过舍入来处理此问题。 |
| 123.78     | 000000.000   | 000123.780  | “pattern”指定前导和尾随零，因为使用的是0字符而不是磅符号（#）。 |
| 12345.67   | $###,###.### | $12,345.67  | “pattern”中的第一个字符是美元符号（$）。注意，它紧挨着格式化的“输出”中最左边的数字。 |

### 超越基本算术

Java编程语言支持基本算术及其算术运算符：+、-、*、/和%。[`Math`](https://docs.oracle.com/javase/8/docs/api/java/lang/Math.html)类。lang包提供了用于进行更高级数学计算的方法和常量。

“Math”类中的方法都是静态的，因此可以直接从类中调用它们，如下所示：

```java
Math.cos(angle);
```

------

**Note:** 使用[`import static`](https://docs.oracle.com/javase/tutorial/java/package/usepkgs.html#staticimport)语言功能，您不必在每个数学函数前面写“Math”：

```java
import static java.lang.Math.*;
```

这允许您通过简单名称调用“Math”类方法。例如：

```java
cos(angle);
```

------

#### 常量和基本方法

“Math”类包含两个常量：

- `Math.E`, 这是自然对数的基础，以及
- `Math.PI`, 这是圆的周长与其直径之比。

“Math”类还包括40多个静态方法。下表列出了一些基本方法。

| Method                                                       | Description                                         |
| ------------------------------------------------------------ | --------------------------------------------------- |
| `double abs(double d)float abs(float f)int abs(int i)long abs(long lng)` | 返回参数的绝对值。                                  |
| `double ceil(double d)`                                      | 返回大于或等于参数的最小整数。以双精度返回。        |
| `double floor(double d)`                                     | 返回小于或等于参数的最大整数。以双精度返回。        |
| `double rint(double d)`                                      | 返回值最接近参数的整数。以双精度返回。              |
| `long round(double d)int round(float f)`                     | 返回与参数最接近的long或int，如方法的返回类型所示。 |
| `double min(double arg1, double arg2)float min(float arg1, float arg2)int min(int arg1, int arg2)long min(long arg1, long arg2)` | 返回两个参数中较小的一个。                          |
| `double max(double arg1, double arg2)float max(float arg1, float arg2)int max(int arg1, int arg2)long max(long arg1, long arg2)` | 返回两个参数中较大的一个。                          |

以下程序[`BasicMathDemo`](https://docs.oracle.com/javase/tutorial/java/data/examples/BasicMathDemo.java)，说明了如何使用其中一些方法：

```java
public class BasicMathDemo {
    public static void main(String[] args) {
        double a = -191.635;
        double b = 43.74;
        int c = 16, d = 45;

        System.out.printf("The absolute value " + "of %.3f is %.3f%n", 
                          a, Math.abs(a));

        System.out.printf("The ceiling of " + "%.2f is %.0f%n", 
                          b, Math.ceil(b));

        System.out.printf("The floor of " + "%.2f is %.0f%n", 
                          b, Math.floor(b));

        System.out.printf("The rint of %.2f " + "is %.0f%n", 
                          b, Math.rint(b));

        System.out.printf("The max of %d and " + "%d is %d%n",
                          c, d, Math.max(c, d));

        System.out.printf("The min of of %d " + "and %d is %d%n",
                          c, d, Math.min(c, d));
    }
}
```

Here's the output from this program:

```
The absolute value of -191.635 is 191.635
The ceiling of 43.74 is 44
The floor of 43.74 is 43
The rint of 43.74 is 44
The max of 16 and 45 is 45
The min of 16 and 45 is 16
```

#### 指数和对数方法

下表列出了“Math”类的指数和对数方法。

| Method                                     | Description                            |
| ------------------------------------------ | -------------------------------------- |
| `double exp(double d)`                     | 将自然对数的基数e返回为参数的幂。      |
| `double log(double d)`                     | 返回参数的自然对数。                   |
| `double pow(double base, double exponent)` | 返回第一个参数的值乘以第二个参数的幂。 |
| `double sqrt(double d)`                    | 返回参数的平方根。                     |

以下程序[`ExponentialDemo`](https://docs.oracle.com/javase/tutorial/java/data/examples/ExponentialDemo.java)，显示“e”的值，然后对任意选择的数字调用上表中列出的每个方法：

```java
public class ExponentialDemo {
    public static void main(String[] args) {
        double x = 11.635;
        double y = 2.76;

        System.out.printf("The value of " + "e is %.4f%n",
                          Math.E);

        System.out.printf("exp(%.3f) " + "is %.3f%n",
                          x, Math.exp(x));

        System.out.printf("log(%.3f) is " + "%.3f%n",
                          x, Math.log(x));

        System.out.printf("pow(%.3f, %.3f) " + "is %.3f%n",
                          x, y, Math.pow(x, y));

        System.out.printf("sqrt(%.3f) is " + "%.3f%n",
                          x, Math.sqrt(x));
    }
}
```

Here's the output you'll see when you run `ExponentialDemo`:

```
The value of e is 2.7183
exp(11.635) is 112983.831
log(11.635) is 2.454
pow(11.635, 2.760) is 874.008
sqrt(11.635) is 3.411
```

#### 三角测量法

“Math”类还提供了三角函数的集合，总结如下表所示。传递给每个方法的值都是以弧度表示的角度。可以使用“toRadians”方法将度数转换为弧度。

| Method                                                 | Description                                           |
| ------------------------------------------------------ | ----------------------------------------------------- |
| `double sin(double d)`                                 | 返回指定双精度值的正弦值。                            |
| `double cos(double d)`                                 | 返回指定双精度值的余弦值。                            |
| `double tan(double d)`                                 | 返回指定双精度值的正切值。                            |
| `double asin(double d)`                                | 返回指定双精度值的反正弦。                            |
| `double acos(double d)`                                | 返回指定双精度值的反余弦。                            |
| `double atan(double d)`                                | 返回指定双精度值的反正切。                            |
| `double atan2(double y, double x)`                     | 将矩形坐标“（x，y）”转换为极坐标“（r，θ）”并返回“θ”。 |
| `double toDegrees(double d)double toRadians(double d)` | 将参数转换为度或弧度。                                |

这是一个程序[`TrigonomicDemo`](https://docs.oracle.com/javase/tutorial/java/data/examples/TrigonometricDemo.java)，使用这些方法计算45度角的各种三角值：

```java
public class TrigonometricDemo {
    public static void main(String[] args) {
        double degrees = 45.0;
        double radians = Math.toRadians(degrees);
        
        System.out.format("The value of pi " + "is %.4f%n",
                           Math.PI);

        System.out.format("The sine of %.1f " + "degrees is %.4f%n",
                          degrees, Math.sin(radians));

        System.out.format("The cosine of %.1f " + "degrees is %.4f%n",
                          degrees, Math.cos(radians));

        System.out.format("The tangent of %.1f " + "degrees is %.4f%n",
                          degrees, Math.tan(radians));

        System.out.format("The arcsine of %.4f " + "is %.4f degrees %n", 
                          Math.sin(radians), 
                          Math.toDegrees(Math.asin(Math.sin(radians))));

        System.out.format("The arccosine of %.4f " + "is %.4f degrees %n", 
                          Math.cos(radians),  
                          Math.toDegrees(Math.acos(Math.cos(radians))));

        System.out.format("The arctangent of %.4f " + "is %.4f degrees %n", 
                          Math.tan(radians), 
                          Math.toDegrees(Math.atan(Math.tan(radians))));
    }
}
```

The output of this program is as follows:

```
The value of pi is 3.1416
The sine of 45.0 degrees is 0.7071
The cosine of 45.0 degrees is 0.7071
The tangent of 45.0 degrees is 1.0000
The arcsine of 0.7071 is 45.0000 degrees
The arccosine of 0.7071 is 45.0000 degrees
The arctangent of 1.0000 is 45.0000 degrees
```

#### 随机数

“random()”方法返回介于0.0和1.0之间的伪随机选择的数字。范围包括0.0但不包括1.0。换句话说： `0.0 <= Math.random() < 1.0`. 要获得不同范围的数字，可以对随机方法返回的值执行算术运算。例如，要生成一个介于0和9之间的整数，您可以写：

```
int number = (int)(Math.random() * 10);
```

通过将该值乘以10，可能值的范围变为 `0.0 <= number < 10.0`.

使用`Math。当你需要生成一个随机数时，“随机”很有效。如果需要生成一系列随机数，应该创建`java.util。Random”并调用该对象上的方法以生成数字。

### Numbers 总结

您可以使用一个包装类（“Byte”、“Double”、”Float“、”Integer“、”Long“或”Short“）来包装对象中的多个基本类型。Java编译器会在必要时自动为您包装（装箱）原语，并在必要时再次打开它们。

“Number”类包括常量和有用的类方法。`MIN_VALUE`和`MAX_VALUE'常量包含该类型对象可以包含的最小和最大值。“byteValue”、“shortValue”和类似的方法将一种数字类型转换为另一种。“valueOf”方法将字符串转换为数字，“toString”方法将数字转换为字符串。

要格式化包含数字的字符串以进行输出，可以使用“PrintStream”类中的“printf（）”或“format（）”方法。或者，您可以使用“NumberFormat”类使用模式自定义数字格式。

“Math”类包含用于执行数学函数的各种类方法，包括指数、对数和三角方法`Math还包括基本的算术函数，如绝对值和舍入，以及生成随机数的方法“random（）”。

## Characters

大多数情况下，如果使用的是单个字符值，则将使用基本的“char”类型。例如：

```java
char ch = 'a'; 
// Unicode for uppercase Greek omega character
char uniChar = '\u03A9';
// an array of chars
char[] charArray = { 'a', 'b', 'c', 'd', 'e' };
```

然而，有时需要将字符用作对象，例如，用作需要对象的方法参数。Java编程语言提供了一个*wrapper*类，用于将“char”“包装”在“Character”对象中。“Character”类型的对象包含一个字段，其类型为“char”。此[字符](https://docs.oracle.com/javase/8/docs/api/java/lang/Character.html)类还提供了许多有用的类（即静态）方法来处理字符。

您可以使用“Character”构造函数创建“Character”对象：

```java
Character ch = new Character('a');
```

在某些情况下，Java编译器还会为您创建一个“字符”对象。例如，如果将原语“char”传递给需要对象的方法，编译器会自动将“char”转换为“Character”。如果转换方向相反，则此功能称为*autoboxing*或*unboxing*。有关自动装箱和取消装箱的详细信息，请参见[自动装箱和解除装箱](https://docs.oracle.com/javase/tutorial/java/data/autoboxing.html).

------

**Note:** “Character”类是不可变的，因此一旦创建了它，就不能更改“Character”对象。

------

下表列出了“Character”类中一些最有用的方法，但并不详尽。有关该类中所有方法的完整列表（超过50个），请参阅[java.lang.Character](https://docs.oracle.com/javase/8/docs/api/java/lang/Character.html)API规范。

| Method                                                     | Description                                            |
| ---------------------------------------------------------- | ------------------------------------------------------ |
| `boolean isLetter(char ch)boolean isDigit(char ch)`        | 确定指定的字符值是字母还是数字。                       |
| `boolean isWhitespace(char ch)`                            | 确定指定的字符值是否为空白。                           |
| `boolean isUpperCase(char ch)boolean isLowerCase(char ch)` | 确定指定的字符值是大写还是小写。                       |
| `char toUpperCase(char ch)char toLowerCase(char ch)`       | 返回指定字符值的大小写形式。                           |
| `toString(char ch)`                                        | 返回表示指定字符值的“字符串”对象，即一个单字符字符串。 |

### 转义序列

反斜杠（\）前面的字符是*转义序列*，对编译器有特殊意义。下表显示了Java转义序列：

| Escape Sequence | Description                  |
| --------------- | ---------------------------- |
| `\t`            | 此时在文本中插入一个选项卡。 |
| `\b`            | 此时在文本中插入退格。       |
| `\n`            | 此时在文本中插入新行。       |
| `\r`            | 此时在文本中插入回车符。     |
| `\f`            | 此时在文本中插入表单源。     |
| `\'`            | 此时在文本中插入单引号字符。 |
| `\"`            | 此时在文本中插入双引号字符。 |
| `\\`            | 此时在文本中插入反斜杠字符。 |

当在print语句中遇到转义序列时，编译器会相应地解释它。例如，如果要将引号放在引号内，必须在内部引号上使用转义序列“”

```
She said "Hello!" to me.
```

你会写

```
System.out.println("She said \"Hello!\" to me.");
```

## Strings

Strings, 在Java编程中广泛使用的字符序列是字符序列。在Java编程语言中，字符串是对象。

Java平台提供[`String`](https://docs.oracle.com/javase/8/docs/api/java/lang/String.html)类来创建和操作字符串。

### Creating Strings

创建字符串的最直接方法是编写：

```
String greeting = "Hello world!";
```

在这种情况下，“你好世界！”是*字符串文字*-代码中用双引号括起来的一系列字符。每当在代码中遇到字符串时，编译器都会创建一个“string”对象，其值在本例中为“Hello world！”。

与其他任何对象一样，可以使用“new”关键字和构造函数创建“String”对象。“String”类有13个构造函数，允许您使用不同的源（例如字符数组）提供字符串的初始值：

```java
char[] helloArray = { 'h', 'e', 'l', 'l', 'o', '.' };
String helloString = new String(helloArray);
System.out.println(helloString);
```

此代码段的最后一行显示“hello”。

------

**Note:** “String”类是不可变的，因此一旦创建了“String”对象就不能更改。“String”类有许多方法，下面将讨论其中一些方法，它们似乎可以修改字符串。由于字符串是不可变的，所以这些方法真正要做的是创建并返回包含操作结果的新字符串。

------

### String Length

用于获取对象信息的方法称为*访问器方法*。可以用于字符串的一个访问器方法是“length（）”方法，它返回字符串对象中包含的字符数。执行以下两行代码后，“len”等于17：

```java
String palindrome = "Dot saw I was Tod";
int len = palindrome.length();
```

回文是一个对称的单词或句子，前后拼写相同，忽略大小写和标点符号。这里有一个简短而低效的程序来反转回文字符串。它调用“String”方法“charAt（i）”，该方法返回字符串中的第i个字符，从0开始计数。

```java
public class StringDemo {
    public static void main(String[] args) {
        String palindrome = "Dot saw I was Tod";
        int len = palindrome.length();
        char[] tempCharArray = new char[len];
        char[] charArray = new char[len];
        
        // put original string in an 
        // array of chars
        for (int i = 0; i < len; i++) {
            tempCharArray[i] = 
                palindrome.charAt(i);
        } 
        
        // reverse array of chars
        for (int j = 0; j < len; j++) {
            charArray[j] =
                tempCharArray[len - 1 - j];
        }
        
        String reversePalindrome =
            new String(charArray);
        System.out.println(reversePalindrome);
    }
}
```

Running the program produces this output:

```
doT saw I was toD
```

为了实现字符串反转，程序必须将字符串转换为字符数组（第一个“for”循环），将数组反转为第二个数组（第二个“for“循环），然后再转换回字符串。[`String`](https://docs.oracle.com/javase/8/docs/api/java/lang/String.html)类包含一个方法“getChars（）”，用于将字符串或字符串的一部分转换为字符数组，这样我们就可以用

```java
palindrome.getChars(0, len, tempCharArray, 0);
```

### 拼接 Strings

“String”类包含一个连接两个字符串的方法：

```java
string1.concat(string2); 
```

这将返回一个新字符串，该字符串为string1，末尾添加了string2。

还可以对字符串文本使用“concat（）”方法，如：

```java
"My name is ".concat("Rumplestiltskin");
```

字符串通常用“+”运算符连接，如

```java
"Hello," + " world" + "!"
```

这导致

```java
"Hello, world!"
```

“+”运算符在“print”语句中广泛使用。例如：

```java
String string1 = "saw I was ";
System.out.println("Dot " + string1 + "Tod");
```

which prints

```
Dot saw I was Tod
```

这种连接可以是任何对象的混合。对于每个不是“字符串”的对象，调用其“toString（）”方法将其转换为“字符串”。

------

**Note:** Java编程语言不允许文本字符串跨越源文件中的行，因此必须在多行字符串中的每行末尾使用“+”连接运算符。例如：

```java
String quote = 
    "Now is the time for all good " +
    "men to come to the aid of their country.";
```

在“print”语句中，使用“+”串联运算符断开行之间的字符串也是非常常见的。

------

### 创建格式字符串

您已经看到了使用“printf（）”和“format（）”方法打印带有格式化数字的输出。“String”类有一个等效的类方法“format（）”，它返回“String”对象而不是“PrintStream”对象。

使用“String”的“static”format（）方法，您可以创建可重复使用的格式化字符串，而不是一次性打印语句。例如，代替

```java
System.out.printf("The value of the float " +
                  "variable is %f, while " +
                  "the value of the " + 
                  "integer variable is %d, " +
                  "and the string is %s", 
                  floatVar, intVar, stringVar); 
```

you can write

```java
String fs;
fs = String.format("The value of the float " +
                   "variable is %f, while " +
                   "the value of the " + 
                   "integer variable is %d, " +
                   " and the string is %s",
                   floatVar, intVar, stringVar);
System.out.println(fs);
```

### 在数字和字符串之间转换

#### 将字符串转换为数字

通常，程序以字符串对象（例如，用户输入的值）中的数字数据结尾。

包装基本数字类型的“Number”子类（[`Byte`](https://docs.oracle.com/javase/8/docs/api/java/lang/Byte.html)，[`Integer`](https://docs.oracle.com/javase/8/docs/api/java/lang/Integer.html)，[`Double`](https://docs.oracle.com/javase/8/docs/api/java/lang/Double.html)，[`Float`](https://docs.oracle.com/javase/8/docs/api/java/lang/Float.html)，[`Long`](https://docs.oracle.com/javase/8/docs/api/java/lang/Long.html)，和[`Short`](https://docs.oracle.com/javase/8/docs/api/java/lang/Short.html))每个都提供一个名为“valueOf”的类方法，该方法将字符串转换为该类型的对象。下面是一个示例[`ValueOfDemo`](https://docs.oracle.com/javase/tutorial/java/data/examples/ValueOfDemo.java)，从命令行获取两个字符串，将它们转换为数字，并对值执行算术运算：

```java
public class ValueOfDemo {
    public static void main(String[] args) {

        // this program requires two 
        // arguments on the command line 
        if (args.length == 2) {
            // convert strings to numbers
            float a = (Float.valueOf(args[0])).floatValue(); 
            float b = (Float.valueOf(args[1])).floatValue();

            // do some arithmetic
            System.out.println("a + b = " +
                               (a + b));
            System.out.println("a - b = " +
                               (a - b));
            System.out.println("a * b = " +
                               (a * b));
            System.out.println("a / b = " +
                               (a / b));
            System.out.println("a % b = " +
                               (a % b));
        } else {
            System.out.println("This program " +
                "requires two command-line arguments.");
        }
    }
}
```

以下是使用“4.5”和“87.2”作为命令行参数时程序的输出：

```
a + b = 91.7
a - b = -82.7
a * b = 392.4
a / b = 0.0516055
a % b = 4.5
```

------

**Note:** 包装原始数字类型的每个“Number”子类还提供了一个“parseXXXX（）”方法（例如，“parseFloat（）”），可用于将字符串转换为原始数字。由于返回的是基元类型而不是对象，因此“parseFloat（）”方法比“valueOf（）”更直接。例如，在“ValueOfDemo”程序中，我们可以使用：

```java
float a = Float.parseFloat(args[0]);
float b = Float.parseFloat(args[1]);
```

------

#### 将数字转换为字符串

有时您需要将数字转换为字符串，因为您需要对其字符串形式的值进行操作。有几种简单的方法可以将数字转换成字符串：

```java
int i;
// Concatenate "i" with an empty string; conversion is handled for you.
String s1 = "" + i;
```

or

```java
// The valueOf class method.
String s2 = String.valueOf(i);
```

每个“Number”子类都包含一个类方法“toString（）”，该方法将其原始类型转换为字符串。例如：

```java
int i;
double d;
String s3 = Integer.toString(i); 
String s4 = Double.toString(d); 
```

[`ToStringDemo`](https://docs.oracle.com/javase/tutorial/java/data/examples/ToStringDemo.java)示例使用“toString”方法将数字转换为字符串。然后，程序使用一些字符串方法计算小数点前后的位数：

```java
public class ToStringDemo {
    
    public static void main(String[] args) {
        double d = 858.48;
        String s = Double.toString(d);
        
        int dot = s.indexOf('.');
        
        System.out.println(dot + " digits " +
            "before decimal point.");
        System.out.println( (s.length() - dot - 1) +
            " digits after decimal point.");
    }
}
```

The output of this program is:

```
3 digits before decimal point.
2 digits after decimal point.
```

### 操纵字符串中的字符

“String”类有许多方法用于检查字符串的内容、查找字符串中的字符或子字符串、更改大小写和其他任务。

#### 按索引获取字符和子字符串

通过调用“charAt（）”访问器方法，可以获取字符串中特定索引处的字符。第一个字符的索引为0，而最后一个字符的指数为“length（）-1”。例如，以下代码获取字符串中索引9处的字符：

```
String anotherPalindrome = "Niagara. O roar again!"; 
char aChar = anotherPalindrome.charAt(9);
```

索引从0开始，因此索引9处的字符为“O”，如下图所示：

![Use the charAt method to get a character at a particular index.](Oracle-Java-Numbers和Strings/objects-charAt.gif)

如果要从字符串中获取多个连续字符，可以使用“substring”方法。“substring”方法有两个版本，如下表所示：

| Method                                           | Description                                                  |
| ------------------------------------------------ | ------------------------------------------------------------ |
| `String substring(int beginIndex, int endIndex)` | 返回作为此字符串的子字符串的新字符串。子字符串从指定的“beginIndex”开始，并扩展到索引“endIndex-1”处的字符。 |
| `String substring(int beginIndex)`               | 返回作为此字符串的子字符串的新字符串。整数参数指定第一个字符的索引。这里，返回的子字符串扩展到原始字符串的末尾。 |

以下代码从尼亚加拉回文中获取从索引11延伸到但不包括索引15的子字符串，即单词“咆哮”：

```java
String anotherPalindrome = "Niagara. O roar again!"; 
String roar = anotherPalindrome.substring(11, 15); 
```

![Use the substring method to get part of a string.](Oracle-Java-Numbers和Strings/objects-substring.gif)

#### 操纵字符串的其他方法

以下是用于操作字符串的其他几种“字符串”方法：

| Method                                                       | Description                                                  |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| `String[] split(String regex)` `String[] split(String regex, int limit)` | 搜索字符串参数（包含正则表达式）指定的匹配项，并相应地将此字符串拆分为字符串数组。可选整数参数指定返回数组的最大大小。正则表达式包含在题为“正则表达式”的课程中 |
| `CharSequence subSequence(int beginIndex, int endIndex)`     | 返回从“beginIndex”索引到“endIndex”-1构造的新字符序列。       |
| `String trim()`                                              | 返回此字符串的副本，其中删除了前导空格和尾随空格。           |
| `String toLowerCase()String toUpperCase()`                   | 返回转换为小写或大写的字符串副本。如果不需要转换，这些方法将返回原始字符串。 |

#### 搜索字符串中的字符和子字符串

下面是一些用于查找字符串中的字符或子字符串的其他“字符串”方法。“String”类提供了返回特定字符或子字符串在字符串中的位置的访问器方法：“indexOf（）”和“lastIndexOf（（）”。“indexOf（）”方法从字符串的开头向前搜索，而“lastIndexOf（”方法则从字符串的结尾向后搜索。如果未找到字符或子字符串，“indexOf（）”和“lastIndexOf（（）”将返回-1。

“String”类还提供了一个搜索方法“contains”，如果字符串包含特定的字符序列，则返回true。当您只需要知道字符串包含一个字符序列，但准确的位置并不重要时，可以使用此方法。

下表介绍了各种字符串搜索方法。

| Method                                                       | Description                                                  |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| `int indexOf(int ch)int lastIndexOf(int ch)`                 | 返回指定字符第一次（最后一次）出现的索引。                   |
| `int indexOf(int ch, int fromIndex)int lastIndexOf(int ch, int fromIndex)` | 返回指定字符第一次（最后一次）出现的索引，从指定索引向前（向后）搜索。 |
| `int indexOf(String str)int lastIndexOf(String str)`         | 返回指定子字符串第一次（最后一次）出现的索引。               |
| `int indexOf(String str, int fromIndex)int lastIndexOf(String str, int fromIndex)` | 返回指定子字符串第一次（最后一次）出现的索引，从指定索引向前（向后）搜索。 |
| `boolean contains(CharSequence s)`                           | 如果字符串包含指定的字符序列，则返回true。                   |

------

**Note:**`CharSequence`是由“String”类实现的接口。因此，可以使用字符串作为“contains（）”方法的参数。

------

#### 将字符和子字符串替换为字符串

“String”类很少有将字符或子字符串插入字符串的方法。一般来说，它们是不需要的：您可以通过将从字符串中删除的子字符串与要插入的子字符串串联起来来创建新字符串。

不过，“String”类有四个方法来替换找到的字符或子字符串。他们是：

| Method                                                       | Description                                                  |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| `String replace(char oldChar, char newChar)`                 | 返回一个新字符串，该字符串是用newChar替换此字符串中所有oldChar的结果。 |
| `String replace(CharSequence target, CharSequence replacement)` | 用指定的文字替换序列替换此字符串中与文字目标序列匹配的每个子字符串。 |
| `String replaceAll(String regex, String replacement)`        | 用给定的替换替换此字符串中与给定正则表达式匹配的每个子字符串。 |
| `String replaceFirst(String regex, String replacement)`      | 用给定的替换替换此字符串中与给定正则表达式匹配的第一个子字符串。 |

#### 一个例子

以下类[`Filename](https://docs.oracle.com/javase/tutorial/java/data/examples/Filename.java)，说明了使用“lastIndexOf（）”和“substring（）”来隔离文件名的不同部分。

------

**Note:** 下面的“Filename”类中的方法不进行任何错误检查，并假定它们的参数包含完整的目录路径和带有扩展名的文件名。如果这些方法是生产代码，它们将验证其参数是否正确构造。

------

```java
public class Filename {
    private String fullPath;
    private char pathSeparator, 
                 extensionSeparator;

    public Filename(String str, char sep, char ext) {
        fullPath = str;
        pathSeparator = sep;
        extensionSeparator = ext;
    }

    public String extension() {
        int dot = fullPath.lastIndexOf(extensionSeparator);
        return fullPath.substring(dot + 1);
    }

    // gets filename without extension
    public String filename() {
        int dot = fullPath.lastIndexOf(extensionSeparator);
        int sep = fullPath.lastIndexOf(pathSeparator);
        return fullPath.substring(sep + 1, dot);
    }

    public String path() {
        int sep = fullPath.lastIndexOf(pathSeparator);
        return fullPath.substring(0, sep);
    }
}
```

这是一个程序[`FilenameDemo`](https://docs.oracle.com/javase/tutorial/java/data/examples/FilenameDemo.java)，构造一个“Filename”对象并调用其所有方法：

```java
public class FilenameDemo {
    public static void main(String[] args) {
        final String FPATH = "/home/user/index.html";
        Filename myHomePage = new Filename(FPATH, '/', '.');
        System.out.println("Extension = " + myHomePage.extension());
        System.out.println("Filename = " + myHomePage.filename());
        System.out.println("Path = " + myHomePage.path());
    }
}
```

And here's the output from the program:

```
Extension = html
Filename = index
Path = /home/user
```

如下图所示，我们的“extension”方法使用“lastIndexOf”来查找文件名中句点（.）的最后一次出现。然后，“substring”使用“lastIndexOf”的返回值提取文件扩展名，即从句点到字符串结尾的子字符串。此代码假定文件名中有句点；如果文件名没有句点，“lastIndexOf”将返回-1，而substring方法将抛出“StringIndexOutOfBoundsException”。

![The use of lastIndexOf and substring in the extension method in the Filename class.](Oracle-Java-Numbers和Strings/objects-lastIndexOf.gif)

此外，请注意，“extension”方法使用“dot+1”作为“substring”的参数。如果句点字符（.）是字符串的最后一个字符，则“点+1”等于字符串的长度，比字符串中最大的索引大一个（因为索引从0开始）。这是“substring”的合法参数，因为该方法接受一个等于但不大于字符串长度的索引，并将其解释为“字符串的结尾”

### 比较字符串和部分字符串

“String”类有许多用于比较字符串和字符串部分的方法。下表列出了这些方法。

| Method                                                       | Description                                                  |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| `boolean endsWith(String suffix)boolean startsWith(String prefix)` | 如果此字符串以指定为方法参数的子字符串结尾或开头，则返回“true”。 |
| `boolean startsWith(String prefix, int offset)`              | 考虑以索引“offset”开头的字符串，如果以指定为参数的子字符串开头，则返回“true”。 |
| `int compareTo(String anotherString)`                        | 以字典方式比较两个字符串。返回一个整数，指示此字符串是否大于（结果>0）、等于（结果=0）或小于（结果<0）参数。 |
| `int compareToIgnoreCase(String str)`                        | 以字典方式比较两个字符串，忽略大小写的差异。返回一个整数，指示此字符串是否大于（结果>0）、等于（结果=0）或小于（结果<0）参数。 |
| `boolean equals(Object anObject)`                            | 当且仅当参数是表示与此对象相同的字符序列的“字符串”对象时，返回“true”。 |
| `boolean equalsIgnoreCase(String anotherString)`             | 当且仅当参数是与此对象表示相同字符序列的“字符串”对象时，返回“true”，忽略大小写差异。 |
| `boolean regionMatches(int toffset, String other, int ooffset, int len)` | 测试此字符串的指定区域是否与string参数的指定区域匹配。Region的长度为“len”，对于此字符串以索引“toffset”开始，对于另一个字符串则以索引“ooffset”开头。 |
| `boolean regionMatches(boolean ignoreCase, int toffset, String other, int ooffset, int len)` | 测试此字符串的指定区域是否与string参数的指定区域匹配。Region的长度为“len”，对于此字符串以索引“toffset”开始，对于另一个字符串则以索引“ooffset”开头。布尔参数指示是否应忽略大小写；如果为true，则在比较字符时忽略大小写。 |
| `boolean matches(String regex)`                              | 测试此字符串是否与指定的正则表达式匹配。正则表达式在题为“正则表达式”的课程中讨论 |

以下程序“RegionMatchesDemo”使用“regionMatches”方法在另一个字符串中搜索字符串：

```java
public class RegionMatchesDemo {
    public static void main(String[] args) {
        String searchMe = "Green Eggs and Ham";
        String findMe = "Eggs";
        int searchMeLength = searchMe.length();
        int findMeLength = findMe.length();
        boolean foundIt = false;
        for (int i = 0; 
             i <= (searchMeLength - findMeLength);
             i++) {
           if (searchMe.regionMatches(i, findMe, 0, findMeLength)) {
              foundIt = true;
              System.out.println(searchMe.substring(i, i + findMeLength));
              break;
           }
        }
        if (!foundIt)
            System.out.println("No match found.");
    }
}
```

这个程序的输出是“鸡蛋”。

程序一次一个字符地遍历“searchMe”引用的字符串。对于每个字符，程序调用regionMatches方法来确定以当前字符开头的子字符串是否与程序正在查找的字符串匹配。

### The StringBuilder Class

[`StringBuilder `](https://docs.oracle.com/javase/8/docs/api/java/lang/StringBuilder.html)对象类似于[`String`](https://docs.oracle.com/javase/8/docs/api/java/lang/String.html)对象，但它们可以修改。在内部，这些对象被视为包含字符序列的可变长度数组。在任何时候，序列的长度和内容都可以通过方法调用来更改。

除非字符串生成器在更简单的代码（参见本节末尾的示例程序）或更好的性能方面具有优势，否则应始终使用字符串。例如，如果需要连接大量字符串，则附加到“StringBuilder”对象更有效。

#### 长度和容量

与“String”类一样，“StringBuilder”类有一个“length（）”方法，用于返回生成器中字符序列的长度。

与字符串不同，每个字符串生成器还具有*容量*，即已分配的字符空间数。“capacity（）”方法返回的容量始终大于或等于长度（通常大于），并将根据需要自动扩展以适应对字符串生成器的添加。

| Constructor                       | Description                                                  |
| --------------------------------- | ------------------------------------------------------------ |
| `StringBuilder()`                 | 创建容量为16（16个空元素）的空字符串生成器。                 |
| `StringBuilder(CharSequence cs)`  | 构造一个字符串生成器，其中包含与指定的CharSequence相同的字符，再加上CharSequence后面的16个空元素。 |
| `StringBuilder(int initCapacity)` | 创建具有指定初始容量的空字符串生成器。                       |
| `StringBuilder(String s)`         | 创建一个字符串生成器，其值由指定的字符串初始化，加上字符串后面的额外16个空元素。 |

For example, the following code

```
// creates empty builder, capacity 16
StringBuilder sb = new StringBuilder();
// adds 9 character string at beginning
sb.append("Greetings");
```

将产生长度为9、容量为16:

![A string builder's length is the number of characters it contains; a string builder's capacity is the number of character spaces that have been allocated.](Oracle-Java-Numbers和Strings/objects-stringBuffer.gif)

“StringBuilder”类有一些与“String”类没有的长度和容量相关的方法：

| Method                                 | Description                                                  |
| -------------------------------------- | ------------------------------------------------------------ |
| `void setLength(int newLength)`        | 设置字符序列的长度。如果“newLength”小于“length（）”，则将截断字符序列中的最后一个字符。如果“newLength”大于“length（）”，则在字符序列末尾添加空字符。 |
| `void ensureCapacity(int minCapacity)` | 确保容量至少等于指定的最小值。                               |

许多操作（例如，“append（）”、“insert（）”或“setLength（）”）可以增加字符串生成器中字符序列的长度，从而使生成的“length（）”大于当前的“capacity（））”。发生这种情况时，容量会自动增加。

#### StringBuilder操作

“StringBuilder”上的主要操作在“String”中不可用，它们是“append（）”和“insert（）”方法，它们被重载以接受任何类型的数据。每个都将其参数转换为字符串，然后将该字符串的字符附加或插入到字符串生成器中的字符序列中。append方法总是在现有字符序列的末尾添加这些字符，而insert方法在指定的点添加字符。

下面是“StringBuilder”类的一些方法。

| Method                                                       | Description                                                  |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| `StringBuilder append(boolean b)StringBuilder append(char c)StringBuilder append(char[] str)StringBuilder append(char[] str, int offset, int len)StringBuilder append(double d)StringBuilder append(float f)StringBuilder append(int i)StringBuilder append(long lng)StringBuilder append(Object obj)StringBuilder append(String s)` | 将参数追加到此字符串生成器。在执行追加操作之前，数据被转换为字符串。 |
| `StringBuilder delete(int start, int end)StringBuilder deleteCharAt(int index)` | 第一个方法删除“StringBuilder”的字符序列中从头至尾1（含）的子序列。第二种方法删除位于“index”的字符。 |
| `StringBuilder insert(int offset, boolean b)StringBuilder insert(int offset, char c)StringBuilder insert(int offset, char[] str)StringBuilder insert(int index, char[] str, int offset, int len)StringBuilder insert(int offset, double d)StringBuilder insert(int offset, float f)StringBuilder insert(int offset, int i)StringBuilder insert(int offset, long lng)StringBuilder insert(int offset, Object obj)StringBuilder insert(int offset, String s)` | 将第二个参数插入字符串生成器。第一个整数参数指示要在其之前插入数据的索引。在执行插入操作之前，数据被转换为字符串。 |
| `StringBuilder replace(int start, int end, String s)void setCharAt(int index, char c)` | 替换此字符串生成器中的指定字符。                             |
| `StringBuilder reverse()`                                    | 反转此字符串生成器中的字符序列。                             |
| `String toString()`                                          | 返回包含生成器中的字符序列的字符串。                         |

------

**Note:** 通过首先使用“StringBuilder”类的“toString（）”方法将字符串生成器转换为字符串，可以在“StringBuilder”对象上使用任何“String”方法。然后使用“StringBuilder（Stringstr）”构造函数将字符串转换回字符串生成器。

------

#### 一个例子

标题为“字符串”的部分中列出的“StringDemo”程序是一个程序的示例，如果使用“StringBuilder”而不是“String”，该程序的效率会更高。

`StringDemo`反转了回文。再次列出：

```java
public class StringDemo {
    public static void main(String[] args) {
        String palindrome = "Dot saw I was Tod";
        int len = palindrome.length();
        char[] tempCharArray = new char[len];
        char[] charArray = new char[len];
        
        // put original string in an 
        // array of chars
        for (int i = 0; i < len; i++) {
            tempCharArray[i] = 
                palindrome.charAt(i);
        } 
        
        // reverse array of chars
        for (int j = 0; j < len; j++) {
            charArray[j] =
                tempCharArray[len - 1 - j];
        }
        
        String reversePalindrome =
            new String(charArray);
        System.out.println(reversePalindrome);
    }
}
```

Running the program produces this output:

```
doT saw I was toD
```

为了实现字符串反转，程序将字符串转换为字符数组（第一个“for”循环），将数组反转为第二个数组（第二个“for“循环），然后转换回字符串。

如果将“回文”字符串转换为字符串生成器，则可以在“StringBuilder”类中使用“reverse（）”方法。它使代码更简单，更容易阅读：

```java
public class StringBuilderDemo {
    public static void main(String[] args) {
        String palindrome = "Dot saw I was Tod";
         
        StringBuilder sb = new StringBuilder(palindrome);
        
        sb.reverse();  // reverse it
        
        System.out.println(sb);
    }
}
```

Running this program produces the same output:

```
doT saw I was toD
```

Note that `println()` prints a string builder, as in:

```
System.out.println(sb);
```

因为某人.toString()”被隐式调用，就像在“println（）”调用中对任何其他对象一样。

------

**Note:** 还有一个“StringBuffer”类与“StringBuilder”类*完全相同，只是由于方法同步，它是线程安全的。线程将在关于并发的课程中讨论。

------

### Characters and Strings 总结

大多数情况下，如果使用的是单个字符值，则将使用基本的“char”类型。然而，有时需要将字符用作对象，例如，用作需要对象的方法参数。Java编程语言提供了一个*wrapper*类，用于将“char”“包装”在“Character”对象中。“Character”类型的对象包含一个类型为“char”的字段。此[`字符`](https://docs.oracle.com/javase/8/docs/api/java/lang/Character.html)类还提供了许多有用的类（即静态）方法来处理字符。

字符串是一系列字符，在Java编程中广泛使用。在Java编程语言中，字符串是对象。[`String`](https://docs.oracle.com/javase/8/docs/api/java/lang/String.html)类有60多个方法和13个构造函数。

最常见的情况是，您使用以下语句创建字符串

```
String s = "Hello world!";
```

而不是使用“String”构造函数之一。

“String”类有许多方法来查找和检索子字符串；然后可以使用“+”串联运算符将这些字符串轻松地重新组合成新字符串。

“String”类还包括许多实用程序方法，其中包括“split（）”、“toLowerCase（）”，“toUpperCase（）”和“valueOf（）”。在将用户输入字符串转换为数字时，后一种方法是必不可少的。“Number”子类也有将字符串转换为数字的方法，反之亦然。

除了“String”类之外，还有一个[`StringBuilder`](https://docs.oracle.com/javase/8/docs/api/java/lang/StringBuilder.html)类。使用“StringBuilder”对象有时比使用字符串更有效。“StringBuilder”类提供了一些对字符串有用的方法，其中包括“reverse（）”。然而，一般来说，“String”类有更广泛的方法。

可以使用“StringBuilder”构造函数将字符串转换为字符串生成器。可以使用“toString（）”方法将字符串生成器转换为字符串。

## 自动装箱和拆箱

*Autoboxing*是Java编译器在原语类型及其对应的对象包装类之间进行的自动转换。例如，将“int”转换成“Integer”，将“double”转换为“double”，依此类推。如果转换相反，则称为“unboxing”。

以下是自动装箱的最简单示例：

```java
Character ch = 'a';
```

本节中的其他示例使用泛型。如果您还不熟悉泛型的语法，请参阅[generics（Updated）](https://docs.oracle.com/javase/tutorial/java/generics/index.html)教训。

考虑以下代码：

```java
List<Integer> li = new ArrayList<>();
for (int i = 1; i < 50; i += 2)
    li.add(i);
```

尽管将“int”值作为基元类型而不是“Integer”对象添加到“li”中，但代码仍会编译。因为“li”是“Integer”对象的列表，而不是“int”值的列表，所以您可能会想为什么Java编译器不会发出编译时错误。编译器不会生成错误，因为它从“i”创建了一个“Integer”对象，并将该对象添加到“li”。因此，编译器在运行时将先前的代码转换为以下代码：

```java
List<Integer> li = new ArrayList<>();
for (int i = 1; i < 50; i += 2)
    li.add(Integer.valueOf(i));
```

将原始值（例如“int”）转换为相应包装类（“Integer”）的对象称为自动装箱。当基元值为：

- 作为参数传递给需要相应包装类的对象的方法。
- 分配给相应包装类的变量。

考虑以下方法：

```java
public static int sumEven(List<Integer> li) {
    int sum = 0;
    for (Integer i: li)
        if (i % 2 == 0)
            sum += i;
        return sum;
}
```

由于余数（“%”）和一元加号（“+=”）运算符不适用于“Integer”对象，您可能会想知道为什么Java编译器编译该方法而不发出任何错误。编译器不会生成错误，因为它在运行时调用“intValue”方法将“Integer”转换为“int”：

```java
public static int sumEven(List<Integer> li) {
    int sum = 0;
    for (Integer i : li)
        if (i.intValue() % 2 == 0)
            sum += i.intValue();
        return sum;
}
```

将包装类型（“Integer”）的对象转换为其对应的原语（“int”）值称为取消装箱。当包装类的对象为：

- 作为参数传递给需要相应基元类型值的方法。
- 分配给相应基元类型的变量。

[`取消装箱`](https://docs.oracle.com/javase/tutorial/java/data/examples/Unboxing.java)示例显示了其工作原理：

```java
import java.util.ArrayList;
import java.util.List;

public class Unboxing {

    public static void main(String[] args) {
        Integer i = new Integer(-8);

        // 1. Unboxing through method invocation
        int absVal = absoluteValue(i);
        System.out.println("absolute value of " + i + " = " + absVal);

        List<Double> ld = new ArrayList<>();
        ld.add(3.1416);    // Π is autoboxed through method invocation.

        // 2. Unboxing through assignment
        double pi = ld.get(0);
        System.out.println("pi = " + pi);
    }

    public static int absoluteValue(int i) {
        return (i < 0) ? -i : i;
    }
}
```

程序打印以下内容：

```
absolute value of -8 = 8
pi = 3.1416
```

自动装箱和拆箱可以让开发人员编写更干净的代码，使其更易于阅读。下表列出了Java编译器用于自动装箱和取消装箱的原语类型及其对应的包装类：

| 元 type | 包装 class |
| ------- | ---------- |
| boolean | Boolean    |
| byte    | Byte       |
| char    | Character  |
| float   | Float      |
| int     | Integer    |
| long    | Long       |
| short   | Short      |
| double  | Double     |
