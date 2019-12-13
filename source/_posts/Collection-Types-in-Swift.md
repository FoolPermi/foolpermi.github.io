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

### Creating Array

创建数组的方法有很多种，可以使用 **[]** 来创建一个数组，也可以使用 **Array** 关键字来创建一个数组。创建数组的时候可以明确指出数组中元素的类型，如果没有指出，编译器会根据数组中的元素进行类型推断。

```swift
// eg1:
let evenNumbers = [2, 4, 6, 8] // 数组的类型为[Int]
// eg2:
var subscribers: [String] = [] // 创建空数组，必须指定数组类型
// eg3:
let allZeros = Array(repeating: 0, count: 5) // [0, 0, 0, 0, 0]
```
<!---more--->
### Accessing Array

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

### Modifying Array

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

## Dictionary

Dictionary 是一种存储多个相同类型的值的容器。每个值 (value) 都关联唯一的键 (key), 键作为字典中的这个值数据的标识符。和数组中的数据项不同，字典中的数据项并没有具体顺序。

### Creating Dictionary

```swift
var nameAndScores = ["Anna": 2, "Linda": 6, "Ermei": 3, "Bella": 5] // type: [String: Int]
nameAndScores = [:] // make existed dictionary empty
// create an empty dictionary
var namesAndAges: [String: Int] = [:]
```

### Accessing Dictionary

```swift
var namesAndScores = ["Anna": 2, "Linda": 6, "Ermei": 3, "Bella": 5]
var scoreOfAnna = namesAndScores["Anna"] // 2
namesAndScores.isEmpty // false
namesAndScores.count // 4
```

### Modifying Dictionary

```swift
var namesAndScores = ["Anna": 2, "Linda": 6, "Ermei": 3, "Bella": 5]
namesAndScores.updateValue(4, forKey: "Ermei")
namesAndScores["Bella"] = 7 // update element, add it if not exist
namesAndScores.removeValue(forKey: "Anna")
namesAndScores["Linda"] = nil // remove element
```

如果 Dictionary 中的 value 是 optinal 类型的元素，通过 `dic[key] = nil`, 的方式仍然会移除元素，如果想要将 optional 的元素设置为 nil, 必须使用 `dic.updateValue(nil, forKey: key)` 的方式。

### Dictionary Iteration

```swift
var namesAndScores = ["Anna": 2, "Linda": 6, "Ermei": 3, "Bella": 5]
for (name, score) in namesAndScores {
    print("\(name) - \(score)")
}
for name in namesAndScores.keys {
    print("\(name)")
}
for score in namesAndScores.values{
    print("\(score)")
}
```

## Set

Set 用来存储类型相同且没有确定顺序的值。与数组的主要区别是集合中的元素是无序的，而且集合中的元素不允许重复。

### Creating Set

```swift
let setOne: Set<Int> = [1]
let someSet = Set([1, 3, 2, 4])
```

### Accessing Set

```swift
var someSet: Set<Int> = [1, 3, 2, 4]
someSet.contains(1) // true
someSet.contains(5) // false
```

### Modifying Set

```swift
var someSet:Set<Int> = [1, 3, 2, 4]
someSet.insert(5)
someSet.remove(1)
```

### Set Iteration

```swift
var someSet: Set<Int> = [1, 3, 2, 4]
for num in someSet {
    print("\(num)")
}
```

## Strings

Swift 中 String 类似于集合类型，所以可以使用集合类型遍历的方法来遍历一个 String。和普通的集合类型有所区别的是，不可以使用下标来直接获取 String 中指定位置的字符。因为 String 中的字符由于编码方式的差异，可能需要不同字节长度的存储空间。

### Creating/Accessing Strings

```swift
let string = "Ray"
var greeting = String("Hello World")
for char in string {
    print(char)
}
let strLen = string.count
let secondChar = string[1] // error
let cafeNormal = "café"
let cafeCombining = "cafe\u{0301}"
cafeNormal.count // 4
cafeCombining.count // 4
cafeNormal.unicodeScalars.count // 4
cafeCombining.unicodeScalars.count // 5

let equal = cafeNormal == cafeCombining // true
```

### Indexing Strings

```swift
let cafeNormal = "café"
let firstIdx = cafeNormal.startIndex
let firstChar = cafeNormal[firstIdx]

let fourthIdx = cafeNormal.index(cafeNormal.startIndex, offsetBy: 3)
let fourthChar = cafeNormal[fourthIdx] // é
fourthChar.unicodeScalars.count // 1
fourthChar.unicodeScalars.forEach { codePoint in
    print(codePoint.value)
}

let lastIdx = cafeNormal.index(before: cafeNormal.endIndex)
let lastChar = cafeNormal[lastIdx] // é
```

### Strings as Collections

```swift
let name = "Matt"
let backwardsName = name.reversed() // ReversedCollection<String>
let thirdCharIdx = backwardsName.index(backwardsName.startIndex, offsetBy: 2)
let thirdChar = backwardsName[thirdCharIdx]

let backwardsNameStr = String(backwardsName)
```

### Raw Strings

当 String 中含有需要转译的字符时，为了避免转译，可以使用 '#' 来标记为 **Raw String**.

```swift
let raw1 = #"Raw "No Escaping" \(no interpolation!). Use all the \ you want!"#
print(raw1) // Raw "No Escaping" \(no interpolation!). Use all the \ you want!
let raw2 = ##"Aren't we "# clever"##
print(raw2) // Aren't we "# clever
let can = "can do that too"
let raw3 = #"Yes we \#(can)!"#
print(raw3) // Yes we can do that too!
```

### Substrings

```swift
let fullName = "Peter Xu"
let spaceIdx = fullName.firstIndex(of: " ")!
let firstName = fullName[fullName.startIndex..<spaceIdx] // "Peter"
let firstName = fullName[..<spaceIdx] // "Peter"
let lastName = fullName[fullName.index(after: spaceIdx)...]
```

### Characters

```swift
let singleChar: Character = "x"
singleChar.isASCII // true
let emojiChar: Character = "🤣"
emojiChar.isASCII // false
let space: Character = " "
space.isWhitespace // true
let hexDigital: Character = "d"
hexDigital.isHexDigit // true
let thaiNine: Character = "๙"
thaiNine.wholeNumberValue // 9
```
