---
title: Autolayout总结
date: 2016-03-10 22:59:38
categories: Cocoa
tags: cocoa
---

## Autolayout

最近两天看了几篇博客，查了相关的文档，认真研究了一下 Autolayout。很难想象我自学 iOS 这么久一直都没有系统地研究 Autolayout。因此决定写个总结。随着苹果的产品线的扩展，屏幕尺寸越来越多，Autolayout 的出现就是为了解决不同尺寸的屏幕的适配问题，还有后来的 sizeclass 技术，有关 sizeclass 的使用将在另外的文章中进行描述。Autolayout 的实现方式有很多种，苹果最初的 API，之后的 VFL，storyboard 以及第三方的 Masonry。    

<!-- more -->    

在此之前，先给 Autolayout 一个总结，这个总结将贯穿全文。

- Autolayout 里有两个词，**约束**和**参照**
- 要想显示一个控件，需要知道两个东西，**位置**和**尺寸**，对应于以前 frame 的 origin 和 size
- 添加的约束不宜过多，当约束足以确定控件的**位置**和**尺寸**，就足够了
- **约束**就是对控件的大小或位置进行约束，**参照**就是以某个控件的位置进行约束，两者并没有明确的区别，它们都可以对控件的**位置**和**尺寸**起到作用
- 所有控件，都离不开**位置**和**尺寸**，Autolayout 就是干这个的，后面的例子以UIView为例

## 代码实现Autolayout

- 先从一个简单的例子开始学习通过 Autolayout 代码来完成一个控件的**位置**和**尺寸**

- 我要在界面的左下方放置一个宽高各为50的红色 View，它距离屏幕左边缘和下边缘距离都是20

- 在此之前先介绍一个方法

  ``` ObjectiveC
          /**
  *  这个是系统默认添加约束的方法，它是NSLayoutConstraint的类方法
  *
  *  @param view1      传入想要添加约束的控件
  *  @param attr1      传入想要添加约束的方向，这个枚举值有很多，可以自己看看
  *  @param relation   传入与约束值的关系，大于，等于还是小于
  *  @param view2      传入被参照对象
  *  @param attr2      传入被参照对象所被参照的方向，如顶部，左边，右边等等
  *  @param multiplier 传入想要的间距倍数关系
  *  @param c          传入最终的差值
  *
  *  @return NSLayoutConstraint对象
  */
  +(instancetype)constraintWithItem:(id)view1 attribute:(NSLayoutAttribute)attr1 relatedBy:(NSLayoutRelation)relation toItem:(id)view2 attribute:(NSLayoutAttribute)attr2 multiplier:(CGFloat)multiplier constant:(CGFloat)c
  //一部分NSLayoutAttribute的枚举值
  NSLayoutAttributeLeft = 1,//控件左边
  NSLayoutAttributeRight,//控件右边
  NSLayoutAttributeTop,//控件上边
  NSLayoutAttributeBottom,//控件下边
  NSLayoutAttributeLeading,//控件左边
  NSLayoutAttributeTrailing,//控件右边
  NSLayoutAttributeWidth,//控件的宽
  NSLayoutAttributeHeight,//控件的高
  NSLayoutAttributeCenterX,//竖直方向的中点
  NSLayoutAttributeCenterY,//水平方向的中点
  //下面看具体的用法
  //创建redView
  UIView *redView = [[UIView alloc]init];
  redView.backgroundColor = [UIColor redColor];
  redView.translatesAutoresizingMaskIntoConstraints = NO;
  [self.view addSubview:redView];    
  //1.创建redView的第一个约束，相对self.view的左边缘间距为20
  NSLayoutConstraint *redLeftC = [NSLayoutConstraint constraintWithItem:redView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0f constant:20.0f];
  //只有在没有参照控件的时候，约束才加到自己身上，否则加到父控件上
  [self.view addConstraint:redLeftC];
  //2.创建redView的第二个约束，相对self.view的底边缘间距为20
  NSLayoutConstraint *redBottomC = [NSLayoutConstraint constraintWithItem:redView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0f constant:-20.0f];
  [self.view addConstraint:redBottomC];
  //创建redView的第三个约束，设置自身的宽，宽可以参照其它控件进行设置，比如self.view的一半
  /*
  [NSLayoutConstraint constraintWithItem:redView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0.5f constant:0.0f];
  */
  //3.这里直接设置宽为50
  NSLayoutConstraint *redWidthC = [NSLayoutConstraint constraintWithItem:redView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:50.0f];
  //由于没有参照物，约束加到自己身上
  [redView addConstraint:redWidthC];
  //4.创建最后一个约束，自身的高
  NSLayoutConstraint *redHeightC = [NSLayoutConstraint constraintWithItem:redView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:50.0f];
  //由于没有参照物，约束加到自己身上
  [redView addConstraint:redHeightC];
  //这时候，redView的位置和尺寸都可以确定了，如下图
  ```
  <img src="https://foolpermi-blog-1254115483.cos.ap-chengdu.myqcloud.com/images/cocoa/Autolayout%E6%80%BB%E7%BB%93_01.jpg" width="320" height="568" align=center />

