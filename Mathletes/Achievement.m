//
//  Achievement.m
//  Mathletes
//
//  Created by Kagan Riedel on 2/10/14.
//  Copyright (c) 2014 Kagan Riedel. All rights reserved.
//

#import "Achievement.h"

@implementation Achievement

-(id)initWithName:(NSString *)name Description:(NSString *)description Message:(NSString *)message
{
    self = [super init];
    self.name = name;
    self.description = description;
    self.message = message;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.isAchieved = [userDefaults boolForKey:name];

    return self;
}

@end
