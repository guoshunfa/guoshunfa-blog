---
title: Swift基础 控制流程
tags:
    - Swift
    - 基础
categories:
    - Swift
date: 2022-07-01 12:01:01
thumbnail:
---

翻译自：https://docs.swift.org/swift-book/LanguageGuide/ControlFlow.html

Swift提供了各种控制流语句。这些包括`while`循环多次执行任务；`if`、`guard`和`switch`语句，以根据特定条件执行不同的代码分支；以及`break`和`continue`将执行流程转移到代码中的另一个点等语句。

Swift还提供了一个`for`-`in`循环，可以轻松地在数组、字典、范围、字符串和其他序列上迭代。

Swift的`switch`语句在许多类似C语言中比它的对应语句强大得多。案例可以匹配许多不同的模式，包括间隔匹配、元组和特定类型的转换。`switch`情况下的匹配值可以绑定到临时常量或变量，以便在案例正文中使用，复杂的匹配条件可以用每个案例的`where`子句表示。

## For-In循环

您可以使用`for`-`in`循环迭代序列，例如数组中的项、数字范围或字符串中的字符。

此示例使用`for`-`in`循环来迭代数组中的项目：

```swift
let names = ["Anna", "Alex", "Brian", "Jack"]
for name in names {
   print("Hello, \(name)!")
}
// Hello, Anna!
// Hello, Alex!
// Hello, Brian!
// Hello, Jack!
```

您还可以迭代字典以访问其键值对。字典迭代时，字典中的每个项目都会作为`(key,value)`元组返回，您可以将`(key,value)`元组的成员分解为显式命名的常量，以便在`for`-`in`循环的正文中使用。在下面的代码示例中，字典的键被分解为名为`animalName`的常量，字典的值被分解为名为`legCount`的常量。

```swift
let numberOfLegs = ["spider": 8, "ant": 6, "cat": 4]
for (animalName, legCount) in numberOfLegs {
   print("\(animalName)s have \(legCount) legs")
}
// cats have 4 legs
// ants have 6 legs
// spiders have 8 legs
```



