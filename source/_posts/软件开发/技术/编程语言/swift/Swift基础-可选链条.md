---
title: Swift基础 可选链条
tags:
    - Swift
    - 基础
categories:
    - Swift
date: 2022-07-01 12:01:01
thumbnail:
---

翻译自：https://docs.swift.org/swift-book/LanguageGuide/OptionalChaining.html

*可选链*是一个在当前可能为`nil`的可选*链*上查询和调用属性、方法和下标的过程。如果可选包含值，则属性、方法或下标调用成功；如果可选值为`nil`，则属性、方法或下标调用返回`nil`。多个查询可以链接在一起，如果链中的任何链接为`nil`整个链条会优雅地失败。

注意

Swift中的可选链类似于Objective-C中的消息`nil`，但以适用于任何类型的方式，并且可以检查成功或失败。

## 可选链作为强制打开包装的替代方案

您通过放置问号（`?`）来指定可选的链条在可选值之后，如果可选值为非`nil`在您希望调用属性、方法或下标的可选值之后。这与放置感叹号（`!`）非常相似在可选值之后，强制展开其值。主要区别在于，当可选链接为`nil`，可选链会优雅地失败，而当可选链接为`nil`，强制展开包装会触发运行时错误。

为了反映可选链可以在`nil`值上调用的事实，可选链调用的结果始终是可选值，即使您正在查询的属性、方法或下标返回非可选值。您可以使用此可选返回值来检查可选链调用是否成功（返回的可选包含值），还是由于链中的`nil`值而没有成功（返回的可选值为`nil`）。

具体来说，可选链调用的结果与预期返回值类型相同，但包装在可选中。通常返回`Int`的属性会返回`Int?`通过可选链访问时。

接下来的几个代码片段演示了可选链与强制拆开的区别，并使您能够检查成功。

First, two classes called `Person` and `Residence` are defined:

1. class Person {
2. ​    var residence: Residence?
3. }
4. 
5. class Residence {
6. ​    var numberOfRooms = 1
7. }

`Residence`实例有一个名为`numberOfRooms``Int`属性，默认值为1。`Person`实例具有`Residence?`类型为可选的`residence`属性。

如果您创建一个新的`Person`实例，其`residence`属性默认初始化为`nil`，因为它是可选的。在下面的代码中，`john`的`residence`物业价值为`nil`：

1. let john = Person()

如果您尝试访问此人`residence`的`numberOfRooms`属性，通过在`residence`后放置感叹号以强制解开其值，您将触发运行时错误，因为没有`residence`值可以打开：

1. let roomCount = john.residence!.numberOfRooms
2. // this triggers a runtime error

`john.residence`具有非`nil`值时，上述代码将成功，并将`roomCount`设置为包含适当数量房间的`Int`值。然而，如上所述，当`residence`为`nil`，此代码总是触发运行时错误。

可选链提供了一种访问`numberOfRooms`值的替代方式。要使用可选的链条，请使用问号代替感叹号：

1. if let roomCount = john.residence?.numberOfRooms {
2. ​    print("John's residence has \(roomCount) room(s).")
3. } else {
4. ​    print("Unable to retrieve the number of rooms.")
5. }
6. // Prints "Unable to retrieve the number of rooms."

这告诉Swift在可选的`residence`属性上“链”，如果存在`residence`，则检索`numberOfRooms`值。

由于访问`numberOfRooms`尝试可能会失败，因此可选的链式尝试返回类型为`Int?`或“optional `Int`”的值。如上例所示，当`residence`为`nil`，此可选的`Int`也将为`nil`，以反映无法访问`numberOfRooms`的事实。可选的`Int`通过可选绑定访问，以解开整数，并将非可选值分配给`roomCount`常量。

请注意，即使`numberOfRooms`是一个非可选的`Int`也是如此。它通过可选链查询的事实意味着对`numberOfRooms`调用将始终返回anInt`Int?`而不是`Int`。

您可以将`Residence`实例分配给`john.residence`，使其不再具有`nil`值：

1. john.residence = Residence()

`john.residence`现在包含一个实际的`Residence`实例，而不是`nil`。如果您尝试使用与以前相同的可选链条访问`numberOfRooms`，它现在将返回一个`Int?`包含默认`numberOfRooms`值为1：

