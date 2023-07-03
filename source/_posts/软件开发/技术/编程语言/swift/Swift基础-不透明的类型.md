---
title: Swift基础 不透明的类型
tags:
    - swift
    - 基础
categories:
    - 技术
date: 2022-07-01 12:01:01
thumbnail:
---

翻译自：https://docs.swift.org/swift-book/LanguageGuide/OpaqueTypes.html

具有不透明返回类型的函数或方法隐藏其返回值的类型信息。返回值不是提供具体类型作为函数的返回类型，而是根据其支持的协议来描述。隐藏类型信息在调用模块的模块和代码之间的边界上非常有用，因为返回值的底层类型可以保持私密性。与返回类型为协议类型的值不同，不透明类型保留类型标识——编译器可以访问类型信息，但模块的客户端不能访问。

## 不透明类型解决的问题

例如，假设您正在编写一个绘制ASCII艺术形状的模块。ASCII艺术形状的基本特征是`draw()`函数，该函数返回该形状的字符串表示形式，您可以将其用作`Shape`协议的要求：

1. protocol Shape {
2. ​    func draw() -> String
3. }
4. 
5. struct Triangle: Shape {
6. ​    var size: Int
7. ​    func draw() -> String {
8. ​        var result: [String] = []
9. ​        for length in 1...size {
10. ​            result.append(String(repeating: "*", count: length))
11. ​        }
12. ​        return result.joined(separator: "\n")
13. ​    }
14. }
15. let smallTriangle = Triangle(size: 3)
16. print(smallTriangle.draw())
17. // *
18. // **
19. // ***

您可以使用泛型来实现垂直翻转形状等操作，如下代码所示。然而，这种方法有一个重要的局限性：翻转的结果暴露了用于创建它的确切通用类型。

1. struct FlippedShape<T: Shape>: Shape {
2. ​    var shape: T
3. ​    func draw() -> String {
4. ​        let lines = shape.draw().split(separator: "\n")
5. ​        return lines.reversed().joined(separator: "\n")
6. ​    }
7. }
8. let flippedTriangle = FlippedShape(shape: smallTriangle)
9. print(flippedTriangle.draw())
10. // ***
11. // **
12. // *

This approach to defining a `JoinedShape<T: Shape, U: Shape>` structure that joins two shapes together vertically, like the code below shows, results in types like `JoinedShape<FlippedShape<Triangle>, Triangle>` from joining a flipped triangle with another triangle.

1. struct JoinedShape<T: Shape, U: Shape>: Shape {
2. ​    var top: T
3. ​    var bottom: U
4. ​    func draw() -> String {
5. ​        return top.draw() + "\n" + bottom.draw()
6. ​    }
7. }
8. let joinedTriangles = JoinedShape(top: smallTriangle, bottom: flippedTriangle)
9. print(joinedTriangles.draw())
10. // *
11. // **
12. // ***
13. // ***
14. // **
15. // *

公开有关创建形状的详细信息，可以让不打算属于ASCII艺术模块公共界面的类型泄露出去，因为需要声明完整的返回类型。模块内的代码可以以各种方式构建相同的形状，模块外使用该形状的其他代码不应考虑有关转换列表的实现细节。`JoinedShape`和`FlippedShape`等包装类型对模块的用户无关紧要，它们不应该可见。该模块的公共接口包括连接和翻转形状等操作，这些操作返回另一个`Shape`值。

## 返回不透明类型

你可以把不透明的类型想象成通用类型的反面。通用类型允许调用函数的代码为该函数的参数选择类型，并以从函数实现抽象出来的方式返回值。例如，以下代码中的函数返回的类型取决于其调用者：

`func max<T>(_ x: T, _ y: T) -> T where T: Comparable { ... }`

调用`max(_:_:)`的代码为`x`和`y`选择值，这些值的类型决定了`T`的具体类型。调用代码可以使用任何符合`Comparable`协议的类型。函数中的代码以一般方式编写，因此它可以处理调用者提供的任何类型。`max(_:_:)`的实现仅使用所有`Comparable`类型共享的功能。

对于具有不透明返回类型的函数，这些角色是反向的。不透明类型允许函数实现以一种从调用函数的代码抽象出来的方式选择它返回的值的类型。例如，以下示例中的函数返回梯形而不暴露该形状的底层类型。
```swift
struct Square: Shape {
​    var size: Int
​    func draw() -> String {
​        let line = String(repeating: "*", count: size)
​        let result = Array<String>(repeating: line, count: size)
​        return result.joined(separator: "\n")
​    }
}
```

