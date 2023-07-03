---
title: Swift基础 协议
tags:
    - swift
    - 基础
categories:
    - 技术
date: 2022-07-01 12:01:01
thumbnail:
---

翻译自：https://docs.swift.org/swift-book/LanguageGuide/Protocols.html

*协议*定义了适合特定任务或功能的方法、属性和其他要求的蓝图。然后，该协议可以由类、结构或枚举*采用*，以提供这些要求的实际实现。任何满足协议要求的类型都被称为*符合*该协议。

除了指定符合类型必须实现的要求外，您还可以扩展协议来实现其中一些需求或实现符合类型可以利用的其他功能。

## 协议语法

您以与类、结构和枚举非常相似的方式定义协议：

1. protocol SomeProtocol {
2. ​    // protocol definition goes here
3. }

自定义类型声明，他们采用特定协议，将协议的名称放在类型名称之后，用冒号分隔，作为其定义的一部分。可以列出多个协议，并用逗号分隔：

1. struct SomeStructure: FirstProtocol, AnotherProtocol {
2. ​    // structure definition goes here
3. }

如果一个类有一个超类，请在它采用的任何协议之前列出超类名称，后跟逗号：

1. class SomeClass: SomeSuperclass, FirstProtocol, AnotherProtocol {
2. ​    // class definition goes here
3. }

## 财产要求

协议可以要求任何符合要求的类型为实例属性或类型属性提供特定名称和类型。该协议没有指定该属性是存储属性还是计算属性，它只指定所需的属性名称和类型。该协议还指定每个属性必须是可获取的还是可获取*和*可设置的。

如果协议要求属性可获取和可设置，则该属性要求无法由常量存储属性或只读计算属性满足。如果协议仅要求属性是可获取的，则任何类型的属性都可以满足该要求，如果这对您自己的代码有用，则该属性也可以设置。

Property requirements are always declared as variable properties, prefixed with the `var`keyword. Gettable and settable properties are indicated by writing `{ get set }` after their type declaration, and gettable properties are indicated by writing `{ get }`.

1. protocol SomeProtocol {
2. ​    var mustBeSettable: Int { get set }
3. ​    var doesNotNeedToBeSettable: Int { get }
4. }

在协议中定义类型属性要求时，请务必用静态关键字作为类型属性要求前缀。即使类型属性要求在类实现时可以以`class`或静态关键字为前缀，但此规则也适用：

1. protocol AnotherProtocol {
2. ​    static var someTypeProperty: Int { get set }
3. }

以下是具有单个实例属性要求的协议示例：

1. protocol FullyNamed {
2. ​    var fullName: String { get }
3. }

`FullyNamed`协议要求符合要求的类型来提供完全限定的名称。该协议没有指定任何关于符合类型性质的任何其他信息——它只指定该类型必须能够为自己提供全名。该协议规定，任何`FullyNamed`类型都必须有一个名为`fullName`的gettable实例属性，该属性类型为`String`。

以下是采用并符合`FullyNamed`协议的简单结构示例：

1. struct Person: FullyNamed {
2. ​    var fullName: String
3. }
4. let john = Person(fullName: "John Appleseed")
5. // john.fullName is "John Appleseed"

此示例定义了一个名为`Person`结构，该结构表示一个特定的命名人。它表示，它采用`FullyNamed`协议作为其定义第一行的一部分。

Each instance of `Person` has a single stored property called `fullName`, which is of type `String`. This matches the single requirement of the `FullyNamed` protocol, and means that `Person` has correctly conformed to the protocol. (Swift reports an error at compile time if a protocol requirement isn’t fulfilled.)

这里有一个更复杂的类，它也采用并符合`FullyNamed`协议：

1. class Starship: FullyNamed {
2. ​    var prefix: String?
3. ​    var name: String
4. ​    init(name: String, prefix: String? = nil) {
5. ​        self.name = name
6. ​        self.prefix = prefix
7. ​    }
8. ​    var fullName: String {
9. ​        return (prefix != nil ? prefix! + " " : "") + name
10. ​    }
11. }
12. var ncc1701 = Starship(name: "Enterprise", prefix: "USS")
13. // ncc1701.fullName is "USS Enterprise"

该类实现`fullName`属性要求，作为星际飞船的计算只读属性。每个`Starship`类实例都存储一个必填`name`和一个可选`prefix`。如果存在，`fullName`属性使用`prefix`值，并将其前置于`name`开头，为星舰创建全名。

## 方法要求

协议可以要求通过符合类型实现特定的实例方法和类型方法。这些方法作为协议定义的一部分，以与普通实例和类型方法完全相同的方式编写，但没有花括号或方法主体。允许变量参数，但须遵守与正常方法相同的规则。然而，无法为协议定义中的方法参数指定默认值。

与类型属性要求一样，当在协议中定义`static`关键字时，您总是在类型方法要求前加上静态关键字。即使类型方法要求在类实现时以`class`或静态关键字为前缀，也是如此：

1. protocol SomeProtocol {
2. ​    static func someTypeMethod()
3. }

以下示例定义了具有单个实例方法要求的协议：

1. protocol RandomNumberGenerator {
2. ​    func random() -> Double
3. }

该协议`RandomNumberGenerator`要求任何符合要求的类型都有一个名为`random`实例方法，该方法在调用时返回一个`Double`值。虽然它没有指定为协议的一部分，但假设这个值将从`0.0`到（但不包括）`1.0`。

`RandomNumberGenerator`协议不会对如何生成每个随机数做出任何假设——它只是要求生成器提供一种标准方法来生成新的随机数。

以下是采用并符合`RandomNumberGenerator`协议的类的实现。该类实现了伪随机数生成器算法，称为*线性同余生成器*：