1. if let roomCount = john.residence?.numberOfRooms {
2. ​    print("John's residence has \(roomCount) room(s).")
3. } else {
4. ​    print("Unable to retrieve the number of rooms.")
5. }
6. // Prints "John's residence has 1 room(s)."

## 定义可选链的模型类

您可以使用可选链来调用多个级别深的属性、方法和下标。这使您能够深入了解相互关联的复杂模型中的子属性，并检查是否可以访问这些子属性的属性、方法和下标。

下面的代码片段定义了四个模型类，用于后续几个示例，包括多级可选链的示例。这些类通过添加`Room`和`Address`类以及相关的属性、方法和下标来扩展上面的`Person``Residence`模式。

`Person`类的定义与以前相同：

1. class Person {
2. ​    var residence: Residence?
3. }

`Residence`舱比以前更复杂。这一次，`Residence`类定义了一个名为`rooms`的变量属性，该属性使用`[Room]`类型的空数组初始化：

1. class Residence {
2. ​    var rooms: [Room] = []
3. ​    var numberOfRooms: Int {
4. ​        return rooms.count
5. ​    }
6. ​    subscript(i: Int) -> Room {
7. ​        get {
8. ​            return rooms[i]
9. ​        }
10. ​        set {
11. ​            rooms[i] = newValue
12. ​        }
13. ​    }
14. ​    func printNumberOfRooms() {
15. ​        print("The number of rooms is \(numberOfRooms)")
16. ​    }
17. ​    var address: Address?
18. }

由于此版本的`Residence`存储了一个`Room`实例数组，因此其`numberOfRooms`属性作为计算属性实现，而不是存储属性。computednumberOfRooms属性只需从`rooms`数组返回`count`属性的值。

作为访问其`rooms`数组的快捷方式，此版本的`Residence`提供了一个读写下标，该下标可根据`rooms`数组中请求的索引访问房间。

这个版本的`Residence`还提供了一种名为`printNumberOfRooms`的方法，它只需打印住宅中的房间数量。

Finally, `Residence` defines an optional property called `address`, with a type of `Address?`. The `Address` class type for this property is defined below.

用于`rooms`数组的`Room`类是一个简单的类，有一个名为`name`的属性，以及将该属性设置为合适房间名称的初始化器：

1. class Room {
2. ​    let name: String
3. ​    init(name: String) { self.name = name }
4. }

这个模型中的最后一个类称为`Address`。该类有三个typeString`String?`的可选属性。前两个属性，`buildingName`和`buildingNumber`，是将特定建筑物识别为地址一部分的替代方法。第三种财产，`street`，用于为该地址命名街道：

1. class Address {
2. ​    var buildingName: String?
3. ​    var buildingNumber: String?
4. ​    var street: String?
5. ​    func buildingIdentifier() -> String? {
6. ​        if let buildingNumber = buildingNumber, let street = street {
7. ​            return "\(buildingNumber) \(street)"
8. ​        } else if buildingName != nil {
9. ​            return buildingName
10. ​        } else {
11. ​            return nil
12. ​        }
13. ​    }
14. }

The `Address` class also provides a method called `buildingIdentifier()`, which has a return type of `String?`. This method checks the properties of the address and returns `buildingName` if it has a value, or `buildingNumber` concatenated with `street` if both have values, or `nil` otherwise.

## 通过可选链访问属性

