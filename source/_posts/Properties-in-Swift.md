---
title: Properties in Swift
date: 2016-11-20 16:41:01
categories: Swift
tags:
---

最近读了*Swift Apprentice*, 将其中一些关于 Property 的知识总结一下。主要包括以下几个部分:

- 存储属性 ( Stored Properties )
- 计算属性 ( Computed Properties )
- 类型属性 ( Typed Properties)
- 属性观察器 ( Property Observers )
- 延迟加载属性 ( Lazy Properties )

<!---more--->

在下面的例子中，结构体 Car 有两个属性，存储了两个字符串常量。

```swift
struct Car {
  let make: String
  let color: String
}
```

上面的属性称为**存储属性 (stored property)**,表示它们将会为每个 Car 的实例开辟内存并且存储值。

除了存储属性外还有一种**计算属性 (computed property)**,在创建实例的时候并不会为计算属性分配空间，而只是在需要的时候简单的计算它们的值。

## Stored properties

假如你想创建一个通讯录，那么通讯录中的每一条联系人的组成可能是下面这样:

```swift
struct Contact {
  var fullName: String
  var emailAddress: String
}
```

Contact 中的属性并没有赋上初始值，所以只能通过**构造函数 (initializer)**来实例化，Swift 会根据类型中的属性，自动生成一个构造函数。

```swift
var person = Contact(fullName: "Grace Murray", emailAddress: "grace@navy.mil")
```

实例化完成以后，就可以使用**点运算符 (dot notation)**来访问实例中的属性:

```swift
let name = person.fullName // Grace Murray
let email = person.emailAddress // grace@navy.mil
```

如果存储属性的实例是变量，而且属性也是个变量，那么就可以给属性赋值，

```swift
// Grace got married so she changed her name
person.fullName = "Grace Hopper"
let grade = person.fullName // Grace Hopper
```

如果一个属性在实例化以后不可以被改变的话，那么声明的时候可以使用 **let** 将其声明为常量。

```swift
struct Contact {
  var fullName: String
  let emailAddress: String // emailAddress是个常量，实例化完成后就不可以再修改
}
var person = Contact(fullName: "Linda", emailAddress: "sb@baidu.com") // 实例化
person.emailAddress = "sb@sohu.com" // error: 不可以修改一个常量的值
```

### Default values

如果一个属性的值是可以预测的，而且很少变动的话，那么可以给属性设置一个默认值。下面为 Contact 增加一个属性 type 用于标记联系人所属的分组。

```swift
struct Contact {
  var fullName: String
  let emailAddress: String
  var type = "Friend" // property with default value
}
// 设置默认值在一定程度上可以减少代码负担，缺点是Swift根据属性自动生成的构造函数中还需要指定type的值，除非你实现了一个自定义的构造函数
var person = Contact(fullName: "Linda", emailAddress: "sb@baidu.com", type: "Friend")
```

## Computed properties

**存储属性 (stored property)**既可以是常量也可以是变量，而**计算属性 (computed property)**只能是变量，而且必须明确指出属性的类型。

下面以 TV 为例说明，其中包括 3 个属性，分别是 height 、width 、diagonal 分别表示 TV 的高、宽、对角线长度。

```swift
struct TV {
  var height: Double
  var width: Double
  // diagonal 为计算属性，必须指定其类型，而且只能声明为变量 (var)
  var diagonal: Int {
    let result = sqrt(height * height + width * width)
    let roundedResult = result.rounded()
    return Int(roundedResult)
  }
}
// 计算属性不存储值，只是计算结果后返回
var tv = TV(height: 53.93, width: 95.87)
let size = tv.diagonal // 110
```

上面的 diagonal 只有一个**getter**，还可以实现一个**setter**，因为计算属性不存储值，所以**setter**中一般都是通过修改相关的存储属性实现的。

```swift
var diagonal: Int {
  get {
    let result = sqrt(height * height + width * width)
    let roundedResult = result.rounded()
    return Int(roundedResult)
  }
  set {
    let ratioWidth = 16.0
    let ratioHeight = 9.0
    // 修改height和width
    height = Double(newValue) * ratioHeight /
      sqrt(ratioWidth * ratioWidth + ratioHeight * ratioHeight)
    width = height * ratioWidth / ratioHeight
  }
}
```

