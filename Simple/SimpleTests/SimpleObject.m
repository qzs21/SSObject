//
//  SimpleObject.m
//  Simple
//
//  Created by Steven on 15/4/29.
//  Copyright (c) 2015年 Neva. All rights reserved.
//

#import "SimpleObject.h"

@implementation SimpleObject

- (Class)arrayClassWithPropertyName:(NSString *)propertyName {
    return SimpleObject.class;
}

// 实现一个只读属性，确保设置时不引起崩溃
- (NSNumber *)readonly {
    return nil;
}

@end
