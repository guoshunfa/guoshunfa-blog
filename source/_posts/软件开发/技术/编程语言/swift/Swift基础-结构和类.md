---
title: Swift基础 结构和类
tags:
    - swift
    - 基础
categories:
    - 技术
date: 2022-07-01 12:01:01
thumbnail:
---

翻译自：https://docs.swift.org/swift-book/LanguageGuide/ClassesAndStructures.html

*结构*和*类*是通用的、灵活的结构，成为程序代码的构建块。您定义属性和方法，使用定义常量、变量和函数的相同语法为结构和类添加功能。

与其他编程语言不同，Swift不要求您为自定义结构和类创建单独的接口和实现文件。在Swift中，您在单个文件中定义结构或类，该类或结构的外部接口会自动供其他代码使用。

> 注意
>
> 类的实例传统上被称为*对象*。然而，与其他语言相比，Swift结构和类的功能要接近得多，本章的大部分内容描述了适用于类或结构类型的实例的功能。因此，使用了更通用的术语*实例*。

## 比较结构和类

Swift中的结构和类有很多共同点。两者都可以：

- 定义属性以存储值
- 定义提供功能的方法
- 定义下标，以使用下标语法提供对其值的访问
- 定义初始化器以设置其初始状态
- 扩展以将其功能扩展到默认实现之外
- 符合协议，提供某种类型的标准功能

