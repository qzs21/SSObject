//
//  SSObject.m
//
//  Created by Steven on 15/4/29.
//  Copyright (c) 2015年 Yamei. All rights reserved.
//

#import "SSObject.h"
#import <objc/runtime.h>
#import "SSObjectProperty.h"

@implementation SSObject

#pragma mark - Formats
- (NSString *)dateFormatWithPropertyName:(NSString *)propertyName {
    return @"yyyy-MM-dd HH:mm:ss";
}
- (double)dateMillisecondMultipleWithPropertyName:(NSString *)propertyName {
    return 0.001;
}
- (Class)arrayClassWithPropertyName:(NSString *)propertyName {
    return NULL;
}

#pragma mark -
- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    
    if (self = [super init]) {
        [self setDictionary:dictionary];
    }
    
    return self;
}

- (void)setDictionary:(NSDictionary *)dictionary;
{
    if (![dictionary isKindOfClass:NSDictionary.class])
    {
        return;
    }
    
    if (dictionary.allKeys.count == 0 )
    {
        return;
    }
    
    id value = nil;
    NSArray * propertyItems = [self.class propertyItems];
    for (SSObjectProperty * p in propertyItems)
    {
        
        value = [dictionary objectForKey:p.name];
        
        if ( value==nil || [value isKindOfClass:NSNull.class]) { continue; }
        
        if (p.type == SSObjectPropertyTypeObject) {
            
            // 给对象属性赋值
            [self _setPropertyItem:p objectValue:value];
        
        } else if ([value isKindOfClass:NSNumber.class] || [value isKindOfClass:NSString.class]) {
        
            // 给常量属性赋值
            [self _setPropertyItem:p value:value];
        
        }
    }
    
}

// 给对象设置值
- (void)_setPropertyItem:(SSObjectProperty *)p objectValue:(id)value
{
    id finalValue = value;
    if (class_isClass(p.class, NSString.class))
    {
        // NSSting
        finalValue = [NSString stringWithFormat:@"%@", value];
    }
    else if (class_isClass(p.class, NSNumber.class))
    {
        // NSNumber
        if ([value isKindOfClass:NSNumber.class])
        {
            // 正好是NSNumber什么都不做
        }
        else if ([value isKindOfClass:NSString.class])
        {
            finalValue = @([value doubleValue]);
        }
    }
    else if (class_isClass(p.class, NSDate.class))
    {
        // NSDate
        
        if ( ![value isKindOfClass:NSString.class] && ![value isKindOfClass:NSNumber.class]) { return; }
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[0-9]+$"];
        BOOL isNumber = [predicate evaluateWithObject:[NSString stringWithFormat:@"%@", value]];
        
        if (isNumber)
        {
            // 数字时间
            NSTimeInterval time = [value doubleValue] * [self dateMillisecondMultipleWithPropertyName:p.name];
            finalValue = [NSDate dateWithTimeIntervalSince1970:time];
        }
        else
        {
            // 字符串时间
            NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
            dateformatter.dateFormat = [self dateFormatWithPropertyName:p.name];
            finalValue = [dateformatter dateFromString:value];
        }
    }
    else if (class_isClass(p.class, NSArray.class))
    {
        
        if (![value isKindOfClass:NSArray.class]) { return; }
        
        NSMutableArray * items = [NSMutableArray array];
        id obj = nil;
        for (id v in value)
        {
            Class objClass = [self arrayClassWithPropertyName:p.name];
            if (class_isClass(objClass, SSObject.class))
            {
                obj = [[objClass alloc] initWithDictionary:v];
            }
            else
            {
                obj = v;
            }
            [items addObject:obj];
        }
        
        finalValue = [NSArray arrayWithArray:items];
        
    } else if (class_isClass(p.class, SSObject.class)) {
        // 数据模型对象是属性，自动生成对象
        finalValue = [p.class objectWithDictionary:value];
    }
    [self setValue:finalValue forKey:p.name];
}

// 设置基础类型的属性的值
- (void)_setPropertyItem:(SSObjectProperty *)p value:(id)value
{
    if ([value isKindOfClass:NSNumber.class] || [value isKindOfClass:NSString.class]) {
        id finalValue = nil;
        switch (p.type) {
            case SSObjectPropertyTypeInt:
                finalValue = @([value intValue]);
                break;
            case SSObjectPropertyTypeUnsignedInt:
                // NSNumber 没有 unsignedIntegerValue 方法，避免崩溃，使用 longLongValue
                finalValue = @([value longLongValue]);
                break;
            case SSObjectPropertyTypeShort:
                finalValue = @([value shortValue]);
                break;
            case SSObjectPropertyTypeUnsignedShort:
                finalValue = @([value integerValue]);
                break;
            case SSObjectPropertyTypeLong:
                finalValue = @([value longValue]);
                break;
            case SSObjectPropertyTypeUnsignedLong:
                finalValue = @([value longLongValue]);
                break;
            case SSObjectPropertyTypeChar:
                finalValue = @([value intValue]);
                break;
            case SSObjectPropertyTypeUnsignedChar:
                finalValue = @([value intValue]);
                break;
            case SSObjectPropertyTypeBOOL:
                finalValue = @([value boolValue]);
                break;
            case SSObjectPropertyTypeDouble:
                finalValue = @([value doubleValue]);
                break;
            case SSObjectPropertyTypeFloat:
                finalValue = @([value floatValue]);
                break;
            default: break;
        }
        if (finalValue) {
            [self setValue:finalValue forKey:p.name];
        }
    }
}

+ (instancetype)objectWithDictionary:(NSDictionary *)dictionary {
    return [[self alloc] initWithDictionary:dictionary];
}


+ (NSArray *)arrayWithDictionarys:(NSArray *)dictionarys {
    if ( ![dictionarys isKindOfClass:NSArray.class] )
    {
        return nil;
    }
    NSMutableArray * itmes = [NSMutableArray array];
    for (NSDictionary * dic in dictionarys) {
        id info = [self objectWithDictionary:dic];
        if (info) {
            [itmes addObject:info];
        }
    }
    return [NSArray arrayWithArray:itmes];
}

@end
