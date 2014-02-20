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

@dynamic mathUser;
@dynamic displayName;
@dynamic problemType;
@dynamic mathProblemValue;
@dynamic equationDifficulty;
@dynamic haveAttemptedEquation;

+ (NSString *)parseClassName
{
    return @"MathProblem";
}

-(id)initWithDifficulty:(NSInteger) difficulty forProblem:(NSInteger) problem ofProblemType:(NSInteger) type
{
    self = [super init];
    self.mathUser = [PFUser currentUser];
    self.equationDifficulty = difficulty;
    self.mathProblemValue = problem;
    self.problemType = type;
    self.haveAttemptedEquation = NO;
    return self;
}     

@end

/*
@implementation AdditionProblem

+ (NSString *)parseClassName
{
    return @"AdditionProblem";
}

@end


@implementation SubtractionProblem

+ (NSString *)parseClassName
{
    return @"SubtractionProblem";
}

@end
*/