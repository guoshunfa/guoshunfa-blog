---
title: Swift基础 枚举
tags:
    - Swift
    - 基础
categories:
    - Swift
date: 2022-07-01 12:01:01
thumbnail:
---


翻译自：https://docs.swift.org/swift-book/LanguageGuide/Enumerations.html

*枚举*为一组相关值定义了通用类型，并使您能够在代码中以类型安全的方式处理这些值。

如果您熟悉C，您将知道C枚举为一组整数值分配相关名称。Swift 中的枚举要灵活得多，不必为每个枚举案例提供值。如果为每个枚举情况提供了一个值（称为*原始*值），则该值可以是字符串、字符或任何整数或浮点类型的值。

或者，枚举大小写可以指定要存储*的任何*类型的关联值，以及每个不同的大小写值，就像其他语言中的联合或变体一样。您可以将一组常见的相关情况定义为一个枚举的一部分，每个枚举都有与之关联的不同类型值集。

Swift 中的枚举本身就是一流的类型。它们采用了许多传统上仅由类支持的功能，例如计算属性以提供有关枚举当前值的更多信息，以及实例方法，以提供与枚举所代表的值相关的功能。枚举还可以定义初始化器以提供初始大小写值；可以扩展其功能，使其功能超出原始实现；并且可以遵守协议以提供标准功能。

