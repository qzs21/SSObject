//
//  SSObjectProperty.h
//  Pods
//
//  Created by Steven on 15/6/3.
//
//

#import <Foundation/Foundation.h>

/// class1 是否是 class2或其的子类
bool class_isClass( Class class1, Class class2 );

@interface SSObjectProperty : NSObject

@property (nonatomic, strong) NSString * propertyName;

@property (nonatomic, strong) NSString * propertyType;

@end


@interface NSObject( NSObject_propertyItems)

+ (NSArray *)propertyItems;

@end
