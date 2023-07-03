---
title: Swift基础 并发性
tags:
    - swift
    - 基础
categories:
    - 技术
date: 2022-07-01 12:01:01
thumbnail:
---
# Swift基础 - 并发性

翻译自：https://docs.swift.org/swift-book/LanguageGuide/Concurrency.html

Swift内置支持以结构化方式编写异步和并行代码。*异步代码*可以暂停并稍后恢复，尽管一次只执行一个程序。在程序中暂停和恢复代码可以让它继续在更新用户界面等短期操作上取得进展，同时继续处理长期运行的操作，如通过网络获取数据或解析文件。*并行代码*意味着多个代码同时运行——例如，一台配备四核处理器的计算机可以同时运行四条代码，每个核心执行其中一项任务。使用并行和异步代码的程序一次执行多个操作；它暂停等待外部系统的操作，并使其更容易以内存安全的方式编写此代码。

并行或异步代码的额外调度灵活性也增加了复杂性。Swift允许您以允许一些编译时检查的方式表达您的意图——例如，您可以使用参与者安全地访问可变状态。然而，向缓慢或错误的代码添加并发并不能保证它会变得快速或正确。事实上，添加并发性甚至可能会使您的代码更难调试。然而，使用Swift对代码中需要并发的并发的语言级支持意味着Swift可以帮助您在编译时发现问题。

本章的其余部分使用并发一词来指代异步和并行代码的常见组合。

注意

如果您以前编写过并发代码，您可能习惯于处理线程。Swift 中的并发模型构建在线程之上，但您不会直接与它们交互。Swift中的异步函数可以放弃它正在运行的线程，这允许另一个异步函数在第一个函数被阻止时在该线程上运行。

虽然可以在不使用Swift语言支持的情况下编写并发代码，但该代码往往更难阅读。例如，以下代码下载照片名称列表，下载该列表中的第一张照片，并向用户显示该照片：

1. listPhotos(inGallery: "Summer Vacation") { photoNames in
2. ​    let sortedNames = photoNames.sorted()
3. ​    let name = sortedNames[0]
4. ​    downloadPhoto(named: name) { photo in
5. ​        show(photo)
6. ​    }
7. }

即使在这种简单的情况下，由于代码必须编写为一系列完成处理程序，您最终也会编写嵌套闭包。在这种风格下，具有深嵌套的更复杂的代码可能会很快变得笨拙。

## 定义和调用异步函数

*异步函数*或*异步方法*是一种特殊的函数或方法，可以在执行过程中暂停。这与普通的同步函数和方法形成鲜明对比，这些函数和方法要么运行到完成，要么抛出错误，要么永远不会返回。异步函数或方法仍然可以做这三件事之一，但当它等待某事时，它也可以在中间暂停。在异步函数或方法的主体中，您可以标记可以暂停执行的每个地方。

要指示函数或方法是异步的，您将`async`关键字写入其参数后的声明中，类似于您如何使用`throws`标记抛出函数。如果函数或方法返回值，则在返回箭头（`->`）之前写入`async`。例如，以下是您可以在图库中获取照片名称的方法：

1. func listPhotos(inGallery name: String) async -> [String] {
2. ​    let result = // ... some asynchronous networking code ...
3. ​    return result
4. }

对于既异步又抛出的函数或方法，您在`throws`前编写`async`。

当调用异步方法时，执行暂停，直到该方法返回。您在通话前写下`await`，以标记可能的暂停点。这就像在调用抛出函数时`try`写入，如果出现错误，则标记程序流程的可能更改。在异步方法中，*只有当*您调用另一个异步方法时，执行流程才会暂停——暂停从来都不是隐式或先发制人的——这意味着每个可能的暂停点都标有`await`。

例如，下面的代码获取图库中所有图片的名称，然后显示第一张图片：

1. let photoNames = await listPhotos(inGallery: "Summer Vacation")
2. let sortedNames = photoNames.sorted()
3. let name = sortedNames[0]
4. let photo = await downloadPhoto(named: name)
5. show(photo)

