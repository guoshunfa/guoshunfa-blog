---
title: Swift基础 类型铸造
tags:
    - Swift
    - 基础
categories:
    - Swift
date: 2022-07-01 12:01:01
thumbnail:
---


翻译自：https://docs.swift.org/swift-book/LanguageGuide/TypeCasting.html

*类型转换*是一种检查实例类型的方法，或将该实例视为与自身类层次结构中其他地方不同的超类或子类。

Swift中的类型转换是用`is``as`运算符实现的。这两个运算符提供了一种简单而富有表现力的方式来检查值的类型或将值转换为其他类型。

您还可以使用类型转换来检查类型是否符合协议，如[“检查协议一致性](https://docs.swift.org/swift-book/LanguageGuide/Protocols.html#ID283)”中所述。

## 定义类型铸造的类层次结构

您可以使用带有类和子类层次结构的类型转换来检查特定类实例的类型，并将该实例转换为同一层次结构中的另一个类。下面的三个代码片段定义了类的层次结构和包含这些类实例的数组，用于类型转换示例。

第一个片段定义了一个名为`MediaItem`的新基类。该类为数字媒体库中出现的任何类型的项目提供基本功能。具体来说，它声明`String`类型的`name`属性和`initname`初始化器。（假设所有媒体项目，包括所有电影和歌曲，都将有一个名称。）

1. class MediaItem {
2. ​    var name: String
3. ​    init(name: String) {
4. ​        self.name = name
5. ​    }
6. }

下一个片段定义了`MediaItem`的两个子类。第一个子类“`Movie`会封装有关某部或某部电影的其他信息。它在基础`MediaItem`类之上添加了一个`director`属性，并带有相应的初始化器。第二个子类`Song`在基类之上添加了`artist`属性和初始化器：

1. class Movie: MediaItem {
2. ​    var director: String
3. ​    init(name: String, director: String) {
4. ​        self.director = director
5. ​        super.init(name: name)
6. ​    }
7. }
8. 
9. class Song: MediaItem {
10. ​    var artist: String
11. ​    init(name: String, artist: String) {
12. ​        self.artist = artist
13. ​        super.init(name: name)
14. ​    }
15. }

最后一个片段创建一个名为`library`的常量数组，其中包含两个`Movie`实例和三个`Song`实例。通过使用数组文字的内容初始化库数组来推断`library`数组的类型。Swift的类型检查器能够推断`Movie`和`Song`具有常见的`MediaItem`超类，因此它推断出库数组的`[MediaItem]`类型：

1. let library = [
2. ​    Movie(name: "Casablanca", director: "Michael Curtiz"),
3. ​    Song(name: "Blue Suede Shoes", artist: "Elvis Presley"),
4. ​    Movie(name: "Citizen Kane", director: "Orson Welles"),
5. ​    Song(name: "The One And Only", artist: "Chesney Hawkes"),
6. ​    Song(name: "Never Gonna Give You Up", artist: "Rick Astley")
7. ]
8. // the type of "library" is inferred to be [MediaItem]

存储在`library`中的项目仍然是幕后`Movie`和`Song`实例。但是，如果您迭代此数组的内容，则您收到的项目被键入为`MediaItem`，而不是`Movie`或`Song`。为了将他们作为他们的原生类型，您需要*检查*他们的类型，或将他们*降*为其他类型，如下所述。

## 检查类型

使用*类型检查运算符*（`is`）来检查实例是否属于特定子类类型。如果实例属于该子类类型，类型检查运算符返回`true`，如果不是该子类类型，则返回`false`。

以下示例定义了两个变量，`movieCount`和`songCount`，它们计算`library`数组中的`Movie`和`Song`实例数量：

1. var movieCount = 0
2. var songCount = 0
3. 
4. for item in library {
5. ​    if item is Movie {
6. ​        movieCount += 1
7. ​    } else if item is Song {
8. ​        songCount += 1
9. ​    }
10. }
11. 
12. print("Media library contains \(movieCount) movies and \(songCount) songs")
13. // Prints "Media library contains 2 movies and 3 songs"

此示例迭代`library`数组中的所有项目。在每次传递中，`for`-`in`循环将`item`常量设置为数组中的下一个`MediaItem`。

`item is Movie`如果当前`MediaItem`是`Movie`实例，则返回`true`，如果不是，则返回`false`。同样，`itemisSong`，检查项目是否是`Song`实例。在`for`-`in`循环的末尾，`movieCount`和`songCount`的值包含每种类型的`MediaItem`实例数量。

## 压倒

特定类类型的常量或变量实际上可能指幕后子类的实例。如果您认为情况就是这样，您可以尝试使用*类型转换运算符**降*到子类类型（`as?`或者`as!`）。

由于下调可能会失败，类型转换运算符有两种不同的形式。条件形式`as?`返回您试图向下转换的类型的可选值。强迫形式，`as!`，尝试压倒和强迫将结果包装为单个复合动作。

使用类型转换运算符的条件形式（`as?`）当你不确定沮丧的人是否会成功时。这种形式的运算符将始终返回一个可选值，如果无法进行向下转换，该值将为`nil`。这使您能够检查是否成功下调。

使用类型转换运算符的强制形式（`as!`）只有当你确信沮丧的人会永远成功的时候。如果您尝试将这种形式的运算符降到错误的类类型，将触发运行时错误。

以下示例对`library`中的每个`MediaItem`迭代，并为每个项目打印适当的描述。要做到这一点，它需要将每个项目作为真正的`Movie`或`Song`访问，而不仅仅是作为`MediaItem`。这是必要的，这样它才能访问`Movie`或`Song`的`director`或`artist`属性，以便在描述中使用。

在本例中，数组中的每个项目可能是`Movie`，也可能是`Song`。您事先不知道每个项目应使用哪个实际类，因此使用类型转换运算符的条件形式是合适的（`as?`）每次通过循环检查降压：

1. for item in library {
2. ​    if let movie = item as? Movie {
3. ​        print("Movie: \(movie.name), dir. \(movie.director)")
4. ​    } else if let song = item as? Song {
5. ​        print("Song: \(song.name), by \(song.artist)")
6. ​    }
7. }
8. 
9. // Movie: Casablanca, dir. Michael Curtiz
10. // Song: Blue Suede Shoes, by Elvis Presley
11. // Movie: Citizen Kane, dir. Orson Welles
12. // Song: The One And Only, by Chesney Hawkes
13. // Song: Never Gonna Give You Up, by Rick Astley

该示例首先尝试将当前`item`降为`Movie`。因为`item`是`MediaItem`实例，所以它可能是一部`Movie`；同样，它也可能是一首`Song`，甚至只是一个基本的`MediaItem`。因为这种不确定性，`as?`当尝试将类型转换为子类类型时，类型转换运算符的形式返回一个*可选*值。`item`的结果`as?Movie`类型为`Movie?`，或“可选`Movie`”。

当应用于库数组中`Song`实例时，将向下转换到`Movie`失败。为了应对这种情况，上面的示例使用可选绑定来检查可选`Movie`是否真的包含一个值（即找出被关闭的版本是否成功）。这个可选绑定写为“`ifletmovie=itemas?Movie`”，可以读作：

“尝试将`item`作为`Movie`访问。如果成功，请将名为`movie`的新临时常量设置为存储在返回的可选`Movie`中的值。”

如果压制成功，则使用`movie`的属性来打印该`Movie`实例的描述，包括其`director`的姓名。类似的原则用于检查`Song`实例，并在库中找到`Song`时打印适当的描述（包括`artist`姓名）。

注意

铸造实际上不会修改实例或更改其值。基础实例保持不变；它只是作为其被转换到的类型的实例进行处理和访问。

## 任何和AnyObject的类型铸造

Swift 提供了两种特殊类型，用于处理非特定类型：

- `Any`可以表示任何类型的实例，包括函数类型。
- `AnyObject`可以表示任何类类型的实例。

仅当您明确需要它们提供的行为和功能时，才使用`Any`和`AnyObject`。最好具体说明您希望在代码中使用的类型。

以下是使用`Any`处理不同类型组合的示例，包括函数类型和非类类型。该示例创建一个名为`things`的数组，可以存储类型为`Any`的值：

1. var things: [Any] = []
2. 
3. things.append(0)
4. things.append(0.0)
5. things.append(42)
6. things.append(3.14159)
7. things.append("hello")
8. things.append((3.0, 5.0))
9. things.append(Movie(name: "Ghostbusters", director: "Ivan Reitman"))
10. things.append({ (name: String) -> String in "Hello, \(name)" })

`things`数组包含两个`Int`值、两个`Double`值、一个`String`值、一个类型的元组`(Double,Double)`电影“Ghostbusters”和一个接受`String`值并返回另一个`String`值的闭包表达式。

To discover the specific type of a constant or variable that’s known only to be of type `Any` or `AnyObject`, you can use an `is` or `as` pattern in a `switch` statement’s cases. The example below iterates over the items in the `things` array and queries the type of each item with a `switch` statement. Several of the `switch` statement’s cases bind their matched value to a constant of the specified type to enable its value to be printed:

1. for thing in things {
2. ​    switch thing {
3. ​    case 0 as Int:
4. ​        print("zero as an Int")
5. ​    case 0 as Double:
6. ​        print("zero as a Double")
7. ​    case let someInt as Int:
8. ​        print("an integer value of \(someInt)")
9. ​    case let someDouble as Double where someDouble > 0:
10. ​        print("a positive double value of \(someDouble)")
11. ​    case is Double:
12. ​        print("some other double value that I don't want to print")
13. ​    case let someString as String:
14. ​        print("a string value of \"\(someString)\"")
15. ​    case let (x, y) as (Double, Double):
16. ​        print("an (x, y) point at \(x), \(y)")
17. ​    case let movie as Movie:
18. ​        print("a movie called \(movie.name), dir. \(movie.director)")
19. ​    case let stringConverter as (String) -> String:
20. ​        print(stringConverter("Michael"))
21. ​    default:
22. ​        print("something else")
23. ​    }
24. }
25. 
26. // zero as an Int
27. // zero as a Double
28. // an integer value of 42
29. // a positive double value of 3.14159
30. // a string value of "hello"
31. // an (x, y) point at 3.0, 5.0
32. // a movie called Ghostbusters, dir. Ivan Reitman
33. // Hello, Michael

注意

`Any`类型表示任何类型的值，包括可选类型。如果您使用可选值，其中需要`Any`类型的值，Swift会向您发出警告。如果您确实需要将可选值用作Any值，您可以使用`as`运算符将可选值显式转换为`Any`，如下所示。

1. let optionalNumber: Int? = 3
2. things.append(optionalNumber)        // Warning
3. things.append(optionalNumber as Any) // No warning