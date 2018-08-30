//
//  BaseModel.m
//
//  Created by 王炜圣 on 2018/8/29.
//  Copyright © 2018年 王炜圣. All rights reserved.
//


#import "BaseModel.h"

@implementation BaseModel

#pragma mark - Coding/Copying/hash/equal/description

// 直接添加以下代码即可自动完成
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self modelEncodeWithCoder:aCoder];
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    
    return [self modelInitWithCoder:aDecoder];
}
- (id)copyWithZone:(NSZone *)zone {
    return [self modelCopy];
}
- (NSUInteger)hash {
    return [self modelHash];
}
- (BOOL)isEqual:(id)object {
    return [self modelIsEqual:object];
}
- (NSString *)description {
    return [self modelDescription];
}



#pragma mark - Attributes
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return nil;
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return nil;
}


#pragma mark - 黑名单与白名单
// 如果实现了该方法，则处理过程中会忽略该列表内的所有属性
+ (NSArray *)modelPropertyBlacklist {
    return nil;
}
// 如果实现了该方法，则处理过程中不会处理该列表外的属性。
+ (NSArray *)modelPropertyWhitelist {
    return nil;
}



#pragma mark - 数据校验与自定义转换
// 当 JSON 转为 Model 完成后，该方法会被调用。
// 你可以在这里对数据进行校验，如果校验不通过，可以返回 NO，则该 Model 会被忽略。
// 你也可以在这里做一些自动转换不能完成的工作。
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    
    return YES;
}

// 当 Model 转为 JSON 完成后，该方法会被调用。
// 你可以在这里对数据进行校验，如果校验不通过，可以返回 NO，则该 Model 会被忽略。
// 你也可以在这里做一些自动转换不能完成的工作。
- (BOOL)modelCustomTransformToDictionary:(NSMutableDictionary *)dic {
    
    return YES;
}



@end







