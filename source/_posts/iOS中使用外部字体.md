---
title: iOS中使用外部字体
date: 2016-11-04 00:42:06
categories: 知识小集
tags:
---

最近在 iOS 项目中使用到了外部字体，所以简单记录一下。使用外部静态字体基本上分为以下几个步骤：

1.将要使用的 ttf 或 otf 字体文件导入到项目中

2.在 info.plist 文件中使用 **Fonts provided by application** 配置字体的信息，如下图所示：

![](http://ww1.sinaimg.cn/large/8f27fe81gw1f9fekbnn6gj216c0m8dop.jpg)

3.在项目中使用以下代码设置字体，也可以直接在 xib 或者 storyboard 中选择导入的字体

<!---more--->

```ObjectiveC
self.label.font = [UIFont fontWithName:@"Ubuntu-B" size:16];
```

还可以使用以下代码打印所有可以的字体的信息：

```ObjectiveC
for (NSString *fontFamilyName in [UIFont familyNames]) {
	NSLog(@"family: %@",fontFamilyName);
    for (NSString *fontName in [UIFont fontNamesForFamilyName:fontFamilyName]) {
        NSLog(@"fontName: %@", fontName);        
    	}
  	NSLog(@"---------");
    }
```

4.假如以上设置完成以后，仍然没有预期的效果，那么请在 **Build Phases** 的 **Copy Bundle Resources**中添加导入的字体

![](http://ww4.sinaimg.cn/large/8f27fe81gw1f9fer44p3bj216a0ms43o.jpg)

