//
//  AMArithmeticOperation.h
//  RationalCalculator
//
//  Created by Mark on 03.10.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    AMArithmeticOperationAddition = 1,
    AMArithmeticOperationSubtraction,
    AMArithmeticOperationMultiplication,
    AMArithmeticOperationDivision
} AMArithmeticOperationType;

typedef enum : NSUInteger {
    AMArithmeticOperationPriorityLow = 100,
    AMArithmeticOperationPriorityHigh = 130,
} AMArithmeticOperationPriority;

@interface AMArithmeticOperation : NSObject {
@protected
    NSString *_symbol;
    AMArithmeticOperationType _type;
    AMArithmeticOperationPriority _priority;
}

@property (nonatomic, readonly) NSString *symbol;
@property (nonatomic, readonly) AMArithmeticOperationType type;
@property (nonatomic, readonly) AMArithmeticOperationPriority priority;

+ (instancetype)operationWithType:(AMArithmeticOperationType)operationType;

@end
