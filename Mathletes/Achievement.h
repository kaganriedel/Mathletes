//
//  Achievement.h
//  Mathletes
//
//  Created by MobileMath.co on 2/7/14.
//  Copyright (c) 2014 MobileMath.co. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Achievement : NSObject

@property NSString *name;
@property NSString *description;
@property NSString *message;
@property BOOL isAchieved;

-(id)initWithName:(NSString *)name Description:(NSString *)description Message:(NSString *)message;

@end
