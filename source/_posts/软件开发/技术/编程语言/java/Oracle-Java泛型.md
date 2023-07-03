---
title: Oracle Java泛型
tags:
	- oracle
	- java
categories:
	- 技术
date: 2022-07-01 12:01:01
thumbnail:
---
# Oracle Java 泛型

> 本文章以jdk8为基础进行编写，如果想查看后续的版本可以前往jdk版本目录下查看。
>
> 翻译自：https://docs.oracle.com/javase/tutorial/java/generics/index.html

在任何非平凡的软件项目中，bug都是生活中的事实。仔细的规划、编程和测试可以帮助减少它们的普遍性，但不知何故，在某个地方，它们总会找到一种方法潜入您的代码。随着新特性的引入和代码库的规模和复杂性的增加，这一点变得尤为明显。

幸运的是，有些bug比其他bug更容易检测。例如，编译时错误可以在早期检测到；您可以使用编译器的错误消息来找出问题所在并立即修复它。然而，运行时错误可能会有更大的问题；它们并不总是立即出现，当它们出现时，可能是程序中的某个点与问题的实际原因相去甚远。

泛型通过在编译时检测更多的错误来增加代码的稳定性。完成本课程后，您可能需要继续学习[Generics](https://docs.oracle.com/javase/tutorial/extra/generics/index.html)吉拉德·布拉查的教程。

## 为什么使用泛型？

简而言之，泛型使*types*（类和接口）在定义类、接口和方法时成为参数。与方法声明中使用的更为熟悉的*形式参数*非常相似，类型参数为您提供了一种将相同的代码用于不同输入的方法。不同之处在于，形式参数的输入是值，而类型参数的输入则是类型。

使用泛型的代码比非泛型代码有很多好处：

- 编译时更强大的类型检查。
	Java编译器对泛型代码应用强类型检查，如果代码违反了类型安全性，就会发出错误。修复编译时错误比修复运行时错误更容易，因为运行时错误很难找到。

	

- 消除铸件。

	以下没有泛型的代码段需要强制转换：

	```java
	List list = new ArrayList();
	list.add("hello");
	String s = (String) list.get(0);
	```

	重新编写以使用泛型时，代码不需要强制转换：

	```java
	List<String> list = new ArrayList<String>();
	list.add("hello");
	String s = list.get(0);   // no cast
	```

- 使程序员能够实现通用算法。
	通过使用泛型，程序员可以实现通用算法，这些算法可以处理不同类型的集合，可以自定义，并且类型安全，更易于阅读。

## 泛型类型

*泛型类型*是在类型上参数化的泛型类或接口。将修改下面的“Box”类以演示该概念。

### 一个简单的Box类

首先检查对任何类型的对象进行操作的非泛型“Box”类。它只需要提供两个方法：“set”（将对象添加到框中）和“get”（检索对象）：

```java
public class Box {
    private Object object;

    public void set(Object object) { this.object = object; }
    public Object get() { return object; }
}
```

由于它的方法接受或返回一个“Object”，所以只要它不是原始类型之一，您就可以随意传入任何您想要的内容。在编译时，无法验证该类是如何使用的。代码的一部分可能将“Integer”放在框中，并期望从中获取“Integer’s”，而代码的另一部分可能错误地传入“String”，从而导致运行时错误。

### Box类的通用版本

*泛型类*的定义格式如下：

```java
class name<T1, T2, ..., Tn> { /* ... */ }
```

类型参数部分由尖括号（`<>`）分隔，位于类名之后。它指定*类型参数*（也称为*类型变量*）“T1”、“T2”、…和“Tn”。

要更新“Box”类以使用泛型，请通过将代码“`public class Box`”更改为“`public class-Box<T>`”来创建一个*泛型类型声明*。这引入了类型变量“T”，它可以在类中的任何地方使用。

通过此更改，“Box”类变为：

```java
/**
 * Generic version of the Box class.
 * @param <T> the type of the value being boxed
 */
public class Box<T> {
    // T stands for "Type"
    private T t;

    public void set(T t) { this.t = t; }
    public T get() { return t; }
}
```

如您所见，“Object”的所有出现都被“T”替换。类型变量可以是您指定的任何**非基元**类型：任何类类型、任何接口类型、任何数组类型，甚至其他类型变量。

同样的技术也可以用于创建通用接口。

### 类型参数命名惯例

按照惯例，类型参数名称是单个大写字母。这与变量[命名](https://docs.oracle.com/javase/tutorial/java/nutsandbolts/variables.html#naming)形成鲜明对比您已经知道的约定，并且有充分的理由：如果没有这种约定，很难区分类型变量和普通类或接口名称之间的区别。

最常用的类型参数名称是：

- E - Element (Java集合框架广泛使用)
- K - Key
- N - Number
- T - Type
- V - Value
- S,U,V etc. - 2nd, 3rd, 4th types

您将在整个JavaSEAPI和本课程的其余部分中看到这些名称。

### 调用和实例化泛型类型

要从代码中引用泛型“Box”类，必须执行*泛型类型调用*，该调用将“T”替换为一些具体值，例如“Integer”：

```java
Box<Integer> integerBox;
```

您可以将泛型类型调用视为与普通方法调用类似，但不是将参数传递给方法，而是将*类型参数*（在本例中为“Integer”）传递给“Box”类本身。

------

**类型参数和类型参数术语:** 许多开发人员可互换地使用术语“类型参数”和“类型自变量”，但这些术语并不相同。编码时，提供类型参数以创建参数化类型。因此，“`Foo<T>`”中的“T”是类型参数，而“`Foo＞String＞f`”中的‘String’是类型参数。本课在使用这些术语时遵循了这一定义。

------

与任何其他变量声明一样，此代码实际上不会创建新的“Box”对象。它简单地声明“integerBox”将包含对“Integer”的“Box”的引用，这就是读取“Box＜Integer＞”的方式。

泛型类型的调用通常称为*参数化类型*。

要实例化该类，请像往常一样使用“new”关键字，但在类名和括号之间放置“＜Integer＞”：

```java
Box<Integer> integerBox = new Box<Integer>();
```

### 钻石

在JavaSE7和更高版本中，只要编译器可以从上下文中确定或推断类型参数，就可以用一组空的类型参数（`<>`）替换调用泛型类构造函数所需的类型参数。这对尖括号<>，非正式地称为“钻石”。例如，可以使用以下语句创建“`Box<Integer>`”的实例：

```
Box<Integer> integerBox = new Box<>();
```

有关菱形符号和类型推断的更多信息，请参阅[type inference](https://docs.oracle.com/javase/tutorial/java/generics/genTypeInference.html).

### 多个类型参数

如前所述，泛型类可以有多个类型参数。例如，实现通用“Pair”接口的通用“OrderedPair”类：

```java
public interface Pair<K, V> {
    public K getKey();
    public V getValue();
}

public class OrderedPair<K, V> implements Pair<K, V> {

    private K key;
    private V value;

    public OrderedPair(K key, V value) {
	this.key = key;
	this.value = value;
    }

    public K getKey()	{ return key; }
    public V getValue() { return value; }
}
```

以下语句创建了“OrderedPair”类的两个实例：

```java
Pair<String, Integer> p1 = new OrderedPair<String, Integer>("Even", 8);
Pair<String, String>  p2 = new OrderedPair<String, String>("hello", "world");
```

代码“`new OrderedPair<String，Integer>`”将“K”实例化为“String”，将“V”实例化为一个“Integer”。因此，“OrderedPair”构造函数的参数类型分别为“String”和“Integer”。由于[自动装箱](https://docs.oracle.com/javase/tutorial/java/data/autoboxing.html)，向类传递“String”和“int”是有效的。

如[钻石](https://docs.oracle.com/javase/tutorial/java/generics/types.html#diamond)中所述，因为Java编译器可以从声明“`OrderedPair<String，Integer>`”中推断“K”和“V”类型，所以可以使用菱形符号缩短这些语句：

```java
OrderedPair<String, Integer> p1 = new OrderedPair<>("Even", 8);
OrderedPair<String, String>  p2 = new OrderedPair<>("hello", "world");
```

要创建泛型接口，请遵循与创建泛型类相同的约定。

### 参数化类型

也可以用参数化类型（即“`List<String>`”）替换类型参数（即“K”或“V”）。例如，使用“`OrderedPair<K，V>`”示例：

```java
OrderedPair<String, Box<Integer>> p = new OrderedPair<>("primes", new Box<Integer>(...));
```

### 原始类型

*原始类型*是没有任何类型参数的泛型类或接口的名称。例如，给定泛型“Box”类：

```java
public class Box<T> {
    public void set(T t) { /* ... */ }
    // ...
}
```

要创建参数化类型“`Box<T>`”，请为正式类型参数“T”提供一个实际类型参数：

```java
Box<Integer> intBox = new Box<>();
```

如果省略了实际类型参数，则创建“Box＜T＞”的原始类型：

```java
Box rawBox = new Box();
```

因此，“Box”是泛型类型“`Box<T>`”的原始类型。但是，非泛型类或接口类型*不是*原始类型。

原始类型出现在遗留代码中，因为在JDK5.0之前，许多API类（如“集合”类）都不是泛型的。为了向后兼容，允许将参数化类型分配给其原始类型：

```java
Box<String> stringBox = new Box<>();
Box rawBox = stringBox;               // OK
```

但如果将原始类型分配给参数化类型，则会收到警告：

```java
Box rawBox = new Box();           // rawBox is a raw type of Box<T>
Box<Integer> intBox = rawBox;     // warning: unchecked conversion
```

如果使用原始类型调用相应泛型类型中定义的泛型方法，也会收到警告：

```java
Box<String> stringBox = new Box<>();
Box rawBox = stringBox;
rawBox.set(8);  // warning: unchecked invocation to set(T)
```

警告显示，原始类型绕过泛型类型检查，将不安全代码的捕获延迟到运行时。因此，应避免使用原始类型。

[类型擦除](https://docs.oracle.com/javase/tutorial/java/generics/erasure.html)部分提供了有关Java编译器如何使用原始类型的更多信息。

#### 未选中的错误消息

如前所述, 当将遗留代码与通用代码混合时，您可能会遇到类似于以下内容的警告消息:

```
Note: Example.java uses unchecked or unsafe operations.
Note: Recompile with -Xlint:unchecked for details.
```

当使用对原始类型进行操作的旧API时，可能会发生这种情况，如下例所示：

```java
public class WarningDemo {
    public static void main(String[] args){
        Box<Integer> bi;
        bi = createBox();
    }

    static Box createBox(){
        return new Box();
    }
}
```

术语“未检查”意味着编译器没有足够的类型信息来执行确保类型安全所需的所有类型检查。默认情况下，“未检查”警告被禁用，尽管编译器会给出提示。要查看所有“未检查”警告，请使用“-Xlint:unchecked”重新编译。

使用“-Xlint:unchecked”重新编译上一个示例将显示以下附加信息：

```
WarningDemo.java:4: warning: [unchecked] unchecked conversion
found   : Box
required: Box<java.lang.Integer>
        bi = createBox();
                      ^
1 warning
```

要完全禁用未检查的警告，请使用“-Xlint:未检查”标志。`@SuppressWarnings（“unchecked”）`注释可抑制未选中的警告。如果您不熟悉“@SuppressWarnings”语法，请参阅[Annotations](https://docs.oracle.com/javase/tutorial/java/annotations/index.html).

## 泛型方法

*泛型方法*是引入自己类型参数的方法。这类似于声明泛型类型，但类型参数的范围仅限于声明它的方法。允许使用静态和非静态泛型方法以及泛型类构造函数。

泛型方法的语法包括一个类型参数列表，位于尖括号内，出现在方法的返回类型之前。对于静态泛型方法，类型参数部分必须出现在方法的返回类型之前。

“Util”类包含一个通用方法“compare”，用于比较两个“Pair”对象：

```java
public class Util {
    public static <K, V> boolean compare(Pair<K, V> p1, Pair<K, V> p2) {
        return p1.getKey().equals(p2.getKey()) &&
               p1.getValue().equals(p2.getValue());
    }
}

public class Pair<K, V> {

    private K key;
    private V value;

    public Pair(K key, V value) {
        this.key = key;
        this.value = value;
    }

    public void setKey(K key) { this.key = key; }
    public void setValue(V value) { this.value = value; }
    public K getKey()   { return key; }
    public V getValue() { return value; }
}
```

调用此方法的完整语法为：

```java
Pair<Integer, String> p1 = new Pair<>(1, "apple");
Pair<Integer, String> p2 = new Pair<>(2, "pear");
boolean same = Util.<Integer, String>compare(p1, p2);
```

已显式提供类型，如粗体所示。通常，这可以省略，编译器将推断所需的类型：

```java
Pair<Integer, String> p1 = new Pair<>(1, "apple");
Pair<Integer, String> p2 = new Pair<>(2, "pear");
boolean same = Util.compare(p1, p2);
```

此特性称为*类型推断*，允许您将泛型方法作为普通方法调用，而无需在尖括号之间指定类型。该主题将在下一节[类型推断](https://docs.oracle.com/javase/tutorial/java/generics/genTypeInference.html)中进一步讨论.

## 受限的类型参数

有时可能需要限制可以用作参数化类型中的类型参数的类型。例如，对数字进行操作的方法可能只希望接受“Number”或其子类的实例。这就是*有界类型参数*的用途。

要声明有界的类型参数，请列出类型参数的名称，后跟“extends”关键字，后跟其*上界*，在本例中为“Number”。注意，在此上下文中，“extends”在一般意义上是指“extends（扩展）”（如在类中）或“implements（实现）”（在接口中）。

```java
public class Box<T> {

    private T t;          

    public void set(T t) {
        this.t = t;
    }

    public T get() {
        return t;
    }

    public <U extends Number> void inspect(U u){
        System.out.println("T: " + t.getClass().getName());
        System.out.println("U: " + u.getClass().getName());
    }

    public static void main(String[] args) {
        Box<Integer> integerBox = new Box<Integer>();
        integerBox.set(new Integer(10));
        integerBox.inspect("some text"); // error: this is still String!
    }
}
```

通过修改泛型方法以包含此有界类型参数，编译现在将失败，因为我们对“inspect”的调用仍然包含“String”：

```
Box.java:21: <U>inspect(U) in Box<java.lang.Integer> cannot
  be applied to (java.lang.String)
                        integerBox.inspect("10");
                                  ^
1 error
```

除了限制可用于实例化泛型类型的类型之外，有界类型参数还允许您调用在边界中定义的方法：

```java
public class NaturalNumber<T extends Integer> {

    private T n;

    public NaturalNumber(T n)  { this.n = n; }

    public boolean isEven() {
        return n.intValue() % 2 == 0;
    }

    // ...
}
```

“isEven”方法通过“n”调用在“Integer”类中定义的“intValue”方法。

### 多个边界

前面的示例说明了使用具有单个边界的类型参数，但类型参数可以具有*多个边界*：

```
<T extends B1 & B2 & B3>
```

具有多个边界的类型变量是边界中列出的所有类型的子类型。如果其中一个边界是类，则必须首先指定它。例如：

```java
Class A { /* ... */ }
interface B { /* ... */ }
interface C { /* ... */ }

class D <T extends A & B & C> { /* ... */ }
```

如果未首先指定绑定“A”，则会出现编译时错误：

```java
class D <T extends B & A & C> { /* ... */ }  // compile-time error
```

### 泛型方法和有界类型参数

有界类型参数是实现通用算法的关键。考虑以下方法，该方法计算数组“T[]”中大于指定元素“elem”的元素数。

```java
public static <T> int countGreaterThan(T[] anArray, T elem) {
    int count = 0;
    for (T e : anArray)
        if (e > elem)  // compiler error
            ++count;
    return count;
}
```

该方法的实现很简单，但它不会编译，因为大于运算符（“`>`”）仅适用于基本类型，如“short”、“int”、“double”、“long”、”float“、”byte“和”char“。不能使用“>”运算符来比较对象。要解决此问题，请使用由“`Comparable<T>`”接口限定的类型参数：

```java
public interface Comparable<T> {
    public int compareTo(T o);
}
```

生成的代码将是：

```java
public static <T extends Comparable<T>> int countGreaterThan(T[] anArray, T elem) {
    int count = 0;
    for (T e : anArray)
        if (e.compareTo(elem) > 0)
            ++count;
    return count;
}
```

## 泛型、继承和子类型

正如您已经知道的，只要类型兼容，就可以将一种类型的对象分配给另一种类型。例如，您可以将“整型”分配给“对象”，因为“对象”是“整型”的超类型之一：

```java
Object someObject = new Object();
Integer someInteger = new Integer(10);
someObject = someInteger;   // OK
```

在面向对象的术语中，这被称为“是一种”关系。由于“Integer”*是“Object”的*类型，因此允许赋值。但“整数”也是“数字”的一种，因此以下代码也是有效的：

```java
public void someMethod(Number n) { /* ... */ }

someMethod(new Integer(10));   // OK
someMethod(new Double(10.1));   // OK
```

泛型也是如此。您可以执行泛型类型调用，将“Number”作为其类型参数传递，如果该参数与“Number”兼容，则允许随后调用“add”：

```java
Box<Number> box = new Box<Number>();
box.add(new Integer(10));   // OK
box.add(new Double(10.1));  // OK
```

现在考虑以下方法：

```java
public void boxTest(Box<Number> n) { /* ... */ }
```

它接受什么类型的参数？通过查看其签名，您可以看到它接受一个类型为“`Box<Number>`”的参数。但这意味着什么？是否允许按预期传入“`Box<Integer>`”或“`Box<Double>`”？答案是“否”，因为`Box<Integer>`和`Box<Double>`不是`Box<Number>`的子类型。

在使用泛型编程时，这是一个常见的误解，但它是一个需要学习的重要概念。

![diagram showing that Box<Integer> is not a subtype of Box<Number>](Oracle-Java泛型/generics-subtypeRelationship.gif)

尽管“Integer”是“Number”的子类型，但“`Box<Integer>`”不是“`Box<Number>`”的子型。

------

**Note:** 给定两个具体类型“A”和“B”（例如，“Number”和“Integer”），无论“A”与“B”是否相关，“`MyClass<A>`”与“`MyClass<B>`”都没有关系。“`MyClass<A>`”和“`MyClass<B>`”的共同父级是“Object”。

有关在类型参数相关时如何在两个泛型类之间创建类似子类型的关系的信息，请参阅[Wildcards and Subyping](https://docs.oracle.com/javase/tutorial/java/generics/subtyping.html).

------

### 泛型类和子类型

您可以通过扩展或实现泛型类或接口来对其进行子类型化。一个类或接口的类型参数与另一个类的类型参数之间的关系由“extends”和“implements”子句确定。

以“Collections”类为例，“`ArrayList<E>`”实现了“`List<E>`'”，而“`List<E>`”扩展了“`Collection<E>`”。因此，`ArrayList<String>`是`List<String>`的子类型，也是`Collection<String>`的子类型。只要不改变类型参数，类型之间的子类型关系就会保持不变。

![diagram showing a sample collections hierarchy: ArrayList<String> is a subtype of List<String>, which is a subtype of Collection<String>.](Oracle-Java泛型/generics-sampleHierarchy.gif)

示例“集合”层次结构

现在假设我们要定义自己的列表接口“PayloadList”，它将泛型类型“P”的可选值与每个元素相关联。其声明可能如下：

```java
interface PayloadList<E,P> extends List<E> {
  void setPayload(int index, P val);
  ...
}
```

“PayloadList”的以下参数化是“List＜String＞”的子类型：

- `PayloadList<String,String>`
- `PayloadList<String,Integer>`
- `PayloadList<String,Exception>`

![diagram showing an example PayLoadList hierarchy: PayloadList<String, String> is a subtype of List<String>, which is a subtype of Collection<String>. At the same level of PayloadList<String,String> is PayloadList<String, Integer> and PayloadList<String, Exceptions>.](Oracle-Java泛型/generics-payloadListHierarchy.gif)

示例“PayloadList”层次结构

## 类型推断

*类型推断*是Java编译器查看每个方法调用和相应声明的能力，以确定使调用适用的类型参数。推理算法确定参数的类型，以及分配或返回结果的类型（如果可用）。最后，推理算法试图找到适用于所有参数的“最具体”类型。

为了说明最后一点，在以下示例中，推断确定传递给“pick”方法的第二个参数的类型为“Serializable”：

```java
static <T> T pick(T a1, T a2) { return a2; }
Serializable s = pick("d", new ArrayList<String>());
```

### 类型推理和泛型方法

[通用方法](https://docs.oracle.com/javase/tutorial/java/generics/methods.html)向您介绍了类型推断，它使您能够像调用普通方法一样调用泛型方法，而无需在尖括号之间指定类型。考虑以下示例[`BoxDemo`](https://docs.oracle.com/javase/tutorial/java/generics/examples/BoxDemo.java)，这需要[`Box`](https://docs.oracle.com/javase/tutorial/java/generics/examples/Box.java)类别：

```java
public class BoxDemo {

  public static <U> void addBox(U u, 
      java.util.List<Box<U>> boxes) {
    Box<U> box = new Box<>();
    box.set(u);
    boxes.add(box);
  }

  public static <U> void outputBoxes(java.util.List<Box<U>> boxes) {
    int counter = 0;
    for (Box<U> box: boxes) {
      U boxContents = box.get();
      System.out.println("Box #" + counter + " contains [" +
             boxContents.toString() + "]");
      counter++;
    }
  }

  public static void main(String[] args) {
    java.util.ArrayList<Box<Integer>> listOfIntegerBoxes =
      new java.util.ArrayList<>();
    BoxDemo.<Integer>addBox(Integer.valueOf(10), listOfIntegerBoxes);
    BoxDemo.addBox(Integer.valueOf(20), listOfIntegerBoxes);
    BoxDemo.addBox(Integer.valueOf(30), listOfIntegerBoxes);
    BoxDemo.outputBoxes(listOfIntegerBoxes);
  }
}
```

以下是本示例的输出：

```
Box #0 contains [10]
Box #1 contains [20]
Box #2 contains [30]
```

泛型方法“addBox”定义了一个名为“U”的类型参数。通常，Java编译器可以推断泛型方法调用的类型参数。因此，在大多数情况下，您不必指定它们。例如，要调用泛型方法“addBox”，可以使用*类型见证*指定类型参数，如下所示：

```java
BoxDemo.<Integer>addBox(Integer.valueOf(10), listOfIntegerBoxes);
```

或者，如果省略类型见证，Java编译器会（从方法的参数）自动推断类型参数为“Integer”：

```java
BoxDemo.addBox(Integer.valueOf(20), listOfIntegerBoxes);
```

### 泛型类的类型推理和实例化

只要编译器可以从上下文中推断类型参数，就可以用一组空的类型参数（`<>`）替换调用泛型类构造函数所需的类型参数。这对尖括号非正式地称为[菱形](https://docs.oracle.com/javase/tutorial/java/generics/types.html#diamond).

例如，考虑以下变量声明：

```java
Map<String, List<String>> myMap = new HashMap<String, List<String>>();
```

您可以用一组空的类型参数（`<>`）替换构造函数的参数化类型：

```java
Map<String, List<String>> myMap = new HashMap<>();
```

注意，要在泛型类实例化期间利用类型推断，必须使用菱形。在以下示例中，编译器生成未检查的转换警告，因为“`HashMap()`”构造函数引用的是“HashMap”原始类型，而不是“`Map<String，List<String>>`”类型：

```java
Map<String, List<String>> myMap = new HashMap(); // unchecked conversion warning
```

### 泛型类和非泛型类的类型推理和泛型构造函数

注意，构造函数在泛型类和非泛型类中都可以是泛型的（换句话说，声明自己的形式类型参数）。考虑以下示例：

```java
class MyClass<X> {
  <T> MyClass(T t) {
    // ...
  }
}
```

考虑类“MyClass”的以下实例化：

```java
new MyClass<Integer>("")
```

此语句创建参数化类型“`MyClass<Integer>`”的实例；该语句显式指定泛型类“`MyClass<X>`”的形式类型参数“X”的类型“Integer”。请注意，此泛型类的构造函数包含一个形式类型参数“T”。编译器推断此泛型类的构造函数的形式类型参数“T”的类型“String”（因为此构造函数的实际参数是“String”对象）。

Java SE 7之前版本的编译器能够推断泛型构造函数的实际类型参数，类似于泛型方法。但是，如果您使用菱形（`<>`），Java SE 7和更高版本中的编译器可以推断正在实例化的泛型类的实际类型参数。考虑以下示例：

```java
MyClass<Integer> myObject = new MyClass<>("");
```

在此示例中，编译器推断泛型类“`MyClass<X>`”的形式类型参数“X”的类型“Integer”。它为该泛型类的构造函数的形式类型参数“T”推断类型“String”。

------

**Note:** 需要注意的是，推理算法仅使用调用参数、目标类型以及可能的明显预期返回类型来推断类型。推理算法不使用程序后期的结果。

------

### 目标类型

Java编译器利用目标类型来推断泛型方法调用的类型参数。表达式的*目标类型*是Java编译器期望的数据类型，具体取决于表达式出现的位置。考虑方法`Collections.emptyList`，声明如下：

```java
static <T> List<T> emptyList();
```

考虑以下赋值语句：

```java
List<String> listOne = Collections.emptyList();
```

此语句需要“`List<String>`”的实例；此数据类型是目标类型。由于方法“emptyList”返回类型为“`List<T>`”的值，编译器推断类型参数“T”必须是值“String”。这在Java SE 7和8中都适用。或者，您可以使用类型见证并指定“T”的值，如下所示：

```java
List<String> listOne = Collections.<String>emptyList();
```

然而，在这种情况下，这不是必要的。但在其他情况下，这是必要的。考虑以下方法：

```java
void processStringList(List<String> stringList) {
    // process stringList
}
```

假设您要使用空列表调用方法“processStringList”。在Java SE 7中，以下语句不会编译：

```
processStringList(Collections.emptyList());
```

The Java SE 7 compiler generates an error message similar to the following:

```
List<Object> cannot be converted to List<String>
```

编译器需要类型参数“T”的值，因此它以值“Object”开头。因此，调用“集合”。emptyList返回类为`List<Object>`的值，该值与方法`processStringList`不兼容。因此，在Java SE 7中，必须按如下方式指定类型参数的值：

```java
processStringList(Collections.<String>emptyList());
```

这在JavaSE8中不再是必要的。目标类型的概念已经扩展到包括方法参数，例如方法“processStringList”的参数。在这种情况下，“processStringList”需要类型为“`List<String>`”的参数。方法`Collections。emptyList`返回值`List<T>`，因此使用目标类型`List<String>`，编译器推断类型参数`T`的值为`String`。因此，在Java SE 8中，编译以下语句：

```java
processStringList(Collections.emptyList());
```

See [Target Typing](https://docs.oracle.com/javase/tutorial/java/javaOO/lambdaexpressions.html#target-typing) in [Lambda Expressions](https://docs.oracle.com/javase/tutorial/java/javaOO/lambdaexpressions.html) for more information.

## 通配符

在通用代码中，问号（？），称为通配符的通配符表示未知类型。通配符可用于多种情况：作为参数、字段或局部变量的类型；有时作为返回类型（尽管更具体一些是更好的编程实践）。通配符永远不会用作泛型方法调用、泛型类实例创建或超类型的类型参数。

以下部分将更详细地讨论通配符，包括上限通配符、下限通配符和通配符捕获。

### 上限通配符

可以使用上限通配符放宽对变量的限制。例如，假设您要编写一个方法，该方法适用于`List<Integer>`、`List<Double>`、和`List<Number>`；可以通过使用上限通配符来实现这一点。

要声明上限通配符，请使用通配符（“?”），后跟“extends”关键字，后跟其*上限*。注意，在此上下文中，“extends”在一般意义上是指“extends（扩展）”（如在类中）或“implements（实现）”（在接口中）。

要编写适用于“Number”列表和“Number”子类型（如“Integer”、“Double”和“Float”）的方法，需要指定“`List<？extends Number>`。术语“`List<Number>`”比“`List<? extends Number>`，因为前者仅匹配类型为'Number'的列表，而后者匹配类型为`Number`或其任何子类的列表。

考虑以下“process”方法：

```
public static void process(List<? extends Foo> list) { /* ... */ }
```

上限通配符`<？extends Foo>`，其中`Foo`是任何类型，匹配`Foo`和`Foo`的任何子类型。“process”方法可以访问类型为“Foo”的列表元素：

```java
public static void process(List<? extends Foo> list) {
    for (Foo elem : list) {
        // ...
    }
}
```

在“foreach”子句中，“elem”变量迭代列表中的每个元素。“Foo”类中定义的任何方法现在都可以在“elem”上使用。

“sumOfList”方法返回列表中数字的总和：

```java
public static double sumOfList(List<? extends Number> list) {
    double s = 0.0;
    for (Number n : list)
        s += n.doubleValue();
    return s;
}
```

以下代码使用“Integer”对象列表打印“sum=6.0”：

```java
List<Integer> li = Arrays.asList(1, 2, 3);
System.out.println("sum = " + sumOfList(li));
```

“Double”值列表可以使用相同的“sumOfList”方法。以下代码显示“sum=7.0”：

```java
List<Double> ld = Arrays.asList(1.2, 2.3, 3.5);
System.out.println("sum = " + sumOfList(ld));
```

### 无边界通配符

使用通配符（“？”）指定无界通配符类型, 例如，“`List<?>`”。这称为*未知类型列表*。在两种情况下，无界通配符是一种有用的方法：

- 如果您正在编写可以使用“Object”类中提供的功能实现的方法。
- 当代码在泛型类中使用不依赖于类型参数的方法时。例如，`List.size`或`List.clear`。事实上，“`Class<?>`”因为“`Class<T>`”中的大多数方法都不依赖于“T”。

考虑以下方法“printList”：

```java
public static void printList(List<Object> list) {
    for (Object elem : list)
        System.out.println(elem + " ");
    System.out.println();
}
```

“printList”的目标是打印任何类型的列表，但它无法实现这一目标——它只打印“Object”实例的列表；它无法打印“`List<Integer>`”、“`List<String>`”、‘`List<Double>`”等，因为它们不是“`List<Object>`”的子类型。要编写通用的“printList”方法，请使用“`List<?>`”：

```java
public static void printList(List<?> list) {
    for (Object elem: list)
        System.out.print(elem + " ");
    System.out.println();
}
```

因为对于任何具体类型“A”，“`List<A>`”是“`List<?>`”的子类型，您可以使用“printList”打印任何类型的列表：

```java
List<Integer> li = Arrays.asList(1, 2, 3);
List<String>  ls = Arrays.asList("one", "two", "three");
printList(li);
printList(ls);
```

------

**Note:** [`Arrays.asList`](https://docs.oracle.com/javase/8/docs/api/java/util/Arrays.html#asList-T、 ..-)方法在本课程的示例中使用。此静态工厂方法转换指定的数组并返回固定大小的列表。

------

需要注意的是，`List<Object>`和`List<?>`不一样。您可以将“Object”或“Object”的任何子类型插入到“`List<Object>`”中。但只能将“null”插入到“`List<?>`”中。[通配符使用指南](https://docs.oracle.com/javase/tutorial/java/generics/wildcardGuidelines.html)部分提供了有关如何确定在给定情况下应使用哪种通配符（如果有的话）的更多信息。

### 下限通配符

[上限通配符](https://docs.oracle.com/javase/tutorial/java/generics/upperBounded.html)部分显示了一个上界通配符将未知类型限制为特定类型或该类型的子类型，并使用“extends”关键字表示。 以类似的方式，*下限*通配符将未知类型限制为特定类型或该类型的*超级类型*。

下限通配符使用通配符（“？”）表示，后跟“super”关键字，后跟其*下限*： `<? super A>`.。

------

**Note:** 可以为通配符指定上限，也可以指定下限，但不能同时指定两者。

------

假设您要编写一个将“Integer”对象放入列表的方法。为了最大限度地提高灵活性，您希望该方法可以处理“`List<Integer>`”、“`List<Number>`”和“`List<Object>`”—任何可以保存“Integer”值的对象。

要编写适用于“整型”列表和“整型”超类型（如“整型”、“数字”和“对象”）的方法，需要指定`List<? super Integer>`。术语`List<Integer>`比`List<？super Integer>`，因为前者仅匹配“Integer”类型的列表，而后者匹配“Integer'”超类型的任何类型的列表。

以下代码将数字1到10添加到列表末尾：

```java
public static void addNumbers(List<? super Integer> list) {
    for (int i = 1; i <= 10; i++) {
        list.add(i);
    }
}
```

[通配符使用指南](https://docs.oracle.com/javase/tutorial/java/generics/wildcardGuidelines.html)本节提供了何时使用上限通配符和何时使用下限通配符的指导。

### 通配符和子类型

如[泛型、继承和子类型](https://docs.oracle.com/javase/tutorial/java/generics/inheritance.html)中所述，泛型类或接口并不相关，因为它们的类型之间存在关系。 但是，您可以使用通配符来创建泛型类或接口之间的关系。

给定以下两个常规（非泛型）类：

```java
class A { /* ... */ }
class B extends A { /* ... */ }
```

编写以下代码是合理的：

```java
B b = new B();
A a = b;
```

此示例显示，常规类的继承遵循子类型化规则：如果B扩展了a，则类B是类a的子类型。此规则不适用于泛型类型：

```java
List<B> lb = new ArrayList<>();
List<A> la = lb;   // compile-time error
```

假定“整数”是“数字”的子类型，那么“`List<Number>`”和“`List<Integer>`”之间的关系是什么？

![diagram showing that the common parent of List<Number> and List<Integer> is the list of unknown type](Oracle-Java泛型/generics-listParent.gif)

常见的父项是“`List<?>`”。

虽然“整数”是“数字”的子类型，但“`List<Integer>`”不是“`List<Number>`”的子型，事实上，这两种类型并不相关。“`List<Number>`”和“`List<Integer>`”的共同父级是“`List<?>`”。

为了在这些类之间创建关系，以便代码可以通过“`List<Integer>`”元素访问“Number”方法，请使用上限通配符：

```java
List<? extends Integer> intList = new ArrayList<>();
List<? extends Number>  numList = intList;  // OK. List<? extends Integer> is a subtype of List<? extends Number>
```

因为“Integer”是“Number”的子类型，而“numList”是“Number”对象的列表，所以现在在“intList”（“整型”对象列表）和“numList”之间存在关系。下图显示了使用上限和下限通配符声明的几个“List”类之间的关系。

![diagram showing that List<Integer> is a subtype of both List<? extends Integer> and List<?super Integer>. List<? extends Integer> is a subtype of List<? extends Number> which is a subtype of List<?>. List<Number> is a subtype of List<? super Number> and List>? extends Number>. List<? super Number> is a subtype of List<? super Integer> which is a subtype of List<?>.](Oracle-Java泛型/generics-wildcardSubtyping.gif)

多个泛型“List”类声明的层次结构。

[通配符使用指南](https://docs.oracle.com/javase/tutorial/java/generics/wildcardGuidelines.html)部分提供了有关使用上限和下限通配符的影响的更多信息。

### 通配符捕获和帮助程序方法

在某些情况下，编译器推断通配符的类型。例如，列表可以定义为“`list<?>`”但是，当计算表达式时，编译器从代码中推断出特定类型。这种情况称为*通配符捕获*。

在大多数情况下，您不必担心通配符捕获，除非看到包含短语“captureof”的错误消息。

[`WildcardError`](https://docs.oracle.com/javase/tutorial/java/generics/examples/WildcardError.java)示例在编译时生成捕获错误：

```java
import java.util.List;

public class WildcardError {

    void foo(List<?> i) {
        i.set(0, i.get(0));
    }
}
```

在此示例中，编译器将“i”输入参数处理为“Object”类型。当“foo”方法调用[List.set（int，E）](https://docs.oracle.com/javase/8/docs/api/java/util/List.html#set-int-E-)时，编译器无法确认插入列表中的对象的类型，并产生错误。当发生这种类型的错误时，通常意味着编译器认为您为变量分配了错误的类型。泛型之所以被添加到Java语言中，是为了在编译时加强类型安全。

“WildcardError”示例在由Oracle的JDK 7“javac”实现编译时生成以下错误：

```
WildcardError.java:6: error: method set in interface List<E> cannot be applied to given types;
    i.set(0, i.get(0));
     ^
  required: int,CAP#1
  found: int,Object
  reason: actual argument Object cannot be converted to CAP#1 by method invocation conversion
  where E is a type-variable:
    E extends Object declared in interface List
  where CAP#1 is a fresh type-variable:
    CAP#1 extends Object from capture of ?
1 error
```

在本例中，代码试图执行安全操作，因此如何解决编译器错误？您可以通过编写一个捕获通配符的*private helper方法*来解决这个问题。在这种情况下，您可以通过创建私有助手方法“fooHelper”来解决这个问题，如[`WildcardFixed`](https://docs.oracle.com/javase/tutorial/java/generics/examples/WildcardFixed.java)所示:

```java
public class WildcardFixed {

    void foo(List<?> i) {
        fooHelper(i);
    }


    // Helper method created so that the wildcard can be captured
    // through type inference.
    private <T> void fooHelper(List<T> l) {
        l.set(0, l.get(0));
    }

}
```

由于helper方法，编译器在调用中使用推断来确定“T”是捕获变量“CAP#1”。该示例现在已成功编译。

按照惯例，助手方法通常命名为`*originalMethodName*helper`。

现在考虑一个更复杂的示例[`WildcardErrorBad`](https://docs.oracle.com/javase/tutorial/java/generics/examples/WildcardErrorBad.java):

```java
import java.util.List;

public class WildcardErrorBad {

    void swapFirst(List<? extends Number> l1, List<? extends Number> l2) {
      Number temp = l1.get(0);
      l1.set(0, l2.get(0)); // expected a CAP#1 extends Number,
                            // got a CAP#2 extends Number;
                            // same bound, but different types
      l2.set(0, temp);	    // expected a CAP#1 extends Number,
                            // got a Number
    }
}
```

在此示例中，代码正在尝试不安全的操作。例如，考虑“swapFirst”方法的以下调用：

```java
List<Integer> li = Arrays.asList(1, 2, 3);
List<Double>  ld = Arrays.asList(10.10, 20.20, 30.30);
swapFirst(li, ld);
```

而`List<Integer>`和`List<Double>`都满足`List<？extendsNumber>`，则从“Integer”值列表中获取项目并尝试将其放入“Double”值列表显然是不正确的。

使用Oracle的JDK`javac`编译器编译代码会产生以下错误：

```
WildcardErrorBad.java:7: error: method set in interface List<E> cannot be applied to given types;
      l1.set(0, l2.get(0)); // expected a CAP#1 extends Number,
        ^
  required: int,CAP#1
  found: int,Number
  reason: actual argument Number cannot be converted to CAP#1 by method invocation conversion
  where E is a type-variable:
    E extends Object declared in interface List
  where CAP#1 is a fresh type-variable:
    CAP#1 extends Number from capture of ? extends Number
WildcardErrorBad.java:10: error: method set in interface List<E> cannot be applied to given types;
      l2.set(0, temp);      // expected a CAP#1 extends Number,
        ^
  required: int,CAP#1
  found: int,Number
  reason: actual argument Number cannot be converted to CAP#1 by method invocation conversion
  where E is a type-variable:
    E extends Object declared in interface List
  where CAP#1 is a fresh type-variable:
    CAP#1 extends Number from capture of ? extends Number
WildcardErrorBad.java:15: error: method set in interface List<E> cannot be applied to given types;
        i.set(0, i.get(0));
         ^
  required: int,CAP#1
  found: int,Object
  reason: actual argument Object cannot be converted to CAP#1 by method invocation conversion
  where E is a type-variable:
    E extends Object declared in interface List
  where CAP#1 is a fresh type-variable:
    CAP#1 extends Object from capture of ?
3 errors
```

没有助手方法可以解决这个问题，因为代码根本上是错误的：从“Integer”值列表中获取一个项并尝试将其放入“Double”值列表显然是不正确的。

### 通配符使用指南

学习使用泛型编程时，一个更令人困惑的方面是确定何时使用上限通配符，何时使用下限通配符。本页提供了设计代码时应遵循的一些准则。

出于本讨论的目的，将变量视为提供以下两种功能之一是有帮助的：

- **“In”变量**

	“in”变量向代码提供数据。设想一个具有两个参数的copy方法：`copy（src，dest）`。“src”参数提供要复制的数据，因此它是“in”参数。

- **“out”变量**

	“out”变量保存其他地方使用的数据。在复制示例“copy（src，dest）”中，“dest”参数接受数据，因此它是“out”参数。

当然，一些变量同时用于“输入”和“输出”目的——指南中也讨论了这种情况。

在决定是否使用通配符以及合适的通配符类型时，可以使用“in”和“out”原则。以下列表提供了应遵循的准则：

------

**通配符指南:**

- “in”变量用上限通配符定义，使用“extends”关键字。
- “out”变量用下限通配符定义，使用super关键字。
- 如果可以使用“Object”类中定义的方法访问“In”变量，使用无界通配符。
- 如果代码需要同时作为“In”和“out”变量访问变量，请不要使用通配符。

------

这些准则不适用于方法的返回类型。应避免使用通配符作为返回类型，因为这会迫使程序员使用代码来处理通配符。

由`list<？extends …>`可以非正式地认为是只读的，但这并不是严格的保证。假设您有以下两个类：

```java
class NaturalNumber {

    private int i;

    public NaturalNumber(int i) { this.i = i; }
    // ...
}

class EvenNumber extends NaturalNumber {

    public EvenNumber(int i) { super(i); }
    // ...
}
```

Consider the following code:

```java
List<EvenNumber> le = new ArrayList<>();
List<? extends NaturalNumber> ln = le;
ln.add(new NaturalNumber(35));  // compile-time error
```

因为`List<EvenNumber>`是`List<？extends NaturalNumber>`，您可以将`le`分配给`ln`。但不能使用“ln”将自然数添加到偶数列表中。列表中可能有以下操作：

- 您可以添加“null”。
- 您可以调用“clear”。
- 您可以获取迭代器并调用“remove”。
- 您可以捕获通配符并编写从列表中读取的元素。

您可以看到由`list<？extends NaturalNumber>`在严格意义上不是只读的，但您可能会这样想，因为您无法存储新元素或更改列表中的现有元素。

## 类型擦除

在 Java 语言中引入了泛型，以便在编译时提供更严格的类型检查并支持泛型。为了实现泛型，Java编译器将类型擦除应用于：

- 用泛型类型的边界替换泛型类型中的所有类型参数，如果类型参数是无界的，则替换为“ Object”。因此，生成的字节码只包含普通的类、接口和方法。
- 必要时插入类型强制转换以保证类型安全。
- 生成桥接方法以保留扩展泛型类型中的多态性。

类型擦除确保不会为参数化类型创建新类； 因此，泛型不会产生运行时开销。

### 通用类型的擦除

在类型擦除过程中，Java 编译器会擦除所有类型参数，如果类型参数是有界的，则用第一个边界替换每个参数，如果类型参数是无界的，则用“Object”替换。

考虑以下表示单向链表中节点的泛型类：

```java
public class Node<T> {

    private T data;
    private Node<T> next;

    public Node(T data, Node<T> next) {
        this.data = data;
        this.next = next;
    }

    public T getData() { return data; }
    // ...
}
```

因为类型参数 `T` 是无界的，所以 Java 编译器将其替换为 `Object`：

```java
public class Node {

    private Object data;
    private Node next;

    public Node(Object data, Node next) {
        this.data = data;
        this.next = next;
    }

    public Object getData() { return data; }
    // ...
}
```

在以下示例中，通用 `Node` 类使用有界类型参数：

```java
public class Node<T extends Comparable<T>> {

    private T data;
    private Node<T> next;

    public Node(T data, Node<T> next) {
        this.data = data;
        this.next = next;
    }

    public T getData() { return data; }
    // ...
}
```

Java 编译器将有界类型参数“T”替换为第一个绑定类“Comparable”：

```java
public class Node {

    private Comparable data;
    private Node next;

    public Node(Comparable data, Node next) {
        this.data = data;
        this.next = next;
    }

    public Comparable getData() { return data; }
    // ...
}
```

### 通用方法的擦除

Java 编译器还会擦除泛型方法参数中的类型参数。 考虑以下通用方法：

```java
// Counts the number of occurrences of elem in anArray.
//
public static <T> int count(T[] anArray, T elem) {
    int cnt = 0;
    for (T e : anArray)
        if (e.equals(elem))
            ++cnt;
        return cnt;
}
```

因为 `T` 是无界的，所以 Java 编译器将其替换为 `Object`：

```java
public static int count(Object[] anArray, Object elem) {
    int cnt = 0;
    for (Object e : anArray)
        if (e.equals(elem))
            ++cnt;
        return cnt;
}
```

假设定义了以下类：

```java
class Shape { /* ... */ }
class Circle extends Shape { /* ... */ }
class Rectangle extends Shape { /* ... */ }
```

您可以编写一个通用方法来绘制不同的形状：

```java
public static <T extends Shape> void draw(T shape) { /* ... */ }
```

Java 编译器将 `T` 替换为 `Shape`：

```java
public static void draw(Shape shape) { /* ... */ }
```

### 类型擦除和桥接方法的影响

有时类型擦除会导致您可能没有预料到的情况。 以下示例显示了这是如何发生的。 以下示例显示编译器有时如何创建一个合成方法，称为桥接方法，作为类型擦除过程的一部分。

给定以下两个类：

```java
public class Node<T> {

    public T data;

    public Node(T data) { this.data = data; }

    public void setData(T data) {
        System.out.println("Node.setData");
        this.data = data;
    }
}

public class MyNode extends Node<Integer> {
    public MyNode(Integer data) { super(data); }

    public void setData(Integer data) {
        System.out.println("MyNode.setData");
        super.setData(data);
    }
}
```

考虑以下代码：

```java
MyNode mn = new MyNode(5);
Node n = mn;            // A raw type - compiler throws an unchecked warning
n.setData("Hello");     // Causes a ClassCastException to be thrown.
Integer x = mn.data;    
```

类型擦除后，这段代码变成：

```java
MyNode mn = new MyNode(5);
Node n = mn;            // A raw type - compiler throws an unchecked warning
                        // Note: This statement could instead be the following:
                        //     Node n = (Node)mn;
                        // However, the compiler doesn't generate a cast because
                        // it isn't required.
n.setData("Hello");     // Causes a ClassCastException to be thrown.
Integer x = (Integer)mn.data; 
```

下一节解释为什么在 `n.setData("Hello");` 语句中抛出 `ClassCastException`。

### 桥接方法

在编译扩展参数化类或实现参数化接口的类或接口时，编译器可能需要创建一个合成方法，称为桥接方法，作为类型擦除过程的一部分。 您通常不需要担心桥接方法，但如果一个出现在堆栈跟踪中，您可能会感到困惑。

类型擦除后，`Node` 和 `MyNode` 类变为：

```java
public class Node {

    public Object data;

    public Node(Object data) { this.data = data; }

    public void setData(Object data) {
        System.out.println("Node.setData");
        this.data = data;
    }
}

public class MyNode extends Node {

    public MyNode(Integer data) { super(data); }

    public void setData(Integer data) {
        System.out.println("MyNode.setData");
        super.setData(data);
    }
}
```

类型擦除后，方法签名不匹配；  `Node.setData(T)` 方法变为 `Node.setData(Object)`。 因此，“MyNode.setData(Integer)”方法不会覆盖“Node.setData(Object)”方法。

为了解决这个问题并在类型擦除后保留泛型类型的[多态性](https://docs.oracle.com/javase/tutorial/java/IandI/polymorphism.html)，Java编译器生成了一个桥接方法来确保 子类型按预期工作。

对于 MyNode 类，编译器为 setData 生成以下桥接方法：

```java
class MyNode extends Node {

    // Bridge method generated by the compiler
    //
    public void setData(Object data) {
        setData((Integer) data);
    }

    public void setData(Integer data) {
        System.out.println("MyNode.setData");
        super.setData(data);
    }

    // ...
}
```

桥接方法 MyNode.setData(object) 委托给原始的 MyNode.setData(Integer) 方法。 结果，`n.setData("Hello");` 语句调用方法 `MyNode.setData(Object)`，并抛出 `ClassCastException`，因为 `"Hello"` 无法转换为 `Integer  `。

### 不可具体化的类型

[类型擦除](https://docs.oracle.com/javase/tutorial/java/generics/erasure.html) 部分讨论了编译器删除与类型参数和类型参数相关的信息的过程。 类型擦除会产生与可变参数（也称为 *varargs* ）方法相关的后果，这些方法的可变参数形式参数具有不可具体化的类型。 请参阅[将信息传递给方法或构造函数](https://docs.oracle.com/javase/tutorial/java/javaOO/arguments.html#varargs)部分[任意参数](https://docs.oracle.com/javase/tutorial/java/javaOO/arguments.html#varargs)了解有关可变参数方法的更多信息。

#### 不可具体化的类型

*可具体化*类型是其类型信息在运行时完全可用的类型。 这包括原语、非泛型类型、原始类型和未绑定通配符的调用。

*Non-reifiable types* 是在编译时通过类型擦除删除信息的类型——调用未定义为无限通配符的泛型类型。 不可具体化的类型在运行时不会提供所有可用信息。 不可具体化类型的示例是 `List<String>` 和 `List<Number>`；  JVM 无法在运行时区分这些类型。 如 [Restrictions on Generics](https://docs.oracle.com/javase/tutorial/java/generics/restrictions.html) 所示，在某些情况下不能使用不可具体化的类型：在 `instanceof` 中 例如，表达式，或作为数组中的元素。

#### 堆污染

*堆污染*发生在参数化类型的变量引用不属于该参数化类型的对象时。 如果程序执行了一些在编译时产生未经检查的警告的操作，就会发生这种情况。 如果在编译时（在编译时类型检查规则的限制内）或在运行时，涉及参数化类型（例如，强制转换或方法调用）的操作的正确性，则会生成 *unchecked warning* 无法验证。 例如，堆污染发生在混合原始类型和参数化类型时，或执行未经检查的转换时。

在正常情况下，当同时编译所有代码时，编译器会发出未经检查的警告，提醒您注意潜在的堆污染。 如果您单独编译部分代码，则很难检测到堆污染的潜在风险。 如果您确保您的代码在没有警告的情况下编译，那么就不会发生堆污染。

#### 具有不可具体化形式参数的 Varargs 方法的潜在漏洞

包含可变参数输入参数的通用方法会导致堆污染。

考虑以下 ArrayBuilder 类：

```java
public class ArrayBuilder {

  public static <T> void addToList (List<T> listArg, T... elements) {
    for (T x : elements) {
      listArg.add(x);
    }
  }

  public static void faultyMethod(List<String>... l) {
    Object[] objectArray = l;     // Valid
    objectArray[0] = Arrays.asList(42);
    String s = l[0].get(0);       // ClassCastException thrown here
  }

}
```

以下示例“HeapPollutionExample”使用“ArrayBuiler”类：

```java
public class HeapPollutionExample {

  public static void main(String[] args) {

    List<String> stringListA = new ArrayList<String>();
    List<String> stringListB = new ArrayList<String>();

    ArrayBuilder.addToList(stringListA, "Seven", "Eight", "Nine");
    ArrayBuilder.addToList(stringListB, "Ten", "Eleven", "Twelve");
    List<List<String>> listOfStringLists =
      new ArrayList<List<String>>();
    ArrayBuilder.addToList(listOfStringLists,
      stringListA, stringListB);

    ArrayBuilder.faultyMethod(Arrays.asList("Hello!"), Arrays.asList("World!"));
  }
}
```

编译时，“ArrayBuilder.addToList”方法的定义会产生以下警告：

```
warning: [varargs] Possible heap pollution from parameterized vararg type T
```

当编译器遇到可变参数方法时，它会将可变参数形式参数转换为数组。 但是，Java 编程语言不允许创建参数化类型的数组。在 ArrayBuilder.addToList 方法中，编译器将可变参数形式参数 T... elements 转换为形式参数 T[] elements，一个数组。 但是，由于类型擦除，编译器将可变参数形式参数转换为 Object[] elements。 因此，存在堆污染的可能性。

以下语句将可变参数形式参数 `l` 分配给 `Object` 数组 `objectArgs`：

```
Object[] objectArray = l;
```

该语句可能会引入堆污染。 与可变参数形式参数 l 的参数化类型匹配的值可以分配给变量 objectArray，因此可以分配给 l。 但是，编译器不会在此语句中生成未经检查的警告。 编译器在将可变参数形式参数 `List<String>... l` 转换为形式参数 List[] l 时已经生成警告。 此声明有效； 变量 `l` 的类型为 `List[]`，它是 `Object[]` 的子类型。

因此，如果您将任何类型的“List”对象分配给“objectArray”数组的任何数组组件，编译器不会发出警告或错误，如下语句所示：

```java
objectArray[0] = Arrays.asList(42);
```

此语句将 objectArray 数组的第一个数组组件分配给一个包含一个 Integer 类型对象的 List 对象。

假设您使用以下语句调用“ArrayBuilder.faultyMethod”：

```java
ArrayBuilder.faultyMethod(Arrays.asList("Hello!"), Arrays.asList("World!"));
```

在运行时，JVM 在以下语句中抛出 ClassCastException：

```java
// ClassCastException thrown here
String s = l[0].get(0);
```

存储在变量“l”的第一个数组组件中的对象具有“`List<Integer>`”类型，但此语句需要一个“`List<String>`”类型的对象。

#### 使用不可具体化的形式参数防止 Varargs 方法发出警告

如果您声明一个具有参数化类型参数的可变参数方法，并且您确保该方法的主体不会因对可变参数形式参数的不当处理而抛出“ClassCastException”或其他类似异常，则可以防止警告 编译器通过将以下注释添加到静态和非构造方法声明来为这些类型的可变参数方法生成：

```java
@SafeVarargs
```

`@SafeVarargs` 注释是方法契约的文档化部分； 此注释断言该方法的实现不会不正确地处理可变参数形式参数。

也可以通过在方法声明中添加以下内容来抑制此类警告，尽管不太理想：

```java
@SuppressWarnings({"unchecked", "varargs"})
```

但是，此方法不会抑制从方法的调用站点生成的警告。 如果您不熟悉“@SuppressWarnings”语法，请参阅[注释](https://docs.oracle.com/javase/tutorial/java/annotations/index.html)。

## 泛型的限制

要有效地使用 Java 泛型，您必须考虑以下限制：

- [无法使用原始类型实例化泛型类型](https://docs.oracle.com/javase/tutorial/java/generics/restrictions.html#instantiate)
- [无法创建类型参数的实例](https://docs.oracle.com/javase/tutorial/java/generics/restrictions.html#createObjects)
- [不能声明类型为类型参数的静态字段](https://docs.oracle.com/javase/tutorial/java/generics/restrictions.html#createStatic)
- [不能对参数化类型使用 Casts 或 instanceof](https://docs.oracle.com/javase/tutorial/java/generics/restrictions.html#cannotCast)
- [无法创建参数化类型的数组](https://docs.oracle.com/javase/tutorial/java/generics/restrictions.html#createArrays)
- [无法创建、捕获或抛出参数化类型的对象](https://docs.oracle.com/javase/tutorial/java/generics/restrictions.html#cannotCatch)
- [无法重载每个重载的形式参数类型擦除为相同原始类型的方法](https://docs.oracle.com/javase/tutorial/java/generics/restrictions.html#cannotOverload)

### 无法使用原始类型实例化泛型类型

无法使用原始类型实例化泛型类型

```java
class Pair<K, V> {

    private K key;
    private V value;

    public Pair(K key, V value) {
        this.key = key;
        this.value = value;
    }

    // ...
}
```

创建 Pair 对象时，不能用基本类型替换类型参数 K 或 V：

```java
Pair<int, char> p = new Pair<>(8, 'a');  // compile-time error
```

您只能用非基本类型替换类型参数 K 和 V：

```java
Pair<Integer, Character> p = new Pair<>(8, 'a');
```

请注意，Java 编译器将“8”自动装箱为“Integer.valueOf(8)”，将“a”自动装箱为“Character('a')”：

```java
Pair<Integer, Character> p = new Pair<>(Integer.valueOf(8), new Character('a'));
```

有关自动装箱的更多信息，请参阅[数字和字符串](https://docs.oracle.com/javase/tutorial/java/data/index.html)课程。

### 无法创建类型参数的实例

您不能创建类型参数的实例。 例如，以下代码会导致编译时错误：

```java
public static <E> void append(List<E> list) {
    E elem = new E();  // compile-time error
    list.add(elem);
}
```

作为解决方法，您可以通过反射创建类型参数的对象：

```java
public static <E> void append(List<E> list, Class<E> cls) throws Exception {
    E elem = cls.newInstance();   // OK
    list.add(elem);
}
```

您可以按如下方式调用 `append` 方法：

```java
List<String> ls = new ArrayList<>();
append(ls, String.class);
```

### 不能声明类型为类型参数的静态字段

类的静态字段是类的所有非静态对象共享的类级变量。 因此，类型参数的静态字段是不允许的。 考虑以下课程：

```java
public class MobileDevice<T> {
    private static T os;

    // ...
}
```

如果允许类型参数的静态字段，那么下面的代码就会混淆：

```java
MobileDevice<Smartphone> phone = new MobileDevice<>();
MobileDevice<Pager> pager = new MobileDevice<>();
MobileDevice<TabletPC> pc = new MobileDevice<>();
```

因为静态字段`os` 被`phone`、`pager` 和`pc` 共享，所以`os` 的实际类型是什么？ 不能同时是`Smartphone`、`Pager`、`TabletPC`。 因此，您不能创建类型参数的静态字段。

### 不能对参数化类型使用 Casts 或 `instanceof`

因为 Java 编译器会擦除泛型代码中的所有类型参数，所以您无法验证在运行时使用了泛型类型的哪个参数化类型：

```java
public static <E> void rtti(List<E> list) {
    if (list instanceof ArrayList<Integer>) {  // compile-time error
        // ...
    }
}
```

传递给 rtti 方法的参数化类型集是：

```java
S = { ArrayList<Integer>, ArrayList<String> LinkedList<Character>, ... }
```

运行时不跟踪类型参数，因此它无法区分 `ArrayList<Integer>` 和 `ArrayList<String>` 之间的区别。 您最多可以使用无界通配符来验证列表是否为“ArrayList”：

```java
public static void rtti(List<?> list) {
    if (list instanceof ArrayList<?>) {  // OK; instanceof requires a reifiable type
        // ...
    }
}
```

通常，您不能转换为参数化类型，除非它由无限通配符参数化。 例如：

```java
List<Integer> li = new ArrayList<>();
List<Number>  ln = (List<Number>) li;  // compile-time error
```

但是，在某些情况下，编译器知道类型参数始终有效并允许进行强制转换。 例如：

```java
List<String> l1 = ...;
ArrayList<String> l2 = (ArrayList<String>)l1;  // OK
```

### 无法创建参数化类型的数组

不能创建参数化类型的数组。例如，以下代码无法编译：

```java
List<Integer>[] arrayOfLists = new List<Integer>[2];  // compile-time error
```

下面的代码说明了在数组中插入不同类型时会发生什么：

```java
Object[] strings = new String[2];
strings[0] = "hi";   // OK
strings[1] = 100;    // An ArrayStoreException is thrown.
```

如果您对通用列表尝试相同的操作，则会出现问题：

```java
Object[] stringLists = new List<String>[2];  // compiler error, but pretend it's allowed
stringLists[0] = new ArrayList<String>();   // OK
stringLists[1] = new ArrayList<Integer>();  // An ArrayStoreException should be thrown,
                                            // but the runtime can't detect it.
```

如果允许参数化列表的数组，则前面的代码将无法引发所需的“ArrayStoreException”。

### 无法创建、捕获或抛出参数化类型的对象

泛型类不能直接或间接扩展“Throwable”类。例如，以下类将不会编译：

```java
// Extends Throwable indirectly
class MathException<T> extends Exception { /* ... */ }    // compile-time error

// Extends Throwable directly
class QueueFullException<T> extends Throwable { /* ... */ // compile-time error
```

方法无法捕获类型参数的实例：

```java
public static <T extends Exception, J> void execute(List<J> jobs) {
    try {
        for (J job : jobs)
            // ...
    } catch (T e) {   // compile-time error
        // ...
    }
}
```

但是，您可以在“throws”子句中使用类型参数：

```java
class Parser<T extends Exception> {
    public void parse(File file) throws T {     // OK
        // ...
    }
}
```

### 无法重载每个重载的形式参数类型擦除为相同原始类型的方法

一个类不能有两个重载方法，它们在类型删除后具有相同的签名。

```java
public class Example {
    public void print(Set<String> strSet) { }
    public void print(Set<Integer> intSet) { }
}
```

重载将共享相同的类文件表示，并将生成编译时错误。