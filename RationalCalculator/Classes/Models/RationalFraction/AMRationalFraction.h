//
//  AMRationalFraction.h
//  RationalCalculator
//
//  Created by Mark on 29.09.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMRationalFraction : NSObject

@property (nonatomic) NSInteger numerator;
@property (nonatomic) NSInteger denominator;

+ (instancetype)fractionWithIntegerPart:(NSInteger)intPart andFractionalPart:(NSInteger)fractPart;

- (NSInteger)calculateGCDForNumber1:(NSInteger)num1 andNumber2:(NSInteger)num2;
- (NSInteger)calculateLCMForNumber1:(NSInteger)num1 andNumber2:(NSInteger)num2;

- (BOOL)isEqualToFraction:(AMRationalFraction *)fraction;
- (BOOL)isLessThanFraction:(AMRationalFraction *)fraction;
- (BOOL)isGreaterThanFraction:(AMRationalFraction *)fraction;

@end
