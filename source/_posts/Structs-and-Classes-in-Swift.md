---
title: Structs and Classes in Swift
date: 2016-11-21 23:15:36
categories: Swift
tags:
---

在 Swift 中**结构体 (struct)** 和**类 (class)** 有很多相似的地方，也有一些不同之处，下面记录并总结。内容主要参考了 *Swift Apprentice*。

## Struct

### Basics

Struct 作为一种常见的数据类型，在许多编程语言中都存在。我们使用 Struct 封装特定的数据结构。Swift 中赋予了 Struct 很多特性，比如 Struct 中除了可以定义属性外，还可以定义**方法 (method)** 和**构造函数 (initializer)**。

举个例子，为了表示在平面坐标系中的位置，定义一个结构体 Location，其中包括两个属性 x 和 y。

```swift
struct Location {
  var x: Int
  var y: Int
}
```

上面就定义了一个结构体，然后就可以实例化以后使用，假如你没有实现  **init** 方法的话，结构体可以根据属性自动产生一个构造器:

```swift
var location = Location(x: 2, y: 4)
// 使用点运算符访问
print(location.x) // 2
print(location.y) // 4
```

<!---more--->

现在为 Location 增加一个方法用于计算距离坐标原点的距离。

```swift
struct Location {
  var x: Int
  var y: Int
  func distanceToOrigin() -> Double {
    let x = Double(self.x)
    let y = Double(self.y)
    return sqrt(x ** x + y ** y) 
  }
}
// 调用结构体中的方法
var location = Location(x: 3, y: 4)
let distance = location.distanceToOrigin() // 点运算符
print(distance) // 5.0
```

### Value type

Struct 是**值类型 (value type)**，所以 Struct 在传递的时候拷贝的是**值**，而不是**引用**。

```swift
var location1 = Location(x: 3, y: 4)
var location2 = location1
location1.x = 4 // 更改 location1
print(location1.x) // 4
print(location2.x) // 3, location2的值不变，说明两个实例分别占用的不是同一块内存
```

### Extensions

可以通过**扩展 (extensions)** 给一个结构体追加方法或者计算属性，但是不可以追加存储属性。此外，还可以在扩展中实现自定义的 **init** 方法，在扩展中实现的 **init** 方法将不会使结构体根据属性自动生成的 **init** 失效。

```swift
extension Location {
  var gradient: Double { // 追加一个计算属性来获取斜率
    let y = Double(self.y)
    let x = Double(self.x)
    guard x != 0 else {
		return 0
    }
	return y / x
  }
  init() {
    x = 0
    y = 0
  }
}
var location1 = Location() // 使用自定义的init
var location2 = Location(x: 3, y: 4) // 使用自动生成的init
```

### Conform to protocols

Struct 可以遵守**协议 (protocols )**，并实现协议定义的属性或方法。下面遵守协议并实现 **description** 的过程如下:

```swift
struct Location: CustomStringConvertible {
  var x: Int
  var y: Int
  var description: String {
    return "location at (\(x),\(y))."  
  }
  func distanceToOrigin() -> Double {
    let x = Double(self.x)
    let y = Double(self.y)
    return sqrt(x ** x + y ** y) 
  }
}
```

## Class

### Basics

Swift中的类和结构体类似，也可以定义**属性**、**方法**、**遵守协议**。除此之外，类还拥有**继承 (inheritance)**、**重写 (override)**、**多态 (polymorphism)** 等结构体不具有的功能。

下面从实现一个 Person 类开始，Person 类中有两个存储属性和一个 **init** 方法，注意，class 并不会根据属性自动生成一个构造函数，所以必需手动实现 init 方法，假如没有提供，就会产生错误。

```swift
class Person {
  var firstName: String
  var lastName: String
  init(firstName: String, lastName: String) {
    self.firstName = firstName
    self.lastName = lastName
  }
}
let john = Person(firstName: "Johnny", lastName: "Ivy")
```

### Reference type

在Swift 中，结构体是一个**不可变的值类型 (immutable value)**，而类则是**可变的引用类型 (mutable reference)**。所以即使类中的某个方法改变了类的内容，也不需要在方法前使用 **mutating** 关键字。

