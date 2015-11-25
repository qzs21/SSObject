//
//  SSObjectProperty.m
//  Pods
//
//  Created by Steven on 15/6/3.
//
//

#import "SSObjectProperty.h"
#import <objc/runtime.h>


/// class1 是否是 class2或其的子类
bool class_isClass( Class class1, Class class2 )
{
    if (class1==NULL || class2==NULL) { return NO; }
    
    if (class1 != class2) { return class_isClass( class_getSuperclass(class1), class2 ); }
    
    return true;
}

@interface SSObjectProperty()
@property (nonatomic, copy) NSString * infoString; ///< 属性的原始信息
@end

@implementation SSObjectProperty

@end


@implementation NSObject (NSObject_propertyItems)

+ (NSDictionary *)_allPropertyType {
    NSDictionary * allPropertyType = nil;
    if (allPropertyType == nil)
    {
        allPropertyType = @{
                            
                            @"T@":      @(SSObjectPropertyTypeObject),
                            @"Ti":      @(SSObjectPropertyTypeInt),
                            @"TI":      @(SSObjectPropertyTypeUnsignedInt),
                            @"Ts":      @(SSObjectPropertyTypeShort),
                            @"TS":      @(SSObjectPropertyTypeUnsignedShort),
                            @"Tq":      @(SSObjectPropertyTypeLong),
                            @"TQ":      @(SSObjectPropertyTypeUnsignedLong),
                            @"Tc":      @(SSObjectPropertyTypeChar),
                            @"TC":      @(SSObjectPropertyTypeUnsignedChar),
                            @"TB":      @(SSObjectPropertyTypeBOOL),
                            @"Td":      @(SSObjectPropertyTypeDouble),
                            @"Tf":      @(SSObjectPropertyTypeFloat),
                            
                            };
    }
    return allPropertyType;
}

// 获取setter方法名
+ (NSString *)setterStringWithName:(NSString *)name
{
    if (name.length == 0) {
        return nil;
    }
    NSString * first = [name substringToIndex:1];
    NSString * secon = [name substringFromIndex:1];
    return [NSString stringWithFormat:@"set%@%@:", first.uppercaseString, secon];
}

+ (NSArray *)propertyItems;
{
    // 缓存
    static NSMutableDictionary * cacheItems = nil;
    if (cacheItems == nil)
    {
        cacheItems = [NSMutableDictionary dictionary];
    }
    
    NSArray * callBackData = [cacheItems objectForKey:NSStringFromClass(self)];
    if (callBackData == nil)
    {
        unsigned int outCount = 0;
        objc_property_t * properties = class_copyPropertyList([self class], &outCount);
        objc_property_t property = NULL;
        
        NSMutableArray * items = [NSMutableArray array];
        SSObjectProperty * item = nil; // 保存属性对象
        for (int i = 0; i < outCount; i++)
        {
            property = properties[i];
            item = [[SSObjectProperty alloc] init];
            item.name = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
            item.infoString = [NSString stringWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
            item.type = SSObjectPropertyTypeUnknown;
            
            if (![self instancesRespondToSelector:NSSelectorFromString([self setterStringWithName:item.name])]) {
                // 不支持setter，不登记属性
                continue;
            }

            // 确定属性类型
            NSDictionary * allTypes = self._allPropertyType;
            for (NSString * key in allTypes.allKeys) {
                if ([item.infoString hasPrefix:key]) {
                    item.type = (SSObjectPropertyType)[allTypes[key] integerValue];
                    break;
                }
            }
            // 如果是对象，并且类型不是 id ，就确定对象的类
            if ( (item.type == SSObjectPropertyTypeObject) && ([item.infoString hasPrefix:@"T@\""]) )
            {
                // 获取类名
                NSRange start = [item.infoString rangeOfString:@"T@\""];
                NSRange end = [item.infoString rangeOfString:@"\","];
                NSString * className = nil;
                if (start.length && end.length)
                {
                    className = [item.infoString substringWithRange:NSMakeRange(start.location+start.length, end.location - start.length)];
                }
                item.class = NSClassFromString(className);
            }
            
            [items addObject:item];
        }
        free(properties);
        
        callBackData = [NSArray arrayWithArray:items];
        [cacheItems setObject:callBackData forKey:NSStringFromClass(self)];
    }
    
    return callBackData;
}

@end