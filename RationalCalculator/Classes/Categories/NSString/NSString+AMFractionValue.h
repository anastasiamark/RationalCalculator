//
//  NSString+AMFractionValue.h
//  RationalCalculator
//
//  Created by Mark on 03.10.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AMRationalFraction;
@class AMArithmeticOperation;

@interface NSString (AMFractionValue)

- (AMRationalFraction *)fractionValue;
- (AMRationalFraction *)fractionValueAfterOperation:(AMArithmeticOperation *)nextOperation;
- (AMRationalFraction *)fractionValueBeforeOperation:(AMArithmeticOperation *)previousOperation;

@end
