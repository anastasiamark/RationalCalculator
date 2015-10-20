//
//  AMCalculatorItem.h
//  RationalCalculator
//
//  Created by Mark on 12.10.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AMArithmeticOperation.h"

typedef enum : NSUInteger {
    AMCalculatorItemTypeExpression,
    AMCalculatorItemTypeSymbol,
    AMCalculatorItemTypeNumber,
    AMCalculatorItemTypeCleanOneSymbol,
    AMCalculatorItemTypeCleanAll,
    AMCalculatorItemTypeChangeSign,
} AMCalculatorItemType;

@interface AMCalculatorItem : NSObject

@property (strong, nonatomic) NSString *title;
@property (assign, nonatomic) AMCalculatorItemType type;
@property (assign, nonatomic) AMArithmeticOperationType operationType;

+ (instancetype)itemWithTitle:(NSString *)title andType:(AMCalculatorItemType)type;

@end
