---
title: Swift基础 基础知识
tags:
    - swift
    - 基础
categories:
    - 技术
date: 2022-07-01 12:01:01
thumbnail:
---

翻译自：https://docs.swift.org/swift-book/LanguageGuide/TheBasics.html

Swift 是 iOS、macOS、watchOS 和 Apple tvOS app 开发的新编程语言。尽管如此，从您在C和Objective-C开发的经验来看，Swift的许多部分都会很熟悉。

Swift提供了所有基本C和Objective-C类型的自己的版本，包括用于整数的`Int`、用于浮点值的`Double`和`Float`、用于布尔值的`Bool`和用于文本数据的`String`。Swift还提供了三种主要集合类型的强大版本，`Array`、`Set`和`Dictionary`，如[集合类型](https://docs.swift.org/swift-book/LanguageGuide/CollectionTypes.html)中所述。

与C一样，Swift使用变量通过标识名称存储和引用值。Swift还广泛使用值无法更改的变量。这些被称为常数，比C中的常数强大得多。在整个 Swift 中，常量会使用，使代码在处理不需要更改的值时更加安全、更清晰。

除了熟悉的类型外，Swift还引入了Objective-C中没有的高级类型，例如元组。元组使您能够创建和传递值分组。您可以使用元组从函数中返回多个值作为单个复合值。

Swift还引入了可选类型，用于处理值缺失的情况。可选内容要么说“有一个值，它等于*x*”或“*根本没有*值”。使用可选类似于在Objective-C中使用`nil`和指针，但它们适用于任何类型，而不仅仅是类。可选选项不仅比Objective-C中的`nil`指针更安全、更具表现力，而且是Swift许多最强大功能的核心。

Swift 是一种*类型安全的*语言，这意味着该语言可帮助您清楚地了解代码可以使用的值类型。如果您的部分代码需要`String`，则类型安全可以防止您错误地传递给`Int`。同样，类型安全可防止您意外地将可选`String`传递给需要非可选`String`的代码。类型安全可帮助您在开发过程中尽早捕获和修复错误。

## 常量和变量(Constants and Variables)

常量和变量将名称（如`maximumNumberOfLoginAttempts`或`welcomeMessage`）与特定类型的值（如数字`10`或字符串`"Hello"`相关联。*常量*的值一旦设置就无法更改，而*变量*将来可以设置为不同的值。

### 声明常量和变量

常量和变量在使用之前必须声明。您可以使用`let`关键字声明常量，并使用`var`关键字声明变量。以下是如何使用常量和变量来跟踪用户尝试登录次数的示例：

```swift
let maximumNumberOfLoginAttempts = 10
var currentLoginAttempt = 0
```

此代码可以读作：

“声明一个名为`maximumNumberOfLoginAttempts`的新常量，并给它的值10。然后，声明一个名为`currentLoginAttempt`的新变量，并给它一个初始值`0`。”

在本例中，允许的最大登录尝试次数被声明为常量，因为最大值永远不会改变。当前登录尝试计数器声明为变量，因为每次登录尝试失败后，此值必须递增。

您可以在一行上声明多个常量或多个变量，用逗号分隔：

```swift
var x = 0.0, y = 0.0, z = 0.0
```

> 注意
>
> 如果代码中的存储值不会更改，请始终将其声明为带有`let`关键字的常量。仅使用变量来存储需要能够更改的值。

### 类型注释

您可以在声明常量或变量时提供*类型注释*，以明确常量或变量可以存储的值类型。通过在常量或变量名称后放置冒号，后跟空格，后跟要使用的类型名称来编写类型注释。

此示例为名为`welcomeMessage`的变量提供了一个类型注释，以指示该变量可以存储`String`值：

```swift
var welcomeMessage: String
```

声明中的冒号的意思是“类型......”，因此上面的代码可以理解为：

“Declare a variable called `welcomeMessage` that’s of type `String`.”

“`String`类型”一词的意思是“可以存储任何`String`值”。把它想象成“可以存储的东西的类型”（或“东西的类型”）。

`welcomeMessage`变量现在可以设置为任何字符串值，没有错误：

```swift
welcomeMessage = "Hello"
```

您可以在一行上定义同一类型的多个相关变量，用逗号分隔，并在最终变量名称后面添加单个类型注释：

```swift
var red, green, blue: Double
```

> 注意
>
> 在实践中，您很少需要编写类型注释。如果您在定义的点为常量或变量提供初始值，Swift几乎总是可以推断用于该常量或变量的类型，如[类型安全和类型推断中](https://docs.swift.org/swift-book/LanguageGuide/TheBasics.html#ID322)所述。在上面的`welcomeMessage`示例中，没有提供初始值，因此`welcomeMessage`变量的类型用类型注释指定，而不是从初始值推断。

### 命名常量和变量

常量和变量名几乎可以包含任何字符，包括Unicode字符：

```swift
let π = 3.14159
let 你好 = "你好世界"
let 🐶🐮 = "dogcow"
```

常量和变量名称不能包含空格字符、数学符号、箭头、私人使用的Unicode标量值或线条和框绘制字符。它们也不能以数字开头，尽管数字可能包含在名称的其他地方。

一旦您声明了特定类型的常量或变量，您就无法以相同名称再次声明它，也无法将其更改为存储其他类型的值。您也不能将常量更改为变量或将变量更改为常量。

> 注意
>
> 如果您需要为常量或变量提供与保留的Swift关键字相同的名称，请在将关键字用作名称时用反勾（`）包围该关键字。但是，除非您完全别无选择，否则请避免使用关键字作为名称。

您可以将现有变量的值更改为兼容类型的另一个值。在本例中， `friendlyWelcome` 的值从 `"Hello!"` 改变成了 `"Bonjour!"`:

```swift
1. var friendlyWelcome = "Hello!"
2. friendlyWelcome = "Bonjour!"
3. // friendlyWelcome is now "Bonjour!"
```

与变量不同，常量的值在设置后无法更改。编译代码时，尝试这样做将报告为错误：

```swift
1. let languageName = "Swift"
2. languageName = "Swift++"
3. // This is a compile-time error: languageName cannot be changed.
```

### 打印常量和变量

您可以使用`print(_:separator:terminator:)`函数打印常量或变量的当前值：

```swift
print(friendlyWelcome)
// Prints "Bonjour!"
```

`print(_:separator:terminator:)`函数是一个全局函数，将一个或多个值打印到适当的输出。例如，在Xcode中，`print(_:separator:terminator:)`函数在Xcode的“控制台”窗格中打印其输出。`separator`和`terminator`参数具有默认值，因此您可以在调用此函数时省略它们。默认情况下，该函数通过添加换行符来终止其打印的行。要打印后没有换行符的值，请传递一个空字符串作为终止符——例如，`print(someValue,terminator:"")`。有关具有默认值的参数的信息，请参阅[默认参数值](https://docs.swift.org/swift-book/LanguageGuide/Functions.html#ID169)。

Swift使用*字符串插值*将常量或变量的名称作为占位符包含在较长的字符串中，并提示Swift将其替换为该常量或变量的当前值。将名称包装在括号中，并在开头括号前用反斜杠转义：

```swift
print("The current value of friendlyWelcome is \(friendlyWelcome)")
// Prints "The current value of friendlyWelcome is Bonjour!"
```

> 注意
>
> 可用于字符串插值的所有选项都在[字符串插值](https://docs.swift.org/swift-book/LanguageGuide/StringsAndCharacters.html#ID292)中描述。

## 注释

使用注释在您的代码中包含不可执行的文本，作为对您自己的便条或提醒。编译代码时，Swift编译器会忽略注释。

Swift 中的注释与 C 中的注释非常相似。单行注释以两个正斜杠（`//`）开头：

```swift
// This is a comment.
```

多行注释以前斜杠后跟星号（`/*`）开始，以星号后跟前斜杠（`*/`）结束：

```swift
/* This is also a comment
but is written over multiple lines. */
```

与C中的多行注释不同，Swift中的多行注释可以嵌套在其他多行注释中。您可以通过启动多行注释块，然后在第一个块中启动第二个多行注释来编写嵌套注释。然后关闭第二个块，然后是第一个块：

```swift
/* This is the start of the first multiline comment.
/* This is the second, nested multiline comment. */
This is the end of the first multiline comment. */
```

嵌套的多行注释使您可以快速轻松地注释大块代码，即使代码已经包含多行注释。

## 分号(;)

与许多其他语言不同，Swift不要求您在代码中的每个语句后编写分号（`;`），尽管如果您愿意，您可以这样做。但是，如果您想在一行上写多个单独的语句，*则*需要分号：

```swift
let cat = "🐱"; print(cat)
// Prints "🐱"
```

## 整数(Integers)

*整数*是没有小数分量的整数，例如`42`和`-23`。整数要么是*有符号*（正数、零或负数），要么*无符号*（正数或零）。

Swift以8、16、32和64位形式提供有符号和无符号整数。这些整数遵循类似于C的命名约定，即8位无符号整数类型为`UInt8`，32位有符号整数类型为`Int32`。与 Swift 中的所有类型一样，这些整数类型都有大写名称。

### 整数边界(Integer Bounds)

您可以访问每种整数类型的最小值和最大值及其`min`和`max`：

```swift
let minValue = UInt8.min  // minValue is equal to 0, and is of type UInt8
let maxValue = UInt8.max  // maxValue is equal to 255, and is of type UInt8
```

这些属性的值是适当大小的数字类型（如上面示例中的`UInt8`），因此可以与相同类型的其他值一起用于表达式。

### Int

在大多数情况下，您不需要选择特定大小的整数来在代码中使用。Swift提供了一种额外的整数类型`Int`，其大小与当前平台的原生单词大小相同：

- 在32位平台上，`Int`与`Int32`的大小相同。
- 在64位平台上，`Int`与`Int64`的大小相同。

除非您需要使用特定大小的整数，否则请始终使用`Int`来处理代码中的整数值。这有助于代码一致性和互操作性。即使在32位平台上，`Int`也可以存储在`-2,147,483,648`和`2,147,483,647`之间的任何值，并且对于许多整数范围来说足够大。

### UInt

Swift还提供了一种无符号整数类型`UInt`，其大小与当前平台的原生单词大小相同：

- 在32位平台上，`UInt`与`UInt32`的大小相同。
- 在64位平台上，`UInt`与`UInt64`的大小相同。

> 注意
>
> 仅当您特别需要与平台原生单词大小相同的无符号整数类型时，才使用`UInt`。如果不是这样，最好是`Int`，即使已知要存储的值是非负值。一致地使用`Int`进行整数值有助于代码互操作性，避免在不同数字类型之间转换，并匹配整数类型推断，如[类型安全和类型推断](https://docs.swift.org/swift-book/LanguageGuide/TheBasics.html#ID322)所述。

## 浮点数

*浮点数*是具有小数分量的数字，如`3.14159`、`0.1`和`-273.15`。

浮点类型可以表示比整数类型更广泛的值范围，并且可以存储比`Int`中存储的要大得多或小得多的数字。Swift提供了两种有符号浮点数类型：

- `Double`表示64位浮点数。
- `Float`表示32位浮点数。

> 注意
>
> `Double`精度至少为小数点后15位，而`Float`的精度可以小到小数点后6位。要使用的合适浮点类型取决于您需要在代码中使用的值的性质和范围。在这两种类型合适的情况下，首选`Double`。

## 类型安全和类型推断

Swift是一种*类型安全的*语言。类型安全语言鼓励您明确代码可以使用的值类型。如果您的部分代码需要`String`，则不能错误地将其传递给`Int`。

由于Swift是类型安全的，它在编译代码时执行*类型检查，*并将任何不匹配的类型标记为错误。这使您能够尽早在开发过程中捕获和修复错误。

类型检查可帮助您在处理不同类型的值时避免错误。然而，这并不意味着您必须指定您声明的每个常量和变量的类型。如果您没有指定所需的值类型，Swift会使用*类型推断*来计算适当的类型。类型推断使编译器在编译代码时能够自动推断特定表达式的类型，只需检查您提供的值。

由于类型推断，Swift需要的类型声明比C或Objective-C等语言少得多。常量和变量仍然是显式类型，但指定其类型的大部分工作都是为您完成的。

当您声明具有初始值的常量或变量时，类型推断特别有用。这通常通过在您声明常量或变量时为常量或变量分配*字面值*（或*字面值*）来完成。（字面值是直接出现在源代码中的值，例如以下示例中的`42`和`3.14159`。）

例如，如果您在不说明类型的情况下为新常量分配`42`的字面值，Swift推断您希望该常量为`Int`，因为您已经用一个看起来像整数的数字初始化了它：

```swift
let meaningOfLife = 42
// meaningOfLife is inferred to be of type Int
```

同样，如果您没有为浮点文字指定类型，Swift推断您想创建一个`Double`：

```swift
let pi = 3.14159
// pi is inferred to be of type Double
```

Swift在推断浮点数类型时总是选择`Double`（而不是`Float`）。

如果您在表达式中组合整数和浮点文字，则将从上下文中推断出一种`Double`类型：

```swift
let anotherPi = 3 + 0.14159
// anotherPi is also inferred to be of type Double
```

`3`的字面值本身没有显式类型，因此从浮点字面值的存在中推断出适当的`Double`输出类型作为加法的一部分。

## 数字文字

整数文字可以写成：

- 没有前缀*的小数*
- 带有`0b`前缀的*二进制*数字
- 一个*八度*数，前缀为`0o`
- *十六进制*数字，前缀为`0x`

所有这些整数文字的十进制值为`17`：

```swift
let decimalInteger = 17
let binaryInteger = 0b10001       // 17 in binary notation
let octalInteger = 0o21           // 17 in octal notation
let hexadecimalInteger = 0x11     // 17 in hexadecimal notation
```

浮点文字可以是十进制（没有前缀）或十六进制（带有`0x`前缀）。它们必须在小数点的两侧始终有一个数字（或十六进制数字）。十进制浮点数也可以有一个可选的*指数*，用大写或小写`e`表示；十六进制浮点必须有一个指数，用大写或小写`p`表示。

对于指数为`exp`的小数，基数乘以10exp：

- `1.25e2`意思是1.25 x 102，或`125.0`。
- `1.25e-2`意思是1.25 x 10-2，或`0.0125`。

对于指数为`exp`的十六进制数字，基数乘以2exp：

- `0xFp2`意思是15 x 22或`60.0`。
- `0xFp-2`意思是15 x 2-2，或`3.75`。

所有这些浮点文字的十进制值为`12.1875`：

```swift
let decimalDouble = 12.1875
let exponentDouble = 1.21875e1
let hexadecimalDouble = 0xC.3p0
```

数字文字可以包含额外的格式，使其更容易阅读。整数和浮点数都可以用额外的零填充，并可以包含下划线，以帮助提高可读性。这两种格式都不会影响文字的基本值：

```swift
let paddedDouble = 000123.456
let oneMillion = 1_000_000
let justOverOneMillion = 1_000_000.000_000_1
```

## 数字类型转换

对于代码中的所有通用整数常量和变量，即使已知它们是非负数，也请使用`Int`类型。在日常情况下使用默认整数类型意味着整数常量和变量在您的代码中立即互操作，并将与整数字面值的推断类型匹配。

仅在手头任务特别需要时使用其他整数类型，因为外部来源的数据显式大小，或用于性能、内存使用或其他必要的优化。在这些情况下，使用显式大小的类型有助于捕获任何意外值溢出，并隐式记录所用数据的性质。

### 整数转换

可以存储在整数常数或变量中的数字范围因每种数字类型而异。`Int8`常量或变量可以存储`-128`和`127`之间的数字，而`UInt8`常量或变量可以存储`0`到`255`之间的数字。编译代码时，不适合大小整数类型的常量或变量的数字将报告为错误：

```swift
let cannotBeNegative: UInt8 = -1
// UInt8 can't store negative numbers, and so this will report an error
let tooBig: Int8 = Int8.max + 1
// Int8 can't store a number larger than its maximum value,
// and so this will also report an error
```

由于每种数字类型可以存储不同范围的值，因此您必须根据具体情况选择数字类型转换。这种选择加入方法可以防止隐藏的转换错误，并有助于在代码中明确类型转换意图。

要将一种特定数字类型转换为另一种特定数字类型，请使用现有值初始化所需类型的新数字。在下面的示例中，常量`twoThousand`是类型`UInt16`，而常数是`UInt8`类型。它们不能直接添加在一起，因为它们不是同一类型。相反，此示例调用`UInt16(one)`创建一个新的`UInt16`，初始化为`one`，并使用此值代替原始值：

```swift
let twoThousand: UInt16 = 2_000
let one: UInt8 = 1
let twoThousandAndOne = twoThousand + UInt16(one)
```

由于添加的两侧现在都是`UInt16`类型，因此允许添加。输出常数（`twoThousandAndOne`）被推断为`UInt16`类型，因为它是两个`UInt16`值的总和。

`SomeType(ofInitialValue)`是调用Swift类型的初始化器并传递初始值的默认方式。在幕后，`UInt16`有一个接受`UInt8`值的初始化器，因此此初始化器用于从现有的`UInt8`制作新的`UInt16`。然而，您不能在这里传递*任何*类型——它必须是`UInt16`提供初始化器的类型。扩展涵盖了扩展现有类型以提供接受新类型（包括您自己的类型定义）的初始化[器](https://docs.swift.org/swift-book/LanguageGuide/Extensions.html)。

### 整数和浮点转换

整数和浮点数字类型之间的转换必须明确：

```swift
let three = 3
let pointOneFourOneFiveNine = 0.14159
let pi = Double(three) + pointOneFourOneFiveNine
// pi equals 3.14159, and is inferred to be of type Double
```

在这里，常数`three`的值用于创建`Double`类型的新值，以便加法的两侧都是相同的类型。如果没有这种转换，将不允许添加。

浮点到整数转换也必须明确。整数类型可以用`Double`或`Float`值初始化：

```swift
let integerPi = Int(pi)
// integerPi equals 3, and is inferred to be of type Int
```

当用于以这种方式初始化新的整数值时，浮点值总是被截断。这意味着`4.75`变成4，`-3.9`变成`-3`。

> 注意
>
> 组合数字常数和变量的规则与数字文字的规则不同。字面值`3`可以直接添加到字面值`0.14159`中，因为数字文字本身没有显式类型。只有在编译器评估它们时，才会推断出它们的类型。

## 类型别名

*类型别名*定义了现有类型的替代名称。您可以使用`typealias`关键字定义类型别名。

当您想用上下文更合适的名称引用现有类型时，例如在处理来自外部来源的特定大小的数据时，类型别名非常有用：

```swift
typealias AudioSample = UInt16
```

定义类型别名后，您可以在可能使用原始名称的任何地方使用别名：

```swift
var maxAmplitudeFound = AudioSample.min
// maxAmplitudeFound is now 0
```

在这里，`AudioSample`被定义为`UInt16`的别名。由于它是一个别名，对`AudioSample.min`的调用实际上调用`UInt16.min`，它为`maxAmplitudeFound`变量提供了初始值`0`。

## 布尔值(Booleans)

Swift有一个基本的*布尔*类型，称为`Bool`。布尔值被称为*逻辑值*，因为它们只能是真或假。Swift提供了两个布尔常量值，`true`和`false`：

```swift
let orangesAreOrange = true
let turnipsAreDelicious = false
```

 `orangesAreOrange` 和 `turnnipsaredelicious` 的类型被推断为`Bool`，因为它们是用布尔值初始化的。与上面的' Int '和' Double '一样，如果你在创建常量或变量时将它们设置为' true '或' false '，你就不需要将它们声明为' Bool '。当Swift使用其他已知类型的值初始化常量或变量时，类型推断有助于使代码更加简洁和可读。

当您使用条件语句（如`if`语句）时，布尔值特别有用：

```swift
if turnipsAreDelicious {
    print("Mmm, tasty turnips!")
} else {
    print("Eww, turnips are horrible.")
}
// Prints "Eww, turnips are horrible."
```

[Control Flow](/pages/24ff35/)更详细地介绍了条件语句，如`if`语句。

Swift的类型安全防止非布尔值被替换为`Bool`。以下示例报告编译时错误：

```swift
let i = 1
if i {
    // this example will not compile, and will report an error
}
```

然而，下面的替代示例是有效的：

```swift
let i = 1
if i == 1 {
​    // this example will compile successfully
}
```

The result of the `i == 1` comparison is of type `Bool`, and so this second example passes the type-check. Comparisons like `i == 1` are discussed in [Basic Operators](https://docs.swift.org/swift-book/LanguageGuide/BasicOperators.html).

与 Swift 中的其他类型安全示例一样，这种方法可以避免意外错误，并确保特定代码部分的意图始终清晰。

## 元组

*元组*将多个值分组为单个复合值。元组中的值可以是任何类型，不必是彼此相同的类型。

在本例中，`(404,"NotFound")`是描述*HTTP状态代码*的元组。HTTP状态代码是Web服务器在请求网页时返回的特殊值。如果您请求不存在的网页，则返回`404NotFound`的状态代码。

```swift
let http404Error = (404, "Not Found")
// http404Error is of type (Int, String), and equals (404, "Not Found")
```

`(404,"NotFound")`元组将一个`Int`和一个`String`组合在一起，为HTTP状态代码提供两个单独的值：数字和人类可读描述。它可以被描述为“类型元组`(Int,String)`”。

您可以从任何类型的排列中创建元组，它们可以包含任意数量的不同类型。没有什么可以阻止您拥有类型元组`(Int,Int,Int)`或`(String,Bool)`或者您所需的任何其他排列。

您可以将元组的内容*分解*为单独的常量或变量，然后像往常一样访问：

```swift
let (statusCode, statusMessage) = http404Error
print("The status code is \(statusCode)")
// Prints "The status code is 404"
print("The status message is \(statusMessage)")
// Prints "The status message is Not Found"
```

如果您只需要元组的一些值，请在分解元组时忽略带下划线（`_`）的元组部分：

```swift
let (justTheStatusCode, _) = http404Error
print("The status code is \(justTheStatusCode)")
// Prints "The status code is 404"
```

或者，使用从零开始的索引号访问元组中的单个元素值：

```swift
print("The status code is \(http404Error.0)")
// Prints "The status code is 404"
print("The status message is \(http404Error.1)")
// Prints "The status message is Not Found"
```

当定义元组时，您可以命名元组中的单个元素：

```swift
let http200Status = (statusCode: 200, description: "OK")
```

如果您命名元组中的元素，则可以使用元素名称访问这些元素的值：

```swift
print("The status code is \(http200Status.statusCode)")
// Prints "The status code is 200"
print("The status message is \(http200Status.description)")
// Prints "The status message is OK"
```

元组作为函数的返回值特别有用。尝试检索网页的函数可能会返回`(Int,String)`元组类型，以描述页面检索的成功或失败。通过返回具有两个不同值的元组，每个值都具有不同的类型，该函数提供了有关其结果的更有用的信息，而不是只能返回单个类型的单个值。有关更多信息，请参阅[具有多个返回值的函数](https://docs.swift.org/swift-book/LanguageGuide/Functions.html#ID164)。

> 注意
>
> 元组对简单的相关值组非常有用。它们不适合创建复杂的数据结构。如果您的数据结构可能更复杂，请将其建模为类或结构，而不是元组。有关更多信息，请参阅[结构和类](https://docs.swift.org/swift-book/LanguageGuide/ClassesAndStructures.html)。

## 可选

在值可能不存在的情况下，您可以使用*可选选项*。可选代表两种可能性：要么有一个值，你可以解开可选值来访问该值，要么根本没有值。

> 注意
>
> C或Objective-C中不存在可选概念。Objective-C中最近的东西是能够从否则会返回对象的方法返回`nil`，`nil`的意思是“没有有效的对象”。然而，这仅适用于对象，不适用于结构、基本C类型或枚举值。对于这些类型，Objective-C方法通常会返回一个特殊值（如`NSNotFound`），以指示没有值。这种方法假设方法的调用者知道有一个特殊值需要测试，并记得检查它。Swift的可选选项允许您指示*任何类型的*值，而无需特殊常量。

以下是如何使用可选选项来应对值缺失的示例。Swift的sInt类型有一个初始化器，尝试将`String`值转换为`Int`值。然而，并非每个字符串都可以转换为整数。字符串`"123"`可以转换为数字值`123`，但字符串`"hello,world"`没有明显的数字值可以转换到。

下面的示例使用初始化器尝试将`String`转换为`Int`：

```swift
let possibleNumber = "123"
let convertedNumber = Int(possibleNumber)
// convertedNumber is inferred to be of type "Int?", or "optional Int"
```

由于初始化器可能会失败，它返回一个*可选*的`Int`，而不是一个`Int`。可选的`Int`写成`Int?`，而不是`Int`。问号表示它包含的值是可选的，这意味着它可能包含*一些*`Int`值，或者它可能*根本不*包含*任何值*。（它不能包含任何其他内容，例如`Bool`值或`String`值。它要么是`Int`，要么什么都不是。）

### nil

您可以通过为特殊值`nil`将其设置为无值状态的可选变量：

```swift
var serverResponseCode: Int? = 404
// serverResponseCode contains an actual Int value of 404
serverResponseCode = nil
// serverResponseCode now contains no value
```

> 注意
>
> 您不能将`nil`与非可选常量和变量一起使用。如果代码中的常量或变量在某些条件下需要在没有值的情况下工作，请始终将其声明为适当类型的可选值。

如果您在不提供默认值的情况下定义可选变量，该变量将自动设置为`nil`：

```swift
var surveyAnswer: String?
// surveyAnswer is automatically set to nil
```

> 注意
>
> Swift的“nil”和Objective-C中的“nil”不一样。在Objective-C中，' nil '是一个指向不存在对象的指针。在Swift中，' nil '不是一个指针——它是一个特定类型的值的缺失。任何类型的可选参数都可以设置为nil，而不仅仅是对象类型。

### 如果陈述和强制打开包装

你可以使用' if '语句，通过比较可选的和' nil '来确定可选的是否包含一个值。可以使用“等于”操作符(' == ')或“不等于”操作符(' != ')执行此比较。

如果可选选项具有值，则将其视为“不等于”`nil`：

```swift
if convertedNumber != nil {
   print("convertedNumber contains some integer value.")
}
// Prints "convertedNumber contains some integer value."
```

一旦您确定可选内容*确实*包含一个值，您可以通过添加感叹号来访问其基础值（`!`）直到可选名称的末尾。感叹号有效地说：“我知道这个可选肯定有价值；请使用它。”这被称为*强制打开*可选值：

```swift
if convertedNumber != nil {
   print("convertedNumber has an integer value of \(convertedNumber!).")
}
// Prints "convertedNumber has an integer value of 123."
```

有关`if`语句的更多信息，请参阅[控制流](https://docs.swift.org/swift-book/LanguageGuide/ControlFlow.html)。

> 注意
>
> 尝试使用`!`访问不存在的可选值会触发运行时错误。在使用之前，请务必确保可选选项包含非`nil`值`!`强行打开它的价值。

### 可选绑定

你可以使用*可选绑定*来确定一个可选绑定是否包含一个值，如果是，则将该值用作临时常量或变量。可选绑定可以与' if '和' while '语句一起使用，以检查可选绑定中的值，并将该值提取到一个常量或变量中，作为单个操作的一部分。“if”和“while”语句在[Control Flow](/pages/24ff35/)中有更详细的描述。

为`if`语句编写可选绑定，如下所示：

```swift
if let constantName = someOptional {
   statements
}
```

您可以从[可选](https://docs.swift.org/swift-book/LanguageGuide/TheBasics.html#ID330)部分重写`possibleNumber`示例，以使用可选绑定而不是强制展开包装：

```swift
if let actualNumber = Int(possibleNumber) {
   print("The string \"\(possibleNumber)\" has an integer value of \(actualNumber)")
} else {
   print("The string \"\(possibleNumber)\" couldn't be converted to an integer")
}
// Prints "The string "123" has an integer value of 123"
```

此代码可以读作：

“如果`Int(possibleNumber)`返回的可选`Int`包含一个值，请将名为`actualNumber`的新常量设置为可选值。”

如果转换成功，`actualNumber`常量可以在`if`语句的第一个分支中使用。它已经用可选中包含的值初始化，因此您不使用`!`后缀以访问其值。在本例中，`actualNumber`仅用于打印转换结果。

可以使用带有可选绑定的常量和变量。如果你想在' If '语句的第一个分支中操作' actualNumber '的值，你可以写' If var actualNumber '代替，而包含在可选的值将作为一个变量而不是一个常量可用。

您可以根据需要在单个`if`语句中包含尽可能多的可选绑定和布尔条件，并用逗号分隔。如果可选绑定中的任何值为`nil`，或者任何布尔条件计算为`false`，则整个`if`语句的条件被视为`false`。`if`陈述等效，请按以下方式处理：

```swift
if let firstNumber = Int("4"), let secondNumber = Int("42"), firstNumber < secondNumber && secondNumber < 100 {
   print("\(firstNumber) < \(secondNumber) < 100")
}
// Prints "4 < 42 < 100"

if let firstNumber = Int("4") {
   if let secondNumber = Int("42") {
       if firstNumber < secondNumber && secondNumber < 100 {
           print("\(firstNumber) < \(secondNumber) < 100")
       }
   }
}
// Prints "4 < 42 < 100
```

> 注意
>
> 在`if`语句中使用可选绑定创建的常量和变量仅在`if`语句的正文中可用。相比之下，使用`guard`语句创建的常量和变量可以在`guard`语句后面的代码行中找到，如[Early Exit](https://docs.swift.org/swift-book/LanguageGuide/ControlFlow.html#ID525)所述。

### 隐式拆开的可选

如上所述，可选表示允许常量或变量“无值”。可选选项可以用`if`语句检查，看看是否存在值，并且可以使用可选绑定有条件地展开，以访问可选值（如果存在）。

有时，从程序的结构中可以清楚地看到，在首次设置该值后，可选值将*始终*具有该值。在这些情况下，每次访问可选值时，无需检查和打开其值，因为可以安全地假设它一直具有值。

这些类型的可选选项被定义为*隐式未包装的可选选项*。您通过放置感叹号（`String!`）来编写隐式打开的可选选项而不是问号（`String?`）在您想要选择的类型之后。使用时，不要在可选名称后放置感叹号，而是在声明选项类型后放置感叹号。

当可选值在首次定义可选后立即确认存在时，隐式未包装的可选值非常有用，并且可以肯定可以假设在此后的每个点都存在。Swift中隐式未包装的可选选项的主要用途是在类初始化期间，如[Unowned References和Imlicitly Unwrapped Optional Properties](https://docs.swift.org/swift-book/LanguageGuide/AutomaticReferenceCounting.html#ID55)中所述。

隐式展开的可选选项是幕后正常的可选选项，但也可以像非可选值一样使用，而无需每次访问时解开可选值。以下示例显示了可选字符串和隐式未包装的可选字符串在以显式`String`的形式访问其包装值时的行为差异：

```swift
let possibleString: String? = "An optional string."
let forcedString: String = possibleString! // 需要一个感叹号

let assumedString: String! = "An implicitly unwrapped optional string."
let implicitString: String = assumedString // 不需要感叹号
```

您可以将隐式解封的可选选项视为在需要时强制打开可选选项。当您使用隐式展开的可选值时，Swift首先尝试将其用作普通的可选值；如果不能用作可选值，Swift将强制解开该值。在上面的代码中，可选值 `assumedString`在将其值分配给`implicitString`之前被强制解开，因为`implicitString`具有显式、非可选类型的`String`。在下面的代码中，`optionalString`没有显式类型，因此它是普通的可选。

```swift
let optionalString = assumedString
// optionalString的类型是“String?”，而assumedString不强制解包装。
```

如果隐式解包的可选选项为`nil`，并且您尝试访问其包装值，您将触发运行时错误。结果与您在不包含值的正常可选选项后放置感叹号完全相同。

您可以检查隐式未包装的可选选项是否为`nil`，就像检查正常可选选项一样：

```swift
if assumedString != nil {
   print(assumedString!)
}
// Prints "隐式解除包装的可选字符串。"
```

您还可以使用带有可选绑定的隐式解包装可选选项，在单个语句中检查和解包装其值：

```swift
if let definiteString = assumedString {
   print(definiteString)
}
// Prints "An implicitly unwrapped optional string."
```

> 注意
>
> 当变量以后可能变成`nil`，不要使用隐式未包装的可选选项。如果您需要在变量生命周期内检查`nil`值，请始终使用正常的可选类型。

## 错误处理

您使用*错误处理*来响应程序在执行过程中可能遇到的错误条件。

与可选选项不同，后者可以使用值的存在或不存在来传达函数的成功或失败，与之相反，错误处理允许您确定失败的根本原因，并在必要时将错误传播到程序的另一部分。

当函数遇到错误条件时，它会*抛出*错误。然后，该函数的调用者可以*捕获*错误并做出适当的响应。

```swift
func canThrowAnError() throws {
   // 这个函数可能抛出错误，也可能不抛出错误
}
```

函数表示可以通过在其声明中包含`throws`关键字来抛出错误。当您调用可以抛出错误的函数时，您将`try`关键字之前置于表达式。

Swift会自动将错误传播到当前范围之外，直到它们由`catch`子句处理。

```swift
do {
   try canThrowAnError()
   // no error was thrown
} catch {
   // an error was thrown
}
```

`do`语句创建一个新的包含范围，允许将错误传播到一个或多个`catch`子句。

以下是如何使用错误处理来响应不同错误条件的示例：

```swift
func makeASandwich() throws {
   // ...
}

do {
   try makeASandwich()
   eatASandwich()
} catch SandwichError.outOfCleanDishes {
   washDishes()
} catch SandwichError.missingIngredients(let ingredients) {
   buyGroceries(ingredients)
}
```

在本例中，如果没有干净的菜肴或缺少任何成分，`makeASandwich()`函数将抛出错误。由于`makeASandwich()`可以抛出错误，函数调用被包装在`try`表达式中。通过将函数调用包装在`do`语句中，抛出的任何错误都将传播到提供的`catch`子句。

如果没有抛出错误，则调用`eatASandwich()`函数。如果抛出错误，并且与`SandwichError.outOfCleanDishes`情况匹配，则将调用`washDishes()`函数。如果抛出错误，并且它与`SandwichError.missingIngredients`的情况匹配，则使用`catch`模式捕获的关联`[String]`值调用`buyGroceries(_:)`函数。

[错误处理](https://docs.swift.org/swift-book/LanguageGuide/ErrorHandling.html)中更详细地介绍了抛出、捕获和传播错误。

## 断言和先决条件

*断言*和*先决条件*是在运行时发生的检查。在执行任何进一步的代码之前，您可以使用它们来确保满足基本条件。如果断言或先决条件中的布尔条件计算为`true`，则代码执行将照常继续。如果条件计算为`false`，则程序的当前状态无效；代码执行结束，您的应用程序被终止。

您使用断言和先决条件来表达您在编码时所做的假设和期望，因此您可以将它们包含在代码中。断言可帮助您在开发过程中发现错误和错误的假设，先决条件可帮助您检测生产中的问题。

除了在运行时验证您的期望外，断言和先决条件也成为代码中有用的文档形式。与上面[错误处理](https://docs.swift.org/swift-book/LanguageGuide/TheBasics.html#ID515)中讨论的错误条件不同，断言和先决条件不用于可恢复或预期错误。由于失败的断言或先决条件表示无效的程序状态，因此无法捕获失败的断言。

使用断言和先决条件不能替代以不太可能出现无效条件的方式设计代码。然而，使用它们来强制执行有效数据和状态会导致您的应用程序在发生无效状态时更可预测地终止，并有助于使问题更容易调试。一旦检测到无效状态就停止执行也有助于限制该无效状态造成的损害。

断言和先决条件之间的区别在于它们被检查时：断言仅在调试构建中检查，但先决条件在调试和生产构建中都被检查。在生产构建中，不评估断言中的条件。这意味着您可以在开发过程中使用任意数量的断言，而不会影响生产性能。

### 使用断言进行调试

您通过从Swift标准库调用[`assert(_:_:file:line:)`](https://developer.apple.com/documentation/swift/1541112-assert)函数来编写断言。您传递此函数，一个计算为`true`或`false`表达式，如果条件的结果为`false`，则显示一条消息。例如：

```swift
let age = -3
assert(age >= 0, "A person's age can't be less than zero.")
// 这个断言失败，因为-3不是>= 0。
```

在本例中，如果' age >= 0 '的值为' true '，也就是说，如果' age '的值是非负的，则代码继续执行。如果' age '的值为负值，如上面的代码所示，那么' age >= 0 '的计算结果为' false '，断言将失败，从而终止应用程序。

您可以省略断言消息——例如，当它只是作为散文重复条件时。

```swift
assert(age >= 0)
```

如果代码已经检查了条件，则使用[' assertionFailure(:file:line:) '](https://developer.apple.com/documentation/swift/1539616-assertionfailure)function表示断言失败。例如:

```swift
if age > 10 {
   print("You can ride the roller-coaster or the ferris wheel.")
} else if age >= 0 {
   print("You can ride the ferris wheel.")
} else {
   assertionFailure("A person's age can't be less than zero.")
}
```

### 执行先决条件

每当条件可能为假时，请使用先决条件，但您的代码必须是真的才能继续执行。例如，使用先决条件检查下标没有越界，或检查函数是否传递了有效值。

您可以通过调用[`precondition(_:_:file:line:)`](https://developer.apple.com/documentation/swift/1540960-precondition)函数编写先决条件。您传递此函数，一个计算为`true`或`false`表达式，如果条件的结果为`false`，则显示一条消息。例如：

```swift
// 在下标的实现中…
precondition(index > 0, "Index must be greater than zero.")
```

您还可以调用[`preconditionFailure(_:file:line:)`](https://developer.apple.com/documentation/swift/1539374-preconditionfailure)函数来指示发生了故障——例如，如果采用了交换机的默认情况，但所有有效的输入数据都应该由交换机的其他情况之一处理。

> 注意
>
> 如果您以未选中模式（`-Ounchecked`编译，则不会检查先决条件。编译器假设先决条件始终为真，并相应地优化您的代码。然而，无论优化设置如何，thefatalError`fatalError(_:file:line:)`函数总是停止执行。
>
> 您可以在原型和早期开发期间使用`fatalError(_:file:line:)`函数，通过编写`fatalError("Unimplemented")`作为存根实现，为尚未实现的功能创建存根。由于致命错误永远不会被优化，与断言或先决条件不同，您可以确保如果遇到存根实现，执行总是会停止。