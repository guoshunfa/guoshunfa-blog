---
title: Swift基础 自动参考计数
tags:
    - swift
    - 基础
categories:
    - 技术
date: 2022-07-01 12:01:01
thumbnail:
---

翻译自：https://docs.swift.org/swift-book/LanguageGuide/AutomaticReferenceCounting.html

Swift 使用*自动参考计数* (ARC) 来跟踪和管理 app 的内存使用情况。在大多数情况下，这意味着内存管理在Swift中“有效”，您无需自己考虑内存管理。当不再需要类实例时，ARC会自动释放类实例使用的内存。

然而，在少数情况下，ARC需要有关代码部分之间关系的更多信息，以便为您管理内存。本章介绍了这些情况，并展示了如何启用ARC来管理应用程序的所有内存。在Swift中使用ARC与[过渡到ARC发布说明](https://developer.apple.com/library/content/releasenotes/ObjectiveC/RN-TransitioningToARC/Introduction/Introduction.html)中描述的将ARC与Objective-C一起使用的方法非常相似。

引用计数仅适用于类实例。结构和枚举是值类型，而不是引用类型，不会通过引用存储和传递。

## ARC的工作原理

每次您创建类的新实例时，ARC都会分配一大块内存来存储有关该实例的信息。此内存包含有关实例类型的信息，以及与该实例关联的任何存储属性的值。

此外，当不再需要实例时，ARC会释放该实例使用的内存，以便将内存用于其他目的。这确保了类实例在不再需要时不会占用内存空间。

但是，如果ARC要处理仍在使用的实例，将无法再访问该实例的属性或调用该实例的方法。事实上，如果您尝试访问该实例，您的应用程序很可能会崩溃。

为了确保实例在仍然需要时不会消失，ARC跟踪当前引用每个类实例的属性、常量和变量数量。只要至少存在对实例的至少一个活动引用，ARC就不会处理该实例。

为了做到这一点，每当您将类实例分配给属性、常量或变量时，该属性、常量或变量都会*强烈引用*该实例。该引用被称为“强”引用，因为它牢牢抓住该实例，只要该强引用仍然存在，就不允许将其交易。

## ARC在行动

以下是自动引用计数工作原理的示例。此示例从一个名为`Person`的简单类开始，该类定义了一个名为`name`的存储常量属性：

1. class Person {
2. ​    let name: String
3. ​    init(name: String) {
4. ​        self.name = name
5. ​        print("\(name) is being initialized")
6. ​    }
7. ​    deinit {
8. ​        print("\(name) is being deinitialized")
9. ​    }
10. }

`Person`类有一个初始化器，可以设置实例的`name`属性，并打印一条消息来指示初始化正在进行中。`Person`类还有一个去初始化器，当类的实例被释放时，它会打印消息。

下一个代码片段定义了类型为`Person?`的三个变量，用于在后续代码片段中设置对新`Person`实例的多个引用。由于这些变量是可选类型（`Person?`，而不是`Person`），它们会自动初始化，值为`nil`，目前不引用`Person`实例。

1. var reference1: Person?
2. var reference2: Person?
3. var reference3: Person?

您现在可以创建一个新的`Person`实例，并将其分配给以下三个变量之一：

1. reference1 = Person(name: "John Appleseed")
2. // Prints "John Appleseed is being initialized"

Note that the message `"John Appleseed is being initialized"` is printed at the point that you call the `Person` class’s initializer. This confirms that initialization has taken place.

由于新的`Person`实例已分配给`reference1`变量，因此现在`reference1`对新`Person`实例有强烈引用。由于至少有一个强有力的参考，ARC确保这个人被保存在记忆中，并且没有被释放。

如果您将同一`Person`实例分配给另外两个变量，则会建立对该实例的两个更强引用：

1. reference2 = reference1
2. reference3 = reference1

现在*有三个*强烈的引用这个单一`Person`实例。

如果您通过将`nil`配给其中两个变量来破坏其中两个强引用（包括原始引用），则将保留一个强引用，并且`Person`实例未被释放：

1. reference1 = nil
2. reference2 = nil

在第三个也是最后一个强引用被破坏之前，ARC不会处理`Person`实例，此时很明显您不再使用`Person`实例：

1. reference3 = nil
2. // Prints "John Appleseed is being deinitialized"

## 类实例之间的较强参考周期

在上面的示例中，ARC能够跟踪您创建的新`Person`实例的引用数量，并在不再需要时处理该`Person`实例。

然而，可以编写类实例*永远不会*达到零强引用的代码。如果两个类实例彼此保持强烈引用，这样每个实例都会保持另一个实例的活力，则会发生这种情况。这被称为*强参考周期*。

您通过将类之间的一些关系定义为弱引用或无名引用而不是强引用来解决强引用周期。这个过程在[解决类实例之间的强引用周期中](https://docs.swift.org/swift-book/LanguageGuide/AutomaticReferenceCounting.html#ID52)进行了描述。然而，在您学习如何解决强参考周期之前，了解这种周期是如何导致的非常有用。

Here’s an example of how a strong reference cycle can be created by accident. This example defines two classes called `Person` and `Apartment`, which model a block of apartments and its residents:

1. class Person {
2. ​    let name: String
3. ​    init(name: String) { self.name = name }
4. ​    var apartment: Apartment?
5. ​    deinit { print("\(name) is being deinitialized") }
6. }
7. 
8. class Apartment {
9. ​    let unit: String
10. ​    init(unit: String) { self.unit = unit }
11. ​    var tenant: Person?
12. ​    deinit { print("Apartment \(unit) is being deinitialized") }
13. }

每个`Person`实例都有一个`String`类型的`name`属性和一个最初为`nil`可选`apartment`属性。`apartment`物业是可选的，因为一个人可能并不总是有公寓。

同样，每个`Apartment`实例都有一个`String`类型的`unit`属性，并且有一个最初为`nil`的可选`tenant`属性。租户物业是可选的，因为公寓可能并不总是有租户。

这两个类还定义了一个去初始化器，该初始化器打印了该类的实例正在被非初始化的事实。这使您能够查看`Person`和`Apartment`的实例是否按预期进行处理。

下一个代码片段定义了两个可选类型的变量，称为`john`和`unit4A`，这些变量将设置为下面的特定`Apartment`和`Person`实例。由于是可选的，这两个变量的初始值为`nil`：

1. var john: Person?
2. var unit4A: Apartment?

您现在可以创建特定的`Person`实例和`Apartment`实例，并将这些新实例分配给`john`和`unit4A`变量：

1. john = Person(name: "John Appleseed")
2. unit4A = Apartment(unit: "4A")

以下是创建和分配这两个实例后强引用的外观。`john`变量现在强烈引用新的`Person`实例，`unit4A`变量强烈引用新的`Apartment`实例：

![../_images/referenceCycle01_2x.png](https://docs.swift.org/swift-book/_images/referenceCycle01_2x.png)

您现在可以将这两个实例链接在一起，以便该人拥有公寓，而公寓则拥有租户。请注意，感叹号 (`!`)用于解开和访问存储在`john`和`unit4A`可选变量中的实例，以便可以设置这些实例的属性：

1. john!.apartment = unit4A
2. unit4A!.tenant = john

以下是将两个实例链接在一起后强引用的外观：

![../_images/referenceCycle02_2x.png](https://docs.swift.org/swift-book/_images/referenceCycle02_2x.png)

不幸的是，将这两个实例联系起来会在它们之间产生强大的参考周期。`Person`实例现在强烈引用`Apartment`实例，`Apartment`实例强烈引用`Person`实例。因此，当您打破`john`和`unit4A`变量持有的强引用时，引用计数不会降至零，并且实例也不会由ARC分配：

1. john = nil
2. unit4A = nil

请注意，当您将这两个变量设置为`nil`时，两者都不调用非初始化器。强大的参考周期可防止`Person`和`Apartment`实例被释放，导致应用程序内存泄漏。

以下是将`john`和`unit4A`变量设置为`nil`后强引用的外观：

![../_images/referenceCycle03_2x.png](https://docs.swift.org/swift-book/_images/referenceCycle03_2x.png)

`Person`实例和`Apartment`实例之间的强烈引用仍然存在，不能被打破。

## 解决类实例之间的强引用周期

当您处理类类型的属性时，Swift提供了两种解决强引用周期的方法：弱引用和无名引用。

弱和无拥有引用使参考周期中的一个实例能够引用另一个实例，*而无需*强势控制它。然后，这些实例可以相互引用，而不会创建强大的参考周期。

当另一个实例的生命周期较短时，即当另一个实例可以首先进行交易时，请使用弱引用。在上面的`Apartment`示例中，公寓在其生命周期的某个阶段没有租户是合适的，因此在这种情况下，弱参考是打破参考周期的适当方式。相比之下，当另一个实例具有相同的生命周期或更长的生命周期时，请使用非拥有的引用。

### 弱引用

*弱引用*是一种引用，它不会强烈保留它所指的实例，因此不会阻止ARC处理引用的实例。此行为阻止引用成为强引用周期的一部分。您可以通过将`weak`关键字放在属性或变量声明之前来指示弱引用。

由于弱引用不能强力保留其引用的实例，因此当弱引用仍在引用时，该实例可能会被释放。因此，当它引用的实例被释放时，ARC会自动将弱引用设置为`nil`。而且，由于弱引用需要允许其值在运行时更改为`nil`，因此它们总是声明为可选类型的变量，而不是常量。

您可以像任何其他可选值一样，检查弱引用中是否存在值，并且您永远不会引用不再存在的无效实例。

注意

当ARC将弱引用设置为`nil`时，不会调用属性观察者。

下面的示例与上面的`Person`和`Apartment`示例相同，有一个重要的区别。这一次，`Apartment`类型的`tenant`物业被宣布为薄弱的参考：

1. class Person {
2. ​    let name: String
3. ​    init(name: String) { self.name = name }
4. ​    var apartment: Apartment?
5. ​    deinit { print("\(name) is being deinitialized") }
6. }
7. 
8. class Apartment {
9. ​    let unit: String
10. ​    init(unit: String) { self.unit = unit }
11. ​    weak var tenant: Person?
12. ​    deinit { print("Apartment \(unit) is being deinitialized") }
13. }

来自两个变量（`john`和`unit4A`）的强引用以及两个实例之间的联系与以前一样创建：

1. var john: Person?
2. var unit4A: Apartment?
3. 
4. john = Person(name: "John Appleseed")
5. unit4A = Apartment(unit: "4A")
6. 
7. john!.apartment = unit4A
8. unit4A!.tenant = john

现在您已将这两个实例链接在一起，参考资料的外观如下：

![../_images/weakReference01_2x.png](https://docs.swift.org/swift-book/_images/weakReference01_2x.png)

`Person`实例仍然对`Apartment`实例有很强的引用，但`Apartment`实例现在对`Person`实例的引用*很弱*。这意味着，当您通过将`john`变量设置为`nil`来破坏其持有的强引用时，对`Person`实例不再有更强引用：

1. john = nil
2. // Prints "John Appleseed is being deinitialized"

由于没有更强烈的引用`Person`实例，因此它被分配，`tenant`属性设置为`nil`：

![../_images/weakReference02_2x.png](https://docs.swift.org/swift-book/_images/weakReference02_2x.png)

对`Apartment`实例的唯一强烈引用来自`unit4A`变量。如果您打破了*该*强引用，则不再有对`Apartment`实例的强引用：

1. unit4A = nil
2. // Prints "Apartment 4A is being deinitialized"

由于没有更强烈的`Apartment`实例，所以它也被分配了：

![../_images/weakReference03_2x.png](https://docs.swift.org/swift-book/_images/weakReference03_2x.png)

注意

在使用垃圾收集的系统中，有时使用弱指针来实现简单的缓存机制，因为只有当内存压力触发垃圾收集时，才会释放没有强引用的对象。然而，对于ARC，值在删除其最后一个强引用后立即进行分配，这使得弱引用不适合此目的。

### 未知参考资料

与弱引用一样，*无拥有引用*不会强烈保留其引用的实例。然而，与弱引用不同，当另一个实例具有相同或更长的生命周期时，会使用非拥有引用。您可以通过将非`unowned`关键字放在属性或变量声明之前来指示非所有引用。

与弱引用不同，无拥有引用应该始终具有值。因此，将值标记为非所有值并不使其成为可选的，ARC永远不会将无拥有引用的值设置为`nil`。

重要

仅当您确定引用*总是*引用未被释放的实例时，才使用非拥有的引用。

如果您在实例被释放后尝试访问该实例的值，您将收到一个运行时错误。

以下示例定义了两个类别，`Customer`和`CreditCard`，它们为银行客户建模，并为该客户建模可能的信用卡。这两个类都存储另一个类的实例作为属性。这种关系有可能创造一个强大的参考周期。

`Customer`和`CreditCard`之间的关系与上面薄弱的参考示例中看到的`Apartment`和`Person`之间的关系略有不同。在这种数据模型中，客户可能有也可能没有信用卡，但信用卡将*始终*与客户相关联。`CreditCard`实例永远不会比它所指`Customer`长寿。为了表示这一点，`Customer`类有一个可选的`card`属性，但`CreditCard`类有一个非拥有（和非可选）`customer`属性。

此外，新的`CreditCard`实例*只能*通过将`number`值和`customer`实例传递给自定义`CreditCard`初始化器来创建。这确保了在创建信用卡实例时，`CreditCard`实例始终有一个`customer`实例相关联。

由于信用卡总是有客户，因此您可以将其`customer`财产定义为非所有权参考，以避免强大的参考周期：

1. class Customer {
2. ​    let name: String
3. ​    var card: CreditCard?
4. ​    init(name: String) {
5. ​        self.name = name
6. ​    }
7. ​    deinit { print("\(name) is being deinitialized") }
8. }
9. 
10. class CreditCard {
11. ​    let number: UInt64
12. ​    unowned let customer: Customer
13. ​    init(number: UInt64, customer: Customer) {
14. ​        self.number = number
15. ​        self.customer = customer
16. ​    }
17. ​    deinit { print("Card #\(number) is being deinitialized") }
18. }

注意

`CreditCard`类`number`属性使用`UInt64`而不是`Int`来定义，以确保`number`属性的容量足够大，可以在32位和64位系统上存储16位卡号。

下一个代码片段定义了一个名为`john`可选`Customer`变量，该变量将用于存储对特定客户的引用。由于该变量是可选的，其初始值为零：

1. var john: Customer?

您现在可以创建一个`Customer`实例，并使用它来初始化和分配一个新的`CreditCard`实例作为该客户的`card`属性：

1. john = Customer(name: "John Appleseed")
2. john!.card = CreditCard(number: 1234_5678_9012_3456, customer: john!)

现在您已经链接了这两个实例，参考资料的外观如下：

![../_images/unownedReference01_2x.png](https://docs.swift.org/swift-book/_images/unownedReference01_2x.png)

`Customer`实例现在对`CreditCard`实例有强烈引用，`CreditCard`实例对`Customer`实例有非所有引用。

由于非拥有`customer`引用，当您破坏`john`变量持有的强引用时，对`Customer`实例没有更强的引用：

![../_images/unownedReference02_2x.png](https://docs.swift.org/swift-book/_images/unownedReference02_2x.png)

由于没有对`Customer`实例的更强烈引用，因此它被交易了。发生这种情况后，没有对`CreditCard`实例的更强烈引用，它也被交易：

1. john = nil
2. // Prints "John Appleseed is being deinitialized"
3. // Prints "Card #1234567890123456 is being deinitialized"

上面的最终代码片段显示，`Customer`实例和`CreditCard`实例的去初始化器都在`john`变量设置为吨位后打印其“非初始化”消息。

注意

上面的示例展示了如何使用*安全的*非所有引用。Swift 还针对需要停用运行时安全检查（例如出于性能原因）的情形，提供了*不安全的*不拥有的参考。与所有不安全操作一样，您有责任检查该代码是否安全。

您通过写无`unowned(unsafe)`表示不安全的无名引用。如果您在引用的实例被释放后尝试访问不安全的无有引用，您的程序将尝试访问实例曾经所在的内存位置，这是一个不安全的操作。

### 未拥有的可选参考资料

您可以将类的可选引用标记为非拥有。就ARC所有权模型而言，无主可选引用和弱引用都可以在同一上下文中使用。区别在于，当您使用非拥有的可选引用时，您有责任确保它始终引用有效对象或设置为`nil`。

以下是跟踪学校特定部门提供的课程的示例：

1. class Department {
2. ​    var name: String
3. ​    var courses: [Course]
4. ​    init(name: String) {
5. ​        self.name = name
6. ​        self.courses = []
7. ​    }
8. }
9. 
10. class Course {
11. ​    var name: String
12. ​    unowned var department: Department
13. ​    unowned var nextCourse: Course?
14. ​    init(name: String, in department: Department) {
15. ​        self.name = name
16. ​        self.department = department
17. ​        self.nextCourse = nil
18. ​    }
19. }

`Department`对部门提供的每门课程都保持强有力的参考。在ARC所有权模式中，一个部门拥有自己的课程。`Course`有两个非自主参考资料，一个是系参考资料，另一个是学生应该参加的下一门课程；一门课程不拥有其中任何一个对象。每门课程都是某个部门的一部分，因此`department`属性不是可选的。然而，由于一些课程没有推荐的后续课程，`nextCourse`属性是可选的。

以下是使用这些类的示例：

1. let department = Department(name: "Horticulture")
2. 
3. let intro = Course(name: "Survey of Plants", in: department)
4. let intermediate = Course(name: "Growing Common Herbs", in: department)
5. let advanced = Course(name: "Caring for Tropical Plants", in: department)
6. 
7. intro.nextCourse = intermediate
8. intermediate.nextCourse = advanced
9. department.courses = [intro, intermediate, advanced]

上面的代码创建了一个部门及其三门课程。入门课程和中级课程都有一个建议的下一门课程存储在`nextCourse`属性中，该属性保留了学生在完成该课程后应该学习的课程的无选择参考。

![../_images/unownedOptionalReference_2x.png](https://docs.swift.org/swift-book/_images/unownedOptionalReference_2x.png)

无人任用引用不会强烈保留其包装的类实例，因此不会阻止ARC对实例进行交易。它的行为与ARC下的无名引用相同，只是无拥有的可选引用可以benil。

Like non-optional unowned references, you’re responsible for ensuring that `nextCourse`always refers to a course that hasn’t been deallocated. In this case, for example, when you delete a course from `department.courses` you also need to remove any references to it that other courses might have.

注意

可选值的基础类型是`Optional`，这是Swift标准库中的枚举。然而，可选是值类型不能用`unowned`标记的规则的例外。

包装类的可选内容不使用引用计数，因此您不需要对可选的强烈引用。

### 未拥有的引用和隐式解开的可选属性

上面弱引用和无名引用的示例涵盖了两个更常见的场景，在这两个场景中，有必要打破强引用周期。

`Person`和`Apartment`示例显示了两种财产（均为`nil`）可能导致强烈参考周期的情况。最好在参考较弱的情况下解决此情景。

`Customer`和`CreditCard`示例显示了一种情况，即一个允许为`nil`的属性和另一个不能为`nil`的属性可能会导致强大的参考周期。最好通过非自有参考来解决这个问题。

然而，还有第三种情况，在这种情况下，*两个*属性都应该始终有一个值，一旦初始化完成，这两个属性都不应该为`nil`。在这种情况下，将一个类上的非所有属性与另一个类上隐式解包装的可选属性相结合是有用的。

这使初始化完成后可以直接访问两个属性（无需可选的展开），同时仍然避免引用周期。本节向您展示如何建立这种关系。

以下示例定义了两个类，`Country`和`City`，每个类都存储另一个类的实例作为属性。在这个数据模型中，每个国家必须始终拥有一个首都，每个城市必须始终属于一个国家。为了代表这一点，`Country`级有一个`capitalCity`财产，`City`阶级有一个`country`财产：

1. class Country {
2. ​    let name: String
3. ​    var capitalCity: City!
4. ​    init(name: String, capitalName: String) {
5. ​        self.name = name
6. ​        self.capitalCity = City(name: capitalName, country: self)
7. ​    }
8. }
9. 
10. class City {
11. ​    let name: String
12. ​    unowned let country: Country
13. ​    init(name: String, country: Country) {
14. ​        self.name = name
15. ​        self.country = country
16. ​    }
17. }

为了在两个类之间建立相互依存关系，`City`的初始化器采用一个国家实例，并将该实例存储在其`country`属性中。

`City`的初始化器从`Country`的初始化器中调用。但是，在新的`Country`实例完全初始化之前，`Country`的初始化器无法将`self`传递给`City`初始化器，如[两阶段初始化](https://docs.swift.org/swift-book/LanguageGuide/Initialization.html#ID220)中所述。

为了满足这一要求，您声明`Country`的`capitalCity`财产为隐式未包装的可选属性，由其类型注释（`City!`）末尾的感叹号表示。这意味着，与任何其他可选属性一样，`capitalCity`属性的默认值为`nil`，但无需按照[隐式未包装选项](https://docs.swift.org/swift-book/LanguageGuide/TheBasics.html#ID334)所述打开其值即可访问。

Because `capitalCity` has a default `nil` value, a new `Country` instance is considered fully initialized as soon as the `Country` instance sets its `name` property within its initializer. This means that the `Country` initializer can start to reference and pass around the implicit `self`property as soon as the `name` property is set. The `Country` initializer can therefore pass `self`as one of the parameters for the `City` initializer when the `Country` initializer is setting its own `capitalCity` property.

所有这些都意味着您可以在单个语句中创建`Country`和`City`实例，而无需创建强大的参考周期，并且可以直接访问`capitalCity`属性，而无需使用感叹号来解开其可选值：

1. var country = Country(name: "Canada", capitalName: "Ottawa")
2. print("\(country.name)'s capital city is called \(country.capitalCity.name)")
3. // Prints "Canada's capital city is called Ottawa"

在上面的示例中，使用隐式未包装的可选选项意味着满足所有两相类初始化器要求。一旦初始化完成，`capitalCity`属性可以像非可选值一样使用和访问，同时仍然避免了强大的参考周期。

## 关闭的强参考周期

您在上面看到了当两个类实例属性相互保持强引用时，如何创建强引用周期。您还看到了如何使用弱引用和无名引用来打破这些强引用周期。

如果您为类实例的属性分配闭包，并且该闭包的主体捕获实例，也可能发生强引用周期。发生此捕获可能是因为闭包的主体访问实例的属性，如`self.someProperty`，或者因为闭包调用实例上的方法，如`self.someMethod()`。无论哪种情况，这些访问都会导致闭包“捕获”`self`，从而创建一个强大的参考周期。

出现这种强大的参考周期是因为闭包与类一样是*引用类型*。当您为属性分配闭包时，您将为该闭包分配*引用*。从本质上讲，这是与上面相同的问题——两个强有力的引用让彼此保持活力。然而，这次不是两个类实例，而是一个类实例和一个闭包，它们让彼此保持活力。

Swift为这个问题提供了一个优雅的解决方案，称为*闭包捕获列表*。然而，在您学习如何通过闭包捕获列表打破强大的参考周期之前，了解如何导致这样的循环是有用的。

下面的示例展示了在使用引用`self`的闭包时如何创建强引用周期。此示例定义了一个名为`HTMLElement`类，该类为HTML文档中的单个元素提供了一个简单的模型：

1. class HTMLElement {
2. 
3. ​    let name: String
4. ​    let text: String?
5. 
6. ​    lazy var asHTML: () -> String = {
7. ​        if let text = self.text {
8. ​            return "<\(self.name)>\(text)</\(self.name)>"
9. ​        } else {
10. ​            return "<\(self.name) />"
11. ​        }
12. ​    }
13. 
14. ​    init(name: String, text: String? = nil) {
15. ​        self.name = name
16. ​        self.text = text
17. ​    }
18. 
19. ​    deinit {
20. ​        print("\(name) is being deinitialized")
21. ​    }
22. 
23. }

`HTMLElement`类定义了一个`name`属性，该属性指示元素的名称，例如标题元素的`"h1"`”，段落元素的`"p"`换行符元素的`"br"`”。`HTMLElement`还定义了一个可选的`text`属性，您可以将其设置为表示在该HTML元素中渲染的文本的字符串。

除了这两个简单的属性外，`HTMLElement`类还定义了一个名为`asHTML`惰性属性。此属性引用将`name`和`text`组合成HTML字符串片段的闭包。`asHTML`属性类型为`()->String`，或“不接受参数并返回`String`值的函数”。

By default, the `asHTML` property is assigned a closure that returns a string representation of an HTML tag. This tag contains the optional `text` value if it exists, or no text content if `text`doesn’t exist. For a paragraph element, the closure would return `"<p>some text</p>"` or `"<p />"`, depending on whether the `text` property equals `"some text"` or `nil`.

`asHTML`属性的命名和使用有点像实例方法。但是，由于`asHTML`是一个闭包属性，而不是实例方法，如果您想更改特定HTML元素的HTML渲染，您可以将`asHTML`属性的默认值替换为自定义闭包。

例如，如果`text`属性为`nil`，则可以将`asHTML`属性设置为默认为某些文本的闭包，以防止表示返回空的HTML标签：

1. let heading = HTMLElement(name: "h1")
2. let defaultText = "some default text"
3. heading.asHTML = {
4. ​    return "<\(heading.name)>\(heading.text ?? defaultText)</\(heading.name)>"
5. }
6. print(heading.asHTML())
7. // Prints "<h1>some default text</h1>"

注意

`asHTML`属性被声明为惰性属性，因为只有当元素实际上需要渲染为某些HTML输出目标的字符串值时，才需要它。`asHTML`是一个惰性属性，这意味着您可以在默认闭包中引用`self`，因为在初始化完成并已知`self`存在之前，才会访问惰性属性。

`HTMLElement`类提供了一个初始化器，它使用`name`参数和（如果需要）`text`参数来初始化新元素。该类还定义了一个去初始化器，该初始化器打印一条消息，以便在`HTMLElement`实例被释放时显示。

以下是您如何使用`HTMLElement`类创建和打印新实例的方法：

1. var paragraph: HTMLElement? = HTMLElement(name: "p", text: "hello, world")
2. print(paragraph!.asHTML())
3. // Prints "<p>hello, world</p>"

注意

上面的`paragraph`变量被定义为*可选*的`HTMLElement`，因此可以将其设置为`nil`，以证明存在强引用周期。

不幸的是，如上所述，`HTMLElement`类在`HTMLElement`实例和用于其默认为`asHTML`值的闭包之间创建了强大的参考周期。以下是周期的外观：

![../_images/closureReferenceCycle01_2x.png](https://docs.swift.org/swift-book/_images/closureReferenceCycle01_2x.png)

实例的`asHTML`属性对其闭包有很强的引用。然而，由于闭包在其主体内引用`self`（作为引用`self.name`和`self.text`的一种方式），闭包*捕获*self，这意味着它具有对`HTMLElement`实例的强烈引用。两者之间创造了一个强大的参考周期。（有关在闭包中捕获值的更多信息，请参阅[捕获值](https://docs.swift.org/swift-book/LanguageGuide/Closures.html#ID103)。）

注意

尽管闭包多次引用`self`，但它只捕获一个对`HTMLElement`实例的强烈引用。

如果您将`paragraph`变量设置为`nil`并破坏其对`HTMLElement`实例的强引用，则由于强引用周期，`HTMLElement`实例及其闭包都不会被释放：

1. paragraph = nil

Note that the message in the `HTMLElement` deinitializer isn’t printed, which shows that the `HTMLElement` instance isn’t deallocated.

## 解决关闭的强参考周期

通过定义*捕获列表*作为闭包定义的一部分，您可以解决闭包和类实例之间的强引用周期。捕获列表定义了在闭包主体中捕获一个或多个引用类型时使用的规则。与两个类实例之间的强引用周期一样，您将每个捕获的引用声明为弱引用或非自有引用，而不是强引用。弱或无权的适当选择取决于代码不同部分之间的关系。

注意

每当您引用闭包中的`self`成员时，Swift要求您编写`self.someProperty`或`self.someMethod()`（而不是justsomeProperty或`someMethod()`）。这有助于你记住，偶然捕捉`self`是可能的。

### 定义捕获列表

Each item in a capture list is a pairing of the `weak` or `unowned` keyword with a reference to a class instance (such as `self`) or a variable initialized with some value (such as `delegate = self.delegate`). These pairings are written within a pair of square braces, separated by commas.

将捕获列表放在闭包的参数列表之前，如果提供了它们，则返回类型：

1. lazy var someClosure = {
2. ​    [unowned self, weak delegate = self.delegate]
3. ​    (index: Int, stringToProcess: String) -> String in
4. ​    // closure body goes here
5. }

如果闭包没有指定参数列表或返回类型，因为它们可以从上下文中推断出来，请将捕获列表放在闭包的开头，后跟关键字：

1. lazy var someClosure = {
2. ​    [unowned self, weak delegate = self.delegate] in
3. ​    // closure body goes here
4. }

### 弱引用和无所有引用

当闭包及其捕获的实例始终相互引用时，将闭包中的捕获定义为非自引用，并且始终同时被释放。

相反，当捕获的引用在未来某个时候可能变成`nil`，将捕获定义为弱引用。弱引用始终是可选类型，当它们引用的实例被释放时，它们会自动变成`nil`。这使您能够检查它们是否存在于闭合体中。

注意

如果捕获的引用永远不会变成`nil`，则应始终将其捕获为非拥有的引用，而不是弱引用。

无自有引用是从上面的[强引用周期](https://docs.swift.org/swift-book/LanguageGuide/AutomaticReferenceCounting.html#ID56)到上文的`HTMLElement`示例中解析强引用周期[的](https://docs.swift.org/swift-book/LanguageGuide/AutomaticReferenceCounting.html#ID56)适当捕获方法。以下是您编写`HTMLElement`类以避免循环的方法：

1. class HTMLElement {
2. 
3. ​    let name: String
4. ​    let text: String?
5. 
6. ​    lazy var asHTML: () -> String = {
7. ​        [unowned self] in
8. ​        if let text = self.text {
9. ​            return "<\(self.name)>\(text)</\(self.name)>"
10. ​        } else {
11. ​            return "<\(self.name) />"
12. ​        }
13. ​    }
14. 
15. ​    init(name: String, text: String? = nil) {
16. ​        self.name = name
17. ​        self.text = text
18. ​    }
19. 
20. ​    deinit {
21. ​        print("\(name) is being deinitialized")
22. ​    }
23. 
24. }

除了在`asHTML`闭包中添加捕获列表外，`HTMLElement`的实现与之前的实现相同。在这种情况下，捕获列表是`[unownedself]`，这意味着“捕获自我作为非自有参考，而不是强引用”。

您可以像以前一样创建和打印`HTMLElement`实例：

1. var paragraph: HTMLElement? = HTMLElement(name: "p", text: "hello, world")
2. print(paragraph!.asHTML())
3. // Prints "<p>hello, world</p>"

以下是捕获列表到位后参考资料的外观：

![../_images/closureReferenceCycle02_2x.png](https://docs.swift.org/swift-book/_images/closureReferenceCycle02_2x.png)

这一次，闭包捕获`self`是一个非拥有的引用，并且不会强烈保留它捕获的`HTMLElement`实例。如果您将`paragraph`变量的强引用设置为`nil`，则`HTMLElement`实例将被释放，从以下示例中打印其去初始化器消息中可以看出：

1. paragraph = nil
2. // Prints "p is being deinitialized"

有关捕获列表的更多信息，请参阅[捕获列表](https://docs.swift.org/swift-book/ReferenceManual/Expressions.html#ID544)。