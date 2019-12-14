---
title: Enumerations in Swift
date: 2017-10-10 15:53:47
categories: Swift
tags: swift
---

枚举为一组相关的值定义了一个共同的类型，以便在代码中以类型安全的方式使用这些值。在 C 语言中，枚举会为枚举成员分配一个对应的整形值。Swift 中的枚举更加灵活，可以不必为每一个成员提供对应的值。在 Swift 中这个值被称为**原始值 (Raw Value)**，原始值的类型可以是字符串，字符，整形值或浮点数。与枚举有关的内容主要包括：

- 基本语法 (Basics)
- 原始值 (Raw values)
- 关联值 (Associated values)
- 没有成员的枚举 (Case-less enumerations)
- 递归枚举 (Recursive enumerations)

主要参考了 *Swift Apprentice* 和 *The Swift Programming Language*。

<!---more--->

## Basics

定义一个枚举类型和定义类和结构体类似，只是使用 **enum** 关键字，然后在枚举成员前标上 **case** 关键字。假如要写一个函数，函数接收一个用来表示月份的字符串，输出对应的学期，那么可以使用一个字符串数组实现：

```swift
let months = ["January", "February", "March", "April", "May", "June", "July", "August","September", "October", "November", "December"]

func semester(for month: String) -> String {
  switch month {
    case "January", "February", "March", "April", "May":
    	return "Spring"
    case "August", "September", "October", "November", "December":
    	return "Autumn"
    default:
    	return "Not in the school year"
  }
}

semester(for: "April") // Spring
```

上面的代码可以实现需要的功能，但是输入一个字符串的时候容易出现错误，而这种错误会使结果不正确。所以就可以改用一个枚举类型来实现上面的函数，这样输入的时候会进行类型检查和自动补全，可以避免错误的产生。

```swift
enum Month {
  case january, february, march, april, may, june, july, august, september, october, november, december
}
// 重写semester函数，参数类型为Month而不再是String
func semester(for month: Month) -> String {
  switch month {
  	case Month.january, Month.february, Month.march, Month.april, Month.may:
  		return "Spring"
  	case Month.august, Month.september, Month.october, Month.november, Month.december:
  		return "Autumn"
  	default: 
  		return "Not in the school year"
  }
}
```

因为 Swift 会根据参数类型进行推断，所以 semester 函数还可以写成下面的样子：

```swift
func semester(for month: Month) -> String {
  switch month {
    case .january, .february, .march, .april, .may:
    	return "Spring"
    case .august, .september, .october, .november, .december:
    	return "Autumn"
    default:
    	return "Not in the school year"
  }
}
```

Switch 语句要求是完备的，也就是所列的 case 中必须包括所有可能的情况，对于不需要处理的情况，可以放在 default 中。所以当 month 的类型是 String 时，你就必须要使用 default，因为你不可能列出所有可能的字符串。而使用 Month 类型以后，就可以在下面的代码中安全的移除 default。

```swift
func semester(for month: Month) -> String {
  switch month {
    case .january, .february, .march, .april, .may:
    	return "String"
    case .june, .july:
    	return "Summer"
    case .august, .september, .october, .november, .december:
    	return "Autumn"
  }
}
```

Swift 的枚举类型中还可以定义计算属性和方法，方法既可以是成员方法也可以是类型方法，但是不可以定义存储属性。比如上面的函数我们可以作为计算属性，写在 Month 内部。

```swift
enum Month {
  case january, february, march, april, may, june, july, august, september, october, november, december
  
  var semester: String {
    switch self {
      case .january, .february, .march, .april, .may:
    	  return "String"
      case .june, .july:
    	  return "Summer"
      case .august, .september, .october, .november, .december:
    	  return "Autumn"
    }
  }
}
let may = Month.may
may.semester // Spring
```



## Raw values

Swift 不会自动为枚举中的成员自动生成一个对应的整型值，但是仍然允许根据需要为各个成员指定一个值而且值的类型不仅仅局限于整形。假如要为 Month 中的成员指定一个对应的数字与之对应，可以使用下面的语句：

```swift
enum Month: Int {
  case january = 1, february = 2, march = 3, april = 4, may = 5, june = 6, july = 7, august = 8, september = 9, october = 10, november = 11, december = 12
}
```

同 C 语言类似，并不需要为每一个成员都指定一个值，后面的值会根据前面的值递增。所以上面的代码与下面的等价：

```swift
enum Month: Int {
  case january = 1, february, march, april, may, june, july, august, september, october, november, december
}
```

若要访问成员对应的值，可以使用 **rawValue** 属性，比如下面的函数可以用来计算本年度还剩下几个月：

```swift
func monthUntilWinterBreak(from month: Month) -> Int {
  return Month.december.rawValue - month.rawValue
}
monthUntilWinterBreak(from: .april) // 8
```

枚举中的成员还可以使用 rawValue 进行初始化：

```swift
let fifthMonth = Month(rawValue: 5)! // 使用 rawValue 初始化返回的是一个可选值
monthUntilWinterBreak(from: fifthMonth) // 7
```

### String raw values

枚举类型的 rawValue 还可以指定为 String，假如没有为成员指定特定的字符串，默认生成的字符串与成员的名字相同。

```swift
enum Icon: String {
  case music
  case sports
  case weather
}
Icon.music.rawValue // "music"
```

### Unordered raw values

rawValue 不要求是有序的，所以完全可以根据需要定义 rawValue 的值：

