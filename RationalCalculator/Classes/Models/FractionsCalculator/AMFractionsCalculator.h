//
//  AMFractionsCalculator.h
//  RationalCalculator
//
//  Created by Mark on 03.10.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AMRationalFraction, AMArithmeticOperation;

@interface AMFractionsCalculator : NSObject

@property (nonatomic) NSMutableArray *operations;

- (void)performArithmeticalOperationWithExpression:(NSString *)expression
                      withCompletion:(void(^)(AMRationalFraction *resultFraction))completion;

@end