1. class LinearCongruentialGenerator: RandomNumberGenerator {
2. ​    var lastRandom = 42.0
3. ​    let m = 139968.0
4. ​    let a = 3877.0
5. ​    let c = 29573.0
6. ​    func random() -> Double {
7. ​        lastRandom = ((lastRandom * a + c)
8. ​            .truncatingRemainder(dividingBy:m))
9. ​        return lastRandom / m
10. ​    }
11. }
12. let generator = LinearCongruentialGenerator()
13. print("Here's a random number: \(generator.random())")
14. // Prints "Here's a random number: 0.3746499199817101"
15. print("And another one: \(generator.random())")
16. // Prints "And another one: 0.729023776863283"

## 突变方法要求

有时，方法需要修改（或*突变*）它所属的实例。例如，值类型（即结构和枚举）上的方法，您将`mutating`关键字放在方法的`func`关键字之前，以指示允许该方法修改其所属的实例和该实例的任何属性。这个过程在[从实例内方法修改值类型中](https://docs.swift.org/swift-book/LanguageGuide/Methods.html#ID239)进行了描述。

如果您定义了旨在突变采用该协议的任何类型的实例的协议实例方法要求，请将该方法标记为协议定义的一部分。这使结构和枚举能够采用协议并满足该方法要求。

注意

如果您将协议实例方法要求标记为`mutating`，则在为类编写该方法的实现时无需编写`mutating`关键字。`mutating`关键字仅供结构和枚举使用。

下面的示例定义了一个名为`Togglable`的协议，该协议定义了一个名为`toggle`单个实例方法要求。顾名思义，`toggle()`方法旨在切换或反转任何符合类型的状态，通常通过修改该类型的属性。

`toggle()`方法被标记为`mutating`关键字，作为`Togglable`协议定义的一部分，以指示该方法在调用时预计将突变符合实例的状态：

1. protocol Togglable {
2. ​    mutating func toggle()
3. }

如果您为结构或枚举实现`Togglable`协议，该结构或枚举可以通过提供也标记为`mutating`的`toggle()`方法的实现来符合协议。

The example below defines an enumeration called `OnOffSwitch`. This enumeration toggles between two states, indicated by the enumeration cases `on` and `off`. The enumeration’s `toggle` implementation is marked as `mutating`, to match the `Togglable` protocol’s requirements:

1. enum OnOffSwitch: Togglable {
2. ​    case off, on
3. ​    mutating func toggle() {
4. ​        switch self {
5. ​        case .off:
6. ​            self = .on
7. ​        case .on:
8. ​            self = .off
9. ​        }
10. ​    }
11. }
12. var lightSwitch = OnOffSwitch.off
13. lightSwitch.toggle()
14. // lightSwitch is now equal to .on

## 初始化器要求

协议可以要求通过符合类型实现特定的初始化器。您以与普通初始化器完全相同的方式编写这些初始化器作为协议定义的一部分，但没有花括号或初始化器主体：

1. protocol SomeProtocol {
2. ​    init(someParameter: Int)
3. }

### 协议初始化器要求的类实现

您可以在符合要求的类上实现协议初始化器要求，作为指定的初始化器或方便初始化器。在这两种情况下，您都必须用`required`修饰符标记初始化器实现：

1. class SomeClass: SomeProtocol {
2. ​    required init(someParameter: Int) {
3. ​        // initializer implementation goes here
4. ​    }
5. }

使用`required`修饰符可确保您在符合类的所有子类上提供初始化器要求的显式或继承实现，以便它们也符合协议。

有关所需初始化器的更多信息，请参阅[所需初始化器](https://docs.swift.org/swift-book/LanguageGuide/Initialization.html#ID231)。

注意

您不需要在标有`final`修饰符的类上使用`required`修饰符标记协议初始化器实现，因为最终类无法子类。有关`final`修饰符的更多信息，请参阅[防止覆盖](https://docs.swift.org/swift-book/LanguageGuide/Inheritance.html#ID202)。

如果子类从超类覆盖指定的初始化器，并且还从协议中实现了匹配的初始化器要求，请用`required`修饰符和`override`修饰符标记初始化器实现：

1. protocol SomeProtocol {
2. ​    init()
3. }
4. 
5. class SomeSuperClass {
6. ​    init() {
7. ​        // initializer implementation goes here
8. ​    }
9. }
10. 
11. class SomeSubClass: SomeSuperClass, SomeProtocol {
12. ​    // "required" from SomeProtocol conformance; "override" from SomeSuperClass
13. ​    required override init() {
14. ​        // initializer implementation goes here
15. ​    }
16. }

### 失败的初始化器要求

协议可以定义符合类型的故障初始化器要求，如[故障初始化器](https://docs.swift.org/swift-book/LanguageGuide/Initialization.html#ID224)中定义。

符合要求的类型上的可故障或不可失败的初始化器可以满足故障初始化器要求。非故障初始化器或隐式未包装的故障初始化器可以满足非故障初始化器要求。

## 协议作为类型

协议本身实际上并没有实现任何功能。尽管如此，您可以在代码中将协议用作成熟的类型。将协议用作类型有时被称为*存在类型*，它来自短语“存在一种类型*T*，使得*T*符合协议”。

您可以在许多允许其他类型的地方使用协议，包括：

- 作为函数、方法或初始化器中的参数类型或返回类型
- 作为常量、变量或属性的类型
- 作为数组、字典或其他容器中项目的类型

注意

由于协议是类型，因此以大写字母（如`FullyNamed`和`RandomNumberGenerator`）开头，以匹配Swift中其他类型的名称（如`Int`、`String`和`Double`）。

以下是用作类型的协议示例：

1. class Dice {
2. ​    let sides: Int
3. ​    let generator: RandomNumberGenerator
4. ​    init(sides: Int, generator: RandomNumberGenerator) {
5. ​        self.sides = sides
6. ​        self.generator = generator
7. ​    }
8. ​    func roll() -> Int {
9. ​        return Int(generator.random() * Double(sides)) + 1
10. ​    }
11. }

此示例定义了一个名为`Dice`的新类，它表示用于棋盘游戏的*n*面骰子。`Dice`实例有一个称为`sides`的整数属性，表示它们有多少边，以及一个称为生`generator`属性，它提供了一个随机数生成器，从中创建骰子滚动值。

`generator`属性为`RandomNumberGenerator`类型。因此，您可以将其设置为采用`RandomNumberGenerator`协议*的任何*类型的实例。您分配给此属性的实例不需要其他内容，除非实例必须采用`RandomNumberGenerator`协议。由于其类型是`RandomNumberGenerator`，`Dice`类中的代码只能以适用于所有符合此协议的生成器的方式与`generator`交互。这意味着它不能使用由生成器底层类型定义的任何方法或属性。但是，您可以从协议类型降级类型到底层类型，就像您可以从超类向下转换到子类一样，正如在[向下转换](https://docs.swift.org/swift-book/LanguageGuide/TypeCasting.html#ID341)中讨论的那样。

`Dice`还有一个初始化器，用于设置其初始状态。此初始化器有一个名为`generator`的参数，该参数也属于`RandomNumberGenerator`类型。在初始化新的`Dice`实例时，您可以将任何符合类型的值传递给此参数。

`Dice`提供一种实例方法，`roll`，它返回1和骰子上边数之间的整数值。此方法调用生成器的`random()`方法，以创建一个`0.0`到`1.0`之间的新随机数，并使用此随机数在正确的范围内创建骰子滚动值。由于已知`generator`采用`RandomNumberGenerator`，因此它保证有一个`random()`方法可以调用。

以下是如何使用`Dice`创建以a`LinearCongruentialGenerator`实例作为其随机数生成器的六面骰子：

1. var d6 = Dice(sides: 6, generator: LinearCongruentialGenerator())
2. for _ in 1...5 {
3. ​    print("Random dice roll is \(d6.roll())")
4. }
5. // Random dice roll is 3
6. // Random dice roll is 5
7. // Random dice roll is 4
8. // Random dice roll is 5
9. // Random dice roll is 4

## 授权

*委托*是一种设计模式，使类或结构能够将其部分责任移交给（或*委托*）到另一种类型的实例。这种设计模式是通过定义封装委托责任的协议来实现的，这样保证符合的类型（称为委托）可以提供已委托的功能。委托可用于响应特定操作，或从外部来源检索数据，而无需知道该源的基础类型。

以下示例定义了两种用于基于骰子的棋盘游戏的协议：

1. protocol DiceGame {
2. ​    var dice: Dice { get }
3. ​    func play()
4. }
5. protocol DiceGameDelegate: AnyObject {
6. ​    func gameDidStart(_ game: DiceGame)
7. ​    func game(_ game: DiceGame, didStartNewTurnWithDiceRoll diceRoll: Int)
8. ​    func gameDidEnd(_ game: DiceGame)
9. }

`DiceGame`协议是一种协议，任何涉及骰子的游戏都可以采用。

可以使用`DiceGameDelegate`协议来跟踪`DiceGame`的进度。为了防止强引用周期，委托被声明为弱引用。有关弱引用的信息，请参阅[类实例之间的强引用周期](https://docs.swift.org/swift-book/LanguageGuide/AutomaticReferenceCounting.html#ID51)。将协议标记为仅类可以让`SnakesAndLadders`类在本章后面声明其委托必须使用弱引用。正如在仅[类协议](https://docs.swift.org/swift-book/LanguageGuide/Protocols.html#ID281)中讨论的那样，仅类协议通过从`AnyObject`继承来标记。

这是最初在[Control Flow](https://docs.swift.org/swift-book/LanguageGuide/ControlFlow.html)中引入*的蛇和梯子*游戏的一个版本。此版本适用于使用`Dice`实例进行骰子卷；采用`DiceGame`协议；并通知`DiceGameDelegate`其进度：

1. class SnakesAndLadders: DiceGame {
2. ​    let finalSquare = 25
3. ​    let dice = Dice(sides: 6, generator: LinearCongruentialGenerator())
4. ​    var square = 0
5. ​    var board: [Int]
6. ​    init() {
7. ​        board = Array(repeating: 0, count: finalSquare + 1)
8. ​        board[03] = +08; board[06] = +11; board[09] = +09; board[10] = +02
9. ​        board[14] = -10; board[19] = -11; board[22] = -02; board[24] = -08
10. ​    }
11. ​    weak var delegate: DiceGameDelegate?
12. ​    func play() {
13. ​        square = 0
14. ​        delegate?.gameDidStart(self)
15. ​        gameLoop: while square != finalSquare {
16. ​            let diceRoll = dice.roll()
17. ​            delegate?.game(self, didStartNewTurnWithDiceRoll: diceRoll)
18. ​            switch square + diceRoll {
19. ​            case finalSquare:
20. ​                break gameLoop
21. ​            case let newSquare where newSquare > finalSquare:
22. ​                continue gameLoop
23. ​            default:
24. ​                square += diceRoll
25. ​                square += board[square]
26. ​            }
27. ​        }
28. ​        delegate?.gameDidEnd(self)
29. ​    }
30. }

有关*蛇和梯子*游戏玩法的描述，请参阅[Break](https://docs.swift.org/swift-book/LanguageGuide/ControlFlow.html#ID137)。

这个版本的游戏被包装成一个名为`SnakesAndLadders`类，该类采用了`DiceGame`协议。它提供了一个gettable`dice`属性和一个`play()`方法，以符合协议。（`dice`属性被声明为常量属性，因为它在初始化后不需要更改，并且协议仅要求它必须是可获取的。）

*Snakes and Ladders*游戏板设置在类的`init()`初始化器中进行。所有游戏逻辑都转移到协议`play`方法中，该方法使用协议的必需`dice`属性来提供其骰子滚动值。

请注意，`delegate`属性被定义为*可选*的`DiceGameDelegate`，因为玩游戏不需要委托。由于它是可选类型，`delegate`属性会自动设置为`nil`的初始值。此后，游戏实例化器可以选择将属性设置为合适的委托。由于`DiceGameDelegate`协议仅限类，因此您可以声明委托为`weak`，以防止引用周期。

`DiceGameDelegate`提供了三种跟踪游戏进度的方法。这三种方法已纳入上述`play()`方法中的游戏逻辑，并在新游戏开始、新回合开始或游戏结束时调用。

由于`delegate`属性是*可选*的`DiceGameDelegate`，因此`play()`方法每次在委托上调用方法时都使用可选链。如果`delegate`属性为零，则这些委托调用优雅地失败，没有错误。如果`delegate`属性非零，则调用委托方法，并将`SnakesAndLadders`实例作为参数传递。

下一个示例显示了一个名为`DiceGameTracker`的类，该类采用了`DiceGameDelegate`协议：

1. class DiceGameTracker: DiceGameDelegate {
2. ​    var numberOfTurns = 0
3. ​    func gameDidStart(_ game: DiceGame) {
4. ​        numberOfTurns = 0
5. ​        if game is SnakesAndLadders {
6. ​            print("Started a new game of Snakes and Ladders")
7. ​        }
8. ​        print("The game is using a \(game.dice.sides)-sided dice")
9. ​    }
10. ​    func game(_ game: DiceGame, didStartNewTurnWithDiceRoll diceRoll: Int) {
11. ​        numberOfTurns += 1
12. ​        print("Rolled a \(diceRoll)")
13. ​    }
14. ​    func gameDidEnd(_ game: DiceGame) {
15. ​        print("The game lasted for \(numberOfTurns) turns")
16. ​    }
17. }

`DiceGameTracker`实现`DiceGameDelegate`所需的所有三种方法。它使用这些方法来跟踪游戏的转弯次数。当游戏开始时，它会将anumberOfTurns属性重置为零，每次新回合开始时都会增加，并在游戏结束后打印出回合总数。

上面显示的`gameDidStart(_:)`的实现使用`game`参数打印一些关于即将玩的游戏的介绍性信息。`game`参数具有`DiceGame`类型，而不是`SnakesAndLadders`，因此`gameDidStart(_:)`只能访问和使用作为`DiceGame`协议一部分实现的方法和属性。然而，该方法仍然能够使用类型转换来查询底层实例的类型。在本例中，它检查`game`是否实际上是幕后`SnakesAndLadders`的实例，如果是，则打印适当的消息。

`gameDidStart(_:)`方法还访问传递`game`参数的`dice`属性。由于`game`已知符合`DiceGame`协议，因此它保证具有`dice`属性，因此无论玩哪种游戏，`gameDidStart(_:)`方法都可以访问和打印骰子的`sides`属性。

以下是`DiceGameTracker`在操作中的样子：

1. let tracker = DiceGameTracker()
2. let game = SnakesAndLadders()
3. game.delegate = tracker
4. game.play()
5. // Started a new game of Snakes and Ladders
6. // The game is using a 6-sided dice
7. // Rolled a 3
8. // Rolled a 5
9. // Rolled a 4
10. // Rolled a 5
11. // The game lasted for 4 turns

## 通过扩展添加协议一致性

即使您无法访问现有类型的源代码，您也可以扩展现有类型以采用和遵守新协议。扩展可以向现有类型添加新的属性、方法和下标，因此能够添加协议可能要求的任何要求。有关扩展的更多信息，请参阅[扩展](https://docs.swift.org/swift-book/LanguageGuide/Extensions.html)。

注意

当该一致性在扩展中添加到实例的类型时，类型的现有实例会自动采用并符合协议。

例如，这种名为`TextRepresentable`的协议可以通过任何可以表示为文本的类型实现。这可能是对自身的描述，也可能是其当前状态的文本版本：

1. protocol TextRepresentable {
2. ​    var textualDescription: String { get }
3. }

上面的`Dice`可以扩展到采用并符合`TextRepresentable`：

1. extension Dice: TextRepresentable {
2. ​    var textualDescription: String {
3. ​        return "A \(sides)-sided dice"
4. ​    }
5. }

此扩展采用新协议的方式与`Dice`在其原始实现中提供的方式完全相同。协议名称在类型名称之后提供，由冒号分隔，并在扩展的花括号内提供协议所有要求的实现。

任何`Dice`实例现在都可以被视为`TextRepresentable`：

1. let d12 = Dice(sides: 12, generator: LinearCongruentialGenerator())
2. print(d12.textualDescription)
3. // Prints "A 12-sided dice"

同样，`SnakesAndLadders`游戏类可以扩展为采用并符合`TextRepresentable`协议：

1. extension SnakesAndLadders: TextRepresentable {
2. ​    var textualDescription: String {
3. ​        return "A game of Snakes and Ladders with \(finalSquare) squares"
4. ​    }
5. }
6. print(game.textualDescription)
7. // Prints "A game of Snakes and Ladders with 25 squares"

### 有条件地遵守协议

只有在特定条件下，例如当类型的通用参数符合协议时，通用类型才能满足协议的要求。您可以通过在扩展类型时列出约束，使泛型类型有条件地符合协议。通过编写通用`where`子句，在您采用的协议名称后写入这些约束。有关通用`where`子句的更多信息，请参阅[通用where子句](https://docs.swift.org/swift-book/LanguageGuide/Generics.html#ID192)。

以下扩展使`Array`实例在存储符合TextRepresentable的类型元素时符合`TextRepresentable`协议。

1. extension Array: TextRepresentable where Element: TextRepresentable {
2. ​    var textualDescription: String {
3. ​        let itemsAsText = self.map { $0.textualDescription }
4. ​        return "[" + itemsAsText.joined(separator: ", ") + "]"
5. ​    }
6. }
7. let myDice = [d6, d12]
8. print(myDice.textualDescription)
9. // Prints "[A 6-sided dice, A 12-sided dice]"

### 宣布协议通过扩展

如果一种类型已经符合协议的所有要求，但尚未声明它采用该协议，您可以使其采用带有空扩展名的协议：

1. struct Hamster {
2. ​    var name: String
3. ​    var textualDescription: String {
4. ​        return "A hamster named \(name)"
5. ​    }
6. }
7. extension Hamster: TextRepresentable {}

现在，只要`TextRepresentable`是必填类型，都可以使用`Hamster`实例：

1. let simonTheHamster = Hamster(name: "Simon")
2. let somethingTextRepresentable: TextRepresentable = simonTheHamster
3. print(somethingTextRepresentable.textualDescription)
4. // Prints "A hamster named Simon"

注意

类型不会仅仅通过满足其要求而自动采用协议。他们必须始终明确宣布通过该议定书。

## 使用综合实现采用协议

在许多简单的情况下，Swift可以自动为`Equatable`、`Hashable`和`Comparable`提供协议一致性。使用此综合实现意味着您不必编写重复的样板代码来自己实现协议要求。

Swift为以下类型的自定义类型提供了`Equatable`的综合实现：

- 仅存储符合`Equatable`协议的属性的结构
- 仅具有符合`Equatable`协议的关联类型的枚举
- 没有关联类型的枚举

To receive a synthesized implementation of `==`, declare conformance to `Equatable` in the file that contains the original declaration, without implementing an `==` operator yourself. The `Equatable` protocol provides a default implementation of `!=`.

下面的示例定义了三维位置向量`(x,y,z)`的`Vector3D`结构，类似于`Vector2D`结构。由于`x`、`y`和`z`属性都是`Equatable`的，`Vector3D`接收等价运算符的合成实现。

1. struct Vector3D: Equatable {
2. ​    var x = 0.0, y = 0.0, z = 0.0
3. }
4. 
5. let twoThreeFour = Vector3D(x: 2.0, y: 3.0, z: 4.0)
6. let anotherTwoThreeFour = Vector3D(x: 2.0, y: 3.0, z: 4.0)
7. if twoThreeFour == anotherTwoThreeFour {
8. ​    print("These two vectors are also equivalent.")
9. }
10. // Prints "These two vectors are also equivalent."

Swift为以下类型的自定义类型提供了`Hashable`的综合实现：

- Structures that have only stored properties that conform to the `Hashable` protocol
- 仅具有符合`Hashable`协议的关联类型的枚举
- 没有关联类型的枚举

要接收`hash(into:)`的合成实现，请在包含原始声明的文件中声明与`Hashable`的一致性，而无需自己实现`hash(into:)`方法。

Swift为没有原始值的枚举提供了`Comparable`的综合实现。如果枚举具有关联类型，它们都必须符合`Comparable`协议。要接收`<`的合成实现，请在包含原始枚举声明的文件中声明一致性为`Comparable`，而无需自己实现`<`运算符。`Comparable`协议的默认实现`<=`,`>`和`>=`提供了剩余的比较运算符。

以下示例定义了针对初学者、中级和专家案例的`SkillLevel`列举。专家还根据他们拥有的恒星数量进行排名。

1. enum SkillLevel: Comparable {
2. ​    case beginner
3. ​    case intermediate
4. ​    case expert(stars: Int)
5. }
6. var levels = [SkillLevel.intermediate, SkillLevel.beginner,
7. ​              SkillLevel.expert(stars: 5), SkillLevel.expert(stars: 3)]
8. for level in levels.sorted() {
9. ​    print(level)
10. }
11. // Prints "beginner"
12. // Prints "intermediate"
13. // Prints "expert(stars: 3)"
14. // Prints "expert(stars: 5)"

## 协议类型的集合

协议可以用作存储在集合中的类型，如数组或字典，如[协议](https://docs.swift.org/swift-book/LanguageGuide/Protocols.html#ID275)中所述。此示例创建一个`TextRepresentable`事物数组：

1. let things: [TextRepresentable] = [game, d12, simonTheHamster]

现在可以迭代数组中的项目，并打印每个项目的文本描述：

1. for thing in things {
2. ​    print(thing.textualDescription)
3. }
4. // A game of Snakes and Ladders with 25 squares
5. // A 12-sided dice
6. // A hamster named Simon

请注意，常量为`TextRepresentable`类型。它不是`Dice`、orDiceGame或`Hamster`类型，即使幕后的实际实例是这些类型之一。尽管如此，由于其类型为`TextRepresentable`，并且已知任何`TextRepresentable`都具有`textualDescription`属性，因此每次通过循环访问`thing.textualDescription`都是安全的。

## 协议继承

协议可以*继承*一个或多个其他协议，并可以在继承的要求之外添加进一步的要求。协议继承的语法类似于类继承的语法，但可以选择列出多个继承的协议，用逗号分隔：

1. protocol InheritingProtocol: SomeProtocol, AnotherProtocol {
2. ​    // protocol definition goes here
3. }

以下是从上面继承`TextRepresentable`协议的协议示例：

1. protocol PrettyTextRepresentable: TextRepresentable {
2. ​    var prettyTextualDescription: String { get }
3. }

This example defines a new protocol, `PrettyTextRepresentable`, which inherits from `TextRepresentable`. Anything that adopts `PrettyTextRepresentable` must satisfy all of the requirements enforced by `TextRepresentable`, *plus* the additional requirements enforced by `PrettyTextRepresentable`. In this example, `PrettyTextRepresentable` adds a single requirement to provide a gettable property called `prettyTextualDescription` that returns a `String`.

`SnakesAndLadders`类可以扩展到采用并符合`PrettyTextRepresentable`：

1. extension SnakesAndLadders: PrettyTextRepresentable {
2. ​    var prettyTextualDescription: String {
3. ​        var output = textualDescription + ":\n"
4. ​        for index in 1...finalSquare {
5. ​            switch board[index] {
6. ​            case let ladder where ladder > 0:
7. ​                output += "▲ "
8. ​            case let snake where snake < 0:
9. ​                output += "▼ "
10. ​            default:
11. ​                output += "○ "
12. ​            }
13. ​        }
14. ​        return output
15. ​    }
16. }

此扩展声明它采用`PrettyTextRepresentable`协议，并为`SnakesAndLadders`类型提供了 `prettyTextualDescription`属性的实现。任何`PrettyTextRepresentable`都必须是`TextRepresentable`，因此`prettyTextualDescription`的实现从`TextRepresentable`协议访问`textualDescription`属性开始，以启动输出字符串。它附加冒号和换行符，并将其用作其漂亮文本表示的开始。然后，它通过板正方形阵列迭代，并附加一个几何形状来表示每个正方形的内容：

- 如果正方形的值大于`0`，它是梯子的底部，并用▲表示。
- 如果正方形的值小于`0`，那就是蛇的头，并用▼表示。
- 否则，正方形的值为`0`，它是一个“自由”正方形，由`○`表示。

`prettyTextualDescription`属性现在可用于打印任何`SnakesAndLadders`实例的漂亮文本描述：

1. print(game.prettyTextualDescription)
2. // A game of Snakes and Ladders with 25 squares:
3. // ○ ○ ▲ ○ ○ ▲ ○ ○ ▲ ▲ ○ ○ ○ ▼ ○ ○ ○ ○ ▼ ○ ○ ▼ ○ ▼ ○

## 仅类协议

您可以通过将`AnyObject`协议添加到协议的继承列表中来将协议采用限制为类类型（而不是结构或枚举）。

1. protocol SomeClassOnlyProtocol: AnyObject, SomeInheritedProtocol {
2. ​    // class-only protocol definition goes here
3. }

在上面的示例中，`SomeClassOnlyProtocol`只能由类类型采用。编写试图采用`SomeClassOnlyProtocol`的结构或枚举定义是一个编译时错误。

注意

当该协议要求定义的行为假设或要求符合的类型具有参考语义而不是值语义时，请使用仅类协议。有关引用和值语义的更多信息，请参阅[结构和枚举是值类型](https://docs.swift.org/swift-book/LanguageGuide/ClassesAndStructures.html#ID88)，[类是参考类型](https://docs.swift.org/swift-book/LanguageGuide/ClassesAndStructures.html#ID89)。

## 礼宾组成

要求一种类型同时遵守多个协议可能是有用的。您可以将多个协议组合成一个带有*协议组合*的单个需求。协议组合的行为就好像您定义了一个临时本地协议，该协议具有组合中所有协议的组合要求。协议组合没有定义任何新的协议类型。

Protocol compositions have the form `SomeProtocol & AnotherProtocol`. You can list as many protocols as you need, separating them with ampersands (`&`). In addition to its list of protocols, a protocol composition can also contain one class type, which you can use to specify a required superclass.

以下是一个将两个名为`Named`和`Aged`的协议组合成函数参数上的单个协议组合要求的示例：

1. protocol Named {
2. ​    var name: String { get }
3. }
4. protocol Aged {
5. ​    var age: Int { get }
6. }
7. struct Person: Named, Aged {
8. ​    var name: String
9. ​    var age: Int
10. }
11. func wishHappyBirthday(to celebrator: Named & Aged) {
12. ​    print("Happy birthday, \(celebrator.name), you're \(celebrator.age)!")
13. }
14. let birthdayPerson = Person(name: "Malcolm", age: 21)
15. wishHappyBirthday(to: birthdayPerson)
16. // Prints "Happy birthday, Malcolm, you're 21!"

在本例中，`Named`协议对名为`name`的可获取`String`属性有一个单一要求。`Aged`协议对可取的`Int`属性调用具有单一要求。这两种协议都由一个名为`Person`的结构采用。

The example also defines a `wishHappyBirthday(to:)` function. The type of the `celebrator`parameter is `Named & Aged`, which means “any type that conforms to both the `Named` and `Aged` protocols.” It doesn’t matter which specific type is passed to the function, as long as it conforms to both of the required protocols.

然后，该示例创建一个名为`birthdayPerson`的新Person实例，并将此新实例传递给`wishHappyBirthday(to:)`函数。由于`Person`符合这两种协议，因此此通话是有效的，`wishHappyBirthday(to:)`功能可以打印其生日问候语。

以下是将上一个示例中的`Named`协议与aLocation类相结合的示例：

1. class Location {
2. ​    var latitude: Double
3. ​    var longitude: Double
4. ​    init(latitude: Double, longitude: Double) {
5. ​        self.latitude = latitude
6. ​        self.longitude = longitude
7. ​    }
8. }
9. class City: Location, Named {
10. ​    var name: String
11. ​    init(name: String, latitude: Double, longitude: Double) {
12. ​        self.name = name
13. ​        super.init(latitude: latitude, longitude: longitude)
14. ​    }
15. }
16. func beginConcert(in location: Location & Named) {
17. ​    print("Hello, \(location.name)!")
18. }
19. 
20. let seattle = City(name: "Seattle", latitude: 47.6, longitude: -122.3)
21. beginConcert(in: seattle)
22. // Prints "Hello, Seattle!"

The `beginConcert(in:)` function takes a parameter of type `Location & Named`, which means “any type that’s a subclass of `Location` and that conforms to the `Named` protocol.” In this case, `City` satisfies both requirements.

Passing `birthdayPerson` to the `beginConcert(in:)` function is invalid because `Person` isn’t a subclass of `Location`. Likewise, if you made a subclass of `Location` that didn’t conform to the `Named` protocol, calling `beginConcert(in:)` with an instance of that type is also invalid.

## 检查协议一致性

您可以使用[类型转换](https://docs.swift.org/swift-book/LanguageGuide/TypeCasting.html)中描述的`is`和`as`运算符来检查协议一致性，并转换为特定协议。检查和转换到协议遵循与检查和转换到类型完全相同的语法：

- 如果实例符合协议，则`is`运算符返回`true`，如果不符合协议，则返回`false`。
- `as?`向下转换运算符的版本返回协议类型的可选值，如果实例不符合该协议，则该值为`nil`。
- `as!`下调运算符的版本将下调强制到协议类型，如果下调失败，则触发运行时错误。

此示例定义了一个名为`HasArea`协议，具有称为`area`的可获取`Double`属性的单个属性要求：

1. protocol HasArea {
2. ​    var area: Double { get }
3. }

以下是两个类别，`Circle`和`Country`，它们都符合`HasArea`协议：

1. class Circle: HasArea {
2. ​    let pi = 3.1415927
3. ​    var radius: Double
4. ​    var area: Double { return pi * radius * radius }
5. ​    init(radius: Double) { self.radius = radius }
6. }
7. class Country: HasArea {
8. ​    var area: Double
9. ​    init(area: Double) { self.area = area }
10. }

`Circle`类基于存储`radius`属性将`area`属性要求作为计算属性实现。`Country`类直接作为存储属性实现`area`要求。这两个类都正确地符合`HasArea`协议。

这里有一个名为`Animal`的类，它不符合`HasArea`协议：

1. class Animal {
2. ​    var legs: Int
3. ​    init(legs: Int) { self.legs = legs }
4. }

`Circle`、`Country`和`Animal`类没有共享的基类。尽管如此，它们都是类，因此所有三种类型的实例都可以用于初始化存储类型`AnyObject`值的数组：

1. let objects: [AnyObject] = [
2. ​    Circle(radius: 2.0),
3. ​    Country(area: 243_610),
4. ​    Animal(legs: 4)
5. ]

`objects`数组初始化为数组文字，其中包含半径为2个单位的`Circle`实例；以英国表面积（平方公里）初始化`Country`实例；以及四个腿的`Animal`实例。

现在可以迭代`objects`数组，并且可以检查数组中的每个对象，看看它是否符合`HasArea`协议：

1. for object in objects {
2. ​    if let objectWithArea = object as? HasArea {
3. ​        print("Area is \(objectWithArea.area)")
4. ​    } else {
5. ​        print("Something that doesn't have an area")
6. ​    }
7. }
8. // Area is 12.5663708
9. // Area is 243610.0
10. // Something that doesn't have an area

Whenever an object in the array conforms to the `HasArea` protocol, the optional value returned by the `as?` operator is unwrapped with optional binding into a constant called `objectWithArea`. The `objectWithArea` constant is known to be of type `HasArea`, and so its `area` property can be accessed and printed in a type-safe way.

请注意，基础对象不会因铸造过程而改变。他们仍然是`Circle`、`Country`和`Animal`。然而，当它们存储在`objectWithArea`常量中时，它们只知道是`HasArea`类型，因此只能访问它们`area`属性。

## 《任择议定书》要求

您可以定义协议的*可选要求*。这些要求不必由符合协议的类型实现。作为协议定义的一部分，可选要求前缀为`optional`饰符。可选要求可用，以便您可以编写与Objective-C互操作的代码。协议和可选要求都必须用`@objc`属性标记。请注意，`@objc`协议只能由从Objective-C类或其他`@objc`类继承的类采用。它们不能被结构或枚举所采用。

当您在可选需求中使用方法或属性时，其类型会自动成为可选类型。例如，类型`(Int)->String`的方法变为`((Int)->String)?`请注意，整个函数类型包装在可选中，而不是方法的返回值中。

可选协议要求可以通过可选链调用，以解释该要求不是由符合协议的类型实现的可能性。调用可选方法时，您可以通过在方法名称后写一个问号来检查其实现，例如`someOptionalMethod?(someArgument)`有关可选链的信息，请参阅[可选链](https://docs.swift.org/swift-book/LanguageGuide/OptionalChaining.html)。

以下示例定义了一个名为`Counter`的整数计数类，该类使用外部数据源来提供其增量。此数据源由`CounterDataSource`协议定义，该协议有两个可选要求：

1. @objc protocol CounterDataSource {
2. ​    @objc optional func increment(forCount count: Int) -> Int
3. ​    @objc optional var fixedIncrement: Int { get }
4. }

`CounterDataSource`协议定义了一个名为`increment(forCount:)`的可选方法要求和一个名为`fixedIncrement`可选属性要求。这些要求定义了数据源为`Counter`实例提供适当增量的两种不同方式。

注意

严格来说，您可以编写符合`CounterDataSource`的自定义类，而无需实现*任一*协议要求。毕竟，它们都是可选的。虽然技术上允许，但这不会成为一个非常好的数据源。

下面定义的`Counter`类具有typeCounterDataSource`CounterDataSource?`的可选`dataSource`属性：

1. class Counter {
2. ​    var count = 0
3. ​    var dataSource: CounterDataSource?
4. ​    func increment() {
5. ​        if let amount = dataSource?.increment?(forCount: count) {
6. ​            count += amount
7. ​        } else if let amount = dataSource?.fixedIncrement {
8. ​            count += amount
9. ​        }
10. ​    }
11. }

`Counter`类将其当前值存储在称为`count`的变量属性中。`Counter`类还定义了一个名为`increment`的方法，每次调用方法时都会增加`count`属性。

`increment()`方法首先尝试通过在其数据源上查找`increment(forCount:)`方法的实现来检索增量。`increment()`方法使用可选链来尝试调用`increment(forCount:)`并将currentcount值作为方法的单个参数传递。

请注意，*两个*级别的可选链在这里起作用。首先，`dataSource`可能为`nil`，因此`dataSource`名称后有一个问号，表示只有当`dataSource`不是`nil`才应调用`increment(forCount:)`）。其次，即使`dataSource`*确实*存在，也不能保证它实现`increment(forCount:)`因为它是一个可选要求。在这里，`increment(forCount:)`可能无法实现的可能性也通过可选链处理。只有当`increment(forCount:)`存在时，才会调用`increment(forCount:)`），也就是说，如果它不是`nil`。这就是为什么`increment(forCount:)`在名称后面也用问号书写。

Because the call to `increment(forCount:)` can fail for either of these two reasons, the call returns an *optional* `Int` value. This is true even though `increment(forCount:)` is defined as returning a non-optional `Int` value in the definition of `CounterDataSource`. Even though there are two optional chaining operations, one after another, the result is still wrapped in a single optional. For more information about using multiple optional chaining operations, see [Linking Multiple Levels of Chaining](https://docs.swift.org/swift-book/LanguageGuide/OptionalChaining.html#ID252).

调用`increment(forCount:)`后，它返回的可选`Int`使用可选绑定解包装成一个常量称为`amount`。如果可选的`Int`确实包含一个值——也就是说，如果委托和方法都存在，并且方法返回了一个值——则未包装的`amount`将添加到存储`count`属性中，并且增量完成。

如果*无法*从`increment(forCount:)`方法中检索值——要么是因为`dataSource`为零，要么是因为数据源没有实现`increment(forCount:)`——那么`increment()`方法会尝试从数据源的`fixedIncrement`属性中检索值。`fixedIncrement`属性也是可选要求，因此其值是可选的`Int`值，即使`fixedIncrement`被定义为非可选的`Int`属性，作为`CounterDataSource`协议定义的一部分。

这是一个简单的`CounterDataSource`实现，其中数据源每次查询时都会返回`3`的常量值。它通过实现可选`fixedIncrement`属性要求来做到这一点：

1. class ThreeSource: NSObject, CounterDataSource {
2. ​    let fixedIncrement = 3
3. }

您可以使用`ThreeSource`实例作为新`Counter`实例的数据源：

1. var counter = Counter()
2. counter.dataSource = ThreeSource()
3. for _ in 1...4 {
4. ​    counter.increment()
5. ​    print(counter.count)
6. }
7. // 3
8. // 6
9. // 9
10. // 12

上面的代码创建一个新的`Counter`实例；将其数据源设置为newThreeSource实例；并四次调用counter的`increment()`方法。不出所料，每次调用`increment()`时，计数器的`count`属性都会增加三个。

Here’s a more complex data source called `TowardsZeroSource`, which makes a `Counter`instance count up or down towards zero from its current `count` value:

1. class TowardsZeroSource: NSObject, CounterDataSource {
2. ​    func increment(forCount count: Int) -> Int {
3. ​        if count == 0 {
4. ​            return 0
5. ​        } else if count < 0 {
6. ​            return 1
7. ​        } else {
8. ​            return -1
9. ​        }
10. ​    }
11. }

The `TowardsZeroSource` class implements the optional `increment(forCount:)` method from the `CounterDataSource` protocol and uses the `count` argument value to work out which direction to count in. If `count` is already zero, the method returns `0` to indicate that no further counting should take place.

You can use an instance of `TowardsZeroSource` with the existing `Counter` instance to count from `-4` to zero. Once the counter reaches zero, no more counting takes place:

1. counter.count = -4
2. counter.dataSource = TowardsZeroSource()
3. for _ in 1...5 {
4. ​    counter.increment()
5. ​    print(counter.count)
6. }
7. // -3
8. // -2
9. // -1
10. // 0
11. // 0

## 协议扩展

协议可以扩展到向符合要求的类型提供方法、初始化器、下标和计算属性实现。这允许您定义协议本身的行为，而不是在每种类型的单个一致性或全局函数中。

例如，`RandomNumberGenerator`协议可以扩展到提供arandomBool`randomBool()`方法，该方法使用所需的`random()`方法的结果返回随机`Bool`值：

1. extension RandomNumberGenerator {
2. ​    func randomBool() -> Bool {
3. ​        return random() > 0.5
4. ​    }
5. }

通过在协议上创建扩展，所有符合的类型都会自动获得此方法实现，而无需任何额外的修改。

1. let generator = LinearCongruentialGenerator()
2. print("Here's a random number: \(generator.random())")
3. // Prints "Here's a random number: 0.3746499199817101"
4. print("And here's a random Boolean: \(generator.randomBool())")
5. // Prints "And here's a random Boolean: true"

协议扩展可以向符合要求的类型添加实现，但不能使协议扩展或从其他协议继承。协议继承总是在协议声明本身中指定。

### 提供默认实现

您可以使用协议扩展为该协议的任何方法或计算属性要求提供默认实现。如果符合的类型提供了自己实现所需的方法或属性，则将使用该实现而不是扩展提供的实现。

注意

扩展提供的默认实现的协议要求与任择议定书要求不同。虽然符合要求的类型不必提供它们自己的实现，但可以调用默认实现的需求，而无需可选的链式。

例如，继承`TextRepresentable`协议的`PrettyTextRepresentable`协议可以提供其resedprettyTextualDescription属性的默认实现，以简单地返回访问`textualDescription`属性的结果：

1. extension PrettyTextRepresentable  {
2. ​    var prettyTextualDescription: String {
3. ​        return textualDescription
4. ​    }
5. }

### 为协议扩展添加约束

当您定义协议扩展时，您可以指定符合要求的类型在扩展的方法和属性可用之前必须满足的约束。您通过编写通用`where`子句，在您要扩展的协议名称后编写这些约束。有关通用`where`子句的更多信息，请参阅[通用where子句](https://docs.swift.org/swift-book/LanguageGuide/Generics.html#ID192)。

例如，您可以定义`Collection`协议的扩展，该扩展适用于其元素符合`Equatable`协议的任何集合。通过将集合的元素限制到标准库的一部分`Equatable`协议，您可以使用`==`和`!=`运算符来检查两个元素之间的等式和不等式。

1. extension Collection where Element: Equatable {
2. ​    func allEqual() -> Bool {
3. ​        for element in self {
4. ​            if element != self.first {
5. ​                return false
6. ​            }
7. ​        }
8. ​        return true
9. ​    }
10. }

只有当集合中的所有元素相等时，`allEqual()`方法才会返回`true`。

考虑两个整数数组，一个所有元素都相同，另一个不相同：

1. let equalNumbers = [100, 100, 100, 100, 100]
2. let differentNumbers = [100, 100, 200, 100, 200]

由于数组符合`Collection`，整数符合`Equatable`，`equalNumbers`和`differentNumbers`可以使用`allEqual()`方法：

1. print(equalNumbers.allEqual())
2. // Prints "true"
3. print(differentNumbers.allEqual())
4. // Prints "false"

注意

如果符合要求的类型满足为同一方法或属性提供实现的多个约束扩展的要求，Swift将使用与最专业约束相对应的实现。