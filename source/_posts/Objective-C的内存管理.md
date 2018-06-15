---
title: Objective-C的内存管理
date: 2015-12-26 19:00:27
categories: Objective-C
tags: objc
---

首先谢谢 [LonelyRoamer](http://blog.csdn.net/lonelyroamer/article/details/7666851)   ，它的文章让我明白一些事情。整理如下，分享给大家： 

## 一、内存管理的黄金法则:  

如果一个对象使用了  alloc、copy、mutableCopy、retain、new，那你就必须使用相应的 release 或 autorelease.
<!-- more -->

## 二、内存管理类型分类  

基本类型和 C 语言类型：如 int、short、char、struct、enum、union等类型.  
Objective-C 类型：任何继承于 NSObject 的对象都属于 Objective-C 的类型。
我们讲的内存管理实际上是对 Objective-C 类型的内存管理，它对基本数据类型和 C 语言的类型并不管用。 

## 三、C 和 C++ 内存管理的不足   

当有多个指针同时指向同一块内存的时候，任何一个调用了 free 方法释放了内存，而其余指针在不知情的情况下继续使用这块内存就会出现问题，何时由谁去释放这块内存，就是 C 和 C++ 在内存管理上的混乱。 

## 四、Objective-C 对象在内存中的结构  

所有的 Objective-C 类型对象的结构如下，这个对象的内存在包含自己的变量和方法的基础上还包含一个名为 retainCount 的引用计数器用来表示当前对象被引用的次数，如果引用次数为0，就会调 dealloc 释放这块内存。

**MRC规则：**

+ Objective-C 类中实现了引用计数器，对象知道自己当前被引用的次数
+ 一个对象被初始 alloc 以后 retainCount  为1
+ 如果需要引用对象，可以给对象发送一个 retain 消息，这样对象的 retainCount 就加1
+ 当不需要引用对象了，可以给对象发送 release 消息，这样对象 retainCount 就减1
+ 当 retainCount 减到0，自动调用对象的 dealloc 函数，对象就会释放内存
+ 计数器为0的对象不能再使用 release 和其他方法

## 五、举例说明  

比如有一个引擎类 Engine, 有一个类 Car, Car 里面有一个 Engine 的实例变量，一个 setter 和一个 getter 方法，如下所示：
```ObjectiveC
#import "Car.h"  
@implementation Car
- (void) setEngine: (Engine*) engine {
  _engine = engine;
}

- (Engine*) engine {
  return _engine; 
}

- (void) dealloc {
  NSLog(@"Car is dealloc");
  [super dealloc];
}
@end
```
上面写的是一个简单的类，但是这样写是有问题，需要一步步的改进。
**第一步改进：**
先使用它看问题的所在，在 main 方法里面如下使用：
```ObjectiveC
//先创建一个引擎
Engine* engine1 = [[Engine alloc]init];
[engine setID: 1]；
//再创建一个汽车，设置汽车的引擎
Car* car = [[Car alloc]init];//retainCount=1
[car setEngine: engine];
/*分析：在这里，现在有两个引用指向这个Engine对象，engine1和Car中的_engine，可是这个Engine对象的引用计数还为1，因为在setter方法中，并没有使用retain。那么不管是那个引用调用release，那么另外一个引用都将指向一块释放掉的内存，那么肯定会发生错误，所以需要在setter方法中改进。*/
```
**第二步改进：**
setter 方法改进
```ObjectiveC
- (void) setEngine: (Engine*) engine {
  _engine = [engine retain];//多一个引用，retainCount+1 
}
```
再在 main 中使用它:
```ObjectiveC
//先创建一个引擎
Engine* engine1 = [[Engine alloc]init];
[engine1 setID: 1];
//再创建一个汽车，设置汽车的引擎
Car* car = [[Car alloc]init];//retainCount=1
[car setEngine: engine1];//retainCount=2，因为setter中使用了retain

//假设还有一个引擎
Engine* engine2 = [[Engine alloc]init];
[engine2 setID: 2];

//这个汽车要换引擎，自然又要调用setter方法
[car setEngine: engine2];
/*分析：这里换了一个引擎，那么它的engine就不再指向engine1的那个对象的内存了，而是换成了engine2，也就是说engine1的那块对象指向的内存的引用只有一个。可是它的retainCount是两个，这就是问题所在，所以仍需要改进*/
```
**第三步改进：**
```ObjectiveC
- (void) setEngine: (Engine*) engine {
  [_engine release];//在设置之前，先release，那么在设置的时候，就会自动将前面的一个引用release掉
  _engine = [engine retain];//多一个引用，retainCount+1
}
```
再在 main 中使用
```ObjectiveC
//先创建一个引擎
Engine* engine1 = [[Engine alloc]init];
[engine1 setID: 1];
//再创建一个汽车，设置汽车的引擎
Car* car = [[Car alloc]init];//retainCount=1
[car setEngine: engine1];//retainCounr=2,因为使用了retain，所以retainCount=2

//如果进行了一个误操作，又设置了一次engine1
[car setEngine: engine1];

/*分析：那么，又要重新调用一次setter方法，这根本就是无意义的操作，所以要在设置之间加上判断*/
```
**第四步改进：**
```ObjectiveC
- (void) setEngine: (Engine*) engine {
  if（_engine != engine）{//判断是否重复设置
    [_engine release];//在设置之前，先release，那么在设置的时候就会自动将前面一个引用release掉
    _engine = [engine retain];//多了一个引用，retainCount+1
  }
}
```
**第五步改进：**
现在 setter 方法基本没有问题了，那么当我们释放掉一个 car 对象的时候，也要释放它里面 \_engine 的引用，所以要重写 Car 的 dealloc 方法。
```ObjectiveC
- (void) dealloc {
  [_engine release];//在释放car的时候，释放掉它对engine的引用
  [super dealloc]; 
}
```
这还不是最好的方法，下面的方法更好
```ObjectiveC
- (void) dealloc {
  [self setEngine: nil];//释放car得分时候，使用setEngine设为nil，它不仅会release掉，而且指向nil，即使误操作也不会出错'
  [super dealloc];
}
```
所以，综上所述，在 setter 方法中的最终写法是
```ObjectiveC
- (void) setEngine: (Engine*) engine {
  if(_engine != engine){//判断是否重复
    [_engine release];//设置之前，先release，在设置的时候，就会自动将前面的引用release掉
    _engine = [engine retain];
  }
}
```
也可以是：
```ObjectiveC
- (void) setEngine: (Engine*) engine {
  [engine retain]; //一定注意retain和release的先后顺序，不然engine和_engine相同时会出错
  [_engine release];
  _engine = engine;
}
```
然后在 dealloc 方法中的写法是：

```ObjectiveC
- (void) dealloc {
  [self setEngine:nil];
  [super dealloc];
}
```

## 六、property中setter的关键字

在 property 中有三个关键字定义关于展开 setter 方法中的语法，assign、retain、copy.

+ assign 展开 setter 的写法

```ObjectiveC
- (void) setEngine: (Engine*) engine {
  _engine = engine;
}
```
+ retain 展开 setter 的写法

```ObjectiveC
- (void) setEngine: (Engine*) engine {
  if(_engine != engine) {//判读断是否重复设置
    [_engine release];//设置之前，先release，那么在设置的时候就会自动将前面一个引用release掉
    _engine = [engine retain];//多了一个引用，retainCount+1
  }
}
```
+ copy 展开 setter 的写法

```ObjectiveC
- (void) setEngine : (Engine*) engine {
  if(_engine!=engine) {//判断是否重复设置
    [_engine release];//设置之前先release
    _engine = [engine copy];//多了一个引用，retainCount+1
  }
}
```
对于 copy 属性有一点要注意，被定义有 copy 属性的对象必须要符合 NSCopying 协议，并且实现 copyWithZone: 方法。可以看到,使用 retain 和我们上面举的例子完全相同，所以我们可以使用 property 和它的 retain 代替之前的写法。

## 七、autorelease用法简介

autorelease 从字面上的意思也很好理解，自动释放池。autorelease 实际上也是将对象进行 release, 但是它将对release 的调用进行了延迟处理，当你使用 autorelease 的时候，并不会立刻将对象的引用计数减1，而是将这个对象放入了 autorelease pool 中，当 pool 被释放时，pool 中的所有对象才会被 release。在每个iOS应用中，大家会看到一个 autorelease pool，在开始时创建，程序结束时释放，那岂不是对象在程序结束时才被 release，跟内存泄漏有什么区别？其实不然。 
对于每一个 Runloop，系统会隐式创建一些 autorelease pool，这些 pool 会构成一个像 CallStack 一样的栈结构，每一个 runloop 结束的时候，栈顶的 pool 会被销毁，pool 中的对象被自动 release，如果你使用ARC，那么你将不能直接使用 autorelease pool，而是使用 @autoreleasepool block。
参考：[Apple Reference](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSAutoreleasePool_Class/index.html#//apple_ref/doc/uid/20000051-SW5) &  [What is RunLoop](http://www.jianshu.com/p/549c37f60bf7)
例如:
```ObjectiveC
NSAutoreleasePool* pool = [[NSAutoRelease alloc]init];
//Code benefitting from a local autorelease pool.
//此处不可以使用break，return，goto之类的语句。
[pool release];
```
将需要写成
```ObjectiveC
@autoreleasepool {
//Code benefitting from a local autorelease pool.
//此处可以使用break，return，goto之类的语句。
}
```
**对一个 pool 发送 release 和 drain 的区别：**
在向 NSAutoreleasePool 发送 alloc 和 init 创建了一个 pool 以后，在销毁 pool 的时候可以向 pool 发送 drain 和 release 消息。macOS 支持垃圾回收，iOS 并不支持。在一个支持垃圾回收的环境中，是不需要使用 autorelease pool 的，但是假如你想编写一个库，而这个库又需要同时支持垃圾回收和引用计数的话，那么就需要使用 autorelease pool，在支持垃圾回收的环境中，向一个 pool 发送 drain 消息将会触发 pool 在必要的时候进行垃圾回收，而发送 release 就是一个空操作。而在一个引用计数的环境中，drain 和 release 所产生的效果相同。所以通常情况下，推荐使用 drain。

## 八、便利构造器的情况

当你使用 alloc、init 方法创建一个对象时，该对象的初始引用计数为1。当不再使用该对象时，你就要负责销毁它。
除了这种标准的创建对象的方法外，还有一种创建临时对象的方法，通过这种方法创建的对象都是临时对象，生成之后会被直接加入到内部的自动释放池，你不需要关心如何销毁它。
比如你需要创建一个数组 array 和一个字符串 string 的时候，使用了类似下面的方法：   
```ObjectiveC
NSArray* array=[NSArray arrayWithArray: obj];         
NSString* string = [NSString stringWithCString: "This is a temporary string"]; 
```
那么，array 和 string 就不需要我们手动负责内存管理。同使用 alloc 和 init 相比，这种不以 init 开头的初始化方法也称为便利构造器。    

## 九、使用ARC的基本注意事项

+ 不能在程序中定义和使用下列函数：retain、release、autorelease 和 retainCount    
+ 使用 @autoreleasepool 代替 NSAutoreleasePool
+ 方法命名必须遵循命名规则，不能随意定义以 alloc、init、new、copy、mutableCopy 开头且和所有权无关的方法
+ 不能在 dealloc 中释放实例变量（但可以在 dealloc 中释放资源），也不需要调用 [super dealloc]
+ 编译代码时使用编译器 clang，并加上编译选项 -fobjc-arc

