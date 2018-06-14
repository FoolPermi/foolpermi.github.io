---
title: Generics in Swift
date: 2016-11-28 21:43:52
categories: Swift
tags: swift
---

**泛型 (Generics)** 是 Swift 中最强大的特性之一，许多 Swift 的标准库也都是基于泛型的代码构建的。使用泛型可以让你根据自定义的需求，编写出适用于任意类型、灵活可重用的函数和类型。例如 Swift 中的 Array 和 Dictionary 都是泛型集合，你可以创建一个 Int 数组，也可以创建一个 String 数组，还可以创建其它类型的数组。当然，也可以创建任意指定类型的字典，本文的主要内容包括：

- 泛型解决的问题 (The problems generic solve)
- 泛型函数 (Generic functions)
- 泛型类型 (Generic types)
- 扩展泛型类型 (Extending a generic type)
- 类型约束 (Type constrains)
- 关联类型 (Associated type)
- Where 语句 (Generic where clauses)

<!---more--->

## The problem generics solve

下面是一个标准的非泛型函数 swapTwoInts，用来交换两个 Int 值：

```swift
func swapTwoInts(_ a: inout Int, _ b: inout Int) {
  let temp = a
  a = b
  b = temp
}
```

上面的代码使用输入输出参数 (inout) 来交换 a 和 b 的值：

```swift
var someInt = 3
var anotherInt = 107
swapTwoInts(&someInt, &anotherInt)
print("someInt = \(someInt), anotherInt = \(anotherInt)") // someInt = 107, anotherInt = 3
```

当然，swapTwoInts 函数挺有用，但是缺点也同样明显，就是它只能交换 Int 的值，如果想要交换两个 Double 或者 String 的值，你还必须重写一个类似的函数：

```swift
func swapTwoDoubles(_ a: inout Double, _ b: inout Double) {
  let temp = a
  a = b
  b = temp
}
func swapTwoStrings(_ a: inout String, _ b: inout String) {
  let temp = a
  a = b
  b = temp
}
```

可以看出，上面的函数除了参数类型以外，实现过程完全相同。在实际应用中，通常需要一个更实用更灵活的函数来交换两个任意类型的值，这就需要使用泛型代码。

## Generic functions

泛型函数可适用于任意类型，下面的 swapTwoValues 函数就是上面3个函数的泛型版本：

```swift
func swapTwoValues<T>(_ a: inout T, _ b: inout T) {
  let temp = a
  a = b 
  b = temp
}
```

swapTwoValues的函数主体和之前的函数完全相同，唯一的不同是在函数声明的时候：

```swift
func swapTwoInts(_ a: inout Int, _ b: inout Int)
func swapTwoValues<T>(_ a: inout T, _ b: inout T)
```

这个泛型函数的声明使用了占位类型名 (这里是 T) 来代替实际类型名 (例如 Int、Double、String)。占位类型符 T 并没有指出具体是什么类型，但它约束了 a 和 b 必须是同一类型。在函数调用的时候会根据实际传入的类型决定 T 的类型。现在函数 swapTwoValues 和前面的函数一样调用，只是这个函数可以接受两个任意类型的参数，只是这两个参数类型必须相同。

```swift
var someInt = 3
var anotherInt = 107
swapTwoValues(&someInt, &anotherInt)
print("someInt = \(someInt), anotherInt = \(anotherInt)") // someInt = 107, anotherInt = 3

var someStr = "hello"
var anotherStr = "world"
swapTwoValues(&someStr, &anotherStr) 
print("someStr = \(someStr), anotherStr = \(anotherStr)") // someStr = world, anotherStr = hello
```

## Generic types

除了泛型函数，Swift 还允许定义泛型类型，这些自定义的结构体、类、枚举可以适用于任何类型，类似于 Array 和 Dictionary。下面的例子是编写一个名为 Stack 的泛型集合类型，首先展示一个非泛型的版本：

```swift
struct IntStack {
  var items = [Int]()
  mutating func push(_ item: Int) {
    items.append(item)
  }
  mutating func pop() -> Int {
    return items.removeLast()
  }
}
```

上面的结构体可以进行入栈和出栈的操作，但是只适用于 Int 类型，对应的泛型版本如下：

```swift
struct Stack<Element> {
  var items = [Element]()
  mutating func push(_ item: Element) {
    items.append(item)
  }
  mutating func pop() -> Element {
    return items.removeLast()
  }
}
```

