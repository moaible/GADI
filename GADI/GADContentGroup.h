//
//  GADContentGroup.h
//  GADIDemo
//
//  Created by 本寺広海 on 2015/07/13.
//  Copyright (c) 2015年 HiromiMotodera. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GADContentGroup : NSObject

@property (nonatomic) NSUInteger index;

@property (nonatomic, copy) NSString *value;

+ (instancetype)contentGroupWithIndex:(NSUInteger)index value:(NSString *)value;

@end