有关这些功能的更多信息，请参阅[属性](https://docs.swift.org/swift-book/LanguageGuide/Properties.html)、[方法](https://docs.swift.org/swift-book/LanguageGuide/Methods.html)、[初始化](https://docs.swift.org/swift-book/LanguageGuide/Initialization.html)、[扩展](https://docs.swift.org/swift-book/LanguageGuide/Extensions.html)和[协议](https://docs.swift.org/swift-book/LanguageGuide/Protocols.html)。

## 枚举语法

您使用`enum`关键字引入枚举，并将它们的整个定义放在一对大括号中：

```swift
enum SomeEnumeration {
   // enumeration definition goes here
}
```

以下是指南针四个要点的示例：

```swift
enum CompassPoint {
   case north
   case south
   case east
   case west
}
```

枚举中定义的值（如`north`、`south`、`east`和`west`）是其*枚举情况*。您可以使用`case`关键字来引入新的枚举案例。

> 注意
>
> 与C和Objective-C等语言不同，Swift枚举案例默认没有设置整数值。在上面的`CompassPoint`示例中，`north`、`south`、`east`和`west`不隐含等于`0`、1、`2`和3。相反，不同的枚举情况本身就是值，具有明确定义的`CompassPoint`类型。

多个案例可以出现在一行上，用逗号分隔：

```swift
enum Planet {
   case mercury, venus, earth, mars, jupiter, saturn, uranus, neptune
}
```

每个枚举定义都定义了一种新类型。与Swift中的其他类型一样，他们的名字（如`CompassPoint`和`Planet`）以大写字母开头。给出枚举类型单数而不是复数名称，以便它们读起来不言而喻：

```swift
var directionToHead = CompassPoint.west
```

' directionToHead '的类型在它被' compaspoint '的可能值之一初始化时被推断出来。一旦' directionToHead '被声明为' compaspoint '，你可以使用一个更短的点语法将它设置为一个不同的' compaspoint '值:

```swift
directionToHead = .east
```

`directionToHead`的类型已经知道，因此您可以在设置其值时删除该类型。这使得在处理显式类型的枚举值时具有高度可读性的代码。

## 将枚举值与Switch语句匹配

您可以将单个枚举值与`switch`语句匹配：

```swift
directionToHead = .south
switch directionToHead {
case .north:
   print("Lots of planets have a north")
case .south:
   print("Watch out for penguins")
case .east:
   print("Where the sun rises")
case .west:
   print("Where the skies are blue")
}
// Prints "Watch out for penguins"
```

您可以将此代码读取为：

考虑`directionToHead`的价值。在它等于`.north`的情况下，打印`"Lotsplanetshavenorth"`在它等于`.south`的情况下，打印`"Watchoutpenguins"`

...等等。

如[Control Flow](https://docs.swift.org/swift-book/LanguageGuide/ControlFlow.html)中所述，在考虑枚举的情况时，`switch`语句必须详尽无遗。如果省略`.west``case`，此代码不会编译，因为它不考虑`CompassPoint`案例的完整列表。要求详尽无遗，确保枚举案例不会被意外省略。

如果不适合为每个枚举案例提供`case`，您可以提供`default`案例来涵盖任何未明确解决的案例：

```swift
let somePlanet = Planet.earth
switch somePlanet {
case .earth:
   print("Mostly harmless")
default:
   print("Not a safe place for humans")
}
// Prints "Mostly harmless"
```

## 迭代枚举案例

对于某些枚举，收集所有枚举的案例是有用的。您通过在枚举名称后写入`:CaseIterable`来启用此功能。Swift将所有案例的集合公开为枚举类型的`allCases`属性。这里有一个例子：

```swift
enum Beverage: CaseIterable {
   case coffee, tea, juice
}
let numberOfChoices = Beverage.allCases.count
print("\(numberOfChoices) beverages available")
// Prints "3 beverages available"
```

在上面的示例中，您编写`Beverage.allCases`来访问包含`Beverage`枚举所有案例的集合。您可以像使用任何其他集合一样使用`allCases`——集合的元素是枚举类型的实例，因此在这种情况下，它们是`Beverage`值。上面的示例计算了有多少个案例，下面的示例使用`for`-`in`循环来迭代所有案例。

```swift
for beverage in Beverage.allCases {
   print(beverage)
}
// coffee
// tea
// juice
```

上面示例中使用的语法将枚举标记为符合[`CaseIterable`](https://developer.apple.com/documentation/swift/caseiterable)协议。有关协议的信息，请参阅[协议](https://docs.swift.org/swift-book/LanguageGuide/Protocols.html)。

## 关联值

上一节中的示例显示了枚举的情况本身是如何定义（和键入）的值。您可以为`Planet.earth`设置常量或变量，稍后检查此值。然而，有时将其他类型的值与这些大小写值一起存储是有用的。此附加信息称为*关联值*，每次您将该情况用作代码中的值时，它都会有所不同。

您可以定义Swift枚举来存储任何给定类型的关联值，如果需要，每个枚举情况下的值类型可能不同。类似的枚举被称为*歧视联合*、*标记联合*或其他编程语言的*变体*。

例如，假设库存跟踪系统需要通过两种不同类型的条形码跟踪产品。一些产品以UPC格式标有1D条形码，使用数字`0`到9。每个条形码都有一个数字系统数字，然后是五个制造商代码数字和五个产品代码数字。后面跟着一个检查数字，以验证代码是否已正确扫描：

<img src="https://file.pandacode.cn/blog/202204051541473.png" alt="../_images/barcode_UPC_2x.png" style="zoom:33%;" />

其他产品以二维码格式标有二维条形码，可以使用任何ISO 8859-1字符，并可以对长度高达2953个字符的字符串进行编码：

<img src="https://file.pandacode.cn/blog/202204051541247.png" alt="../_images/barcode_QR_2x.png" style="zoom:33%;" />

库存跟踪系统可以方便地将UPC条形码存储为四个整数的元组，并将二维码条形码存储为任何长度的字符串。

在 Swift 中，用于定义任一类型的产品条形码的枚举可能如下所示：

```swift
enum Barcode {
   case upc(Int, Int, Int, Int)
   case qrCode(String)
}
```

这可以理解为：

“定义一个名为‘Barcode’的枚举类型，它可以接受一个带有类型关联值(‘Int’，‘Int’，‘Int’，‘Int’)的‘upc’值，或者一个带有类型关联值(‘String’)的‘qrCode’值。”

此定义不提供任何实际的`Int`或`String`值——它只是定义了`Barcode`常量和变量在等于`Barcode.upc`或`Barcode.qrCode`时可以存储的关联值*类型*。

然后，您可以使用任一类型创建新条形码：

```swift
var productBarcode = Barcode.upc(8, 85909, 51226, 3)
```

下面的例子创建了一个名为“productBarcode”的新变量，并将其赋值为“Barcode”。Upc '，关联元组值为'(8,85909,51226,3)'。

您可以为同一产品分配不同类型的条形码：

```swift
productBarcode = .qrCode("ABCDEFGHIJKLMNOP")
```

此时，原始`Barcode.upc`及其整数值将被newBarcode`Barcode.qrCode`及其字符串值取代。`Barcode`类型的常量和变量可以存储`.upc`或`.qrCode`（及其相关值），但它们在任何给定时间只能存储其中之一。

您可以使用开关语句检查不同的条形码类型，类似于将[枚举值与交换机语句匹配](https://docs.swift.org/swift-book/LanguageGuide/Enumerations.html#ID147)中的示例。然而，这一次，关联值作为开关语句的一部分提取。您可以将每个关联值提取为常量（带有`let`前缀）或变量（带有`var`前缀），以便在`switch`大小写的正文中使用：

```swift
switch productBarcode {
case .upc(let numberSystem, let manufacturer, let product, let check):
   print("UPC: \(numberSystem), \(manufacturer), \(product), \(check).")
case .qrCode(let productCode):
   print("QR code: \(productCode).")
}
// Prints "QR code: ABCDEFGHIJKLMNOP."
```

如果枚举情况的所有关联值都被提取为常量，或者所有关联值都被提取为变量，为了简洁起义，您可以在案例名称之前放置单个`var`或`let`注释：

```swift
switch productBarcode {
case let .upc(numberSystem, manufacturer, product, check):
   print("UPC : \(numberSystem), \(manufacturer), \(product), \(check).")
case let .qrCode(productCode):
   print("QR code: \(productCode).")
}
// Prints "QR code: ABCDEFGHIJKLMNOP."
```

## 原始值

[关联值](https://docs.swift.org/swift-book/LanguageGuide/Enumerations.html#ID148)中的条形码示例显示了枚举案例如何声明它们存储不同类型的关联值。作为关联值的替代品，枚举情况可以预先填充默认值（称为*原始值*），这些值都是同一类型。

以下是将原始ASCII值与命名枚举案例一起存储的示例：

```swift
enum ASCIIControlCharacter: Character {
   case tab = "\t"
   case lineFeed = "\n"
   case carriageReturn = "\r"
}
```

在这里，名为`ASCIIControlCharacter`的枚举的原始值被定义为`Character`类型，并设置为一些更常见的ASCII控制字符。`Character`值在[字符串和字符](https://docs.swift.org/swift-book/LanguageGuide/StringsAndCharacters.html)中描述。

原始值可以是字符串、字符或任何整数或浮点数类型。每个原始值在其枚举声明中必须是唯一的。

> 注意
>
> 原始值与关联值不同。当您首次在代码中定义枚举时，原始值设置为预填充值，如上面的三个ASCII代码。特定枚举情况的原始值始终相同。当您根据枚举的一个情况创建新常量或变量时，会设置关联值，并且每次这样做时都可能不同。

### 隐式分配的原始值

当您处理存储整数或字符串原始值的枚举时，您不必为每个案例显式分配原始值。当您不这样做时，Swift会自动为您分配值。

例如，当整数用于原始值时，每种情况下的隐式值比上一个大小写多一个。如果第一个案例没有值集，则其值为`0`。

以下枚举是对早期`Planet`枚举的细化，其整数原始值表示每颗行星与太阳的顺序：

```swift
enum Planet: Int {
   case mercury = 1, venus, earth, mars, jupiter, saturn, uranus, neptune
}
```

在上面的示例中，`Planet.mercury`的显式原始值为1，`Planet.venus`的隐式原始值为2，以此类推。

当字符串用于原始值时，每个案例的隐式值是该案例名称的文本。

下面的枚举是对早期`CompassPoint`枚举的细化，字符串原始值表示每个方向的名称：

```swift
enum CompassPoint: String {
   case north, south, east, west
}
```

在上面的示例中，`CompassPoint.south`具有`"south"`等隐式原始值。

您可以使用其`rawValue`属性访问枚举案例的原始值：

```swift
let earthsOrder = Planet.earth.rawValue
// earthsOrder is 3

let sunsetDirection = CompassPoint.west.rawValue
// sunsetDirection is "west"
```

### 从原始值初始化

如果您使用原始值类型定义枚举，枚举会自动收到一个初始化器，该初始化器接受原始值类型的值（作为称为`rawValue`的参数），并返回枚举大小写或`nil`。您可以使用此初始化器尝试创建枚举的新实例。

此示例从原始值`7`中识别天王星：

```swift
let possiblePlanet = Planet(rawValue: 7)
// possiblePlanet is of type Planet? and equals Planet.uranus
```

然而，并不是所有可能的“Int”值都能找到匹配的行星。因此，原始值初始化器总是返回一个*可选的*枚举情况。在上面的例子中，“可能行星”的类型是“行星?”或者“可选的‘行星’。”

> 注意
>
> 原始值初始化器是一个失败的初始化器，因为并非每个原始值都会返回一个枚举情况。有关更多信息，请参阅[失败的初始化器](https://docs.swift.org/swift-book/ReferenceManual/Declarations.html#ID376)。

如果您试图找到位置为11的行星，原始值初始化器返回的可选`Planet`值将为`nil`：

```swift
let positionToFind = 11
if let somePlanet = Planet(rawValue: positionToFind) {
   switch somePlanet {
   case .earth:
       print("Mostly harmless")
   default:
       print("Not a safe place for humans")
   }
} else {
   print("There isn't a planet at position \(positionToFind)")
}
// Prints "There isn't a planet at position 11"
```

这个例子使用了可选的绑定来访问一个原始值为' 11 '的行星。语句' if let somePlanet = Planet(rawValue: 11) '创建了一个可选的' Planet '，并将' somePlanet '设置为可选的' Planet '的值，如果它可以被检索。在这种情况下，不可能检索位置为“11”的行星，所以执行“else”分支。

## 递归枚举

*递归枚举*是一种枚举，其枚举的另一个实例作为一个或多个枚举案例的关联值。您通过在枚举前`indirect`写入来指示枚举情况是递归的，这告诉编译器插入必要的间接层。

例如，这里有一个存储简单算术表达式的枚举：

```swift
enum ArithmeticExpression {
   case number(Int)
   indirect case addition(ArithmeticExpression, ArithmeticExpression)
   indirect case multiplication(ArithmeticExpression, ArithmeticExpression)
}
```

你也可以在枚举的开始之前写' indirect '来为所有有关联值的枚举情况启用间接:

```swift
indirect enum ArithmeticExpression {
   case number(Int)
   case addition(ArithmeticExpression, ArithmeticExpression)
   case multiplication(ArithmeticExpression, ArithmeticExpression)
}
```

此枚举可以存储三种算术表达式:普通数字、两个表达式的加法和两个表达式的乘法。“加法”和“乘法”的关联值也是算术表达式——这些关联值使得嵌套表达式成为可能。例如，表达式'(5 + 4)* 2 '在乘法运算的右边有一个数字，在乘法运算的左边有另一个表达式。因为数据是嵌套的，所以用于存储数据的枚举也需要支持嵌套——这意味着

```swift
1. let five = ArithmeticExpression.number(5)
2. let four = ArithmeticExpression.number(4)
3. let sum = ArithmeticExpression.addition(five, four)
4. let product = ArithmeticExpression.multiplication(sum, ArithmeticExpression.number(2))
```

递归函数是处理具有递归结构的数据的一种简单方法。例如，这里有一个计算算术表达式的函数：

```swift
func evaluate(_ expression: ArithmeticExpression) -> Int {
   switch expression {
   case let .number(value):
       return value
   case let .addition(left, right):
       return evaluate(left) + evaluate(right)
   case let .multiplication(left, right):
       return evaluate(left) * evaluate(right)
   }
}

print(evaluate(product))
// Prints "18"
```

此函数只需返回相关值即可计算纯数。它通过评估左侧的表达式，在右侧评估表达式，然后将它们添加或乘以它们来计算加法或乘法。