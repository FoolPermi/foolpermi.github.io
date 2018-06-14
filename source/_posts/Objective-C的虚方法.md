---
title: Objective-C的虚方法
date: 2015-12-28 19:59:59
categories: Objective-C
tags: objc
---

OC 的方法都是虚方法:
1.父类的指针可以指向子类的对象
2.调用方法时不看指针看对象    

<!---more--->

```ObjectiveC
 //父类，有一个方法jump
 //Father.h
 #import <Foundation/Foundation.h>
 @interface Father : NSObject
 - (void)jump;
 @end

 //Father.m
 #import "Father.h"
 @implementation Father
 -(void)jump
 {
   NSLog(@"Father can jump 1.2m.");
 }
 @end

 //子类，重写了jump方法
 //Son.h
 #import"Father.h"
 @interface Son : Father
 //重写，无需声明
 @end

 //Son.m
 #import "Son.h"
 @implementation Son
 -(void)jump
 {
   NSLog(@"Son can jump 1.8m.");
 }
 @end

 //main.m
 #import <Foundation/Foundation.h>
 #import "Father.h"
 #import "Son.h"

 int main(int argc,const char* argv[])
 {
   @autoreleasepool{
     Son* son = [[Son alloc]init];
     Father* father = son;//父类的指针指向子类的对象
     [father jump];//调用父类的jump还是子类的jump?
     //调用的仍然是子类的方法
     //调用方法时不看指针，看对象
     //对象的地址调用对象的方法
   }
   return 0；
 }
```
这样的方法叫做虚方法，可以描述不同事物被相同事件触发，产生不同的响应（结果）。下面写一个殴打小动物的程序。


```ObjectiveC
 //父类，Animal，有一个beBeaten方法，描述被打时的响应
 //Animal.h
 
 #import <Foundation/Foundation.h>
 @interface Animal : NSObject

 -(void)beBeaten;//被打时的响应

 @end

 //Animal.m
 #import "Animal.h"
 @implementation Animal

 -(void)beBeaten
 {
   return ;//虚方法，可以什么都不做，每个子类都会重写这个方法
 }

 @end

 //Cat.h
 #import "Animal.h"
 @interface Cat : Animal

 @end

 //Cat.m
 #import "Cat.h"
 @implementation Cat

 -(void)beBeaten
 {
   NSLog(@"Bark and jump to high!");
 }

 @end

 //Dog.h
 #import "Animal.h"
 @interface Dog : Animal

 @end

 //Dog.m
 #import "Dog.h"
 @implementation Dog

 -(void)beBeaten
 {
   NSLog(@"Give a hard bit!");
 }

 @end

 //Frog.h
 #import "Animal.h"
 @interface Frog : Animal

 @end

 //Frog.m
 #import "Frog.h"
 @implementation Frog

 -(void)beBeaten
 {
   NSLog(@"Do nothing!");
 }

 @end

 //Human类，有一个方法beat
 #import <Foundation/Fountion.h>
 #import "Animal.h"
 @interface Human : NSObject

 -(void)beatAnimal:(Animal*)animal;//父类的指针可以指向任意一个子类的地址，否则，殴打不同的动物，就需要创建不同的动物对象

 @end

 //Human.m
 #import "Human.h"
 @implementation Human
 //只需要写一个方法，尽管动物不同，这就是父类可以指向子类的好处
 -(void)beatAnimal:(Animal*)animal
 {
   NSLog(@"Human beat the %@",[animal class]);
   [animal beBeaten];
 }

 @end

 //main.m
 #import <Foundation/Foundation.h>
 #import "Dog.h"
 #import "Cat.h"
 #import "Frog.h"
 #import "Human.h"
 int main(int argc,const char* argv[])
 {
   @autoreleasepool{
     Frog* frog = [[Frog alloc]init];
     Dog* dog = [[Dog alloc]init];
     Cat* cat = [[Cat alloc]init];
     Human* Linda = [[Human alloc]init]; //who is Linda?
     [Linda beatAnimal:frog]; //不同的事物被相同的事件触发，产生不同的响应
     [Linda beatAnimal:cat];
     [Linda beatAnimal:dog];
   }
   return 0;
 }
```