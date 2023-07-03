---
title: Swift基础 高级操作员
tags:
    - swift
    - 基础
categories:
    - 技术
date: 2022-07-01 12:01:01
thumbnail:
---

翻译自：https://docs.swift.org/swift-book/LanguageGuide/AdvancedOperators.html

[除了基本运算符](https://docs.swift.org/swift-book/LanguageGuide/BasicOperators.html)中描述[的](https://docs.swift.org/swift-book/LanguageGuide/BasicOperators.html)运算符外，Swift还提供了几个高级运算符来执行更复杂的值操作。这些包括您将熟悉的C和Objective-C的所有位和位移位运算符。

与C中的算术运算符不同，Swift中的算术运算符默认不会溢出。溢出行为被困住，并报告为错误。要选择溢出行为，请使用Swift的第二组默认溢出的算术运算符，例如溢出加法运算符（`&+`）。所有这些溢出运算符都以安培和（`&`）开头。

当您定义自己的结构、类和枚举时，为这些自定义类型提供您自己的标准Swift运算符的实现可能会很有用。Swift可以轻松提供这些运算符的定制实现，并准确确定它们对您创建的每个类型的行为。

您不限于预定义的运算符。Swift允许您自由定义自己的自定义内缀、前缀、后缀和赋值运算符，并具有自定义优先级和关联性值。这些运算符可以像任何预定义运算符一样在您的代码中使用和采用，您甚至可以扩展现有类型以支持您定义的自定义运算符。

## 按位运算符

*按位运算符*使您能够操作数据结构中的单个原始数据位。它们通常用于低级编程，例如图形编程和设备驱动程序创建。当您处理来自外部来源的原始数据时，例如编码和解码数据以通过自定义协议进行通信时，按位运算符也很有用。

Swift支持C中的所有按位运算符，如下所述。

### Bitwise NOT运算符

*按位不算符*（`~`）反转数字中的所有位：

![../_images/bitwiseNOT_2x.png](https://docs.swift.org/swift-book/_images/bitwiseNOT_2x.png)

按位NOt运算符是一个前缀运算符，并显示在其操作的值之前，没有任何空格：

1. let initialBits: UInt8 = 0b00001111
2. let invertedBits = ~initialBits  // equals 11110000

`UInt8`整数有8位，可以存储`0`到`255`之间的任何值。此示例初始化二进制值`00001111`的`UInt8`整数，其前四位设置为`0`，后四位设置为1。这相当于小数点后15。

然后，按位NOt运算符创建一个名为`invertedBits`的新常量，该常量等于initialBits，但所有位都倒置。零变成1，1变成零。`invertedBits`的值为`11110000`，等于`240`的无符号小数值。

### 位和运算符

*按位和运算符*（`&`）结合了两个数字的位。*只有当两个*输入数字中的位等于`1`时，它才会返回一个新数字，其位设置为`1`：

![../_images/bitwiseAND_2x.png](https://docs.swift.org/swift-book/_images/bitwiseAND_2x.png)

在下面的示例中，`firstSixBits`和`lastSixBits`的值都有四个中间位等于1。按位和运算符将它们组合成数字`00111100`，等于`60`的无符号小数值：

1. let firstSixBits: UInt8 = 0b11111100
2. let lastSixBits: UInt8  = 0b00111111
3. let middleFourBits = firstSixBits & lastSixBits  // equals 00111100

### Bitwise OR运算符

*按位OR运算符*（`|`）比较两个数字的位。如果*任一*输入号中的位等于`1`运算符返回一个新数字，其位设置为`1`：

![../_images/bitwiseOR_2x.png](https://docs.swift.org/swift-book/_images/bitwiseOR_2x.png)

在下面的示例中，`someBits`和`moreBits`的值将不同的位设置为1。按位或运算符将它们组合成数字`11111110`，等于`254`的无符号小数点：

1. let someBits: UInt8 = 0b10110010
2. let moreBits: UInt8 = 0b01011110
3. let combinedbits = someBits | moreBits  // equals 11111110

### 位XOR运算符

*按位XOR运算符*，或“排他性OR运算符”（`^`），比较两个数字的位。运算符返回一个新数字，其位设置为`1`，其中输入位不同，并设置为`0`，其中输入位相同：

![../_images/bitwiseXOR_2x.png](https://docs.swift.org/swift-book/_images/bitwiseXOR_2x.png)

在下面的示例中，`firstBits`和`otherBits`的值在另一个没有的位置上都设置为`1`。按位XOR运算符将这两个位的输出值设置为`1`。`firstBits``otherBits`中的所有其他位都匹配，并在输出值中设置为`0`：

1. let firstBits: UInt8 = 0b00010100
2. let otherBits: UInt8 = 0b00000101
3. let outputBits = firstBits ^ otherBits  // equals 00010001

### 逐位左移和右移运算符

根据下面定义的规则，*按位左移运算符*（`<<`）和*按位右移运算符*（`>>`）将数字中的所有位向左或向右移动一定数量的位置。

位左移和右移具有整数乘以或除以二倍的效果。将整数的位向左移动一个位置会使其值翻倍，而将其向右移动一个位置会将其值减半。

#### 无符号整数的移动行为

无符号整数的位移位行为如下：

1. 现有位按请求的位数向左或向右移动。
2. 任何移动到整数存储边界之外的位都会被丢弃。
3. 在原始位向左或向右移动后，零插入后面的空间。

这种方法被称为*逻辑转变*。

The illustration below shows the results of `11111111 << 1` (which is `11111111` shifted to the left by `1` place), and `11111111 >> 1` (which is `11111111` shifted to the right by `1` place). Blue numbers are shifted, gray numbers are discarded, and orange zeros are inserted:

![../_images/bitshiftUnsigned_2x.png](https://docs.swift.org/swift-book/_images/bitshiftUnsigned_2x.png)

以下是 Swift 代码中位移的外观：

1. let shiftBits: UInt8 = 4   // 00000100 in binary
2. shiftBits << 1             // 00001000
3. shiftBits << 2             // 00010000
4. shiftBits << 5             // 10000000
5. shiftBits << 6             // 00000000
6. shiftBits >> 2             // 00000001

您可以使用位移来编码和解码其他数据类型中的值：

1. let pink: UInt32 = 0xCC6699
2. let redComponent = (pink & 0xFF0000) >> 16    // redComponent is 0xCC, or 204
3. let greenComponent = (pink & 0x00FF00) >> 8   // greenComponent is 0x66, or 102
4. let blueComponent = pink & 0x0000FF           // blueComponent is 0x99, or 153

此示例使用名为`pink`的`UInt32`常量来存储粉红色的级联样式表颜色值。CSS颜色值`#CC6699`在Swift的十六进制数字表示中写为`0xCC6699`。然后，按位AND运算符（`&`）和按位右移运算符（`>>`）分解为红色（`CC`）、绿色（`66`）和蓝色（`99`）组件。

红色分量是通过在数字`0xCC6699`和`0xFF0000`之间执行按位AND获得的。`0xFF0000`中的零有效地“屏蔽”了`0xCC6699`的第二和第三个字节，导致`6699`被忽略，并因此留下`0xCC0000`。

This number is then shifted 16 places to the right (`>> 16`). Each pair of characters in a hexadecimal number uses 8 bits, so a move 16 places to the right will convert `0xCC0000` into `0x0000CC`. This is the same as `0xCC`, which has a decimal value of `204`.

同样，绿色分量是通过在数字`0xCC6699`和`0x00FF00`之间执行按位AND获得的，输出值为`0x006600`。然后，该输出值向右移动八个位置，给出的值为`0x66`，小数值为`102`。

最后，通过在数字`0xCC6699`和`0x0000FF`之间执行按位AND获得蓝色分量，输出值为`0x000099`。由于`0x000099`已经等于`0x99`，其小数值为153，因此使用此值时不会将其向右移动，

#### 有符号整数的移动行为

有符号整数的移位行为比无符号整数更复杂，因为有符号整数在二进制中表示的方式。（为了简单起见，以下示例基于8位有符号整数，但同样的原则适用于任何大小的有符号整数。）

有符号整数使用它们的第一个位（称为*符号位*）来指示整数是正数还是负数。`0`的符号位表示正值，`1`的符号位表示负数。

剩余的位（称为*值位*）存储实际值。正数的存储方式与无符号整数完全相同，从`0`向上计数。以下是`Int8`中的位如何查找数字`4`：

![../_images/bitshiftSignedFour_2x.png](https://docs.swift.org/swift-book/_images/bitshiftSignedFour_2x.png)

符号位为`0`（意为“正”），七个值位只是数字4，用二进制符号书写。

然而，负数的存储方式不同。它们通过从`2`减去`n`的绝对值来存储，其中`n`是值位数。八位数字有7个值位，这意味着`2`到7或`128`的功率。

以下是`Int8`内部的位如何查找数字`-4`：

![../_images/bitshiftSignedMinusFour_2x.png](https://docs.swift.org/swift-book/_images/bitshiftSignedMinusFour_2x.png)

这一次，符号位为`1`（意为“负”），七个值位的二进制值为`124`（即`1284`）：

![../_images/bitshiftSignedMinusFourValue_2x.png](https://docs.swift.org/swift-book/_images/bitshiftSignedMinusFourValue_2x.png)

这种负数编码被称为*二的补数*表示。这可能看起来是一种不寻常的表示负数的方式，但它有几个优点。

首先，您可以添加`-1`到`-4`，只需对所有8位（包括符号位）进行标准二进制添加，并在完成后丢弃任何不适合8位的东西：

![../_images/bitshiftSignedAddition_2x.png](https://docs.swift.org/swift-book/_images/bitshiftSignedAddition_2x.png)

其次，两者的补码表示还允许您像正数一样将负数位移到左侧和右侧，并且最终在向左移动的每移动时将其翻倍，或者在向右移动的每移动时将其减半。为了实现这一目标，当有符号整数向右移动时，会使用额外的规则：当您向右移动有符号整数时，请应用与无符号整数相同的规则，但用*符号位*而不是用零填充左侧的任何空位。

![../_images/bitshiftSigned_2x.png](https://docs.swift.org/swift-book/_images/bitshiftSigned_2x.png)

此操作确保有符号整数在向右移动后具有相同的符号，并被称为*算术移位*。

由于正数和负数的存储方式特殊，将它们中的任何一个移动到右边会使它们接近于零。在这种转变期间保持符号位不变意味着负整数在值接近于零时保持负数。

## 溢出运算符

如果您尝试将数字插入无法保存该值的整数常量或变量中，默认情况下，Swift会报告错误，而不是允许创建无效值。当您处理太大或太小的数字时，这种行为会带来额外的安全性。

例如，`Int16`整数类型可以保存`-32768`和`32767`之间的任何有符号整数。尝试将`Int16`常量或变量设置为此范围之外的数字会导致错误：

1. var potentialOverflow = Int16.max
2. // potentialOverflow equals 32767, which is the maximum value an Int16 can hold
3. potentialOverflow += 1
4. // this causes an error

当值太大或太小时提供错误处理，使您在编码边界值条件时具有更大的灵活性。

但是，当您特别希望溢出条件截断可用位数时，您可以选择此行为，而不是触发错误。Swift提供了三个算法*溢出运算符*，这些*运算符*选择溢出行为进行整数计算。这些运算符都以安培数（`&`）开头：

- 溢出添加（`&+`）
- 溢出减法（`&-`）
- 溢出乘法（`&*`）

### 价值溢出

数字可以向正向和负方向溢出。

以下是一个示例，说明当允许无符号整数使用溢出加法运算符（`&+`）向正方向溢出时会发生什么：

1. var unsignedOverflow = UInt8.max
2. // unsignedOverflow equals 255, which is the maximum value a UInt8 can hold
3. unsignedOverflow = unsignedOverflow &+ 1
4. // unsignedOverflow is now equal to 0

变量`unsignedOverflow`初始化为`UInt8`可以持有的最大值（`255`，二进制为`11111111`）。然后使用溢出加法运算符（`&+`）将其增加`1`。这使其二进制表示略高于`UInt8`可以容纳的大小，导致其溢出超出其界限，如下图所示。溢出加法后保持在`UInt8`范围内的值为`00000000`或零。

![../_images/overflowAddition_2x.png](https://docs.swift.org/swift-book/_images/overflowAddition_2x.png)

当允许无符号整数向负方向溢出时，也会发生类似的事情。以下是使用溢出减法运算符（`&-`）的示例：

1. var unsignedOverflow = UInt8.min
2. // unsignedOverflow equals 0, which is the minimum value a UInt8 can hold
3. unsignedOverflow = unsignedOverflow &- 1
4. // unsignedOverflow is now equal to 255

`UInt8`可以持有的最低值为零，或二进制中的`00000000`。如果您使用溢出减法运算符（`&-`）从`00000000`中减去`1`，该数字将溢出并包装为`11111111`，或小数`255`。

![../_images/overflowUnsignedSubtraction_2x.png](https://docs.swift.org/swift-book/_images/overflowUnsignedSubtraction_2x.png)

签名整数也会发生溢出。有符号整数的所有加法和减法都以按位方式执行，符号位包含在数字中添加或减去中，如[按位左移和右移运算符](https://docs.swift.org/swift-book/LanguageGuide/AdvancedOperators.html#ID34)中所述。

1. var signedOverflow = Int8.min
2. // signedOverflow equals -128, which is the minimum value an Int8 can hold
3. signedOverflow = signedOverflow &- 1
4. // signedOverflow is now equal to 127

`Int8`可以持有的最低值为`-128`，或二进制中的`10000000`。使用溢出运算符从这个二进制数中减去`1`，二进制值为`01111111`，这会切换符号位并给出正`127`，即`Int8`可以持有的最大正值。

![../_images/overflowSignedSubtraction_2x.png](https://docs.swift.org/swift-book/_images/overflowSignedSubtraction_2x.png)

对于有符号整数和非有符号整数，正方向的溢出从最大有效整数值回最小值，负方向的溢出从最小值到最大值。

## 优先级和关联性

运算符*优先级*赋予一些运算符比其他运算符更高的优先级；这些运算符首先应用。

运算符*结合性*定义了具有相同优先级的运算符如何分组在一起——要么从左分组，要么从右分组。把它想象成“他们与左边的表达式相关联想”，或“他们与右边的表达式相关联”。

在计算复合表达式的顺序时，重要的是要考虑每个算子的优先级和关联性。例如，运算符优先级解释了为什么以下表达式等于17。

1. 2 + 3 % 4 * 5
2. // this equals 17

如果您严格从左到右阅读，您可能会期望表达式计算如下：

- `2`加`3`等于`5`
- `5`剩余的`4`等于`1`
- `1`乘以`5`等于`5`

然而，实际答案是17，而不是5。高优先级算子在低优先级运算符之前进行评估。在Swift中，与C一样，余数运算符（`%`）和乘法运算符（`*`）的优先级高于加法运算符（`+`）。因此，在考虑添加之前，它们都会被评估。

然而，余数和乘法具有*相同的*优先级。要确定要使用的确切评估顺序，您还需要考虑它们的关联性。剩余和乘法都与左边的表达式相关联。将其视为从左侧开始，在表达式的这些部分周围添加隐式括号：

1. 2 + ((3 % 4) * 5)

`(3 % 4)`是3，所以这相当于：

1. 2 + (3 * 5)

`(3 * 5)`是15，所以这相当于：

1. 2 + 15

这一计算得出了17的最终答案。

有关Swift标准库提供的运算符的信息，包括运算符优先级组和关联性设置的完整列表，请参阅[运算符声明](https://developer.apple.com/documentation/swift/operator_declarations)。

注意

Swift的运算符优先级和结合性规则比C和Objective-C更简单、更可预测。然而，这意味着它们与基于C的语言并不完全相同。在将现有代码移植到Swift时，请务必确保运营商交互的行为仍然像您希望的方式。

## 运算符方法

类和结构可以提供现有运算符自己的实现。这被称为*使*现有运算符*超载*。

下面的示例展示了如何为自定义结构实现算术加法运算符（`+`）。算术加法运算符是一个二进制运算符，因为它在两个目标上运行，而它是一个内缀运算符，因为它出现在这两个目标之间。

该示例为二维位置向量`(x,y)`定义了`Vector2D`结构，然后是将`Vector2D`结构实例相加的*运算符方法*的定义：

1. struct Vector2D {
2. ​    var x = 0.0, y = 0.0
3. }
4. 
5. extension Vector2D {
6. ​    static func + (left: Vector2D, right: Vector2D) -> Vector2D {
7. ​        return Vector2D(x: left.x + right.x, y: left.y + right.y)
8. ​    }
9. }

运算符方法被定义为`Vector2D`上的类型方法，其方法名称与要重载的运算符（`+`）匹配。由于加法不是向量基本行为的一部分，因此类型方法在`Vector2D`的扩展中定义，而不是在`Vector2D`的主结构声明中定义。由于算术加法运算符是二进制运算符，因此该运算符方法接受`Vector2D`类型的两个输入参数，并返回一个输出值，也是`Vector2D`类型的输出值。

在这个实现中，输入参数被命名为`left`和`right`，以表示位于`+`运算符左侧和右侧的`Vector2D`实例。该方法返回一个新的`Vector2D`实例，其`x`和`y`属性使用添加到在一起的两个`Vector2D`实例的`x`和`y`属性的总和初始化。

类型方法可以用作现有`Vector2D`实例之间的修复运算符：

1. let vector = Vector2D(x: 3.0, y: 1.0)
2. let anotherVector = Vector2D(x: 2.0, y: 4.0)
3. let combinedVector = vector + anotherVector
4. // combinedVector is a Vector2D instance with values of (5.0, 5.0)

此示例将矢量`(3.0,1.0)`和`(2.0,4.0)`组合在一起，使矢量`(5.0,5.0)`如下所示。

![../_images/vectorAddition_2x.png](https://docs.swift.org/swift-book/_images/vectorAddition_2x.png)

### 前缀和后缀运算符

上面显示的示例演示了二进制修复运算符的自定义实现。类和结构还可以提供标准*一元运算符*的实现。单一运算符在单个目标上运行。如果它们在目标（如`-a`）之前，它们是*前缀*，如果他们遵循目标（如`b!`则为*后缀*运算符。

在声明运算符方法时，您可以通过在`func`关键字之前写入`prefix`或`postfix`修饰符来实现前缀或后缀一元运算符：

1. extension Vector2D {
2. ​    static prefix func - (vector: Vector2D) -> Vector2D {
3. ​        return Vector2D(x: -vector.x, y: -vector.y)
4. ​    }
5. }

上面的示例实现了`Vector2D`实例的一元减运算符（`-a`）。一元减算符是前缀运算符，因此这种方法必须用`prefix`修饰符限定。

对于简单的数值，一元减算符将正数转换为负等价数，反之亦然。`Vector2D`实例的相应实现对`x`和`y`属性执行此操作：

1. let positive = Vector2D(x: 3.0, y: 4.0)
2. let negative = -positive
3. // negative is a Vector2D instance with values of (-3.0, -4.0)
4. let alsoPositive = -negative
5. // alsoPositive is a Vector2D instance with values of (3.0, 4.0)

### 复合分配运算符

*复合赋值运算符*将赋值（=）与另一个运算相结合。例如，加法赋值运算符（`+=`将加法和赋值组合成一个运算。您可以将复合赋值运算符的左输入参数类型标记为`inout`，因为参数的值将直接从运算符方法中修改。

以下示例实现了`Vector2D`实例的加法赋值运算符方法：

1. extension Vector2D {
2. ​    static func += (left: inout Vector2D, right: Vector2D) {
3. ​        left = left + right
4. ​    }
5. }

由于添加运算符是早些时候定义的，因此您无需在这里重新实现添加过程。相反，加法赋值运算符方法利用了现有的加法运算符方法，并使左值设置为左值加右值：

1. var original = Vector2D(x: 1.0, y: 2.0)
2. let vectorToAdd = Vector2D(x: 3.0, y: 4.0)
3. original += vectorToAdd
4. // original now has values of (4.0, 6.0)

注意

It isn’t possible to overload the default assignment operator (`=`). Only the compound assignment operators can be overloaded. Similarly, the ternary conditional operator (`a ? b : c`) can’t be overloaded.

### 等效运算符

默认情况下，自定义类和结构没有*等价运算符*的实现，称为*等于*运算符（`==`，*不等于*运算符（`!=`）。您通常实现`==`运算符，并使用标准库的默认实现`!=`否定`==`运算符结果的运算符。有两种方法可以实现`==`运算符：您可以自己实现它，或者对于许多类型，您可以让Swift为您合成实现。在这两种情况下，您都会添加与标准库的`Equatable`协议的一致性。

您以与实现其他修复运算符相同的方式提供`==`运算符的实现：

1. extension Vector2D: Equatable {
2. ​    static func == (left: Vector2D, right: Vector2D) -> Bool {
3. ​        return (left.x == right.x) && (left.y == right.y)
4. ​    }
5. }

上面的示例实现了`==`运算符来检查两个`Vector2D`实例是否具有等效值。在`Vector2D`的上下文中，将“相等”视为“这两个实例具有相同的`x`值和`y`值”是有道理的，因此这是运算符实现使用的逻辑。

您现在可以使用此运算符检查两个`Vector2D`实例是否等效：

1. let twoThree = Vector2D(x: 2.0, y: 3.0)
2. let anotherTwoThree = Vector2D(x: 2.0, y: 3.0)
3. if twoThree == anotherTwoThree {
4. ​    print("These two vectors are equivalent.")
5. }
6. // Prints "These two vectors are equivalent."

在许多简单的情况下，您可以要求Swift为您提供等效运算符的合成实现，如《[采用使用合成实现的协议》](https://docs.swift.org/swift-book/LanguageGuide/Protocols.html#ID627)中所述。

## 自定义操作员

除了Swift提供的标准运算符外，您还可以声明和实现自己的*自定义*运算符。有关可用于定义自定义运算符的字符列表，请参阅[运算符](https://docs.swift.org/swift-book/ReferenceManual/LexicalStructure.html#ID418)。

新运算符使用`operator`关键字在全局级别声明，并标有`prefix`、`infix`或`postfix`修饰符：

1. prefix operator +++

上面的示例定义了一个名为`+++`的新前缀运算符。此运算符在Swift中没有现有含义，因此在使用`Vector2D`实例的特定上下文中，它在下面被赋予了自己的自定义含义。在本例中，`+++`被视为一个新的“前缀加倍”运算符。它通过使用前面定义的加法赋值运算符将向量添加到自身，将`Vector2D`实例的`x`和`y`值翻倍。要实现`+++`运算符，请在`Vector2D`中添加一个名为`+++`的类型方法，如下所示：

1. extension Vector2D {
2. ​    static prefix func +++ (vector: inout Vector2D) -> Vector2D {
3. ​        vector += vector
4. ​        return vector
5. ​    }
6. }
7. 
8. var toBeDoubled = Vector2D(x: 1.0, y: 4.0)
9. let afterDoubling = +++toBeDoubled
10. // toBeDoubled now has values of (2.0, 8.0)
11. // afterDoubling also has values of (2.0, 8.0)

### 自定义Infix运算符的优先级

每个自定义修复运算符都属于优先级组。优先级组指定运算符相对于其他内缀运算符的优先级，以及运算符的关联性。有关这些特征如何影响内缀运算符与其他内缀运算符的交互的说明，请参阅[优先级和关联性](https://docs.swift.org/swift-book/LanguageGuide/AdvancedOperators.html#ID41)。

没有显式放置在优先级组中的自定义内缀运算符将获得一个默认优先级组，其优先级直接高于三元条件运算符的优先级。

以下示例定义了一个名为`+-`的新自定义内缀运算符，该运算符属于优先级组 `AdditionPrecedence`：

1. infix operator +-: AdditionPrecedence
2. extension Vector2D {
3. ​    static func +- (left: Vector2D, right: Vector2D) -> Vector2D {
4. ​        return Vector2D(x: left.x + right.x, y: left.y - right.y)
5. ​    }
6. }
7. let firstVector = Vector2D(x: 1.0, y: 2.0)
8. let secondVector = Vector2D(x: 3.0, y: 4.0)
9. let plusMinusVector = firstVector +- secondVector
10. // plusMinusVector is a Vector2D instance with values of (4.0, -2.0)

这个运算符将两个向量的`x`值加在一起，并从第一个向量中减去第二个向量的`y`值。因为它本质上是一个“加法”运算符，所以它被赋予了与`+`和`-`等加性内缀运算符相同的优先级组。有关Swift标准库提供的运算符的信息，包括运算符优先级组和关联性设置的完整列表，请参阅[运算符声明](https://developer.apple.com/documentation/swift/operator_declarations)。有关优先级组的更多信息，以及查看定义您自己的运算符和优先级组的语法，请参阅[运算符声明](https://docs.swift.org/swift-book/ReferenceManual/Declarations.html#ID380)。

注意

在定义前缀或后缀运算符时，您不会指定优先级。但是，如果您同时将前缀和后缀运算符应用于同一操作数，则首先应用后缀运算符。

## 结果建设者

*结果生成器*是您定义的一种类型，它以自然、声明的方式添加用于创建嵌套数据（如列表或树）的语法。使用结果构建器的代码可以包括普通的Swift语法，例如`if`和`for`，以处理条件或重复的数据。

以下代码定义了使用星星和文本在单行上绘制的几种类型。

1. protocol Drawable {
2. ​    func draw() -> String
3. }
4. struct Line: Drawable {
5. ​    var elements: [Drawable]
6. ​    func draw() -> String {
7. ​        return elements.map { $0.draw() }.joined(separator: "")
8. ​    }
9. }
10. struct Text: Drawable {
11. ​    var content: String
12. ​    init(_ content: String) { self.content = content }
13. ​    func draw() -> String { return content }
14. }
15. struct Space: Drawable {
16. ​    func draw() -> String { return " " }
17. }
18. struct Stars: Drawable {
19. ​    var length: Int
20. ​    func draw() -> String { return String(repeating: "*", count: length) }
21. }
22. struct AllCaps: Drawable {
23. ​    var content: Drawable
24. ​    func draw() -> String { return content.draw().uppercased() }
25. }

`Drawable`协议定义了对可以绘制的东西的要求，例如线条或形状：类型必须实现`draw()`方法。`Line`结构代表单线绘图，它为大多数绘图的顶层容器服务。要绘制一条`Line`，结构在每行的组件上调用`draw()`，然后将生成的字符串连接成单个字符串。`Text`结构包裹字符串使其成为绘图的一部分。`AllCaps`结构包装和修改另一张绘图，将绘图中的任何文本转换为大写。

可以通过调用初始化器来使用这些类型绘制绘图：

1. let name: String? = "Ravi Patel"
2. let manualDrawing = Line(elements: [
3. ​    Stars(length: 3),
4. ​    Text("Hello"),
5. ​    Space(),
6. ​    AllCaps(content: Text((name ?? "World") + "!")),
7. ​    Stars(length: 2),
8. ​    ])
9. print(manualDrawing.draw())
10. // Prints "***Hello RAVI PATEL!**"

这个代码有效，但有点尴尬。`AllCaps`之后的深嵌套括号很难阅读。当`name`为`nil`使用“世界”的后备逻辑必须使用`??`完成操作员，如果更复杂，那就很难了。如果您需要包含开关或循环来构建部分绘图，则无法做到这一点。结果生成器允许您像这样重写代码，使其看起来像普通的Swift代码。

要定义结果构建器，请在类型声明上写入`@resultBuilder`属性。例如，此代码定义了一个名为`DrawingBuilder`的结果构建器，它允许您使用声明语法来描述绘图：

1. @resultBuilder
2. struct DrawingBuilder {
3. ​    static func buildBlock(_ components: Drawable...) -> Drawable {
4. ​        return Line(elements: components)
5. ​    }
6. ​    static func buildEither(first: Drawable) -> Drawable {
7. ​        return first
8. ​    }
9. ​    static func buildEither(second: Drawable) -> Drawable {
10. ​        return second
11. ​    }
12. }

`DrawingBuilder`结构定义了实现结果构建器语法部分的三种方法。`buildBlock(_:)`方法增加了对在代码块中写入一系列行的支持。它将该块中的组件组合成一条`Line`。ThebuildEither`buildEither(first:)`和`buildEither(second:)`方法增加了对`if`-`else`的支持。

您可以将`@DrawingBuilder`属性应用于函数的参数，该参数将传递给函数的闭包转换为结果构建器从该闭包创建的值。例如：

1. func draw(@DrawingBuilder content: () -> Drawable) -> Drawable {
2. ​    return content()
3. }
4. func caps(@DrawingBuilder content: () -> Drawable) -> Drawable {
5. ​    return AllCaps(content: content())
6. }
7. 
8. func makeGreeting(for name: String? = nil) -> Drawable {
9. ​    let greeting = draw {
10. ​        Stars(length: 3)
11. ​        Text("Hello")
12. ​        Space()
13. ​        caps {
14. ​            if let name = name {
15. ​                Text(name + "!")
16. ​            } else {
17. ​                Text("World!")
18. ​            }
19. ​        }
20. ​        Stars(length: 2)
21. ​    }
22. ​    return greeting
23. }
24. let genericGreeting = makeGreeting()
25. print(genericGreeting.draw())
26. // Prints "***Hello WORLD!**"
27. 
28. let personalGreeting = makeGreeting(for: "Ravi Patel")
29. print(personalGreeting.draw())
30. // Prints "***Hello RAVI PATEL!**"

`makeGreeting(for:)`函数使用`name`参数，并用它来绘制个性化的问候语。`draw(_:)`和`caps(_:)`函数都以单个闭包作为参数，该闭包标有`@DrawingBuilder`属性。当您调用这些函数时，您使用`DrawingBuilder`定义的特殊语法。Swift将绘图的声明性描述转换为对`DrawingBuilder`上方法的一系列调用，以建立作为函数参数传递的值。例如，Swift将该示例中的对`caps(_:)`调用转换为以下代码：

1. let capsDrawing = caps {
2. ​    let partialDrawing: Drawable
3. ​    if let name = name {
4. ​        let text = Text(name + "!")
5. ​        partialDrawing = DrawingBuilder.buildEither(first: text)
6. ​    } else {
7. ​        let text = Text("World!")
8. ​        partialDrawing = DrawingBuilder.buildEither(second: text)
9. ​    }
10. ​    return partialDrawing
11. }

Swift将`if`-`else`块转换为对`buildEither(first:)`和`buildEither(second:)`方法的调用。虽然您不会在自己的代码中调用这些方法，但当您使用`DrawingBuilder`语法时，显示转换结果可以更容易地查看Swift如何转换代码。

要在特殊绘图语法中添加`for`循环写入的支持，请添加`buildArray(_:)`方法。

1. extension DrawingBuilder {
2. ​    static func buildArray(_ components: [Drawable]) -> Drawable {
3. ​        return Line(elements: components)
4. ​    }
5. }
6. let manyStars = draw {
7. ​    Text("Stars:")
8. ​    for length in 1...3 {
9. ​        Space()
10. ​        Stars(length: length)
11. ​    }
12. }

在上面的代码中，`for`循环创建一个绘图数组，`buildArray(_:)`方法将该数组转换为`Line`。

有关Swift如何将构建器语法转换为对构建器类型方法的调用的完整列表，请参阅[结果构建器](https://docs.swift.org/swift-book/ReferenceManual/Attributes.html#ID633)。