正如[可选链作为强制打开包装的替代方案](https://docs.swift.org/swift-book/LanguageGuide/OptionalChaining.html#ID246)所示，您可以使用可选链访问可选值上的属性，并检查该属性访问是否成功。

使用上面定义的类创建一个新的`Person`实例，并尝试像以前一样访问其`numberOfRooms`属性：

1. let john = Person()
2. if let roomCount = john.residence?.numberOfRooms {
3. ​    print("John's residence has \(roomCount) room(s).")
4. } else {
5. ​    print("Unable to retrieve the number of rooms.")
6. }
7. // Prints "Unable to retrieve the number of rooms."

由于`john.residence`为`nil`，这个可选的链式调用与以前一样失败。

您还可以尝试通过可选链设置属性的值：

1. let someAddress = Address()
2. someAddress.buildingNumber = "29"
3. someAddress.street = "Acacia Road"
4. john.residence?.address = someAddress

在本例中，设置`john.residence``address`属性的尝试将失败，因为`john.residence`目前为`nil`。

该赋值是可选链的一部分，这意味着没有计算`=`运算符右侧的代码。在上一个示例中，不容易看到`someAddress`从未被评估过，因为访问常量没有任何副作用。以下列表执行相同的分配，但它使用函数来创建地址。该函数在返回值之前打印“函数已调用”，该值允许您查看是否计算了`=`运算符的右侧。

1. func createAddress() -> Address {
2. ​    print("Function was called.")
3. 
4. ​    let someAddress = Address()
5. ​    someAddress.buildingNumber = "29"
6. ​    someAddress.street = "Acacia Road"
7. 
8. ​    return someAddress
9. }
10. john.residence?.address = createAddress()

您可以判断没有调用`createAddress()`函数，因为没有打印任何东西。

## 通过可选链调用方法

您可以使用可选链调用可选值上的方法，并检查该方法调用是否成功。即使该方法没有定义返回值，您也可以这样做。

`Residence`类上的`printNumberOfRooms()`方法打印`numberOfRooms`当前值。以下是方法的外观：

1. func printNumberOfRooms() {
2. ​    print("The number of rooms is \(numberOfRooms)")
3. }

此方法没有指定返回类型。然而，没有返回类型的函数和方法具有隐式返回类型为`Void`，如《[没有返回值的函数》](https://docs.swift.org/swift-book/LanguageGuide/Functions.html#ID163)中所述。这意味着它们返回一个值`()`或一个空元组。

If you call this method on an optional value with optional chaining, the method’s return type will be `Void?`, not `Void`, because return values are always of an optional type when called through optional chaining. This enables you to use an `if` statement to check whether it was possible to call the `printNumberOfRooms()` method, even though the method doesn’t itself define a return value. Compare the return value from the `printNumberOfRooms` call against `nil` to see if the method call was successful:

1. if john.residence?.printNumberOfRooms() != nil {
2. ​    print("It was possible to print the number of rooms.")
3. } else {
4. ​    print("It was not possible to print the number of rooms.")
5. }
6. // Prints "It was not possible to print the number of rooms."

如果您尝试通过可选链设置属性，也是如此。上面[通过可选链访问属性](https://docs.swift.org/swift-book/LanguageGuide/OptionalChaining.html#ID248)中的示例试图为`john.residence`设置`address`值，即使`residence`属性为`nil`。任何通过可选链设置属性的尝试都会返回`Void?`类型的值，这使您能够与`nil`进行比较，看看属性是否已成功设置：

1. if (john.residence?.address = someAddress) != nil {
2. ​    print("It was possible to set the address.")
3. } else {
4. ​    print("It was not possible to set the address.")
5. }
6. // Prints "It was not possible to set the address."

## 通过可选链条访问下标

您可以使用可选链尝试从可选值的下标中检索和设置值，并检查该下标调用是否成功。

注意

当您通过可选链访问可选值的下标时，您将问号放在下标括号*之前*，而不是之后。可选的链式问号总是紧随其后于表达式的可选部分之后。

下面的示例试图使用`Residence`类上定义的下标检索`john.residence`属性的`rooms`数组中第一个房间的名称。由于`john.residence`目前为`nil`，下标调用失败：

1. if let firstRoomName = john.residence?[0].name {
2. ​    print("The first room name is \(firstRoomName).")
3. } else {
4. ​    print("Unable to retrieve the first room name.")
5. }
6. // Prints "Unable to retrieve the first room name."

此下标调用中的可选链问号立即放在`john.residence`之后的下标括号之前，因为`john.residence`是尝试可选链的可选值。

同样，您可以尝试通过带有可选链的下标设置新值：

1. john.residence?[0] = Room(name: "Bathroom")

此下标设置尝试也失败，因为`residence`目前为`nil`。

如果您创建并向`john.residence`分配实际的`Residence`实例，其`rooms`数组中有一个或多个`Room`实例，您可以使用`Residence`下标通过可选链访问`rooms`数组中的实际项目：

1. let johnsHouse = Residence()
2. johnsHouse.rooms.append(Room(name: "Living Room"))
3. johnsHouse.rooms.append(Room(name: "Kitchen"))
4. john.residence = johnsHouse
5. 
6. if let firstRoomName = john.residence?[0].name {
7. ​    print("The first room name is \(firstRoomName).")
8. } else {
9. ​    print("Unable to retrieve the first room name.")
10. }
11. // Prints "The first room name is Living Room."

### 访问可选类型的下标

如果下标返回可选类型的值（例如Swift'sDictionary类型的键下标），请在下标的闭括号*后*放置一个问号，以链式链接到其可选返回值：

1. var testScores = ["Dave": [86, 82, 84], "Bev": [79, 94, 81]]
2. testScores["Dave"]?[0] = 91
3. testScores["Bev"]?[0] += 1
4. testScores["Brian"]?[0] = 72
5. // the "Dave" array is now [91, 82, 84] and the "Bev" array is now [80, 94, 81]

上面的示例定义了一个名为`testScores`字典，其中包含两个键值对，将`String`键映射到`Int`值数组。该示例使用可选链将`"Dave"`数组中的第一个项目设置为`91`；将`"Bev"`数组中的第一个项目增加`1`；并尝试将数组中的第一个项目设置为`"Brian"`的键。前两个调用成功了，因为`testScores`字典包含`"Dave"`和`"Bev"`的键。第三次调用失败，因为`testScores`字典不包含`"Brian"`的密钥。

## 连接多个级别的链条

您可以将多个级别的可选链链接在一起，以深入了解模型中更深处的属性、方法和下标。然而，多个级别的可选链不会为返回的值添加更多级别的可选性。

换句话说：

- 如果您试图检索的类型不是可选的，它将因可选的链而成为可选的。
- 如果您试图检索的类型*已经*是可选的，它不会因为链而*变得更加*可选。

因此：

- 如果您尝试通过可选链检索`Int`值，则为`Int?`无论使用多少级别的链条，总是会返回。
- 同样，如果您尝试检索`Int?`通过可选链获得价值，一个`Int?`无论使用多少级别的链条，总是会返回。

下面的示例试图访问`john``address`属性的`street`财产。这里*有两个*级别的可选链条，用于链穿`residence`和`address`属性，两者都是可选类型：

1. if let johnsStreet = john.residence?.address?.street {
2. ​    print("John's street name is \(johnsStreet).")
3. } else {
4. ​    print("Unable to retrieve the address.")
5. }
6. // Prints "Unable to retrieve the address."

`john.residence`的值目前包含一个有效的`Residence`实例。然而，`john.residence.address`的价值目前为`nil`。因此，给`john.residence?.address?.street`的电话失败了。

请注意，在上面的示例中，您正在尝试检索`street`属性的值。此属性的类型是`String?`。因此，`john.residence?.address?.street`的返回值也是`String?`，尽管除了属性的基础可选类型外，还应用了两个级别的可选链。

如果您将实际`Address`实例设置为`john.residence.address`的值，并为地址的`street`属性设置实际值，您可以通过多级可选链访问`street`属性的值：

1. let johnsAddress = Address()
2. johnsAddress.buildingName = "The Larches"
3. johnsAddress.street = "Laurel Street"
4. john.residence?.address = johnsAddress
5. 
6. if let johnsStreet = john.residence?.address?.street {
7. ​    print("John's street name is \(johnsStreet).")
8. } else {
9. ​    print("Unable to retrieve the address.")
10. }
11. // Prints "John's street name is Laurel Street."

在本例中，设置`john.residence``address`属性的尝试将成功，因为`john.residence`的值目前包含一个有效的`Residence`实例。

## 具有可选返回值的方法链

前面的示例展示了如何通过可选链检索可选类型属性的值。您还可以使用可选链调用返回可选类型值的方法，并在需要时链上该方法的返回值。

The example below calls the `Address` class’s `buildingIdentifier()` method through optional chaining. This method returns a value of type `String?`. As described above, the ultimate return type of this method call after optional chaining is also `String?`:

1. if let buildingIdentifier = john.residence?.address?.buildingIdentifier() {
2. ​    print("John's building identifier is \(buildingIdentifier).")
3. }
4. // Prints "John's building identifier is The Larches."

如果您想对此方法的返回值执行进一步的可选链式，请在方法的括号*后*放置可选链问号：

1. if let beginsWithThe =
2. ​    john.residence?.address?.buildingIdentifier()?.hasPrefix("The") {
3. ​    if beginsWithThe {
4. ​        print("John's building identifier begins with \"The\".")
5. ​    } else {
6. ​        print("John's building identifier doesn't begin with \"The\".")
7. ​    }
8. }
9. // Prints "John's building identifier begins with "The"."

注意

In the example above, you place the optional chaining question mark *after* the parentheses, because the optional value you are chaining on is the `buildingIdentifier()` method’s return value, and not the `buildingIdentifier()` method itself.