1.  func makeTrapezoid() -> some Shape {
2.  ​    let top = Triangle(size: 2)
3.  ​    let middle = Square(size: 2)
4.  ​    let bottom = FlippedShape(shape: top)
5.  ​    let trapezoid = JoinedShape(
6.  ​        top: top,
7.  ​        bottom: JoinedShape(top: middle, bottom: bottom)
8.  ​    )
9.  ​    return trapezoid
10. }
11. let trapezoid = makeTrapezoid()
12. print(trapezoid.draw())
13. // *
14. // **
15. // **
16. // **
17. // **
18. // *

本示例中的`makeTrapezoid()`函数将其返回类型声明为`someShape`；因此，该函数返回符合`Shape`协议的给定类型的值，而不指定任何特定的具体类型。以这种方式编写`makeTrapezoid()`可以表达其公共接口的基本方面——它返回的值是一个形状——而无需制作形状由其公共接口的一部分制成的特定类型。这个实现使用两个三角形和一个正方形，但可以重写该函数，以各种其他方式绘制梯形，而不会改变其返回类型。

此示例突出了不透明的返回类型与泛型类型相反的方式。`makeTrapezoid()`内部的代码可以返回它需要的任何类型，只要该类型符合`Shape`协议，就像调用通用函数一样。调用函数的代码需要以一般方式编写，例如实现泛型函数，以便它可以与`makeTrapezoid()`返回的任何`Shape`值一起工作。

