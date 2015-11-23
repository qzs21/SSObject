//
//  SimpleTests.m
//  SimpleTests
//
//  Created by Steven on 15/4/29.
//  Copyright (c) 2015年 Neva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "SimpleObject.h"
#import "SSObject/SSObjectProperty.h"

#define STR(str) [NSString stringWithFormat:@"%@", str]

@interface SimpleTests : XCTestCase

@property (nonatomic, strong) NSDictionary * testDicationry;

@end

@implementation SimpleTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    self.testDicationry = @{
        @"intValue": @(SSObjectPropertyTypeInt),
        @"unsignedIntValue": @(SSObjectPropertyTypeUnsignedInt),
        @"shortValue": @(SSObjectPropertyTypeShort),
        @"unsignedShortValue": @(SSObjectPropertyTypeUnsignedShort),
        @"longValue": @(SSObjectPropertyTypeLong),
        @"unsignedLongValue": @(SSObjectPropertyTypeUnsignedLong),
        @"charValue": @(SSObjectPropertyTypeChar),
        @"unsignedCharValue": @(SSObjectPropertyTypeUnsignedChar),
        @"boolValue": @(YES),
        @"doubleValue": @(2.3),
        @"floatValue": @(6.9),
        @"stringValue": @"StringDone",
        @"numberValue": @(1),
        @"dateValue": @(1435030889000),
    };
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSetDictionryOneLevel {
    // 测试一个层级的字典，验证每个值的设置是否正确
    SimpleObject * obj = [SimpleObject objectWithDictionary:self.testDicationry];
    XCTAssert(obj.intValue == SSObjectPropertyTypeInt, @"int value error");
    XCTAssert(obj.unsignedIntValue == SSObjectPropertyTypeUnsignedInt, @"unsigned int value error");
    XCTAssert(obj.shortValue == SSObjectPropertyTypeShort, @"short value error");
    XCTAssert(obj.unsignedShortValue == SSObjectPropertyTypeUnsignedShort, @"unsigend short value error");
    XCTAssert(obj.longValue == SSObjectPropertyTypeLong, @"long value error");
    XCTAssert(obj.unsignedLongValue == SSObjectPropertyTypeUnsignedLong, @"unsigend long value error");
    XCTAssert(obj.charValue == SSObjectPropertyTypeChar, @"char value error");
    XCTAssert(obj.unsignedCharValue == SSObjectPropertyTypeUnsignedChar, @"unsigend char value error");
}

- (void)testSetObjectProperty {
    // 测试验证属性是对象时设置是否正确，测试仅在-testEqual通过时有效
    
    NSDictionary * dic = @{
       @"objectValue": self.testDicationry,
    };
    
    SimpleObject * obj1 = [SimpleObject objectWithDictionary:dic]; // 需要测试的对象
    SimpleObject * obj2 = [SimpleObject objectWithDictionary:self.testDicationry]; // 用于比较的样板
    
    XCTAssert([obj1.objectValue isEqual:obj2], @"object value error");
}

- (void)testSetArrayProperty {
    // 测试数组设置是否正确，测试仅在-testEqual通过时有效
    NSDictionary * dic = @{
        @"arrayValue": @[self.testDicationry, self.testDicationry]
    };
    
    SimpleObject * obj1 = [SimpleObject objectWithDictionary:dic];
    SimpleObject * obj2 = [SimpleObject objectWithDictionary:self.testDicationry];
    
    for (SimpleObject * o in obj1.arrayValue) {
        XCTAssert([o isEqual:obj2], @"array value error");
    }
}

- (void)testIsEqual {
    // 测试两个对象是否相等
    SimpleObject * o1 = [SimpleObject objectWithDictionary:self.testDicationry];
    SimpleObject * o2 = [SimpleObject objectWithDictionary:self.testDicationry];
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:self.testDicationry];
    [dic setObject:@(SSObjectPropertyTypeLong) forKey:@"intValue"];
    SimpleObject * o3 = [SimpleObject objectWithDictionary:dic];
    
    XCTAssert([o1 isEqual:o2], @"test isEqual error");
    XCTAssert((![o1 isEqual:o3]), @"test isEqual error");
}

- (void)testPerformanceExample {
    // 性能测试
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        for (int i = 0; i < 10000; i++) {
            [SimpleObject objectWithDictionary:self.testDicationry];
        }
    }];
}

@end
