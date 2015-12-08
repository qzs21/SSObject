//
//  SSObjectOutput.m
//  Pods
//
//  Created by Steven on 15/11/23.
//
//

#import "SSObjectOutput.h"
#import "SSObjectProperty.h"

@implementation SSObject (SSObjectOutput)

- (NSString *)date:(NSDate *)date withFormat:(NSString *)format {
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:format];
    return [outputFormatter stringFromDate:date];
}

- (NSDictionary *)dictionaryFormInfoWithNull:(BOOL)withNull
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    
    id value = nil;
    NSString * key = nil;
    for (SSObjectProperty * property in [self.class propertyItems])
    {
        key = property.name;
        value = [self valueForKey:key];
        
        if ([value isKindOfClass:NSDate.class])
        {
            [dic setObject:[self date:value withFormat:[self dateFormatWithPropertyName:key]] forKey:key];
        } else if ([value isKindOfClass:SSObject.class]) {
            [dic setObject:[value dictionaryFormInfo] forKey:key];
        } else if ([value isKindOfClass:NSArray.class]) {
            NSMutableArray * arr = [NSMutableArray array];
            for (id obj in value) {
                if ([obj isKindOfClass:SSObject.class]) {
                    [arr addObject:[obj dictionaryFormInfo]];
                } else {
                    [arr addObject:obj];
                }
            }
            [dic setObject:arr forKey:key];
        } else {
            if (withNull)
            {
                [dic setObject:value?value:[NSNull null] forKey:key];
            }
            else
            {
                if (value != nil && value != [NSNull null])
                {
                    [dic setObject:value forKey:key];
                }
            }
        }
    }
    return dic;
}
/// 按照自身属性生成字典，一般用于序列化保存
- (NSDictionary *)dictionaryFormInfo {
    return [self dictionaryFormInfoWithNull:YES];
}
- (NSDictionary *)dictionaryFormInfoWithoutNullValue
{
    return [self dictionaryFormInfoWithNull:NO];
}

#pragma mark - Debug 输出
- (NSString *)getDebugString {
    return [NSString stringWithFormat:@"\r\n%@ <0x%08X>:\r\n%@", self.class, (int)self, self.dictionaryFormInfo];
}
- (NSString *)description {
    return [self getDebugString];
}
- (NSString *)debugDescription {
    return [self getDebugString];
}

@end
