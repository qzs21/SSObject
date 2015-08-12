//
//  SimpleObject.h
//  Simple
//
//  Created by Steven on 15/4/29.
//  Copyright (c) 2015年 Neva. All rights reserved.
//

#import "SSObject.h"

@interface SimpleObject : SSObject

@property (nonatomic, strong) SimpleObject * testObj;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, assign) int intValue;
@property (nonatomic, assign) NSDate * dateValue;
@property (nonatomic, strong) NSArray * testItems;
@property (nonatomic, strong) id value;

@end