`Dictionary`的内容本质上是无序的，迭代它们并不能保证检索它们的顺序。特别是，您在`Dictionary`中插入项目的顺序并不能定义它们迭代的顺序。有关数组和字典的更多信息，请参阅[集合类型](https://docs.swift.org/swift-book/LanguageGuide/CollectionTypes.html)。

您还可以使用数字范围的`for`-`in`循环。此示例打印五次表中的前几个条目：

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

正在迭代的序列是从`1`到5的数字范围，包括使用闭区间运算符（`...`）所示。`index`的值设置为范围（1）中的第一个数字，并执行循环中的语句。在这种情况下，循环只包含一个语句，该语句从五次表中打印`index`当前值的条目。执行语句后，`index`值将更新为包含范围（2）中的第二个值，并再次调用`print(_:separator:terminator:)`函数。这个过程一直持续到范围结束。

在上面的示例中，`index`是一个常量，其值在循环每次迭代开始时自动设置。因此，`index`在使用之前不必声明。它仅通过包含在循环声明中来隐式声明，而无需`let`声明关键字。

如果您不需要序列中的每个值，您可以使用下划线代替变量名称来忽略这些值。

```swift
let base = 3
let power = 10
var answer = 1
for _ in 1...power {
   answer *= base
}
print("\(base) to the power of \(power) is \(answer)")
// Prints "3 to the power of 10 is 59049"
```

上面的示例计算了一个数字对另一个数字幂的值（在这种情况下，`3`到`10`的幂）。它使用以`1`开头和以10结尾的闭合范围将`1`（即`3`到`0`的幂）乘以3、十倍。对于此计算，每次通过循环的单个计数器值是不必要的——代码只需正确执行循环次数。代替循环变量的下划线字符（`_`）会导致单个值被忽略，并且在循环的每次迭代中不提供对当前值的访问。

在某些情况下，您可能不想使用闭合范围，包括两个端点。考虑在表盘上每分钟绘制刻度。你想画`60`勾号，从`0`分钟开始。使用半开范围运算符（`..<`）包括下界，但不包括上界。有关范围的更多信息，请参阅[范围操作员](https://docs.swift.org/swift-book/LanguageGuide/BasicOperators.html#ID73)。

```swift
let minutes = 60
for tickMark in 0..<minutes {
   // render the tick mark each minute (60 times)
}
```

一些用户可能希望在他们的UI中少打勾。他们可以选择每“5”分钟打一个分数。使用' `stride(from:to:by:)` '函数来跳过不需要的标记。

```swift
let minuteInterval = 5
for tickMark in stride(from: 0, to: minutes, by: minuteInterval) {
   // render the tick mark every 5 minutes (0, 5, 10, 15 ... 45, 50, 55)
}
```

闭合范围也可用，使用 `stride(from:through:by:)`代替：

```swift
let hours = 12
let hourInterval = 3
for tickMark in stride(from: 3, through: hours, by: hourInterval) {
   // render the tick mark every 3 hours (3, 6, 9, 12)
}
```

上面的示例使用`for`-`in`循环来迭代范围、数组、字典和字符串。但是，您可以使用此语法迭代*任何*集合，包括您自己的类和集合类型，只要这些类型符合[`Sequence`](https://developer.apple.com/documentation/swift/sequence)协议。

## While循环

`while`循环执行一组语句，直到条件变成`false`。当第一次迭代开始前不知道迭代次数时，最好使用这些类型的循环。Swift提供了两种类型的`while`循环：

- `while`在每次通过循环开始时评估其状态。
- `repeat`-`while`在每次通过循环结束时评估其状态。

### While

`while`循环从评估单个条件开始。如果条件为`true`，则重复一组语句，直到条件变为`false`。

以下是`while`循环的一般形式：

1. while `condition` {
2. ​    `statements`
3. }

这个例子玩一个简单的*蛇和梯子*游戏（也称为*滑槽和梯子*）：

![../_images/snakesAndLadders_2x.png](Swift基础-控制流程/202204051010377.png)

游戏规则如下：

- 董事会有25个正方形，目标是降落在25个正方形或25个以上。
- 玩家的起始方块是“正方形零”，就在棋盘的左下角。
- 每次转弯，您滚动一个六面骰子，并沿着上面虚线箭头指示的水平路径按该数量的正方形移动。
- 如果你的转弯在梯子底部结束，你就向上移动。
- 如果你的转弯在蛇的头上结束，你就沿着那条蛇向下移动。

游戏板由`Int`值数组表示。它的大小基于一个名为`finalSquare`常量，该常量用于初始化数组，并在示例后面检查获胜条件。因为玩家从棋盘开始，在“平方零”上，棋盘初始化为26个零`Int`值，而不是25个。

```swift
let finalSquare = 25
var board = [Int](repeating: 0, count: finalSquare + 1)
```

然后将一些正方形设置为蛇和梯子具有更具体的值。带梯子底座的正数可以将您向上移动，而带蛇头的正方形则有一个负数将您移回板上。

```swift
board[03] = +08; board[06] = +11; board[09] = +09; board[10] = +02
board[14] = -10; board[19] = -11; board[22] = -02; board[24] = -08
```

正方形3包含一个梯子的底部，该梯子将您移动到正方形11。为了表示这一点，`board[03]`等于`+08`，这相当于整数值`8`（`3`和`11`之间的差）。为了对齐值和语句，一元加运算符（`+i`）显式地与一元减运算符（`-i`）一起使用，小于`10`的数字用零填充。（两者都不是严格必要的文体技术，但它们会导致代码更整洁。）

```swift
var square = 0
var diceRoll = 0
while square < finalSquare {
   // roll the dice
   diceRoll += 1
   if diceRoll == 7 { diceRoll = 1 }
   // move by the rolled amount
   square += diceRoll
   if square < board.count {
       // if we're still on the board, move up or down for a snake or a ladder
       square += board[square]
   }
}
print("Game over!")
```

上面的例子使用一种非常简单的方法来掷骰子。它不是生成随机数，而是以`diceRoll`值`0`开头。每次通过`while`循环，`diceRoll`都会增加一个，然后检查它是否变得太大。每当这个返回值等于7时，骰子卷就变得太大，并重置为1。结果是一系列`diceRoll`值，总是1、2、3、4、5、6、1、`2`等等。

掷骰子后，玩家通过`diceRoll`正方形向前移动。骰子卷可能已经将玩家移到了25方块之外，在这种情况下，游戏就结束了。为了应对这种情况，代码检查该`square`小于`board`数组的`count`属性。如果`square`有效，则将存储在`board[square]`中的值添加到当前`square`值中，以向上或向下移动任何梯子或蛇。

> 注意
>
> 如果不执行此检查，`board[square]`可能会尝试访问`board`数组范围之外的值，这将触发运行时错误。

然后，电流`while`循环执行结束，并检查循环的条件，看看是否应该再次执行循环。如果玩家在正方形25上移动或超过25，循环的条件将计算为`false`，游戏结束。

在这种情况下，`while`循环是合适的，因为`while`循环开始时游戏的长度不明确。相反，循环被执行，直到满足特定条件。

### Repeat-While

`while`循环的另一个变体，称为`repeat``while`循环，在考虑循环的条件*之前*，先执行一次循环块的传递。然后，它继续重复循环，直到条件为`false`。

> 注意
>
> Swift 中的`repeat`循环类似于其他语言中的`while`循环。

以下是`repeat`循环的一般形式：

1. repeat {
2. ​    `statements`
3. } while `condition`

这是*蛇和梯子*的例子，写成`repeat`循环，而不是`while`循环。`finalSquare`、`board`、`square`和`diceRoll`的值初始化方式与`while`循环完全相同。

```swift
let finalSquare = 25
var board = [Int](repeating: 0, count: finalSquare + 1)
board[03] = +08; board[06] = +11; board[09] = +09; board[10] = +02
board[14] = -10; board[19] = -11; board[22] = -02; board[24] = -08
var square = 0
var diceRoll = 0
```

在这个版本的游戏中，循环中*的第一个*动作是检查梯子或蛇。棋盘上没有梯子将玩家直接带到25号方块，因此不可能通过向上移动梯子来赢得比赛。因此，检查蛇或梯子作为循环中的第一个动作是安全的。

在游戏开始时，玩家处于“平方零”。`board[0]`总是等于`0`，没有效果。

```swift
repeat {
   // move up or down for a snake or ladder
   square += board[square]
   // roll the dice
   diceRoll += 1
   if diceRoll == 7 { diceRoll = 1 }
   // move by the rolled amount
   square += diceRoll
} while square < finalSquare
print("Game over!")
```

在代码检查蛇和梯子后，掷骰子，玩家被`diceRoll`正方形向前移动。然后，当前的循环执行结束。

循环的条件（`whilesquare<finalSquare`）与以前相同，但这次要到第一次循环运行*结束时*才会进行评估。`repeat`循环的结构比上一个示例中的`while`循环更适合这个游戏。在上面的`while`循环中，`square+=board[square]`总是在循环*后立即*执行，`while`条件确认`square`仍在板上。此行为消除了前面描述的游戏`while`循环版本中对数组边界检查的需求。

## 条件声明

根据特定条件执行不同的代码通常非常有用。您可能希望在发生错误时运行额外的代码，或者在值变得太高或太低时显示消息。为此，您可以将部分代码*附加条件*。

Swift提供了两种向代码添加条件分支的方法：`if`语句和`switch`语句。通常，您使用`if`语句来评估只有少数可能结果的简单条件。`switch`语句更适合具有多种可能排列的更复杂条件，在模式匹配可以帮助选择适当的代码分支执行的情况下非常有用。

### if

在最简单的形式中，`if`语句有一个单一的`if`条件。只有当条件为`true`时，它才会执行一组语句。

```swift
var temperatureInFahrenheit = 30
if temperatureInFahrenheit <= 32 {
   print("It's very cold. Consider wearing a scarf.")
}
// Prints "It's very cold. Consider wearing a scarf."
```

上面的例子检查温度是小于还是等于32华氏度（水的冰点）。如果是，则打印一条消息。否则，不会打印消息，代码执行在`if`语句的关闭大括号后继续。

`if`语句可以为`if`条件为`false`的情况提供一组替代语句，称为*e else子句*。这些语句由`else`关键字表示。

```swift
temperatureInFahrenheit = 40
if temperatureInFahrenheit <= 32 {
   print("It's very cold. Consider wearing a scarf.")
} else {
   print("It's not that cold. Wear a t-shirt.")
}
// Prints "It's not that cold. Wear a t-shirt."
```

这两个分支中的一个总是被执行的。由于温度已升至华氏`40`度，因此不再足够冷，无法建议戴围巾，因此会触发`else`分支。

您可以将多个`if`语句链接在一起，以考虑其他子句。

```swift
temperatureInFahrenheit = 90
if temperatureInFahrenheit <= 32 {
   print("It's very cold. Consider wearing a scarf.")
} else if temperatureInFahrenheit >= 86 {
   print("It's really warm. Don't forget to wear sunscreen.")
} else {
  print("It's not that cold. Wear a t-shirt.")
}
// Prints "It's really warm. Don't forget to wear sunscreen."
```

在这里，添加了一个额外的`if`语句，以应对特别温暖的温度。最后的`else`句仍然存在，它打印了对任何既不太温暖也不太冷的温度的响应。

然而，最终的al `else`子句是可选的，如果一组条件不需要完整，则可以排除。

```swift
temperatureInFahrenheit = 72
if temperatureInFahrenheit <= 32 {
   print("It's very cold. Consider wearing a scarf.")
} else if temperatureInFahrenheit >= 86 {
   print("It's really warm. Don't forget to wear sunscreen.")
}
```

由于温度既不太冷也不太暖，无法触发`if`或`if`条件，因此没有打印任何消息。

### switch

`switch`语句考虑一个值，并将其与几种可能的匹配模式进行比较。然后，它根据第一个成功匹配的模式执行适当的代码块。`switch`语句提供了`if`语句的替代方案，用于响应多个潜在状态。

以最简单的形式，`switch`语句将一个值与同一类型的一个或多个值进行比较。

```swift
switch some value to consider {
case value 1:
   respond to value 1
case value 2,
    value 3:
   respond to value 2 or 3
default:
   otherwise, do something else
}
```

每个`switch`语句由多个可能的*大小写组成*，每个`case`关键字开头。除了与特定值进行比较外，Swift还为每种情况提供了几种方法来指定更复杂的匹配模式。本章后面将介绍这些选项。

`if`语句的正文一样，每个`case`都是代码执行的单独分支。`switch`语句决定应该选择哪个分支。此过程被称为对正在考虑的值进行*切换*。

每个`switch`语句必须*详尽无遗*。也就是说，所考虑的类型的每个可能值都必须与其中一个`switch`情况匹配。如果为每个可能的值提供一个案例不合适，您可以定义一个默认大小写，以涵盖任何未显式处理的值。此默认情况由`default`关键字表示，并且必须始终显示在最后。

此示例使用`switch`语句来考虑单个小写字符，称为`someCharacter`：

```swift
let someCharacter: Character = "z"
switch someCharacter {
case "a":
   print("The first letter of the alphabet")
case "z":
   print("The last letter of the alphabet")
default:
   print("Some other character")
}
// Prints "The last letter of the alphabet"
```

`switch`语句的第一个大小写与英语字母表`a`的第一个字母匹配，其第二个大小写与最后一个字母`z`匹配。由于`switch`必须为每个可能的字符（而不仅仅是每个字母字符）有一个大小写，因此此`switch`语句使用`default`大小写来匹配`a`和`z`以外的所有字符。该条款确保了`switch`语句详尽无遗。

### 没有隐含Fallthrough

与C和Objective-C中的`switch`语句不同，Swift中的`switch`语句不会默认地从每个案例的底部掉到下一个案例中。相反，整个`switch`语句在第一个匹配的`switch`案例完成后立即完成执行，而无需显式`break`语句。这使得`switch`语句比C中的交换机语句更安全、更易于使用，并避免错误地执行多个`switch`案例。

> 注意
>
> 虽然 Swift 中不需要`break`，但您可以使用`break`语句来匹配和忽略特定案例，或者在案例完成执行之前打破匹配的案例。有关详细信息，请参阅[切换语句中的断裂](https://docs.swift.org/swift-book/LanguageGuide/ControlFlow.html#ID139)。

每个案例的正文*必须*包含至少一个可执行的语句。编写以下代码无效，因为第一个案例为空：

```swift
let anotherCharacter: Character = "a"
switch anotherCharacter {
case "a": // Invalid, the case has an empty body
case "A":
   print("The letter A")
default:
   print("Not the letter A")
}
// This will report a compile-time error.
```

与C中的`switch`语句不同，此`switch`语句与`"a"`和`"A"`都不匹配。相反，它报告了一个编译时错误，`case"a":`不包含任何可执行语句。这种方法避免了从一个案例到另一个案例的意外故障，并使其意图更安全的代码更加清晰。

要使用同时匹配`"a"`和`"A"`的单个大小写进行`switch`请将这两个值组合成一个复合大小写，用逗号分隔值。

```swift
let anotherCharacter: Character = "a"
switch anotherCharacter {
case "a", "A":
   print("The letter A")
default:
   print("Not the letter A")
}
// Prints "The letter A"
```

为了可读性，复合情况也可以写在多行上。有关复合病例的更多信息，请参阅[复合案例](https://docs.swift.org/swift-book/LanguageGuide/ControlFlow.html#ID548)。

> 注意
>
> 要在特定`switch`大小写的末尾显式掉线，请使用`fallthrough`关键字，如[Fallthrough](https://docs.swift.org/swift-book/LanguageGuide/ControlFlow.html#ID140)中所述。

### 间隔匹配

`switch`情况下的值可以检查它们是否在间隔内包含。此示例使用数字间隔为任何大小的数字提供自然语言计数：

```swift
let approximateCount = 62
let countedThings = "moons orbiting Saturn"
let naturalCount: String
switch approximateCount {
case 0:
   naturalCount = "no"
case 1..<5:
   naturalCount = "a few"
case 5..<12:
   naturalCount = "several"
case 12..<100:
   naturalCount = "dozens of"
case 100..<1000:
   naturalCount = "hundreds of"
default:
   naturalCount = "many"
}
print("There are \(naturalCount) \(countedThings).")
// Prints "There are dozens of moons orbiting Saturn."
```

在上面的示例中，`approximateCount`在`switch`语句中计算。每个`case`都将该值与数字或区间进行比较。由于`approximateCount`的值在12到100之间，`naturalCount`被分配到`"dozens`并从`switch`语句中转移执行。

### 元组

您可以使用元组在同一`switch`语句中测试多个值。元组的每个元素都可以根据不同的值或值间隔进行测试。或者，使用下划线字符（`_`），也称为通配符模式，以匹配任何可能的值。

下面的示例取了一个（x，y）点，表示为类型的简单元组`(Int,Int)`并在示例后面的图表上对其进行分类。

```swift
let somePoint = (1, 1)
switch somePoint {
case (0, 0):
   print("\(somePoint) is at the origin")
case (_, 0):
   print("\(somePoint) is on the x-axis")
case (0, _):
   print("\(somePoint) is on the y-axis")
case (-2...2, -2...2):
   print("\(somePoint) is inside the box")
default:
   print("\(somePoint) is outside of the box")
}
// Prints "(1, 1) is inside the box"
```

<img src="https://file.pandacode.cn/blog/202204051023130.png" alt="../_images/coordinateGraphSimple_2x.png" style="zoom:50%;" />

`switch`语句确定该点是在原点（0，0）、红色x轴上、绿色y轴上、以原点为中心的蓝色4乘4框内，还是在框外。

与C不同，Swift允许多个`switch`考虑相同的值。事实上，点（0，0）可以匹配本示例中的所有*四个*情况。但是，如果可以进行多次匹配，则始终使用第一个匹配案例。点（0，0）将首先匹配`case(0,0)`因此所有其他匹配情况将被忽略。

### 价值绑定

`switch`大小写可以命名其匹配的值或值，以用于临时常量或变量，以便在正文中使用。这种行为被称为*值绑定*，因为值绑定到案例正文中的临时常量或变量。

下面的示例取了一个（x，y）点，表示为类型`(Int,Int)`的元组，并将其分类如下图：

```swift
let anotherPoint = (2, 0)
switch anotherPoint {
case (let x, 0):
   print("on the x-axis with an x value of \(x)")
case (0, let y):
   print("on the y-axis with a y value of \(y)")
case let (x, y):
   print("somewhere else at (\(x), \(y))")
}
// Prints "on the x-axis with an x value of 2"
```

<img src="https://file.pandacode.cn/blog/202204051024139.png" alt="../_images/coordinateGraphMedium_2x.png" style="zoom:50%;" />

`switch`语句决定了该点是在红色x轴上，还是在绿色y轴上，还是在其他地方（在两个轴上）。

这三种' switch '情况声明了占位符常量' x '和' y '，它们临时接受' anotherPoint '中的一个或两个元组值。第一种情况，' case (let x, 0) '，匹配任何点的' y '值为' 0 '，并将该点的' x '值赋给临时常数' x '。类似地，第二种情况，' case (0, let y) '，匹配任何点的' x '值为' 0 '，并将该点的' y '值赋给临时常数' y '。

声明临时常量后，它们可以在案例的代码块中使用。在这里，它们用于打印点的分类。

此`switch`语句没有`default`案例。最后一个案例，`caselet(x,y)`声明一个由两个占位符常量组成，可以匹配任何值。由于`anotherPoint`始终是两个值的元组，因此此情况与所有可能的剩余值匹配，并且不需要`default`大小写即可使`switch`语句详尽无遗。

### where

`switch`盒可以使用`where`子句来检查其他条件。

以下示例对以下图表上的（x，y）点进行了分类：

```swift
let yetAnotherPoint = (1, -1)
switch yetAnotherPoint {
case let (x, y) where x == y:
   print("(\(x), \(y)) is on the line x == y")
case let (x, y) where x == -y:
   print("(\(x), \(y)) is on the line x == -y")
case let (x, y):
   print("(\(x), \(y)) is just some arbitrary point")
}
// Prints "(1, -1) is on the line x == -y"
```

<img src="https://docs.swift.org/swift-book/_images/coordinateGraphComplex_2x.png" alt="../_images/coordinateGraphComplex_2x.png" style="zoom:50%;" />

' switch '语句确定这个点是在绿色对角线上的' x == y '，还是在紫色对角线上的' x == -y '，或者两者都不在。

三个`switch`情况声明占位符常量`x`和`y`，这些常量暂时接受 `yetAnotherPoint`的两个元组值。这些常量被用作`where`子句的一部分，以创建动态过滤器。`where`子句的条件计算为`true`时，`switch`大小写才匹配`point`的当前值。

与上一个示例一样，最终大小写匹配所有可能的剩余值，因此不需要`default`大小写来使`switch`语句详尽无遗。

### 复合病例

共享同一主体的多个开关案例可以通过在`case`后写多个模式组合，每个模式之间都有一个逗号。如果任何模式匹配，则认为情况匹配。如果列表很长，图案可以写在多行上。例如：

```swift
let someCharacter: Character = "e"
switch someCharacter {
case "a", "e", "i", "o", "u":
   print("\(someCharacter) is a vowel")
case "b", "c", "d", "f", "g", "h", "j", "k", "l", "m",
    "n", "p", "q", "r", "s", "t", "v", "w", "x", "y", "z":
   print("\(someCharacter) is a consonant")
default:
   print("\(someCharacter) isn't a vowel or a consonant")
}
// Prints "e is a vowel"
```

`switch`语句的第一个大小写与英语中的所有五个小写元音相匹配。同样，它的第二个大小写匹配所有小写英语辅音。最后，`default`大小写与任何其他字符匹配。

复合情况也可以包括值绑定。复合情况的所有模式都必须包含相同的值绑定集，并且每个绑定必须从复合情况下的所有模式中获得相同类型的值。这确保了无论复合情况的哪个部分匹配，大小写正文中的代码都可以始终访问绑定的值，并且该值始终具有相同的类型。

```swift
let stillAnotherPoint = (9, 0)
switch stillAnotherPoint {
case (let distance, 0), (0, let distance):
   print("On an axis, \(distance) from the origin")
default:
   print("Not on an axis")
}
// Prints "On an axis, 9 from the origin"
```

上述`case`有两种模式：`(letdistance,0)`匹配x轴上的点，`(0,letdistance)`匹配y轴上的点。这两种模式都包括`distance`的绑定，`distance`是两种模式中的整数——这意味着`case`正文中的代码始终可以访问`distance`值。

## 控制转移声明

*控制转移语句*通过将控制权从一段代码传输到另一段代码来更改代码的执行顺序。Swift有五个控制转移语句：

- `continue`
- `break`
- `fallthrough`
- `return`
- `throw`

`continue`、`break`和`fallthrough`的陈述如下所述。`return`语句在[函数](https://docs.swift.org/swift-book/LanguageGuide/Functions.html)中描述，`throw`语句在[使用抛出函数传播错误](https://docs.swift.org/swift-book/LanguageGuide/ErrorHandling.html#ID510)中描述。

### continue

`continue`语句告诉循环停止它正在做的事情，并在下一个迭代开始时通过循环重新开始。它说“我完成了当前的循环迭代”，而没有完全离开循环。

以下示例从小写字符串中删除所有元音和空格，以创建神秘的益智短语：

```swift
let puzzleInput = "great minds think alike"
var puzzleOutput = ""
let charactersToRemove: [Character] = ["a", "e", "i", "o", "u", " "]
for character in puzzleInput {
   if charactersToRemove.contains(character) {
       continue
   }
   puzzleOutput.append(character)
}
print(puzzleOutput)
// Prints "grtmndsthnklk"
```

上面的代码每当它匹配元音或空格时都会调用`continue`关键字，导致循环的当前迭代立即结束，并直接跳转到下一个迭代的开始。

### break

`break`语句立即结束整个控制流语句的执行。当您想提前终止`switch`或循环语句的执行时，可以在`switch`或循环语句中使用。

#### 打破循环语句

当在循环语句中使用时，`break`会立即结束循环的执行，并在循环的关闭大括号（`}`）后将控制权传输到代码。没有执行循环当前迭代的进一步代码，也没有开始循环的进一步迭代。

#### 切换语句中的中断

当在`switch`语句中使用时，`break`会导致`switch`语句立即结束执行，并在`switch`语句的关闭大括号（`}`）后将控制权转移到代码中。

此行为可用于匹配和忽略`switch`语句中的一个或多个案例。由于 Swift 的`switch`语句非常详尽，不允许空案例，因此有时需要故意匹配和忽略案例，以便明确您的意图。您通过将`break`声明写成您要忽略的整个案例正文来做到这一点。当该案例与`switch`语句匹配时，案例中的`break`语句将立即结束`switch`语句的执行。

> 注意
>
> 仅包含注释的`switch`案例被报告为编译时错误。评论不是陈述，也不会导致`switch`案例被忽略。务必使用`break`语句来忽略`switch`案例。

以下示例切换`Character`值，并确定它是否代表四种语言之一的数字符号。为了简洁起，单个`switch`案例中包含多个值。

```swift
let numberSymbol: Character = "三"  // Chinese symbol for the number 3
var possibleIntegerValue: Int?
switch numberSymbol {
case "1", "١", "一", "๑":
   possibleIntegerValue = 1
case "2", "٢", "二", "๒":
   possibleIntegerValue = 2
case "3", "٣", "三", "๓":
   possibleIntegerValue = 3
case "4", "٤", "四", "๔":
   possibleIntegerValue = 4
default:
   break
}
if let integerValue = possibleIntegerValue {
   print("The integer value of \(numberSymbol) is \(integerValue).")
} else {
   print("An integer value couldn't be found for \(numberSymbol).")
}
// Prints "The integer value of 三 is 3."
```

此示例检查`numberSymbol`，以确定数字`1`到4的符号是拉丁文、阿拉伯文、中文还是泰语符号。如果找到匹配项，`switch`语句的一个案例会设置一个可选的`Int?`变量称为`possibleIntegerValue`到适当的整数值。

在`switch`语句完成执行后，该示例使用可选绑定来确定是否找到了值。由于是可选类型，`possibleIntegerValue`变量的隐式初始值为`nil`，因此只有当`possibleIntegerValue`被`switch`语句的前四种情况之一设置为实际值时，可选绑定才会成功。

因为在上面的例子中列出所有可能的' Character '值是不实际的，所以' default ' case处理任何不匹配的字符。这种' default '情况不需要执行任何操作，所以它是用一个' break '语句作为它的主体编写的。只要匹配到' default '的大小写，' break '语句就会结束' switch '语句的执行，代码的执行从' if let '语句开始。

### fallthrough

在 Swift 中，`switch`语句不会从每个案例的底部掉到下一个案例中。也就是说，整个`switch`语句在第一个匹配案例完成后立即完成执行。相比之下，C要求您在每个`switch`盒的末尾插入一个显式`break`语句，以防止掉线。避免默认的故障意味着Swift`switch`语句比C中的对应语句更简洁、更可预测，因此它们避免错误地执行多个`switch`案例。

如果您需要C型跌倒性行为，您可以使用`fallthrough`关键字逐案选择加入此行为。下面的示例使用`fallthrough`创建数字的文本描述。

```swift
let integerToDescribe = 5
var description = "The number \(integerToDescribe) is"
switch integerToDescribe {
case 2, 3, 5, 7, 11, 13, 17, 19:
   description += " a prime number, and also"
   fallthrough
default:
   description += " an integer."
}
print(description)
// Prints "The number 5 is a prime number, and also an integer."
```

此示例声明一个名为`description`的新`String`变量，并为其分配初始值。然后，函数使用`switch`语句考虑`integerToDescribe`的值。如果`integerToDescribe`的值是列表中的素数之一，则函数会将文本附加到`description`的末尾，以注意该数字是素数。然后，它使用`fallthrough`关键字来“落入”`default`情况。`default`情况下，在描述的末尾添加了一些额外的文本，`switch`语句已完成。

除非`integerToDescribe`的值在已知素数列表中，否则它根本不与第一个`switch`情况匹配。由于没有其他特定情况，`integerToDescribe`与`default`情况匹配。

`switch`语句执行完成后，使用`print(_:separator:terminator:)`函数打印数字描述。在本例中，数字`5`被正确标识为素数。

> 注意
>
> `fallthrough`关键字不会检查它导致执行陷入的`switch`案例的大小写条件。`fallthrough`关键字只是导致代码执行直接移动到下一个案例（或`default`大小写）块中的语句，就像C的标准`switch`语句行为一样。

### 带标签的语句

在Swift中，您可以在其他循环和条件语句中嵌套循环和条件语句，以创建复杂的控制流结构。然而，循环语句和条件语句都可以使用`break`语句过早地结束其执行。因此，有时明确您希望`break`语句终止哪个循环或条件语句是有用的。同样，如果您有多个嵌套循环，明确`continue`语句应该影响哪个循环可能会有用。

为了实现这些目标，您可以使用*声明标签*标记循环语句或条件语句。使用条件语句，您可以使用带有`break`语句的语句标签来结束标记语句的执行。使用循环语句，您可以使用带有`break`或`continue`语句的语句标签来结束或继续执行标记语句。

标记语句通过在与语句的介绍关键字相同的行上放置标签来指示，后跟冒号。以下是`while`循环语法的一个示例，尽管所有循环和`switch`语句的原则都是一样的：

1. `label name`: while `condition` {
2. ​    `statements`
3. }

以下示例使用您在本章前面看到的*Snakes* and *Ladders*游戏改编版本的带有标签`while`循环的`break`*和*`continue`语句。这一次，游戏有一个额外的规则：

- 要获胜，你必须*正好*降落在25号广场。

如果一个特定的骰子卷会带你超过25方块，你必须再次滚动，直到你滚动落在25方块所需的确切数字。

游戏板和以前一样。

![../_images/snakesAndLadders_2x.png](https://file.pandacode.cn/blog/202204051033766.png)

`finalSquare`、`board`、`square`和`diceRoll`的值与之前相同初始化：

```swift
let finalSquare = 25
var board = [Int](repeating: 0, count: finalSquare + 1)
board[03] = +08; board[06] = +11; board[09] = +09; board[10] = +02
board[14] = -10; board[19] = -11; board[22] = -02; board[24] = -08
var square = 0
var diceRoll = 0
```

这个版本的游戏使用`while`循环和`switch`语句来实现游戏的逻辑。`while`循环有一个名为`gameLoop`的语句标签，表示它是蛇和梯子游戏的主要游戏循环。

The `while` loop’s condition is `while square != finalSquare`, to reflect that you must land exactly on square 25.

```swift
gameLoop: while square != finalSquare {
   diceRoll += 1
   if diceRoll == 7 { diceRoll = 1 }
   switch square + diceRoll {
   case finalSquare:
       // diceRoll will move us to the final square, so the game is over
       break gameLoop
   case let newSquare where newSquare > finalSquare:
       // diceRoll will move us beyond the final square, so roll again
       continue gameLoop
   default:
       // this is a valid move, so find out its effect
       square += diceRoll
       square += board[square]
   }
}
print("Game over!")
```

骰子在每个循环的开头滚动。Loop不立即移动播放器，而是使用`switch`语句来考虑移动的结果，并确定是否允许移动：

- 如果掷骰子将玩家带到最后一个方格，那么游戏就结束了。“break gamelloop”语句将控制转移到“while”循环之外的第一行代码，从而结束游戏。
- 如果掷骰子将玩家移出最后的方格，那么这一移动就是无效的，玩家需要再次掷骰子。“continue gameLoop”语句结束当前的“while”循环迭代，并开始下一个循环迭代。
- 在所有其他情况下，掷骰子是一个有效的举动。玩家通过`diceRoll`方块向前移动，游戏逻辑检查是否有任何蛇和梯子。然后循环结束，控件返回到`while`条件，以决定是否需要再次回合。

> 注意
>
> 如果上面的`break`语句没有使用`gameLoop`标签，它将从`switch`语句中脱颖而出，而不是`while`语句。使用`gameLoop`标签可以明确应该终止哪个控制语句。

当调用“continue gameLoop”来跳转到循环的下一个迭代时，并不一定要使用“gameLoop”标签。游戏中只有一个循环，因此“continue”语句将影响哪个循环并不含糊。然而，在“continue”语句中使用“gameLoop”标签并没有什么坏处。这样做与标签的使用与“中断”声明是一致的，并有助于让游戏的逻辑更清晰地阅读和理解。

## 提前退出

`guard`语句，如`if`语句，根据表达式的布尔值执行语句。您使用`guard`语句要求条件必须为真，才能执行`guard`语句之后的代码。与`if`语句不同，`guard`语句总是有一个`else`子句——如果条件不正确，则执行`else`子句中的代码。

```swift
func greet(person: [String: String]) {
   guard let name = person["name"] else {
       return
   }

   print("Hello \(name)!")

   guard let location = person["location"] else {
       print("I hope the weather is nice near you.")
       return
   }

   print("I hope the weather is nice in \(location).")
}

greet(person: ["name": "John"])
// Prints "Hello John!"
// Prints "I hope the weather is nice near you."
greet(person: ["name": "Jane", "location": "Cupertino"])
// Prints "Hello Jane!"
// Prints "I hope the weather is nice in Cupertino."
```

如果满足`guard`语句的条件，则在`guard`语句的闭幕大括号后继续执行代码。使用可选绑定作为条件的一部分分配值的任何变量或常量都可用于`guard`语句中显示的代码块的其余部分。

如果不符合此条件，则执行`else`分支内的代码。该分支必须传输控件才能退出出现`guard`语句的代码块。它可以通过`return`、`break`、`continue`或`throw`等控件传输语句来执行此操作，也可以调用不返回的函数或方法，例如`fatalError(_:file:line:)`

与对`if`语句进行相同的检查相比，对需求使用`guard`语句可以提高代码的可读性。它允许您编写通常执行的代码，而无需将其包装在`else`块中，并允许您将处理违反要求的代码保留在需求旁边。

## 检查API可用性

Swift内置了对检查API可用性的支持，这确保您不会意外使用给定部署目标上不可用的API。

编译器使用SDK中的可用性信息来验证代码中使用的所有API是否在项目指定的部署目标上可用。如果您尝试使用不可用的API，Swift会在编译时报告错误。

您在`if`或`guard`语句中使用*可用性条件*执行代码块，具体取决于您要使用的API在运行时是否可用。编译器在验证该代码块中的API是否可用时，使用可用性条件中的信息。

```swift
if #available(iOS 10, macOS 10.12, *) {
   // Use iOS 10 APIs on iOS, and use macOS 10.12 APIs on macOS
} else {
   // Fall back to earlier iOS and macOS APIs
}
```

上述可用性条件指定，在iOS中，`if`语句的正文仅在iOS 10及更高版本中执行；在macOS中，仅在macOS 10.12及更高版本中执行。最后一个参数`*`是必需的，并指定在任何其他平台上，`if`的正文对目标指定的最小部署目标执行。

在其一般形式中，可用性条件接受平台名称和版本列表。您可以使用平台名称，如' iOS '， ' macOS '， ' watchOS '和' tvOS ' -完整的列表，请参阅[声明属性](https://docs.swift.org/swift-book/ReferenceManual/Attributes.html#ID348)。除了指定主要版本号(如iOS 8或macOS 10.10)外，还可以指定次要版本号(如iOS 11.2.6和macOS 10.13.3)。

```swift
if #available(platform name version, ..., *) {
   statements to execute if the APIs are available
} else {
   fallback statements to execute if the APIs are unavailable
}
```

