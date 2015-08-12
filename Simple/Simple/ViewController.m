//
//  ViewController.m
//  Simple
//
//  Created by Steven on 15/4/29.
//  Copyright (c) 2015年 Neva. All rights reserved.
//

#import "ViewController.h"
#import "SimpleObject.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary * dic = @{ @"testObj": @{  @"name": @"test2",
                                            @"intValue": @(80),
                                            @"dateValue": @(1435030889000)},
                            @"name":        @"test1",
                            @"intValue":    @"10",
                            @"value":       @{  @"key1": @"value1" },
                            @"testItems":   @[  @{ @"name": @"testName1"},
                                                @{ @"name": @"testName2"},
                                                @{ @"name": @"testName3"}]};
    NSArray * arr = @[  @{@"name": @"testName1"},
                        @{@"name": @"testName2"},
                        @{@"name": @"testName3"}];
    SimpleObject * obj = [SimpleObject objectWithDictionary:dic];
    NSArray * objItems = [SimpleObject arrayWithDictionarys:arr];
    NSLog(@"%@", obj);
    NSLog(@"%@", obj.dictionaryFormInfo);
    NSLog(@"%@", objItems);
    
    [obj setDictionary:@{@"name": @"213131"}];
    NSLog(@"%@", obj);
    
    
    // 对象对比
    SimpleObject * o1 = [SimpleObject objectWithDictionary:@{@"name": @"steven"}];
    SimpleObject * o2 = [SimpleObject objectWithDictionary:@{@"name": @"steven"}];
    SimpleObject * o3 = [SimpleObject objectWithDictionary:@{@"name": @"steven1"}];
    
    NSLog(@"%d", [o1 isEqual:o2]);
    NSLog(@"%d", [o1 isEqual:o3]);
}

@end
