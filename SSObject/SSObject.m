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
    if (class_isClass(p.class, NSString.class))
    {
        // NSSting
        [self setValue:[NSString stringWithFormat:@"%@", value] forKey:p.name];
    }
    else if (class_isClass(p.class, NSNumber.class))
    {
        // NSNumber
        if ([value isKindOfClass:NSNumber.class])
        {
            [self setValue:value forKey:p.name];
        }
        else if ([value isKindOfClass:NSString.class])
        {
            [self setValue:@([value doubleValue]) forKey:p.name];
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
            NSTimeInterval time = [value doubleValue] * [self dateMillisecondMultipleWithPropertyName:p.name];
            NSDate * date = [NSDate dateWithTimeIntervalSince1970:time];
            [self setValue:date forKey:p.name];
        }
        else
        {
            NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
            dateformatter.dateFormat = [self dateFormatWithPropertyName:p.name];
            NSDate * date = [dateformatter dateFromString:value];
            [self setValue:date forKey:p.name];
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
        
        [self setValue:[NSArray arrayWithArray:items] forKey:p.name];
        
    } else if (class_isClass(p.class, SSObject.class)) {
        // 数据模型对象是属性，自动生成对象
        id autoCreateObj = [p.class objectWithDictionary:value];
        if (autoCreateObj) {
            [self setValue:autoCreateObj forKey:p.name];
        }
    } else {
        // 其他类型对象 (id，和其他类)
        [self setValue:value forKey:p.name];
    }
}

// 设置基础类型的属性的值
- (void)_setPropertyItem:(SSObjectProperty *)p value:(id)value
{
    if ([value isKindOfClass:NSNumber.class] || [value isKindOfClass:NSString.class]) {
        switch (p.type) {
            case SSObjectPropertyTypeInt:
                [self setValue:@([value intValue]) forKey:p.name];
                break;
            case SSObjectPropertyTypeUnsignedInt:
                // NSNumber 没有 unsignedIntegerValue 方法，避免崩溃，使用 longLongValue
                [self setValue:@([value longLongValue]) forKey:p.name];
                break;
            case SSObjectPropertyTypeShort:
                [self setValue:@([value shortValue]) forKey:p.name];
                break;
            case SSObjectPropertyTypeUnsignedShort:
                [self setValue:@([value integerValue]) forKey:p.name];
                break;
            case SSObjectPropertyTypeLong:
                [self setValue:@([value longValue]) forKey:p.name];
                break;
            case SSObjectPropertyTypeUnsignedLong:
                [self setValue:@([value longLongValue]) forKey:p.name];
                break;
            case SSObjectPropertyTypeChar:
                [self setValue:@([value intValue]) forKey:p.name];
                break;
            case SSObjectPropertyTypeUnsignedChar:
                [self setValue:@([value intValue]) forKey:p.name];
                break;
            case SSObjectPropertyTypeBOOL:
                [self setValue:@([value boolValue]) forKey:p.name];
                break;
            case SSObjectPropertyTypeDouble:
                [self setValue:@([value doubleValue]) forKey:p.name];
                break;
            case SSObjectPropertyTypeFloat:
                [self setValue:@([value floatValue]) forKey:p.name];
                break;
            default: break;
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

- (NSString *)date:(NSDate *)date withFormat:(NSString *)format {
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:format];
    return [outputFormatter stringFromDate:date];
}

- (NSDictionary *)dictionaryFormInfoWithNull:(BOOL)withNull
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    
    id value = nil;
    NSString * key = nil;
    for (SSObjectProperty * property in [self.class propertyItems])
    {
        key = property.name;
        value = [self valueForKey:key];
        
        if ([value isKindOfClass:NSDate.class])
        {
            [dic setObject:[self date:value withFormat:[self dateFormatWithPropertyName:key]] forKey:key];
        } else if ([value isKindOfClass:SSObject.class]) {
            [dic setObject:[value dictionaryFormInfo] forKey:key];
        } else if ([value isKindOfClass:NSArray.class]) {
            NSMutableArray * arr = [NSMutableArray array];
            for (id obj in value) {
                if ([obj isKindOfClass:SSObject.class]) {
                    [arr addObject:[obj dictionaryFormInfo]];
                } else {
                    [arr addObject:obj];
                }
            }
            [dic setObject:arr forKey:key];
        } else {
            if (withNull)
            {
                [dic setObject:value?value:[NSNull null] forKey:key];
            }
            else
            {
                if (value != nil && value != [NSNull null])
                {
                    [dic setObject:value forKey:key];
                }
            }
        }
    }
    return dic;
}
/// 按照自身属性生成字典，一般用于序列化保存
- (NSDictionary *)dictionaryFormInfo {
    return [self dictionaryFormInfoWithNull:YES];
}
- (NSDictionary *)dictionaryFormInfoWithoutNullValue
{
    return [self dictionaryFormInfoWithNull:NO];
}


/// 判断对象属性值是否都相等
- (BOOL)isEqual:(id)object
{
    if (![object isKindOfClass:self.class])
    {
        return NO;
    }
    
    NSString * key = nil;
    id value1 = nil;
    id value2 = nil;
    for (SSObjectProperty * property in [self.class propertyItems])
    {
        key = property.name;
        
        value1 = [self valueForKey:key];
        value2 = [object valueForKey:key];
        
        if (value1 != value2)
        {
            if (value1 && ![value1 isEqual:value2])
            {
                return NO;
            }
            else if (value2 && ![value2 isEqual:value1])
            {
                return NO;
            }
        }
    }
    
    return YES;
}



#pragma mark - Debug 输出
- (NSString *)getDebugString {
    return [NSString stringWithFormat:@"\r\n%@ <0x%08X>:\r\n%@", self.class, (int)self, self.dictionaryFormInfo];
}
- (NSString *)description {
    return [self getDebugString];
}
- (NSString *)debugDescription {
    return [self getDebugString];
}

@end
