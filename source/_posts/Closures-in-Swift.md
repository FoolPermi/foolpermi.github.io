---
title: Closures in Swift
date: 2016-11-25 16:48:43
categories: Swift
tags:
---

闭包是 Swift 中的重要语法，与 Objective-C 中的 block 类似，本文主要总结 Swift 中闭包的基本用法。主要参考了 *Swift Apprentice* 和 *The Swift Programming Language*，关于自动闭包的部分则参考了 [*bestswifter*](http://www.jianshu.com/p/f9ba4c41d9c7) 的文章。主要内容包括：

- 基本语法 (Basics)
- 简化规则 (Short syntax)
- 无返回值的闭包 (Closures with no return value)
- 闭包的值捕获 (Capturing from enclosing scope)
- 逃逸闭包 (Escaping closures)
- 自动闭包 (Autoclosures)

<!---more--->


## Basics

**闭包( closure )**是一种没有名字的函数，封装了一段代码块，执行指定的操作。之所以称之为“闭包”是因为它有一个重要的特性，可以捕获作用域内的变量并在闭包内进行访问。因为闭包是一个没有名字的函数，那么要使用一个闭包可以通过将闭包赋给一个常量或者变量，然后使用常量或者变量的名字进行访问。

```swift
// multiplyClosure 是一个闭包，接收两个Int参数，返回一个Int值
var multiplyClosure: (Int, Int) -> Int 
// 给multiplyClosure赋值，关键字in用于区分类型和实现
multiplyClosure = { (a: Int, b: Int) -> Int in
	return a * b
}
// 像调用函数一样调用闭包
let result = multiplyClosure(4, 2) // result = 8
```

## Short syntax

同函数相比，闭包在设计的时候就要求更加简单、轻量，所以也就有很多语法糖可以把闭包书写的更加简单。

- 假如闭包中只包括一条 return 语句，那么可以省略 return关键字，所以上面的 multiplyClosure 可以改为：

```swift
multiplyClosure = { (a: Int, b: Int) -> Int in
	a * b 
}
```

- 通过 Swift 的类型推断，在闭包的实现部分可以省略闭包中参数和返回值的类型，所以 multiplyClosure 可以改为：

```swift
var multiplyClosure: (Int, Int) -> Int 
// 因为声明闭包的时候已经指定了参数和返回类型，所以实现部分可以省略
multiplyClosure = { (a, b) in 
	a * b
}
```

- Swift 会将闭包中的参数指定为 **$0**,**$1**...分别对应闭包中的参数列表，所以实现的时候还可以省略闭包的参数列表。

```swift
multiplyClosure = { 
	$0 * $1
}
```

现在，闭包的**参数列表**，**return 关键字**，**in 关键字**全部都可以被省略了。

考虑下面的函数 operateOnNumbers，函数接收两个 Int 参数和一个闭包，根据闭包指定的操作对两个 Int 参数进行计算。

```swift
func operateOnNumbers(_ a: Int, _ b: Int, operation: (Int, Int) -> Int) -> Int {
  let result = operation(a, b)
  print(result)
  return result
}
```

使用上面的函数的时候，可以先定义一个闭包，然后将闭包传给 operateOnNumbers 函数。

```swift
// 定义闭包
let addClosure = { (a: Int, b: Int) in 
	a + b
}
// 传给函数
operateOnNumbers(4, 2, operation: addClosure) // 6
```

因为闭包就是没有名字的函数，所以，给 operateOnNumbers 传个函数一样可以正常运行：

```swift
func addFunction(_ a: Int, _ b: Int) -> Int {
  return a + b
}
operateOnNumbers(4, 2, operation: addFunction) // 6
```

- 作为函数参数的时候可以使用内联闭包，就是直接将闭包传给函数参数，而不需要将闭包赋给一个变量。所以使用内联闭包的时候，上面的代码可以写成：

```swift
operateOnNumbers(4, 2, operation: { (a: Int, b: Int) -> Int in
	return a + b
})
```

再考虑到上面已经讲过的一些书写闭包的语法糖，现在调用 operateOnNumbers 的时候仍然适用：

```swift
// 1. 闭包只有一句 return 语句时，可以省略 return 关键字
operateOnNumbers(4, 2, operation: { (a: Int, b:Int) -> Int in
	a + b
})
// 2. 已知闭包类型的情况下，省略参数和返回值类型
operateOnNumbers(4, 2, operation: { (a, b) in
	a + b
})
// 3. 省略参数列表
operateOnNumbers(4, 2, operation: { 
	$0 + $1
})
```

除了上面的几种写法以外，还可以直接传给函数一个 '+' 运算符，因为 '+' 运算符本身也是函数，它接收两个参数，并返回其计算结果。所以，还可以写成下面的样子：

```swift
operateOnNumbers(4, 2, operation: +)
```

上面的写法已经非常简单明白了，但是还可以进一步优化。当闭包是函数的**最后一个参数**的时候，可以将闭包写在函数的后面，这种写法也称为**尾随闭包( trailing closure)**。

```swift
// 1. 普通写法
operateOnNumbers(4, 2, operation: { 
	$0 + $1
})
// 2. 使用尾随闭包的写法
operateOnNumbers(4, 2) {
  $0 + $1
}
```

## Closures with no return value

目前为止，上面的闭包都接收了至少一个参数并且有返回值，但是和函数一样，参数和返回值并不是必需的，闭包可以没有参数也没有返回值，而只完成某一特定的操作。

```swift
// 声明一个闭包voidClosure，voidClosure没有参数也没有返回值
let voidClosure: () -> Void = {
  print("This is a closure")
}
// 调用
voidClosure()
```

## Capturing from enclosing scope

最后，回到闭包的特性上来，开篇就强调了，闭包之所以叫“闭包”，是因为它可以捕获作用域内的值。即使定义这些常量和变量的原作用域已经不存在，闭包仍然可以在闭包函数体内引用和修改这些值。举个例子：

```swift
var counter = 0
// incrementCounter是一个闭包，因为闭包和变量counter作用域相同，所以可以捕获变量，并在闭包内使用
let incrementCounter = {
  counter += 1 // 闭包内增加counter的值
}
// 然后多次调用闭包
incrementCounter() // 1
incrementCounter() // 2
incrementCounter() // 3
incrementCounter() // 4
incrementCounter() // 5
```

上面的例子只是简单演示了闭包对变量的捕获，现在定义一个函数，函数的返回值是一个闭包：

```swift
func countingClosure() -> (() -> Int) {
  var counter = 0
  let incrementCounter: () -> Int = {
    counter += 1
    return counter
  }
  // 将闭包返回
  return incrementCounter
}

let counter1 = countingClosure() 
let counter2 = countingClosure() 
counter1() // 1
counter2() // 1
counter1() // 2
counter1() // 3
counter2() // 2
```

上面的结果表示在两个闭包内部对 counter 的操作是连续和各自独立的。

## Closures are reference types

在上面的例子中，counter1 和 counter2 都被声明为常量，但是 counter1 和 counter2 仍然可以改变闭包中 counter 变量的值，这是因为函数和闭包都是**引用类型 (reference type)**，当把一个闭包赋给一个变量或者常量的时候，实际上是将变量或常量指向这个闭包所在的地址。

```swift
// 注意上面的代码，counter1中的counter当前值是3
let counter3 = counter1 
counter3() // 4
```

## Escaping closures

一个闭包作为参数传到一个函数中，但是这个闭包在函数返回之后才被执行，我们称该闭包从函数中逃逸。默认情况下闭包是不允许“逃逸”出函数的，标记为 **@escape**才表示允许闭包在函数返回后执行。将闭包标注 **@escape** 能使编译器知道这个闭包的生命周期。

非逃逸闭包和逃逸闭包讲的并不是执行的先后顺序，非逃逸闭包指的是闭包不可以在函数外单独调用，只能在函数内部调用，函数调用完成后，这个闭包就结束了。

将一个闭包标记为允许逃逸时，在闭包内部访问**实例变量**时要使用 self，而不允许闭包逃逸的时候，访问变量不需要使用 self。

```swift
// 声明一个存放函数的数组
var completionHandlers: [() -> Void] = []
// 定义一个接收闭包参数的函数，闭包允许逃逸
func someFunctionWithEscapingClosure(completionHandler: @escaping () -> Void) {
  completionHandlers.append(completionHandler)
}
func someFunctionWithNonescapingClosure(closure: () -> Void) {
  closure()
}
class SomeClass {
  var x = 10
  func doSomething() {
    someFunctionWithEscapingClosure { self.x = 100 }
    someFunctionWithNonescapingClosure { x = 200 }
  }
}

let instance = SomeClass()
instance.doSomething()
print(instance.x) // prints "200"

completionHandlers.first?() // 延迟调用
print(instance.x) // prints "100"
```

## Autoclosures

我们都知道 **&&** 是个短路运算符，它有两个操作数，首先会计算左边的操作数是不是 true，只有当左边操作数是 true 的时候，才会计算右边的操作数。假如左边是 false，整个表达式的值就是 false，所以无需计算右边的表达式。假如，我们要对数组的第一个元素进行某种判断，可以使用下面的代码：

```swift
var evens = [1, 2, 3]
if !evens.isEmpty && evens[0] > 10 {
  evens[0] = 0
}
```

这主要依赖于 && 运算符的短路机制，否则 evens 为空的时候程序就会崩溃。虽然几乎所有语言的 && 和 || 运算符都有内建的短路机制，但是如何给自定义的运算符添加短路机制呢。假如我们使用下面的代码实现 && 运算符：

```swift
func and(_ l: Bool, _ r: Bool) -> Bool {
  guard l else { return false }
  return r
}
```

这样的 and 并不具备短路机制。因为被传入的参数 r 是 Bool 类型，在 and 内部已经得到了结果。我们要想把这个判断过程延迟，只要在左边表达式为 true 的时候才进行。这就可以使用闭包来满足需求，因为闭包可以把真正执行的代码封装到一个变量中并延迟执行。

```swift
func and(_ l: Bool, _ r: () -> Bool) -> Bool {
  guard l else { return false }
  return r()
}
```

这样调用 and 的时候就可以使用下面的代码：

```swift
if and(!evens.isEmpty, {evens[0] > 10}) {
  evens[0] = 0
}
```

与 && 运算符相比，在 and 方法中，第二个参数变成了闭包，但我们真正关心的只是代码中的内容，使用闭包带来了便利却也使书写变得麻烦。这时候就可以使用 **@autoclosure** 关键字了，它可以把一个表达式自动变成闭包的形式。

```swift
func and(_ l: Bool, @autoclosure _ r: () -> Bool) -> Bool {
  guard l else { return false }
  return r()
}
```

于是 and 方法的调用就可以简化为下面的样子：

```swift
if and(!evens.isEmpty, evens[0] > 10) {
  evens[0] = 0
}
```

除了可以用于短路运算符以外，@autoclosure 关键字在一些调试、日志函数中也很有用处，比如我们可以看到在 *fatalError* 和 *assert* 函数的定义中也用到了 @autoclosure 关键字。以 *assert* 函数为例，它只在调试的时候才会触发，因此在 release 模式下，闭包内的代码不会执行，这样有助于提高程序的效率。

## Custom sorting with closures

在 collection 类型中有一个 sorted 函数用于进行对 collection 中的元素进行排序，使用闭包，可以实现自定义排序规则。

```swift
let names = ["ZZZZZZ", "BB", "A", "CCCC", "EEEEE"]
names.sorted() // ["A", "BB", "CCCC", "EEEEE", "ZZZZZZ"]
```

默认是根据字母表的顺序排列的，现在我们将其改成根据字符串的长度进行排序：

```swift
// sorted 有一个参数接收一个用于定义排序规则的闭包
names.sorted {
  $0.characters.count > $1.characters.count // 根据字符串长度排序
} // ["ZZZZZZ", "EEEEE", "CCCC", "BB", "A"]
```

## Iterating over collections with closures

Swift 的 collection 类型实现了很多简单的语法，而实现过程大多依赖函数式编程，并且使用了闭包。这里介绍一下常用的3个函数：filter，map 和 reduce。

- 函数 filter 允许自定义规则对 collection 中的元素进行筛选。

```swift
var prices = [1, 10, 8, 20, 3]
let largePrices = prices.filter {
  return $0 > 5 // 大于5的元素会被筛选出来，筛选条件是一个Bool表达式
} // [10, 8, 20]
```

- 函数 map 允许对 collection 中的所有元素分别执行某个操作。

```swift
var prices = [1, 10, 8, 20, 3]
let salePrices = prices.map {
  return $0 - 1 // prices中的每个元素依次减少1
} // [0, 9, 7, 19, 2]
```

- 函数 reduce 可以对 collection 中的元素依次迭代执行某个操作。

```swift
let stock = [1.5: 5, 10: 2, 4.99: 20, 2.30: 5, 8.19: 30]
let stockSum = stock.reduce(0) {
  return $0 + $1.key * Double($1.value)
} // 384.5
```

