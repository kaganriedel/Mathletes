//
//  FlashCard.h
//  Mathletes
//
//  Created by MobileMath.co on 2/7/14.
//  Copyright (c) 2014 MobileMath.co. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface MathProblem : PFObject <PFSubclassing>

+ (NSString *)parseClassName;

@property (retain)NSString *displayName;
@property PFUser *mathUser;
@property NSInteger equationDifficulty;
@property NSInteger problemType;
@property NSInteger firstValue;
@property NSInteger secondValue;
@property BOOL haveAttemptedEquation;

-(id)initWithDifficulty:(NSInteger) difficulty ofProblemType:(NSInteger) type forFirstValue:(NSInteger) firstProblem forSecondValue:(NSInteger) secondProblem;

@end
