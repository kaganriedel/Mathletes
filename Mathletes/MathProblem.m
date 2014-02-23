//
//  FlashCard.m
//  Mathletes
//
//  Created by Matthew Voracek on 2/11/14.
//  Copyright (c) 2014 Kagan Riedel. All rights reserved.
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

