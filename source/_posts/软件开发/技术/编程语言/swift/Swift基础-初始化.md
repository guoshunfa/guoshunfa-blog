---
title: Swift基础 初始化
tags:
- swift
- 基础
categories:
- 技术
date: 2022-07-01 12:01:01
thumbnail:
---

翻译自：https://docs.swift.org/swift-book/LanguageGuide/Initialization.html

*初始化*是准备类、结构或枚举实例以供使用的过程。此过程涉及为该实例上的每个存储属性设置初始值，并在新实例准备使用之前执行所需的任何其他设置或初始化。

您通过定义*初始化器来*实现此初始化过程，*初始化器*就像可以调用以创建特定类型的新实例的特殊方法。与Objective-C初始化器不同，Swift初始化器不会返回值。他们的主要作用是确保一种类型的新实例在首次使用之前被正确初始化。

类类型的实例还可以实现*去初始化器*，该初始化器在该类的实例被释放之前执行任何自定义清理。有关去初始化器的更多信息，请参阅[取消初始化](https://docs.swift.org/swift-book/LanguageGuide/Deinitialization.html)。

## 为存储的属性设置初始值

类和结构*必须在*创建该类或结构的实例时将其所有存储属性设置为适当的初始值。存储的属性不能处于不确定状态。

您可以在初始化器中为存储的属性设置初始值，也可以分配默认属性值作为属性定义的一部分。以下各节将介绍这些操作。

注意

当您为存储属性分配默认值或在初始化器中设置其初始值时，该属性的值将直接设置，而无需调用任何属性观察器。

### 初始化器

调用*初始化器*来创建特定类型的新实例。在最简单的形式中，初始化器就像一个没有参数的实例方法，使用`init`关键字编写：

1. init() {
2. ​    // perform some initialization here
3. }

以下示例定义了一种名为`Fahrenheit`的新结构，以存储华氏度中表达的温度。`Fahrenheit`结构有一个存储属性，`temperature`，属于`Double`类型：

1. struct Fahrenheit {
2. ​    var temperature: Double
3. ​    init() {
4. ​        temperature = 32.0
5. ​    }
6. }
7. var f = Fahrenheit()
8. print("The default temperature is \(f.temperature)° Fahrenheit")
9. // Prints "The default temperature is 32.0° Fahrenheit"

该结构定义了一个没有参数的单个初始化器`init`，该初始化值为`32.0`（水的冰点（华氏度））的存储温度。

### 默认属性值

您可以从初始化器中设置存储属性的初始值，如上所示。或者，指定一个*默认属性值*作为属性声明的一部分。您可以在定义属性时为属性分配初始值来指定默认属性值。

注意

如果属性总是具有相同的初始值，请提供默认值，而不是在初始化器中设置值。最终结果相同，但默认值将属性的初始化与其声明更紧密地联系起来。它使初始化器更短、更清晰，并使您能够从其默认值推断属性的类型。默认值还使您更容易利用默认初始化器和初始化器继承，如本章后面所述。

You can write the `Fahrenheit` structure from above in a simpler form by providing a default value for its `temperature` property at the point that the property is declared:

1. struct Fahrenheit {
2. ​    var temperature = 32.0
3. }

## 自定义初始化

您可以使用输入参数和可选属性类型自定义初始化过程，也可以在初始化期间分配常量属性，如以下部分所述。

### 初始化参数

您可以提供*初始化参数*作为初始化器定义的一部分，以定义自定义初始化过程的值的类型和名称。初始化参数具有与函数和方法参数相同的功能和语法。

以下示例定义了一个名为`Celsius`结构，该结构以摄氏度表示的温度。`Celsius`结构实现了两个自定义初始化器，称为`init(fromFahrenheit:)`和`init(fromKelvin:)`它们使用不同温度尺度的值初始化结构的新实例：

1. struct Celsius {
2. ​    var temperatureInCelsius: Double
3. ​    init(fromFahrenheit fahrenheit: Double) {
4. ​        temperatureInCelsius = (fahrenheit - 32.0) / 1.8
5. ​    }
6. ​    init(fromKelvin kelvin: Double) {
7. ​        temperatureInCelsius = kelvin - 273.15
8. ​    }
9. }
10. let boilingPointOfWater = Celsius(fromFahrenheit: 212.0)
11. // boilingPointOfWater.temperatureInCelsius is 100.0
12. let freezingPointOfWater = Celsius(fromKelvin: 273.15)
13. // freezingPointOfWater.temperatureInCelsius is 0.0

第一个初始化器有一个初始化参数，参数标签为`fromFahrenheit`，参数名称为`fahrenheit`。第二个初始化器有一个初始化参数，参数标签为 `fromKelvin`，参数名称为 ofkelvin。两个初始化器都将单个参数转换为相应的摄氏度值，并将该值存储在名为`temperatureInCelsius`的属性中。

### 参数名称和参数标签

与函数和方法参数一样，初始化参数既可以有一个参数名称，供初始化器正文使用，也可以有一个参数标签，供调用初始化器时使用。

然而，初始化器在括号前没有像函数和方法那样识别函数名称。因此，初始化器参数的名称和类型在确定应该调用哪个初始化器方面发挥着特别重要的作用。因此，如果您不提供初始化器中的*每个*参数，Swift会为自动参数标签。

以下示例定义了一个名为`Color`的结构，具有三个常量属性，称为`red`、`green`和`blue`。这些属性存储的值在`0.0`到`1.0`之间，以指示颜色中的红色、绿色和蓝色的数量。

`Color`为其红色、绿色和蓝色组件提供三个适当命名的`Double`型参数的初始化器。`Color`还提供了第二个带有单个`white`参数的初始化器，该参数用于为所有三个颜色组件提供相同的值。

1. struct Color {
2. ​    let red, green, blue: Double
3. ​    init(red: Double, green: Double, blue: Double) {
4. ​        self.red   = red
5. ​        self.green = green
6. ​        self.blue  = blue
7. ​    }
8. ​    init(white: Double) {
9. ​        red   = white
10. ​        green = white
11. ​        blue  = white
12. ​    }
13. }

两个初始化器都可用于创建新的`Color`实例，方法是为每个初始化器参数提供命名值：

1. let magenta = Color(red: 1.0, green: 0.0, blue: 1.0)
2. let halfGray = Color(white: 0.5)

请注意，如果不使用参数标签，就无法调用这些初始化器。如果定义了参数标签，则必须始终在初始化器中使用参数标签，省略它们是一个编译时错误：

1. let veryGreen = Color(0.0, 1.0, 0.0)
2. // this reports a compile-time error - argument labels are required

### 没有参数标签的初始化参数

如果您不想为初始化参数使用参数标签，请为该参数写下划线（`_`）而不是显式参数标签，以覆盖默认行为。

以下是上面[初始化参数](https://docs.swift.org/swift-book/LanguageGuide/Initialization.html#ID208)中摄氏度示例的扩展版本，以及一个额外的初始化器，用于从已经在摄氏度范围内的`Double`值创建新的`Celsius`实例：

1. struct Celsius {
2. ​    var temperatureInCelsius: Double
3. ​    init(fromFahrenheit fahrenheit: Double) {
4. ​        temperatureInCelsius = (fahrenheit - 32.0) / 1.8
5. ​    }
6. ​    init(fromKelvin kelvin: Double) {
7. ​        temperatureInCelsius = kelvin - 273.15
8. ​    }
9. ​    init(_ celsius: Double) {
10. ​        temperatureInCelsius = celsius
11. ​    }
12. }
13. let bodyTemperature = Celsius(37.0)
14. // bodyTemperature.temperatureInCelsius is 37.0

The initializer call `Celsius(37.0)` is clear in its intent without the need for an argument label. It’s therefore appropriate to write this initializer as `init(_ celsius: Double)` so that it can be called by providing an unnamed `Double` value.

### 可选属性类型

如果您的自定义类型有一个逻辑上允许“无值”的存储属性——可能是因为在初始化期间无法设置其值，或者因为它允许在稍后某个时候具有“无值”——请使用*可选*类型声明该属性。可选类型的属性会自动初始化，值为`nil`，这表明该属性在初始化期间故意具有“尚无值”。

以下示例定义了一个名为`SurveyQuestion`类，其可选`String`属性称为`response`：

1. class SurveyQuestion {
2. ​    var text: String
3. ​    var response: String?
4. ​    init(text: String) {
5. ​        self.text = text
6. ​    }
7. ​    func ask() {
8. ​        print(text)
9. ​    }
10. }
11. let cheeseQuestion = SurveyQuestion(text: "Do you like cheese?")
12. cheeseQuestion.ask()
13. // Prints "Do you like cheese?"
14. cheeseQuestion.response = "Yes, I do like cheese."

The response to a survey question can’t be known until it’s asked, and so the `response`property is declared with a type of `String?`, or “optional `String`”. It’s automatically assigned a default value of `nil`, meaning “no string yet”, when a new instance of `SurveyQuestion` is initialized.

### 在初始化期间分配常量属性

您可以在初始化期间的任何时候为常量属性分配值，只要在初始化完成时将其设置为确定值。一旦一个常量属性被分配了一个值，它就无法进一步修改。

注意

对于类实例，常量属性只能由引入常量属性的类在初始化期间进行修改。它不能被子类修改。

您可以从上面修改`SurveyQuestion`示例，为问题的`text`属性使用常量属性而不是变量属性，以表明一旦创建了`SurveyQuestion`实例，问题不会改变。即使`text`属性现在是常量，它仍然可以在类的初始化器中设置：

1. class SurveyQuestion {
2. ​    let text: String
3. ​    var response: String?
4. ​    init(text: String) {
5. ​        self.text = text
6. ​    }
7. ​    func ask() {
8. ​        print(text)
9. ​    }
10. }
11. let beetsQuestion = SurveyQuestion(text: "How about beets?")
12. beetsQuestion.ask()
13. // Prints "How about beets?"
14. beetsQuestion.response = "I also like beets. (But not with cheese.)"

## 默认初始化器

Swift为任何为其所有属性提供默认值的结构或类提供*默认初始化器*，并且本身不提供至少一个初始化器。默认初始化器只需创建一个新实例，其所有属性都设置为默认值。

此示例定义了一个名为`ShoppingListItem`的类，该类封装了购物清单中商品的名称、数量和购买状态：

1. class ShoppingListItem {
2. ​    var name: String?
3. ​    var quantity = 1
4. ​    var purchased = false
5. }
6. var item = ShoppingListItem()

由于`ShoppingListItem`类的所有属性都有默认值，并且因为它是一个没有超类的基类，因此`ShoppingListItem`会自动获得默认初始化器实现，该实现创建一个新实例，其所有属性都设置为默认值。（`name`属性是一个可选的`String`属性，因此它会自动接收默认值为`nil`，即使该值没有写入代码中。）上面的示例使用`ShoppingListItem`类的默认初始化器创建具有初始化器语法的类的新实例，写为`ShoppingListItem()`，并将此新实例分配给名为`item`的变量。

### 结构类型的成员初始化器

如果结构类型没有定义自己的任何自定义初始化器，它们会自动收到*成员*初始化器。与默认初始化器不同，该结构即使存储了没有默认值的属性，也会接收成员初始化器。

成员初始化器是初始化新结构实例成员属性的简写方法。新实例属性的初始值可以按名称传递给成员初始化器。

下面的示例定义了一个名为`Size`的结构，有两个属性称为`width`和`height`。通过分配`0.0`的默认值，可以推断出这两个属性都是`Double`类型的。

`Size`结构会自动接收`init(width:height:)`成员初始化器，您可以使用该初始化新的`Size`实例：

1. struct Size {
2. ​    var width = 0.0, height = 0.0
3. }
4. let twoByTwo = Size(width: 2.0, height: 2.0)

当您调用成员初始化器时，您可以省略任何具有默认值的属性的值。在上面的示例中，`Size`结构的`height`和`width`属性都有默认值。您可以省略任何一个属性或两个属性，初始化器对省略的任何内容都使用默认值，例如：

1. let zeroByTwo = Size(height: 2.0)
2. print(zeroByTwo.width, zeroByTwo.height)
3. // Prints "0.0 2.0"
4. 
5. let zeroByZero = Size()
6. print(zeroByZero.width, zeroByZero.height)
7. // Prints "0.0 0.0"

## 值类型的初始化委托

初始化器可以调用其他初始化器来执行实例的部分初始化。这个过程被称为*初始化器委托*，避免了跨多个初始化器复制代码。

初始化器委托如何工作以及允许哪种形式的委托的规则对于值类型和类类型是不同的。值类型（结构和枚举）不支持继承，因此它们的初始化器委托过程相对简单，因为它们只能委托给自己提供的另一个初始化器。然而，类可以从其他类继承，如[继承](https://docs.swift.org/swift-book/LanguageGuide/Inheritance.html)中所述。这意味着类有额外的责任来确保在初始化期间为其继承的所有存储属性分配合适的值。这些职责在下面的[类继承和初始化](https://docs.swift.org/swift-book/LanguageGuide/Initialization.html#ID216)中描述。

对于值类型，在编写自己的自定义初始化器时，您可以使用`self.init`引用来自相同值类型的其他初始化器。您只能从初始化器中调用`self.init`。

请注意，如果您为值类型定义自定义初始化器，您将无法再访问该类型的默认初始化器（或成员初始化器，如果是结构）。这种约束防止了使用自动初始化器之一的人意外绕过了更复杂的初始化器中提供的额外基本设置的情况。

注意

如果您希望自定义值类型可以使用默认初始化器和成员初始化器初始化，也可以使用您自己的自定义初始化器初始化，请在扩展中编写自定义初始化器，而不是作为值类型原始实现的一部分。有关更多信息，请参阅[扩展](https://docs.swift.org/swift-book/LanguageGuide/Extensions.html)。

以下示例定义了一个自定义`Rect`结构来表示几何矩形。该示例需要两个名为`Size`和`Point`的支持结构，这两个结构都为其所有属性提供`0.0`的默认值：

1. struct Size {
2. ​    var width = 0.0, height = 0.0
3. }
4. struct Point {
5. ​    var x = 0.0, y = 0.0
6. }

您可以通过以下三种方式之一初始化`Rect`结构——使用其默认的零初始化`origin`和`size`属性值，提供特定的原点和大小，或提供特定的中心点和大小。这些初始化选项由三个自定义初始化器表示，它们是`Rect`结构定义的一部分：

1. struct Rect {
2. ​    var origin = Point()
3. ​    var size = Size()
4. ​    init() {}
5. ​    init(origin: Point, size: Size) {
6. ​        self.origin = origin
7. ​        self.size = size
8. ​    }
9. ​    init(center: Point, size: Size) {
10. ​        let originX = center.x - (size.width / 2)
11. ​        let originY = center.y - (size.height / 2)
12. ​        self.init(origin: Point(x: originX, y: originY), size: size)
13. ​    }
14. }

第一个`Rect`初始化器`init()`在功能上与结构如果没有自己的自定义初始化器时会收到的默认初始化器相同。此初始化器有一个空正文，由一对空的花括号`{}`表示。调用此初始化器返回aRect实例，其`origin`和`size`属性都从其属性定义中初始化为`Point(x:0.0,y:0.0)`和`Size(width:0.0,height:0.0)`的默认值：

1. let basicRect = Rect()
2. // basicRect's origin is (0.0, 0.0) and its size is (0.0, 0.0)

第二个`Rect`初始化器`init(origin:size:)`在功能上与结构如果没有自己的自定义初始化器时会收到的成员初始化器相同。此初始化器只需将`origin`和`size`参数值分配给适当的存储属性：

1. let originRect = Rect(origin: Point(x: 2.0, y: 2.0),
2. ​                      size: Size(width: 5.0, height: 5.0))
3. // originRect's origin is (2.0, 2.0) and its size is (5.0, 5.0)

第三个`Rect`初始化器`init(center:size:)`稍微复杂一些。它首先根据`center`和`size`值计算适当的原点。然后，它调用（或*委托*）`init(origin:size:)`初始化器，该初始化器将新的原点和大小值存储在适当的属性中：

1. let centerRect = Rect(center: Point(x: 4.0, y: 4.0),
2. ​                      size: Size(width: 3.0, height: 3.0))
3. // centerRect's origin is (2.5, 2.5) and its size is (3.0, 3.0)

`init(center:size:)`初始化器可以将`origin`值和`size`的新值分配给适当的属性本身。然而，`init(center:size:)`初始化器更方便（意图更清晰），可以利用已经提供该功能的现有初始化器。

注意

有关在不定义`init()`和`init(origin:size:)`初始化器的情况下编写此示例的替代方法，请参阅[扩展](https://docs.swift.org/swift-book/LanguageGuide/Extensions.html)。

## 类继承和初始化

类的所有存储属性，包括该类从其超类继承的任何属性，在初始化期间*必须*分配初始值。

Swift为类类型定义了两种初始化器，以帮助确保所有存储的属性都收到初始值。这些被称为指定的初始化器和方便初始化器。

### 指定初始化器和便利初始化器

*指定初始化器*是类的主要初始化器。指定的初始化器完全初始化该类引入的所有属性，并调用适当的超类初始化器来继续超类链上的初始化过程。

类的指定初始化器往往很少，并且一个类只有一个初始化器很常见。指定的初始化器是进行初始化的“漏斗”点，初始化过程通过这些点继续超类链。

每个类必须至少有一个指定的初始化器。在某些情况下，通过从超类继承一个或多个指定初始化器来满足这一要求，如下文的[自动初始化器继承](https://docs.swift.org/swift-book/LanguageGuide/Initialization.html#ID222)所述。

*方便初始化器*是次要*的*，支持类的初始化器。您可以定义一个方便初始化器，以调用与方便初始化器同一类的指定初始化器，其中指定初始化器的一些参数设置为默认值。您还可以定义一个方便的初始化器，为特定的用例或输入值类型创建该类的实例。

如果您的班级不需要方便的初始化器，则不必提供方便的初始化器。每当通用初始化模式的快捷方式将节省时间或使类的初始化更清晰时，请创建方便的初始化器。

### 指定和方便初始化器的语法

类的指定初始化器的编写方式与值类型的简单初始化器相同：

1. init(parameters) {
2. ​    statements
3. }

方便初始化器以相同的样式编写，但`convenience`修饰符放在`init`关键字之前，由空格分隔：

1. convenience init(parameters) {
2. ​    statements
3. }

### 类类型的初始化委托

为了简化指定初始化器和方便初始化器之间的关系，Swift对初始化器之间的委托调用适用以下三项规则：

- **规则1**

  指定的初始化器必须从其直接超类调用指定的初始化器。

- **规则2**

  方便初始化器必须调用*同一*类的另一个初始化器。

- **规则3**

  方便初始化器最终必须调用指定的初始化器。

记住这一点的简单方法是：

- 指定的初始化器必须始终委托。
- 方便初始化器必须始终委托。

这些规则如下图所示：

![../_images/initializerDelegation01_2x.png](https://file.pandacode.cn/blog/202204051616580.png)

在这里，超类有一个指定的初始化器和两个方便初始化器。一个方便初始化器调用另一个方便初始化器，而方便初始化器又调用单个指定的初始化器。这符合上面的规则2和3。超级班本身没有进一步的超级班级，因此规则1不适用。

本图中的子类有两个指定的初始化器和一个方便初始化器。方便初始化器必须调用两个指定初始化器中的一个，因为它只能调用同一类的另一个初始化器。这符合上面的规则2和3。两个指定的初始化器都必须从超类调用单个指定初始化器，以满足上面的规则1。

注意

这些规则不会影响类用户如何*创建*每个类的实例。上图中的任何初始化器都可用于创建它们所属类的完全初始化实例。这些规则只会影响您编写类初始化器实现的方式。

下图显示了四个类的更复杂的类层次结构。它说明了此层次结构中的指定初始化器如何充当类初始化的“漏斗”点，简化了链中类之间的相互关系：

![../_images/initializerDelegation02_2x.png](https://file.pandacode.cn/blog/202204051616344.png)

### 两阶段初始化

Swift 中的类初始化是一个两阶段的过程。在第一阶段，引入它的类为每个存储的属性分配一个初始值。一旦确定了每个存储属性的初始状态，第二阶段就开始了，每个类都有机会在新实例被认为可供使用之前进一步自定义其存储属性。

使用两阶段初始化过程使初始化安全，同时仍然为类层次结构中的每个类提供完全的灵活性。两阶段初始化可以防止属性值在初始化之前被访问，并防止属性值意外地被另一个初始化器设置为不同的值。

注意

Swift的两阶段初始化过程类似于Objective-C中的初始化。主要区别在于，在第1阶段，Objective-C为每个属性分配零或零值（如`0`或`nil`）。Swift的初始化流程更加灵活，因为它允许您设置自定义初始值，并可以处理`0`或`nil`不是有效默认值的类型。

Swift的编译器执行了四项有用的安全检查，以确保两阶段初始化没有错误地完成：

- **安全检查1**

  指定的初始化器必须确保其类引入的所有属性在委托给超类初始化器之前都已初始化。

如上所述，只有当对象所有存储属性的初始状态已知时，对象的内存才会被视为完全初始化。为了满足此规则，指定的初始化器必须确保其所有自己的属性在启动链条之前都已初始化。

- **安全检查2**

  在将值分配给继承的属性之前，指定的初始化器必须委托给超类初始化器。如果没有，指定初始化器分配的新值将被超类覆盖，作为其自身初始化的一部分。

- **安全检查3**

  在为*任何*属性（包括同一类定义的属性）分配值之前，方便初始化器必须委托给另一个初始化器。如果没有，便利初始化器分配的新值将被其自身类的指定初始化器覆盖。

- **安全检查4**

  在初始化的第一阶段完成之前，初始化器无法调用任何实例方法，读取任何实例属性的值，或将`self`称为值。

在第一阶段结束之前，类实例不会完全有效。只有在已知类实例在第一阶段结束时有效时，才能访问属性，并且只能调用方法。

根据上述四项安全检查，以下是两阶段初始化是如何运作的：

**第一阶段**

- 类调用指定或方便的初始化器。
- 为该类的新实例分配内存。内存尚未初始化。
- 该类的指定初始化器确认该类引入的所有存储属性都有一个值。这些存储属性的内存现已初始化。
- 指定的初始化器交给超类初始化器，以为自己的存储属性执行相同的任务。
- 这继续沿着类继承链，直到到达链的顶部。
- 一旦到达链的顶部，并且链中的最后一个类确保其所有存储属性都有一个值，实例的内存将被视为完全初始化，阶段1完成。

**第二阶段**

- 从链的顶部向下工作，链中的每个指定的初始化器都可以选择进一步自定义实例。初始化器现在可以访问`self`，并可以修改其属性，调用其实例方法等。
- 最后，链中的任何方便初始化器都可以选择自定义实例并使用`self`。

以下是第1阶段如何查找假设子类和超类的初始化调用：

![../_images/twoPhaseInitialization01_2x.png](https://docs.swift.org/swift-book/_images/twoPhaseInitialization01_2x.png)

在本例中，初始化以调用子类上的方便初始化器开始。此方便初始化器尚无法修改任何属性。它委托给来自同一类的指定初始化器。

根据安全检查1，指定的初始化器确保子类的所有属性都有一个值。然后，它在其超类上调用指定的初始化器，以继续沿着链进行初始化。

超类的指定初始化器确保所有超类属性都有一个值。没有更多的超级类需要初始化，因此不需要进一步的授权。

一旦超类的所有属性都具有初始值，其内存就会被视为完全初始化，第1阶段就完成了。

以下是第2阶段对相同初始化调用的查找方式：

![../_images/twoPhaseInitialization02_2x.png](https://docs.swift.org/swift-book/_images/twoPhaseInitialization02_2x.png)

超类的指定初始化器现在有机会进一步自定义实例（尽管它不必这样做）。

一旦超类的指定初始化器完成，子类的指定初始化器可以执行额外的自定义（尽管同样，它不必这样做）。

最后，一旦子类的指定初始化器完成，最初调用的方便初始化器可以执行额外的自定义。

### 初始化器继承和重写

与Objective-C中的子类不同，Swift子类默认不会继承其超类初始化器。Swift的方法防止了超类的简单初始化器被更专业的子类继承，并用于创建未完全或正确初始化的子类的新实例。

注意

在某些情况下，超类初始化器*是*继承的，但只有在安全且合适的情况下才会继承。有关更多信息，请参阅下面的[自动初始化器继承](https://docs.swift.org/swift-book/LanguageGuide/Initialization.html#ID222)。

如果您希望自定义子类显示与其超类相同的一个或多个初始化器，您可以在子类中提供这些初始化器的自定义实现。

当您编写与超类*指定*初始化器匹配的子类初始化器时，您实际上是在提供该指定初始化器的重写。因此，您必须在子类的初始化器定义之前编写`override`修饰符。即使您重写自动提供的默认初始化器，也是如此，如[默认初始化器](https://docs.swift.org/swift-book/LanguageGuide/Initialization.html#ID213)所述。

与重写属性、方法或下标一样，`override`修饰符的存在会提示Swift检查超类是否有匹配的指定初始化器要重写，并验证重写初始化器的参数是否已按预期指定。

注意

在覆盖超类指定初始化器时，您总是写入`override`修饰符，即使子类对初始化器的实现是一个方便的初始化器。

相反，如果您编写与超类*便利*初始化器匹配的子类初始化器，则根据上面[类类型初始化器委托](https://docs.swift.org/swift-book/LanguageGuide/Initialization.html#ID219)中描述的规则，您的子类永远不能直接调用该超类方便初始化器。因此，您的子类（严格来说）不提供超类初始化器的重写。因此，在提供超类方便初始化器的匹配实现时，您不会编写`override`修饰符。

下面的示例定义了一个名为`Vehicle`的基类。该基类声明一个名为`numberOfWheels`的存储属性，默认`Int`值为`0`。`numberOfWheels`属性由称为`description`的计算属性用于创建车辆特征的`String`描述：

1. class Vehicle {
2. ​    var numberOfWheels = 0
3. ​    var description: String {
4. ​        return "\(numberOfWheels) wheel(s)"
5. ​    }
6. }

`Vehicle`类为其唯一存储的属性提供默认值，并且本身不提供任何自定义初始化器。因此，它会自动接收默认初始化器，如[默认初始化器](https://docs.swift.org/swift-book/LanguageGuide/Initialization.html#ID213)中所述。默认初始化器（如果可用）始终是类的指定初始化器，可用于创建一个新的`Vehicle`实例，其anumberOfWheels为`0`：

1. let vehicle = Vehicle()
2. print("Vehicle: \(vehicle.description)")
3. // Vehicle: 0 wheel(s)

下一个示例定义了一个名为`Bicycle`的`Vehicle`子类：

1. class Bicycle: Vehicle {
2. ​    override init() {
3. ​        super.init()
4. ​        numberOfWheels = 2
5. ​    }
6. }

`Bicycle`子类定义了一个自定义指定的初始化器`init()`。此指定初始化器与`Bicycle`超类的指定初始化器匹配，因此此初始化器的`Bicycle`版本用`override`修饰符标记。

The `init()` initializer for `Bicycle` starts by calling `super.init()`, which calls the default initializer for the `Bicycle` class’s superclass, `Vehicle`. This ensures that the `numberOfWheels`inherited property is initialized by `Vehicle` before `Bicycle` has the opportunity to modify the property. After calling `super.init()`, the original value of `numberOfWheels` is replaced with a new value of `2`.

如果您创建`Bicycle`实例，您可以调用其继承的`description`计算属性，以查看其`numberOfWheels`属性是如何更新的：

1. let bicycle = Bicycle()
2. print("Bicycle: \(bicycle.description)")
3. // Bicycle: 2 wheel(s)

如果子类初始化器在初始化过程的第2阶段不执行自定义，并且超类具有零参数指定初始化器，则在为子类的所有存储属性分配值后，您可以省略对`super.init()`的调用。

此示例定义了`Vehicle`的另一个子类，称为`Hoverboard`。在其初始化器中，`Hoverboard`类仅设置其`color`属性。此初始化器不是显式调用`super.init()`，而是依赖对其超类初始化器的隐式调用来完成该过程。

1. class Hoverboard: Vehicle {
2. ​    var color: String
3. ​    init(color: String) {
4. ​        self.color = color
5. ​        // super.init() implicitly called here
6. ​    }
7. ​    override var description: String {
8. ​        return "\(super.description) in a beautiful \(color)"
9. ​    }
10. }

`Hoverboard`实例使用`Vehicle`初始化器提供的默认车轮数量。

1. let hoverboard = Hoverboard(color: "silver")
2. print("Hoverboard: \(hoverboard.description)")
3. // Hoverboard: 0 wheel(s) in a beautiful silver

注意

子类可以在初始化期间修改继承的变量属性，但不能修改继承的常量属性。

### 自动初始化器继承

如上所述，默认情况下，子类不会继承其超类初始化器。然而，如果满足某些条件*，*超类初始化器会自动继承。在实践中，这意味着您不需要在许多常见情况下编写初始化器重写，只要安全，就可以毫不费力地继承超类初始化器。

假设您为在子类中引入的任何新属性提供默认值，则适用以下两条规则：

- **规则1**

  如果您的子类没有定义任何指定的初始化器，它会自动继承其所有超类指定初始化器。

- **规则2**

  如果您的子类提供其*所有*超类指定初始化器的实现——要么根据规则1继承它们，要么提供自定义实现作为其定义的一部分——那么它会自动继承所有超类方便初始化器。

即使您的子类添加了进一步的便利初始化器，这些规则也适用。

注意

作为满足规则2的一部分，子类可以实现超类指定的初始化器作为子类方便初始化器。

### 指定和方便的初始化器在操作中

以下示例显示了指定的初始化器、方便初始化器和自动初始化器继承。此示例定义了三个类的层次结构，称为`Food`、`RecipeIngredient`和`ShoppingListItem`，并演示了它们的初始化器如何交互。

层次结构中的基类称为`Food`，这是一个封装食品名称的简单类。`Food`类引入了一个名为`name``String`属性，并为创建`Food`实例提供了两个初始化器：

1. class Food {
2. ​    var name: String
3. ​    init(name: String) {
4. ​        self.name = name
5. ​    }
6. ​    convenience init() {
7. ​        self.init(name: "[Unnamed]")
8. ​    }
9. }

下图显示了`Food`类的初始化链：

![../_images/initializersExample01_2x.png](https://docs.swift.org/swift-book/_images/initializersExample01_2x.png)

类没有默认的按成员初始化器，因此`Food`类提供了一个指定的初始化器，该初始化器接受一个名为`name`参数。此初始化器可用于创建具有特定名称的新`Food`实例：

1. let namedMeat = Food(name: "Bacon")
2. // namedMeat's name is "Bacon"

`Food`类的`init(name:String)`初始化器作为*指定的*初始化器提供，因为它确保新`Food`实例的所有存储属性都完全初始化。`Food`类没有超类，因此`init(name:String)`初始化器不需要调用`super.init()`即可完成其初始化。

`Food`类还提供了一个*方便*的初始化器`init()`，没有参数。Theinit`init()`初始化器通过将`name`值为`[Unnamed]`的`Food`类的`init(name:String)`委托来为新食物提供默认占位符名称：

1. let mysteryMeat = Food()
2. // mysteryMeat's name is "[Unnamed]"

层次结构中的第二类是`Food`的一个子类，称为`RecipeIngredient`。`RecipeIngredient`在烹饪食谱中建模成分。它引入了一个名为`quantity``Int`属性（除了它从`Food`继承的`name`属性外），并定义了用于创建`RecipeIngredient`实例的两个初始化器：

1. class RecipeIngredient: Food {
2. ​    var quantity: Int
3. ​    init(name: String, quantity: Int) {
4. ​        self.quantity = quantity
5. ​        super.init(name: name)
6. ​    }
7. ​    override convenience init(name: String) {
8. ​        self.init(name: name, quantity: 1)
9. ​    }
10. }

The figure below shows the initializer chain for the `RecipeIngredient` class:

![../_images/initializers示例02_2x.png](https://docs.swift.org/swift-book/_images/initializersExample02_2x.png)

`RecipeIngredient`类有一个指定的初始化器`init(name:String,quantity:Int)`可用于填充新`RecipeIngredient`实例的所有属性。此初始化器首先将传递的`quantity`参数分配给`quantity`属性，这是`RecipeIngredient`引入的唯一新属性。完成后，初始化器将委托给`Food`类的`init(name:String)`初始化器。此过程满足上述[两阶段初始化](https://docs.swift.org/swift-book/LanguageGuide/Initialization.html#ID220)的安全检查1。

`RecipeIngredient`还定义了一个方便初始化器`init(name:String)`它仅用于按名称创建`RecipeIngredient`实例。对于没有显式数量创建的任何`RecipeIngredient`实例，此方便初始化器假设数量为`1`。此方便初始化器的定义使`RecipeIngredient`实例创建更快、更方便，并在创建多个单量`RecipeIngredient`实例时避免代码复制。此方便初始化器只需将数量值委托给类的指定初始化器，传递`quantity`为1。

`RecipeIngredient`提供的`init(name:String)`方便初始化器采用与`Food`中*指定的*`init(name:String)`*指定*初始化器相同的参数。由于此方便初始化器从其超类中覆盖指定的初始化器，因此必须用`override`修饰符标记（如[初始化器继承和重写](https://docs.swift.org/swift-book/LanguageGuide/Initialization.html#ID221)中所述）。

尽管`RecipeIngredient`提供了`init(name:String)`初始化器作为方便的初始化器，但`RecipeIngredient`仍然提供了其所有超类指定初始化器的实现。因此，`RecipeIngredient`也会自动继承其所有超类的便利初始化器。

在本例中，`RecipeIngredient`的超类是`Food`，它只有一个名为`init()`方便初始化器。因此，此初始化器由`RecipeIngredient`继承。`init()`的继承版本的功能与`Food`版本完全相同，只是它委托给`init(name:String)`的`RecipeIngredient`版本，而不是`Food`版本。

All three of these initializers can be used to create new `RecipeIngredient` instances:

1. let oneMysteryItem = RecipeIngredient()
2. let oneBacon = RecipeIngredient(name: "Bacon")
3. let sixEggs = RecipeIngredient(name: "Eggs", quantity: 6)

The third and final class in the hierarchy is a subclass of `RecipeIngredient` called `ShoppingListItem`. The `ShoppingListItem` class models a recipe ingredient as it appears in a shopping list.

购物清单中的每件商品都以“未购买”开头。为了表示这一事实，`ShoppingListItem`引入了一个名为`purchased`布尔属性，默认值为关闭。`ShoppingListItem`还添加了一个计算`description`属性，该属性提供了`ShoppingListItem`实例的文本描述：

1. class ShoppingListItem: RecipeIngredient {
2. ​    var purchased = false
3. ​    var description: String {
4. ​        var output = "\(quantity) x \(name)"
5. ​        output += purchased ? " ✔" : " ✘"
6. ​        return output
7. ​    }
8. }

注意

`ShoppingListItem`没有定义初始化器来为`purchased`提供初始值，因为购物清单中的商品（如此处建模）总是从未购买开始。

由于它为其引入的所有属性提供了默认值，并且本身不定义任何初始化器，因此`ShoppingListItem`会自动从其超类继承*所有*指定和方便的初始化器。

下图显示了所有三个类别的整体初始化链：

![../_images/initializers示例03_2x.png](https://docs.swift.org/swift-book/_images/initializersExample03_2x.png)

您可以使用所有三个继承的初始化器来创建新的`ShoppingListItem`实例：

1. var breakfastList = [
2. ​    ShoppingListItem(),
3. ​    ShoppingListItem(name: "Bacon"),
4. ​    ShoppingListItem(name: "Eggs", quantity: 6),
5. ]
6. breakfastList[0].name = "Orange juice"
7. breakfastList[0].purchased = true
8. for item in breakfastList {
9. ​    print(item.description)
10. }
11. // 1 x Orange juice ✔
12. // 1 x Bacon ✘
13. // 6 x Eggs ✘

在这里，一个名为`breakfastList`的新数组是从包含三个新`ShoppingListItem`实例的数组文字创建的。数组的类型推断为`[ShoppingListItem]`数组创建后，数组开头的`ShoppingListItem`名称从`"[Unnamed]"`更改为`"Orangejuice"`并标记为已购买。打印数组中每个项目的描述会显示它们的默认状态已按预期设置。

## 失败的初始化器

定义初始化可能失败的类、结构或枚举有时是有用的。此故障可能由无效的初始化参数值、缺乏所需的外部资源或阻止初始化成功的其他条件触发。

要应对可能失败的初始化条件，请将一个或多个故障初始化器定义为类、结构或枚举定义的一部分。您可以通过在`init`关键字（`init?`）后放置问号来编写一个失败的初始化器。

注意

您无法使用相同的参数类型和名称定义故障和非故障初始化器。

故障初始化器会创建其初始化类型的*可选*值。您可以在可故障初始化器中写入`returnnil`，以指示可以触发初始化失败的点。

注意

严格来说，初始化器不会返回值。相反，他们的作用是确保在初始化结束时完全正确地初始化`self`。虽然您写`returnnil`以触发初始化失败，但您不会使用`return`关键字来指示初始化成功。

例如，为数字类型转换实现了故障初始化器。为了确保数字类型之间的转换准确保持该值，请使用`init(exactly:)`初始化器。如果类型转换无法维护该值，初始化器将失败。

1. let wholeNumber: Double = 12345.0
2. let pi = 3.14159
3. 
4. if let valueMaintained = Int(exactly: wholeNumber) {
5. ​    print("\(wholeNumber) conversion to Int maintains value of \(valueMaintained)")
6. }
7. // Prints "12345.0 conversion to Int maintains value of 12345"
8. 
9. let valueChanged = Int(exactly: pi)
10. // valueChanged is of type Int?, not Int
11. 
12. if valueChanged == nil {
13. ​    print("\(pi) conversion to Int doesn't maintain value")
14. }
15. // Prints "3.14159 conversion to Int doesn't maintain value"

以下示例定义了一个名为`Animal`的结构，其常量`String`属性称为`species`。`Animal`结构还定义了一个具有称为`species`的单个参数的故障初始化器。此初始化器检查传递给初始化器的`species`值是否为空字符串。如果找到空字符串，则触发初始化失败。否则，将设置`species`属性的值，初始化成功：

1. struct Animal {
2. ​    let species: String
3. ​    init?(species: String) {
4. ​        if species.isEmpty { return nil }
5. ​        self.species = species
6. ​    }
7. }

您可以使用此故障初始化器尝试初始化新的`Animal`实例，并检查初始化是否成功：

1. let someCreature = Animal(species: "Giraffe")
2. // someCreature is of type Animal?, not Animal
3. 
4. if let giraffe = someCreature {
5. ​    print("An animal was initialized with a species of \(giraffe.species)")
6. }
7. // Prints "An animal was initialized with a species of Giraffe"

如果您将空字符串值传递给可故障初始化器的`species`参数，初始化器将触发初始化失败：

1. let anonymousCreature = Animal(species: "")
2. // anonymousCreature is of type Animal?, not Animal
3. 
4. if anonymousCreature == nil {
5. ​    print("The anonymous creature couldn't be initialized")
6. }
7. // Prints "The anonymous creature couldn't be initialized"

注意

检查空字符串值（如`""`而不是`"Giraffe"`与检查`nil`以指示没有*可选*`String`值不同。在上面的示例中，空字符串（“”）是一个有效的、非可选的`String`。然而，动物用空字符串作为其`species`属性的值是不合适的。要模拟此限制，如果找到空字符串，则故障初始化器将触发初始化失败。

### 枚举的失败初始化器

您可以使用故障初始化器根据一个或多个参数选择适当的枚举情况。如果提供的参数与适当的枚举情况不匹配，初始化器可能会失败。

以下示例定义了一个名为`TemperatureUnit`枚举，具有三种可能的状态（`kelvin`、摄氏度和`fahrenheit`）。故障初始化器用于为表示温度符号的`Character`值找到适当的枚举情况：

1. enum TemperatureUnit {
2. ​    case kelvin, celsius, fahrenheit
3. ​    init?(symbol: Character) {
4. ​        switch symbol {
5. ​        case "K":
6. ​            self = .kelvin
7. ​        case "C":
8. ​            self = .celsius
9. ​        case "F":
10. ​            self = .fahrenheit
11. ​        default:
12. ​            return nil
13. ​        }
14. ​    }
15. }

您可以使用此故障初始化器为三种可能的状态选择适当的枚举情况，如果参数与以下状态之一不匹配，则导致初始化失败：

1. let fahrenheitUnit = TemperatureUnit(symbol: "F")
2. if fahrenheitUnit != nil {
3. ​    print("This is a defined temperature unit, so initialization succeeded.")
4. }
5. // Prints "This is a defined temperature unit, so initialization succeeded."
6. 
7. let unknownUnit = TemperatureUnit(symbol: "X")
8. if unknownUnit == nil {
9. ​    print("This isn't a defined temperature unit, so initialization failed.")
10. }
11. // Prints "This isn't a defined temperature unit, so initialization failed."

### 具有原始值的枚举的失败初始化器

具有原始值的枚举会自动收到一个失败的初始化器，`init?(rawValue:)`它接受一个名为`rawValue`的适当原始值类型的参数，如果找到匹配枚举情况，则选择匹配枚举情况，如果没有匹配值，则触发初始化失败。

You can rewrite the `TemperatureUnit` example from above to use raw values of type `Character` and to take advantage of the `init?(rawValue:)` initializer:

1. enum TemperatureUnit: Character {
2. ​    case kelvin = "K", celsius = "C", fahrenheit = "F"
3. }
4. 
5. let fahrenheitUnit = TemperatureUnit(rawValue: "F")
6. if fahrenheitUnit != nil {
7. ​    print("This is a defined temperature unit, so initialization succeeded.")
8. }
9. // Prints "This is a defined temperature unit, so initialization succeeded."
10. 
11. let unknownUnit = TemperatureUnit(rawValue: "X")
12. if unknownUnit == nil {
13. ​    print("This isn't a defined temperature unit, so initialization failed.")
14. }
15. // Prints "This isn't a defined temperature unit, so initialization failed."

### 初始化失败的传播

类、结构或枚举的故障初始化器可以委托给来自同一类、结构或枚举的另一个故障初始化器。同样，子类故障初始化器最多可以委托给超类故障初始化器。

无论哪种情况，如果您委托给另一个导致初始化失败的初始化器，整个初始化过程都会立即失败，并且不会执行进一步的初始化代码。

注意

故障初始化器也可以委托给不可失败的初始化器。如果您需要将潜在的失败状态添加到现有初始化进程中，否则不会失败，请使用此方法。

下面的示例定义了一个名为`CartItem``Product`子类。`CartItem`类为在线购物车中的商品建模。`CartItem`引入了一个名为`quantity`的存储常量属性，并确保该属性始终具有至少1的值：

1. class Product {
2. ​    let name: String
3. ​    init?(name: String) {
4. ​        if name.isEmpty { return nil }
5. ​        self.name = name
6. ​    }
7. }
8. 
9. class CartItem: Product {
10. ​    let quantity: Int
11. ​    init?(name: String, quantity: Int) {
12. ​        if quantity < 1 { return nil }
13. ​        self.quantity = quantity
14. ​        super.init(name: name)
15. ​    }
16. }

`CartItem`的故障初始化器首先验证它是否收到了`1`或更多`quantity`。如果`quantity`无效，整个初始化过程将立即失败，并且不会执行进一步的初始化代码。同样，`Product`故障初始化器会检查`name`值，如果`name`是空字符串，初始化过程将立即失败。

如果您创建具有非空名称且数量为`1`或更多内容的`CartItem`实例，初始化将成功：

1. if let twoSocks = CartItem(name: "sock", quantity: 2) {
2. ​    print("Item: \(twoSocks.name), quantity: \(twoSocks.quantity)")
3. }
4. // Prints "Item: sock, quantity: 2"

如果您尝试创建`quantity`为`0`的`CartItem`实例，`CartItem`初始化程序会导致初始化失败：

1. if let zeroShirts = CartItem(name: "shirt", quantity: 0) {
2. ​    print("Item: \(zeroShirts.name), quantity: \(zeroShirts.quantity)")
3. } else {
4. ​    print("Unable to initialize zero shirts")
5. }
6. // Prints "Unable to initialize zero shirts"

同样，如果您尝试创建`name`值为空的`CartItem`实例，超类`Product`初始化器会导致初始化失败：

1. if let oneUnnamed = CartItem(name: "", quantity: 1) {
2. ​    print("Item: \(oneUnnamed.name), quantity: \(oneUnnamed.quantity)")
3. } else {
4. ​    print("Unable to initialize one unnamed product")
5. }
6. // Prints "Unable to initialize one unnamed product"

### 覆盖失败的初始化器

您可以像任何其他初始化器一样，在子类中覆盖超类故障初始化器。或者，您可以使用子类不可*失败*初始化器覆盖超类故障初始化器。这使您能够定义初始化不能失败的子类，即使允许超类的初始化失败。

请注意，如果您使用不可失败的子类初始化器覆盖故障的超类初始化器，则委托给超类初始化器的唯一方法是强制解压可故障超类初始化器的结果。

注意

您可以使用不可失败的初始化器覆盖故障初始化器，但不能反过来。

下面的示例定义了一个名为`Document`的类。该类建模文档，该文档可以使用非空字符串值或`nil`的`name`属性初始化，但不能是空字符串：

1. class Document {
2. ​    var name: String?
3. ​    // this initializer creates a document with a nil name value
4. ​    init() {}
5. ​    // this initializer creates a document with a nonempty name value
6. ​    init?(name: String) {
7. ​        if name.isEmpty { return nil }
8. ​        self.name = name
9. ​    }
10. }

下一个示例定义了一个名为`AutomaticallyNamedDocument`的`Document`子类。`AutomaticallyNamedDocument`子类覆盖了`Document`引入的两个指定初始化器。如果实例在没有名称的情况下初始化，或者将空字符串传递给`init(name:)`初始化器，则这些重写确保`AutomaticallyNamedDocument`实例的初始`name`值为`"[Untitled]"`：

1. class AutomaticallyNamedDocument: Document {
2. ​    override init() {
3. ​        super.init()
4. ​        self.name = "[Untitled]"
5. ​    }
6. ​    override init(name: String) {
7. ​        super.init()
8. ​        if name.isEmpty {
9. ​            self.name = "[Untitled]"
10. ​        } else {
11. ​            self.name = name
12. ​        }
13. ​    }
14. }

The `AutomaticallyNamedDocument` overrides its superclass’s failable `init?(name:)`initializer with a nonfailable `init(name:)` initializer. Because `AutomaticallyNamedDocument`copes with the empty string case in a different way than its superclass, its initializer doesn’t need to fail, and so it provides a nonfailable version of the initializer instead.

您可以使用初始化器中的强制展开从超类调用故障初始化器，作为子类不可失败初始化器实现的一部分。例如，下面的`UntitledDocument`子类总是命名为`"[Untitled]"`并在初始化期间使用其超类的failableinit`init(name:)`初始化器。

1. class UntitledDocument: Document {
2. ​    override init() {
3. ​        super.init(name: "[Untitled]")!
4. ​    }
5. }

在这种情况下，如果以空字符串为名称调用超类的`init(name:)`初始化器，强制展开操作将导致运行时错误。但是，由于它是用字符串常量调用的，因此您可以看到初始化器不会失败，因此在这种情况下不会发生运行时错误。

### it！初始化器失败

您通常定义一个失败的初始化器，通过`init`关键字（`init?`）后面放置问号来创建适当类型的可选实例。或者，您可以定义一个可故障的初始化器，该初始化器可以创建适当类型的隐式未包装的可选实例。通过`init`关键字（`init!`）后面放置感叹号来做到这一点而不是问号。

You can delegate from `init?` to `init!` and vice versa, and you can override `init?` with `init!` and vice versa. You can also delegate from `init` to `init!`, although doing so will trigger an assertion if the `init!` initializer causes initialization to fail.

## 必需的初始化器

在定义类初始化器之前写入`required`修饰符，以指示类中的每个子类都必须实现该初始化器：

1. class SomeClass {
2. ​    required init() {
3. ​        // initializer implementation goes here
4. ​    }
5. }

您还必须在每个必需初始化器子类实现之前编写`required`修饰符，以表明初始化器要求适用于链中的进一步子类。在覆盖所需的指定初始化器时，您不会编写`override`修饰符：

1. class SomeSubclass: SomeClass {
2. ​    required init() {
3. ​        // subclass implementation of the required initializer goes here
4. ​    }
5. }

注意

如果您能够用继承的初始化器满足要求，则不必提供所需初始化器的显式实现。

## 使用闭包或函数设置默认属性值

如果存储属性的默认值需要一些自定义或设置，您可以使用闭包或全局函数为该属性提供自定义默认值。每当初始化属性所属类型的新实例时，都会调用闭包或函数，并将其返回值分配为属性的默认值。

这些类型的闭包或函数通常会创建一个与属性类型相同的临时值，定制该值以表示所需的初始状态，然后返回该临时值作为属性的默认值。

以下是如何使用闭包来提供默认属性值的骨架大纲：

1. class SomeClass {
2. ​    let someProperty: SomeType = {
3. ​        // create a default value for someProperty inside this closure
4. ​        // someValue must be of the same type as SomeType
5. ​        return someValue
6. ​    }()
7. }

请注意，闭合的末端花括号后面是一对空括号。这告诉Swift立即执行关闭。如果您省略这些括号，您将尝试将闭包本身分配给属性，而不是闭包的返回值。

注意

如果您使用闭包初始化属性，请记住，在执行闭包时，实例的其余部分尚未初始化。这意味着您无法从闭包中访问任何其他属性值，即使这些属性具有默认值。您也不能使用隐式`self`属性，也不能调用实例的任何方法。

下面的示例定义了一个名为`Chessboard`结构，该结构为国际象棋游戏建模。国际象棋在8 x 8棋盘上进行，黑白方块交替进行。

![../_images/chessBoard_2x.png](https://docs.swift.org/swift-book/_images/chessBoard_2x.png)

为了表示这个游戏板，`Chessboard`结构有一个名为`boardColors`单一属性，这是一个由64个`Bool`值组成的数组。数组中的`true`值表示黑色正方形，`false`值表示白色正方形。数组中的第一个项目表示板上的左上角正方形，数组中的最后一个项表示板上的右下角正方形。

`boardColors`数组使用闭包初始化，以设置其颜色值：

1. struct Chessboard {
2. ​    let boardColors: [Bool] = {
3. ​        var temporaryBoard: [Bool] = []
4. ​        var isBlack = false
5. ​        for i in 1...8 {
6. ​            for j in 1...8 {
7. ​                temporaryBoard.append(isBlack)
8. ​                isBlack = !isBlack
9. ​            }
10. ​            isBlack = !isBlack
11. ​        }
12. ​        return temporaryBoard
13. ​    }()
14. ​    func squareIsBlackAt(row: Int, column: Int) -> Bool {
15. ​        return boardColors[(row * 8) + column]
16. ​    }
17. }

每当创建新的`Chessboard`实例时，都会执行闭包，并计算并返回`boardColors`默认值。上面示例中的闭包计算并设置名为`temporaryBoard`板上的每个正方形的适当颜色，并在设置完成后将该临时数组作为闭包的返回值。返回的数组值存储在`boardColors`，可以使用`squareIsBlackAt(row:column:)`实用程序函数查询：

1. let board = Chessboard()
2. print(board.squareIsBlackAt(row: 0, column: 1))
3. // Prints "true"
4. print(board.squareIsBlackAt(row: 7, column: 7))
5. // Prints "false"