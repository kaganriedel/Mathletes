//
//  main.m
//  Mathletes
//
//  Created by MobileMath.co on 2/7/14.
//  Copyright (c) 2014 MobileMath.co. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"

int main(int argc, char * argv[])
{
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}


//interface is in Prefix.pch
@implementation NSUserDefaults (mathletes)

- (int)incrementKey:(NSString *)key
{
    int value = [self integerForKey:key] + 1;
    [self setInteger:value forKey:key];
    return value;
}

- (int)decrementKey:(NSString *)key
{
    int value = [self integerForKey:key] - 1;
    if (value >= 0)
    {
        [self setInteger:value forKey:key];
    }
    return value;
}

@end

@implementation PFObject (mathletes)

-(int)increaseKey:(NSString *)key
{
    NSNumber *value = @([[self objectForKey:key] intValue] + 1);
    
    [self setObject:value forKey:key];
    
    return value.intValue;
    
}

-(int)decrementKey:(NSString *)key
{
    NSNumber *value = @([[self objectForKey:key] intValue] - 1);
    if (value >= 0)
    {
        [self setObject:value forKey:key];
        return [value intValue];
    }
    return 0;
}

@end

@implementation UIColor (mathletes)

+(UIColor*)myGreenColor
{
    UIColor *color = [UIColor colorWithRed:130.0/255.0 green:183.0/255.0 blue:53.0/255.0 alpha:1];
    return color;
}

+(UIColor*)myRedColor
{
    UIColor *color = [UIColor colorWithRed:222.0/255.0 green:54.0/255.0 blue:64.0/255.0 alpha:1];
    return color;
}

+(UIColor*)myYellowColor
{
    UIColor *color = [UIColor colorWithRed:(221.0/255.0) green:(168.0/255.0) blue:(57.0/255.0) alpha:0.9];
    return color;
}

+(UIColor*)myBlueColor
{
    UIColor *color = [UIColor colorWithRed:(95.0/255.0) green:(162.0/255.0) blue:(219/255.0) alpha:1];
    return color;
}

@end

@implementation NSArray (stickerarray)

+(NSArray*)stickerArray
{
    NSArray *stickerArray = @[@"Rocket_Ship", @"Mountain", @"Galaxy", @"Kitten", @"Fish", @"Cookies", @"Monkey", @"Earth", @"Palm_Tree", @"Puppy", @"Apple", @"Train", @"Sports_Car", @"Comet", @"Campfire", @"School_Bus", @"Pirate_Ship", @"Tent", @"Flower", @"Giraffe", @"Ice_Cream", @"Helicopter", @"Watermelon", @"Panda"];
    return stickerArray;
}

@end
