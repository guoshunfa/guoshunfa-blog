---
title: Swift基础 基本运算符
tags:
    - swift
    - 基础
categories:
    - 技术
date: 2022-07-01 12:01:01
thumbnail:
---

翻译自：https://docs.swift.org/swift-book/LanguageGuide/BasicOperators.html#ID72

操作符是用来检查、更改或合并值的特殊符号或短语。例如，加法运算符(' + ')将两个数字相加，如' let i = 1 + 2 '，逻辑和运算符(' && ')结合两个布尔值，如' if enteredDoorCode && passsedretinascan '。

Swift支持您可能已经从C等语言中知道的运算符，并改进了几种功能来消除常见的编码错误。赋值运算符（=）不返回值，以防止在等于运算符（`==`时被错误使用。算术运算符（`+`、`-`、`*`、`/`、`%`等）检测并禁止值溢出，以避免在处理大于或小于存储它们的类型允许值范围的数字时出现意外结果。您可以选择使用Swift的溢出运算符来评估溢出行为，如[溢出运算符](https://docs.swift.org/swift-book/LanguageGuide/AdvancedOperators.html#ID37)中所述。

Swift还提供了C中找不到的范围运算符，例如`a..<b`和`a...b`，作为表达一系列值的快捷方式。

本章介绍了Swift中的常见运算符。[高级运算符](/pages/b5a382/)涵盖了Swift的高级运算符，并描述了如何定义自己的自定义运算符，并实现您自己的自定义类型的标准运算符。

## 术语

运算符是一元、二进制或三元：

- *一元*运算符对单个目标（如`-a`）进行操作。元*前缀*运算符出现在目标之前（例如`!b`），一元*后缀*运算符立即出现在目标后面（例如`c!`）。
- *Binary* operators operate on two targets (such as `2 + 3`) and are *infix* because they appear in between their two targets.
- *Ternary* operators operate on three targets. Like C, Swift has only one ternary operator, the ternary conditional operator (`a ? b : c`).

操作符影响的值是*操作数*。在表达式 `1 + 2` 中，`+` 符号是一个中缀操作符，它的两个操作数是值 `1` 和 `2` 。

## 分配操作员

赋值操作符 ( `a = b` )用 `b` 的值初始化或更新 `a` 的值:

```swift
let b = 10
var a = 5
a = b
// a is now equal to 10
```

如果赋值的右侧是一个具有多个值的元组，则其元素可以同时分解为多个常量或变量：

```swift
let (x, y) = (1, 2)
// x is equal to 1, and y is equal to 2
```

与C和Objective-C中的赋值运算符不同，Swift中的赋值运算符本身不会返回值。以下陈述无效：

```swift
if x = y {
   // This isn't valid, because x = y doesn't return a value.
}
```

这个特性可以防止在实际使用等于操作符( `==` )时意外使用赋值操作符( `=` )。通过使 `if x = y` 无效，Swift可以帮助你在代码中避免这类错误。

## 算术运算符

Swift支持所有数字类型的四个标准*算术运算符*：

- 添加（`+`）
- 减法（`-`）
- 乘法（`*`）
- 司（`/`）

```swift
1 + 2       // equals 3
5 - 3       // equals 2
2 * 3       // equals 6
10.0 / 2.5  // equals 4.0
```

与C和Objective-C中的算术操作符不同，Swift的算术操作符默认情况下不允许值溢出。你可以通过使用Swift的溢出操作符(例如 `a &+ b` )来选择值溢出行为。See [Overflow Operators](https://docs.swift.org/swift-book/LanguageGuide/AdvancedOperators.html#ID37).

`String`串联也支持加法运算符：

```swift
"hello, " + "world"  // equals "hello, world"
```

### 剩余运算符

*remainder操作符* ( `a % b` )计算出 `b` 的多少倍将适合于 `a` 并返回剩余的值(称为*remainder*)。

> 注意
>
> 其余运算符（`%`）在其他语言中也被称为*模运算符*。然而，它在Swift中对负数的行为意味着，严格来说，它是一个剩余的操作，而不是一个模块化操作。

以下是剩余运算符的工作原理。要计算`%`，您首先计算出`9`个`4`个内部有多少个：

![../_images/remainderInteger_2x.png](Swift基础-基本运算符/202204042043654.png)

您可以在9个内部安装两个`4`s，其余为`1`（以橙色显示）。

在Swift中，这将写为：

```swift
9 % 4    // equals 1
```

为了确定`%b`的答案，`%`运算符计算以下方程，并将`remainder`作为其输出返回：

```swift
a = (b x some multiplier) + remainder
```

其中`somemultiplier`是适合`a`内部的`b`的最大倍数。

将`9`和`4`插入此方程会产生：

```swift
9=(4 x 2)+1
```

在计算负值的余数时，也应用了相同的方法：

```swift
-9 % 4   // equals -1
```

在方程中插入`-9`和`4`会产生：

```swift
-9=(4 x -2)-1
```

给出剩余值`-1`。

当 `b` 值为负值时， `b` 的符号将被忽略。这意味着 `a % b` 和 `a % -b` 总是给出相同的答案。

### 一元减号运算符

数字值的符号可以使用前缀`-`（称为*一元减号运算符*）切换：

```swift
let three = 3
let minusThree = -three       // minusThree equals -3
let plusThree = -minusThree   // plusThree equals 3, or "minus minus three"
```

一元减算符（`-`）直接放在它操作的值之前，没有任何空格。

### Unary Plus运算符

*一元加运算符*（`+`）只需返回其操作的值，无需任何更改：

```swift
let minusSix = -6
let alsoMinusSix = +minusSix  // alsoMinusSix equals -6
```

虽然一元加运算符实际上什么都没做，但当使用一元减运算符进行负数时，您可以使用它来在代码中为正数提供对称性。

## 复合分配运算符

与C一样，Swift提供了将赋值（=）与另一个操作相结合的*复合赋值运算符*。一个例子是*加法赋值运算符*（`+=`：

```swift
var a = 1
a += 2
// a is now equal to 3
```

表达式 `a += 2` 是 `a = a + 2` 的缩写。实际上，加法和赋值被合并到一个操作符中，同时执行这两个任务。

> 注意
>
> 复合赋值操作符不返回值。例如，你不能写`let b = a += 2`。

有关Swift标准库提供的运算符的信息，请参阅[运算符声明](https://developer.apple.com/documentation/swift/operator_declarations)。

## 比较运算符

Swift 支持以下比较运算符：

- Equal to (`a == b`)
- Not equal to (`a != b`)
- Greater than (`a > b`)
- Less than (`a < b`)
- Greater than or equal to (`a >= b`)
- Less than or equal to (`a <= b`)

> 注意
>
> Swift还提供了两个*身份运算符*（`===`和`!==`，用于测试两个对象引用是否都引用同一个对象实例。有关更多信息，请参阅[身份运营商](https://docs.swift.org/swift-book/LanguageGuide/ClassesAndStructures.html#ID90)。

每个比较运算符都返回一个`Bool`值，以指示语句是否为真：

```swift
1 == 1   // true because 1 is equal to 1
2 != 1   // true because 2 isn't equal to 1
2 > 1    // true because 2 is greater than 1
1 < 2    // true because 1 is less than 2
1 >= 1   // true because 1 is greater than or equal to 1
2 <= 1   // false because 2 isn't less than or equal to 1
```

比较运算符通常用于条件语句，例如`if`语句：

```swift
let name = "world"
if name == "world" {
   print("hello, world")
} else {
   print("I'm sorry \(name), but I don't recognize you")
}
// Prints "hello, world", because name is indeed equal to "world".
```

有关`if`语句的更多信息，请参阅[控制流](https://docs.swift.org/swift-book/LanguageGuide/ControlFlow.html)。

如果两个元组具有相同的类型和相同数量的值，您可以比较它们。元组从左到右比较，一次一个值，直到比较发现两个不相等的值。对这两个值进行了比较，比较的结果决定了元组比较的总体结果。如果所有元素都是相等的，那么元组本身就是相等的。例如：

```swift
(1, "zebra") < (2, "apple")   // true because 1 is less than 2; "zebra" and "apple" aren't compared
(3, "apple") < (3, "bird")    // true because 3 is equal to 3, and "apple" is less than "bird"
(4, "dog") == (4, "dog")      // true because 4 is equal to 4, and "dog" is equal to "dog"
```

在上面的示例中，您可以在第一行看到从左到右的比较行为。因为`1`小于2`(1,"zebra")`被认为是小于`(2,"apple")`，无论元组中的任何其他值如何。`"zebra"`不亚于`"apple"`并不重要，因为比较已经由元组的第一个元素决定了。然而，当元组的第一个元素相同时，它们的第二个元素*会*进行比较——这就是第二行和第三行发生的事情。

只有当运算符可以应用于各自元组中的每个值时，元组才能与给定运算符进行比较。例如，如下代码所示，您可以比较两个类型的元组`(String,Int)`因为可以使用`<`运算符比较`String`和`Int`值。相比之下，两个类型的元组`(String,Bool)`无法与`<`运算符进行比较，因为`<`运算符不能应用于`Bool`值。

```swift
("blue", -1) < ("purple", 1)        // OK, evaluates to true
("blue", false) < ("purple", true)  // Error because < can't compare Boolean values
```

> 注意
>
> Swift标准库包括少于七个元素的元组的元组比较运算符。要将元组与七个或更多元素进行比较，您必须自己实现比较运算符。

## 三元条件运算符

*三元条件算子*是一个有三个部分的特殊算子，它接受形式`question?answer1:answer2`。这是根据`question`是真还是假来评估两个表达式之一的快捷方式。如果`question`属实，它会评估`answer1`并返回其值；否则，它会评估`answer2`并返回其值。

三元条件运算符是以下代码的缩写：

```swift
if question {
   answer1
} else {
   answer2
}
```

这里有一个例子，它计算了表格行的高度。如果行有标题，行高应比内容高度高50分，如果行没有标头，则高20分：

```swift
let contentHeight = 40
let hasHeader = true
let rowHeight = contentHeight + (hasHeader ? 50 : 20)
// rowHeight is equal to 90
```

上面的示例是以下代码的简写：

```swift
let contentHeight = 40
let hasHeader = true
let rowHeight: Int
if hasHeader {
   rowHeight = contentHeight + 50
} else {
   rowHeight = contentHeight + 20
}
// rowHeight is equal to 90
```

第一个示例对三元条件运算符的使用意味着`rowHeight`可以在一行代码上设置为正确的值，这比第二个示例中使用的代码更简洁。

三元条件算子为决定考虑两个表达式中的哪一个提供了一个高效的简写。然而，请小心使用三元条件操作员。如果过度使用，它的简洁性可能会导致难以阅读的代码。避免将三元条件运算符的多个实例组合成一个复合语句。

## nil 合并运算符

*零共同化操作员*（`a??b`) 如果可选`a`包含一个值，则解开它，如果`a`为`nil`则返回默认值`b`。表达式`a`总是可选类型。表达式`b`必须与存储在`a`中的类型匹配。

零共同算符是以下代码的缩写：

```swift
a != nil ? a! : b
```

上面的代码使用三元条件运算符和强制展开（`a!`）当`a`不是`nil`，访问包裹在`a`中的值，否则返回`b`。零凝聚运算符提供了一种更优雅的方式，以简洁易读的形式封装这种有条件的检查和展开包装。

> 注意
>
> 如果`a`的值非`nil`，则不计算`b`的值。这被称为*短路评估*。

以下示例使用零共同化运算符在默认颜色名称和可选用户定义的颜色名称之间进行选择：

```swift
let defaultColorName = "red"
var userDefinedColorName: String?   // defaults to nil

var colorNameToUse = userDefinedColorName ?? defaultColorName
// userDefinedColorName is nil, so colorNameToUse is set to the default of "red"
```

`userDefinedColorName`变量定义为可选`String`，默认值为`nil`。由于`userDefinedColorName`是可选类型，因此您可以使用零强制运算符来考虑其值。在上面的示例中，运算符用于确定名为`colorNameToUse`的`String`变量的初始值。因为`userDefinedColorName`，所以表达式`userDefinedColorName??defaultColorName`返回`defaultColorName`或`"red"`的值。

如果您将非`nil`值分配给`userDefinedColorName`，并再次执行零共同计算符检查，则使用`userDefinedColorName`中包装的值，而不是默认值：

```swift
userDefinedColorName = "green"
colorNameToUse = userDefinedColorName ?? defaultColorName
// userDefinedColorName isn't nil, so colorNameToUse is set to "green"
```

## 范围操作员

Swift包括几个*范围运算符*，它们是表达一系列值的快捷方式。

### 封闭式距离操作员

*闭范围运算符*（`a...b`）定义了一个从`a`到`b`的范围，包括值`a`和`b`。`a`的值不得大于`b`。

在您想要使用所有值的范围上迭代时，闭合范围运算符非常有用，例如`for`-`in`循环：

```swift
for index in 1...5 {
   print("\(index) times 5 is \(index * 5)")
}
// 1 times 5 is 5
// 2 times 5 is 10
// 3 times 5 is 15
// 4 times 5 is 20
// 5 times 5 is 25
```

有关`for`-`in`循环的更多信息，请参阅[控制流](/pages/24ff35/)。

### 半开放式范围操作员

*半开范围运算符*（`a..<b`）定义了一个从`a`到`b`运行的范围，但不包括`b`。据说它是*半开放的*，因为它包含它的第一个值，但不包含它的最终值。与闭区间运算符一样，`a`的值不得大于`b`。如果`a`的值等于`b`，那么结果范围将是空的。

当您使用基于零的列表（如数组）时，半开放范围特别有用，其中最多（但不包括）列表的长度非常有用：

```swift
let names = ["Anna", "Alex", "Brian", "Jack"]
let count = names.count
for i in 0..<count {
   print("Person \(i + 1) is called \(names[i])")
}
// Person 1 is called Anna
// Person 2 is called Alex
// Person 3 is called Brian
// Person 4 is called Jack
```

请注意，数组包含四个项目，但`0..<count`仅计入`3`（数组中最后一个项目的索引），因为它是一个半开放的范围。有关数组的更多信息，请参阅[数组](https://docs.swift.org/swift-book/LanguageGuide/CollectionTypes.html#ID107)。

### 单面范围

闭区间运算符对尽可能在一个方向上继续的范围有另一种形式——例如，范围包括从索引2到数组末尾的数组的所有元素。在这些情况下，您可以省略范围运算符一侧的值。这种范围被称为*单边范围*，因为运算符只在一边有一个值。例如：

```swift
for name in names[2...] {
   print(name)
}
// Brian
// Jack

for name in names[...2] {
   print(name)
}
// Anna
// Alex
// Brian
```

半开范围运算符还有一个单边形式，仅用其最终值书写。就像您在两侧都包含一个值一样，最终值不是范围的一部分。例如：

```swift
for name in names[..<2] {
   print(name)
}
// Anna
// Alex
```

单边范围可用于其他上下文，而不仅仅是下标。您无法迭代省略第一个值的单边范围，因为不清楚迭代应该从哪里开始。*您可以*迭代省略其最终值的单边范围；但是，由于范围无限期地持续，请确保为循环添加显式结束条件。您还可以检查单边范围是否包含特定值，如下代码所示。

```swift
let range = ...5
range.contains(7)   // false
range.contains(4)   // true
range.contains(-1)  // true
```

## 逻辑运算符

*逻辑运算符*修改或组合布尔逻辑值`true`和`false`。Swift支持在基于C的语言中找到的三个标准逻辑运算符：

- 逻辑不是（`!a`）
- 逻辑和（`a&&b`）
- Logical OR (`a || b`)

### 逻辑非运算符

*逻辑非运算符*（`!a`）反转布尔值，使`true`变成`false`，`false`变成`true`。

逻辑NOt运算符是一个前缀运算符，并显示在其操作的值之前，没有任何空格。它可以读作“不是`a`”，如以下示例所示：

```swift
let allowedEntry = false
if !allowedEntry {
   print("ACCESS DENIED")
}
// Prints "ACCESS DENIED"
```

短语`if!allowedEntry`可以读作“如果不允许进入”。只有当“不允许输入”为true时，才会执行后续行；也就是说，如果`allowedEntry`为`false`。

与本示例一样，仔细选择布尔常量和变量名称有助于保持代码的可读性和简洁性，同时避免双重否定或混淆逻辑语句。

### 逻辑和运算符(&&)

*逻辑和运算符*（`a&&b`）创建逻辑表达式，其中两个值都必须`true`，整体表达式也为`true`。

如果任一值为`false`，则整体表达式也为`false`。事实上，如果*第一个*值是`false`的，第二个值甚至不会被计算，因为它不可能使整个表达式等同于`true`。这被称为*短路评估*。

此示例考虑两个`Bool`值，并且仅当两个值都为`true`时才允许访问：

```swift
let enteredDoorCode = true
let passedRetinaScan = false
if enteredDoorCode && passedRetinaScan {
   print("Welcome!")
} else {
   print("ACCESS DENIED")
}
// Prints "ACCESS DENIED"
```

### 逻辑OR运算符(||)

逻辑OR操作符 ( `a || b` )是由两个相邻管道字符组成的中缀操作符。你可以用它来创建逻辑表达式，其中只有两个值中的一个必须为“true”，才能使整个表达式为“true”。

与上面的逻辑和运算符一样，逻辑OR运算符使用短路求值来考虑其表达式。如果逻辑OR表达式的左侧为`true`，则不会计算右侧，因为它无法改变整体表达式的结果。

在下面的示例中，第一个`Bool`值（`hasDoorKey`）为`false`，但第二个值（`knowsOverridePassword`）为`true`。因为一个值为`true`，因此整体表达式也计算为`true`，并且允许访问：

```swift
let hasDoorKey = false
let knowsOverridePassword = true
if hasDoorKey || knowsOverridePassword {
   print("Welcome!")
} else {
   print("ACCESS DENIED")
}
// Prints "Welcome!"
```

### 组合逻辑运算符

您可以组合多个逻辑运算符来创建更长的复合表达式：

```swift
if enteredDoorCode && passedRetinaScan || hasDoorKey || knowsOverridePassword {
   print("Welcome!")
} else {
   print("ACCESS DENIED")
}
// Prints "Welcome!"
```

此示例使用多个`&&`和`||`运算符来创建更长的复合表达式。然而，`&&`和`||`运算符仍然只在两个值上运行，因此这实际上是三个较小的表达式链在一起。该示例可以理解为：

如果我们输入了正确的门密码并通过了视网膜扫描，或者我们有有效的门钥匙，或者我们知道紧急覆盖密码，那么允许访问。

根据 `enteredDoorCode` ，  `passedRetinaScan` 和 `hasDoorKey` 的值，前两个子表达式为 `false` 。但是，紧急重写密码是已知的，因此整个复合表达式的计算结果仍然为“true”。

> 注意
>
> Swift逻辑运算符`&&`和`||`是左关联，这意味着具有多个逻辑运算符的复合表达式首先计算最左边的子表达式。

### 显式括号

有时，在不严格需要括号时包含括号是有用的，以使复杂表达式的意图更容易阅读。在上面的门访问示例中，在复合表达式的第一部分周围添加括号以明确其意图是有用的：

```swift
if (enteredDoorCode && passedRetinaScan) || hasDoorKey || knowsOverridePassword {
   print("Welcome!")
} else {
   print("ACCESS DENIED")
}
// Prints "Welcome!"
```

括号清楚地表明，前两个值被视为整体逻辑中单独可能状态的一部分。复合表达式的输出不会改变，但整体意图对读者来说更清楚。可读性总是比简洁更受欢迎；使用括号，它们有助于明确你的意图。