- 现在继续增加需求，我们在红色方块右边离它20间距，离 self.view 底部也20个间距，放置一个宽高相等的蓝色方块

  ``` ObjectiveC
     //先创建一个蓝色的视图
     UIView *blueView = [[UIView alloc]init];
     blueView.backgroundColor = [UIColor blueColor];
     blueView.translatesAutoresizingMaskIntoConstraints = NO;
     [self.view addSubview:blueView];
     //1.创建第一个约束，左边间距，由于是想要与红色有20的间距，那么参数"toItem"就应该填redView
     NSLayoutConstraint *blueLeft = [NSLayoutConstraint constraintWithItem:blueView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:redView attribute:NSLayoutAttributeRight multiplier:1.0f constant:20.0f];
     [self.view addConstraint:blueLeft];
     //2.创建第二个约束，底边约束，由于是想与底边有20的间距，比self.view的坐标小，所以为-20
     NSLayoutConstraint *blueBottom = [NSLayoutConstraint constraintWithItem:blueView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0f constant:-20.0f];
     [self.view addConstraint:blueBottom];
     //3.创建第三个约束，确定蓝色视图的宽
     NSLayoutConstraint *blueWidth = [NSLayoutConstraint constraintWithItem:blueView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:redView attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0.0f];
     [self.view addConstraint:blueWidth];
     //4.创建第四个约束，确定蓝色视图的高
     NSLayoutConstraint *blueHeight = [NSLayoutConstraint constraintWithItem:blueView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:redView attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.0f];
     [self.view addConstraint:blueHeight];    
  ```
  <img src="https://foolpermi-blog-1254115483.cos.ap-chengdu.myqcloud.com/images/cocoa/Autolayout%E6%80%BB%E7%BB%93_02.jpg" width="320" height="568" align=center />

- 其实 Autolayout 的思想还是比较简单，刚开始使用的时候不要想着一气呵成，可以一个控件一个控件的实现依赖，分别满足其位置和尺寸的需求，如果几个控件一起弄得话，需要思路非常清晰，往往大家犯错是因为约束加多了，而不是加少了

- 就如上面的例子，很多人在设置了与红色等高等宽以后，还同时设置顶部和底部对齐，这样高度就重复设置了。因为上下同时对齐不仅给予了垂直位置，也给予了高度，所以思路必须清晰。

## Autolayout动画

- 最后在原来的例子上做个小动画，让大家了解 Autolayout 是怎么做动画的

- 需求：将在蓝色方块的右边再加个同样大小的黄色方块，然后要求点击屏幕，蓝色的方块被移除，黄色方块取代蓝色方块的位置

- 这个例子主要涉及到 Autolayout 的另一个知识点：**优先级(priority)**

- 好了，下面添加黄色的方块

  ``` ObjectiveC
  //先添加黄色View
  UIView *yellowView = [[UIView alloc]init];
  yellowView.backgroundColor = [UIColor yellowColor];
  yellowView.translatesAutoresizingMaskIntoConstraints = NO;
  [self.view addSubview:yellowView];
  //1.创建第一个约束，左边间距
  NSLayoutConstraint *yellowLeft = [NSLayoutConstraint constraintWithItem:yellowView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:blueView attribute:NSLayoutAttributeRight multiplier:1.0f constant:20.0f];
  [self.view addConstraint:yellowLeft];
  //2.创建第二个约束，底部间距
  NSLayoutConstraint *yellowBottom = [NSLayoutConstraint constraintWithItem:yellowView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0f constant:-20.0f];
  [self.view addConstraint:yellowBottom];
  //3.创建第三个约束，宽度
  NSLayoutConstraint *yellowWidth = [NSLayoutConstraint constraintWithItem:yellowView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:50.0f];
  [yellowView addConstraint:yellowWidth];
  //4.创建第四个约束，高度
  NSLayoutConstraint *yellowHeight = [NSLayoutConstraint constraintWithItem:yellowView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:50.0f];
  [yellowView addConstraint:yellowHeight];
  ```
  <img src="https://foolpermi-blog-1254115483.cos.ap-chengdu.myqcloud.com/images/cocoa/Autolayout%E6%80%BB%E7%BB%93_03.jpg" width="320" height="568" align=center />

