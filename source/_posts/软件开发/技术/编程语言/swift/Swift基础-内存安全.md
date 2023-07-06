---
title: Swift基础 内存安全
tags:
    - Swift
    - 基础
categories:
    - Swift
date: 2022-07-01 12:01:01
thumbnail:
---
# Swift基础 - 内存安全

翻译自：https://docs.swift.org/swift-book/LanguageGuide/MemorySafety.html

默认情况下，Swift 可以防止代码中出现不安全行为。例如，Swift确保变量在使用前初始化，在释放后无法访问内存，并检查数组索引是否有越界错误。

Swift 还要求修改内存位置的代码独占该内存访问权限，从而确保对同一内存区域的多次访问不会发生冲突。由于 Swift 会自动管理内存，因此在大多数情况下，您根本不需要考虑访问内存。然而，了解潜在冲突在哪里可能发生很重要，这样您就可以避免编写内存访问冲突的代码。如果您的代码确实包含冲突，您将收到编译时或运行时错误。

## 了解内存访问冲突

当您执行设置变量值或将参数传递给函数等操作时，代码中会发生对内存的访问。例如，以下代码包含读取访问和写入访问：

1. // A write access to the memory where one is stored.
2. var one = 1
3. 
4. // A read access from the memory where one is stored.
5. print("We're number \(one)!")

当您代码的不同部分试图同时访问内存中的同一位置时，可能会发生对内存的访问冲突。同时多次访问内存中的位置可能会产生不可预测或不一致的行为。在Swift中，有几种方法可以修改跨越几行代码的值，从而可以在自己的修改过程中尝试访问一个值。

通过考虑如何更新写在纸上的预算，您可以看到类似的问题。更新预算是一个两步过程：首先添加项目的名称和价格，然后更改总金额以反映当前列表中的项目。在更新之前和之后，您可以阅读预算中的任何信息并获得正确的答案，如下图所示。

