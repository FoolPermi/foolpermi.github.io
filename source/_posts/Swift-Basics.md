---
title: Swift Basics
date: 2019-11-4 21:56:37
categories: Swift
tags: swift
---
## 基础运算

和其它编程语言一样，swift支持加 (+)、减 (-)、乘 (*)、除 (/)、取模 (%)、移位等多种基础运算。

```swift
2 + 6 // ok
2+6 // ok
2 +6 // error
2+ 6 // error
2 - 6
2 * 6
6 / 2
6.0 / 2.0
28 % 10
(28.0).truncatingRemainder(dividingBy: 10.0) // 浮点数取模
1 << 3 // 8
32 >> 2 // 8
sin(45 * Double.pi / 180)
cos(135 * Double.pi / 180)
(2.0).squareRoot()
max(5, 10) // 10
min(-5, -10) // -10
```

## let VS var

**let** 用来声明常量，**var** 用来声明变量。声明常量或变量的时候可以不指定数据类型，编译器会进行推断。但是一旦确定类型以后，便只能赋予相同类型的变量值。

```swift
let number: Int = 10
var pi: Double = 3.14
var name = "Peter" // name is a string
name = 15 // error
name = "Linda" // ok
```
<!---more--->
## 基本类型和操作符

swift 中基本数据类型有 Int8, UInt8, Int16, UInt16, Int32, UInt32, Int64, UInt64, Float, Double. 大部分情况下可以直接使用 **Int** 和 **Double**.

```swift
let a: Int16 = 12
let b: UInt8 = 255
let c: Int32 = -10000
let sum = Int(a) + Int(b) + Int(c) // result is an Int
```

swift 中表示单个字符和字符串时都是使用引号，当未明确指定类型时默认是字符串类型，所以如果期望表示单个字符，请一定指定类型。

```swift
let charA: Character = "a"
let strA: String = "a"
let strB = "b" // so if you want to make a Char, you must explicit its type
var name = "Jay"
var greeting = "My name is \(name)" // "My name is Jay"
// 多行字符串
let bigStr = """
                This is 
                a Multiple lines
                string.
             """
```

Tuple 类型用来表示具有多个字段的数据元组。

```swift
let coordinates: (Int, Int) = (2, 3) // coordinates 的类型为 (Int, Int)
let location = (2.1, 3.5, 1) // location 类型推断为 (Double, Double, Int)
let x1 = coordinates.0 // 使用下标访问 Tuple 中的元素
let y1 = coordinates.1
let location3D = (x: 2, y: 3, z: 4) 
let x2 = location3D.x // 使用元素名访问 Tuple 中元素
let y2 = location3D.y
let z2 = location3D.z
let (x3, y3, z3) = location3D
```

## Type alias

**typealias** 是 swift 中用来给类型指定别名的关键字，相当于 C 语言中的 typedef.

```swift
typealias Animal = String
let myPet: Animal = "Dog"
typealias Coordinates = (Int, Int)
let xy: Coordinates = (2, 4)
```

## Basic Control Flow

### Bool 类型

swift 中 Bool 类型的两种取值是 **true** 和 **false**.

```swift
let yes: Bool = true
let no: Bool = false
let and = (2 > 1) && ("Hello" == "World")
let or = (2 > 1) || ("Hello" == "World")
let not = !(2 > 1)
var switchState = true
switchState.toggle() // switchState = false
switchState.toggle() // switchState = true
```

### if 语句

swift 中 if 语句后面的条件不需要使用**括号()**。

```swift
if condition1 {

} else if condition2 {

} else {

}
```

### while 语句

和 if 语句类似，while 语句后面的条件也不需要使用括号。repeat-while 语句类似于其它语言中的 do-while, 循环体中的代码至少会被执行一次。

```swift
while condition {
    loop code
}
repeat {
    loop code
} while condition
```

### for 语句