- 接下来给黄色添加一个约束，这个约束涉及到优先级，代码如下

  ``` ObjectiveC
  //1.yellowView创建另一个左边约束
  NSLayoutConstraint *yellowAnotherLeft = [NSLayoutConstraint constraintWithItem:yellowView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:redView attribute:NSLayoutAttributeRight multiplier:1.0f constant:20.f];
  //2.设置优先级
  UILayoutPriority priority = 250;
  yellowAnotherLeft.priority = priority;
  //3.约束添加到父视图上
  [self.view addConstraint:yellowAnotherLeft];
  ```


- 约束的优先级的范围是0~1000，数值越大优先级越高，在不设置的情况下默认值是1000

- 这说明，最后添加的约束的优先级是低的，这个约束只有在它的冲突约束被抹掉以后，它才能实现，也就是说，当把蓝色 view 移除以后，黄色 view相对于蓝色 view 左间距20这个约束就不成立了，那么黄色 view 会自动地变为与红色 view 的间距为20

  <img src="https://foolpermi-blog-1254115483.cos.ap-chengdu.myqcloud.com/images/cocoa/Autolayout%E6%80%BB%E7%BB%93_04.jpg" width="320" height="568"  align=center />


- 最后加几行代码来实现这个动画吧
  
  ``` ObjectiveC
  - (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
  //1.先把蓝色从父视图上移除
      [self.blueView removeFromSuperview];
      //2.重新布局页面
      [UIView animateWithDuration:1.0 animations:^{
          [self.view layoutIfNeeded];
      }];
  }
  ```

## VFL实现Autolayout

- 之前介绍了使用苹果原始 API 实现 Autolayout，现在介绍使用 VFL (Visual Format Language) 来实现 Autolayout

- VFL 的思想与其它的实现方式有所不同，它更为宏观化，它将约束分成了两块：**水平方向 (H:) **和**垂直方向 (V:)**

- 也就是说在创建约束的时候，得把水平方向和垂直方向用字符串一并表示出来而不是一个一个的添加

- 下面看 VFL 的 API，它的 API 短了一些，但是要筹齐参数是件很麻烦的事情

  ``` ObjectiveC
          /**
  *  VFL创建约束的API
  *
  *  @param format  传入某种格式构成的字符串，用以表达想要添加的约束，如@"H:|-margin-[redView(50)]"，水平方向上，redView与父控件左边缘保持“margin”间距，redView的宽为50
  *  @param opts    对齐方式，是个枚举值
  *  @param metrics 一般传入以间距为KEY的字典，如： @{ @"margin":@20}，KEY要与format参数里所填写的“margin”相同
  *  @param views   传入约束中提到的View，也是要传入字典，但是KEY一定要和format参数里所填写的View名字相同，如：上面填的是redView，所以KEY是@“redView”
  *
  *  @return 返回约束的数组
  */(NSArray *)constraintsWithVisualFormat:(NSString *)format options:(NSLayoutFormatOptions)opts metrics:(NSDictionary *)metrics views:(NSDictionary *)views;
  //部分NSLayoutFormatOptions的枚举选项
  /*
  NSLayoutFormatAlignAllLeft = (1 << NSLayoutAttributeLeft),//左边缘对齐
  NSLayoutFormatAlignAllRight = (1 << NSLayoutAttributeRight),//右边缘对齐    
  NSLayoutFormatAlignAllTop = (1 << NSLayoutAttributeTop),//上边缘对齐
  NSLayoutFormatAlignAllBottom = (1 << NSLayoutAttributeBottom),//下边缘对齐
  NSLayoutFormatAlignAllLeading = (1 << NSLayoutAttributeLeading),//左边缘对齐
  NSLayoutFormatAlignAllTrailing = (1 << NSLayoutAttributeTrailing),//右边缘对齐
  NSLayoutFormatAlignAllCenterX = (1 << NSLayoutAttributeCenterX),//垂直方向中心对齐
  NSLayoutFormatAlignAllCenterY = (1 << NSLayoutAttributeCenterY),//水平方向中心对齐
  */
  ```

