//
//  AMDivisionOperation.m
//  RationalCalculator
//
//  Created by Mark on 03.10.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "AMDivisionOperation.h"

#import "AMArithmeticOperation.h"

@implementation AMDivisionOperation

#pragma mark - Lifecycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        _symbol = @":";
        _type = AMArithmeticOperationDivision;
        _priority = AMArithmeticOperationPriorityHigh;
    }
    return self;
}

@end