```swift
var person1 = Person(firstName: "Bruce", lastName: "Lee")
var person2 = person1 // 传递引用
print(person2.firstName) // Bruce
person1.firstName = "Jack"
print(person2.firstName) // Jack
```

若要比较两个对象指向的是不是同一块内存，可以使用 **"==="** 运算符，常用的 **"=="** 运算符只用于比较值是否相等。

```swift
var person1 = Person(firstName: "Bruce", lastName: "Lee")
var person2 = Person(firstName: "Bruce", lastName: "Lee") // person2和person1名字相同，是同一个人?
var person3 = person1 // person3和person1指向同一块内存
print(person1 === person2) // false
print(person1 === person3) // true
```

因为对象是引用类型，所以即使将一个对象声明为常量，也可以改变对象中属性的值。常量表示对象指向内存的位置不可变，但是内存中存储的内容可以改变。

```swift
let person = Person(firstName: "Bruce", lastName: "Lee") // person为常量
person.firstName = "Jack" // 更改person的属性
print(person.firstName) // Jack, 属性的值仍然被改变了
```

### Extensions

与结构体类似，类也可以通过 extension 添加方法和计算属性。假如要添加一个计算属性  fullName，实现如下：

```swift
extension Person {
  var fullName: String {
	return "\(firstName) \(lastName)"
  }
}
```

### Inheritance

**继承 (inheritance)** 可以实现类的扩展，为已存在的类增加新的属性和方法，或者对原有的方法进行**重写 (override)**。

假如有一个 Student 类，定义如下:

```swift
struct Grade {
  let letter: String
  let points: Double
  let credits: Double
}
class Student {
  var firstName: String
  var lastNameL: String
  var grades: [Grade] = [] // 表示成绩
  init(firstName: String, lastName: String) {
    self.firstName = firstName
    self.lastName = lastName
  }
  func recordGrade(_ grade: Grade) {
    grades.append(grade)
  }
}
```

可以看到 Student 也是 Person，所以可以在现有的 Person 类基础上进行扩展来减少代码冗余。

```swift
struct Grade {
  let letter: String
  let points: Double
  let credits: Double
}
class Person {
  var firstName: String
  var lastName: String
  init(firstName: String, lastName: String) {
    self.firstName = firstName
    self.lastName = lastName
  }
}
class Student: Person { // Student继承自Person
  var grades: [Grade] = []
  func recordGrade(_ grade: Grade) {
    grades.append(grade)
  }
}
```

通过继承，Student 拥有了 Person 的属性、构造函数和其它的方法。然后就可以像使用 Person 一样使用 Student。

```swift
let john = Person(firstName: "Johnny", lastName: "Ivy")
let jane = Student(firstName: "Jane", lastName: "Ivy")
print(john.firstName) // Johnny
print(jane.firstName) // Jane
```

除了继承自 Person 的属性和方法外，Student 还有自身的属性 **grades** 和方法，而特有的属性和方法只有 Student 的实例才可以访问。

```swift
let history = Grade(letter: "B", points: 9.0, credits: 3.0)
jane.recordGrade(history)
john.recordGrade(history) // Error: john is not a student
```

Swift 中的类不支持多继承，一个子类最多允许继承自一个父类。

### Polymorphism

**多态 (Polymorphism)** 是许多面向对象的语言的特性，使用多态可以写出更加抽象和灵活的代码，涉及到多态的时候，主要有两个重要的性质：

- 父类的指针可以指向子类的对象
- 不同的对象作用于同一个方法会产生不同的响应

下面仍然使用介绍 Objective-C 中多态的时候所用的例子来说明 Swift 中的多态。