- 里面最重要的就是 **format** 参数，这个参数的难点在于其书写格式

- 通过例子来看 API 的使用，现在要在界面上添加一个红色的方块，高100，宽50，与父视图顶部边缘和左边缘距离为20

- 来看看代码是怎么实现的

  ``` ObjectiveC
     UIView *redView = [[UIView alloc]init];
     redView.backgroundColor = [UIColor redColor];
     redView.translatesAutoresizingMaskIntoConstraints = NO;
     [self.view addSubview:redView];
     //接下来开始写API所需要的参数了
     //format参数
     //Hvfl与Vvfl分别是水平方向与垂直方向的约束，等下之后会有解析
     NSString *Hvfl = @"H:|-margin-[redView(50)]";
     NSString *Vvfl = @"V:|-margin-[redView(100)]";
     //设置margin的数值
     NSDictionary *metrics = @{ @"margin":@20};
     //把要添加约束的View转成字典
     NSDictionary *views = NSDictionaryOfVariableBindings(redView);//这个方法会自动把传入的参数以字典的形式返回，字典的KEY就是其本身的名字
     //如@{@"redView"：redView}
     //添加对齐方式，
     NSLayoutFormatOptions ops = NSLayoutFormatAlignAllLeft | NSLayoutFormatAlignAllTop;//左边与顶部
     //参数已经设置完了，接收返回的数组，用以self.view添加
     NSArray *Hconstraints = [NSLayoutConstraint constraintsWithVisualFormat:Hvfl options:ops metrics:metrics views:views];
     NSArray *Vconstraints = [NSLayoutConstraint constraintsWithVisualFormat:Vvfl options:ops metrics:metrics views:views];
     //self.view分别添加水平与垂直方向的约束
     [self.view addConstraints:Hconstraints];
     [self.view addConstraints:Vconstraints];
     //运行结果如下图
  ```
  <img src="https://foolpermi-blog-1254115483.cos.ap-chengdu.myqcloud.com/images/cocoa/Autolayout%E6%80%BB%E7%BB%93_05.jpg" width="320" height="568" align=center />

- 如图，需求已经实现了，下面解释一下**format**里面奇怪的语法

  - 每个前面都要加 **@"H:"** 或者 **@"V:"**，分别表示水平和垂直方向
  - **@"|"**代表着边界，很形象
  - **@"-"**用来表示间隙，一般以这样的形式出现**@"-20-"**，这代表20的间距，也可以填写表示，如 **@"-margin-"**，之后设置替换参数 **metrics****
  - **@"[]"**中括号里放的是要添加约束的 View，如上边例子的 **redView**，要想设置宽度和高度就这样 **[redView(50)]**，水平方向上 **(H:)** 表示的数字是宽，垂直方向上 **(V:)** 表示的数字是高

- 基本的用法就是这样，更多的东西要在代码中体会，现在做一个稍微复杂的例子，这个例子和以前使用苹果原始 API实现的例子一样，就是在距离 self.view 的底部20间距的地方放置3个方块，红、蓝、黄分别间距20，宽高相同，都为50

