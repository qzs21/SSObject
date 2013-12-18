//
//  MyObject.m
//  SSObjectBaseTest
//
//  Created by Steven on 13-12-17.
//  Copyright (c) 2013年 Steven. All rights reserved.
//

#import "GroupObject.h"

@implementation GroupObject

- (id)init {
    if (self = [super init]) {
        self.personList = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
