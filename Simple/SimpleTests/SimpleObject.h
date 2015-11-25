//
//  SimpleObject.h
//  Simple
//
//  Created by Steven on 15/4/29.
//  Copyright (c) 2015年 Neva. All rights reserved.
//

#import "SSObject.h"

@interface SimpleObject : SSObject

@property (nonatomic, assign) int intValue;
@property (nonatomic, assign) unsigned int unsignedIntValue;
@property (nonatomic, assign) short shortValue;
@property (nonatomic, assign) unsigned short unsignedShortValue;
@property (nonatomic, assign) long longValue;
@property (nonatomic, assign) unsigned long unsignedLongValue;
@property (nonatomic, assign) char charValue;
@property (nonatomic, assign) unsigned char unsignedCharValue;
@property (nonatomic, assign) BOOL boolValue;
@property (nonatomic, assign) double doubleValue;
@property (nonatomic, assign) float floatValue;

// 实现一个只读属性，确保设置时不引起崩溃
@property (nonatomic, readonly) NSNumber * readonly;

@property (nonatomic, strong) SimpleObject * objectValue;

@property (nonatomic, strong) NSString * stringValue;

@property (nonatomic, strong) NSNumber * numberValue;

@property (nonatomic, assign) NSDate * dateValue;

@property (nonatomic, strong) NSArray * arrayValue;

@property (nonatomic, strong) id idValue;

@end