```swift
enum Coin: Int {
  case penny = 1
  case nickel = 5
  case dime = 10
  case quarter = 25
}

let coin = Coin.quarter
coin.rawValue // 25
```

## Associated values

除了可以为枚举成员定义原始值，还可以定义关联值。这样就可以为成员存储额外的自定义信息，并且每次在代码中使用该枚举成员时，还可以修改这个关联值。关联值可以是任意类型，而且各个成员之间的关联值类型可以互不相同。假如一个库存跟踪系统需要支持两种不同类型的条形码来跟踪商品，有些商品上使用数字标记的一维条形码，有些商品使用标有 QR 码格式的二维码。每个一维条形码都由4个字段组成，分别表示数字系统、厂商代码、产品代码和检查位。所以枚举类型可以定义为如下格式：

```swift
enum Barcode {
  case upc(Int, Int, Int, Int) // upc的关联值类型为包含4个Int的元组
  case qrCode(String) // qrCode的关联值类型为String
}
```

上面的定义没有提供任何关联值，它只是定义了枚举中各个成员的关联值的类型。然后可以使用任意一种条形码类型创建新的条码：

```swift
var productBarcode = Barcode.upc(8, 85909, 51226, 3) // 创建一个变量，设置其类型和关联值
productBarcode = .qrCode("ABCDEFG") // 同一个商品还可以分配一个不同类型的二维码
```

原始的 Barcode.upc 及其关联值被新的 Barcode.qrCode 及其关联值替代。Barcode 类型的变量或常量可以存储一个 .upc 或者 .qrCode 但是同一时间只能存储两个值中的一个。可以使用 switch 语句来检查不同的条码类型，这时关联值也可以使用 let 或 var 提取出来使用：

```swift
switch productBarcode {
  case .upc(let numberSystem, let manufacturer, let product, let check):
  	print("UPC: \(numberSystem), \(manufacturer), \(product), \(check)")
  case .qrCode(let productCode):
  	print("QR code: \(productCode)")
} // 打印 "QR code: ABCDEFG"
```

如果一个枚举成员的所有关联值都被提取为常量或者变量，那就可以只在成员名称前标注一个 let 或者 var。

```swift
switch productBarcode {
  case let .upc(numberSystem, manufacturer, product, check):
  	print("UPC: \(numberSystem), \(manufacturer), \(product), \(check)")
  case let .qrCode(productCode):
  	print("QR code: \(productCode)")
} // 打印 "QR code: ABCDEFG"
```

## Case-less enumerations

在将结构体的时候曾经说过可以通过将某一类的方法定义为类型方法放在结构体中，产生类似于命名空间的作用。比如计算阶乘的方法：

```swift
struct Math {
  static func factorial(of number: Int) -> Int {
    return (1...number).reduce(1, *)
  }
}
let factorial = Math.factorial(of: 6) // 720
let math = Math()
```

有一个问题可能已经注意到了就是结构体 Math 是可以实例化的，但是 Math 中仅有一个类型方法，所以实例化是没有意义的。在这种情况下，更好的实现是将 Math 由结构体类型改为枚举类型，这样在没有任何成员变量的情况下对枚举类型进行实例化会产生错误。

```swift
enum Math {
  static func factorial(of number: Int) -> Int {
    return (1...number).reduce(1, *)
  }
}
let factorial = Math.factorial(of: 6) // 720
let math = Math() // error
```

## Recursive enumerations

递归枚举是一种枚举类型，它有一个或多个枚举成员使用该枚举类型的实例作为关联值，使用递归枚举时，编译器会插入一个间接层，可以在枚举成员前加上 **indirect** 来表示该成员可递归，例如下面的例子中，枚举类型存储了简单的算术表达式：

```swift
enum ArithmeticExpression {
  case number(Int)
  indirect case addition(ArithmeticExpression, ArithmeticExpression)
  indirect case multiplication(ArithmeticExpression, ArithmeticExpression)
}
```

当然，也可以在枚举类型开头加上 indirect 关键字来表示它的所有成员都是可递归的。

```swift
indirect enum ArithmeticExpression {
  case number(Int)
  case addition(ArithmeticExpression, ArithmeticExpression)
  case multiplication(ArithmeticExpression, ArithmeticExpression)
}
```

上面定义的枚举类型可以存储3种表达式：纯数字、两个表达式求和、两个表达式求积。枚举成员 addition 和 multiplication 的关联值也是算术表达式，这些关联值使得嵌套表达式成为可能。例如表达式 (5 + 4) * 2，乘号左边是个表达式，右边是纯数字。下面使用 ArithmeticExpression 这个递归枚举创建表达式。

```swift
let five = ArithmeticExpression.number(5)
let four = ArithmeticExpression.number(4)
let sum = ArithmeticExpression.addition(five, four)
let product = ArithmeticExpression.multiplication(sum, ArithmeticExpression.number(2))
```

要操作具有递归性质的数据结构，使用递归函数是一种直截了当的方式，例如下面一个对算术表达式求值的函数：

```swift
func evaluate(_ expression: ArithmeticExpression) -> Int {
  switch expression {
    case let .number(value):
    	return value
    case let .addition(left, right):
    	return evaluate(left) + evaluate(right)
    case let .multiplication(left, right):
    	return evaluate(left) * evaluate(right)
  }
}
print (evaluate(product))
```

该函数遇到纯数字就直接返回数字的值，如果遇到加法和乘法就会递归计算出表达式的值。

