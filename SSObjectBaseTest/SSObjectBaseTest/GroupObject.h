//
//  MyObject.h
//  SSObjectBaseTest
//
//  Created by Steven on 13-12-17.
//  Copyright (c) 2013年 Steven. All rights reserved.
//

#import "SSObjectBase.h"

@interface GroupObject : SSObjectBase

@property (nonatomic, assign) int count;
@property (nonatomic, copy) NSString * groupName;
@property (nonatomic, strong) NSMutableArray * personList;


@end