swift 不支持 C Style 的 for 语句。而且在 for 语句的条件里面可以使用 where 关键字对循环的对象进行筛选。

```swift
for constant in range {
    loop code
}
// eg1:
let count = 10
var sum = 0
for i in 0...10 { // 此处 i 不需要使用 let 或 var 
    sum += i
}
// eg2:
let step = 5
var sum = 0
for _ in 0..<10 { // 如果不需要访问 i 的值，可以使用 _ 代替
    sum += step
}
// eg3:
var sum = 0
for i in 0...10 where i % 2 == 0 { // 可以使用 where 来指定附加条件, 只有 where 条件为 true 时，循环体才会执行
    sum += i
}
// eg4:
var sum = 0
for row in 0..<8 {
    if row % 2 == 0 {
        continue // 使用 continue 跳出本次循环
    }
    for column in 0..<8 {
        sum += row * column
    }
}
// eg5:
var sum = 0
rowLoop: for row in 0..<8 {
    columnLoop: for column in 0..<8 {
        if row == column {
            continue rowLoop // 通过添加 label，跳出指定 level 循环
        }
        sum += row * column
    }
}
```

### switch 语句

swift 中的 switch 语句非常灵活，可以匹配多种 case，而且 break不是必需的，除非 case 下面没有任何需要执行的 code 时，需要使用 break。

```swift
// eg1:
let animal = "Dog"
switch animal {
    case "Dog", "Cat":
        print("It is a house animal")
    default:
        print("It is not a house animal")
}
// eg2:
let hourOfDay = 12
var timeOfDay = ""
switch hourOfDay {
    case 0, 1, 3, 4, 5:
        timeOfDay = "Early morning"
    case 6, 7, 8, 9, 10, 11:
        timeOfDay = "Morning"
    case 12, 13, 14, 15, 16:
        timeOfDay = "Afternoon"
    case 17, 18, 19:
        timeOfDay = "Evening"
    case 20, 21, 22, 23:
        timeOfDay = "Later Evening"
    default:
        timeOfDay = "Invalid time"
}
print(timeOfDay)
// eg3:
let hourOfDay = 12
var timeOfDay = ""
switch hourOfDay {
    case 0...5:
        timeOfDay = "Early morning"
    case 6...11:
        timeOfDay = "Morning"
    case 12...16:
        timeOfDay = "Afternoon"
    case 17...19:
        timeOfDay = "Evening"
    case 20...23:
        timeOfDay = "Later Evening"
    default:
        timeOfDay = "Invalid time"
}
print(timeOfDay)
// eg4:
let num = 10
switch num {
    case let x where x % 2 == 0:
        print("Even")
    default:
        print("Odd")
}
// eg5:
let num = 10
switch num {
    case _ where num % 2 == 0:
        print("Even")
    default:
        print("Odd")
}
// eg6:
let coordinates = (x: 3, y: 2, z: 5)
switch coordinates {
    case (0, 0, 0):
        print("Origin")
    case (_, 0, 0):
        print("X-axis")
    case (0, _, 0):
        print("Y-axis")
    case (0, 0, _):
        print("Z-axis")
    default:
        print("Somewhere")
}
// eg7:
let coordinates = (x: 3, y: 2, z: 5)
switch coordinates {
    case (0, 0, 0):
        print("Origin")
    case (let x, 0, 0):
        print("X-axis at x = \(x)")
    case (0, let y, 0):
        print("Y-axis at y = \(y)")
    case (0, 0, let z):
        print("Z-axis at z = \(z)")
    case let(x, y, z):
        print("Somewhere at (\(x), \(y), \(z))")
}
// eg8
let coordinates = (x: 3, y: 2, z: 5)
switch coordinates {
    case let (x, y, _) where y == x:
        print("Y-X Line")
    case let (x, y, _) where y == x * x:
        print("Y-X^2 Line")
    default:
        break
}
```

参考: Swift Apprentice
