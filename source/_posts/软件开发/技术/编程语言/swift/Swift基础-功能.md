---
title: Swift基础 功能(Functions)
tags:
    - Swift
    - 基础
categories:
    - Swift
date: 2022-07-01 12:01:01
thumbnail:
---


翻译自：https://docs.swift.org/swift-book/LanguageGuide/Functions.html

*函数*是执行特定任务的自包含的代码块。您给函数一个名称来标识它的作用，该名称用于在需要时“调用”该函数以执行其任务。

Swift的统一函数语法足够灵活，可以表达任何东西，从没有参数名称的简单C型函数到带有每个参数名称和参数标签的复杂Objective-C风格方法。参数可以提供默认值来简化函数调用，并且可以作为输入输出参数传递，这些参数在函数完成执行后修改传递的变量。

Swift中的每个函数都有一个类型，由函数的参数类型和返回类型组成。您可以像 Swift 中的任何其他类型一样使用此类型，这样可以轻松地将函数作为参数传递给其他函数，并从函数返回函数。函数也可以写入其他函数，以封装嵌套函数范围内的有用功能。

## 定义和调用函数

当您定义函数时，您可以选择定义函数作为输入的一个或多个命名类型值，称为*参数*。您还可以选择定义一种值类型，该函数将在完成后作为输出传递回，称为其*返回类型*。

每个函数都有一个*函数名*，该函数名描述了函数执行的任务。要使用函数，您可以“调用”该函数及其名称，并将其传递与函数参数类型匹配的输入值（称为*参数*）。函数的参数必须始终以与函数参数列表相同的顺序提供。

以下示例中的函数称为`greet(person:)`因为它就是这样做的——它以一个人的名字作为输入，并为该人返回问候语。要做到这一点，您定义了一个输入参数——一个名为`person`的`String`值——和一个返回类型的`String`，其中将包含对该人的问候语：

```swift
func greet(person: String) -> String {
   let greeting = "Hello, " + person + "!"
   return greeting
}
```

所有这些信息都汇总到函数的定义中，该*定义*前缀为`func`关键字。您可以使用*返回箭头*`->`（连字符后跟直角括号）指示函数的返回类型，后跟要返回的类型名称。

定义描述了函数做什么，它希望收到什么，以及它完成后会返回什么。该定义可以轻松地从代码中的其他地方明确调用该函数：

```swift
print(greet(person: "Anna"))
// Prints "Hello, Anna!"
print(greet(person: "Brian"))
// Prints "Hello, Brian!"
```

调用' greet(person:) '函数的方法是在' person '参数标签后给它传递一个' String '值，例如' greet(person: "Anna") '。因为函数返回' String '值，所以可以调用' print(_:separator:terminator:) '函数来包装' greet(person:) '，以打印该字符串并查看其返回值，如上所示。

