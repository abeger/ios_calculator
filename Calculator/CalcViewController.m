//
//  CalcViewController.m
//  Calculator
//
//  Created by Andreas Beger on 4/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalcViewController.h"
#import "CalculatorBrain.h"

// Private interface
@interface CalcViewController ()
@property (nonatomic) BOOL userIsEnteringNum;
@property (nonatomic, strong) CalculatorBrain *brain;
@end

@implementation CalcViewController

// Always name instance variable something else than 
// property name.
// synthesize creates getter & setter
@synthesize display = _display; 
@synthesize log = _log;
@synthesize userIsEnteringNum = _userIsEnteringNum;
@synthesize brain = _brain;

- (CalculatorBrain *)brain {
    if (!_brain) {
        _brain = [[CalculatorBrain alloc] init];
    }
    return _brain;
}

- (IBAction)digitPressed:(UIButton *)sender {
    // Dump title of button into digit
    NSString *digit = [sender currentTitle];
    //NSLog(@"digit pressed = %@", digit);
    
//    if (]) {
        if (self.userIsEnteringNum && ![self isDisplayZero]) {
            // Append digit to display text
            self.display.text = [self.display.text stringByAppendingString:digit];
        } else {
            self.display.text = digit;
            self.userIsEnteringNum = YES;
        }
//    }
}

/**
 * Returns whether the current display is "0"
 */
- (BOOL) isDisplayZero {
    return [@"0" isEqualToString:self.display.text];
}

- (IBAction)decimalPressed {
    if (self.userIsEnteringNum) {
        if ([self.display.text rangeOfString:@"."].location == NSNotFound) {
            self.display.text = [self.display.text stringByAppendingString:@"."];
        }
    } else {
        self.display.text = @"0.";
        self.userIsEnteringNum = YES;
    }
}

- (IBAction)plusMinusPressed {
    //user is entering number, let them switch sign w/no consequence
    if (self.userIsEnteringNum) {
        if ([self.display.text hasPrefix:@"-"]) {
            self.display.text = [self.display.text substringFromIndex:1];
        } else if (![self isDisplayZero]) {
            //only append minus sign if display != 0
            self.display.text = [@"-" stringByAppendingString:self.display.text];
        }
    } else {
        //no number being entered, invert last-entered number
        [self executeOperation:@"+/-"];
    }
    
}

- (IBAction)operationPressed:(UIButton *)sender {
    if (self.userIsEnteringNum) {
        [self enterPressed];
    }
    NSString *operation = [sender currentTitle];
    [self executeOperation:operation];
}

- (void)executeOperation:(NSString *)operation {
    [self logValue:operation];
    
    double result = [self.brain performOperation:operation];
    self.display.text = [NSString stringWithFormat:@"%g", result];
    [self logValue:[NSString stringWithFormat:@"=%@", self.display.text]];    
}

- (IBAction)enterPressed {
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.userIsEnteringNum = NO;
    [self logValue:self.display.text];
}

- (IBAction)clearPressed {
    [self.brain clear];
    self.userIsEnteringNum = NO;
    self.display.text = @"0";
    self.log.text = @"";
}

- (IBAction)backspacePressed {
    //no backspacing unless they're entering a number
    if (!self.userIsEnteringNum) {
        return;
    }
    int len = self.display.text.length;
    if (len == 1) {
        self.display.text = @"0";
    } else {
        self.display.text = [self.display.text substringToIndex:(len-1)];
    }
}

- (void)logValue:(NSString *)value {
    static int maxLength = 35;
    self.log.text = [self.log.text stringByAppendingFormat:@"%@ ", value];
    if (self.log.text.length > maxLength) {
        int startIndex = self.log.text.length - maxLength;
        self.log.text = [self.log.text substringFromIndex:startIndex];
    }
}

@end
