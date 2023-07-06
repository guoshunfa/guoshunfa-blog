---
title: Swift基础 去初始化
tags:
  - Swift
  - 基础
categories:
  - Swift
date: 2022-07-01 12:01:01
thumbnail:
---


翻译自：https://docs.swift.org/swift-book/LanguageGuide/Deinitialization.html

在类实例被释放之前，会立即调用*去初始化器*。您使用`deinit`关键字编写去初始化器，类似于使用`init`关键字编写初始化器的方式。取消初始化器仅适用于类类型。

## Deinitialization如何运作

Swift 会在不再需要实例时自动处理这些实例，以释放资源。Swift通过*自动引用计数*（*ARC*）处理实例的内存管理，如[自动引用计数](https://docs.swift.org/swift-book/LanguageGuide/AutomaticReferenceCounting.html)中所述。通常，在实例被释放时，您不需要进行手动清理。但是，当您使用自己的资源时，您可能需要自己进行一些额外的清理。例如，如果您创建一个自定义类来打开文件并向其写入一些数据，您可能需要在类实例被释放之前关闭文件。

类定义每个类最多可以有一个去初始化器。取消初始化器不接受任何参数，并且没有括号：

1. deinit {
2. ​    // perform the deinitialization
3. }

在实例处理分配发生之前，会自动调用去初始化器。您不得自己调用非初始化器。超类非初始化器由其子类继承，超类非初始化器在子类非初始化器实现结束时自动调用。总是调用超类非初始化器，即使子类不提供自己的非初始化器。

由于实例在调用其非初始化器后才会被释放，因此非初始化器可以访问其调用的实例的所有属性，并可以根据这些属性修改其行为（例如查找需要关闭的文件的名称）。

## 去初始化器在行动

以下是一个非初始化器在起作用的例子。这个例子为一个简单的游戏定义了两种新类型，`Bank`和`Player`。`Bank`级管理一种制成币，流通量永远不会超过10,000枚硬币。游戏中只能有一个`Bank`，因此该`Bank`是一个具有类型属性和方法来存储和管理其当前状态的类实现：

1. class Bank {
2. ​    static var coinsInBank = 10_000
3. ​    static func distribute(coins numberOfCoinsRequested: Int) -> Int {
4. ​        let numberOfCoinsToVend = min(numberOfCoinsRequested, coinsInBank)
5. ​        coinsInBank -= numberOfCoinsToVend
6. ​        return numberOfCoinsToVend
7. ​    }
8. ​    static func receive(coins: Int) {
9. ​        coinsInBank += coins
10. ​    }
11. }

`Bank` keeps track of the current number of coins it holds with its `coinsInBank` property. It also offers two methods—`distribute(coins:)` and `receive(coins:)`—to handle the distribution and collection of coins.

`distribute(coins:)`方法在分发硬币之前检查银行中是否有足够的硬币。如果硬币不够，`Bank`返回的数字比请求的数字要小（如果银行中没有硬币，则返回零）。它返回一个整数值，以指示提供的实际硬币数量。

`receive(coins:)`方法只需将收到的硬币数量重新添加到银行的硬币商店。

`Player`类描述了游戏中的玩家。每个玩家的钱包里随时都有一定数量的硬币。这由玩家的`coinsInPurse`属性表示：

1. class Player {
2. ​    var coinsInPurse: Int
3. ​    init(coins: Int) {
4. ​        coinsInPurse = Bank.distribute(coins: coins)
5. ​    }
6. ​    func win(coins: Int) {
7. ​        coinsInPurse += Bank.distribute(coins: coins)
8. ​    }
9. ​    deinit {
10. ​        Bank.receive(coins: coinsInPurse)
11. ​    }
12. }

在初始化期间，每个`Player`实例都使用银行指定数量的硬币的起始限额进行初始化，尽管如果没有足够的硬币可用，`Player`实例收到的硬币可能少于该数字。

`Player`类定义了一个`win(coins:)`方法，该方法从银行检索一定数量的硬币并将其添加到玩家的钱包中。`Player`类还实现了去初始化器，该去初始化器是在`Player`实例被释放之前调用的。在这里，去初始化器只需将玩家的所有硬币退还给银行：

1. var playerOne: Player? = Player(coins: 100)
2. print("A new player has joined the game with \(playerOne!.coinsInPurse) coins")
3. // Prints "A new player has joined the game with 100 coins"
4. print("There are now \(Bank.coinsInBank) coins left in the bank")
5. // Prints "There are now 9900 coins left in the bank"

创建一个新的`Player`实例，如果有的话，需要100枚硬币。此`Player`实例存储在名为`playerOne`的可选`Player`变量中。这里使用可选变量，因为玩家可以随时离开游戏。可选功能允许您跟踪游戏中目前是否有玩家。

因为`playerOne`是可选的，所以它有资格获得感叹号（`!`）当访问itscoinsInPurse属性以打印其默认硬币数量时，以及每当调用itswin`win(coins:)`方法时：

1. playerOne!.win(coins: 2_000)
2. print("PlayerOne won 2000 coins & now has \(playerOne!.coinsInPurse) coins")
3. // Prints "PlayerOne won 2000 coins & now has 2100 coins"
4. print("The bank now only has \(Bank.coinsInBank) coins left")
5. // Prints "The bank now only has 7900 coins left"

在这里，玩家赢得了2000枚硬币。玩家的钱包现在包含2100枚硬币，而银行只剩下7900枚硬币。

1. playerOne = nil
2. print("PlayerOne has left the game")
3. // Prints "PlayerOne has left the game"
4. print("The bank now has \(Bank.coinsInBank) coins")
5. // Prints "The bank now has 10000 coins"

玩家现在已经离开了游戏。这通过将可选的`playerOne`变量设置为`nil`来指示，这意味着“没有`Player`实例”。发生这种情况时，`playerOne`变量对`Player`实例的引用被破坏。没有其他属性或变量仍然引用`Player`实例，因此将其释放以释放其内存。就在这种情况发生之前，其去初始化器会自动调用，其硬币被退回银行。