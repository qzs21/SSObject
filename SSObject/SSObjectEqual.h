//
//  SSObjectEqual.h
//  Pods
//
//  Created by Steven on 15/11/23.
//
//

#import <SSObject/SSObject.h>

/**
 *  实现判断两个SSObject对象是否相等
 */
@interface SSObject (SSObjectEqual)

/// 判断对象所有的属性值是否都相等，实现递归判断
- (BOOL)isEqual:(id)object;

@end
