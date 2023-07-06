---
title: Swift基础 嵌套类型
tags:
    - Swift
    - 基础
categories:
    - Swift
date: 2022-07-01 12:01:01
thumbnail:
---


翻译自：https://docs.swift.org/swift-book/LanguageGuide/NestedTypes.html

创建枚举通常是为了支持特定类或结构的功能。同样，可以方便地定义纯属实用程序类和结构，以便在更复杂类型的上下文中使用。为了做到这一点，Swift使您能够定义*嵌套类型*，从而在它们支持的类型的定义中嵌套支持枚举、类和结构。

要将类型嵌套在另一种类型中，请在它支持的类型的外部大括号中写入其定义。类型可以嵌套到所需的任意级别。

## 嵌套类型在行动

下面的示例定义了一个名为`BlackjackCard`结构，该结构模拟了二十一点游戏中使用的扑克牌。`BlackjackCard`结构包含两种嵌套枚举类型，称为`Suit`和`Rank`。

在二十一点中，Ace卡的价值为1或11。此功能由一个名为`Values`结构表示，该结构嵌套在`Rank`枚举中：

1. struct BlackjackCard {
2. 
3. ​    // nested Suit enumeration
4. ​    enum Suit: Character {
5. ​        case spades = "♠", hearts = "♡", diamonds = "♢", clubs = "♣"
6. ​    }
7. 
8. ​    // nested Rank enumeration
9. ​    enum Rank: Int {
10. ​        case two = 2, three, four, five, six, seven, eight, nine, ten
11. ​        case jack, queen, king, ace
12. ​        struct Values {
13. ​            let first: Int, second: Int?
14. ​        }
15. ​        var values: Values {
16. ​            switch self {
17. ​            case .ace:
18. ​                return Values(first: 1, second: 11)
19. ​            case .jack, .queen, .king:
20. ​                return Values(first: 10, second: nil)
21. ​            default:
22. ​                return Values(first: self.rawValue, second: nil)
23. ​            }
24. ​        }
25. ​    }
26. 
27. ​    // BlackjackCard properties and methods
28. ​    let rank: Rank, suit: Suit
29. ​    var description: String {
30. ​        var output = "suit is \(suit.rawValue),"
31. ​        output += " value is \(rank.values.first)"
32. ​        if let second = rank.values.second {
33. ​            output += " or \(second)"
34. ​        }
35. ​        return output
36. ​    }
37. }

`Suit`枚举描述了四套常见的扑克牌套装，以及代表其符号的原始`Character`值。

`Rank`枚举描述了13个可能的扑克牌排名，以及表示其面值的原始`Int`值。（此原始`Int`值不用于Jack、Queen、King和Ace卡。）

如上所述，`Rank`枚举定义了自己的进一步嵌套结构，称为`Values`。这种结构概括了一个事实，即大多数卡片只有一个值，但Ace卡有两个值。`Values`结构定义了两个属性来表示这一点：

- `first`，类型`Int`
- `second`，类型为`Int?`，或“optional `Int`”

`Rank`还定义了一个计算属性，即`values`，它返回`Values`结构的实例。此计算属性考虑卡的排名，并根据排名使用适当的值初始化一个新的`Values`实例。它为`jack`、`queen`、`king`和`ace`使用特殊值。对于数字卡，它使用排名的原始`Int`值。

`BlackjackCard`结构本身有两个属性——`rank`和`suit`。它还定义了一个名为`description`计算属性，该属性使用`rank`和`suit`中存储的值来构建卡片名称和值的描述。`description`属性使用可选绑定来检查是否有第二个值要显示，如果是，则为第二个值插入额外的描述细节。

由于`BlackjackCard`是一个没有自定义初始化器的结构，因此它有一个隐式成员初始化器，如[结构类型的成员初始化器](https://docs.swift.org/swift-book/LanguageGuide/Initialization.html#ID214)中所述。您可以使用此初始化器初始化名为`theAceOfSpades`的新常量：

1. let theAceOfSpades = BlackjackCard(rank: .ace, suit: .spades)
2. print("theAceOfSpades: \(theAceOfSpades.description)")
3. // Prints "theAceOfSpades: suit is ♠, value is 1 or 11"

即使`Rank`和`Suit`嵌套在`BlackjackCard`中，它们的类型可以从上下文中推断出来，因此此实例的初始化只能通过它们的大小写名称（`.ace`和`.spades`）来引用枚举案例。在上面的示例中，`description`属性正确地报告黑桃王牌的值为`1`或11。

## 提及嵌套类型

要在其定义上下文之外使用嵌套类型，请在其名称前加上嵌套在其中的类型名称：

1. let heartsSymbol = BlackjackCard.Suit.hearts.rawValue
2. // heartsSymbol is "♡"

对于上面的例子，这使`Suit`、`Rank`和`Values`的名称可以故意保持简短，因为它们的名字自然会被定义它们的上下文所限定。