```swift
import Foundation
// 定义一个基类Animal，计算属性用于获取动物的名字，方法用于描述动物被打了以后的反应
class Animal {
  func beBeaten() {
    return
  }
}
// Cat 继承自Animal，并重写了beBeaten()方法
class Cat: Animal {
  override func beBeaten() {
    print("Bark and jump to high!")
  }
  
}
// Dog继承自Animal，并重写了beBeaten()方法
class Dog: Animal {
  override func beBeaten() {
    print("Give a hard bit!")
  } 
}
// Frog继承自Animal，并重写了beBeaten()方法
class Frog: Animal {
  override func beBeaten() {
    print("Do nothing!")
  }
}
// 定义一个Human类，用于攻击animal，注意beatAnimal(:)的参数类型是Animal，并没有指明具体是哪种Animal
class Human {
  var name: String
  init(name: String) {
    self.name = name
  }
  func beatAnimal(animal: Animal) {
    animal.beBeaten()
  }
}
var linda = Human(name: "Linda")
let cat = Cat()
let dog = Dog()
let frog = Frog()
// 同样的方法，作用于不同的对象，产生不同的响应
linda.beatAnimal(animal: cat) // Bark and jump to high!
linda.beatAnimal(animal: dog) // Give a hard bit!
linda.beatAnimal(animal: frog) // Do nothing!
```

### Preventing inheritance

假如有时候，存在某个类，这个类不可以被继承，或者是这个类中的某些方法不允许被重写，那么就可以使用 **final** 关键字，被指定为 **final** 的类不可以被继承，被指定为 **final** 的方法不允许被重写。

```swift
class Animal {
  func beBeaten() -> Void {
    return
  } 
}
// Human类不可以被继承
final class Human {
  var name: String
  init(name: String) {
    self.name = name
  }
  func beatAnimal(animal: Animal) {
    animal.beBeaten()
  }
}
class Man: Human { // Error
  
}
// 被标记为final的方法或属性不可以被重写
class Human {
  var name: String
  init(name: String) {
    self.name = name
  }
  final func beatAnimal(animal: Animal) {
    animal.beBeaten()
  }
}
class Man: Human {
  override func beatAnimal(animal: Animal) { // error
    animal.beBeaten()
  }
```

### Required and convenience initializers

一个类可以有多个构造函数，这意味着在子类中可以任意调用父类的构造函数来完成自身的初始化。通过给 **init** 方法标记 **required** 或者 **convenience** 关键字将其指定为指定构造函数或者便利构造函数。

- 所有子类都必须实现父类的标记为 **required** 的构造函数，而且不需要使用 **override** 关键字。
- 一个指定构造函数必须调用直接父类的指定构造函数。
- 所有便利构造函数最终都要直接或间接调用自身的指定构造函数。

```swift
class Person {
  var firstName: String
  var lastName: String
  required init(firstName: String, lastName: String) {
    self.firstName = firstName
    self.lastName = lastName
    print("I am a person")
  }
  convenience init(person: Person) {
    self.init(firstName: person.firstName, lastName: person.lastName)
  }
}

class Student: Person {
  var sports: [String]
  required init(firstName: String, lastName: String) { // 不需要override 关键字，但需要required关键字以保证Student的子类也必须实现此方法
    self.sports = []
    print("I am a student")
    super.init(firstName: firstName, lastName: lastName)
  }
}
// 创建两个实例
var denny = Student(firstName: "Denny", lastName: "Green")
var ivy = Student(person: denny)
```

### Retain cycle and weak references

同 Objective-C 中类似，Swift 也是使用 ARC 来进行内存管理，所以同样存在循环引用的问题，解决办法就是使用**弱引用 (weak reference)**。

```swift
class Person {
  var firstName: String
  var lastName: String
  init(firstName: String, lastName: String) {
    self.firstName = firstName
    self.lastName = lastName
  }
}
class Student: Person {
  var partner: Student?
  deinit {
    print("\(firstName) is deinited.")
  }
}
var denny: Student? = Student(firstName: "Denny", lastName: "Green")
var jack: Student? = Student(firstName: "Jack", lastName: "Bush")
denny?.partner = jack
jack?.partner = denny
denny = nil
jack = nil // 即使denny和jack都变成nil, 内存也没被释放，这就是因为产生了循环引用

// 解决办法是将partner改成weak，swift中的属性默认是strong
class Student: Person {
  weak var partner: Student?
  deinit {
    print("\(firstName) is deinited.")
  }
}
```

