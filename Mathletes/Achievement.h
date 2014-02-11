//
//  Achievement.h
//  Mathletes
//
//  Created by Kagan Riedel on 2/10/14.
//  Copyright (c) 2014 Kagan Riedel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Achievement : NSObject

@property NSString *name;
@property NSString *description;
@property NSString *message;
@property BOOL isAchieved;

-(id)initWithName:(NSString *)name Description:(NSString *)description Message:(NSString *)message;

@end