由于`listPhotos(inGallery:)`和`downloadPhoto(named:)`功能都需要提出网络请求，因此它们可能需要相对较长的时间才能完成。通过在返回箭头之前写入`async`使它们都异步，可以让应用程序的其余代码在该代码等待图片准备就绪时继续运行。

为了了解上述示例的并发性质，这里有一个可能的执行顺序：

1. 代码从第一行开始运行，一直运行到第一行`await`。它调用`listPhotos(inGallery:)`函数，并在等待该函数返回时暂停执行。
2. 当此代码的执行暂停时，同一程序中还会运行一些其他并发代码。例如，一个长期运行的背景任务可能会继续更新新照片库列表。该代码也会运行到下一个暂停点，以`await`为标记，或直到它完成。
3. `listPhotos(inGallery:)`返回后，此代码从那时开始继续执行。它分配返回到`photoNames`值。
4. 定义`sortedNames`和`name`行是常规的同步代码。由于这些线路上没有标记`await`，因此没有任何可能的暂停点。
5. 下一个`await`标志着对`downloadPhoto(named:)`函数的调用。此代码再次暂停执行，直到该函数返回，使其他并发代码有机会运行。
6. `downloadPhoto(named:)`返回后，其返回值被分配给`photo`，然后在调用`show(_:)`时作为参数传递。

标记为`await`的代码中可能的暂停点表示，当前代码可能会在等待异步函数或方法返回时暂停执行。这也被称为*生成线程*，因为在幕后，Swift暂停在当前线程上执行代码，而是在该线程上运行一些其他代码。由于`await`的代码需要能够暂停执行，因此程序中的某些地方只能调用异步函数或方法：

- 异步函数、方法或属性主体中的代码。
- 标记为`@main`结构、类或枚举的静态`main()`方法中的代码。
- 非结构化子任务中的代码，如下所示。

注意

