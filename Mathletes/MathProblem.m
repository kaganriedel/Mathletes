//
//  FlashCard.m
//  Mathletes
//
//  Created by Matthew Voracek on 2/11/14.
//  Copyright (c) 2014 Kagan Riedel. All rights reserved.
//

#import "MathProblem.h"

@implementation MathProblem


-(id)initWithDifficulty:(NSInteger) difficulty forProblem:(NSInteger) problem
{
    self = [super init];
    self.equationDifficulty = difficulty;
    self.mathProblemValue = problem;
    self.haveAttemptedEquation = NO;
    return self;
}     

@end