有关更多信息，请参阅[属性](https://docs.swift.org/swift-book/LanguageGuide/Properties.html)、[方法](https://docs.swift.org/swift-book/LanguageGuide/Methods.html)、[下标](https://docs.swift.org/swift-book/LanguageGuide/Subscripts.html)、[初始化](https://docs.swift.org/swift-book/LanguageGuide/Initialization.html)、[扩展](https://docs.swift.org/swift-book/LanguageGuide/Extensions.html)和[协议](https://docs.swift.org/swift-book/LanguageGuide/Protocols.html)。

类具有结构所没有的额外功能：

- 继承使一个类继承另一个类的特征。
- 类型转换使您可以在运行时检查和解释类实例的类型。
- 去初始化器使类的实例能够释放其分配的任何资源。
- 引用计数允许对类实例进行多个引用。

有关更多信息，请参阅[继承](https://docs.swift.org/swift-book/LanguageGuide/Inheritance.html)、[类型铸造](https://docs.swift.org/swift-book/LanguageGuide/TypeCasting.html)、[去初始化](https://docs.swift.org/swift-book/LanguageGuide/Deinitialization.html)和[自动引用计数](https://docs.swift.org/swift-book/LanguageGuide/AutomaticReferenceCounting.html)。

类支持的额外功能以增加复杂性为代价。作为一般准则，更喜欢结构，因为它们更容易推理，并在适当或必要时使用类。在实践中，这意味着您定义的大多数自定义数据类型将是结构和枚举。有关更详细的比较，请参阅[在结构和类之间进行选择](https://developer.apple.com/documentation/swift/choosing_between_structures_and_classes)。

> 注意
>
> 班级和演员有许多相同的特征和行为。有关演员的信息，请参阅[并发](https://docs.swift.org/swift-book/LanguageGuide/Concurrency.html)。

### 定义语法

结构和类具有相似的定义语法。您引入了带有`struct`关键字的结构和带有`class`关键字的类。两者都将整个定义放在一对大括号中：

```swift
struct SomeStructure {
   // structure definition goes here
}
class SomeClass {
   // class definition goes here
}
```

> 注意
>
> 无论何时定义一个新的结构或类，都要定义一个新的Swift类型。给类型命名为‘UpperCamelCase’(比如这里的‘SomeStructure’和‘SomeClass’)，以匹配标准Swift类型(比如‘String’，‘Int’和‘Bool’)的大小写。将属性和方法命名为“lowerCamelCase”(例如“frameRate”和“incrementCount”)，以区别于类型名称。

以下是结构定义和类定义的示例：

```swift
struct Resolution {
   var width = 0
   var height = 0
}
class VideoMode {
   var resolution = Resolution()
   var interlaced = false
   var frameRate = 0.0
   var name: String?
}
```

上面的示例定义了一个名为`Resolution`的新结构，以描述基于像素的显示分辨率。这种结构有两个存储属性，称为`width`和`height`。存储属性是捆绑并作为结构或类的一部分存储的常量或变量。通过将这两个属性设置为初始整数值为`0`，可以推断为`Int`类型。

上面的示例还定义了一个名为`VideoMode`的新类，以描述视频显示的特定视频模式。该类有四个变量存储属性。第一个，`resolution`，用一个新的`Resolution`结构实例初始化，该实例推断出`Resolution`的属性类型。对于其他三个属性，新的`VideoMode`实例将初始化为`false`的`interlaced`设置（意思是“非隔行视频”），播放帧速率为`0.0`，以及名为`name`的可选`String`值。`name`属性会自动被赋予`nil`的默认值或“无`name`值”，因为它是可选类型。

### 结构和类实例

' Resolution '结构定义和' VideoMode '类定义只描述了' Resolution '或' VideoMode '的外观。它们本身并不描述特定的分辨率或视频模式。为此，您需要创建结构或类的实例。

创建实例的语法对结构和类都非常相似：

```swift
let someResolution = Resolution()
let someVideoMode = VideoMode()
```

结构和类都对新实例使用初始化器语法。最简单的初始化器语法形式使用类或结构的类型名称，后跟空括号，如`Resolution()`或`VideoMode()`。这会创建一个类或结构的新实例，任何属性都初始化为默认值。类和结构初始化在[初始化](https://docs.swift.org/swift-book/LanguageGuide/Initialization.html)中进行了更详细的描述。

### 访问属性

您可以使用*点语法*访问实例的属性。在点语法中，您立即在实例名称之后写入属性名称，用句点（`.`）分隔，没有任何空格：

```swift
print("The width of someResolution is \(someResolution.width)")
// Prints "The width of someResolution is 0"
```

在本例中，`someResolution.width`引用`someResolution`的`width`属性，并返回其默认初始值`0`。

您可以深入了解子属性，例如`VideoMode``resolution`属性中的`width`属性：

```swift
print("The width of someVideoMode is \(someVideoMode.resolution.width)")
// Prints "The width of someVideoMode is 0"
```

您还可以使用点语法为变量属性分配新值：

```swift
someVideoMode.resolution.width = 1280
print("The width of someVideoMode is now \(someVideoMode.resolution.width)")
// Prints "The width of someVideoMode is now 1280"
```

### 结构类型的成员初始化器

所有结构都有一个自动生成的*按成员初始化器*，您可以使用它初始化新结构实例的成员属性。新实例属性的初始值可以通过名称传递给成员初始化器：

```swift
let vga = Resolution(width: 640, height: 480)
```

与结构不同，类实例不会收到默认的按成员初始化器。初始化器在[初始化](https://docs.swift.org/swift-book/LanguageGuide/Initialization.html)中进行了更详细的描述。

### 结构和枚举是值类型

*值类型*是一种类型，其值在分配给变量或常量时，或当传递给函数时被*复制*。

在前几章中，您实际上一直在广泛使用值类型。事实上，Swift中的所有基本类型——整数、浮点数、布尔值、字符串、数组和字典——都是值类型，并作为幕后结构实现。

所有结构和枚举都是Swift中的值类型。这意味着，您创建的任何结构和枚举实例，以及它们作为属性的任何值类型，在代码中传递时，总是会被复制。

> 注意
>
> 标准库定义的集合，如数组、字典和字符串，使用优化来降低复制的性能成本。这些集合不是立即复制，而是共享内存，其中元素存储在原始实例和任何副本之间。如果集合的副本之一被修改，则在修改前复制元素。您在代码中看到的行为总是像是立即复制一样。

考虑这个例子，它使用上一个示例中的`Resolution`结构：

```swift
let hd = Resolution(width: 1920, height: 1080)
var cinema = hd
```

此示例声明一个名为`hd`常量，并将其设置为使用全高清视频的宽度和高度初始化的`Resolution`实例（1920像素宽，高1080像素）。

然后，它声明一个名为`cinema`的变量，并将其设置为`hd`的当前值。因为`Resolution`是一个结构，所以制作了现有实例*的副本*，并将这个新副本分配给`cinema`。尽管`hd``cinema`现在具有相同的宽度和高度，但它们是幕后两个完全不同的实例。

接下来，`cinema`的`width`属性被修改为用于数字影院投影的稍宽的2K标准的宽度（宽2048像素，高1080像素）：

```swift
cinema.width = 2048
```

检查`cinema`的`width`属性表明，它确实变成了`2048`：

```swift
print("cinema is now \(cinema.width) pixels wide")
// Prints "cinema is now 2048 pixels wide"
```

然而，原始`hd`实例的`width`属性仍然具有`1920`年的旧值：

```swift
print("hd is still \(hd.width) pixels wide")
// Prints "hd is still 1920 pixels wide"
```

当给`cinema`当前`hd`值时，存储在`hd`中的*值*被复制到新的`cinema`实例中。最终结果是两个完全独立的实例，其中包含相同的数字值。然而，由于它们是单独的实例，将`cinema`的宽度设置为`2048`不会影响存储在`hd`中的宽度，如下图所示：

![../_images/sharedStateStruct_2x.png](https://file.pandacode.cn/blog/202204051556030.png)

同样的行为也适用于枚举：

```swift
enum CompassPoint {
   case north, south, east, west
   mutating func turnNorth() {
       self = .north
   }
}
var currentDirection = CompassPoint.west
let rememberedDirection = currentDirection
currentDirection.turnNorth()

print("The current direction is \(currentDirection)")
print("The remembered direction is \(rememberedDirection)")
// Prints "The current direction is north"
// Prints "The remembered direction is west"
```

当`rememberedDirection`被分配到`currentDirection`的值时，它实际上被设置为该值的副本。此后更改`currentDirection`的值不会影响存储在`rememberedDirection`中的原始值的副本。

## 类是参考类型

与值类型不同，*引用类型*在分配给变量或常量或传递给函数时*不会*复制。使用对相同现有实例的引用，而不是副本。

以下是使用上面定义的`VideoMode`类的示例：

```swift
let tenEighty = VideoMode()
tenEighty.resolution = hd
tenEighty.interlaced = true
tenEighty.name = "1080i"
tenEighty.frameRate = 25.0
```

这个例子声明了一个名为' ten80 '的新常量，并将其设置为指向' VideoMode '类的一个新实例。视频模式被分配一个以前的高清分辨率“1920”到“1080”的副本。它被设置为交错，它的名称被设置为‘1080i’，它的帧速率被设置为‘25.0’帧每秒。

接下来，`tenEighty`分配给一个新的常量，称为`alsoTenEighty`，并修改了`alsoTenEighty`帧速率：

```swift
let alsoTenEighty = tenEighty
alsoTenEighty.frameRate = 30.0
```

由于类是引用类型，`tenEighty`和`alsoTenEighty`实际上都引用*同一个*`VideoMode`实例。实际上，它们只是同一单个实例的两个不同名称，如下图所示：

![../_images/sharedStateClass_2x.png](https://file.pandacode.cn/blog/202204051557330.png)

检查`tenEighty`的`frameRate`属性表明，它从底层`VideoMode`实例正确报告了`30.0`的新帧速率：

```swift
print("The frameRate property of tenEighty is now \(tenEighty.frameRate)")
// Prints "The frameRate property of tenEighty is now 30.0"
```

这个例子还展示了引用类型如何更难推理。如果`tenEighty`和`alsoTenEighty`程序的代码中相距甚远，可能很难找到更改视频模式的所有方式。无论你在哪里使用`tenEighty`，你还必须考虑使用`alsoTenEighty`的代码，反之亦然。相比之下，值类型更容易推理，因为所有与相同值交互的代码都在源文件中紧密相连。

请注意，`tenEighty`和`alsoTenEighty`被声明为*常量*，而不是变量。但是，您仍然可以更改`tenEighty.frameRate`和`alsoTenEighty.frameRate`，因为`tenEighty`和`alsoTenEighty`常量本身的值实际上没有变化。`tenEighty`和`alsoTenEighty`本身不会“存储”`VideoMode`实例，相反，它们都*指*幕后`VideoMode`实例。更改的是底层`VideoMode`的`frameRate`属性，而不是对该`VideoMode`的常量引用的值。

### 身份运算符

由于类是引用类型，因此多个常量和变量可以在幕后引用类的同一单个实例。（结构和枚举并非如此，因为它们在分配给常量或变量或传递给函数时总是被复制。）

有时，找出两个常量或变量是否引用一个类的完全相同的实例是有用的。为了实现这一点，Swift提供了两个身份运算符：

- 相同到（`===`)
- Not identical to (`!==`)

使用这些运算符检查两个常量或变量是否引用同一个实例：

```swift
if tenEighty === alsoTenEighty {
   print("tenEighty and alsoTenEighty refer to the same VideoMode instance.")
}
// Prints "tenEighty and alsoTenEighty refer to the same VideoMode instance."
```

请注意，*相同于*（由三个相等符号表示，或`===`并不意味着*等于*（由两个相等符号表示，或`==`相同。*与*类类型的两个常量或变量引用完全相同的类实例相同。*等于*意味着两个实例在值上被认为是相等或等价的，对于类型设计器定义的*相等*的适当含义。

当您定义自己的自定义结构和类时，您有责任决定什么符合两个相等的条件。定义自己实现`==`和的过程`!=`运算符在[等效运算符](https://docs.swift.org/swift-book/LanguageGuide/AdvancedOperators.html#ID45)中描述。

### 指针

如果您有使用C、C++或Objective-C的经验，您可能知道这些语言使用*指针*来引用内存中的地址。引用某些引用类型的实例的Swift常量或变量类似于C中的指针，但不是指向内存中地址的直接指针，并且不需要您编写星号（`*`）来指示您正在创建引用。相反，这些引用的定义与Swift中的任何其他常量或变量一样。标准库提供了指针和缓冲区类型，如果您需要直接与指针交互，您可以使用这些类型，请参阅[手动内存管理](https://developer.apple.com/documentation/swift/swift_standard_library/manual_memory_management)。