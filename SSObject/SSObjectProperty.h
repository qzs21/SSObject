//
//  SSObjectProperty.h
//  Pods
//
//  Created by Steven on 15/6/3.
//
//

#import <Foundation/Foundation.h>

/**
 属性的类型
 */
typedef enum {
    SSObjectPropertyTypeUnknown,
    SSObjectPropertyTypeObject,
    SSObjectPropertyTypeInt,
    SSObjectPropertyTypeUnsignedInt,
    SSObjectPropertyTypeShort,
    SSObjectPropertyTypeUnsignedShort,
    SSObjectPropertyTypeLong,           ///< NSInteger
    SSObjectPropertyTypeUnsignedLong,   ///< NSUInteger
    SSObjectPropertyTypeChar,
    SSObjectPropertyTypeUnsignedChar,
    SSObjectPropertyTypeBOOL,
    SSObjectPropertyTypeDouble,
    SSObjectPropertyTypeFloat,
} SSObjectPropertyType;


/// class1 是否是 class2或其的子类
bool class_isClass( Class class1, Class class2 );

/// 对象的属性信息
@interface SSObjectProperty : NSObject
@property (nonatomic, copy) NSString * name; ///< 属性名
@property (nonatomic, assign) SSObjectPropertyType type; ///< 属性类型
@property (nonatomic, assign) Class class; ///< 属所属的类
@end


@interface NSObject( NSObject_propertyItems)

/// 获取某个对象的属性信息
+ (NSArray *)propertyItems;

@end
