//
//  AMRationalFraction.m
//  RationalCalculator
//
//  Created by Mark on 29.09.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "AMRationalFraction.h"

static NSInteger const kFractionInitialValue = 1.f;

@implementation AMRationalFraction

#pragma mark - Accessors

- (NSString *)description
{
    NSString *desc = [NSString stringWithFormat:@"Numerator = %ld, Denomnator = %ld", (long)self.numerator, (long)self.denominator];
    return desc;
}

#pragma mark - Lifecycle

- (instancetype)init
{
    return [self initWithIntegerPart:kFractionInitialValue andFractionalPart:kFractionInitialValue];
}

- (instancetype)initWithIntegerPart:(NSInteger)intPart
{
    return [self initWithIntegerPart:intPart andFractionalPart:kFractionInitialValue];
}

- (instancetype)initWithIntegerPart:(NSInteger)intPart andFractionalPart:(NSInteger)fractPart
{
    self = [super init];
    if (self) {
        _numerator = intPart;
        _denominator = fractPart;
        
        [self reduceFraction];
        
    }
    return self;
}

+ (instancetype)fractionWithIntegerPart:(NSInteger)intPart andFractionalPart:(NSInteger)fractPart
{
    return [[self alloc] initWithIntegerPart:intPart andFractionalPart:fractPart];
}

#pragma mark - Comparing

- (BOOL)isLessThanFraction:(AMRationalFraction *)fraction
{
    return ![self isGreaterThanFraction:fraction];
}

- (BOOL)isGreaterThanFraction:(AMRationalFraction *)fraction
{
    if ([self isEqualToFraction:fraction]) {
        return NO;
    }
    
    NSInteger commonDivider = [self calculateLCMForNumber1:self.denominator andNumber2:fraction.denominator];
    
    NSInteger resultNumerator1 = commonDivider/self.denominator * self.numerator;
    NSInteger resultNumerator2 = commonDivider/fraction.denominator * fraction.numerator;
    
    return resultNumerator1 > resultNumerator2;
}

#pragma mark - Equality

- (BOOL)isEqual:(id)object
{
    if (self == object) {
        return YES;
    }
    
    if (!([[object class] isSubclassOfClass:[self class]])) {
        return NO;
    }
    
    return [self isEqualToFraction:(AMRationalFraction *)object];
}

- (BOOL)isEqualToFraction:(AMRationalFraction *)fraction
{
    if (!fraction) {
        return NO;
    }
    
    BOOL hasEqualNumerators = fraction.numerator == self.numerator;
    BOOL hasEqualDenominators = fraction.denominator == self.denominator;
    
    return hasEqualDenominators && hasEqualNumerators;
}

#pragma mark - GCD and LCM Methods

- (NSInteger)calculateGCDForNumber1:(NSInteger)num1 andNumber2:(NSInteger)num2
{
    while (num2 != 0) {
        NSInteger rest = num1 % num2;
        num1 = num2;
        num2 = rest;
    }
    return num1;
}

- (NSInteger)calculateLCMForNumber1:(NSInteger)num1 andNumber2:(NSInteger)num2
{
    return num1 / [self calculateGCDForNumber1:num1 andNumber2:num2] * num2;
}

#pragma mark - Reduce Fraction Method

- (void)reduceFraction
{
    NSInteger gcd = [self calculateGCDForNumber1:self.numerator andNumber2:self.denominator];
    self.numerator /= gcd;
    self.denominator /= gcd;
}

@end
