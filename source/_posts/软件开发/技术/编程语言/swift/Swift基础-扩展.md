---
title: Swift基础 扩展
tags:
    - Swift
    - 基础
categories:
    - Swift
date: 2022-07-01 12:01:01
thumbnail:
---


翻译自：https://docs.swift.org/swift-book/LanguageGuide/Extensions.html

*扩展*为现有类、结构、枚举或协议类型添加了新功能。这包括扩展您无法访问原始源代码（称为*追溯建模*）的类型的能力。扩展类似于Objective-C中的类别。（与Objective-C类别不同，Swift扩展没有名称。）

Swift中的扩展可以：

- 添加计算实例属性和计算类型属性
- 定义实例方法和类型方法
- 提供新的初始化器
- 定义下标
- 定义和使用新的嵌套类型
- 使现有类型符合协议

在 Swift 中，您甚至可以扩展协议，以提供其要求的实现，或添加符合要求的类型可以利用的其他功能。有关更多详细信息，请参阅[协议扩展](https://docs.swift.org/swift-book/LanguageGuide/Protocols.html#ID521)。

注意

扩展可以为类型添加新功能，但它们不能覆盖现有功能。

## 扩展语法

使用`extension`关键字声明扩展：

1. extension SomeType {
2. ​    // new functionality to add to SomeType goes here
3. }

扩展可以扩展现有类型，使其采用一个或多个协议。要添加协议一致性，您编写协议名称的方式与为类或结构编写协议名称的方式相同：

1. extension SomeType: SomeProtocol, AnotherProtocol {
2. ​    // implementation of protocol requirements goes here
3. }

以这种方式添加协议一致性在[使用扩展添加协议一致性](https://docs.swift.org/swift-book/LanguageGuide/Protocols.html#ID277)中[进行了](https://docs.swift.org/swift-book/LanguageGuide/Protocols.html#ID277)描述。

扩展可用于扩展现有的泛型类型，如[扩展通用类型](https://docs.swift.org/swift-book/LanguageGuide/Generics.html#ID185)中所述。您还可以扩展泛型类型以有条件地添加功能，如[带有通用Where子句的扩展](https://docs.swift.org/swift-book/LanguageGuide/Generics.html#ID553)中所述。

注意

如果您定义了一个扩展来向现有类型添加新功能，则该新功能将在该类型的所有现有实例上可用，即使它们是在定义扩展之前创建的。

## 计算属性

扩展可以将计算实例属性和计算类型属性添加到现有类型中。此示例为Swift的内置`Double`类型添加了五个计算实例属性，为使用距离单元提供基本支持：

1. extension Double {
2. ​    var km: Double { return self * 1_000.0 }
3. ​    var m: Double { return self }
4. ​    var cm: Double { return self / 100.0 }
5. ​    var mm: Double { return self / 1_000.0 }
6. ​    var ft: Double { return self / 3.28084 }
7. }
8. let oneInch = 25.4.mm
9. print("One inch is \(oneInch) meters")
10. // Prints "One inch is 0.0254 meters"
11. let threeFeet = 3.ft
12. print("Three feet is \(threeFeet) meters")
13. // Prints "Three feet is 0.914399970739201 meters"

这些计算属性表示，`Double`值应被视为一定的长度单位。虽然它们是作为计算属性实现的，但这些属性的名称可以附加到带有点语法的浮点字面值中，作为使用该字面值执行距离转换的一种方式。

在本例中，`1.0`的`Double`值被视为表示“一米”。这就是为什么`m`计算属性返回`self`——表达式`1.m`被认为是计算aDouble值`1.0`的原因。

其他单位需要一些转换才能表示为以米为单位的值。一公里与1000米相同，因此计算`km`属性将值乘以`1_000.00`，转换为以米为单位的数字。同样，一米有3.28084英尺，因此`ft`计算属性将底层`Double`值除以`3.28084`，将其从英尺转换为米。

这些属性是只读计算属性，因此它们在没有`get`关键字的情况下表示，以便简短。它们的返回值为`Double`类型，无论何时接受`Double`，都可以在数学计算中使用：

1. let aMarathon = 42.km + 195.m
2. print("A marathon is \(aMarathon) meters long")
3. // Prints "A marathon is 42195.0 meters long"

注意

扩展可以添加新的计算属性，但它们不能添加存储的属性，也不能向现有属性添加属性观察器。

## 初始化器

扩展可以为现有类型添加新的初始化器。这使您能够扩展其他类型，以接受自己的自定义类型作为初始化参数，或提供未作为类型原始实现的一部分的其他初始化选项。

扩展可以向类添加新的方便初始化器，但它们不能向类添加新的指定初始化器或去初始化器。指定的初始化器和去初始化器必须始终由原始类实现提供。

如果您使用扩展程序将初始化器添加到为其所有存储属性提供默认值且不定义任何自定义初始化器的值类型中，您可以从扩展的初始化器中调用该值类型的默认初始化器和成员初始化器。如果您将初始化器写为值类型原始实现的一部分，则情况并非如此，如[值类型的初始化委托](https://docs.swift.org/swift-book/LanguageGuide/Initialization.html#ID215)所述。

如果您使用扩展程序将初始化器添加到另一个模块中声明的结构中，则新初始化器在从定义模块调用初始化器之前无法访问`self`。

下面的示例定义了一个自定义`Rect`结构来表示几何矩形。该示例还定义了两个名为`Size`和`Point`的支持结构，这两个结构都为其所有属性提供`0.0`的默认值：

1. struct Size {
2. ​    var width = 0.0, height = 0.0
3. }
4. struct Point {
5. ​    var x = 0.0, y = 0.0
6. }
7. struct Rect {
8. ​    var origin = Point()
9. ​    var size = Size()
10. }

由于`Rect`结构为其所有属性提供默认值，因此它会自动接收默认初始化器和成员初始化器，如[默认初始化器](https://docs.swift.org/swift-book/LanguageGuide/Initialization.html#ID213)所述。这些初始化器可用于创建新的`Rect`实例：

1. let defaultRect = Rect()
2. let memberwiseRect = Rect(origin: Point(x: 2.0, y: 2.0),
3.    size: Size(width: 5.0, height: 5.0))

您可以扩展`Rect`结构，以提供具有特定中心点和大小的额外初始化器：

1. extension Rect {
2. ​    init(center: Point, size: Size) {
3. ​        let originX = center.x - (size.width / 2)
4. ​        let originY = center.y - (size.height / 2)
5. ​        self.init(origin: Point(x: originX, y: originY), size: size)
6. ​    }
7. }

这个新的初始化器首先根据提供的`center`和`size`值计算适当的原点。然后，初始化器调用结构的自动成员初始化器`init(origin:size:)`该初始化器将新的原点和大小值存储在适当的属性中：

1. let centerRect = Rect(center: Point(x: 4.0, y: 4.0),
2. ​                      size: Size(width: 3.0, height: 3.0))
3. // centerRect's origin is (2.5, 2.5) and its size is (3.0, 3.0)

注意

如果您提供带有扩展的新初始化器，您仍然有责任确保初始化器完成后每个实例都已完全初始化。

## 方法

扩展可以向现有类型添加新的实例方法和类型方法。以下示例为`Int`类型添加了一个名为`repetitions`的新实例方法：

1. extension Int {
2. ​    func repetitions(task: () -> Void) {
3. ​        for _ in 0..<self {
4. ​            task()
5. ​        }
6. ​    }
7. }

The `repetitions(task:)` method takes a single argument of type `() -> Void`, which indicates a function that has no parameters and doesn’t return a value.

定义此扩展后，您可以在任何整数上调用`repetitions(task:)`方法来执行多次任务：

1. 3.repetitions {
2. ​    print("Hello!")
3. }
4. // Hello!
5. // Hello!
6. // Hello!

### 突变实例方法

使用扩展添加的实例方法也可以修改（或*突变*）实例本身。修改`self`或其属性的结构和枚举方法必须将实例方法标记为`mutating`，就像原始实现的突变方法一样。

以下示例在Swift的`Int`类型中添加了一种名为`square`的新突变方法，该方法将原始值平方：

1. extension Int {
2. ​    mutating func square() {
3. ​        self = self * self
4. ​    }
5. }
6. var someInt = 3
7. someInt.square()
8. // someInt is now 9

## 下标

扩展可以向现有类型添加新的下标。此示例为Swift的内置`Int`类型添加了整数下标。此下标`[n]`从数字右侧返回小数`n`位：

- `123456789[0]`退货`9`
- `123456789[1]`退货`8`

...等等：

1. extension Int {
2. ​    subscript(digitIndex: Int) -> Int {
3. ​        var decimalBase = 1
4. ​        for _ in 0..<digitIndex {
5. ​            decimalBase *= 10
6. ​        }
7. ​        return (self / decimalBase) % 10
8. ​    }
9. }
10. 746381295[0]
11. // returns 5
12. 746381295[1]
13. // returns 9
14. 746381295[2]
15. // returns 2
16. 746381295[8]
17. // returns 7

如果`Int`值没有足够的数字来满足请求的索引，下标实现将返回`0`，就像数字在左侧填充了零一样：

1. 746381295[9]
2. // returns 0, as if you had requested:
3. 0746381295[9]

## 嵌套类型

扩展可以向现有类、结构和枚举添加新的嵌套类型：

1. extension Int {
2. ​    enum Kind {
3. ​        case negative, zero, positive
4. ​    }
5. ​    var kind: Kind {
6. ​        switch self {
7. ​        case 0:
8. ​            return .zero
9. ​        case let x where x > 0:
10. ​            return .positive
11. ​        default:
12. ​            return .negative
13. ​        }
14. ​    }
15. }

此示例为`Int`添加了一个新的嵌套枚举。这个枚举称为`Kind`，表示特定整数所代表的数字类型。具体来说，它表示数字是负数、零还是正数。

此示例还向`Int`添加了一个新的计算实例属性，称为`kind`，该属性返回该整数的适当`Kind`枚举情况。

嵌套枚举现在可以与任何`Int`值一起使用：

1. func printIntegerKinds(_ numbers: [Int]) {
2. ​    for number in numbers {
3. ​        switch number.kind {
4. ​        case .negative:
5. ​            print("- ", terminator: "")
6. ​        case .zero:
7. ​            print("0 ", terminator: "")
8. ​        case .positive:
9. ​            print("+ ", terminator: "")
10. ​        }
11. ​    }
12. ​    print("")
13. }
14. printIntegerKinds([3, 19, -27, 0, -6, 0, 7])
15. // Prints "+ + - 0 - 0 + "

此函数`printIntegerKinds(_:)`接受`Int`值的输入数组，并依次迭代这些值。对于数组中的每个整数，函数考虑该整数的`kind`计算属性，并打印适当的描述。

注意

`number.kind`已经知道是`Int.Kind`类型。因此，所有`Int.Kind`大小写值都可以在`switch`语句中以速记形式书写，例如`.negative`而不是`Int.Kind.negative`。