您还可以将不透明的返回类型与泛型组合在一起。以下代码中的函数都返回符合`Shape`协议的某种类型的值。
```
1. func flip<T: Shape>(_ shape: T) -> some Shape {
2. ​    return FlippedShape(shape: shape)
3. }
4. func join<T: Shape, U: Shape>(_ top: T, _ bottom: U) -> some Shape {
5. ​    JoinedShape(top: top, bottom: bottom)
6. }
7. 
8. let opaqueJoinedTriangles = join(smallTriangle, flip(smallTriangle))
9. print(opaqueJoinedTriangles.draw())
10. // *
11. // **
12. // ***
13. // ***
14. // **
15. // *
```
本示例中`opaqueJoinedTriangles`的值与本章前面[不透明类型解决的问题](https://docs.swift.org/swift-book/LanguageGuide/OpaqueTypes.html#ID613)部分中的泛型示例中的`joinedTriangles`相同。然而，与该示例中的值不同，`flip(_:)`和`join(_:_:)`将通用形状操作返回的底层类型包装在不透明的返回类型中，这防止这些类型可见。这两个函数都是通用的，因为它们依赖的类型是通用的，函数的类型参数传递`FlippedShape`和`JoinedShape`所需的类型信息。

如果具有不透明返回类型的函数从多个地方返回，则所有可能的返回值必须具有相同的类型。对于泛型函数，该返回类型可以使用函数的泛型类型参数，但它必须仍然是单一类型。例如，以下是形状翻转函数的*无效*版本，其中包括正方形的特殊情况：
```
1. func invalidFlip<T: Shape>(_ shape: T) -> some Shape {
2. ​    if shape is Square {
3. ​        return shape // Error: return types don't match
4. ​    }
5. ​    return FlippedShape(shape: shape) // Error: return types don't match
6. }
```
如果您使用`Square`调用此函数，它将返回`Square`；否则，它将返回aFlippedShape。这违反了仅返回一种类型的值的要求，并使`invalidFlip(_:)`代码无效。修复`invalidFlip(_:)`的一种方法是将正方形的特殊情况移动到`FlippedShape`的实现中，这使得此函数始终返回aFlippedShape值：
```
1. struct FlippedShape<T: Shape>: Shape {
2. ​    var shape: T
3. ​    func draw() -> String {
4. ​        if shape is Square {
5. ​            return shape.draw()
6. ​        }
7. ​        let lines = shape.draw().split(separator: "\n")
8. ​        return lines.reversed().joined(separator: "\n")
9. ​    }
10. }
```
始终返回单个类型的要求并不妨碍您在不透明的返回类型中使用泛型。以下是将其类型参数集成到其返回的值的基础类型的函数示例：
```
1. func `repeat`<T: Shape>(shape: T, count: Int) -> some Collection {
2. ​    return Array<T>(repeating: shape, count: count)
3. }
```
在这种情况下，返回值的底层类型因`T`而异：无论传递什么形状，`repeat(shape:count:)`创建并返回该形状的数组。然而，返回值始终具有相同的`[T]`底层类型，因此它遵循了具有不透明返回类型的函数必须仅返回单个类型的值的要求。

不透明类型和协议类型之间的差异

返回不透明类型看起来与使用协议类型作为函数的返回类型非常相似，但这两种返回类型在是否保留类型标识方面有所不同。不透明类型是指一种特定类型，尽管函数的调用者无法看到哪种类型；协议类型可以引用任何符合协议的类型。一般来说，协议类型使您更灵活地了解它们存储的值的底层类型，不透明类型允许您对这些底层类型做出更有力的保证。

例如，这是一个`flip(_:)`版本，它使用协议类型作为其返回类型，而不是不透明的返回类型：
```
1. func protoFlip<T: Shape>(_ shape: T) -> Shape {
2. ​    return FlippedShape(shape: shape)
3. }
```
此版本的`protoFlip(_:)`与`flip(_:)`具有相同的主体，并且它总是返回相同类型的值。与`flip(_:)`，`protoFlip(_:)`返回的值不需要始终具有相同的类型——它只需要符合`Shape`协议。换句话说，`protoFlip(_:)`与其调用者签订的API合同比`flip(_:)`的API合同要宽松得多。它保留了返回多种类型值的灵活性：
```
1. func protoFlip<T: Shape>(_ shape: T) -> Shape {
2. ​    if shape is Square {
3. ​        return shape
4. ​    }
5. 
6. ​    return FlippedShape(shape: shape)
7. }
```
代码的修订版本返回`Square`的实例或`FlippedShape`的实例，具体取决于传递的形状。此函数返回的两个翻转形状可能具有完全不同的类型。当翻转相同形状的多个实例时，此函数的其他有效版本可以返回不同类型的值。来自`protoFlip(_:)`不太具体的返回类型信息意味着许多依赖类型信息的操作在返回的值上不可用。例如，无法编写`==`运算符来比较此函数返回的结果。

1. let protoFlippedTriangle = protoFlip(smallTriangle)
2. let sameThing = protoFlip(smallTriangle)
3. protoFlippedTriangle == sameThing  // Error

示例最后一行的错误有几个原因。迫在眉睫的问题是，`Shape`不包含`==`运算符作为其协议要求的一部分。如果您尝试添加一个，您将遇到的下一个问题是`==`运算符需要知道其左手和右手参数的类型。这种运算符通常接受typeSelf的参数，匹配采用协议的任何具体类型，但在协议中添加`Self`要求不允许将协议用作类型时发生的类型擦除。

使用协议类型作为函数的返回类型使您可以灵活地返回任何符合协议的类型。然而，这种灵活性的成本是，一些操作无法对返回的值进行。该示例显示了`==`运算符如何不可用——这取决于使用协议类型无法保留的特定类型信息。

这种方法的另一个问题是形状转换不会嵌套。翻转三角形的结果是类型为`Shape`的值，`protoFlip(_:)`函数采用符合`Shape`协议的某种类型的参数。然而，协议类型的值不符合该协议；`protoFlip(_:)`返回的值不符合`Shape`。这意味着像`protoFlip(protoFlip(smallTriange))`这样的应用多个转换的代码无效，因为翻转的形状不是toprotoFlip`protoFlip(_:)`的有效参数。

相比之下，不透明类型保留了底层类型的身份。Swift可以推断关联类型，这允许您在协议类型不能用作返回值的地方使用不透明的返回值。例如，这是来自[Generics](https://docs.swift.org/swift-book/LanguageGuide/Generics.html)的`Container`协议的一个版本：

1. protocol Container {
2. ​    associatedtype Item
3. ​    var count: Int { get }
4. ​    subscript(i: Int) -> Item { get }
5. }
6. extension Array: Container { }

您不能将`Container`用作函数的返回类型，因为该协议具有关联类型。您也不能在泛型返回类型中将其用作约束，因为函数体外部没有足够的信息来推断泛型类型需要是什么。
```
1. // Error: Protocol with associated types can't be used as a return type.
2. func makeProtocolContainer<T>(item: T) -> Container {
3. ​    return [item]
4. }
5. 
6. // Error: Not enough information to infer C.
7. func makeProtocolContainer<T, C: Container>(item: T) -> C {
8. ​    return [item]
9. }
```
使用不透明类型`someContainer`作为返回类型表示所需的API合同——该函数返回容器，但拒绝指定容器的类型：
```
1. func makeOpaqueContainer<T>(item: T) -> some Container {
2. ​    return [item]
3. }
4. let opaqueContainer = makeOpaqueContainer(item: 12)
5. let twelve = opaqueContainer[0]
6. print(type(of: twelve))
7. // Prints "Int"
```
`twelve`的类型被推断为`Int`，这说明了类型推断适用于不透明类型的事实。在`makeOpaqueContainer(item:)`的实现中，不透明容器的基础类型是`[T]`在这种情况下，`T`是`Int`，因此返回值是整数数数组，并且推断出`Item`关联的类型为`Int`。`Container`上的下标返回`Item`，这意味着`twelve`的类型也被推断为`Int`。