//
//  FlashCard.m
//  Mathletes
//
//  Created by MobileMath.co on 2/7/14.
//  Copyright (c) 2014 MobileMath.co. All rights reserved.
//

#import "MathProblem.h"
#import <Parse/PFObject+Subclass.h>

@implementation MathProblem

@dynamic displayName;
@dynamic mathUser;
@dynamic equationDifficulty;
@dynamic problemType;
@dynamic firstValue;
@dynamic secondValue;
@dynamic haveAttemptedEquation;

+ (NSString *)parseClassName
{
    return @"MathProblem";
}

-(id)initWithDifficulty:(NSInteger) difficulty ofProblemType:(NSInteger) type forFirstValue:(NSInteger) firstProblem forSecondValue:(NSInteger) secondProblem
{
    self = [super init];
    
    if (self) {
        // Initialize
        self.mathUser = [PFUser currentUser];
        self.equationDifficulty = difficulty;
        self.problemType = type;
        self.firstValue = firstProblem;
        self.secondValue = secondProblem;
        self.haveAttemptedEquation = NO;
    }
    
    return self;
}

@end

