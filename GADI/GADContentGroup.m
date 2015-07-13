//
//  GADContentGroup.m
//  GADIDemo
//
//  Created by HiromiMotodera on 2015/07/13.
//  Copyright (c) 2015 MOAI. All rights reserved
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

- (NSString *)description
{
    return [NSString stringWithFormat:@"<GADContentGroup index = %ld, value = %@>", self.index, self.value];
}

@end