> 注意
>
> `print(_:separator:terminator:)`函数没有第一个参数的标签，其其他参数是可选的，因为它们具有默认值。下文在[函数参数标签和参数名称](https://docs.swift.org/swift-book/LanguageGuide/Functions.html#ID166)以及[默认参数值](https://docs.swift.org/swift-book/LanguageGuide/Functions.html#ID169)中讨论了函数语法[的](https://docs.swift.org/swift-book/LanguageGuide/Functions.html#ID169)这些变化。

`greet(person:)`函数的正文从定义一个名为`greeting`的新`String`常量并将其设置为简单的问候消息开始。然后，使用`return`关键字将此问候语传回函数。在显示`returngreeting`的代码行中，该函数完成其执行并返回`greeting`的当前值。

您可以多次调用`greet(person:)`函数，输入值不同。上面的示例显示了如果使用`"Anna"`的输入值和`"Brian"`的输入值调用会发生什么。该功能在每种情况下都会返回量身定制的问候语。

为了缩短此函数的主体，您可以将消息创建和返回语句合并为一行：

```swift
func greetAgain(person: String) -> String {
   return "Hello again, " + person + "!"
}
print(greetAgain(person: "Anna"))
// Prints "Hello again, Anna!"
```

## 函数参数和返回值

在Swift中，函数参数和返回值非常灵活。您可以定义任何东西，从具有单个未命名参数的简单实用程序函数到具有表达式参数名称和不同参数选项的复杂函数。

### 没有参数的函数

定义输入参数不需要函数。这里有一个没有输入参数的函数，每当调用时，它总是返回相同的`String`消息：

```swift
func sayHelloWorld() -> String {
   return "hello, world"
}
print(sayHelloWorld())
// Prints "hello, world"
```

函数定义仍然需要在函数名称后面加上括号，即使它不接受任何参数。调用函数时，函数名后面还有一对空括号。

### 具有多个参数的函数

函数可以有多个输入参数，这些参数写在函数的括号中，用逗号分隔。

此功能使用一个人的名字以及他们是否已经被问候作为输入，并为该人返回适当的问候语：

```swift
func greet(person: String, alreadyGreeted: Bool) -> String {
   if alreadyGreeted {
       return greetAgain(person: person)
   } else {
       return greet(person: person)
   }
}
print(greet(person: "Tim", alreadyGreeted: true))
// Prints "Hello again, Tim!"
```

您通过将标记为`person`的`String`参数值和在括号中标记为greedGreeted的`Bool`参数值，用逗号分隔，来调用 `greet(person:alreadyGreeted:)`函数。请注意，此函数与前面一节中显示的`greet(person:)`函数不同。虽然这两个函数都有以`greet`开头的名字，但`greet(person:alreadyGreeted:)`函数需要两个参数，但`greet(person:)`函数只需要一个参数。

### 没有返回值的函数

定义返回类型不需要函数。以下是`greet(person:)`函数的版本，该函数打印自己的`String`值，而不是返回它：

```swift
func greet(person: String) {
   print("Hello, \(person)!")
}
greet(person: "Dave")
// Prints "Hello, Dave!"
```

由于它不需要返回值，函数的定义不包括返回箭头（`->`）或返回类型。

> 注意
>
> 严格来说，这个版本的`greet(person:)`函数仍然返回一个值，即使没有定义返回值。没有定义返回类型的函数返回类型为`Void`的特殊值。这只是一个空元组，写为`()`

调用函数时，可以忽略其返回值：

```swift
func printAndCount(string: String) -> Int {
   print(string)
   return string.count
}
func printWithoutCounting(string: String) {
   let _ = printAndCount(string: string)
}
printAndCount(string: "hello, world")
// prints "hello, world" and returns a value of 12
printWithoutCounting(string: "hello, world")
// prints "hello, world" but doesn't return a value
```

第一个函数`printAndCount(string:)`打印字符串，然后将其字符计数返回为`Int`。第二个函数`printWithoutCounting(string:)`调用第一个函数，但忽略了其返回值。当调用第二个函数时，消息仍然由第一个函数打印，但返回的值不使用。

> 注意
>
> 返回值可以忽略，但表示将返回值的函数必须始终这样做。具有定义返回类型的函数不允许控件在不返回值的情况下从函数底部掉出来，尝试这样做将导致编译时错误。

### 具有多个返回值的函数

您可以使用元组类型作为函数返回多个值作为复合返回值的一部分的返回类型。

下面的示例定义了一个名为`minMax(array:)`的函数，该函数在`Int`值数组中找到最小和最大的数字：

```swift
func minMax(array: [Int]) -> (min: Int, max: Int) {
   var currentMin = array[0]
   var currentMax = array[0]
   for value in array[1..<array.count] {
       if value < currentMin {
           currentMin = value
       } else if value > currentMax {
           currentMax = value
       }
   }
   return (currentMin, currentMax)
}
```

`minMax(array:)`函数返回一个包含两个`Int`值的元组。这些值被标记为`min`和`max`，以便在查询函数的返回值时按名称访问。

`minMax(array:)`函数的主体首先将两个名为`currentMin`和`currentMax`的工作变量设置为数组中第一个整数的值。然后，该函数迭代数组中的剩余值，并检查每个值，看看它分别小于或大于`currentMin`和`currentMax`的值。最后，总体最小值和最大值作为两个`Int`值的元组返回。

由于元组的成员值被命名为函数返回类型的一部分，因此可以使用点语法访问它们，以检索找到的最小值和最大值：

```swift
let bounds = minMax(array: [8, -6, 2, 109, 3, 71])
print("min is \(bounds.min) and max is \(bounds.max)")
// Prints "min is -6 and max is 109"
```

请注意，元组的成员不需要在从函数返回元组时命名，因为它们的名称已被指定为函数返回类型的一部分。

#### 可选的元组退货类型

如果要从函数返回的元组类型有可能对整个元组具有“无值”，则可以使用*可选*的元组返回类型来反映整个元组可以为`nil`的事实。您通过在元组类型的结束括号后放置问号来编写可选的元组返回类型，例如`(Int,Int)?`或者`(String,Int,Bool)?`

> 注意
>
> 可选元组类型，如`(Int,Int)?`不同于包含可选类型的元组，如`(Int?,Int?)`对于可选的元组类型，整个元组是可选的，而不仅仅是元组中的每个单个值。

上面的`minMax(array:)`函数返回一个包含两个`Int`值的元组。然而，该功能不会对传递的数组进行任何安全检查。如果`array`组参数包含空数组，则上面定义的`minMax(array:)`函数将在尝试访问数`array[0]`时触发运行时错误。

要安全地处理空数组，请使用可选的元组返回类型编写`minMax(array:)`函数，并在数组为空时返回`nil`值：

```swift
func minMax(array: [Int]) -> (min: Int, max: Int)? {
   if array.isEmpty { return nil }
   var currentMin = array[0]
   var currentMax = array[0]
   for value in array[1..<array.count] {
       if value < currentMin {
           currentMin = value
       } else if value > currentMax {
           currentMax = value
        }
   }
   return (currentMin, currentMax)
}
```

您可以使用可选绑定来检查此版本的`minMax(array:)`函数是返回实际元组值还是`nil`：

```swift
if let bounds = minMax(array: [8, -6, 2, 109, 3, 71]) {
   print("min is \(bounds.min) and max is \(bounds.max)")
}
// Prints "min is -6 and max is 109"
```

### 具有隐式返回的函数

如果函数的整个主体都是单个表达式，则函数隐式返回该表达式。例如，以下两个函数都有相同的行为：

```swift
func greeting(for person: String) -> String {
   "Hello, " + person + "!"
}
print(greeting(for: "Dave"))
// Prints "Hello, Dave!"

func anotherGreeting(for person: String) -> String {
   return "Hello, " + person + "!"
}
print(anotherGreeting(for: "Dave"))
// Prints "Hello, Dave!"
```

`greeting(for:)`函数的整个定义是它返回的问候信息，这意味着它可以使用这种较短的形式。`anotherGreeting(for:)`函数返回相同的问候信息，像使用较长的函数一样使用`return`关键字。您仅写为一条`return`行的任何函数都可以省略`return`。

正如您在[速记获取声明](https://docs.swift.org/swift-book/LanguageGuide/Properties.html#ID608)中看到的那样，属性获取者也可以使用隐式返回。

> 注意
>
> 您写入的隐式返回值的代码需要返回一些值。例如，您不能使用`print(13)`作为隐式返回值。但是，您可以使用一个永远不会返回 likefatalError`fatalError("Ohno!")`函数作为隐式返回值，因为Swift知道隐式返回不会发生。

## 函数参数标签和参数名称

每个函数参数都有一个*参数标签*和一个*参数名称*。调用函数时使用参数标签；每个参数都写在函数调用中，前面有参数标签。参数名称用于实现函数。默认情况下，参数使用其参数名称作为参数标签。

```swift
func someFunction(firstParameterName: Int, secondParameterName: Int) {
   // In the function body, firstParameterName and secondParameterName
   // refer to the argument values for the first and second parameters.
}
someFunction(firstParameterName: 1, secondParameterName: 2)
```

所有参数都必须有唯一的名称。虽然多个参数可能具有相同的参数标签，但唯一的参数标签有助于使您的代码更具可读性。

### 指定参数标签

您在参数名称之前写一个参数标签，用空格分隔：

```swift
func someFunction(argumentLabel parameterName: Int) {
   // In the function body, parameterName refers to the argument value
   // for that parameter.
}
```

以下是`greet(person:)`功能的变体，该函数采用一个人的名字和家乡，并返回问候语：

```swift
func greet(person: String, from hometown: String) -> String {
   return "Hello \(person)!  Glad you could visit from \(hometown)."
}
print(greet(person: "Bill", from: "Cupertino"))
// Prints "Hello Bill!  Glad you could visit from Cupertino."
```

使用参数标签可以允许以表达式、类似句子的方式调用函数，同时仍然提供可读且意图清晰的函数体。

### 省略参数标签

如果您不想要参数的参数标签，请为该参数写一个下划线（`_`），而不是显式参数标签。

```swift
func someFunction(_ firstParameterName: Int, secondParameterName: Int) {
   // In the function body, firstParameterName and secondParameterName
   // refer to the argument values for the first and second parameters.
}
someFunction(1, secondParameterName: 2)
```

如果参数有参数标签，则在调用函数时*必须*标记参数。

### 默认参数值

您可以通过在该参数类型之后为参数分配值来定义函数中任何参数的*默认值*。如果定义了默认值，您可以在调用函数时省略该参数。

```swift
func someFunction(parameterWithoutDefault: Int, parameterWithDefault: Int = 12) {
   // If you omit the second argument when calling this function, then
   // the value of parameterWithDefault is 12 inside the function body.
}
someFunction(parameterWithoutDefault: 3, parameterWithDefault: 6) // parameterWithDefault is 6
someFunction(parameterWithoutDefault: 4) // parameterWithDefault is 12
```

将没有默认值的参数放在函数参数列表的开头，放在具有默认值的参数之前。如果没有默认值的参数通常对函数的含义更重要——首先写入它们可以更容易识别正在调用相同的函数，无论是否省略任何默认参数。

### 变量参数

*变参数*接受指定类型的零个或多个值。您使用变异参数来指定在调用函数时可以传递不同数量的输入值。通过在参数的类型名称后插入三个句号字符（`...`）来编写变量参数。

传递给变量参数的值作为适当类型的数组在函数的主体内提供。例如，具有`numbers`名称和`Double...`类型的变量参数在函数的主体中作为称为类型`[Double]``numbers`的常数数组提供。

以下示例计算了任何长度的数字列表的*算术平均值*（也称为*平均值*）：

```swift
func arithmeticMean(_ numbers: Double...) -> Double {
   var total: Double = 0
   for number in numbers {
       total += number
   }
   return total / Double(numbers.count)
}
arithmeticMean(1, 2, 3, 4, 5)
// returns 3.0, which is the arithmetic mean of these five numbers
arithmeticMean(3, 8.25, 18.75)
// returns 10.0, which is the arithmetic mean of these three numbers
```

一个函数可以有多个变性参数。变参数之后的第一个参数必须有一个参数标签。参数标签明确了哪些参数传递给变分参数，哪些参数传递给变分参数之后的参数。

### 输入输出参数

默认情况下，函数参数是常量。试图从该函数主体内更改函数参数的值会导致编译时错误。这意味着您不能错误地更改参数的值。如果您希望函数修改参数的值，并希望这些更改在函数调用结束后持续存在，请将该参数定义为*进出参数*。

您可以通过将输入关键字放在参数类型之前来编写`inout`输出参数。入出参数有一个值，该值被传递给函数，由函数修改，并*从*函数中传递回来以替换原始值。有关进出参数和相关编译器优化行为的详细讨论，请参阅[输入输出参数](https://docs.swift.org/swift-book/ReferenceManual/Declarations.html#ID545)。

您只能传递一个变量作为进出参数的参数。您不能传递常量或字面值作为参数，因为常量和文字无法修改。当您将安培数（`&`）作为参数传递给输入输出参数时，将它直接放在变量名称之前，以指示函数可以修改它。

> 注意
>
> 进出参数不能有默认值，变分参数不能标记为`inout`。

这是一个名为`swapTwoInts(_:_:)`的函数示例，它有两个名为`a`和`b`的输入输出整数参数：

```swift
func swapTwoInts(_ a: inout Int, _ b: inout Int) {
   let temporaryA = a
   a = b
   b = temporaryA
}
```

' swaptwints(::) '函数只是将' b '的值交换为' a '， ' a '的值交换为' b '。函数通过将' a '的值存储在一个名为' temporaryA '的临时常量中，将' b '的值赋给' a '，然后将' temporaryA '赋给' b '来执行交换。

您可以调用具有`Int`类型为两个变量的swapTwoInts`swapTwoInts(_:_:)`函数来交换其值。请注意，`someInt`和`anotherInt`的名称前缀为安培，当它们传递给swapTwoInts`swapTwoInts(_:_:)`函数时：

```swift
var someInt = 3
var anotherInt = 107
swapTwoInts(&someInt, &anotherInt)
print("someInt is now \(someInt), and anotherInt is now \(anotherInt)")
// Prints "someInt is now 107, and anotherInt is now 3"
```

上面的示例表明，`someInt`和`anotherInt`的原始值被swapTwoInts`swapTwoInts(_:_:)`函数修改，即使它们最初是在函数之外定义的。

> 注意
>
> 输入输出参数与从函数返回值不同。上面的`swapTwoInts`示例没有定义返回类型或返回值，但它仍然修改了`someInt`和`anotherInt`的值。输入输出参数是函数在其函数体范围之外产生效果的另一种方式。

## 功能类型

每个函数都有特定的*函数类型*，由参数类型和函数的返回类型组成。

例如：

```swift
func addTwoInts(_ a: Int, _ b: Int) -> Int {
   return a + b
}
func multiplyTwoInts(_ a: Int, _ b: Int) -> Int {
   return a * b
}
```

此示例定义了两个简单的数学函数，称为`addTwoInts`和`multiplyTwoInts`。这些函数各接受两个`Int`值，并返回一个`Int`值，这是执行适当数学运算的结果。

这两个函数的类型都是' (Int, Int) -> Int '。这可以理解为:

“具有两个参数的函数，两个参数都是`Int`类型，并且返回`Int`类型的值。”

以下是另一个例子，对于没有参数或返回值的函数：

```swift
func printHelloWorld() {
   print("hello, world")
}
```

这个函数的类型是' ()-> Void '，或者"一个没有参数的函数，返回' Void ' "。

### 使用功能类型

您使用的功能类型就像 Swift 中的任何其他类型一样。例如，您可以将常量或变量定义为函数类型，并为该变量分配适当的函数：

```swift
var mathFunction: (Int, Int) -> Int = addTwoInts
```

这可以理解为：

“定义一个名为`mathFunction`的变量，该变量具有一种‘接受两个`Int`值并返回一个`Int`值的函数’。将这个新变量设置为引用名为`addTwoInts`函数。”

`addTwoInts(_:_:)`函数具有与`mathFunction`变量相同的类型，因此Swift的类型检查器允许此分配。

您现在可以调用名为`mathFunction`的分配函数：

```swift
print("Result: \(mathFunction(2, 3))")
// Prints "Result: 5"
```

具有相同匹配类型的不同函数可以分配给相同的变量，就像非函数类型一样：

```swift
mathFunction = multiplyTwoInts
print("Result: \(mathFunction(2, 3))")
// Prints "Result: 6"
```

与任何其他类型一样，当您将函数分配给常量或变量时，您可以将其留给Swift来推断函数类型：

```swift
let anotherMathFunction = addTwoInts
// anotherMathFunction is inferred to be of type (Int, Int) -> Int
```

### 函数类型作为参数类型

你可以使用像' (Int, Int) -> Int '这样的函数类型作为另一个函数的形参类型。这使您能够将函数实现的某些方面留给函数的调用者来提供。

以下是从上面打印数学函数结果的示例：

```swift
func printMathResult(_ mathFunction: (Int, Int) -> Int, _ a: Int, _ b: Int) {
   print("Result: \(mathFunction(a, b))")
}
printMathResult(addTwoInts, 3, 5)
// Prints "Result: 8"
```

这个例子定义了一个名为' printMathResult(:::) '的函数，它有三个参数。第一个参数叫做' mathFunction '，其类型为' (Int, Int) -> Int '。您可以传递该类型的任何函数作为第一个参数的实参。第二个和第三个形参称为' a '和' b '，都是' Int '类型。它们用作所提供的数学函数的两个输入值。

当调用`printMathResult(_:_:_:)`时，它传递了`addTwoInts(_:_:)`函数以及整数值`3`和5。它调用值为`3`和5的函数，并打印8的结果。

`printMathResult(_:_:_:)`的作用是打印对适当类型的数学函数的调用结果。该函数的实现实际做什么并不重要，重要的是该函数的类型是否正确。这使`printMathResult(_:_:_:)`能够以类型安全的方式将其部分功能移交给函数的调用者。

### 函数类型作为返回类型

您可以使用函数类型作为另一个函数的返回类型。您可以通过在返回函数的返回箭头（`->`）后立即写入完整的函数类型来做到这一点。

下一个例子定义了两个简单的函数，分别叫做“stepForward(:)”和“stepBackward(:)”。' stepForward(:) '函数返回的值比其输入值大1，' stepBackward(:) '函数返回的值比其输入值小1。两个函数都具有' (Int) -> Int '类型:

```swift
func stepForward(_ input: Int) -> Int {
   return input + 1
}
func stepBackward(_ input: Int) -> Int {
   return input - 1
}
```

这里有一个函数叫做' chooseStepFunction(backward:) '，它的返回类型是' (Int) -> Int '。' chooseStepFunction(backward:) '函数返回' stepForward(:) '函数或' stepBackward(:) '函数，该函数基于一个名为' backward '的布尔形参:

```swift
func chooseStepFunction(backward: Bool) -> (Int) -> Int {
  return backward ? stepBackward : stepForward
}
```

您现在可以使用`chooseStepFunction(backward:)`获取将向一个或另一个方向前进的函数：

1. var currentValue = 3
2. let moveNearerToZero = chooseStepFunction(backward: currentValue > 0)
3. // moveNearerToZero now refers to the stepBackward() function

上面的例子决定了将一个名为“currentValue”的变量移动到逐渐接近零的位置时，是需要一个正的步骤还是负的步骤。' currentValue '的初始值为' 3 '，这意味着' currentValue > 0 '返回' true '，导致' chooseStepFunction(backward:) '返回' stepBackward(:) '函数。对返回函数的引用存储在一个名为“moveNearerToZero”的常量中。

现在' moveNearerToZero '指向了正确的函数，它可以被用来计数到0:

```swift
print("Counting to zero:")
// Counting to zero:
while currentValue != 0 {
   print("\(currentValue)... ")
   currentValue = moveNearerToZero(currentValue)
}
print("zero!")
// 3...
// 2...
// 1...
// zero!
```

## 嵌套函数

到目前为止，您在本章中遇到的所有函数都是*全局函数*的示例，这些*函数*是在全局范围内定义的。您还可以定义其他函数主体内的函数，称为*嵌套函数*。

默认情况下，嵌套函数对外部世界隐藏，但仍然可以被其封闭函数调用和使用。封闭函数也可以返回其嵌套函数之一，以允许嵌套函数在另一个作用域中使用。

您可以重写上面的`chooseStepFunction(backward:)`示例来使用和返回嵌套函数：

```swift
func chooseStepFunction(backward: Bool) -> (Int) -> Int {
   func stepForward(input: Int) -> Int { return input + 1 }
   func stepBackward(input: Int) -> Int { return input - 1 }
   return backward ? stepBackward : stepForward
}
var currentValue = -4
let moveNearerToZero = chooseStepFunction(backward: currentValue > 0)
// moveNearerToZero now refers to the nested stepForward() function
while currentValue != 0 {
   print("\(currentValue)... ")
   currentValue = moveNearerToZero(currentValue)
}
print("zero!")
// -4...
// -3...
// -2...
// -1...
// zero!
```