## Type properties

上面 TV 的存储属性 height、width 和计算属性 diagonal 都是属于 TV 的实例的，所以必须实例化以后才能使用。而类型属性是属于类型本身的，通过类型名进行访问。

假如有一个存在多个关卡的游戏，每一关都是一个 Level 实例，并且拥有一些属性。

```swift
struct Level {
  let id: Int
  var boss: String
  var unlocked: Bool
}
let level1 = Level(id: 1, boss: "Chameleon", unlocked: true)
let level2 = Level(id: 2, boss: "Squid", unlocked: false)
```

现在给 Level 增加一个属性 highsetLevel 用于标记已解锁的最高关卡。

```swift
struct Level {
  static var highestLevel = 1 // 使用static标记一个类型属性
  let id: Int
  var boss: String
  var unlocked: Bool
}
```

现在，highestLevel 是 Level 类型本身的属性，而不是 Level 的**实例 (instance)**。所以访问的时候使用类型名直接进行访问。

```swift
// Error:不能通过实例访问类型属性 
let highestLevel = level2.highestLevel
// Right:只能使用类型名访问类型属性
let highestLevel = Level.highestLevel
```

## Property observers

在实现  Level 的时候，正确的操作应该是当一个新的关卡解锁 (unlocked) 的时候，用于标记最高关卡的 highestLevel 属性也随之改变。所以可以通过 Swift 的**属性观察器 (Property Observer)**来监测属性的变化。属性观察器包括两个方法 **willSet** 和 **didSet**，两者只是调用的时机不同。

```swift
struct Level {
  static var highestLevel = 1
  let id: Int
  var boss: String
  var unlocked: Bool {
    didSet {
    // 当关卡已解锁，当前所在关卡大于已记录的最高关卡时，更新最高关卡的值
      if unlocked && id > Level.highestLevel {
        Level.highestLevel = id
      }
    }
  }
}
```

现在，当解锁新的关卡时，最高关卡的值就会自动更新。注意 **willSet** 和 **didSet** 并不会在初始化的时候被调用，只有在完成初始化以后，再更改属性的值，才会被调用。

### Limiting a variable

属性观察器还可以用来约束属性的值，当设置的值不符合要求时进行相应的处理。didSet 中有个 **oldValue** 表示改变之前的值，willSet 中有个 **newValue** 表示新的值。

```swift
struct LightBulb {
  static let maxCurrent = 40
  var current = 0 {
    didSet {
      if current > LightBulb.maxCurrent {
        print("Current too high, falling back to previous setting.")
      	current = oldValue
      }
    }
  }
}
// 当设置不满足条件的时候，就会进行相应处理
var light = LightBulb()
light.current = 50
var current = light.current // 0
light.current = 40
current = light.current // 40
```

## Lazy properties

如果有一些属性，初始化的时候并不需要知道它们的值，而只在需要的时候才进行计算，就可以使用 **Lazy Property**。下面定义一个结构体 Circle 进行说明。

```swift
struct Circle {
  lazy var pi = {
    return ((4.0 * atan(1.0 / 5.0)) - atan(1.0 / 239.0)) * 4.0
  }()
  var radius = 0.0
  var circumference: Double {
    mutating get {
      return pi * radius * 2
    }
  }
  // 自定义了init
  init (radius: Double) {
    self.radius = radius
  }
}
```

上面的结构体 Circle 中定义了一个 **lazy property**，注意 **lazy property** 必须是一个变量 **var**，上面的 pi 的计算是一个闭包，所以后面有一对小括号，当访问 pi 的值时，闭包会被立即调用。实例化 Circle 的时候，尽管 pi 是存储属性，但并不需要提供 pi 的值，pi 的值会在第一次访问的时候被计算并存储起来。与之对比，属性 circumference 是一个计算属性，每次访问它的值都需要计算。注意 circumference 属性的 **getter** 前有一个 **mutating** 关键字，因为在 **getter** 中使用了 pi，在获取 circumference 的时候会导致 pi 被计算，而原来实例在初始化的时候并没有设置 pi 的值，所以实例发生了改变，从而需要 **mutating** 关键字。

```swift
var circle = Circle(radius: 5) // 实例化一个Circle，此时pi还没有被计算
let circumference = circle.circumference // 31.42, 此时pi也有了值
```
