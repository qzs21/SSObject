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
                                            @"intValue": @(80) },
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
}

@end
