//
//  FlashCard.h
//  Mathletes
//
//  Created by Matthew Voracek on 2/11/14.
//  Copyright (c) 2014 Kagan Riedel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface MathProblem : PFObject <PFSubclassing>

+ (NSString *)parseClassName;

@property (retain)NSString *displayName;
@property NSInteger mathProblemValue;
@property NSInteger equationDifficulty;
@property BOOL haveAttemptedEquation;

-(id)initWithDifficulty:(NSInteger) difficulty forProblem:(NSInteger) problem;

@end
