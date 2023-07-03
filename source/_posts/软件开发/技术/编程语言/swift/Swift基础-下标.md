---
title: Swift基础 下标
tags:
    - swift
    - 基础
categories:
    - 技术
date: 2022-07-01 12:01:01
thumbnail:
---

翻译自：https://docs.swift.org/swift-book/LanguageGuide/Subscripts.html

类、结构和枚举可以定义*下标*，下标是访问集合、列表或序列成员元素的快捷方式。您可以使用下标按索引设置和检索值，而无需单独的设置和检索方法。例如，您可以以`someArray[index]`的形式访问数`Array`实例中的元素，以`someDictionary[key]`的形式访问aDictionary实例中的元素。

您可以为单个类型定义多个下标，并根据您传递给下标的索引值类型选择要使用的相应下标重载。下标不限于单个维度，您可以使用多个输入参数定义下标，以满足自定义类型的需求。

## 下标语法

下标使您能够通过在实例名称后的方括号中写入一个或多个值来查询类型的实例。它们的语法与实例方法语法和计算属性语法相似。您使用下标关键字编写下标定义，并以与实例方法相同的方式指定一个或多个输入参数和返回类型。与实例方法不同，下标可以是读写或只读。此行为由获取者和设置器以与计算属性相同的方式进行通信：

1. subscript(index: Int) -> Int {
2. ​    get {
3. ​        // Return an appropriate subscript value here.
4. ​    }
5. ​    set(newValue) {
6. ​        // Perform a suitable setting action here.
7. ​    }
8. }

`newValue`的类型与下标的返回值相同。与计算属性一样，您可以选择不指定setter的`(newValue)`参数。如果您自己不提供一个名为`newValue`默认参数，则会向您的设置器提供一个参数。

与只读计算属性一样，您可以通过删除`get`关键字及其大括号来简化只读下标的声明：

1. subscript(index: Int) -> Int {
2. ​    // Return an appropriate subscript value here.
3. }

以下是只读下标实现的示例，它定义了一个`TimesTable`结构来表示整数的*n*次表：

1. struct TimesTable {
2. ​    let multiplier: Int
3. ​    subscript(index: Int) -> Int {
4. ​        return multiplier * index
5. ​    }
6. }
7. let threeTimesTable = TimesTable(multiplier: 3)
8. print("six times three is \(threeTimesTable[6])")
9. // Prints "six times three is 18"

在本例中，创建了一个新的`TimesTable`实例来表示三倍表。这通过将值`3`传递给结构的`initializer`作为用于实例`multiplier`参数的值来表示。

您可以通过调用其下标来查询`threeTimesTable`实例，如对`threeTimesTable[6]`的调用所示。这要求三倍表中的第六个条目，返回值为18或`3`乘以6。

注意

*n*-times表基于固定的数学规则。将`threeTimesTable[someIndex]`设置为新值是不合适的，因此`TimesTable`的下标被定义为只读下标。

## 下标用法

“下标”的确切含义取决于其使用的上下文。下标通常用作访问集合、列表或序列中成员元素的快捷方式。您可以自由地以最适合您特定类或结构功能的方式实现下标。

例如，Swift的`Dictionary`类型实现了下标来设置和检索存储在`Dictionary`实例中的值。您可以通过在下标括号中提供字典键类型的键并将字典值类型的值分配给下标来在字典中设置值：

1. var numberOfLegs = ["spider": 8, "ant": 6, "cat": 4]
2. numberOfLegs["bird"] = 2

The example above defines a variable called `numberOfLegs` and initializes it with a dictionary literal containing three key-value pairs. The type of the `numberOfLegs` dictionary is inferred to be `[String: Int]`. After creating the dictionary, this example uses subscript assignment to add a `String` key of `"bird"` and an `Int` value of `2` to the dictionary.

