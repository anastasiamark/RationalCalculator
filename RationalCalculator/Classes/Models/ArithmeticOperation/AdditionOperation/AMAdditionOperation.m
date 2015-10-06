//
//  AMAdditionOperation.m
//  RationalCalculator
//
//  Created by Mark on 03.10.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "AMAdditionOperation.h"

@implementation AMAdditionOperation

#pragma mark - Lifecycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        _symbol = @"+";
        _type = AMArithmeticOperationAddition;
        _priority = AMArithmeticOperationPriorityLow;
    }
    return self;
}

@end
