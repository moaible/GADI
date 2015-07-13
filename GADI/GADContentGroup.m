//
//  GADContentGroup.m
//  GADIDemo
//
//  Created by 本寺広海 on 2015/07/13.
//  Copyright (c) 2015年 HiromiMotodera. All rights reserved.
//

#import "GADContentGroup.h"

@implementation GADContentGroup

+ (instancetype)contentGroupWithIndex:(NSUInteger)index value:(NSString *)value
{
    GADContentGroup *contentGroup = [[GADContentGroup alloc] init];
    contentGroup.index = index;
    contentGroup.value = value;
    return contentGroup;
}

@end