Stack 基本上和 IntStack 相同，只是用占位类型 Element 代替了实际类型 Int，这个类型参数包裹在紧随结构体名的一对尖括号里。Element 为待提供的类型定义了一个占位符，这种占位符可以在结构体中需要类型信息的时候使用。使用泛型版本的 Stack 就可以创建 Swift 中任意有效类型的栈，就像 Array 和 Dictionary 那样。在 Stack 实例化的时候，可以在尖括号中写出 Stack 中的数据类型：

```swift
var stackOfStrings = Stack<String>()
stackOfStrings.push("uno")
stackOfStrings.push("dos")
stackOfStrings.push("tres")
let fromTheTop = stackOfStrings.pop()
```

## Extending a generic type

当扩展一个泛型类型的时候并不需要在扩展的定义中提供类型参数列表，原始类型定义中声明的类型参数列表在扩展中可以直接使用，并且这些来自原始类型的参数名称会被用作原始定义中类型参数的引用。下面扩展泛型类型 Stack，为其添加一个名为 topItem 的只读计算属性用来返回栈顶的元素：

```swift
extension Stack { // 并没有类型列表
  var topItem: Element? {
    return items.isEmpty ? nil : items[items.count - 1]
  }
}
```

这个扩展并没有定义一个类型参数列表，原有 Stack 中的类型参数列表可以直接使用。

## Type constraints

可以给一个类型参数添加约束以使得类型符合特定的条件。在一个类型参数名后面放置一个类名或协议名，并用冒号进行分隔，来定义类型约束，它们将成为类型参数列表的一部分。对泛型函数添加类型约束的基本语法如下：

```swift
func someFunction<T: SomeClass, U: SomeProtocol>(someT: T, someU: U) {
  // 泛型函数的实现部分
}
```

上面这个函数有两个类型参数。第一个类型参数 是T，有一个要求 T 必须是 SomeClass 子类的类型约束；第二个类型参数是U，有一个要求 U 必须符合 SomeProtocol 协议的类型约束。

## Associated type

当定义一个协议时，有的时候声明一个或多个关联类型作为协议定义的一部分是非常有用的，一个关联类型作为协议的一部分，给定了类型的一个占位名作用于关联类型上，实际类型在协议被实现前是不需要指定的。使用 typealias 指定关联类型。

```swift
protocol Container {
  associatedtype ItemType
  mutating func append(item: ItemType)
  var count: Int { get }
  subscript(i: Int) -> ItemType { get }
}
```

Container 定义了一个容器必须满足的3个要求：

+ 必须可以通过 append 方法添加一个新的 item 到容器中
+ 必须可以通过使用 count 属性获取容器中元素的个数
+ 必须可以通过索引获取容器中的各个元素

这里让早先的 IntStack 类型遵守 Container 协议：

```swift
struct IntStack: Container {
  // IntStack的原始实现
  var items = [Int]()
  mutating func push(_ item: Int) {
    items.append(item)
  }
  mutating func pop() -> Int {
    return items.removeLast()
  }
  // 遵守Container协议的实现
  typealias ItemType = Int
  mutating func append(item: Int){
    self.push(item)
  }
  var count: Int {
    return items.count
  }
  subscript(i: Int) -> Int {
    return items[i]
  }
}
```

还可以生成遵循 Container 协议的泛型版本的 Stack 类型：

```swift
struct Stack<T>: Container {
  // Stack的原始实现
  var items = [T]()
  mutating func push(_ item: T) {
    items.append(item)
  }
  mutating func pop() -> T {
    return items.removeLast()
  }
  // 遵守Container协议的实现
  mutating func append(item: T) {
    self.push(item)
  }
  var count: Int {
    return items.count
  }
  subscript(i: Int) -> T {
    return items[i]
  }
}
```

## Generic where clauses

对关联类型定义约束是非常有用的，你可以在参数列表中通过 where 语句定义参数的约束。一个 where 语句可以使一个关联类型遵守一个特定的协议。可以写一个 where 语句，紧跟在类型参数列表的后面，where 语句后跟一个或多个针对关联类型的约束。

```swift
func allItemsMatch<C1: Container, C2: Container>(someContainer: C1, anotherContainer: C2) -> Bool where C1.ItemType == C2.ItemType, C1.ItemType: Equatable {
  if someContainer.count != anotherContainer.count {
    return false
  }
  for i in 0..<someContainer.count {
    if someContainer[i] != anotherContainer[i] {
      return false
    }
  }
  return true
}
```

参考：*The Swift Programming Language*

