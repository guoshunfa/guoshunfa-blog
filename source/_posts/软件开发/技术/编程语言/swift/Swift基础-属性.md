---
title: Swift基础 属性
tags:
    - Swift
    - 基础
categories:
    - Swift
date: 2022-07-01 12:01:01
thumbnail:
---

翻译自：https://docs.swift.org/swift-book/LanguageGuide/Properties.html

*属性*将值与特定类、结构或枚举相关联。存储属性将常量和变量值存储为实例的一部分，而计算属性计算（而不是存储）值。计算属性由类、结构和枚举提供。存储属性仅由类和结构提供。

存储和计算属性通常与特定类型的实例相关联。然而，属性也可以与类型本身相关联。这些属性被称为类型属性。

此外，您可以定义属性观察器来监控属性值的变化，您可以通过自定义操作来响应。属性观察者可以添加到您自己定义的存储属性中，也可以添加到子类从其超类继承的属性中。

您还可以使用属性包装器在多个属性的获取器和设置器中重用代码。

## 存储的属性

在最简单的形式中，存储属性是作为特定类或结构实例的一部分存储的常量或变量。存储属性可以是*变量存储属性*（由`var`关键字引入）或*常量存储属性*（由`let`关键字引入）。

您可以为存储属性提供默认值，作为其定义的一部分，如[默认属性值](https://docs.swift.org/swift-book/LanguageGuide/Initialization.html#ID206)中所述。您还可以在初始化期间设置和修改存储属性的初始值。即使是常量存储属性也是如此，如[初始化期间分配常量属性](https://docs.swift.org/swift-book/LanguageGuide/Initialization.html#ID212)中所述。

以下示例定义了一个名为`FixedLengthRange`的结构，该结构描述了创建后无法更改范围长度的整数范围：

1. struct FixedLengthRange {
2. ​    var firstValue: Int
3. ​    let length: Int
4. }
5. var rangeOfThreeItems = FixedLengthRange(firstValue: 0, length: 3)
6. // the range represents integer values 0, 1, and 2
7. rangeOfThreeItems.firstValue = 6
8. // the range now represents integer values 6, 7, and 8

`FixedLengthRange`的实例有一个名为`firstValue`变量存储属性和一个名为`length`的常量存储属性。在上面的示例中，`length`在创建新范围时初始化，此后无法更改，因为它是一个常量属性。

### 恒定结构实例的存储属性

如果您创建结构实例并将该实例分配给常量，则无法修改实例的属性，即使它们被声明为变量属性：

1. let rangeOfFourItems = FixedLengthRange(firstValue: 0, length: 4)
2. // this range represents integer values 0, 1, 2, and 3
3. rangeOfFourItems.firstValue = 6
4. // this will report an error, even though firstValue is a variable property

由于`rangeOfFourItems`被声明为常量（使用`let`关键字），因此无法更改其`firstValue`属性，即使`firstValue`是一个变量属性。

这种行为是由于结构是*值类型*。当值类型的实例被标记为常量时，其所有属性也是如此。

类的情况并非如此，类是*参考类型*。如果您将引用类型的实例分配给常量，您仍然可以更改该实例的变量属性。

### 懒惰存储的房产

*惰性存储属性*是直到首次使用时才计算初始值的属性。您可以通过在声明之前写入`lazy`修饰符来指示惰性存储属性。

注意

您必须始终将惰性属性声明为变量（使用`var`关键字），因为在实例初始化完成之前，可能无法检索其初始值。*在*初始化完成*之前，*常量属性必须始终具有值，因此不能声明为懒惰。

当属性的初始值依赖于外部因素时，懒惰属性非常有用，这些因素的值直到实例初始化完成后才知道。当属性的初始值需要复杂或计算昂贵的设置时，懒惰属性也很有用，除非或直到需要，否则不应执行。

下面的示例使用惰性存储属性来避免不必要的复杂类初始化。此示例定义了两个名为`DataImporter`和`DataManager`的类，这两个类都没有完整显示：

1. class DataImporter {
2. ​    /*
3. ​    DataImporter is a class to import data from an external file.
4. ​    The class is assumed to take a nontrivial amount of time to initialize.
5. ​    */
6. ​    var filename = "data.txt"
7. ​    // the DataImporter class would provide data importing functionality here
8. }
9. 
10. class DataManager {
11. ​    lazy var importer = DataImporter()
12. ​    var data: [String] = []
13. ​    // the DataManager class would provide data management functionality here
14. }
15. 
16. let manager = DataManager()
17. manager.data.append("Some data")
18. manager.data.append("Some more data")
19. // the DataImporter instance for the importer property hasn't yet been created

`DataManager`类有一个名为`data`的存储属性，该属性使用一个新的空`String`值数组初始化。虽然没有显示其其余功能，但此`DataManager`类的目的是管理和提供对`String`数据数组的访问。

`DataManager`类的部分功能是能够从文件导入数据。此功能由`DataImporter`类提供，该类假设初始化需要非常平凡的时间。这可能是因为`DataImporter`实例在初始化`DataImporter`实例时需要打开文件并将其内容读取到内存中。

由于`DataManager`实例可以在不从文件中导入数据的情况下管理其数据，因此在创建`DataManager`本身时，`DataManager`不会创建新的`DataImporter`实例。相反，当`DataImporter`实例首次使用时，创建它更有意义。

由于它标有`lazy`修饰符，因此只有在首次访问`importer`属性时才会创建`importer`属性的`DataImporter`实例，例如查询其`filename`属性时：

1. print(manager.importer.filename)
2. // the DataImporter instance for the importer property has now been created
3. // Prints "data.txt"

注意

如果标记有`lazy`修饰符的属性同时由多个线程访问，并且该属性尚未初始化，则不能保证该属性只会初始化一次。

### 存储属性和实例变量

如果您有Objective-C的经验，您可能知道它提供了*两种*存储值和引用作为类实例的一部分的方法。除了属性外，您还可以使用实例变量作为存储在属性中的值的备份存储。

Swift将这些概念统一为单个属性声明。Swift属性没有相应的实例变量，并且不会直接访问属性的备份存储。这种方法避免了在不同上下文中如何访问该值的混淆，并将属性的声明简化为单个确定性语句。有关属性的所有信息——包括其名称、类型和内存管理特征——都是在单个位置定义的，作为类型定义的一部分。

## 计算属性

除了存储属性外，类、结构和枚举还可以定义*计算属性*，这些属性实际上不会存储值。相反，它们提供了一个getter和一个可选的setter来间接检索和设置其他属性和值。

1. struct Point {
2. ​    var x = 0.0, y = 0.0
3. }
4. struct Size {
5. ​    var width = 0.0, height = 0.0
6. }
7. struct Rect {
8. ​    var origin = Point()
9. ​    var size = Size()
10. ​    var center: Point {
11. ​        get {
12. ​            let centerX = origin.x + (size.width / 2)
13. ​            let centerY = origin.y + (size.height / 2)
14. ​            return Point(x: centerX, y: centerY)
15. ​        }
16. ​        set(newCenter) {
17. ​            origin.x = newCenter.x - (size.width / 2)
18. ​            origin.y = newCenter.y - (size.height / 2)
19. ​        }
20. ​    }
21. }
22. var square = Rect(origin: Point(x: 0.0, y: 0.0),
23. ​                  size: Size(width: 10.0, height: 10.0))
24. let initialSquareCenter = square.center
25. // initialSquareCenter is at (5.0, 5.0)
26. square.center = Point(x: 15.0, y: 15.0)
27. print("square.origin is now at (\(square.origin.x), \(square.origin.y))")
28. // Prints "square.origin is now at (10.0, 10.0)"

此示例定义了用于处理几何形状的三种结构：

- `Point`封装点的x坐标和y坐标。
- `Size`封装`width`和`height`。
- `Rect`按原点和大小定义矩形。

`Rect`结构还提供了一个称为`center`计算属性。`Rect`的当前中心位置始终可以根据其`origin`和`size`确定，因此您不需要将中心点存储为显式`Point`值。相反，`Rect`为称为`center`的计算变量定义了一个自定义获取器和setter，使您能够像处理矩形`center`一样使用它，就像它是真正的存储属性一样。

上面的示例创建一个名为`square`的新`Rect`变量。`square`变量初始化为`(0,0)`宽度和高度为10。这个正方形由下图中的浅绿色正方形表示。

然后通过点语法（`square.center`）访问`square`变量`center`属性，从而调用`center`获取器来检索当前属性值。得到者实际上计算并返回一个新点来表示正方形的中心，而不是返回现有值。如上所示，获取器正确返回中心点`(5,5)`

然后将`center`属性设置为`(15,15)`的新值，将正方形向上和向右移动，到下图中深绿色正方形显示的新位置。设置`center`属性调用`center`设置器，该设置器修改存储`origin`属性的`x`和`y`值，并将正方形移动到其新位置。

<img src="https://file.pandacode.cn/blog/202204051606043.png" alt="../_images/computedProperties_2x.png" style="zoom:50%;" />

### 速记获取声明

如果得到者的整个主体是一个表达式，则得到者会隐式返回该表达式。以下是利用此速记符号和设置者速记符号的`Rect`结构的另一个版本：

1. struct CompactRect {
2. ​    var origin = Point()
3. ​    var size = Size()
4. ​    var center: Point {
5. ​        get {
6. ​            Point(x: origin.x + (size.width / 2),
7. ​                  y: origin.y + (size.height / 2))
8. ​        }
9. ​        set {
10. ​            origin.x = newValue.x - (size.width / 2)
11. ​            origin.y = newValue.y - (size.height / 2)
12. ​        }
13. ​    }
14. }

省略getter的`return`遵循与省略函数`return`相同的规则，如《[隐式返回函数》](https://docs.swift.org/swift-book/LanguageGuide/Functions.html#ID607)中所述。

### 只读计算属性

具有获取器但没有设置器的计算属性称为*只读计算属性*。只读计算属性总是返回一个值，可以通过点语法访问，但不能设置为其他值。

注意

您必须使用`var`关键字将计算属性（包括只读计算属性）声明为变量属性，因为它们的值不是固定的。`let`关键字仅用于常量属性，以指示一旦将其设置为实例初始化的一部分，其值就无法更改。

您可以通过删除`get`关键字及其大括号来简化只读计算属性的声明：

1. struct Cuboid {
2. ​    var width = 0.0, height = 0.0, depth = 0.0
3. ​    var volume: Double {
4. ​        return width * height * depth
5. ​    }
6. }
7. let fourByFiveByTwo = Cuboid(width: 4.0, height: 5.0, depth: 2.0)
8. print("the volume of fourByFiveByTwo is \(fourByFiveByTwo.volume)")
9. // Prints "the volume of fourByFiveByTwo is 40.0"

此示例定义了一个名为`Cuboid`的新结构，它代表一个具有`width`、`height`和`depth`属性的3D矩形框。该结构还有一个名为`volume`的只读计算属性，该属性计算并返回长方体的当前体积。`volume`可设置没有意义，因为对于特定`volume`值应该使用哪些`width`、`height`和`depth`值是模棱两可的。尽管如此，对于`Cuboid`，提供只读计算属性以使外部用户能够发现其当前的计算卷是有用的。

## 财产观察员

财产观察者观察并回应财产价值的变化。每次设置属性值时都会调用属性观察者，即使新值与属性的当前值相同。

您可以在以下位置添加属性观察者：

- 您定义的存储属性
- 您继承的存储属性
- 您继承的计算属性

对于继承的属性，您可以通过在子类中重写该属性来添加属性观察者。对于您定义的计算属性，请使用属性的设置器来观察和响应值更改，而不是尝试创建观察者。重写属性在[重写](https://docs.swift.org/swift-book/LanguageGuide/Inheritance.html#ID196)中描述。

您可以选择在属性上定义以下一个或多个观察者：

- `willSet`在存储值之前调用。
- `didSet`在存储新值后立即调用。

If you implement a `willSet` observer, it’s passed the new property value as a constant parameter. You can specify a name for this parameter as part of your `willSet`implementation. If you don’t write the parameter name and parentheses within your implementation, the parameter is made available with a default parameter name of `newValue`.

Similarly, if you implement a `didSet` observer, it’s passed a constant parameter containing the old property value. You can name the parameter or use the default parameter name of `oldValue`. If you assign a value to a property within its own `didSet` observer, the new value that you assign replaces the one that was just set.

注意

在调用超类初始化器后，当在子类初始化器中设置属性时，调用超类属性的`willSet`和`didSet`观察器。在调用超类初始化器之前，当类设置自己的属性时，不会调用它们。

有关初始化器委托的更多信息，请参阅[值类型的初始化器委托](https://docs.swift.org/swift-book/LanguageGuide/Initialization.html#ID215)和[类类型的初始化器委托](https://docs.swift.org/swift-book/LanguageGuide/Initialization.html#ID219)。

以下是`willSet`和`didSet`执行的实例。下面的示例定义了一个名为`StepCounter`的新类，该类跟踪一个人在行走时采取的总步数。该课程可以与计步器或其他步数计数器的输入数据一起使用，以跟踪一个人在日常生活中的锻炼情况。

1. class StepCounter {
2. ​    var totalSteps: Int = 0 {
3. ​        willSet(newTotalSteps) {
4. ​            print("About to set totalSteps to \(newTotalSteps)")
5. ​        }
6. ​        didSet {
7. ​            if totalSteps > oldValue  {
8. ​                print("Added \(totalSteps - oldValue) steps")
9. ​            }
10. ​        }
11. ​    }
12. }
13. let stepCounter = StepCounter()
14. stepCounter.totalSteps = 200
15. // About to set totalSteps to 200
16. // Added 200 steps
17. stepCounter.totalSteps = 360
18. // About to set totalSteps to 360
19. // Added 160 steps
20. stepCounter.totalSteps = 896
21. // About to set totalSteps to 896
22. // Added 536 steps

The `StepCounter` class declares a `totalSteps` property of type `Int`. This is a stored property with `willSet` and `didSet` observers.

The `willSet` and `didSet` observers for `totalSteps` are called whenever the property is assigned a new value. This is true even if the new value is the same as the current value.

This example’s `willSet` observer uses a custom parameter name of `newTotalSteps` for the upcoming new value. In this example, it simply prints out the value that’s about to be set.

The `didSet` observer is called after the value of `totalSteps` is updated. It compares the new value of `totalSteps` against the old value. If the total number of steps has increased, a message is printed to indicate how many new steps have been taken. The `didSet` observer doesn’t provide a custom parameter name for the old value, and the default name of `oldValue` is used instead.

注意

如果您将具有观察者作为进出参数的函数的属性传递，则始终调用将`willSet`和`didSet`观察者。这是因为输入输出参数的复制内存模型：该值总是写回函数末尾的属性。有关进出参数行为的详细讨论，请参阅[输入输出参数](https://docs.swift.org/swift-book/ReferenceManual/Declarations.html#ID545)。

## 物业包装纸

属性包装器在管理属性存储方式的代码和定义属性的代码之间添加了一层分离。例如，如果您的属性提供线程安全检查或将其基础数据存储在数据库中，则必须在每个属性上编写该代码。当您使用属性包装器时，您在定义包装器时编写一次管理代码，然后通过将其应用于多个属性来重用该管理代码。

要定义属性包装器，请制作一个定义awrappedValue属性的结构、枚举或类。在下面的代码中，`TwelveOrLess`结构确保它包装的值始终包含小于或等于12的数字。如果您要求它存储更大的数量，它将存储12个。

1. @propertyWrapper
2. struct TwelveOrLess {
3. ​    private var number = 0
4. ​    var wrappedValue: Int {
5. ​        get { return number }
6. ​        set { number = min(newValue, 12) }
7. ​    }
8. }

设置器确保新值小于或等于12，并且获取器返回存储值。

注意

上面示例中的`number`声明将变量标记为`private`，这确保`number`仅用于`TwelveOrLess`的实现。写在其他地方的代码使用`wrappedValue`的getter和setter访问值，并且不能直接使用`number`。有关`private`信息，请参阅[访问控制](https://docs.swift.org/swift-book/LanguageGuide/AccessControl.html)。

您可以通过将包装器的名称写在属性之前作为属性来将包装器应用于属性。这里有一个结构，它存储一个矩形，该矩形使用`TwelveOrLess`属性包装器，以确保其尺寸始终为12或更少：

1. struct SmallRectangle {
2. ​    @TwelveOrLess var height: Int
3. ​    @TwelveOrLess var width: Int
4. }
5. 
6. var rectangle = SmallRectangle()
7. print(rectangle.height)
8. // Prints "0"
9. 
10. rectangle.height = 10
11. print(rectangle.height)
12. // Prints "10"
13. 
14. rectangle.height = 24
15. print(rectangle.height)
16. // Prints "12"

The `height` and `width` properties get their initial values from the definition of `TwelveOrLess`, which sets `TwelveOrLess.number` to zero. The setter in `TwelveOrLess` treats 10 as a valid value so storing the number 10 in `rectangle.height` proceeds as written. However, 24 is larger than `TwelveOrLess` allows, so trying to store 24 end up setting `rectangle.height` to 12 instead, the largest allowed value.

当您将包装器应用于属性时，编译器会合成为包装器提供存储的代码和通过包装器访问该属性的代码。（属性包装器负责存储包装的值，因此没有合成代码。）您可以编写使用属性包装器行为的代码，而无需利用特殊属性语法。例如，这是之前代码列表中的`SmallRectangle`版本，该版本显式将其属性包装在`TwelveOrLess`结构中，而不是将`@TwelveOrLess`写为属性：

1. struct SmallRectangle {
2. ​    private var _height = TwelveOrLess()
3. ​    private var _width = TwelveOrLess()
4. ​    var height: Int {
5. ​        get { return _height.wrappedValue }
6. ​        set { _height.wrappedValue = newValue }
7. ​    }
8. ​    var width: Int {
9. ​        get { return _width.wrappedValue }
10. ​        set { _width.wrappedValue = newValue }
11. ​    }
12. }

`_height`和`_width`属性存储属性包装器`TwelveOrLess`实例。`height`和`width`的获取器和设置器对`wrappedValue`属性的访问。

### 为包装属性设置初始值

上面示例中的代码通过在`TwelveOrLess`的定义中给出`number`初始值来设置包装属性的初始值。使用此属性包装器的代码无法为由`TwelveOrLess`包装的属性指定不同的初始值——例如，`SmallRectangle`的定义不能给出`height`或`width`初始值。为了支持设置初始值或其他自定义，属性包装器需要添加初始化器。以下是名为`SmallNumber`的`TwelveOrLess`扩展版本，它定义了设置包装和最大值的初始化器：

1. @propertyWrapper
2. struct SmallNumber {
3. ​    private var maximum: Int
4. ​    private var number: Int
5. 
6. ​    var wrappedValue: Int {
7. ​        get { return number }
8. ​        set { number = min(newValue, maximum) }
9. ​    }
10. 
11. ​    init() {
12. ​        maximum = 12
13. ​        number = 0
14. ​    }
15. ​    init(wrappedValue: Int) {
16. ​        maximum = 12
17. ​        number = min(wrappedValue, maximum)
18. ​    }
19. ​    init(wrappedValue: Int, maximum: Int) {
20. ​        self.maximum = maximum
21. ​        number = min(wrappedValue, maximum)
22. ​    }
23. }

`SmallNumber`的定义包括三个初始化器——`init()`）、`init(wrappedValue:)`和`init(wrappedValue:maximum:)`——以下示例用于设置包装值和最大值。有关初始化和初始化器语法的信息，请参阅[初始化](https://docs.swift.org/swift-book/LanguageGuide/Initialization.html)。

当您将包装器应用于属性并且没有指定初始值时，Swift会使用thinit`init()`初始化器来设置包装器。例如：

1. struct ZeroRectangle {
2. ​    @SmallNumber var height: Int
3. ​    @SmallNumber var width: Int
4. }
5. 
6. var zeroRectangle = ZeroRectangle()
7. print(zeroRectangle.height, zeroRectangle.width)
8. // Prints "0 0"

包裹`height`和`width`的`SmallNumber`实例是通过调用`SmallNumber()`创建的。该初始化器内部的代码使用零和12的默认值设置初始包装值和初始最大值。属性包装器仍然提供所有初始值，就像之前在`SmallRectangle`中使用`TwelveOrLess`的示例一样。与该示例不同，`SmallNumber`还支持编写这些初始值，作为声明属性的一部分。

当您为属性指定初始值时，Swift使用`init(wrappedValue:)`初始化器来设置包装器。例如：

1. struct UnitRectangle {
2. ​    @SmallNumber var height: Int = 1
3. ​    @SmallNumber var width: Int = 1
4. }
5. 
6. var unitRectangle = UnitRectangle()
7. print(unitRectangle.height, unitRectangle.width)
8. // Prints "1 1"

When you write `= 1` on a property with a wrapper, that’s translated into a call to the `init(wrappedValue:)` initializer. The instances of `SmallNumber` that wrap `height` and `width`are created by calling `SmallNumber(wrappedValue: 1)`. The initializer uses the wrapped value that’s specified here, and it uses the default maximum value of 12.

当您在自定义属性后的括号中写入参数时，Swift使用接受这些参数的初始化器来设置包装器。例如，如果您提供初始值和最大值，Swift将使用`init(wrappedValue:maximum:)`初始化器：

1. struct NarrowRectangle {
2. ​    @SmallNumber(wrappedValue: 2, maximum: 5) var height: Int
3. ​    @SmallNumber(wrappedValue: 3, maximum: 4) var width: Int
4. }
5. 
6. var narrowRectangle = NarrowRectangle()
7. print(narrowRectangle.height, narrowRectangle.width)
8. // Prints "2 3"
9. 
10. narrowRectangle.height = 100
11. narrowRectangle.width = 100
12. print(narrowRectangle.height, narrowRectangle.width)
13. // Prints "5 4"

包裹`height`的`SmallNumber`实例是通过调用`SmallNumber(wrappedValue:2,maximum:5)`创建的，包装`width`的实例是通过调用`SmallNumber(wrappedValue:3,maximum:4)`创建的。

通过将参数包含在属性包装器中，您可以在包装器中设置初始状态，或在创建包装器时将其他选项传递给包装器。此语法是使用属性包装器的最通用方式。您可以为属性提供所需的任何参数，它们将传递给初始化器。

When you include property wrapper arguments, you can also specify an initial value using assignment. Swift treats the assignment like a `wrappedValue` argument and uses the initializer that accepts the arguments you include. For example:

1. struct MixedRectangle {
2. ​    @SmallNumber var height: Int = 1
3. ​    @SmallNumber(maximum: 9) var width: Int = 2
4. }
5. 
6. var mixedRectangle = MixedRectangle()
7. print(mixedRectangle.height)
8. // Prints "1"
9. 
10. mixedRectangle.height = 20
11. print(mixedRectangle.height)
12. // Prints "12"

The instance of `SmallNumber` that wraps `height` is created by calling `SmallNumber(wrappedValue: 1)`, which uses the default maximum value of 12. The instance that wraps `width` is created by calling `SmallNumber(wrappedValue: 2, maximum: 9)`.

### 从属性包装器中投射值

除了包装值外，属性包装器还可以通过定义*投影值*来公开其他功能——例如，管理数据库访问的属性包装器可以在其投影值上公开`flushDatabaseConnection()`方法。预计价值的名称与包装价值相同，只是以美元符号（$）开头。由于您的代码无法定义以`$`开头的属性，因此投影值永远不会干扰您定义的属性。

在上面的`SmallNumber`示例中，如果您尝试将属性设置为太大的数字，属性包装器将在存储之前调整数字。以下代码将`projectedValue`属性添加到`SmallNumber`结构中，以跟踪属性包装器在存储该新值之前是否调整了该属性的新值。

1. @propertyWrapper
2. struct SmallNumber {
3. ​    private var number: Int
4. ​    private(set) var projectedValue: Bool
5. 
6. ​    var wrappedValue: Int {
7. ​        get { return number }
8. ​        set {
9. ​            if newValue > 12 {
10. ​                number = 12
11. ​                projectedValue = true
12. ​            } else {
13. ​                number = newValue
14. ​                projectedValue = false
15. ​            }
16. ​        }
17. ​    }
18. 
19. ​    init() {
20. ​        self.number = 0
21. ​        self.projectedValue = false
22. ​    }
23. }
24. struct SomeStructure {
25. ​    @SmallNumber var someNumber: Int
26. }
27. var someStructure = SomeStructure()
28. 
29. someStructure.someNumber = 4
30. print(someStructure.$someNumber)
31. // Prints "false"
32. 
33. someStructure.someNumber = 55
34. print(someStructure.$someNumber)
35. // Prints "true"

编写`someStructure.$someNumber`访问包装器的投影值。存储一个小数字（如4）后，`someStructure.$someNumber`的值为`false`。然而，在尝试存储一个太大的数字（如55）后，预测值`true`

属性包装器可以返回任何类型的值作为其投影值。在本例中，属性包装器只公开一条信息——无论数字是否调整——因此它将布尔值作为其预测值。需要公开更多信息的包装器可以返回其他数据类型的实例，也可以返回`self`以将包装器的实例作为其投影值公开。

当您从属于该类型的代码（如属性获取器或实例方法）访问投影值时，您可以在属性名称之前省略`self.`就像访问其他属性一样。以下示例中的代码将包装器围绕`height`和`width`的投影值称为`$height`和`$width`：

1. enum Size {
2. ​    case small, large
3. }
4. 
5. struct SizedRectangle {
6. ​    @SmallNumber var height: Int
7. ​    @SmallNumber var width: Int
8. 
9. ​    mutating func resize(to size: Size) -> Bool {
10. ​        switch size {
11. ​        case .small:
12. ​            height = 10
13. ​            width = 20
14. ​        case .large:
15. ​            height = 100
16. ​            width = 100
17. ​        }
18. ​        return $height || $width
19. ​    }
20. }

由于属性包装语法只是具有获取器和设置器的属性的句法糖，因此访问`height`和`width`的行为与访问任何其他属性的行为相同。例如，`resize(to:)`中的代码使用其属性包装器访问`height`和`width`。如果您调用`resize(to:.large)``.large`的开关盒将矩形的高度和宽度设置为100。包装器防止这些属性的值大于12，并将投影值设置为`true`，以记录它调整其值的事实。在`resize(to:)`结束时，返回语句检查`$height`和`$width`，以确定属性包装器是否调整了`height`或`width`。

## 全局和局部变量

上述计算和观察属性的功能也适用于*全局变量*和*局部变量*。全局变量是在任何函数、方法、闭包或类型上下文之外定义的变量。局部变量是在函数、方法或闭包上下文中定义的变量。

您在前几章中遇到的全局变量和局部变量都已*存储*。存储的变量，如存储的属性，为特定类型的值提供存储，并允许设置和检索该值。

但是，您还可以在全局或局域范围内定义*计算变量*并为存储变量定义观察者。计算变量计算其值，而不是存储它，并且它们的写入方式与计算属性相同。

注意

全局常量和变量总是以与[懒惰存储属性](https://docs.swift.org/swift-book/LanguageGuide/Properties.html#ID257)相似的方式计算。与惰性存储属性不同，全局常量和变量不需要用`lazy`修饰符标记。

局部常数和变量从不懒惰地计算。

您可以将属性包装器应用于本地存储变量，但不能应用于全局变量或计算变量。例如，在下面的代码中，`myNumber`使用`SmallNumber`作为属性包装器。

1. func someFunction() {
2. ​    @SmallNumber var myNumber: Int = 0
3. 
4. ​    myNumber = 10
5. ​    // now myNumber is 10
6. 
7. ​    myNumber = 24
8. ​    // now myNumber is 12
9. }

像将`SmallNumber`应用于属性一样，将`myNumber`的值设置为10是有效的。由于属性包装器不允许值高于12，因此将`myNumber`设置为12而不是24。

## 类型属性

实例属性是属于特定类型实例的属性。每次您创建该类型的新实例时，它都有自己的属性值集，与任何其他实例分开。

您还可以定义属于类型本身的属性，而不是该类型的任何实例。无论您创建多少个此类实例，这些属性都将只有一个副本。这些类型的属性称为*类型属性*。

类型属性可用于定义特定类型*所有*实例通用的值，例如所有实例都可以使用的常量属性（如C中的静态常量），或存储该类型所有实例的全局值的变量属性（如C中的静态变量）。

存储的类型属性可以是变量或常量。计算类型属性总是声明为变量属性，就像计算实例属性一样。

注意

与存储实例属性不同，您必须始终为存储类型属性提供默认值。这是因为类型本身没有可以在初始化时为存储的类型属性分配值的初始化器。

存储类型属性在首次访问时被懒惰地初始化。它们保证只初始化一次，即使同时由多个线程访问，并且不需要用`lazy`修饰符标记它们。

### 类型属性语法

在C和Objective-C中，您将与类型关联的静态常量和变量定义为*全局静态*变量。然而，在Swift中，类型属性是作为类型定义的一部分，在类型的外部花括号内编写的，每个类型属性都显式扩展到它支持的类型。

您可以使用`static`关键字定义类型属性。对于类类型的计算类型属性，您可以使用`class`关键字来允许子类覆盖超类的实现。下面的示例显示了存储和计算类型属性的语法：

1. struct SomeStructure {
2. ​    static var storedTypeProperty = "Some value."
3. ​    static var computedTypeProperty: Int {
4. ​        return 1
5. ​    }
6. }
7. enum SomeEnumeration {
8. ​    static var storedTypeProperty = "Some value."
9. ​    static var computedTypeProperty: Int {
10. ​        return 6
11. ​    }
12. }
13. class SomeClass {
14. ​    static var storedTypeProperty = "Some value."
15. ​    static var computedTypeProperty: Int {
16. ​        return 27
17. ​    }
18. ​    class var overrideableComputedTypeProperty: Int {
19. ​        return 107
20. ​    }
21. }

注意

上面的计算类型属性示例适用于只读计算类型属性，但您也可以使用与计算实例属性相同的语法定义读写计算类型属性。

### 查询和设置类型属性

类型属性使用点语法查询和设置，就像实例属性一样。但是，类型属性是在*类型*上查询和设置的，而不是在该类型的实例上。例如：

1. print(SomeStructure.storedTypeProperty)
2. // Prints "Some value."
3. SomeStructure.storedTypeProperty = "Another value."
4. print(SomeStructure.storedTypeProperty)
5. // Prints "Another value."
6. print(SomeEnumeration.computedTypeProperty)
7. // Prints "6"
8. print(SomeClass.computedTypeProperty)
9. // Prints "27"

以下示例使用两个存储的类型属性作为为多个音频通道建模音频电平计的结构的一部分。每个通道的整数音频电平在`0`到`10`之间。

下图说明了如何将其中两个音频通道组合成立体声音频电平计建模。当一个频道的音频电平为`0`时，该频道的灯都不会亮起。当音频电平为10时，该通道的所有灯都亮了。在这个图中，左通道的当前电平为9，右信道的当前电平为`7`：

![../_images/staticPropertiesVUMeter_2x.png](https://file.pandacode.cn/blog/202204051608905.png)

上述音频通道由`AudioChannel`结构的实例表示：

1. struct AudioChannel {
2. ​    static let thresholdLevel = 10
3. ​    static var maxInputLevelForAllChannels = 0
4. ​    var currentLevel: Int = 0 {
5. ​        didSet {
6. ​            if currentLevel > AudioChannel.thresholdLevel {
7. ​                // cap the new audio level to the threshold level
8. ​                currentLevel = AudioChannel.thresholdLevel
9. ​            }
10. ​            if currentLevel > AudioChannel.maxInputLevelForAllChannels {
11. ​                // store this as the new overall maximum input level
12. ​                AudioChannel.maxInputLevelForAllChannels = currentLevel
13. ​            }
14. ​        }
15. ​    }
16. }

`AudioChannel`结构定义了两个存储的类型属性来支持其功能。第一个，`thresholdLevel`，定义了音频级别可以达到的最大阈值。对于所有`AudioChannel`实例，这是一个`10`的常量值。如果音频信号的值高于10，它将被限制为此阈值（如下所述）。

第二种类型属性是一个名为`maxInputLevelForAllChannels`变量存储属性。这可以跟踪*任何*`AudioChannel`实例收到的最大输入值。它以初始值`0`开头。

`AudioChannel`结构还定义了一个名为`currentLevel`的存储实例属性，该属性以`0`到10的比例表示通道的当前音频级别。

`currentLevel`属性有一个`didSet`属性观察器，用于在设置`currentLevel`时检查其值。此观察者执行两项检查：

- 如果`currentLevel`的新值大于允许的`thresholdLevel`，则属性观察者将`currentLevel`上限为 `thresholdLevel`。
- 如果`currentLevel`的新值（在任何上限之后）高于*任何*`AudioChannel`实例之前收到的任何值，则属性观察者将newcurrentLevel值存储在`maxInputLevelForAllChannels`类型属性中。

注意

In the first of these two checks, the `didSet` observer sets `currentLevel` to a different value. This doesn’t, however, cause the observer to be called again.

您可以使用`AudioChannel`结构创建两个名为`leftChannel`和`rightChannel`的新音频通道，以表示立体声系统的音频水平：

1. var leftChannel = AudioChannel()
2. var rightChannel = AudioChannel()

如果您将*左侧*通道的`currentLevel`设置为7，您可以看到`maxInputLevelForAllChannels`类型属性更新为等于`7`：

1. leftChannel.currentLevel = 7
2. print(leftChannel.currentLevel)
3. // Prints "7"
4. print(AudioChannel.maxInputLevelForAllChannels)
5. // Prints "7"

如果您尝试将*正确*通道的`currentLevel`设置为11，您可以看到右侧通道的`currentLevel`属性上限为最大值10，`maxInputLevelForAllChannels`类型属性更新为等于`10`：

1. rightChannel.currentLevel = 11
2. print(rightChannel.currentLevel)
3. // Prints "10"
4. print(AudioChannel.maxInputLevelForAllChannels)
5. // Prints "10"