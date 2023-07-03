---
title: Swift基础 通用
tags:
    - swift
    - 基础
categories:
    - 技术
date: 2022-07-01 12:01:01
thumbnail:
---

翻译自：https://docs.swift.org/swift-book/LanguageGuide/Generics.html

*通用代码*使您能够编写灵活、可重用的函数和类型，这些函数和类型可以根据您定义的要求适用于任何类型。您可以编写避免重复的代码，并以清晰、抽象的方式表达其意图。

通用是Swift最强大的功能之一，Swift标准库的大部分都是用通用代码构建的。事实上，即使您没有意识到这一点，您也一直在使用整个*语言指南*中的泛型。例如，Swift的`Array`和`Dictionary`类型都是通用集合。您可以创建一个包含`Int`值的数组，或包含`String`值的数组，或者为可以在Swift中创建的任何其他类型的数组。同样，您可以创建一个字典来存储任何指定类型的值，并且该类型没有限制。

## 通用解决的问题

这里有一个名为`swapTwoInts(_:_:)`的标准非通用函数，它交换了两个`Int`值：

1. func swapTwoInts(_ a: inout Int, _ b: inout Int) {
2. ​    let temporaryA = a
3. ​    a = b
4. ​    b = temporaryA
5. }

此函数使用输入输出参数来交换`a`和`b`的值，如[In-Out参数](https://docs.swift.org/swift-book/LanguageGuide/Functions.html#ID173)所述。

`swapTwoInts(_:_:)`函数将`b`的原始值交换为`a`，将`a`的原始值交换为`b`。您可以调用此函数来交换两个`Int`变量中的值：

1. var someInt = 3
2. var anotherInt = 107
3. swapTwoInts(&someInt, &anotherInt)
4. print("someInt is now \(someInt), and anotherInt is now \(anotherInt)")
5. // Prints "someInt is now 107, and anotherInt is now 3"

`swapTwoInts(_:_:)`函数非常有用，但它只能与`Int`值一起使用。如果您想交换两个`String`值或两个`Double`值，则必须编写更多函数，例如swapTwoStrings`swapTwoStrings(_:_:)`和`swapTwoDoubles(_:_:)`函数如下所示：

1. func swapTwoStrings(_ a: inout String, _ b: inout String) {
2. ​    let temporaryA = a
3. ​    a = b
4. ​    b = temporaryA
5. }
6. 
7. func swapTwoDoubles(_ a: inout Double, _ b: inout Double) {
8. ​    let temporaryA = a
9. ​    a = b
10. ​    b = temporaryA
11. }

您可能已经注意到，swapTwoInts`swapTwoInts(_:_:)``swapTwoStrings(_:_:)`和`swapTwoDoubles(_:_:)`函数的主体是相同的。唯一的区别是他们接受的值的类型（`Int`、`String`和`Double`）。

编写一个交换*任何*类型两个值的单个函数更有用，也更灵活。通用代码使您能够编写这样的函数。（这些函数的通用版本定义如下。）

注意

在所有三个函数中，`a`和`b`的类型必须相同。如果`a`和`b`不是同一类型，则无法交换它们的值。Swift 是一种类型安全的语言，不允许（例如）`String`类型的变量和类型`Double`的变量相互交换值。尝试这样做会导致编译时错误。

## 通用函数

*通用函数*可以适用于任何类型。这是上面theswapTwoInts`swapTwoInts(_:_:)`函数的通用版本，称为`swapTwoValues(_:_:)`

```swift
func swapTwoValues<T>(_ a: inout T, _ b: inout T) {
   let temporaryA = a
   a = b
   b = temporaryA
}
```

`swapTwoValues(_:_:)`函数的主体与theswapTwoInts`swapTwoInts(_:_:)`函数的主体相同。然而，swapTwoValues`swapTwoValues(_:_:)`的第一行与`swapTwoInts(_:_:)`略有不同。以下是第一行的比较方式：

1. `func swapTwoInts(_ a: inout Int, _ b: inout Int)`
2. `func swapTwoValues<T>(_ a: inout T, _ b: inout T)`

该函数的通用版本使用*占位符*类型名称（在本例中称为`T`）而不是*实际*类型名称（如`Int`、`String`或`Double`）。占位符类型名称没有说明`T`必须是什么，但它*确实*说`a`和`b`必须是相同的类型`T`，无论`T`代表什么。每次调用`swapTwoValues(_:_:)`函数时，都会确定代替`T`的实际类型。

The other difference between a generic function and a nongeneric function is that the generic function’s name (`swapTwoValues(_:_:)`) is followed by the placeholder type name (`T`) inside angle brackets (`<T>`). The brackets tell Swift that `T` is a placeholder type name within the `swapTwoValues(_:_:)` function definition. Because `T` is a placeholder, Swift doesn’t look for an actual type called `T`.

`swapTwoValues(_:_:)`函数现在可以以与`swapTwoInts`相同的方式调用，但只要这两个值彼此具有相同的类型，就可以传递*任何*类型的两个值。每次调用`swapTwoValues(_:_:)`时，都会从传递给函数的值类型推断`T`的类型。

在下面的两个示例中，推断`T`分别为`Int`和`String`：

1. var someInt = 3
2. var anotherInt = 107
3. swapTwoValues(&someInt, &anotherInt)
4. // someInt is now 107, and anotherInt is now 3
5. 
6. var someString = "hello"
7. var anotherString = "world"
8. swapTwoValues(&someString, &anotherString)
9. // someString is now "world", and anotherString is now "hello"

注意

上面定义的`swapTwoValues(_:_:)`函数的灵感来自一个名为`swap`的通用函数，该函数是Swift标准库的一部分，并自动供您在应用程序中使用。如果您需要在自己的代码中使用`swapTwoValues(_:_:)`函数的行为，您可以使用Swift现有的swap`swap(_:_:)`函数，而不是提供自己的实现。

## 类型参数

在上面的`swapTwoValues(_:_:)`示例中，占位符类型`T`是*类型参数*的示例。类型参数指定并命名占位符类型，并立即写在函数名称之后，在一对匹配的角度括号（如`<T>`）之间。

指定类型参数后，您可以使用它来定义函数参数的类型（例如swapTwoValues`swapTwoValues(_:_:)`函数的`a`和`b`参数），或作为函数的返回类型，或作为函数主体中的类型注释。在每种情况下，每当调用函数时，类型参数都会替换为*实际*类型。（在上面的`swapTwoValues(_:_:)`示例中，第一次调用函数时将`T`替换为`Int`，第二次调用时替换为`String`。）

您可以通过在角括号内写入多个类型参数名称，用逗号分隔来提供多个类型参数。

## 命名类型参数

In most cases, type parameters have descriptive names, such as `Key` and `Value` in `Dictionary<Key, Value>` and `Element` in `Array<Element>`, which tells the reader about the relationship between the type parameter and the generic type or function it’s used in. However, when there isn’t a meaningful relationship between them, it’s traditional to name them using single letters such as `T`, `U`, and `V`, such as `T` in the `swapTwoValues(_:_:)` function above.

注意

始终给出类型参数上骆驼大小写名称（如`T`和`MyTypeParameter`），以指示它们是*类型*而不是值的占位符。

## 通用类型

除了通用函数外，Swift还允许您定义自己的*通用类型*。这些是自定义类、结构和枚举，可以与*任何*类型一起工作，类似于`Array`和`Dictionary`。

本节向您展示了如何编写名为`Stack`的通用集合类型。堆栈是一组有序的值，类似于数组，但与Swift的`Array`类型相比，操作集更受限。数组允许在数组的任何位置插入和删除新项目。然而，堆栈只允许将新项目附加到集合的末尾（称为将新值*推送*到堆栈）。同样，堆栈只允许从集合的末尾删除项目（称为从堆栈中弹*出*一个值）。

注意

The concept of a stack is used by the `UINavigationController` class to model the view controllers in its navigation hierarchy. You call the `UINavigationController` class `pushViewController(_:animated:)` method to add (or push) a view controller on to the navigation stack, and its `popViewControllerAnimated(_:)` method to remove (or pop) a view controller from the navigation stack. A stack is a useful collection model whenever you need a strict “last in, first out” approach to managing a collection.

下面的插图显示了堆栈的推送和弹出行为：

![../_images/stackPushPop_2x.png](https://docs.swift.org/swift-book/_images/stackPushPop_2x.png)

1. 堆栈上目前有三个值。
2. 第四个值被推到堆栈的顶部。
3. 堆栈现在包含四个值，最近的一个值在顶部。
4. 堆栈中的顶部项目被弹出。
5. 弹出一个值后，堆栈再次包含三个值。

以下是编写堆栈的非通用版本的方法，在这种情况下，对于`Int`值的堆栈：

1. struct IntStack {
2. ​    var items: [Int] = []
3. ​    mutating func push(_ item: Int) {
4. ​        items.append(item)
5. ​    }
6. ​    mutating func pop() -> Int {
7. ​        return items.removeLast()
8. ​    }
9. }

该结构使用称为`items`的`Array`属性来存储堆栈中的值。`Stack`提供了两种方法，`push`和`pop`，用于在堆栈上和下推送和弹出值。这些方法被标记为`mutating`，因为它们需要修改（或*突变*）结构`items`组。

然而，上面显示的`IntStack`类型只能与`Int`值一起使用。定义一个*通用*的`Stack`结构会更有用，它可以管理*任何*类型值的堆栈。

以下是同一代码的通用版本：

```swift
1. struct Stack<Element> {
2. ​    var items: [Element] = []
3. ​    mutating func push(_ item: Element) {
4. ​        items.append(item)
5. ​    }
6. ​    mutating func pop() -> Element {
7. ​        return items.removeLast()
8. ​    }
9. }
```



请注意，`Stack`的通用版本本质上与非通用版本相同，但具有名为`Element`的类型参数，而不是实际类型的`Int`。此类型参数写在结构名称后的一对角括号（`<Element>`）中。

`Element`定义稍后要提供的类型的占位符名称。这种未来类型可以在结构定义的任何地方被称为`Element`。在这种情况下，`Element`在三个地方用作占位符：

- 创建一个名为`items`属性，该属性使用空类型的值数组初始化`Element`
- 要指定`push(_:)`方法有一个名为`item`的单个参数，该参数必须是类型`Element`
- 指定`pop()`方法返回的值将是类型的值`Element`

由于它是一种通用类型，`Stack`可用于在Swift中创建*任何*有效类型的堆栈，其方式类似于`Array`和`Dictionary`。

您可以通过在角度括号内写入要存储在堆栈中的类型来创建一个新的`Stack`实例。例如，要创建新的字符串堆栈，请编写`Stack<String>()`：

```swift
1. var stackOfStrings = Stack<String>()
2. stackOfStrings.push("uno")
3. stackOfStrings.push("dos")
4. stackOfStrings.push("tres")
5. stackOfStrings.push("cuatro")
6. // the stack now contains 4 strings
```



以下是`stackOfStrings`在将这四个值推送到堆栈后的样子：

![../_images/stackPushedFourStrings_2x.png](https://file.pandacode.cn/blog/202204051636323.png)

从堆栈中弹出一个值将删除并返回最高值`"cuatro"`：

1. let fromTheTop = stackOfStrings.pop()
2. // fromTheTop is equal to "cuatro", and the stack now contains 3 strings

以下是堆栈弹出其最高值后的样子：

![../_images/stackPoppedOneString_2x.png](https://file.pandacode.cn/blog/202204051636038.png)

## 扩展通用类型

当您扩展泛型类型时，您不会提供类型参数列表作为扩展定义的一部分。相反，*原始*类型定义的类型参数列表在扩展的正文中可用，原始类型参数名称用于引用原始定义中的类型参数。

以下示例扩展了通用`Stack`类型，以添加名为`topItem`的只读计算属性，该属性返回堆栈上的顶部项目，而不会从堆栈中弹出它：

1. extension Stack {
2. ​    var topItem: Element? {
3. ​        return items.isEmpty ? nil : items[items.count - 1]
4. ​    }
5. }

`topItem`属性返回`Element`类型的可选值。如果堆栈为空，`topItem`返回`nil`；如果堆栈不是空的，`topItem`返回`items`组中的最后一个项目。

请注意，此扩展没有定义类型参数列表。相反，在扩展中使用`Stack`类型的现有类型参数名称`Element`来指示`topItem`计算属性的可选类型。

`topItem`计算属性现在可以与任何`Stack`实例一起使用，以访问和查询其顶部项目，而无需删除它。

1. if let topItem = stackOfStrings.topItem {
2. ​    print("The top item on the stack is \(topItem).")
3. }
4. // Prints "The top item on the stack is tres."

泛型类型的扩展还可以包括扩展类型的实例必须满足的要求，以获得新功能，如下文中[带有通用Where子句的扩展](https://docs.swift.org/swift-book/LanguageGuide/Generics.html#ID553)中所述。

## 类型约束

`swapTwoValues(_:_:)`函数和`Stack`类型可以与任何类型配合使用。然而，对可以与泛型函数和泛型类型一起使用的类型执行某些*类型约束*有时是有用的。类型约束指定类型参数必须从特定类继承，或符合特定的协议或协议组合。

例如，Swift的`Dictionary`类型对可以用作字典键的类型施加了限制。如[字典](https://docs.swift.org/swift-book/LanguageGuide/CollectionTypes.html#ID113)中所述，字典键的类型必须*可哈希*。也就是说，它必须提供一种使自己具有独特代表性的方法。`Dictionary`需要其键可哈希，以便可以检查它是否已经包含特定密钥的值。没有这个要求，`Dictionary`就无法判断它是否应该插入或替换特定密钥的值，也无法为已经在字典中的给定密钥找到值。

此要求由`Dictionary`键类型的类型约束强制执行，该约束指定键类型必须符合`Hashable`协议，Hashable协议是Swift标准库中定义的特殊协议。Swift的所有基本类型（如`String`、`Int`、`Double`和`Bool`）默认都是可散列的。有关使您自己的自定义类型符合`Hashable`协议的信息，请参阅[符合哈希协议](https://developer.apple.com/documentation/swift/hashable#2849490)。

您可以在创建自定义泛型类型时定义自己的类型约束，这些约束提供了泛型编程的大部分功能。像`Hashable`抽象概念根据概念特征而不是具体类型来描述类型。

### 类型约束语法

您可以通过在类型参数名称后放置单个类或协议约束来编写类型约束，并用冒号分隔，作为类型参数列表的一部分。泛型函数类型约束的基本语法如下所示（尽管泛型类型的语法相同）：

1. func someFunction<T: SomeClass, U: SomeProtocol>(someT: T, someU: U) {
2. ​    // function body goes here
3. }

上面的假设函数有两个类型参数。第一个类型参数`T`有一个类型约束，要求`T`是`SomeClass`的子类。第二个类型参数`U`有一个类型约束，要求`U`符合协议SomeProtocol。

### 操作中的类型约束

这是一个名为`findIndex(ofString:in:)`的非通用函数，它给出了一个要查找的`String`值和一个要查找的`String`值数组。ThefindIndex`findIndex(ofString:in:)`函数返回一个可选的`Int`值，如果找到，它将是数组中第一个匹配字符串的索引，如果找不到字符串，则为`nil`：

1. func findIndex(ofString valueToFind: String, in array: [String]) -> Int? {
2. ​    for (index, value) in array.enumerated() {
3. ​        if value == valueToFind {
4. ​            return index
5. ​        }
6. ​    }
7. ​    return nil
8. }

`findIndex(ofString:in:)`函数可用于查找字符串数组中的字符串值：

1. let strings = ["cat", "dog", "llama", "parakeet", "terrapin"]
2. if let foundIndex = findIndex(ofString: "llama", in: strings) {
3. ​    print("The index of llama is \(foundIndex)")
4. }
5. // Prints "The index of llama is 2"

然而，在数组中查找值索引的原理并不仅适用于字符串。您可以通过将任何提及的字符串替换为某种类型`T`的值来编写与泛型函数相同的功能。

以下是您如何期望编写`findIndex(ofString:in:)`称为`findIndex(of:in:)`的通用版本。请注意，此函数的返回类型仍然是`Int?`，因为该函数返回可选索引号，而不是数组中的可选值。不过，请注意——由于示例后解释的原因，此函数不会编译：

```swift
1. func findIndex<T>(of valueToFind: T, in array:[T]) -> Int? {
2. ​    for (index, value) in array.enumerated() {
3. ​        if value == valueToFind {
4. ​            return index
5. ​        }
6. ​    }
7. ​    return nil
8. }
```



This function doesn’t compile as written above. The problem lies with the equality check, “`if value == valueToFind`”. Not every type in Swift can be compared with the equal to operator (`==`). If you create your own class or structure to represent a complex data model, for example, then the meaning of “equal to” for that class or structure isn’t something that Swift can guess for you. Because of this, it isn’t possible to guarantee that this code will work for *every* possible type `T`, and an appropriate error is reported when you try to compile the code.

All is not lost, however. The Swift standard library defines a protocol called `Equatable`, which requires any conforming type to implement the equal to operator (`==`) and the not equal to operator (`!=`) to compare any two values of that type. All of Swift’s standard types automatically support the `Equatable` protocol.

任何`Equatable`类型都可以安全地与`findIndex(of:in:)`函数一起使用，因为它保证支持等于运算符。为了表达这一事实，当您定义函数时，您可以编写一个`Equatable`的类型约束，作为类型参数定义的一部分：

1. func findIndex<T: Equatable>(of valueToFind: T, in array:[T]) -> Int? {
2. ​    for (index, value) in array.enumerated() {
3. ​        if value == valueToFind {
4. ​            return index
5. ​        }
6. ​    }
7. ​    return nil
8. }

The single type parameter for `findIndex(of:in:)` is written as `T: Equatable`, which means “any type `T` that conforms to the `Equatable` protocol.”

`findIndex(of:in:)`函数现在可以成功编译，并且可以与任何`Equatable`类型一起使用，例如`Double`或`String`：

1. let doubleIndex = findIndex(of: 9.3, in: [3.14159, 0.1, 0.25])
2. // doubleIndex is an optional Int with no value, because 9.3 isn't in the array
3. let stringIndex = findIndex(of: "Andrea", in: ["Mike", "Malcolm", "Andrea"])
4. // stringIndex is an optional Int containing a value of 2

## 相关类型

在定义协议时，声明一个或多个关联类型作为协议定义的一部分有时是有用的。*关联类型*为用作协议一部分的类型提供了占位符名称。在采用协议之前，不会指定用于该关联类型的实际类型。关联类型使用`associatedtype`关键字指定。

### 操作中的关联类型

以下是名为`Container`的协议示例，该协议声明了一个名为`Item`的关联类型：

1. protocol Container {
2. ​    associatedtype Item
3. ​    mutating func append(_ item: Item)
4. ​    var count: Int { get }
5. ​    subscript(i: Int) -> Item { get }
6. }

`Container`协议定义了任何容器必须提供的三种所需功能：

- 必须能够使用`append(_:)`方法向容器添加新项目。
- 必须能够通过返回`Int`值的`count`属性访问容器中项目的计数。
- 必须能够使用接受`Int`索引值的下标检索容器中的每个项目。

该协议没有指定容器中的项目应该如何存储或允许它们的类型。该协议仅指定任何类型必须提供的三个位功能才能被视为`Container`。符合要求的类型可以提供额外的功能，只要它满足这三项要求。

任何符合`Container`协议的类型都必须能够指定它存储的值类型。具体而言，它必须确保只将正确类型的项目添加到容器中，并且必须明确其下标返回的项目类型。

为了定义这些要求，`Container`协议需要一种方法来引用容器将持有的元素的类型，而不知道该类型适用于特定容器。`Container`协议需要指定传递给`append(_:)`方法的任何值必须具有与容器元素类型相同的类型，并且容器下标返回的值将与容器的元素类型相同。

To achieve this, the `Container` protocol declares an associated type called `Item`, written as `associatedtype Item`. The protocol doesn’t define what `Item` is—that information is left for any conforming type to provide. Nonetheless, the `Item` alias provides a way to refer to the type of the items in a `Container`, and to define a type for use with the `append(_:)` method and subscript, to ensure that the expected behavior of any `Container` is enforced.

以下是上述[通用类型的](https://docs.swift.org/swift-book/LanguageGuide/Generics.html#ID184)非通用`IntStack`类型的版本，适合符合`Container`协议：

1. struct IntStack: Container {
2. ​    // original IntStack implementation
3. ​    var items: [Int] = []
4. ​    mutating func push(_ item: Int) {
5. ​        items.append(item)
6. ​    }
7. ​    mutating func pop() -> Int {
8. ​        return items.removeLast()
9. ​    }
10. ​    // conformance to the Container protocol
11. ​    typealias Item = Int
12. ​    mutating func append(_ item: Int) {
13. ​        self.push(item)
14. ​    }
15. ​    var count: Int {
16. ​        return items.count
17. ​    }
18. ​    subscript(i: Int) -> Int {
19. ​        return items[i]
20. ​    }
21. }

`IntStack`类型实现了`Container`协议的所有三个需求，并在每种情况下包装`IntStack`类型的部分现有功能以满足这些要求。

Moreover, `IntStack` specifies that for this implementation of `Container`, the appropriate `Item` to use is a type of `Int`. The definition of `typealias Item = Int` turns the abstract type of `Item` into a concrete type of `Int` for this implementation of the `Container` protocol.

Thanks to Swift’s type inference, you don’t actually need to declare a concrete `Item` of `Int` as part of the definition of `IntStack`. Because `IntStack` conforms to all of the requirements of the `Container` protocol, Swift can infer the appropriate `Item` to use, simply by looking at the type of the `append(_:)` method’s `item` parameter and the return type of the subscript. Indeed, if you delete the `typealias Item = Int` line from the code above, everything still works, because it’s clear what type should be used for `Item`.

您还可以使通用`Stack`类型符合`Container`协议：

```swift
1. struct Stack<Element>: Container {
2. ​    // original Stack<Element> implementation
3. ​    var items: [Element] = []
4. ​    mutating func push(_ item: Element) {
5. ​        items.append(item)
6. ​    }
7. ​    mutating func pop() -> Element {
8. ​        return items.removeLast()
9. ​    }
10. ​    // conformance to the Container protocol
11. ​    mutating func append(_ item: Element) {
12. ​        self.push(item)
13. ​    }
14. ​    var count: Int {
15. ​        return items.count
16. ​    }
17. ​    subscript(i: Int) -> Element {
18. ​        return items[i]
19. ​    }
20. }
```



这一次，类型参数`Element`被用作`append(_:)`方法`item`参数的类型和下标的返回类型。因此，Swift可以推断`Element`是用作此特定容器`Item`的合适类型。

### 扩展现有类型以指定关联类型

您可以扩展现有类型以添加协议一致性，如在[添加扩展协议一致性](https://docs.swift.org/swift-book/LanguageGuide/Protocols.html#ID277)中所述。这包括具有关联类型的协议。

Swift的`Array`类型已经提供了一个`append(_:)`方法、`count`属性和一个带有`Int`索引的下标来检索其元素。这三项功能符合`Container`协议的要求。这意味着，只需声明`Array`采用该协议，您就可以扩展`Array`以符合`Container`协议。您使用空扩展程序执行此操作，如[使用扩展声明协议采用](https://docs.swift.org/swift-book/LanguageGuide/Protocols.html#ID278)中所述：

1. extension Array: Container {}

Array现有的`append(_:)`方法和下标使Swift能够推断用于`Item`的适当类型，就像上面通用`Stack`类型一样。定义此扩展后，您可以将任何`Array`用作`Container`。

### 向关联类型添加约束

您可以向协议中的关联类型添加类型约束，以要求符合这些约束的类型满足这些约束。例如，以下代码定义了一个`Container`版本，要求容器中的项是可等的。

1. protocol Container {
2. ​    associatedtype Item: Equatable
3. ​    mutating func append(_ item: Item)
4. ​    var count: Int { get }
5. ​    subscript(i: Int) -> Item { get }
6. }

要符合此版本的`Container`，容器`Item`类型必须符合`Equatable`协议。

### 在关联类型的约束中使用协议

协议可以作为其自身要求的一部分出现。例如，这里有一个完善`Container`协议的协议，添加了`suffix(_:)`方法的要求。`suffix(_:)`方法从容器末尾返回给定数量的元素，并将其存储在`Suffix`类型的实例中。

1. protocol SuffixableContainer: Container {
2. ​    associatedtype Suffix: SuffixableContainer where Suffix.Item == Item
3. ​    func suffix(_ size: Int) -> Suffix
4. }

在此协议中，`Suffix`是一个关联的类型，就像上面`Container`示例中的`Item`类型一样。`Suffix`有两个约束：它必须符合`SuffixableContainer`协议（当前定义的协议），其`Item`类型必须与容器`Item`类型相同。`Item`的约束是一个通用的`where`子句，在[关联类型](https://docs.swift.org/swift-book/LanguageGuide/Generics.html#ID557)中[与](https://docs.swift.org/swift-book/LanguageGuide/Generics.html#ID557)下面的[通用where子句](https://docs.swift.org/swift-book/LanguageGuide/Generics.html#ID557)讨论。

以下是上述[通用类型的](https://docs.swift.org/swift-book/LanguageGuide/Generics.html#ID184)`Stack`类型的扩展，该扩展增加了对`SuffixableContainer`协议的一致性：

```swift
1. extension Stack: SuffixableContainer {
2. ​    func suffix(_ size: Int) -> Stack {
3. ​        var result = Stack()
4. ​        for index in (count-size)..<count {
5. ​            result.append(self[index])
6. ​        }
7. ​        return result
8. ​    }
9. ​    // Inferred that Suffix is Stack.
10. }
11. var stackOfInts = Stack<Int>()
12. stackOfInts.append(10)
13. stackOfInts.append(20)
14. stackOfInts.append(30)
15. let suffix = stackOfInts.suffix(2)
16. // suffix contains 20 and 30
```



在上面的示例中，`Stack`的`Suffix`关联类型也是`Stack`，因此`Stack`上的后缀操作返回另一个`Stack`。或者，符合`SuffixableContainer`的类型可以具有与自身不同的`Suffix`类型——这意味着后缀操作可以返回不同的类型。例如，这是非genericIntStack类型的扩展，该类型添加了`SuffixableContainer`一致性，使用`Stack<Int>`作为其后缀类型，而不是`IntStack`：

```swift
1. extension IntStack: SuffixableContainer {
2. ​    func suffix(_ size: Int) -> Stack<Int> {
3. ​        var result = Stack<Int>()
4. ​        for index in (count-size)..<count {
5. ​            result.append(self[index])
6. ​        }
7. ​        return result
8. ​    }
9. ​    // Inferred that Suffix is Stack<Int>.
10. }
```

## 通用的其中子句

类型约束，如[类型约束](https://docs.swift.org/swift-book/LanguageGuide/Generics.html#ID186)中所述，使您能够定义与泛型函数、下标或类型关联的类型参数的要求。

定义关联类型的要求也很有用。你通过定义年龄*语where子句来*做到这一点。一个通用`where`子句允许您要求关联类型必须符合特定协议，或者某些类型参数和相关类型必须相同。一个通用`where`子句以`where`关键字开头，然后是关联类型的约束或类型与关联类型之间的等式关系。您就在类型或函数主体的开花括号之前编写一个泛型`where`子句。

下面的示例定义了一个名为`allItemsMatch`的通用函数，该函数检查两个`Container`实例是否以相同的顺序包含相同的项目。如果所有项目匹配，该函数返回`true`的布尔值，如果它们不匹配，则返回`false`值。

要检查的两个容器不必是相同类型的容器（尽管可以），但它们必须容纳相同类型的物品。此要求通过类型约束和通用子句的组合来表达：

1. func allItemsMatch<C1: Container, C2: Container>
2. ​    (_ someContainer: C1, _ anotherContainer: C2) -> Bool
3. ​    where C1.Item == C2.Item, C1.Item: Equatable {
4. 
5. ​        // Check that both containers contain the same number of items.
6. ​        if someContainer.count != anotherContainer.count {
7. ​            return false
8. ​        }
9. 
10. ​        // Check each pair of items to see if they're equivalent.
11. ​        for i in 0..<someContainer.count {
12. ​            if someContainer[i] != anotherContainer[i] {
13. ​                return false
14. ​            }
15. ​        }
16. 
17. ​        // All items match, so return true.
18. ​        return true
19. }

此函数需要两个参数，称为`someContainer`和`anotherContainer`。ThesomeContainer参数为`C1`类型，`anotherContainer`参数为`C2`类型。`C1`和`C2`都是调用函数时要确定的两个容器类型的类型参数。

对函数的两个类型参数提出了以下要求：

- `C1`必须符合`Container`协议（写为`C1:Container`）。
- `C2`还必须符合`Container`协议（写为`C2:Container`）。
- The `Item` for `C1` must be the same as the `Item` for `C2` (written as `C1.Item == C2.Item`).
- `C1``Item`必须符合`Equatable`协议（写为`C1.Item:Equatable`）。

第一个和第二个要求在函数的类型参数列表中定义，第三个和第四个要求在函数的通用`where`子句中定义。

这些要求意味着：

- `someContainer`是`C1`型容器。
- `anotherContainer`是`C2`型容器。
- `someContainer``anotherContainer`包含相同类型的项目。
- The items in `someContainer` can be checked with the not equal operator (`!=`) to see if they’re different from each other.

第三和第四个要求结合在一起，这意味着`anotherContainer`中的物品也可以与`!=`运算符，因为它们与insomeContainer中的项目完全相同。

这些要求使`allItemsMatch(_:_:)`函数能够比较两个容器，即使它们是不同的容器类型。

`allItemsMatch(_:_:)`函数首先检查两个容器是否包含相同数量的项目。如果它们包含不同数量的项目，则无法匹配，并且函数返回`false`。

After making this check, the function iterates over all of the items in `someContainer` with a `for`-`in` loop and the half-open range operator (`..<`). For each item, the function checks whether the item from `someContainer` isn’t equal to the corresponding item in `anotherContainer`. If the two items aren’t equal, then the two containers don’t match, and the function returns `false`.

如果循环结束时没有发现不匹配，则两个容器匹配，并且函数返回`true`。

以下是`allItemsMatch(_:_:)`函数在操作中的样子：

```swift
   var stackOfStrings = Stack<String>()
   stackOfStrings.push("uno")
   stackOfStrings.push("dos")
   stackOfStrings.push("tres")
   
   var arrayOfStrings = ["uno", "dos", "tres"]
   
   if allItemsMatch(stackOfStrings, arrayOfStrings) {
   ​    print("All items match.")
    } else {
    ​    print("Not all items match.")
 }
// Prints "All items match."
```

上面的示例创建一个`Stack`实例来存储`String`值，并将三个字符串推送到堆栈上。该示例还创建一个`Array`实例，该实例使用包含与堆栈相同的三个字符串的数组文字初始化。尽管堆栈和数组类型不同，但它们都符合`Container`协议，并且都包含相同类型的值。因此，您可以使用这两个容器作为参数调用`allItemsMatch(_:_:)`函数。在上面的示例中，`allItemsMatch(_:_:)`函数正确报告两个容器中的所有项目都匹配。

## 带有通用Where子句的扩展

您还可以使用泛型`where`子句作为扩展的一部分。以下示例从前面的示例中扩展了通用`Stack`结构，以添加`isTop(_:)`方法。

1. extension Stack where Element: Equatable {
2. ​    func isTop(_ item: Element) -> Bool {
3. ​        guard let topItem = items.last else {
4. ​            return false
5. ​        }
6. ​        return topItem == item
7. ​    }
8. }

这个新的`isTop(_:)`方法首先检查堆栈不是空的，然后将给定的项目与堆栈的最上面的项目进行比较。如果您尝试在没有泛型`where`子句的情况下执行此操作，您将遇到问题：`isTop(_:)`的实现使用`==`运算符，但`Stack`的定义不要求其项是可等的，因此使用`==`运算符会导致编译时错误。使用通用`where`子句，您可以向扩展添加新要求，以便扩展仅在堆栈中的项目可等时添加`isTop(_:)`方法。

以下是`isTop(_:)`方法在操作中的样子：

1. if stackOfStrings.isTop("tres") {
2. ​    print("Top element is tres.")
3. } else {
4. ​    print("Top element is something else.")
5. }
6. // Prints "Top element is tres."

如果您尝试在元素不可等同的堆栈上调用`isTop(_:)`方法，您将收到编译时错误。
```swift
struct NotEquatable { }
var notEquatableStack = Stack<NotEquatable>()
let notEquatableValue = NotEquatable()
notEquatableStack.push(notEquatableValue)
notEquatableStack.isTop(notEquatableValue)  // Error`
```
You can use a generic `where` clause with extensions to a protocol. The example below extends the `Container` protocol from the previous examples to add a `startsWith(_:)`method.

1. extension Container where Item: Equatable {
2. ​    func startsWith(_ item: Item) -> Bool {
3. ​        return count >= 1 && self[0] == item
4. ​    }
5. }

`startsWith(_:)`方法首先确保容器至少有一个项目，然后检查容器中的第一个项目是否与给定项目匹配。只要容器的项目是等同的，此newstartsWith`startsWith(_:)`方法可以与符合`Container`协议的任何类型一起使用，包括上面使用的堆栈和数组。

1. if [9, 9, 9].startsWith(42) {
2. ​    print("Starts with 42.")
3. } else {
4. ​    print("Starts with something else.")
5. }
6. // Prints "Starts with something else."

上面示例中的泛型`where`子句要求`Item`符合协议，但您也可以编写一个泛型`where`子句，要求`Item`是特定类型。例如：

1. extension Container where Item == Double {
2. ​    func average() -> Double {
3. ​        var sum = 0.0
4. ​        for index in 0..<count {
5. ​            sum += self[index]
6. ​        }
7. ​        return sum / Double(count)
8. ​    }
9. }
10. print([1260.0, 1200.0, 98.6, 37.0].average())
11. // Prints "648.9"

此示例为`Item`类型为`Double`的容器添加了`average()`方法。它迭代容器中的项目以将其相加，并除以容器计数以计算平均值。它显式将计数从`Int`转换为`Double`，以便能够进行浮点除法。

您可以在作为扩展一部分的泛型`where`子句中包含多个要求，就像您可以在其他地方编写的泛型`where`子句一样。用逗号分隔列表中的每个要求。

## 上下文，其中条款

当您已经在泛型类型上下文中工作时，您可以编写一个泛型`where`子句，作为声明的一部分，该声明没有自己的泛型类型约束。例如，您可以在泛型类型的下标或泛型类型扩展中的方法上编写泛型子句。`Container`结构是通用的，以下示例中的`where`子句指定了必须满足哪些类型约束才能在容器上提供这些新方法。

1. extension Container {
2. ​    func average() -> Double where Item == Int {
3. ​        var sum = 0.0
4. ​        for index in 0..<count {
5. ​            sum += Double(self[index])
6. ​        }
7. ​        return sum / Double(count)
8. ​    }
9. ​    func endsWith(_ item: Item) -> Bool where Item: Equatable {
10. ​        return count >= 1 && self[count-1] == item
11. ​    }
12. }
13. let numbers = [1260, 1200, 98, 37]
14. print(numbers.average())
15. // Prints "648.75"
16. print(numbers.endsWith(37))
17. // Prints "true"

当项目为整数时，此示例向`Container`添加`average()`方法，当项为等同时，它会添加`endsWith(_:)`方法。这两个函数都包括一个泛型`where`子句，该子句从`Container`的原始声明中向通用`Item`类型参数添加类型约束。

如果您想在不使用上下文`where`子句的情况下编写此代码，则编写两个扩展，每个泛型`where`子句一个。上面的示例和下面的示例具有相同的行为。

1. extension Container where Item == Int {
2. ​    func average() -> Double {
3. ​        var sum = 0.0
4. ​        for index in 0..<count {
5. ​            sum += Double(self[index])
6. ​        }
7. ​        return sum / Double(count)
8. ​    }
9. }
10. extension Container where Item: Equatable {
11. ​    func endsWith(_ item: Item) -> Bool {
12. ​        return count >= 1 && self[count-1] == item
13. ​    }
14. }

In the version of this example that uses contextual `where` clauses, the implementation of `average()` and `endsWith(_:)` are both in the same extension because each method’s generic `where` clause states the requirements that need to be satisfied to make that method available. Moving those requirements to the extensions’ generic `where` clauses makes the methods available in the same situations, but requires one extension per requirement.

## 与通用Where子句关联的类型

您可以在关联类型上包含一个泛型`where`子句。例如，假设您想制作一个包含迭代器的`Container`版本，就像`Sequence`协议在标准库中使用的一样。您是这样写的：

1. protocol Container {
2. ​    associatedtype Item
3. ​    mutating func append(_ item: Item)
4. ​    var count: Int { get }
5. ​    subscript(i: Int) -> Item { get }
6. 
7. ​    associatedtype Iterator: IteratorProtocol where Iterator.Element == Item
8. ​    func makeIterator() -> Iterator
9. }

`Iterator`上的通用`where`子句要求迭代器必须遍历与容器项目相同的项目类型的元素，无论迭代器的类型如何。ThemakeIterator`makeIterator()`函数提供对容器迭代器的访问。

对于从另一个协议继承的协议，您可以通过在协议声明中包含泛型`where`子句来向继承的关联类型添加约束。例如，以下代码声明了一个`ComparableContainer`协议，该协议要求`Item`符合`Comparable`：

1. protocol ComparableContainer: Container where Item: Comparable { }

## 通用下标

下标可以是通用的，它们可以包括通用的`where`子句。您在`subscript`后角括号内写入占位符类型名称，并在下标正文的开花括号前写一个泛型`where`子句。例如：

1. extension Container {
2. ​    subscript<Indices: Sequence>(indices: Indices) -> [Item]
3. ​        where Indices.Iterator.Element == Int {
4. ​            var result: [Item] = []
5. ​            for index in indices {
6. ​                result.append(self[index])
7. ​            }
8. ​            return result
9. ​    }
10. }

`Container`协议的扩展添加了一个下标，该下标接受一系列索引，并返回一个包含每个给定索引项目项的数组。此通用下标受以下限制：

- 角括号中的通用参数`Indices`必须是符合标准库中的`Sequence`协议的类型。
- 下标取单个参数，即`indices`，这是该`Indices`类型的实例。
- 通用`where`子句要求序列的迭代器必须遍历`Int`类型的元素。这确保了序列中的索引与容器中使用的索引类型相同。

总而言之，这些约束意味着为`indices`参数传递的值是整数序列。