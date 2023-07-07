---
title: Swift基础 继承
tags:
    - Swift
    - 基础
categories:
    - Swift
date: 2022-07-01 12:01:01
thumbnail:
---


翻译自：https://docs.swift.org/swift-book/LanguageGuide/Inheritance.html

一个类可以从另一个类*继承*方法、属性和其他特征。当一个类从另一个类继承时，继承类被称为*子类*，它继承的类被称为其*超类*。继承是一种基本行为，可以将类与 Swift 中的其他类型区分开来。

Swift中的类可以调用和访问属于其超类的方法、属性和下标，并可以提供这些方法、属性和下标的覆盖版本，以细化或修改其行为。Swift通过检查覆盖定义是否具有匹配的超类定义来帮助确保您的覆盖正确。

类还可以将属性观察者添加到继承的属性中，以便在属性值发生变化时收到通知。属性观察者可以添加到任何属性中，无论它最初是否被定义为存储或计算属性。

## 定义基类

任何不从另一个类继承的类都被称为*基类*。

注意

Swift类不会从通用基类继承。您在不指定超类的情况下定义的类会自动成为供您构建的基类。

下面的示例定义了一个名为`Vehicle`的基类。该基类定义了一个名为`currentSpeed`存储属性，默认值为`0.0`（推断`Double`的属性类型）。`currentSpeed`属性的值被称为`description`的只读计算`String`属性用于创建车辆的描述。

`Vehicle`基类还定义了一个名为`makeNoise`的方法。此方法实际上对基本`Vehicle`实例不起作用，但稍后将由`Vehicle`子类自定义：

1. class Vehicle {
2. ​    var currentSpeed = 0.0
3. ​    var description: String {
4. ​        return "traveling at \(currentSpeed) miles per hour"
5. ​    }
6. ​    func makeNoise() {
7. ​        // do nothing - an arbitrary vehicle doesn't necessarily make a noise
8. ​    }
9. }

您创建一个带有*初始化器语法*的新`Vehicle`实例，该语法写为类型名称，后跟空括号：

1. let someVehicle = Vehicle()

创建新的`Vehicle`实例后，您可以访问其`description`属性，以打印车辆当前速度的人类可读描述：

1. print("Vehicle: \(someVehicle.description)")
2. // Vehicle: traveling at 0.0 miles per hour

`Vehicle`类定义了任意车辆的常见特征，但其本身没有多大用处。为了使其更有用，您需要对其进行细化，以描述更具体的车辆类型。

## 子分类

*子类*是将新类建立在现有类的基础上的行为。子类继承了现有类的特征，然后您可以对其进行细化。您还可以为子类添加新特征。

要指示子类有一个超类，请在超类名称之前写下子类名称，用冒号分隔：

1. class SomeSubclass: SomeSuperclass {
2. ​    // subclass definition goes here
3. }

以下示例定义了一个名为`Bicycle`的子类，具有超类`Vehicle`：

1. class Bicycle: Vehicle {
2. ​    var hasBasket = false
3. }

新的`Bicycle`类会自动获得`Vehicle`的所有特征，例如其`currentSpeed`和`description`属性及其`makeNoise()`方法。

除了继承的特征外，`Bicycle`类还定义了一个新的存储属性`hasBasket`，默认值为`false`（为该属性推断一种`Bool`类型）。

默认情况下，您创建的任何新`Bicycle`实例都不会有篮子。创建特定`Bicycle`实例后，您可以将该实例的`hasBasket`属性设置为`true`：

1. let bicycle = Bicycle()
2. bicycle.hasBasket = true

您还可以修改`Bicycle`实例的继承的`currentSpeed`属性，并查询实例的继承`description`属性：

1. bicycle.currentSpeed = 15.0
2. print("Bicycle: \(bicycle.description)")
3. // Bicycle: traveling at 15.0 miles per hour

子类本身可以被子类。下一个示例为被称为“串联”的双座自行车创建`Bicycle`子类：

1. class Tandem: Bicycle {
2. ​    var currentNumberOfPassengers = 0
3. }

`Tandem` inherits all of the properties and methods from `Bicycle`, which in turn inherits all of the properties and methods from `Vehicle`. The `Tandem` subclass also adds a new stored property called `currentNumberOfPassengers`, with a default value of `0`.

如果您创建`Tandem`实例，您可以处理其任何新的和继承的属性，并查询它从`Vehicle`继承的只读`description`属性：

1. let tandem = Tandem()
2. tandem.hasBasket = true
3. tandem.currentNumberOfPassengers = 2
4. tandem.currentSpeed = 22.0
5. print("Tandem: \(tandem.description)")
6. // Tandem: traveling at 22.0 miles per hour

## 压倒一切的

子类可以提供实例方法、类型方法、实例属性、类型属性或下标的自定义实现，否则它将从超类继承。这被称为*压倒一切*。

要覆盖否则会继承的特征，请在覆盖定义前加上`override`关键字。这样做会澄清您打算提供重写，并且没有错误地提供匹配的定义。意外覆盖可能会导致意外行为，任何没有`override`关键字的覆盖都会在编译代码时被诊断为错误。

`override`关键字还会提示Swift编译器检查重写类的超类（或其父类之一）的声明是否与您为重写提供的声明相匹配。此检查可确保您的重写定义正确无误。

### 访问超类方法、属性和下标

当您为子类提供方法、属性或下标覆盖时，有时使用现有的超类实现作为重写的一部分非常有用。例如，您可以细化该现有实现的行为，或将修改后的值存储在现有继承的变量中。

