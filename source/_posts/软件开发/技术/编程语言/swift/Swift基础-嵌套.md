---
title: Swift基础 嵌套
tags:
    - swift
    - 基础
categories:
    - 技术
date: 2022-07-01 12:01:01
thumbnail:
---

翻译自：https://docs.swift.org/swift-book/LanguageGuide/Closures.html#ID102

*嵌套*是自包含的功能块，可以在代码中传递和使用。Swift中的闭包类似于C和Objective-C中的块以及其他编程语言中的lambdas。

闭包可以从定义常量和变量的上下文中捕获和存储对任何常量和变量的引用。这被称为*关闭*这些常量和变量。Swift为您处理捕获的所有内存管理。

> 注意
>
> 如果您不熟悉捕获的概念，请不要担心。下文在《[捕捉价值观》](https://docs.swift.org/swift-book/LanguageGuide/Closures.html#ID103)中对此进行了详细解释。

[函数](https://docs.swift.org/swift-book/LanguageGuide/Functions.html)中引入的全局和嵌套函数实际上是闭包的特殊情况。关闭采取三种形式之一：

- 全局函数是具有名称且不捕获任何值的闭包。
- 嵌套函数是具有名称的闭包，可以从其封闭函数中捕获值。
- 闭包表达式是用轻量级语法编写的未命名闭包，可以从其周围上下文中捕获值。

Swift的闭包表达式具有干净、清晰的风格，优化鼓励在常见场景中进行简短、无杂乱的语法。这些优化包括：

- 从上下文推断参数和返回值类型
- 来自单表达式闭包的隐式回报
- 速记参数名称
- 尾随闭包语法

## 嵌套表达式

Nested [Functions](https://docs.swift.org/swift-book/LanguageGuide/Functions.html#ID178)中引入的嵌套函数是命名和定义自包含代码块作为更大函数的一部分的便捷手段。然而，在没有完整声明和名称的情况下编写类似函数的构造的较短版本有时是有用的。当您使用将函数作为一个或多个参数的函数或方法时，尤其如此。

*闭包表达式*是一种以简短、聚焦的语法编写内联闭包的方法。闭包表达式提供了几种语法优化，用于以缩短的形式编写闭包，而不会失去清晰度或意图。下面的闭包表达式示例通过在几次迭代中完善`sorted(by:)`方法的单个示例来说明这些优化，每个迭代都以更简洁的方式表达相同的功能。

### 排序方法

Swift的标准库提供了一个名为`sorted(by:)`的方法，该方法根据您提供的排序闭包的输出对已知类型的值数组进行排序。完成排序过程后，`sorted(by:)`方法返回与旧数组类型和大小相同的新数组，其元素按正确的排序顺序排列。原始数组不会被`sorted(by:)`方法修改。

下面的闭包表达式示例使用`sorted(by:)`方法按反向字母顺序对`String`值数组进行排序。以下是要排序的初始数组：

```swift
let names = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
```

`sorted(by:)`方法接受一个闭包，该闭包接受两个与数组内容相同的类型参数，并返回一个`Bool`值，说明对值进行排序后，第一个值应该出现在第二个值之前还是之后。如果第一个值出现在第二个值*之前*，排序闭包需要返回`true`，否则返回`false`。

这个例子是对一个' String '值的数组进行排序，因此排序闭包需要是一个类型为' (String, String) -> Bool '的函数。

提供排序闭包的一种方法是编写正确类型的正常函数，并将其作为参数传递给`sorted(by:)`方法：

```swift
func backward(_ s1: String, _ s2: String) -> Bool {
   return s1 > s2
}
var reversedNames = names.sorted(by: backward)
// reversedNames is equal to ["Ewa", "Daniella", "Chris", "Barry", "Alex"]
```

如果第一个字符串（`s1`）大于第二个字符串（`s2`），则 `backward(_:_:)`函数将返回`true`，表明`s1`应该出现在排序数组的`s2`之前。对于字符串中的字符，“大于”意味着“在字母表中出现得晚于”。这意味着字母`"B"`大于字母`"A"`字符串`"Tom"`大于字符串`"Tim"`这给出了一个反向字母排序，将`"Barry"`放在`"Alex"`之前，以此类过。

然而，这是一种相当冗长的方式来编写本质上是一个单表达式函数(' a >b ')。在这个例子中，最好使用闭包表达式语法内联编写排序闭包。

### 嵌套表达式语法

嵌套表达式语法具有以下一般形式：

```swift
{ (parameters) -> return type in
   statements
}
```

嵌套表达式语法中的*参数*可以是输入输出参数，但它们不能有默认值。如果您命名变量参数，则可以使用变量参数。元组也可以用作参数类型和返回类型。

下面的示例显示了上面的向`backward(_:_:)`函数的闭包表达式版本：

```swift
reversedNames = names.sorted(by: { (s1: String, s2: String) -> Bool in
   return s1 > s2
})
```

请注意，这个内联闭包的形参声明和返回类型与' backward(::) '函数的声明相同。在这两种情况下，它都被写成' (s1: String, s2: String) -> Bool '。但是，对于内联闭包表达式，参数和返回类型写在花括号的*内部，而不是在花括号的外面。

闭包正文的开头由关键字引入。此关键字表示闭包参数和返回类型的定义已经完成，闭包的主体即将开始。

由于闭包的主体太短，它甚至可以写在一行上：

```swift
reversedNames = names.sorted(by: { (s1: String, s2: String) -> Bool in return s1 > s2 } )
```

这表明对`sorted(by:)`方法的总体调用保持不变。一对括号仍然包裹着方法的整个参数。然而，这个论点现在是一个内联闭包。

### 从上下文推断类型

因为排序闭包是作为参数传递给方法的，所以Swift可以推断出其参数的类型以及返回值的类型。' sorted(by:) '方法是在一个字符串数组上调用的，所以它的参数必须是一个类型为' (String, String) -> Bool '的函数。这意味着' (String, String) '和' Bool '类型不需要作为闭包表达式定义的一部分编写。因为所有类型都可以被推断，所以返回箭头(' -> ')和形参名称周围的括号也可以被省略:

```swift
reversedNames = names.sorted(by: { s1, s2 in return s1 > s2 } )
```

当将闭包作为内联闭包表达式传递给函数或方法时，始终可以推断参数类型和返回类型。因此，当闭包用作函数或方法参数时，您永远不需要以最完整的形式编写内联闭包。

尽管如此，如果您愿意，您仍然可以明确这些类型，如果这能避免代码读者的歧义，则鼓励这样做。在`sorted(by:)`方法的情况下，从正在进行排序的事实中可以清楚地看出闭包的目的，读者可以安全地假设闭包可能与`String`值一起工作，因为它有助于对字符串数组进行排序。

### 单表达式关闭的隐式返回

单表达式闭包可以通过从声明中省略`return`关键字来隐式返回其单个表达式的结果，如上一个示例的这个版本：

```swift
reversedNames = names.sorted(by: { s1, s2 in s1 > s2 } )
```

这里，' sorted(by:) '方法的参数的函数类型明确表示闭包必须返回' Bool '值。因为闭包的主体包含一个返回' Bool '值的表达式(' s1 > s2 ')，所以没有歧义，并且' return '关键字可以被省略。

### 运算符方法

实际上，有更*短*的方法来编写上面的闭包表达式。Swift的`String`类型将其大于运算符（`>`）的字符串特定实现定义为具有两个`String`类型参数的方法，并返回`Bool`类型的值。这完全符合`sorted(by:)`方法所需的方法类型。因此，您可以简单地传递大于运算符，Swift将推断您想要使用其字符串特定的实现：

```swift
reversedNames = names.sorted(by: >)
```

有关运算符方法的更多信息，请参阅[运算符方法](https://docs.swift.org/swift-book/LanguageGuide/AdvancedOperators.html#ID42)。

## 尾随关闭

如果您需要将闭包表达式传递给函数作为函数的最终参数，并且闭包表达式很长，则将其写为*尾随闭包*可能会有用。您在函数调用的括号后写一个尾随闭包，即使尾随闭包仍然是函数的参数。当您使用尾随闭包语法时，您不会将第一个闭包的参数标签作为函数调用的一部分。函数调用可以包括多个尾随闭包；然而，以下前几个示例使用单个尾随闭包。

```swift
func someFunctionThatTakesAClosure(closure: () -> Void) {
   // function body goes here
}

// 下面是如何在不使用末尾闭包的情况下调用这个函数:

someFunctionThatTakesAClosure(closure: {
   // 结束的身体在这里
})

// 下面是如何使用末尾闭包来调用这个函数:

someFunctionThatTakesAClosure() {
   // trailing closure's body goes here
}
```

上面的[闭包表达式语法](https://docs.swift.org/swift-book/LanguageGuide/Closures.html#ID97)部分的字符串排序闭包可以在`sorted(by:)`方法的括号之外写成尾随闭包：

```swift
reversedNames = names.sorted() { $0 > $1 }
```

如果闭包表达式作为函数或方法的唯一参数提供，并且您将该表达式作为尾随闭包提供，则在调用函数时，您无需在函数或方法名称后写一对括号`()`）：

```swift
reversedNames = names.sorted { $0 > $1 }
```

当闭包足够长，无法将其内联写在一行上时，尾随闭包最有用。例如，Swift的`Array`类型有一个`map(_:)`方法，该方法以闭包表达式为单个参数。为数组中的每个项目调用一次闭包，并返回该项目的替代映射值（可能是其他类型）。您通过在传递给`map(_:)`的闭包中编写代码来指定映射的性质和返回值的类型。

将提供的闭包应用于每个数组元素后，`map(_:)`方法返回一个包含所有新映射值的新数组，顺序与原始数组中的相应值相同。

下面介绍如何使用带有尾随闭包的' map(:) '方法将' Int '值的数组转换为' String '值的数组。数组[16,58,510]被用来创建新的数组["OneSix"， "FiveEight"， "FiveOneZero"]:

```swift
let digitNames = [
   0: "Zero", 1: "One", 2: "Two",   3: "Three", 4: "Four",
   5: "Five", 6: "Six", 7: "Seven", 8: "Eight", 9: "Nine"
]
let numbers = [16, 58, 510]
```

上面的代码创建了整数数字与其名称的英语版本之间的映射词典。它还定义了一个整数数数组，准备转换为字符串。

您现在可以使用`numbers`数组创建`String`值数组，方法是将闭包表达式作为尾随闭包传递到数组的`map(_:)`方法：

```swift
let strings = numbers.map { (number) -> String in
   var number = number
   var output = ""
   repeat {
       output = digitNames[number % 10]! + output
       number /= 10
   } while number > 0
   return output
}
// strings is inferred to be of type [String]
// its value is ["OneSix", "FiveEight", "FiveOneZero"]
```

`map(_:)`方法为数组中的每个项调用闭包表达式一次。您不需要指定闭包输入参数`number`的类型，因为类型可以从要映射的数组中的值中推断出来。

在本例中，变量`number`使用闭包`number`参数的值初始化，以便可以在闭包主体内修改该值。（函数和闭包的参数始终是常量。）闭包表达式还指定了`String`的返回类型，以指示将存储在映射输出数组中的类型。

闭包表达式每次调用时都会构建一个名为`output`的字符串。它使用剩余运算符（`number%10`）计算`number`的最后一个数字，并使用此数字在`digitNames`字典中查找适当的字符串。闭包可用于创建任何大于零的整数的字符串表示形式。

注意

对`digitNames`字典下标的调用后是感叹号（`!`），因为字典下标返回一个可选值，表示如果键不存在，字典查找可能会失败。在上面的示例中，保证`number%10`始终是`digitNames`字典的有效下标键，因此使用感叹号来强制解开存储在下标可选返回值中的`String`值。

从`digitNames`字典中检索到的字符串被添加到`output`的*前面*，有效地反向构建数字的字符串版本。（表达式`number%10`对16、`58`为`8`，对`510`值为`0`。）

然后将`number`变量除以10。因为它是一个整数，所以它在分区期间四舍五入，所以`16`变成1，`58`变成5，`510`变成51。

重复该过程，直到`number`等于`0`，此时`output`字符串由闭包返回，并通过`map(_:)`方法添加到输出数组中。

在上述示例中使用尾随闭包语法，在闭包支持的函数之后立即整齐地封装闭包的功能，而无需将整个闭包包包在`map(_:)`方法的外括号中。

如果一个函数需要多个闭包，则省略第一个尾随闭包的参数标签，并标记剩余的尾随闭包。例如，下面的功能加载照片库的图片：

```swift
func loadPicture(from server: Server, completion: (Picture) -> Void, onFailure: () -> Void) {
   if let picture = download("photo.jpg", from: server) {
       completion(picture)
   } else {
       onFailure()
   }
}
```

当您调用此函数加载图片时，您提供了两个闭包。第一个闭包是一个完成处理程序，在成功下载后显示图片。第二个闭包是一个错误处理程序，向用户显示错误。

```swift
loadPicture(from: someServer) { picture in
   someView.currentPicture = picture
} onFailure: {
   print("Couldn't download the next picture.")
}
```

在本例中，`loadPicture(from:completion:onFailure:)`函数将其网络任务发送到后台，并在网络任务完成后调用两个完成处理程序之一。以这种方式编写该功能可以让您干净地将负责处理网络故障的代码与成功下载后更新用户界面的代码分开，而不是只使用一个处理这两种情况的闭包。

## 捕捉价值观

闭包可以从定义它的周围上下文中*捕获*常量和变量。然后，闭包可以从其主体内引用和修改这些常量和变量的值，即使定义常量和变量的原始范围不再存在。

在Swift中，可以捕获值的最简单闭包形式是写在另一个函数主体中的嵌套函数。嵌套函数可以捕获其外部函数的任何参数，也可以捕获外部函数中定义的任何常量和变量。

这里有一个名为`makeIncrementer`的函数的示例，它包含一个名为`incrementer`嵌套函数。嵌套`incrementer()`函数从其周围的上下文捕获两个值，`runningTotal`和`amount`。捕获这些值后，`makeIncrementer`将作为闭包返回，每次调用时按`amount`增加`runningTotal`。

```swift
func makeIncrementer(forIncrement amount: Int) -> () -> Int {
   var runningTotal = 0
   func incrementer() -> Int {
       runningTotal += amount
       return runningTotal
   }
   return incrementer
}
```

' makeIncrementer '的返回类型是' ()-> Int '。这意味着它返回一个*函数*，而不是一个简单的值。它返回的函数没有参数，每次调用都返回一个' Int '值。要了解函数如何返回其他函数，请参阅[函数类型作为返回类型](https://docs.swift.org/swift-book/LanguageGuide/Functions.html#ID177)。

`makeIncrementer(forIncrement:)`函数定义了一个名为`runningTotal`的整数变量，以存储将返回的增量的当前运行总数。此变量初始化值为`0`。

`makeIncrementer(forIncrement:)`函数具有单个`Int`参数，参数标签为`forIncrement`，参数名称为`amount`。传递给此参数的参数值指定每次调用返回的增量函数时，`runningTotal`应该增加多少。`makeIncrementer`函数定义了一个名为`incrementer`的嵌套函数，该函数执行实际增量。此函数只需为`runningTotal`添加`amount`，然后返回结果。

当孤立地考虑时，嵌套`incrementer()`函数可能看起来不寻常：

```swift
func incrementer() -> Int {
   runningTotal += amount
   return runningTotal
}
```

`incrementer()`函数没有任何参数，但它指的是在其函数主体内`runningTotal`和`amount`。它通过捕获对周围函数中`runningTotal`和`amount`的*引用*，并在自己的功能体中使用它们来做到这一点。通过引用捕获确保在`makeIncrementer`调用结束时，`runningTotal`和`amount`不会消失，并确保下次调用`incrementer`函数时`runningTotal`可用。

> 注意
>
> 作为优化，如果值没有被闭包突变，并且值在闭包创建后没有突变，则可以捕获和存储该值*的副本*。

Swift 还负责处理不再需要的变量时涉及的所有内存管理。

以下是`makeIncrementer`在起作用的一个例子：

```swift
let incrementByTen = makeIncrementer(forIncrement: 10)
```

此示例设置了一个名为`incrementByTen`的常量，以引用每次调用时为其`runningTotal`变量添加`10`增量函数。多次调用函数会显示此行为：

```swift
incrementByTen()
// returns a value of 10
incrementByTen()
// returns a value of 20
incrementByTen()
// returns a value of 30
```

如果您创建第二个增量器，它将对一个新的单独`runningTotal`变量有自己的存储引用：

```swift
let incrementBySeven = makeIncrementer(forIncrement: 7)
incrementBySeven()
// returns a value of 7
```

调用原始增量器（`incrementByTen`）继续增加自己的`runningTotal`变量，并且不影响`incrementBySeven`捕获的变量：

```swift
incrementByTen()
// returns a value of 40
```

> 注意
>
> 如果您为类实例的属性分配闭包，并且闭包通过引用实例或其成员来捕获该实例，您将在闭包和实例之间创建一个强大的引用周期。Swift 使用*采集列表*来打破这些强大的参考周期。有关更多信息，请参阅[关闭的强参考周期](https://docs.swift.org/swift-book/LanguageGuide/AutomaticReferenceCounting.html#ID56)。

## 关闭是参考类型

在上面的例子中，' incrementBySeven '和' incrementByTen '是常量，但是这些常量所引用的闭包仍然能够增加它们捕获的' runningTotal '变量。这是因为函数和闭包都是引用类型。

每当您将函数或闭包分配给常量或变量时，您实际上都会将该常量或变量设置为对函数或闭包的*引用*。在上面的示例中，`incrementByTen`*指的是*闭包的选择是常量，而不是闭包本身的内容。

这也意味着，如果您将闭包分配给两个不同的常量或变量，这两个常量或变量都引用相同的闭包。

```swift
let alsoIncrementByTen = incrementByTen
alsoIncrementByTen()
// returns a value of 50

incrementByTen()
// returns a value of 60
```

上面的示例表明，调用`alsoIncrementByTen`与调用`incrementByTen`相同。由于它们都引用相同的闭包，因此它们都会增加并返回相同的运行总数。

## 逃避关闭

当闭包作为参数传递给函数时，闭包被称为*转义*函数，但在函数返回后调用闭包。当您声明一个以闭包作为其参数之一的函数时，您可以在参数类型之前编写`@escaping`，以指示允许闭包转义。

闭包可以转义的一种方法是存储在函数之外定义的变量中。例如，许多启动异步操作的函数将闭包参数作为完成处理程序。该函数在开始操作后返回，但在操作完成之前不会调用闭包——闭包需要转义，以便稍后调用。例如：

```swift
var completionHandlers: [() -> Void] = []
func someFunctionWithEscapingClosure(completionHandler: @escaping () -> Void) {
   completionHandlers.append(completionHandler)
}
```

`someFunctionWithEscapingClosure(_:)`函数以闭包为参数，并将其添加到函数之外声明的数组中。如果您没有用`@escaping`标记此函数的参数，您将收到编译时错误。

如果`self`引用类的实例，则引用`self`的转义闭包需要特殊考虑。在逃逸闭合中捕获`self`很容易意外地创建一个强大的参考周期。有关参考周期的信息，请参阅[自动参考计数](https://docs.swift.org/swift-book/LanguageGuide/AutomaticReferenceCounting.html)。

通常，闭包通过在闭包正文中使用变量来隐式捕获变量，但在这种情况下，您需要显式变量。如果您想捕获`self`，请在使用它时显式写入`self`，或将`self`包含在闭包的捕获列表中。写`self`明确可以让您表达自己的意图，并提醒您确认没有参考周期。例如，在下面的代码中，传递给`someFunctionWithEscapingClosure(_:)`的闭包显式引用`self`显式。相比之下，传递给`someFunctionWithNonescapingClosure(_:)`的闭包是一个不可转义闭包，这意味着它可以隐式引用`self`。

```swift
func someFunctionWithNonescapingClosure(closure: () -> Void) {
   closure()
}

class SomeClass {
   var x = 10
   func doSomething() {
       someFunctionWithEscapingClosure { self.x = 100 }
       someFunctionWithNonescapingClosure { x = 200 }
   }
}

let instance = SomeClass()
instance.doSomething()
print(instance.x)
// Prints "200"

completionHandlers.first?()
print(instance.x)
// Prints "100"
```



以下是`doSomething()`的一个版本，通过将其包含在闭包的捕获列表中来捕获`self`，然后隐含地引用`self`：

```swift
class SomeOtherClass {
   var x = 10
   func doSomething() {
       someFunctionWithEscapingClosure { [self] in x = 100 }
       someFunctionWithNonescapingClosure { x = 200 }
   }
}
```

如果`self`是结构或枚举的实例，您可以始终隐式引用`self`。然而，当`self`是结构或枚举的实例时，转义闭包无法捕获对`self`的可变引用。结构和枚举不允许共享可变性，正如[结构和枚举是值类型](https://docs.swift.org/swift-book/LanguageGuide/ClassesAndStructures.html#ID88)中讨论的那样。

```swift
struct SomeStruct {
   var x = 10
   mutating func doSomething() {
       someFunctionWithNonescapingClosure { x = 200 }  // Ok
       someFunctionWithEscapingClosure { x = 100 }     // Error
   }
}
```

上面示例中对`someFunctionWithEscapingClosure`函数的调用是一个错误，因为它位于突变方法中，因此`self`是可变的。这违反了规逃逸闭包不能捕获结构对`self`的可变引用的规则。

## 自动关闭

*自动闭包*是自动创建的闭包，用于包装作为参数传递给函数的表达式。它不需要任何参数，当调用它时，它会返回包裹在里面的表达式的值。这种语法便利性允许您通过编写正态表达式而不是显式闭包来省略函数参数周围的大括号。

通常*调用*带有自动闭包的函数，但*实现*这类函数并不常见。例如，`assert(condition:message:file:line:)`函数的`condition`和`message`参数接受一个自动闭包;它的“condition”参数仅在调试版本中计算，而它的“message”参数仅在“condition”为“false”时计算。

自动关闭允许您延迟评估，因为在您调用关闭之前，内部代码不会运行。延迟评估对于具有副作用或计算成本的代码非常有用，因为它允许您控制代码何时进行评估。以下代码显示了关闭如何延迟评估。

```swift
var customersInLine = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
print(customersInLine.count)
// Prints "5"

let customerProvider = { customersInLine.remove(at: 0) }
print(customersInLine.count)
// Prints "5"

print("Now serving \(customerProvider())!")
// Prints "Now serving Chris!"
print(customersInLine.count)
// Prints "4"
```

即使闭包内的代码删除了`customersInLine`数组的第一个元素，但在实际调用闭包之前，数组元素也不会被删除。如果从未调用闭包，则永远不会计算闭包内的表达式，这意味着永远不会删除数组元素。请注意，`customerProvider`的类型不是`String`，而是`()->String`——一个没有返回字符串的参数的函数。

当您将闭包作为参数传递给函数时，您将获得相同的延迟评估行为。

```swift
// customersInLine is ["Alex", "Ewa", "Barry", "Daniella"]
func serve(customer customerProvider: () -> String) {
   print("Now serving \(customerProvider())!")
}
serve(customer: { customersInLine.remove(at: 0) } )
// Prints "Now serving Alex!"
```

上面清单中的' serve(customer:) '函数接受一个显式的闭包，该闭包返回客户的名字。下面的' serve(customer:) '版本执行了相同的操作，但它没有采用显式闭包，而是通过使用' @autoclosure '属性标记其参数的类型来接受一个自动闭包。现在你可以调用这个函数，就好像它有一个' String '参数而不是一个闭包一样。参数会自动转换为闭包，因为' customerProvider '参数的类型是用' @autoclosure '属性标记的。

```swift
// customersInLine is ["Ewa", "Barry", "Daniella"]
func serve(customer customerProvider: @autoclosure () -> String) {
   print("Now serving \(customerProvider())!")
}
serve(customer: customersInLine.remove(at: 0))
// Prints "Now serving Ewa!"
```

> 注意
>
> 过度使用自动关闭可能会使您的代码难以理解。上下文和函数名称应明确表示正在推迟评估。

如果您想要一个允许转义的自动关闭，请使用`@autoclosure`和`@escaping`属性。`@escaping`属性在上文的[“逃避关闭”](https://docs.swift.org/swift-book/LanguageGuide/Closures.html#ID546)中进行了描述。

```swift
// customersInLine is ["Barry", "Daniella"]
var customerProviders: [() -> String] = []
func collectCustomerProviders(_ customerProvider: @autoclosure @escaping () -> String) {
   customerProviders.append(customerProvider)
}
collectCustomerProviders(customersInLine.remove(at: 0))
collectCustomerProviders(customersInLine.remove(at: 0))

print("Collected \(customerProviders.count) closures.")
// Prints "Collected 2 closures."
for customerProvider in customerProviders {
   print("Now serving \(customerProvider())!")
}
// Prints "Now serving Barry!"
// Prints "Now serving Daniella!"
```

在上面的代码中，`collectCustomerProviders(_:)`函数将闭包附加到`customerProviders`数组中，而不是将传递给它的闭包作为其`customerProvider`参数。数组声明在函数范围之外，这意味着数组中的闭包可以在函数返回后执行。因此，必须允许`customerProvider`参数的值转义函数的范围。