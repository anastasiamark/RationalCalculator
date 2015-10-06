//
//  AMRationalFraction+NSString.h
//  RationalCalculator
//
//  Created by Mark on 05.10.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "AMRationalFraction.h"

@interface AMRationalFraction (NSString)

- (NSString *)stringFromRationalFraction;

- (NSString *)stringFromRationalFractionWithOperationSymbol:(NSString *)symbol andAnotherFraction:(AMRationalFraction *)fraction;

@end
