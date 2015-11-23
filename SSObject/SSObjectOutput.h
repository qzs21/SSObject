//
//  SSObjectOutput.h
//  Pods
//
//  Created by Steven on 15/11/23.
//
//

#import <SSObject/SSObject.h>

/**
 *  实现SSObject输出功能：
 *      1.输出字典用于序列化
 *      2.输出debug信息
 */
@interface SSObjectOutput : SSObject

/// 按照自身属性生成字典，一般用于序列化保存
@property (nonatomic, readonly) NSDictionary * dictionaryFormInfo;
@property (nonatomic, readonly) NSDictionary * dictionaryFormInfoWithoutNullValue; // 同上，忽略空值

@end