在适当的情况下，您可以使用`super`前缀访问方法、属性或下标的超类版本：

- 名为`someMethod()`重写方法可以通过在重写方法实现中调用`super.someMethod()`来调用`someMethod()`的超类版本。
- 名为`someProperty`的重写属性可以在重写getter或setter实现中以`super.someProperty`的形式访问`someProperty`的超类版本。
- `someIndex`的重写下标可以从重写下标实现中访问与`super[someIndex]`相同的下标的超类版本。

### 压倒一切的方法

您可以重写继承的实例或类型方法，以便在子类中提供方法的定制或替代实现。

以下示例定义了一个名为`Train`的新`Vehicle`子类，该子类覆盖了`Train`从`Vehicle`继承的`makeNoise()`方法：

1. class Train: Vehicle {
2. ​    override func makeNoise() {
3. ​        print("Choo Choo")
4. ​    }
5. }

如果您创建一个新的`Train`实例并调用其`makeNoise()`方法，您可以看到该方法的`Train`子类版本被调用：

1. let train = Train()
2. train.makeNoise()
3. // Prints "Choo Choo"

### 压倒一切的属性

您可以重写继承的实例或类型属性，为该属性提供自己的自定义获取器和设置器，或添加属性观察器，以使重写属性能够观察基础属性值何时更改。

#### 压倒一切的财产获取者和设定者

您可以提供自定义获取器（如果适用，并酌情提供设置器）来覆盖*任何*继承的属性，无论继承的属性是在源代码中实现为存储的还是计算属性。子类不知道继承属性的存储或计算性质——它只知道继承属性具有特定的名称和类型。您必须始终声明要重写的属性的名称和类型，以使编译器能够检查您的重写是否与具有相同名称和类型的超类属性匹配。

您可以通过在子类属性重写中同时提供获取器和设置器来将继承的只读属性呈现为读写属性。但是，您不能将继承的读写属性显示为只读属性。

注意

如果您提供设置器作为属性覆盖的一部分，您还必须为该覆盖提供获取器。如果您不想在覆盖getter中修改继承属性的值，只需从getter返回`super.someProperty`来传递继承的值，其中`someProperty`是您要重写的属性的名称。

以下示例定义了一个名为`Car`的新类，这是`Vehicle`的一个子类。TheCar类引入了一个新的存储属性，称为`gear`，默认整数值为1。TheCar类还覆盖了它从`Vehicle`继承的`description`属性，以提供包含当前齿轮的自定义描述：

1. class Car: Vehicle {
2. ​    var gear = 1
3. ​    override var description: String {
4. ​        return super.description + " in gear \(gear)"
5. ​    }
6. }

The override of the `description` property starts by calling `super.description`, which returns the `Vehicle` class’s `description` property. The `Car` class’s version of `description`then adds some extra text onto the end of this description to provide information about the current gear.

如果您创建`Car`类的实例并设置其`gear`和`currentSpeed`属性，您可以看到它的`description`属性返回在`Car`类中定义的定制描述：

1. let car = Car()
2. car.currentSpeed = 25.0
3. car.gear = 3
4. print("Car: \(car.description)")
5. // Car: traveling at 25.0 miles per hour in gear 3

#### 压倒一切的财产观察者

您可以使用属性重写将属性观察者添加到继承的属性中。这使您能够在继承属性的值发生变化时收到通知，无论该属性最初是如何实现的。有关财产观察员的更多信息，请参阅[财产观察员](https://docs.swift.org/swift-book/LanguageGuide/Properties.html#ID262)。

注意

您无法将属性观察者添加到继承的常量存储属性或继承的只读计算属性。无法设置这些属性的值，因此不宜提供将`willSet`或`didSet`实现作为重写的一部分。

另请注意，您无法同时提供同一属性的重写设置器和重写属性观察器。如果您想观察属性值的变化，并且您已经在为该属性提供自定义设置器，您可以简单地从自定义设置器中观察任何值更改。

以下示例定义了一个名为`AutomaticCar`的新类，这是`Car`的一个子类。`AutomaticCar`类表示带有自动变速箱的汽车，该变速箱根据当前速度自动选择要使用的适当齿轮：

1. class AutomaticCar: Car {
2. ​    override var currentSpeed: Double {
3. ​        didSet {
4. ​            gear = Int(currentSpeed / 10.0) + 1
5. ​        }
6. ​    }
7. }

每当您设置`AutomaticCar`实例的`currentSpeed`属性时，该属性的sdidSet观察器都会将实例的`gear`属性设置为新速度的适当齿轮选择。具体来说，属性观察者选择一个新的`currentSpeed`值除以10的齿轮，四舍五入到最近的整数，加上1。`35.0`的速度产生`4`的齿轮：

1. let automatic = AutomaticCar()
2. automatic.currentSpeed = 35.0
3. print("AutomaticCar: \(automatic.description)")
4. // AutomaticCar: traveling at 35.0 miles per hour in gear 4

## 防止重写

You can prevent a method, property, or subscript from being overridden by marking it as *final*. Do this by writing the `final` modifier before the method, property, or subscript’s introducer keyword (such as `final var`, `final func`, `final class func`, and `final subscript`).

任何在子类中重写最终方法、属性或下标的尝试都将报告为编译时错误。您添加到扩展类的方法、属性或下标也可以在扩展的定义中标记为最终。

您可以通过在类定义（`finalclass`）中的`class`关键字之前编写`final`修饰符，将整个类标记为最终修饰语。任何对最终类进行子类的尝试都将报告为编译时错误。