有关`Dictionary`下标的更多信息，请参阅[访问和修改词典](https://docs.swift.org/swift-book/LanguageGuide/CollectionTypes.html#ID116)。

注意

Swift的`Dictionary`类型将其键值下标实现为接受并返回*可选*类型的下标。对于上面的`numberOfLegs`字典，键值下标接受并返回类型为`Int?`或“可选int”的值。`Dictionary`类型使用可选的下标类型来模拟并非每个键都有一个值的事实，并通过为该键分配一个`nil`值来为该值来提供删除该值的方法。

## 下标选项

下标可以接受任意数量的输入参数，这些输入参数可以是任何类型的。下标也可以返回任何类型的值。

与函数一样，下标可以获取不同数量的参数，并为其参数提供默认值，如[变量参数](https://docs.swift.org/swift-book/LanguageGuide/Functions.html#ID171)和[默认参数值](https://docs.swift.org/swift-book/LanguageGuide/Functions.html#ID169)中所述。然而，与函数不同，下标不能使用输入输出参数。

类或结构可以根据需要提供尽可能多的下标实现，并将根据使用下标时下标括号中包含的值的类型推断要使用的适当下标。多个下标的定义称为*下标重载*。

虽然下标取单个参数最常见，但如果适合您的类型，您也可以定义具有多个参数的下标。以下示例定义了一个`Matrix`结构，它表示`Double`值的二维矩阵。`Matrix`结构的下标需要两个整数参数：

1. struct Matrix {
2. ​    let rows: Int, columns: Int
3. ​    var grid: [Double]
4. ​    init(rows: Int, columns: Int) {
5. ​        self.rows = rows
6. ​        self.columns = columns
7. ​        grid = Array(repeating: 0.0, count: rows * columns)
8. ​    }
9. ​    func indexIsValid(row: Int, column: Int) -> Bool {
10. ​        return row >= 0 && row < rows && column >= 0 && column < columns
11. ​    }
12. ​    subscript(row: Int, column: Int) -> Double {
13. ​        get {
14. ​            assert(indexIsValid(row: row, column: column), "Index out of range")
15. ​            return grid[(row * columns) + column]
16. ​        }
17. ​        set {
18. ​            assert(indexIsValid(row: row, column: column), "Index out of range")
19. ​            grid[(row * columns) + column] = newValue
20. ​        }
21. ​    }
22. }

`Matrix`提供了一个初始化器，该初始化器接受两个称为`rows`和`columns`参数，并创建一个足够大的数组来存储类型为`Double`的`rows*columns`值。矩阵中的每个位置的初始值为`0.0`。为了实现这一目标，数组的大小和`0.0`的初始单元格值被传递给数组初始化器，该初始化器创建和初始化正确大小的新数组。此初始化器在[创建具有默认值的数组](https://docs.swift.org/swift-book/LanguageGuide/CollectionTypes.html#ID501)中[进行了](https://docs.swift.org/swift-book/LanguageGuide/CollectionTypes.html#ID501)更详细的描述。

您可以通过将适当的行和列计数传递给其初始化器来构建新的`Matrix`实例：

1. var matrix = Matrix(rows: 2, columns: 2)

上面的示例创建一个具有两行和两列的新`Matrix`实例。此`Matrix`实例的`grid`数组实际上是矩阵的扁平版本，从左上角读取到右下角：

![../_images/subscriptMatrix01_2x.png](https://file.pandacode.cn/blog/202204051610262.png)

矩阵中的值可以通过将行和列值传递到下标中来设置，并用逗号分隔：

1. matrix[0, 1] = 1.5
2. matrix[1, 0] = 3.2

这两个语句调用下标的设置器，在矩阵的右上角位置设置`1.5`（`row``0`，`column`1），在左下角位置设置`3.2`（`row``1`，`column``0`）：

![../_images/subscriptMatrix02_2x.png](https://file.pandacode.cn/blog/202204051611092.png)

`Matrix`下标的获取器和设置器都包含一个断言，以检查下标的`row`和`column`值是否有效。为了帮助这些断言，`Matrix`包括一种名为`indexIsValid(row:column:)`的方便方法，该方法检查请求的`row`和`column`是否在矩阵的边界内：

1. func indexIsValid(row: Int, column: Int) -> Bool {
2. ​    return row >= 0 && row < rows && column >= 0 && column < columns
3. }

如果您尝试访问矩阵边界之外的下标，则会触发断言：

1. let someValue = matrix[2, 2]
2. // This triggers an assert, because [2, 2] is outside of the matrix bounds.

## 键入下标

如上所述，实例下标是您在特定类型的实例上调用的下标。您还可以定义在类型本身上调用的下标。这种下标被称为*类型下标*。您可以通过在下标关键字之前写静态关键字来指示类型`subscript`。类可以使用`class`关键字，以允许子类覆盖超类对该下标的实现。下面的示例显示了您如何定义和调用类型下标：

1. enum Planet: Int {
2. ​    case mercury = 1, venus, earth, mars, jupiter, saturn, uranus, neptune
3. ​    static subscript(n: Int) -> Planet {
4. ​        return Planet(rawValue: n)!
5. ​    }
6. }
7. let mars = Planet[4]
8. print(mars)