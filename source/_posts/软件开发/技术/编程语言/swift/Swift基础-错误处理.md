---
title: Swift基础 错误处理
tags:
- swift
- 基础
categories:
- 技术
date: 2022-07-01 12:01:01
thumbnail:
---

翻译自：https://docs.swift.org/swift-book/LanguageGuide/ErrorHandling.html

*错误处理*是响应程序中的错误条件并从中恢复的过程。Swift为在运行时抛出、捕获、传播和操作可恢复错误提供一流的支持。

一些操作不能保证总是完成执行或产生有用的输出。可选用于表示值的缺失，但当操作失败时，了解导致故障的原因通常是有用的，以便您的代码可以做出相应的响应。

例如，考虑从磁盘上的文件中读取和处理数据的任务。此任务有多种方式可能失败，包括文件在指定路径上不存在，文件没有读取权限，或文件没有以兼容格式编码。区分这些不同情况允许程序解决一些错误，并向用户传达任何无法解决的错误。

注意

Swift中的错误处理与Cocoa和Objective-C中使用`NSError`类的错误处理模式互操作。有关本课程的更多信息，请参阅在[Swift中处理可可错误](https://developer.apple.com/documentation/swift/cocoa_design_patterns/handling_cocoa_errors_in_swift)。

## 表示和抛出错误

在 Swift 中，错误由符合`Error`协议的类型值表示。这个空协议表示一种类型可用于错误处理。

Swift枚举特别适合对一组相关错误条件进行建模，相关值允许传达有关错误性质的额外信息。例如，以下是您如何表示在游戏中操作自动售货机的错误条件：

1. enum VendingMachineError: Error {
2. ​    case invalidSelection
3. ​    case insufficientFunds(coinsNeeded: Int)
4. ​    case outOfStock
5. }

抛出错误可以让您表明发生了意想不到的事情，正常的执行流程无法继续。您使用`throw`出语句抛出错误。例如，以下代码会抛出一个错误，表明自动售货机还需要五枚硬币：

1. throw VendingMachineError.insufficientFunds(coinsNeeded: 5)

## 处理错误

当抛出错误时，一些周围的代码必须负责处理错误——例如，通过纠正问题、尝试替代方法或通知用户故障。

有四种方法可以处理 Swift 中的错误。您可以将错误从函数传播到调用该函数的代码，使用`do`-`catch`语句处理错误，将错误作为可选值处理，或断言不会发生错误。每种方法都在下面的一节中描述。

当函数抛出错误时，它会改变程序的流程，因此您可以快速识别代码中可能抛出错误的地方非常重要。要识别代码中的这些位置，请编写`try`关键字或`try?`或者`try!`变化—在调用可能抛出错误的函数、方法或初始化器的代码之前。以下各节介绍了这些关键词。

注意

Swift中的错误处理类似于其他语言中的异常处理，使用`try`、`catch`和`throw`关键字。与包括Objective-C在内的许多语言中的异常处理不同，Swift中的错误处理不涉及解开调用堆栈，这个过程在计算上可能很昂贵。因此，`throw`语句的性能特征与`return`语句的性能特征相当。

### 使用抛出函数传播错误

要指示函数、方法或初始化器可以抛出错误，您可以在函数的声明中在其参数后面写入`throws`关键字。标有`throws`函数称为*抛出函数*。如果函数指定了返回类型，则在返回箭头（`->`）之前写入`throws`关键字。

1. func canThrowErrors() throws -> String
2. 
3. func cannotThrowErrors() -> String

抛出函数将抛出在其中的错误传播到调用它的范围。

注意

只有抛出函数才能传播错误。在非投掷函数内抛出的任何错误都必须在函数内处理。

在下面的示例中，`VendingMachine`类有一个`vend(itemNamed:)`方法，如果请求的项目不可用、缺货或成本超过当前存款金额，则抛出适当的`VendingMachineError`：

1. struct Item {
2. ​    var price: Int
3. ​    var count: Int
4. }
5. 
6. class VendingMachine {
7. ​    var inventory = [
8. ​        "Candy Bar": Item(price: 12, count: 7),
9. ​        "Chips": Item(price: 10, count: 4),
10. ​        "Pretzels": Item(price: 7, count: 11)
11. ​    ]
12. ​    var coinsDeposited = 0
13. 
14. ​    func vend(itemNamed name: String) throws {
15. ​        guard let item = inventory[name] else {
16. ​            throw VendingMachineError.invalidSelection
17. ​        }
18. 
19. ​        guard item.count > 0 else {
20. ​            throw VendingMachineError.outOfStock
21. ​        }
22. 
23. ​        guard item.price <= coinsDeposited else {
24. ​            throw VendingMachineError.insufficientFunds(coinsNeeded: item.price - coinsDeposited)
25. ​        }
26. 
27. ​        coinsDeposited -= item.price
28. 
29. ​        var newItem = item
30. ​        newItem.count -= 1
31. ​        inventory[name] = newItem
32. 
33. ​        print("Dispensing \(name)")
34. ​    }
35. }

`vend(itemNamed:)`方法的实现使用`guard`语句提前退出方法，如果不符合购买零食的任何要求，则会抛出适当的错误。由于`throw`出语句会立即传输程序控制，因此只有在满足所有这些要求的情况下才会对项目进行修改。

由于`vend(itemNamed:)`方法传播它抛出的任何错误，因此任何调用此方法的代码都必须使用`do`-`catch`语句、`try?`或`try!`处理错误，或继续传播它们。例如，以下示例中的`buyFavoriteSnack(person:vendingMachine:)`也是一个抛出函数，`vend(itemNamed:)`方法抛出的任何错误都将传播到调用`buyFavoriteSnack(person:vendingMachine:)`函数的点。

1. let favoriteSnacks = [
2. ​    "Alice": "Chips",
3. ​    "Bob": "Licorice",
4. ​    "Eve": "Pretzels",
5. ]
6. func buyFavoriteSnack(person: String, vendingMachine: VendingMachine) throws {
7. ​    let snackName = favoriteSnacks[person] ?? "Candy Bar"
8. ​    try vendingMachine.vend(itemNamed: snackName)
9. }

在本例中，`buyFavoriteSnack(person:vendingMachine:)`功能查找给定人最喜欢的零食，并尝试通过调用`vend(itemNamed:)`方法为他们购买。由于`vend(itemNamed:)`方法可能会抛出错误，因此在前面用`try`关键字调用它。

抛出初始化器可以像抛出函数一样传播错误。例如，以下列表中`PurchasedSnack`结构的初始化器调用抛出函数作为初始化过程的一部分，并通过将它们传播到调用者来处理遇到的任何错误。

1. struct PurchasedSnack {
2. ​    let name: String
3. ​    init(name: String, vendingMachine: VendingMachine) throws {
4. ​        try vendingMachine.vend(itemNamed: name)
5. ​        self.name = name
6. ​    }
7. }

### 使用Do-Catch处理错误

您可以使用`do`-`catch`语句通过运行代码块来处理错误。如果`do`子句中的代码抛出错误，它将与`catch`子句匹配，以确定其中哪一个可以处理错误。

以下是`do`-`catch`声明的一般形式：

1. do {
2. ​    try expression
3. ​    statements
4. } catch pattern 1 {
5. ​    statements
6. } catch pattern 2 where condition {
7. ​    statements
8. } catch pattern 3, pattern 4 where condition {
9. ​    statements
10. } catch {
11. ​    statements
12. }

您在`catch`后编写一个模式，以指示该子句可以处理哪些错误。如果`catch`子句没有模式，该子句将匹配任何错误，并将错误绑定到名为`error`的本地常量。有关模式匹配的更多信息，请参阅[模式](https://docs.swift.org/swift-book/ReferenceManual/Patterns.html)。

例如，以下代码与`VendingMachineError`枚举的所有三种情况相匹配。

1. var vendingMachine = VendingMachine()
2. vendingMachine.coinsDeposited = 8
3. do {
4. ​    try buyFavoriteSnack(person: "Alice", vendingMachine: vendingMachine)
5. ​    print("Success! Yum.")
6. } catch VendingMachineError.invalidSelection {
7. ​    print("Invalid Selection.")
8. } catch VendingMachineError.outOfStock {
9. ​    print("Out of Stock.")
10. } catch VendingMachineError.insufficientFunds(let coinsNeeded) {
11. ​    print("Insufficient funds. Please insert an additional \(coinsNeeded) coins.")
12. } catch {
13. ​    print("Unexpected error: \(error).")
14. }
15. // Prints "Insufficient funds. Please insert an additional 2 coins."

在上面的示例中，`buyFavoriteSnack(person:vendingMachine:)`函数在`try`表达式中调用，因为它可能会抛出错误。如果抛出错误，执行将立即转移到`catch`子句，该子句决定是否允许继续传播。如果没有匹配模式，错误将被最终的`catch`子句捕获，并绑定到局部`error`常量。如果没有抛出错误，则执行`do`语句中的其余语句。

`catch`子句不必处理`do`子句中的代码可以抛出的所有可能错误。如果没有一个`catch`子句处理错误，则错误会传播到周围的范围。然而，传播的错误必须由周围的*一些*范围处理。在非投掷函数中，封闭的`do`-`catch`语句必须处理错误。在抛出函数中，封闭的`do`-`catch`语句或调用者必须处理错误。如果错误在没有处理的情况下传播到顶级范围，您将收到一个运行时错误。

例如，可以写上一个示例，这样任何不是aVendingMachineError的错误都会被调用函数捕获：

1. func nourish(with item: String) throws {
2. ​    do {
3. ​        try vendingMachine.vend(itemNamed: item)
4. ​    } catch is VendingMachineError {
5. ​        print("Couldn't buy that from the vending machine.")
6. ​    }
7. }
8. 
9. do {
10. ​    try nourish(with: "Beet-Flavored Chips")
11. } catch {
12. ​    print("Unexpected non-vending-machine-related error: \(error)")
13. }
14. // Prints "Couldn't buy that from the vending machine."

在`nourish(with:)`函数中，如果`vend(itemNamed:)`抛出作为`VendingMachineError`枚举之一的错误，`nourish(with:)`通过打印消息来处理错误。否则，`nourish(with:)`将错误传播到其调用站点。然后，错误被一般`catch`子句捕获。

捕获几个相关错误的另一种方法是在`catch`后列出它们，用逗号分隔。例如：

1. func eat(item: String) throws {
2. ​    do {
3. ​        try vendingMachine.vend(itemNamed: item)
4. ​    } catch VendingMachineError.invalidSelection, VendingMachineError.insufficientFunds, VendingMachineError.outOfStock {
5. ​        print("Invalid selection, out of stock, or not enough money.")
6. ​    }
7. }

`eat(item:)`函数列出了要捕获的自动售货机错误，其错误文本对应于该列表中的项目。如果抛出列出的三个错误中的任何一个，此`catch`子句通过打印消息来处理它们。任何其他错误都会传播到周围范围内，包括稍后可能会添加的任何自动售货机错误。

### 将错误转换为可选值

You use `try?` to handle an error by converting it to an optional value. If an error is thrown while evaluating the `try?` expression, the value of the expression is `nil`. For example, in the following code `x` and `y` have the same value and behavior:

1. func someThrowingFunction() throws -> Int {
2. ​    // ...
3. }
4. 
5. let x = try? someThrowingFunction()
6. 
7. let y: Int?
8. do {
9. ​    y = try someThrowingFunction()
10. } catch {
11. ​    y = nil
12. }

如果`someThrowingFunction()`抛出错误，`x`和`y`的值为`nil`。否则，`x`和`y`的值是函数返回的值。请注意，`x`和`y`是`someThrowingFunction()`返回的任何类型的可选。在这里，函数返回一个整数，因此`x`和`y`是可选整数。

使用`try?`当您想以相同的方式处理所有错误时，允许您编写简洁的错误处理代码。例如，以下代码使用几种方法来获取数据，如果所有方法都失败，则返回`nil`。

1. func fetchData() -> Data? {
2. ​    if let data = try? fetchDataFromDisk() { return data }
3. ​    if let data = try? fetchDataFromServer() { return data }
4. ​    return nil
5. }

### 禁用错误传播

Sometimes you know a throwing function or method won’t, in fact, throw an error at runtime. On those occasions, you can write `try!` before the expression to disable error propagation and wrap the call in a runtime assertion that no error will be thrown. If an error actually is thrown, you’ll get a runtime error.

例如，以下代码使用`loadImage(atPath:)`函数，该函数在给定路径上加载图像资源，如果无法加载图像，则抛出错误。在这种情况下，由于图像随应用程序一起发送，因此在运行时不会抛出错误，因此禁用错误传播是合适的。

1. let photo = try! loadImage(atPath: "./Resources/John Appleseed.jpg")

### 指定清理操作

在代码执行离开当前代码块之前，您可以使用`defer`语句执行一组语句。此语句允许您进行任何必要的清理，无论执行*如何*离开当前代码块，无论是因为抛出错误还是因为`return`或`break`等语句而离开。例如，您可以使用`defer`语句来确保文件描述符关闭并释放手动分配的内存。

`defer`语句会推迟执行，直到当前范围退出。此语句由`defer`关键字和稍后要执行的语句组成。延迟语句不得包含任何将控制权从语句中转移出去的代码，例如`break`或a areturn语句，或通过抛出错误。延迟操作的执行顺序与源代码中写入的顺序相反。也就是说，第一个`defer`语句中的代码最后执行，第二个`defer`语句中的代码执行秒到最后，以此类推。源代码顺序的最后一个`defer`语句首先执行。

1. func processFile(filename: String) throws {
2. ​    if exists(filename) {
3. ​        let file = open(filename)
4. ​        defer {
5. ​            close(file)
6. ​        }
7. ​        while let line = try file.readline() {
8. ​            // Work with the file.
9. ​        }
10. ​        // close(file) is called here, at the end of the scope.
11. ​    }
12. }

上面的示例使用`defer`语句来确保`open(_:)`函数具有相应的调用 `close(_:)`

注意

即使不涉及错误处理代码，您也可以使用`defer`语句。