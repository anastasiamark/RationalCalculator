//
//  NSString+AMFractionValue.m
//  RationalCalculator
//
//  Created by Mark on 03.10.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "NSString+AMFractionValue.h"

#import "AMRationalFraction.h"
#import "AMArithmeticOperation.h"

static NSString *const kFractionDivider = @"/";

@implementation NSString (AMFractionValue)

- (AMRationalFraction *)fractionValue
{
    NSArray *fractionArray = [self componentsSeparatedByString:kFractionDivider];
    if (fractionArray.count == 2) {
        NSInteger numerator = [fractionArray[0] integerValue];
        NSInteger denominator = [fractionArray[1] integerValue];
        return [AMRationalFraction fractionWithIntegerPart:numerator andFractionalPart:denominator];
    }
    if (fractionArray.count == 1) {
        NSInteger numerator = [fractionArray[0] integerValue];
        NSInteger denominator = 1;
        return [AMRationalFraction fractionWithIntegerPart:numerator andFractionalPart:denominator];
    }
    return nil;
}

- (AMRationalFraction *)fractionValueAfterOperation:(AMArithmeticOperation *)nextOperation
{
    NSArray *array = [self componentsSeparatedByString:nextOperation.symbol];
    return [array[0] fractionValue];
}

- (AMRationalFraction *)fractionValueBeforeOperation:(AMArithmeticOperation *)previousOperation
{
    NSArray *array = [self componentsSeparatedByString:previousOperation.symbol];
    return [array[array.count - 1] fractionValue];
}

@end
