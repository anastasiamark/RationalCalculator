//
//  AMRationalFraction+NSString.m
//  RationalCalculator
//
//  Created by Mark on 05.10.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "AMRationalFraction+NSString.h"

@implementation AMRationalFraction (NSString)

- (NSString *)stringFromRationalFraction
{
    if (self.denominator == 1) {
        return [NSString stringWithFormat:@"%ld", (long)self.numerator];
    }
    if (self.numerator == 0) {
        return [NSString stringWithFormat:@"%ld", (long)self.numerator];
    }
    return [NSString stringWithFormat:@"%ld/%ld", (long)self.numerator, (long)self.denominator];
}

- (NSString *)stringFromRationalFractionWithOperationSymbol:(NSString *)symbol andAnotherFraction:(AMRationalFraction *)fraction
{
    return [NSString stringWithFormat:@"%@%@%@", [self stringFromRationalFraction], symbol, [fraction stringFromRationalFraction]];
}

@end