![../_images/memory_shopping_2x.png](https://docs.swift.org/swift-book/_images/memory_shopping_2x.png)

当您将项目添加到预算中时，它处于临时无效状态，因为总金额尚未更新以反映新添加的项目。在添加项目过程中读取总金额会显示错误的信息。

此示例还展示了您在修复内存访问冲突时可能会遇到的挑战：有时有多种方法可以解决产生不同答案的冲突，并且并不总是很明显哪个答案是正确的。在本例中，根据您想要原始总金额还是更新的总金额，5美元或320美元可能是正确的答案。在修复相互冲突的访问之前，您必须确定它打算做什么。

注意

如果您编写了并发或多线程代码，对内存的访问冲突可能是一个熟悉的问题。然而，这里讨论的相互冲突的访问可能发生在单个线程上，*不*涉及并发或多线程代码。

如果您从单个线程中对内存的访问存在冲突，Swift保证您在编译时或运行时都会收到错误。对于多线程代码，请使用[线程消毒器](https://developer.apple.com/documentation/xcode/diagnosing_memory_thread_and_crash_issues_early)来帮助检测跨线程的冲突访问。

### 内存访问的特点

在相互冲突的访问中，内存访问有三个特征需要考虑：访问是读还是写，访问持续时间和被访问的内存位置。具体来说，如果您有两个访问满足以下所有条件，则会发生冲突：

- 至少有一个是写入访问或非原子访问。
- 他们在内存中访问相同的位置。
- 它们的持续时间重叠。

读写访问之间的区别通常是显而易见的：写入访问会改变内存中的位置，但读取访问不会。内存中的位置是指正在访问的内容，例如变量、常量或属性。内存访问的持续时间要么是即时的，要么是长期的。

如果操作只使用C原子运算，则该运算是*原子*运算；否则它是非原子运算。有关这些功能的列表，请参阅`stdatomic(3)`手册页。

如果访问无法在访问开始后但在访问结束前运行其他代码，则访问是*即时的*。就其本质而言，两次即时访问不可能同时发生。大多数内存访问都是即时的。例如，以下代码列表中的所有读写访问都是即时的：

1. func oneMore(than number: Int) -> Int {
2. ​    return number + 1
3. }
4. 
5. var myNumber = 1
6. myNumber = oneMore(than: myNumber)
7. print(myNumber)
8. // Prints "2"

然而，有几种访问内存的方法，称为*长期*访问，跨越了其他代码的执行。即时访问和长期访问的区别在于，其他代码可以在长期访问开始后但在结束之前运行，这被称为*重叠*。长期访问可以与其他长期访问和即时访问重叠。

重叠访问主要出现在在函数和方法或结构的突变方法中使用内外参数的代码中。以下各节将讨论使用长期访问的特定类型的Swift代码。

## 对In-Out参数的访问相互冲突

函数可以长期写入其所有输入输出参数。进出参数的写入访问在评估完所有非入出参数后开始，并持续到该函数调用的整个持续时间。如果有多个输入输出参数，写入访问的开始顺序与参数显示的顺序相同。

这种长期写入访问的一个后果是，即使范围规则和访问控制允许，您也无法访问作为进出传递的原始变量——对原始变量的任何访问都会产生冲突。例如：

1. var stepSize = 1
2. 
3. func increment(_ number: inout Int) {
4. ​    number += stepSize
5. }
6. 
7. increment(&stepSize)
8. // Error: conflicting accesses to stepSize

在上面的代码中，`stepSize`是一个全局变量，通常可以从`increment(_:)`访问。然而，对`stepSize`的读取访问与写入访问`number`重叠。如下图所示，`number`和`stepSize`都指内存中的相同位置。读写访问引用相同的内存，它们重叠，产生冲突。

![../_images/memory_increment_2x.png](https://docs.swift.org/swift-book/_images/memory_increment_2x.png)

解决这种冲突的一种方法是明确复制`stepSize`：

1. // Make an explicit copy.
2. var copyOfStepSize = stepSize
3. increment(&copyOfStepSize)
4. 
5. // Update the original.
6. stepSize = copyOfStepSize
7. // stepSize is now 2

When you make a copy of `stepSize` before calling `increment(_:)`, it’s clear that the value of `copyOfStepSize` is incremented by the current step size. The read access ends before the write access starts, so there isn’t a conflict.

对进出参数的长期写入访问的另一个后果是，传递单个变量作为同一函数多个输入输出参数的参数会产生冲突。例如：

1. func balance(_ x: inout Int, _ y: inout Int) {
2. ​    let sum = x + y
3. ​    x = sum / 2
4. ​    y = sum - x
5. }
6. var playerOneScore = 42
7. var playerTwoScore = 30
8. balance(&playerOneScore, &playerTwoScore)  // OK
9. balance(&playerOneScore, &playerOneScore)
10. // Error: conflicting accesses to playerOneScore

上面的`balance(_:_:)`函数修改其两个参数，在它们之间平均分配总值。使用`playerOneScore`和`playerTwoScore`将其称为参数不会产生冲突——有两个写入访问在时间上重叠，但它们访问内存中的不同位置。相比之下，将`playerOneScore`作为两个参数的值会产生冲突，因为它试图同时对内存中的同一位置执行两次写入访问。

注意

Because operators are functions, they can also have long-term accesses to their in-out parameters. For example, if `balance(_:_:)` was an operator function named `<^>`, writing `playerOneScore <^> playerOneScore` would result in the same conflict as `balance(&playerOneScore, &playerOneScore)`.

## 在方法中自我访问相互冲突

结构上的突变方法在方法调用期间具有对`self`的写入访问权限。例如，考虑一个游戏，其中每个玩家的生命值在受到伤害时会减少，能量量在使用特殊能力时会减少。

1. struct Player {
2. ​    var name: String
3. ​    var health: Int
4. ​    var energy: Int
5. 
6. ​    static let maxHealth = 10
7. ​    mutating func restoreHealth() {
8. ​        health = Player.maxHealth
9. ​    }
10. }

在上面的`restoreHealth()`方法中，对`self`的写入访问从方法的开头开始，一直持续到方法返回。在这种情况下，`restoreHealth()`内部没有其他代码可以重叠访问`Player`实例的属性。下面的`shareHealth(with:)`方法将另一个`Player`实例作为进出参数，从而产生重叠访问的可能性。

1. extension Player {
2. ​    mutating func shareHealth(with teammate: inout Player) {
3. ​        balance(&teammate.health, &health)
4. ​    }
5. }
6. 
7. var oscar = Player(name: "Oscar", health: 10, energy: 10)
8. var maria = Player(name: "Maria", health: 5, energy: 10)
9. oscar.shareHealth(with: &maria)  // OK

在上面的示例中，为奥斯卡的玩家调用`shareHealth(with:)`方法与Maria的玩家共享健康不会引起冲突。在方法调用期间，对`oscar`有写入访问权限，因为`oscar`是突变方法中`self`的值，并且有对`maria`的写入访问权限，因为`maria`是作为进出参数传递的。如下图所示，他们访问内存中的不同位置。尽管这两个写入访问在时间上重叠，但它们不会冲突。

![../_images/memory_share_health_maria_2x.png](https://docs.swift.org/swift-book/_images/memory_share_health_maria_2x.png)

但是，如果您将`oscar`作为`shareHealth(with:)`的参数，则存在冲突：

1. oscar.shareHealth(with: &oscar)
2. // Error: conflicting accesses to oscar

突变方法需要在方法持续时间内写入对`self`的访问权限，而入出参数需要在同一持续时间内写入对`teammate`的访问权限。在方法中，`self`和`teammate`都引用了内存中的相同位置——如下图所示。两个写入访问指的是相同的内存，它们重叠，产生冲突。

![../_images/memory_share_health_oscar_2x.png](https://docs.swift.org/swift-book/_images/memory_share_health_oscar_2x.png)

## 对属性的访问相互冲突

结构、元组和枚举等类型由单个组成值组成，例如结构的属性或元组的元素。由于这些是值类型，因此变异值的任何部分都会改变整个值，这意味着对其中一个属性的读或写访问需要对整个值的读或写访问。例如，对元组元素的重叠写入访问会产生冲突：

1. var playerInformation = (health: 10, energy: 20)
2. balance(&playerInformation.health, &playerInformation.energy)
3. // Error: conflicting access to properties of playerInformation

在上面的示例中，在元组元素上调用`balance(_:_:)`会产生冲突，因为对`playerInformation`写入访问重叠。`playerInformation.health`和`playerInformation.energy`都作为输入输出参数传递，这意味着`balance(_:_:)`需要在函数调用期间写入访问权限。在这两种情况下，对元组元素的写入访问都需要对整个元组进行写入访问。这意味着对`playerInformation`有两次写入访问，持续时间重叠，导致冲突。

以下代码显示，对存储在全局变量中的结构属性的重叠写入访问也会出现相同的错误。

1. var holly = Player(name: "Holly", health: 10, energy: 10)
2. balance(&holly.health, &holly.energy)  // Error

在实践中，大多数对结构属性的访问可以安全地重叠。例如，如果上面示例中的变量`holly`更改为局部变量而不是全局变量，编译器可以证明对结构存储属性的重叠访问是安全的：

1. func someFunction() {
2. ​    var oscar = Player(name: "Oscar", health: 10, energy: 10)
3. ​    balance(&oscar.health, &oscar.energy)  // OK
4. }

在上面的示例中，奥斯卡的健康和能量作为两个内外参数来`balance(_:_:)`编译器可以证明内存安全得到保留，因为两个存储的属性不会以任何方式交互。

限制重叠访问结构属性并不总是必要的，以保持内存安全。内存安全是理想的保证，但独家访问是比内存安全更严格的要求——这意味着一些代码保留了内存安全，即使它违反了对内存的独家访问。如果编译器能够证明对内存的非排他性访问仍然是安全的，Swift允许此内存安全代码。具体而言，如果适用以下条件，它可以证明对结构属性的重叠访问是安全的：

- 您仅访问实例的存储属性，而不是计算属性或类属性。
- 该结构是局部变量的值，而不是全局变量。
- 该结构要么不被任何闭包捕获，要么仅由不转义闭包捕获。

如果编译器无法证明访问是安全的，则不允许访问。