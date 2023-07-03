---
title: Swift基础 方法
tags:
    - swift
    - 基础
categories:
    - 技术
date: 2022-07-01 12:01:01
thumbnail:
---

翻译自：https://docs.swift.org/swift-book/LanguageGuide/Methods.html

*方法*是与特定类型关联的函数。类、结构和枚举都可以定义实例方法，这些方法封装了处理给定类型实例的特定任务和功能。类、结构和枚举还可以定义类型方法，这些方法与类型本身相关联。类型方法类似于Objective-C中的类方法。

结构和枚举可以在Swift中定义方法，这一事实与C和Objective-C有很大区别。在Objective-C中，类是唯一可以定义方法的类型。在 Swift 中，您可以选择是定义类、结构还是枚举，并且仍然可以灵活地定义您创建的类型上的方法。

## 实例方法

*实例方法*是属于特定类、结构或枚举实例的函数。它们支持这些实例的功能，要么通过提供访问和修改实例属性的方法，要么通过提供与实例目的相关的功能。实例方法具有与函数完全相同的语法，如[函数](https://docs.swift.org/swift-book/LanguageGuide/Functions.html)中所述。

您可以在它所属类型的打开和关闭大括号中编写实例方法。实例方法可以隐式访问该类型的所有其他实例方法和属性。实例方法只能调用其所属类型的特定实例。没有现有实例，就无法孤立地调用它。

以下是定义简单`Counter`类的示例，可用于计算操作发生的次数：

1. class Counter {
2. ​    var count = 0
3. ​    func increment() {
4. ​        count += 1
5. ​    }
6. ​    func increment(by amount: Int) {
7. ​        count += amount
8. ​    }
9. ​    func reset() {
10. ​        count = 0
11. ​    }
12. }

`Counter`类定义了三种实例方法：

- `increment()`将计数器增加1。
- `increment(by: Int)`计数器以指定的整数量增加。
- `reset()`重置计数器为零。

`Counter`类还声明一个变量属性`count`，以跟踪当前计数器值。

您调用与属性具有相同点语法的实例方法：

1. let counter = Counter()
2. // the initial counter value is 0
3. counter.increment()
4. // the counter's value is now 1
5. counter.increment(by: 5)
6. // the counter's value is now 6
7. counter.reset()
8. // the counter's value is now 0

函数参数可以具有名称（用于函数正文）和参数标签（用于调用函数时），如[函数参数标签和参数名称](https://docs.swift.org/swift-book/LanguageGuide/Functions.html#ID166)所述。方法参数也是如此，因为方法只是与类型关联的函数。

### 自我财产

类型的每个实例都有一个名为`self`的隐式属性，这与实例本身完全等价。您使用`self`属性在自己的实例方法中引用当前实例。

上面示例中的`increment()`方法可以这样写：

1. func increment() {
2. ​    self.count += 1
3. }

在实践中，您不需要经常在代码中编写`self`。如果您没有显式写入`self`，每当您在方法中使用已知的属性或方法名称时，Swift都会假设您指的是当前实例的属性或方法。`Counter`的三个实例方法中使用`count`（而不是`self.count`）证明了这一假设。

当实例方法的参数名称与该实例的属性具有相同的名称时，就会出现此规则的主要异常。在这种情况下，参数名称优先，有必要以更限定的方式引用该属性。您使用`self`属性来区分参数名称和属性名称。

在这里，`self`消除名为`x`的方法参数和也称为`x`的实例属性之间的歧义：

1. struct Point {
2. ​    var x = 0.0, y = 0.0
3. ​    func isToTheRightOf(x: Double) -> Bool {
4. ​        return self.x > x
5. ​    }
6. }
7. let somePoint = Point(x: 4.0, y: 5.0)
8. if somePoint.isToTheRightOf(x: 1.0) {
9. ​    print("This point is to the right of the line where x == 1.0")
10. }
11. // Prints "This point is to the right of the line where x == 1.0"

没有`self`前缀，Swift将假设`x`的两个用法都提到了称为`x`的方法参数。

### 从实例内方法修改值类型

结构和枚举是*值类型*。默认情况下，值类型的属性无法从其实例方法中修改。

但是，如果您需要在特定方法中修改结构或枚举的属性，您可以选择该方法的*突变*行为。然后，该方法可以从方法内部突变（即更改）其属性，并在方法结束时将其所做的任何更改写回原始结构。该方法还可以为其隐式`self`属性分配一个全新的实例，当方法结束时，该新实例将取代现有实例。

您可以通过将`mutating`关键字放在该方法的`func`关键字之前来选择加入此行为：

1. struct Point {
2. ​    var x = 0.0, y = 0.0
3. ​    mutating func moveBy(x deltaX: Double, y deltaY: Double) {
4. ​        x += deltaX
5. ​        y += deltaY
6. ​    }
7. }
8. var somePoint = Point(x: 1.0, y: 1.0)
9. somePoint.moveBy(x: 2.0, y: 3.0)
10. print("The point is now at (\(somePoint.x), \(somePoint.y))")
11. // Prints "The point is now at (3.0, 4.0)"

The `Point` structure above defines a mutating `moveBy(x:y:)` method, which moves a `Point`instance by a certain amount. Instead of returning a new point, this method actually modifies the point on which it’s called. The `mutating` keyword is added to its definition to enable it to modify its properties.

请注意，您无法在结构类型的常量上调用突变方法，因为它的属性无法更改，即使它们是变量属性，如[常量结构实例的存储属性](https://docs.swift.org/swift-book/LanguageGuide/Properties.html#ID256)中所述：

1. let fixedPoint = Point(x: 3.0, y: 3.0)
2. fixedPoint.moveBy(x: 2.0, y: 3.0)
3. // this will report an error

### 在突变方法中分配给自我

突变方法可以为隐式`self`属性分配一个全新的实例。上面显示的`Point`示例可以写成以下方式：

1. struct Point {
2. ​    var x = 0.0, y = 0.0
3. ​    mutating func moveBy(x deltaX: Double, y deltaY: Double) {
4. ​        self = Point(x: x + deltaX, y: y + deltaY)
5. ​    }
6. }

This version of the mutating `moveBy(x:y:)` method creates a new structure whose `x` and `y`values are set to the target location. The end result of calling this alternative version of the method will be exactly the same as for calling the earlier version.

枚举的突变方法可以将隐式`self`参数设置为与同一枚举不同的情况：

1. enum TriStateSwitch {
2. ​    case off, low, high
3. ​    mutating func next() {
4. ​        switch self {
5. ​        case .off:
6. ​            self = .low
7. ​        case .low:
8. ​            self = .high
9. ​        case .high:
10. ​            self = .off
11. ​        }
12. ​    }
13. }
14. var ovenLight = TriStateSwitch.low
15. ovenLight.next()
16. // ovenLight is now equal to .high
17. ovenLight.next()
18. // ovenLight is now equal to .off

此示例定义了三态开关的枚举。每次调用其`next()`方法时，开关都会在三种不同的功率状态（`off`、`low`和`high`）之间循环。

## 类型方法

如上所述，实例方法是您在特定类型的实例上调用的方法。您还可以定义在类型本身上调用的方法。这些方法被称为*类型方法*。您可以通过在方法的`func`关键字之前写入`static`关键字来指示类型方法。类可以使用`class`关键字，以允许子类覆盖超类对该方法的实现。

注意

在Objective-C中，您只能为Objective-C类定义类型级方法。在 Swift 中，您可以为所有类、结构和枚举定义类型级方法。每个类型方法都显式扩展到它支持的类型。

类型方法使用点语法调用，就像实例方法一样。但是，您在类型上调用类型方法，而不是在该类型的实例上调用类型方法。以下是您在名为`SomeClass`的类上调用类型方法的方法：

1. class SomeClass {
2. ​    class func someTypeMethod() {
3. ​        // type method implementation goes here
4. ​    }
5. }
6. SomeClass.someTypeMethod()

在类型方法的主体中，隐式`self`属性是指类型本身，而不是该类型的实例。这意味着您可以使用`self`来消除类型属性和类型方法参数之间的歧义，就像您对实例属性和实例方法参数所做的那样。

更一般地说，您在类型方法正文中使用的任何不合格的方法和属性名称都将引用其他类型级方法和属性。类型方法可以调用另一个类型方法，使用另一个方法的名称，而无需将其前缀为类型名称。同样，结构和枚举上的类型方法可以通过使用类型属性的名称来访问类型属性，而无需类型名称前缀。

下面的示例定义了一个名为`LevelTracker`的结构，该结构跟踪玩家在游戏的不同关卡或阶段的进度。这是一个单人游戏，但可以在一台设备上存储多个玩家的信息。

游戏首次玩游戏时，游戏的所有关卡（除一级外）都已锁定。每次玩家完成关卡时，该关卡都会为设备上的所有玩家解锁。`LevelTracker`结构使用类型属性和方法来跟踪游戏的哪些关卡已解锁。它还跟踪单个玩家的当前级别。

1. struct LevelTracker {
2. ​    static var highestUnlockedLevel = 1
3. ​    var currentLevel = 1
4. 
5. ​    static func unlock(_ level: Int) {
6. ​        if level > highestUnlockedLevel { highestUnlockedLevel = level }
7. ​    }
8. 
9. ​    static func isUnlocked(_ level: Int) -> Bool {
10. ​        return level <= highestUnlockedLevel
11. ​    }
12. 
13. ​    @discardableResult
14. ​    mutating func advance(to level: Int) -> Bool {
15. ​        if LevelTracker.isUnlocked(level) {
16. ​            currentLevel = level
17. ​            return true
18. ​        } else {
19. ​            return false
20. ​        }
21. ​    }
22. }

The `LevelTracker` structure keeps track of the highest level that any player has unlocked. This value is stored in a type property called `highestUnlockedLevel`.

`LevelTracker`还定义了两种类型函数，以使用`highestUnlockedLevel`属性。第一个是名为`unlock(_:)`的类型函数，每当解锁新级别时，它都会更新`highestUnlockedLevel`的值。第二个是名为`isUnlocked(_:)`的方便类型函数，如果特定级别号已解锁，则返回`true`。（请注意，这些类型方法可以访问`highestUnlockedLevel`类型属性，而无需将其写为`LevelTracker.highestUnlockedLevel`。）

除了其类型属性和类型方法外，`LevelTracker`还跟踪单个玩家在游戏中的进度。它使用名为`currentLevel`的实例属性来跟踪玩家当前正在播放的级别。

To help manage the `currentLevel` property, `LevelTracker` defines an instance method called `advance(to:)`. Before updating `currentLevel`, this method checks whether the requested new level is already unlocked. The `advance(to:)` method returns a Boolean value to indicate whether or not it was actually able to set `currentLevel`. Because it’s not necessarily a mistake for code that calls the `advance(to:)` method to ignore the return value, this function is marked with the `@discardableResult` attribute. For more information about this attribute, see [Attributes](https://docs.swift.org/swift-book/ReferenceManual/Attributes.html).

`LevelTracker`结构与如下所示的`Player`类一起使用，以跟踪和更新单个玩家的进度：

1. class Player {
2. ​    var tracker = LevelTracker()
3. ​    let playerName: String
4. ​    func complete(level: Int) {
5. ​        LevelTracker.unlock(level + 1)
6. ​        tracker.advance(to: level + 1)
7. ​    }
8. ​    init(name: String) {
9. ​        playerName = name
10. ​    }
11. }

The `Player` class creates a new instance of `LevelTracker` to track that player’s progress. It also provides a method called `complete(level:)`, which is called whenever a player completes a particular level. This method unlocks the next level for all players and updates the player’s progress to move them to the next level. (The Boolean return value of `advance(to:)` is ignored, because the level is known to have been unlocked by the call to `LevelTracker.unlock(_:)` on the previous line.)

您可以为新玩家创建`Player`类的实例，并查看玩家完成一级时会发生什么：

1. var player = Player(name: "Argyrios")
2. player.complete(level: 1)
3. print("highest unlocked level is now \(LevelTracker.highestUnlockedLevel)")
4. // Prints "highest unlocked level is now 2"

如果您创建了第二个玩家，并试图将该玩家移动到游戏中任何玩家尚未解锁的关卡，则设置玩家当前关卡的尝试失败：

1. player = Player(name: "Beto")
2. if player.tracker.advance(to: 6) {
3. ​    print("player is now on level 6")
4. } else {
5. ​    print("level 6 hasn't yet been unlocked")
6. }
7. // Prints "level 6 hasn't yet been unlocked"