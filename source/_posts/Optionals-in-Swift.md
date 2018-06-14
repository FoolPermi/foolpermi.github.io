---
title: Optionals in Swift
date: 2016-11-22 21:37:25
categories: Swift
tags:
---

Swift 中有一种实用也很容易迷惑的特性**可选类型 (Optional)**，所谓的 Optional 就是一个变量或者常量，这个变量或常量可以有值，也可以为 nil，只能为这两种情况。相当于有一个盒子，盒子只有两种状态，盒子中有个物体或者盒子为空，不管盒子中有没有物体，盒子一直都存在。

## Basics

声明一个可选类型的变量只需要在类型后面使用**问号 ( ? )**，如果声明了一个 optional 类型的变量，并且没有为其赋初值，那么 optional 会被自动设置为 nil。

```swift
var result: Int? = 30 // result要么包含一个Int值，要么为nil
print(result) // Optional(30)
result = nil
```

<!---more--->

## Unwrapping optionals

如果确定一个 optional 有值，那么可以使用叹号( ! )来获取optional的值，这个过程称为**可选值的解包 (unwrapping optionals)**。

```swift
var result: Int? = 30
print(result) // Optional(30)
// 如果要改变result的值，必须先将result解包
print(result + 1) // error: value of type 'Int?' not unwrapped
```

将一个可选值进行解包，通常有两种方法，一种是在确定 optional 有值的情况下，使用叹号( ! )进行**强制解包( force unwrapping)**。比如上面要获取 result 的值，就可以使用下面的代码实现。	

```swift
var unwrappedResult = result! 
print(unwrappedResult) // 30
```

但是如果不小心对一个为 nil 的可选值进行强制解包就会导致错误，而且这种错误在编译时期并不一定能被发现。所以就有了另一种对可选值的处理方式：

```swift
if result != nil {
  print("result is \(result!)")
} else {
  print("result is nil")
}
```

上面的 if 语句首先检查 optional 中是否包含一个值，然后再进行对应的处理。这种代码在一定程度上可以保证程序运行的安全，但是仍然不完美，因为在使用的时候需要时刻对可选值进行检查。

## Optional binding

**可选值绑定 (optional binding)**是为了安全的访问 optional 中的值而出现的。进行可选绑定的时候，可以使用 let 也可以使用 var。

```swift
if let unwrappedResult = result { // 注意result后面并没有叹号(!)
  print("result is \(unwrappedResult)")
} else {
  print("result is nil")
}
```

假如 result 有值，上面的代码会将 result 解包并赋给 unwrappedResult，然后在需要使用 result 的地方就可以使用 unwrappedResult 代替。通常情况下的写法是下面这样的，并不需要为解包后的 optional 特意取个新的变量名。

```swift
if let result = result {
  print("result is \(result)")
} else {
  print("result is nil")
}
```

假如有多个可选值，还可以同时进行多个可选绑定操作，只有当多个 optional 都有值的时候，if 后面的代码才会被执行。

```swift
var authorName: String? = "James"
var authorAge: Int? = 30
if let authorName = authorName, let authorAge = authorAge {
  print("The author is \(authorName) who is \(authorAge) years old")
} else {
  print("No author or no age")
}
```

 此外，在可选绑定操作的后面还可以添加额外的判断条件。

```swift
var authorName: String? = "James"
var authorAge: Int? = 30
if let authorName = authorName, let authorAge = authorAge, authorAge >= 40 {
  print("The author is \(authorName) who is \(authorAge) years old")
} else {
  print("No author or no age or no age less than 40")
}
```

## Implicitly unwrapped optionals

有的时候，从程序的结构上来讲，一个可选值在初始化以后便不会再为 nil，在这些情况下，使用可选值的时候假如仍然需要使用叹号( ! )进行解包就显得非常多余。这个时候就可以使用**隐式解包的可选值 (implicity unwrapped optionals)**。隐式解包可选值在声明时使用叹号而非问号，使用的时候直接使用，不需要进行强制解包，因为其值不会为 nil，但是假如不小心将隐式解包的可选值赋为了 nil，在访问的时候就会触发运行时错误。

```swift
// an optional
let possibleString: String? = "An optional string"
// access an optional
let forcedString: String = possibleString! // 需要叹号
// an implicitly unwrapped optional
let assumedString: String! = "An implicitly unwrapped optional"
let implicitString: String = assumedString // 不需要叹号
```

当然，仍然可以像使用普通可选值那样来使用隐式解包的可选值，比如使用 if 语句判断是否为空，使用可选绑定等。

## Nil coalescing

还有一种处理 optional 的方式，就是这儿介绍的 **nil coalescing**。考虑到一种情况，假如使用 optional 的时候，无论何时对 optional 进行解包都希望得到一个结果，不管可选值是不是 nil，这种情况下就可以设置一个默认值，当可选值为 nil 的时候，表达式就返回这个设定的默认值。设置默认值的语法是使用两个连续的问号( ?? )。

```swift
var optionalInt: Int? = 10
var mustHaveResult = optionalInt ?? 0 
```

上面的表达式首先会判断 optionalInt 是不是 nil，optionalInt 不为 nil，就返回 optional的值，否则返回默认值0。上面的表达式等同于下面的语句，只是书写更加简洁。

```swift
var optionalInt: Int? = 10
var mustHaveResult: Int
if let unwrapped = optionalInt {
  mustHaveResult = unwrapped
} else {
  mustHaveResult = 0
}
```

## Nested optional

可选值是可以进行嵌套的，但是可读性太差，使用的地方并不多，仅作为了解，比如下面的代码：

```swift
let number: Int??? = 10
print(number) // Optional(Optional(Optional(10)))
print(number!) // Optional(Optional(10))
print(number!!) // Optional(10)
print(number!!!) // 10
```

## Guard

**guard** 语句其实并不是 optional 的内容，但是考虑到 optional 中可能会经常使用到 guard 语句，所以在这里进行介绍。有的时候，在进行条件判断的时候，可能会期望只有判断条件为真的时候，代码才会执行，这时候就可以使用 guard 语句。考虑到有下面一个计算平面图形有几条边的函数：

```swift
func calculateNumberOfSides(shape: String) -> Int? {
  switch shape {
    case "Triangle":
    	return 3
    case "Square", "Rectangle":
    	return 4
    case "Pentagon":
    	return 5
    case "Hexagon":
    	return 6
    default:
    	return nil
  }
}
```

上面的函数根据输入的图形的名字，返回图形边的数目，假如名字不正确则返回 nil，所以函数的返回值是可选值。可以在下面的代码中使用上面的函数：

```swift
func maybePrintSides(shape: String) {
  let sides = calculateNumberOfSides(shape: shape) // sides is an optional
  
  if let sides = sides {
    print("A \(shape) has \(sides) sides")
  } else {
    print("I don't know the number of sides for \(shape)")
  }
}
```

上面的代码没有问题，可以正常的运行。相同的逻辑还可以使用 guard 语句，如下所示：

```swift
func maybePrintSides(shape: String) {
  guard let sides = calculateNumberOfSides(shape: shape) else {
	print("I don't know the number of sides for \(shape)")
	return // else中一定要return
  }
	print("A \(shape) has \(sides) sides")
}
```

guard 关键字跟 if 类似，后面可以接判断条件，也可以是可选绑定，紧接着后面是 else 代码块处理条件不满足的情况，并且记得 return，然后 else 代码块后面是处理条件成立时候的语句。