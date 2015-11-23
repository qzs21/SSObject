//
//  SSObjectEqual.m
//  Pods
//
//  Created by Steven on 15/11/23.
//
//

#import "SSObjectEqual.h"
#import "SSObjectProperty.h"

@implementation SSObject (SSObjectEqual)

/// 判断对象属性值是否都相等
- (BOOL)isEqual:(id)object
{
    if (![object isKindOfClass:self.class])
    {
        return NO;
    }
    
    NSString * key = nil;
    id value1 = nil;
    id value2 = nil;
    for (SSObjectProperty * property in [self.class propertyItems])
    {
        key = property.name;
        
        value1 = [self valueForKey:key];
        value2 = [object valueForKey:key];
        
        if (value1 != value2)
        {
            if (value1 && ![value1 isEqual:value2])
            {
                return NO;
            }
            else if (value2 && ![value2 isEqual:value1])
            {
                return NO;
            }
        }
    }
    
    return YES;
}

@end