- 接下来看代码

  ``` ObjectiveC
     //translatesAutoresizingMaskIntoConstraints属性设置为NO，防止苹果把默认设置的Autoresizing属性转成Autolayout，造成错误
     //依次创建三个View
     UIView *redView = [[UIView alloc]init];
         redView.backgroundColor = [UIColor redColor];
         redView.translatesAutoresizingMaskIntoConstraints = NO;
         [self.view addSubview:redView];
  
         UIView *blueView = [[UIView alloc]init];
         blueView.backgroundColor = [UIColor blueColor];
         blueView.translatesAutoresizingMaskIntoConstraints = NO;
         [self.view addSubview:blueView];
  
         UIView *yellowView = [[UIView alloc]init];
         yellowView.backgroundColor = [UIColor yellowColor];
         yellowView.translatesAutoresizingMaskIntoConstraints = NO;
         [self.view addSubview:yellowView];
     //view添加完了，开始创建约束
     //1.创建水平方向约束
     NSString *Hvfl = @"H:|-margin-[redView(50)]-margin-[blueView(==redView)]-margin-[yellowView(==redView)]";
     //大家认真体会一下上面这个字符串
     //如果翻译过来就是，边缘-间距-红色view（宽50）-间距-蓝色View（宽等于红色View的宽）-间距-黄色View（宽等于红色View的宽）
     //设置间距要替换的数值，用字典形式
     NSDictionary *metrics = @{ @"margin":@20};
     //把要添加约束的View都转成字典形式
     NSDictionary *views = NSDictionaryOfVariableBindings(redView,blueView,yellowView);
     //设置对齐方式，顶部与底部都与红色View对齐
     NSLayoutFormatOptions ops = NSLayoutFormatAlignAllTop|NSLayoutFormatAlignAllBottom;
     //创建水平方向约束
     NSArray *Hconstraints = [NSLayoutConstraint constraintsWithVisualFormat:Hvfl options:ops metrics:metrics views:views];
     //这里依然要设置红色view的高，因为水平方向的约束没有设置红色View的高，其他View仅仅是与它顶部底部对齐，但是高依然未知
     NSString *Vvfl = @"V:[redView(50)]-margin-|";
     //创建垂直方向约束
     NSArray *Vconstraints = [NSLayoutConstraint constraintsWithVisualFormat:Vvfl options:ops metrics:metrics views:views];
     //父控件添加约束
     [self.view addConstraints:Hconstraints];
     [self.view addConstraints:Vconstraints];
     //最终效果图如下:
  ```
  <img src="https://foolpermi-blog-1254115483.cos.ap-chengdu.myqcloud.com/images/cocoa/Autolayout%E6%80%BB%E7%BB%93_06.jpg" width="320" height="568" align=center />

## Masonry实现Autolayout

Masonry 是 iOS 和 OS X 平台上非常优秀的第三方 Autolayout 框架，采用更优雅的链式语法对原生 API 进行封装，简洁明了并具有很高的可读性。

先看一段 sample code 来认识 Masonry:

``` ObjectiveC
UIEdgeInsets padding = UIEdgeInsetsMake(10, 10, 10, 10);
[view1 mas_makeConstraints:^(MASConstraintMaker *make) {
	make.edges.equalTo(superview).with.insets(padding);
}];
```

看看 block 里面的那句话:*make edges equalTo superview with insets*,通过类似于自然语言的几行代码就把 view1 约束好了，通俗易懂。

先看看 Masonry 支持哪些属性

``` ObjectiveC
@property (nonatomic, strong, readonly) MASConstraint *left; //左侧
@property (nonatomic, strong, readonly) MASConstraint *right; //右侧
@property (nonatomic, strong, readonly) MASConstraint *top; //上侧
@property (nonatomic, strong, readonly) MASConstraint *bottom; //下侧
@property (nonatomic, strong, readonly) MASConstraint *leading; //首部
@property (nonatomic, strong, readonly) MASConstraint *trailing; //尾部
@property (nonatomic, strong, readonly) MASConstraint *width; //宽
@property (nonatomic, strong, readonly) MASConstraint *height; //高
@property (nonatomic, strong, readonly) MASConstraint *centerX; //横向中点
@property (nonatomic, strong, readonly) MASConstraint *centerY; //纵向中点
@property (nonatomic, strong, readonly) MASConstraint *baseline; //文本基线
```

其中 leading 与 left、trailing 与 right 在正常情况下是等价的，除了一些特殊情况下，比如阿拉伯文，正常使用情况下基本上可以不理不用，用 left 和 right 就好了。下面通过一些简单的实例来学习如何愉快的使用 Masonry:

**1.居中显示一个 view**

``` ObjectiveC
- (void)viewDidLoad{
  [super viewDidLoad];
  UIView *sv = [[UIView alloc]init];
  sv.backgroundColor = [UIColor redColor];
  [self.view addSubview:sv];
  [sv mas_makeConstraints:^(MASConstraintMaker *make){
    	make.center.equalTo(self.view);
    	make.size.mas_equalTo(CGSizeMake(300,300));
  }];
}
```



参考：

1.[iOS Autolayout之Apple原生代码实现](http://www.jianshu.com/p/d7a4790090f1) 

2.[iOS Autolayout之VFL](http://www.jianshu.com/p/757cc57fd9ea) 

3.[Masonry介绍与使用](http://adad184.com/2014/09/28/use-masonry-to-quick-solve-autolayout/)