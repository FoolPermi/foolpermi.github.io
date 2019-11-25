---
title: Collection Types in Swift
date: 2019-11-25 23:13:54
categories: Swift
tags: swift
---
同各种常见的语言一样，swift 中也包括各种集合类型。swift 中的集合类型可以分为以下几种: **Array**, **Set**, **Dictionary**.
声明一个集合类型的时候，必须明确指出集合类型是 **let** 还是 **var**, 使用的关键字不同将决定集合中的元素在声明以后是否可以改变。

## Array

数组是按照一定顺序存储相同类型数据的合集。数组元素的下标从 0 开始，依次递增。

### Creating Arrays

创建数组的方法有很多种，可以使用 **[]** 来创建一个数组，也可以使用 **Array** 关键字来创建一个数组。创建数组的时候可以明确指出数组中元素的类型，如果没有指出，编译器会根据数组中的元素进行类型推断。

```swift
// eg1:
let evenNumbers = [2, 4, 6, 8] // 数组的类型为[Int]
// eg2:
var subscribers: [String] = [] // 创建空数组，必须指定数组类型
// eg3:
let allZeros = Array(repeating: 0, count: 5) // [0, 0, 0, 0, 0]
```

### Accessing elements

数组中有很多的属性和方法，可以使用数组中的属性和方法来操作和访问数组中的元素。

```swift
var players = ["Alisa", "Bob", "Cindy", "Dennis"]
print(players.isEmpty) // false
print(players.count) // 4
var currentPlayer = players.first // access first element
print(currentPlayer as Any) // currentPlayer is optional
print(players.last as Any) // last element is also optional
currentPlayer = players.min() // optional
var firstPlayer = players[0] // 使用下标访问
players.contains("Bob") // 元素检查
```

### ArraySlice

可以给数组指定一个 range, 然后可以返回一个包含部分元素的子数组，也称为切片。创建一个切片的方法如下。

```swift
var players = ["Alisa", "Bob", "Cindy", "Dennis"]
let upcomingPlayersSlice = players[1...2]
print(upcomingPlayersSlice[1], upcomingPlayersSlice[2]) // "Bob", "Cindy"
```

### Modifying Arrays

使用 var 声明的数组在创建以后可以进行增加/删除/插入/更新元素等操作。

```swift
var players = ["Alisa", "Bob", "Cindy", "Dennis"]
// add elements
players.append("Eli")
players += ["Gina"]
// remove elements
var removedPlayer = players.removeLast()
removedPlayer = players.remove(at: 2)
// insert elements
players.insert("Frank", at: 3)
// update elements
players[4] = "Linda"
// swap elements
players.swapAt(1, 3)
```

### Array Iteration

使用 for-in 遍历数组中的元素及其下标。

```swift
var players = ["Alisa", "Bob", "Cindy", "Dennis"]
for player in players {
    print(player)
}
for (index, player) in players.enumerated() {
    print("\(index + 1). \(player)")
}
```
