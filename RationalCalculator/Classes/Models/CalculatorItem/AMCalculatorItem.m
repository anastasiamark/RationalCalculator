//
//  AMCalculatorItem.m
//  RationalCalculator
//
//  Created by Mark on 12.10.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "AMCalculatorItem.h"

@implementation AMCalculatorItem

- (instancetype)initWithTitle:(NSString *)title andType:(AMCalculatorItemType)type
{
    self = [super init];
    if (self) {
        _title = title;
        _type = type;
    }
    return self;
}

+ (instancetype)itemWithTitle:(NSString *)title andType:(AMCalculatorItemType)type
{
    return [[self alloc] initWithTitle:title andType:type];
}

@end
