//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Andreas Beger on 4/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain ()
@property (nonatomic, strong) NSMutableArray *operandStack;
@property (nonatomic, strong) NSNumber *memory;
@end

@implementation CalculatorBrain

@synthesize operandStack = _operandStack;
@synthesize memory = _memory;

// Implement setter in order to lazy instantiate.
// Because we did this, synthesize won't generate.
- (NSMutableArray *)operandStack {
    if (_operandStack == nil) {
        _operandStack = [[NSMutableArray alloc] init];
    }
    return _operandStack;
}

- (NSNumber *)memory {
    if (_memory == nil) {
        _memory = [[NSNumber alloc] initWithDouble:0];
    }
    return _memory;
}

- (void) pushOperand:(double)operand {
    [self.operandStack addObject:[NSNumber numberWithDouble:operand]];
}

/**
 * Returns and removes the last-entered operand. 
 * If no operands are available, returns 0
 */
- (double) popOperand {
    double operand = [self peekOperand];
    [self.operandStack removeLastObject];
    return operand;
}

/**
 * Returns the last-entered operand. 
 * If no operands are available, returns 0
 */
- (double) peekOperand {
    NSNumber *operandObject = [self.operandStack lastObject];
    if (!operandObject) {
        return 0;
    }
    return [operandObject doubleValue];
}

/**
 * Wipe out all objects in the stack
 */
- (void) clear {
    [self.operandStack removeAllObjects];
}

- (double) performOperation:(NSString *)operation {
    double result = 0;
    
    if ([@"+" isEqualToString:operation]) {
        result = [self popOperand] + [self popOperand];
    } else if ([@"*" isEqualToString:operation]) {
        result = [self popOperand] * [self popOperand];
    } else if ([@"-" isEqualToString:operation]) {
        double operand1 = [self popOperand];
        double operand2 = [self popOperand];
        result = operand2 - operand1;
    } else if ([@"/" isEqualToString:operation]) {
        //protect against divide by 0
        double operand1 = [self popOperand];
        double operand2 = [self popOperand];
        if (operand1 == 0) {
            result = 0;
        } else {
            result = operand2 / operand1;
        }
    } else if ([@"sin" isEqualToString:operation]) {
        result = sin([self popOperand]);
    } else if ([@"cos" isEqualToString:operation]) {
        result = cos([self popOperand]);
    } else if ([@"sqrt" isEqualToString:operation]) {
        double operand1 = [self popOperand];
        if (operand1 < 0) {
            result = 0;
        } else {
            result = sqrt(operand1);
        }
    } else if ([@"π" isEqualToString:operation]) {
        result = M_PI;
    } else if ([@"+/-" isEqualToString:operation]) {
        double operand = [self popOperand];
        result = operand == 0 ? 0 : -1 * operand;
        
    } else if ([@"M+" isEqualToString:operation]) {
        double newVal = self.memory.doubleValue + [self peekOperand];
        self.memory = [NSNumber numberWithDouble:newVal];
        result = [self peekOperand];
    } else if ([@"MR" isEqualToString:operation]) {
        result = self.memory.doubleValue;
    } else if ([@"MC" isEqualToString:operation]) {
        self.memory = [NSNumber numberWithDouble:0];
        result = [self peekOperand];
    }
    
    
    [self pushOperand:result];
    
    return result;
}

@end
