SSObject
========================
[![Pod Version](http://img.shields.io/cocoapods/v/SSObject.svg)](http://cocoadocs.org/docsets/SSObject)
[![Pod Platform](https://img.shields.io/cocoapods/p/SSObject.svg)](http://cocoadocs.org/docsets/SSObject)
[![License](http://img.shields.io/cocoapods/l/SSObject.svg)](http://opensource.org/licenses/MIT)

## Quick start

SSObject 支持 [CocoaPods](http://cocoapods.org).  添加下面的配置到`Podfile`:

```ruby
pod 'SSObject'
```


## 功能：
* 可以将数组或键值对映射成本地对象，主要用于对象序列化和网络数据解析
* 数据模型和字典互转

## 常用场景：
* 网络请求Json数据 --> 解析Json成本地数组或字典 -->  使用本类将数组或字典映射为数据模型
* 对象序列化成字典保存

## 特性：
* 实现对象正向反向映射, 自动判断属性类型，使用字典对应的键值匹配属性名进行初始化赋值
* 支持类型 NSString, NSDate, NSNumber, NSArray, 基本常量, SSObject及其子类
* 对于NSDate，如果是数字自动按照时间戳进行转换, 如果是字符串，按照提供的时间格式转换
* 支持数组直接序列化成对象!

## 注意：
* 如果只读属性实现了Get方法，则会抛出异常，虽然内部已经实现捕获异常不会导致崩溃，但是建议使用时注意

## 用例：

### 数据模型类实现：

```objective-c
@interface SimpleObject : SSObject
@property (nonatomic, strong) SimpleObject * testObj;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, assign) int intValue;
@property (nonatomic, strong) NSArray * testItems;
@property (nonatomic, strong) id value;
@end
@implementation SimpleObject
- (Class)arrayClassWithPropertyName:(NSString *)propertyName {
    return SimpleObject.class;
}
@end
```

### 实例化：

```objective-c
NSDictionary * dic = @{ @"testObj": @{  @"name": @"test2",
                                            @"intValue": @(80) },
                            @"name":        @"test1",
                            @"intValue":    @"10",
                            @"value":       @{  @"key1": @"value1" },
                            @"testItems":   @[  @{ @"name": @"testName1"},
                                                @{ @"name": @"testName2"},
                                                @{ @"name": @"testName3"}]};
NSArray * arr = @[  @{@"name": @"testName1"},
                    @{@"name": @"testName2"},
                    @{@"name": @"testName3"}];
SimpleObject * obj = [SimpleObject objectWithDictionary:dic];
NSArray * objItems = [SimpleObject arrayWithDictionarys:arr];
NSLog(@"%@", obj);
NSLog(@"%@", obj.dictionaryFormInfo);
NSLog(@"%@", objItems);
```
       
       