[`Task.sleep(nanoseconds:)`](https://developer.apple.com/documentation/swift/task/3862701-sleep)方法在编写简单代码以了解并发工作原理时非常有用。这种方法什么也做不了，但至少要等待给定的纳秒数才能返回。以下是`listPhotos(inGallery:)`函数的版本，该函数使用`sleep(nanoseconds:)`来模拟等待网络操作：

1. func listPhotos(inGallery name: String) async throws -> [String] {
2. ​    try await Task.sleep(nanoseconds: 2 * 1_000_000_000)  // Two seconds
3. ​    return ["IMG001", "IMG99", "IMG0404"]
4. }

## 异步序列

在数组的所有元素准备就绪后，上一节中的`listPhotos(inGallery:)`函数会异步返回整个数组。另一种方法是使用*异步序列*一次等待集合的一个元素。以下是异步序列迭代的样子：

1. import Foundation
2. 
3. let handle = FileHandle.standardInput
4. for try await line in handle.bytes.lines {
5. ​    print(line)
6. }

上面的示例不是使用普通的`for`-`in`循环，而是在它之后写`for`和`await`。与您调用异步函数或方法时一样，写入`await`表示可能的悬浮点。当等待下一个元素可用时，`await`循环可能会在每次迭代开始时暂停执行。

就像您可以通过添加[`Sequence`](https://developer.apple.com/documentation/swift/sequence)协议的一致性在`for`-`in`循环中使用自己的类型一样，您可以通过添加对[`AsyncSequence`](https://developer.apple.com/documentation/swift/asyncsequence)协议的一致性在`for`-`await`-`in`循环中使用自己的类型。

## 并行调用异步函数

调用带有`await`的异步函数一次只运行一段代码。当异步代码运行时，调用者等待该代码完成，然后再继续运行下一行代码。例如，要从图库中获取前三张照片，您可以等待`downloadPhoto(named:)`功能的三次调用，具体如下：

1. let firstPhoto = await downloadPhoto(named: photoNames[0])
2. let secondPhoto = await downloadPhoto(named: photoNames[1])
3. let thirdPhoto = await downloadPhoto(named: photoNames[2])
4. 
5. let photos = [firstPhoto, secondPhoto, thirdPhoto]
6. show(photos)

这种方法有一个重要的缺点：虽然下载是异步的，并允许在进行其他工作时进行，但一次只运行一个`downloadPhoto(named:)`的调用。每张照片在下一张照片开始下载之前都会完全下载。然而，这些操作无需等待——每张照片都可以独立下载，甚至可以同时下载。

要调用异步函数并让它与周围的代码并行运行，请在定义常量时在`let`前面写入`async`，然后在每次使用常量时写入`await`。

1. async let firstPhoto = downloadPhoto(named: photoNames[0])
2. async let secondPhoto = downloadPhoto(named: photoNames[1])
3. async let thirdPhoto = downloadPhoto(named: photoNames[2])
4. 
5. let photos = await [firstPhoto, secondPhoto, thirdPhoto]
6. show(photos)

在本例中，所有三个`downloadPhoto(named:)`的调用都无需等待前一个调用完成即可开始。如果有足够的系统资源可用，它们可以同时运行。这些函数调用都没有标记为`await`，因为代码不会暂停等待函数的结果。相反，执行一直持续到定义`photos`行——此时，程序需要这些异步调用的结果，因此您写`await`暂停执行，直到所有三张照片完成下载。

以下是您如何思考这两种方法之间的差异：

- 当以下行上的代码取决于该函数的结果时，使用`await`调用异步函数。这创造了按顺序进行的工作。
- 当您直到代码稍后才需要结果时，使用`async``let`调用异步函数。这创造了可以并行进行的工作。
- `await`和`async``let`允许其他代码在暂停时运行。
- 在这两种情况下，您都会用`await`标记可能的悬浮点，以指示如果需要，执行将暂停，直到返回异步函数。

您还可以在同一代码中混合这两种方法。

## 任务和任务组

*任务*是可以作为程序的一部分异步运行的工作单元。所有异步代码都作为某些任务的一部分运行。上一节中描述的`async``let`语法为您创建一个子任务。您还可以创建一个任务组，并将子任务添加到该组中，这使您可以更好地控制优先级和取消，并允许您创建动态数量的任务。

任务排列在层次结构中。任务组中的每个任务都有相同的父任务，每个任务都可以有子任务。由于任务和任务组之间的显式关系，这种方法被称为*结构化并发*。虽然您承担了一些正确性的责任，但任务之间的明确父子关系允许Swift为您处理一些行为，例如传播取消，并允许Swift在编译时检测到一些错误。

1. await withTaskGroup(of: Data.self) { taskGroup in
2. ​    let photoNames = await listPhotos(inGallery: "Summer Vacation")
3. ​    for name in photoNames {
4. ​        taskGroup.addTask { await downloadPhoto(named: name) }
5. ​    }
6. }

有关任务组的更多信息，请参阅[`TaskGroup`](https://developer.apple.com/documentation/swift/taskgroup)。

### 非结构化并发

除了前几节中描述的结构化并发方法外，Swift还支持非结构化并发。与任务组中的任务不同，非*结构化任务*没有父任务。您可以完全灵活地以任何程序需要的方式管理非结构化任务，但您也要对其正确性承担全部责任。要创建在当前参与者上运行的非结构化任务，请调用[`Task.init(priority:operation:)`](https://developer.apple.com/documentation/swift/task/3856790-init)初始化器。要创建不属于当前参与者的非结构化任务，更具体地说，称为*分离任务*，请调用[`Task.detached(priority:operation:)`](https://developer.apple.com/documentation/swift/task/3856786-detached)类方法。这两个操作都返回一个任务句柄，允许您与任务交互——例如，等待其结果或取消它。

1. let newPhoto = // ... some photo data ...
2. let handle = Task {
3. ​    return await add(newPhoto, toGalleryNamed: "Spring Adventures")
4. }
5. let result = await handle.value

有关管理独立任务的更多信息，请参阅[`Task`](https://developer.apple.com/documentation/swift/task)。

### 任务取消

Swift并发使用合作取消模型。每个任务都会检查它是否在执行的适当点被取消，并以任何适当的方式响应取消。根据您正在做的工作，这通常意味着以下内容之一：

- 抛出错误，比如`CancellationError`
- 返回`nil`或空收藏
- 退回部分完成的工作

要检查取消，请调用[`Task.checkCancellation()`](https://developer.apple.com/documentation/swift/task/3814826-checkcancellation)，如果任务已取消，则会抛出`CancellationError`，要么检查[`Task.isCancelled`](https://developer.apple.com/documentation/swift/task/3814832-iscancelled)的值，并在您自己的代码中处理取消。例如，从图库下载照片的任务可能需要删除部分下载并关闭网络连接。

要手动传播取消，请调用[`Task.cancel()`](https://developer.apple.com/documentation/swift/task/3851218-cancel)。

## 演员

与类一样，参与者是引用类型，因此类[是引用类型](https://docs.swift.org/swift-book/LanguageGuide/ClassesAndStructures.html#ID89)中的值类型和引用类型的比较适用于参与者和类。与类不同，参与者一次只允许一个任务访问其可变状态，这使得多个任务中的代码可以安全地与参与者的同一实例交互。例如，这里有一个记录温度的演员：

1. actor TemperatureLogger {
2. ​    let label: String
3. ​    var measurements: [Int]
4. ​    private(set) var max: Int
5. 
6. ​    init(label: String, measurement: Int) {
7. ​        self.label = label
8. ​        self.measurements = [measurement]
9. ​        self.max = measurement
10. ​    }
11. }

您介绍一个带有`actor`关键字的演员，然后在一对大括号中定义。`TemperatureLogger`参与者具有演员以外的其他代码可以访问的属性，并限制`max`属性，因此只有参与者内部的代码可以更新最大值。

您可以使用与结构和类相同的初始化器语法创建参与者的实例。当您访问演员的属性或方法时，您可以使用`await`来标记潜在的暂停点——例如：

1. let logger = TemperatureLogger(label: "Outdoors", measurement: 25)
2. print(await logger.max)
3. // Prints "25"

在本例中，访问`logger.max`是一个可能的悬架点。由于参与者一次只允许一个任务访问其可变状态，如果来自另一个任务的代码已经在与记录器交互，则该代码在等待访问属性时暂停。

相比之下，作为参与者一部分的代码在访问参与者的属性时不会写入`await`。例如，这里有一个用新温度更新`TemperatureLogger`的方法：

1. extension TemperatureLogger {
2. ​    func update(with measurement: Int) {
3. ​        measurements.append(measurement)
4. ​        if measurement > max {
5. ​            max = measurement
6. ​        }
7. ​    }
8. }

The `update(with:)` method is already running on the actor, so it doesn’t mark its access to properties like `max` with `await`. This method also shows one of the reasons why actors allow only one task at a time to interact with their mutable state: Some updates to an actor’s state temporarily break invariants. The `TemperatureLogger` actor keeps track of a list of temperatures and a maximum temperature, and it updates the maximum temperature when you record a new measurement. In the middle of an update, after appending the new measurement but before updating `max`, the temperature logger is in a temporary inconsistent state. Preventing multiple tasks from interacting with the same instance simultaneously prevents problems like the following sequence of events:

1. 您的代码调用`update(with:)`方法。它首先更新`measurements`阵列。
2. 在代码可以更新`max`之前，其他地方的代码会读取最大值和温度数组。
3. 您的代码通过更改`max`完成更新。

在这种情况下，在其他地方运行的代码会读取错误的信息，因为它对行为者的访问在`update(with:)`的调用中交织在一起，而数据暂时无效。在使用Swift角色时，您可以防止这个问题，因为它们一次只允许在其状态上执行一次操作，并且该代码只能在`await`标记暂停点的地方中断。由于`update(with:)`不包含任何暂停点，因此没有其他代码可以在更新过程中访问数据。

如果您尝试从演员外部访问这些属性，就像使用类实例一样，您将收到编译时错误；例如：

1. print(logger.max)  // Error

在不写入的情况下访问`logger.max`失败，因为演员的属性是该演员孤立的本地状态的一部分。Swift保证只有演员内部的代码才能访问演员的本地状态。这种保证被称为*演员隔离*。