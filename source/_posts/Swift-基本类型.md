---
title: Swift 基本类型
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




