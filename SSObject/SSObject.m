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
    
    NSTimeInterval time = 0;
    id value = nil;
    NSString * propertyType;
    NSString * key;
    for (SSObjectProperty * property in [self.class propertyItems])
    {
        
        propertyType = property.propertyType;
        key = property.propertyName;
        value = [dictionary objectForKey:key];
        
        if ( value==nil || [value isKindOfClass:NSNull.class])
        {
            continue;
        }
        
        @try {
            if ([propertyType hasPrefix:@"T@"])
            {
                
                // 处理对象
                if ([propertyType hasPrefix:@"T@\""])
                {
                    
                    // 获取类名
                    NSRange start = [propertyType rangeOfString:@"T@\""];
                    NSRange end = [propertyType rangeOfString:@"\","];
                    NSString * className = nil;
                    if (start.length && end.length)
                    {
                        className = [propertyType substringWithRange:NSMakeRange(start.location+start.length, end.location - start.length)];
                    }
                    
                    Class objClass = NSClassFromString(className);
                    if (class_isClass(objClass, NSString.class))
                    {
                        // NSSting
                        [self setValue:[NSString stringWithFormat:@"%@", value] forKey:key];
                    }
                    else if (class_isClass(objClass, NSNumber.class))
                    {
                        // NSNumber
                        if ([value isKindOfClass:NSNumber.class])
                        {
                            [self setValue:value forKey:key];
                        }
                        else if ([value isKindOfClass:NSString.class])
                        {
                            [self setValue:@([value doubleValue]) forKey:key];
                        }
                    }
                    else if (class_isClass(objClass, NSDate.class))
                    {
                        // NSDate
                        
                        if ( ![value isKindOfClass:NSString.class] && ![value isKindOfClass:NSNumber.class]) { continue; }
                        
                        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[0-9]+$"];
                        BOOL isNumber = [predicate evaluateWithObject:[NSString stringWithFormat:@"%@", value]];
                        
                        if (isNumber)
                        {
                            time = [value doubleValue] * [self dateMillisecondMultipleWithPropertyName:key];
                            NSDate * date = [NSDate dateWithTimeIntervalSince1970:time];
                            [self setValue:date forKey:key];
                        }
                        else
                        {
                            NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
                            dateformatter.dateFormat = [self dateFormatWithPropertyName:key];
                            NSDate * date = [dateformatter dateFromString:value];
                            [self setValue:date forKey:key];
                        }
                    }
                    else if (class_isClass(objClass, NSArray.class))
                    {
                        
                        if (![value isKindOfClass:NSArray.class]) { continue; }
                        
                        NSMutableArray * items = [NSMutableArray array];
                        id obj = nil;
                        for (id v in value)
                        {
                            Class objClass = [self arrayClassWithPropertyName:key];
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
                        
                        [self setValue:[NSArray arrayWithArray:items] forKey:key];
                        
                    } else if (class_isClass(objClass, SSObject.class)) {
                        // 数据模型对象是属性，自动生成对象
                        id autoCreateObj = [objClass objectWithDictionary:value];
                        if (autoCreateObj) {
                            [self setValue:autoCreateObj forKey:key];
                        }
                    } else {
                        // 其他类型对象
                        [self setValue:value forKey:key];
                    }
                } else {
                    // id 类型
                    if ([value isKindOfClass:NSObject.class]) {
                        [self setValue:value forKey:key];
                    }
                }
                
            } else if ([propertyType hasPrefix:@"Ti"]) {
                // int
                if ([value isKindOfClass:NSNumber.class] || [value isKindOfClass:NSString.class]) {
                    [self setValue:@([value intValue]) forKey:key];
                }
            } else if ([propertyType hasPrefix:@"TI"]) {
                // unsigned int
                if ([value isKindOfClass:NSNumber.class] || [value isKindOfClass:NSString.class]) {
                    [self setValue:@([value longLongValue]) forKey:key];
                }
            } else if ([propertyType hasPrefix:@"Ts"]) {
                // short
                if ([value isKindOfClass:NSNumber.class] || [value isKindOfClass:NSString.class]) {
                    [self setValue:@([value shortValue]) forKey:key];
                }
            } else if ([propertyType hasPrefix:@"TS"]) {
                // unsigned short
                if ([value isKindOfClass:NSNumber.class] || [value isKindOfClass:NSString.class]) {
                    [self setValue:@([value integerValue]) forKey:key];
                }
            } else if ([propertyType hasPrefix:@"Tq"]) {
                // long, NSInteger
                if ([value isKindOfClass:NSNumber.class] || [value isKindOfClass:NSString.class]) {
                    [self setValue:@([value longValue]) forKey:key];
                }
            } else if ([propertyType hasPrefix:@"TQ"]) {
                // unsigned long, NSUInteger
                if ([value isKindOfClass:NSNumber.class] || [value isKindOfClass:NSString.class]) {
                    [self setValue:@([value longLongValue]) forKey:key];
                }
            } else if ([propertyType hasPrefix:@"Tc"]) {
                // char
                if ([value isKindOfClass:NSNumber.class] || [value isKindOfClass:NSString.class]) {
                    [self setValue:@([value intValue]) forKey:key];
                }
            } else if ([propertyType hasPrefix:@"TC"]) {
                // unsigned char
                if ([value isKindOfClass:NSNumber.class] || [value isKindOfClass:NSString.class]) {
                    [self setValue:@([value intValue]) forKey:key];
                }
            } else if ([propertyType hasPrefix:@"TB"]) {
                // BOOL
                if ([value isKindOfClass:NSNumber.class] || [value isKindOfClass:NSString.class]) {
                    [self setValue:@([value boolValue]) forKey:key];
                }
            } else if ([propertyType hasPrefix:@"Td"]) {
                // double
                if ([value isKindOfClass:NSNumber.class] || [value isKindOfClass:NSString.class]) {
                    [self setValue:@([value doubleValue]) forKey:key];
                }
            } else if ([propertyType hasPrefix:@"Tf"]) {
                // float
                if ([value isKindOfClass:NSNumber.class] || [value isKindOfClass:NSString.class]) {
                    [self setValue:@([value floatValue]) forKey:key];
                }
            }
        } @catch (NSException *exception) {
            NSLog(@"解析数据异常 (如果只读属性实现了Get方法，则会抛出异常) : %@", exception);
        } @finally {
            
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
        key = property.propertyName;
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
        key = property.propertyName;
        
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
