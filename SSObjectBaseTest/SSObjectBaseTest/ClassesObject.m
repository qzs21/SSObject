//
//  ClassesObject.m
//  SSObjectBaseTest
//
//  Created by Steven on 13-12-17.
//  Copyright (c) 2013年 Steven. All rights reserved.
//

#import "ClassesObject.h"

@implementation ClassesObject

- (id)init {
    if (self = [super init]) {
        self.groupList = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
