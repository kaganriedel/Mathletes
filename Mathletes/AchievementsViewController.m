//
//  AchievementsViewController.m
//  Mathletes
//
//  Created by Kagan Riedel on 2/10/14.
//  Copyright (c) 2014 Kagan Riedel. All rights reserved.
//

#import "AchievementsViewController.h"
#import "Achievement.h"
#import "AchievementCell.h"
#import "AchievementHeader.h"

@interface AchievementsViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
{
    NSArray *achievements;
    PFUser *user;
}

@end

@implementation AchievementsViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    user = [PFUser currentUser];
    
    [self loadAllAchievements];
    
}

-(void)loadAllAchievements
{
 
    achievements = @[
                     @[[[Achievement alloc] initWithName:@"Daily Math x10!" Description:@"Complete 10 math problems today" Message:@"You completed 10 math problems today!"],
                       [[Achievement alloc] initWithName:@"Daily Math x20!" Description:@"Complete 20 math problems today" Message:@"You completed 20 math problems today!"],
                       [[Achievement alloc] initWithName:@"Daily Math x30!" Description:@"Complete 30 math problems today" Message:@"You completed 30 math problems today!"],
                       [[Achievement alloc] initWithName:@"Daily Math x40!" Description:@"Complete 40 math problems today" Message:@"You completed 40 math problems today!"],
                       [[Achievement alloc] initWithName:@"Daily Math x50!" Description:@"Complete 50 math problems today" Message:@"You completed 50 math problems today!"]],
                     
                     @[[[Achievement alloc] initWithName:@"Add It Up!" Description:@"Complete 1 addition problem" Message:@"You completed your first addition problem!"],
                       [[Achievement alloc] initWithName:@"Add It Up x20!" Description:@"Complete 20 addition problems" Message:@"You completed 20 addition problems!"],
                       [[Achievement alloc] initWithName:@"Add It Up x40!" Description:@"Complete 40 addition problems" Message:@"You completed 40 addition problems!"],
                       [[Achievement alloc] initWithName:@"Add It Up x60!" Description:@"Complete 60 addition problems" Message:@"You completed 60 addition problems!"],
                       [[Achievement alloc] initWithName:@"Add It Up x80!" Description:@"Complete 80 addition problems" Message:@"You completed 80 addition problems!"],
                       [[Achievement alloc] initWithName:@"Add It Up x100!" Description:@"Complete 100 addition problems" Message:@"You completed 100 addition problems!"],
                       [[Achievement alloc] initWithName:@"Add It Up x120!" Description:@"Complete 120 addition problems" Message:@"You completed 120 addition problems!"],
                       [[Achievement alloc] initWithName:@"Add It Up x140!" Description:@"Complete 140 addition problems" Message:@"You completed 140 addition problems!"],
                       [[Achievement alloc] initWithName:@"Add It Up x160!" Description:@"Complete 160 addition problems" Message:@"You completed 160 addition problems!"],
                       [[Achievement alloc] initWithName:@"Add It Up x180!" Description:@"Complete 180 addition problems" Message:@"You completed 180 addition problems!"],
                       [[Achievement alloc] initWithName:@"Add It Up x200!" Description:@"Complete 200 addition problems" Message:@"You completed 200 addition problems!"],
                       [[Achievement alloc] initWithName:@"Add It Up x225!" Description:@"Complete 225 addition problems" Message:@"You completed 225 addition problems!"],
                       [[Achievement alloc] initWithName:@"Add It Up x250!" Description:@"Complete 250 addition problems" Message:@"You completed 250 addition problems!"],
                       [[Achievement alloc] initWithName:@"Add It Up x275!" Description:@"Complete 275 addition problems" Message:@"You completed 275 addition problems!"],
                       [[Achievement alloc] initWithName:@"Add It Up x300!" Description:@"Complete 300 addition problems" Message:@"You completed 300 addition problems!"]],
                     
                     @[[[Achievement alloc] initWithName:@"Adding At 15 Miles Per Hour!" Description:@"Complete 15 addition problems in less than 6 seconds each" Message:@"You completed 15 addition problems in less than 6 seconds each!"],
                       [[Achievement alloc] initWithName:@"Adding At 30 Miles Per Hour!" Description:@"Complete 30 addition problems in less than 6 seconds each" Message:@"You completed 30 addition problems in less than 6 seconds each!"],
                       [[Achievement alloc] initWithName:@"Adding At 45 Miles Per Hour!" Description:@"Complete 45 addition problems in less than 6 seconds each" Message:@"You completed 45 addition problems in less than 6 seconds each!"],
                       [[Achievement alloc] initWithName:@"Adding At 60 Miles Per Hour!" Description:@"Complete 60 addition problems in less than 6 seconds each" Message:@"You completed 60 addition problems in less than 6 seconds each!"],
                       [[Achievement alloc] initWithName:@"Adding At 75 Miles Per Hour!" Description:@"Complete 75 addition problems in less than 6 seconds each" Message:@"You completed 75 addition problems in less than 6 seconds each!"],
                       [[Achievement alloc] initWithName:@"Adding At 90 Miles Per Hour!" Description:@"Complete 90 addition problems in less than 6 seconds each" Message:@"You completed 90 addition problems in less than 6 seconds each!"],
                       [[Achievement alloc] initWithName:@"Adding At 105 Miles Per Hour!" Description:@"Complete 105 addition problems in less than 6 seconds each" Message:@"You completed 105 addition problems in less than 6 seconds each!"],
                       [[Achievement alloc] initWithName:@"Adding At 120 Miles Per Hour!" Description:@"Complete 120 addition problems in less than 6 seconds each" Message:@"You completed 120 addition problems in less than 6 seconds each!"],
                       [[Achievement alloc] initWithName:@"Adding At 135 Miles Per Hour!" Description:@"Complete 135 addition problems in less than 6 seconds each" Message:@"You completed 135 addition problems in less than 6 seconds each!"],
                       [[Achievement alloc] initWithName:@"Adding At 150 Miles Per Hour!" Description:@"Complete 150 addition problems in less than 6 seconds each" Message:@"You completed 150 addition problems in less than 6 seconds each!"],
                       [[Achievement alloc] initWithName:@"Adding At 170 Miles Per Hour!" Description:@"Complete 170 addition problems in less than 6 seconds each" Message:@"You completed 170 addition problems in less than 6 seconds each!"],
                       [[Achievement alloc] initWithName:@"Adding At 190 Miles Per Hour!" Description:@"Complete 190 addition problems in less than 6 seconds each" Message:@"You completed 190 addition problems in less than 6 seconds each!"],
                       [[Achievement alloc] initWithName:@"Adding At 210 Miles Per Hour!" Description:@"Complete 210 addition problems in less than 6 seconds each" Message:@"You completed 210 addition problems in less than 6 seconds each!"],
                       [[Achievement alloc] initWithName:@"Adding At 230 Miles Per Hour!" Description:@"Complete 230 addition problems in less than 6 seconds each" Message:@"You completed 230 addition problems in less than 6 seconds each!"],
                       [[Achievement alloc] initWithName:@"Adding At 250 Miles Per Hour!" Description:@"Complete 250 addition problems in less than 6 seconds each" Message:@"You completed 250 addition problems in less than 6 seconds each!"]],
                     
                     @[[[Achievement alloc] initWithName:@"Take It Away!" Description:@"Complete 1 subtraction problem" Message:@"You completed your first subtraction problem!"],
                       [[Achievement alloc] initWithName:@"Take It Away x20!" Description:@"Complete 20 subtraction problems" Message:@"You completed 20 subtraction problems!"],
                       [[Achievement alloc] initWithName:@"Take It Away x40!" Description:@"Complete 40 subtraction problems" Message:@"You completed 40 subtraction problems!"],
                       [[Achievement alloc] initWithName:@"Take It Away x60!" Description:@"Complete 60 subtraction problems" Message:@"You completed 60 subtraction problems!"],
                       [[Achievement alloc] initWithName:@"Take It Away x80!" Description:@"Complete 80 subtraction problems" Message:@"You completed 80 subtraction problems!"],
                       [[Achievement alloc] initWithName:@"Take It Away x100!" Description:@"Complete 100 subtraction problems" Message:@"You completed 100 subtraction problems!"],
                       [[Achievement alloc] initWithName:@"Take It Away x120!" Description:@"Complete 120 subtraction problems" Message:@"You completed 120 subtraction problems!"],
                       [[Achievement alloc] initWithName:@"Take It Away x140!" Description:@"Complete 140 subtraction problems" Message:@"You completed 140 subtraction problems!"],
                       [[Achievement alloc] initWithName:@"Take It Away x160!" Description:@"Complete 160 subtraction problems" Message:@"You completed 160 subtraction problems!"],
                       [[Achievement alloc] initWithName:@"Take It Away x180!" Description:@"Complete 180 subtraction problems" Message:@"You completed 180 subtraction problems!"],
                       [[Achievement alloc] initWithName:@"Take It Away x200!" Description:@"Complete 200 subtraction problems" Message:@"You completed 200 subtraction problems!"],
                       [[Achievement alloc] initWithName:@"Take It Away x225!" Description:@"Complete 225 subtraction problems" Message:@"You completed 225 subtraction problems!"],
                       [[Achievement alloc] initWithName:@"Take It Away x250!" Description:@"Complete 250 subtraction problems" Message:@"You completed 250 subtraction problems!"],
                       [[Achievement alloc] initWithName:@"Take It Away x275!" Description:@"Complete 275 subtraction problems" Message:@"You completed 275 subtraction problems!"],
                       [[Achievement alloc] initWithName:@"Take It Away x300!" Description:@"Complete 300 subtraction problems" Message:@"You completed 300 subtraction problems!"]],
                     
                     @[[[Achievement alloc] initWithName:@"Subtracting At 15 \nMiles Per Hour!" Description:@"Complete 15 subtraction problems in less than 6 seconds each" Message:@"You completed 15 subtraction problems in less than 6 seconds each!"],
                       [[Achievement alloc] initWithName:@"Subtracting At 30 \nMiles Per Hour!" Description:@"Complete 30 subtraction problems in less than 6 seconds each" Message:@"You completed 30 subtraction problems in less than 6 seconds each!"],
                       [[Achievement alloc] initWithName:@"Subtracting At 45 \nMiles Per Hour!" Description:@"Complete 45 subtraction problems in less than 6 seconds each" Message:@"You completed 45 subtraction problems in less than 6 seconds each!"],
                       [[Achievement alloc] initWithName:@"Subtracting At 60 \nMiles Per Hour!" Description:@"Complete 60 subtraction problems in less than 6 seconds each" Message:@"You completed 60 subtraction problems in less than 6 seconds each!"],
                       [[Achievement alloc] initWithName:@"Subtracting At 75 \nMiles Per Hour!" Description:@"Complete 75 subtraction problems in less than 6 seconds each" Message:@"You completed 75 subtraction problems in less than 6 seconds each!"],
                       [[Achievement alloc] initWithName:@"Subtracting At 90 \nMiles Per Hour!" Description:@"Complete 90 subtraction problems in less than 6 seconds each" Message:@"You completed 90 subtraction problems in less than 6 seconds each!"],
                       [[Achievement alloc] initWithName:@"Subtracting At 105 \nMiles Per Hour!" Description:@"Complete 105 subtraction problems in less than 6 seconds each" Message:@"You completed 105 subtraction problems in less than 6 seconds each!"],
                       [[Achievement alloc] initWithName:@"Subtracting At 120 \nMiles Per Hour!" Description:@"Complete 120 subtraction problems in less than 6 seconds each" Message:@"You completed 120 subtraction problems in less than 6 seconds each!"],
                       [[Achievement alloc] initWithName:@"Subtracting At 135 \nMiles Per Hour!" Description:@"Complete 135 subtraction problems in less than 6 seconds each" Message:@"You completed 135 subtraction problems in less than 6 seconds each!"],
                       [[Achievement alloc] initWithName:@"Subtracting At 150 \nMiles Per Hour!" Description:@"Complete 150 subtraction problems in less than 6 seconds each" Message:@"You completed 150 subtraction problems in less than 6 seconds each!"],
                       [[Achievement alloc] initWithName:@"Subtracting At 170 \nMiles Per Hour!" Description:@"Complete 170 subtraction problems in less than 6 seconds each" Message:@"You completed 170 subtraction problems in less than 6 seconds each!"],
                       [[Achievement alloc] initWithName:@"Subtracting At 190 \nMiles Per Hour!" Description:@"Complete 190 subtraction problems in less than 6 seconds each" Message:@"You completed 190 subtraction problems in less than 6 seconds each!"],
                       [[Achievement alloc] initWithName:@"Subtracting At 210 \nMiles Per Hour!" Description:@"Complete 210 subtraction problems in less than 6 seconds each" Message:@"You completed 210 subtraction problems in less than 6 seconds each!"],
                       [[Achievement alloc] initWithName:@"Subtracting At 230 \nMiles Per Hour!" Description:@"Complete 230 subtraction problems in less than 6 seconds each" Message:@"You completed 230 subtraction problems in less than 6 seconds each!"],
                       [[Achievement alloc] initWithName:@"Subtracting At 250 \nMiles Per Hour!" Description:@"Complete 250 subtraction problems in less than 6 seconds each" Message:@"You completed 250 subtraction problems in less than 6 seconds each!"]],
                     
                     @[[[Achievement alloc] initWithName:@"Keep It Up x100!" Description:@"Complete 100 total math problems" Message:@"You completed 100 total problems!"],
                       [[Achievement alloc] initWithName:@"Keep It Up x200!" Description:@"Complete 200 total math problems" Message:@"You completed 200 total problems!"],
                       [[Achievement alloc] initWithName:@"Keep It Up x300!" Description:@"Complete 300 total math problems" Message:@"You completed 300 total problems!"],
                       [[Achievement alloc] initWithName:@"Keep It Up x400!" Description:@"Complete 400 total math problems" Message:@"You completed 400 total problems!"],
                       [[Achievement alloc] initWithName:@"Keep It Up x500!" Description:@"Complete 500 total math problems" Message:@"You completed 500 total problems!"],
                       [[Achievement alloc] initWithName:@"Keep It Up x600!" Description:@"Complete 600 total math problems" Message:@"You completed 600 total problems!"],
                       [[Achievement alloc] initWithName:@"Keep It Up x700!" Description:@"Complete 700 total math problems" Message:@"You completed 700 total problems!"],
                       [[Achievement alloc] initWithName:@"Keep It Up x800!" Description:@"Complete 800 total math problems" Message:@"You completed 800 total problems!"],
                       [[Achievement alloc] initWithName:@"Keep It Up x900!" Description:@"Complete 900 total math problems" Message:@"You completed 900 total problems!"],
                       [[Achievement alloc] initWithName:@"Keep It Up x1000!" Description:@"Complete 1000 total math problems" Message:@"You completed 1000 total problems!"],
                       [[Achievement alloc] initWithName:@"Keep It Up x1100!" Description:@"Complete 1100 total math problems" Message:@"You completed 1100 total problems!"],
                       [[Achievement alloc] initWithName:@"Keep It Up x1200!" Description:@"Complete 1200 total math problems" Message:@"You completed 1200 total problems!"],
                       [[Achievement alloc] initWithName:@"Keep It Up x1300!" Description:@"Complete 1300 total math problems" Message:@"You completed 1300 total problems!"],
                       [[Achievement alloc] initWithName:@"Keep It Up x1400!" Description:@"Complete 1400 total math problems" Message:@"You completed 1400 total problems!"],
                     [[Achievement alloc] initWithName:@"Keep It Up x1500!" Description:@"Complete 1500 total math problems" Message:@"You completed 1500 total problems!"]]
                     ];
    
}

-(AchievementCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AchievementCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AchievementCell" forIndexPath:indexPath];
    
    cell.achievement = achievements[indexPath.section][indexPath.row];
    
    cell.imageView.image = [UIImage imageNamed:@"star.png"];
    if (cell.achievement.isAchieved == YES)
    {
        cell.imageView.alpha = 1.0;
    }
    else
    {
        cell.imageView.alpha = 0.5;
    }
    
    return cell;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return achievements.count;
}



-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [achievements[section] count];
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    AchievementCell *cell = (AchievementCell*)[collectionView cellForItemAtIndexPath:indexPath];
    
    cell.achievement = achievements[indexPath.section][indexPath.row];
    
    NSString *alertMessage;
    if (cell.achievement.isAchieved)
    {
        alertMessage = cell.achievement.message;
    }
    else
    {
        alertMessage = cell.achievement.description;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:cell.achievement.name message:alertMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    int totalForHeader;
    
    AchievementHeader *achievementHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"AchievementHeader" forIndexPath:indexPath];
    switch (indexPath.section)
    {
        case 0:
            totalForHeader = [userDefaults integerForKey:@"dailyMath"];
            achievementHeader.titleLabel.text = [NSString stringWithFormat:@"Daily Math - %i", totalForHeader];
            achievementHeader.titleLabel.font = [UIFont fontWithName:@"Miso-Bold" size:24];
            achievementHeader.backgroundColor = [UIColor colorWithRed:130.0/255.0 green:183.0/255.0 blue:53.0/255.0 alpha:1];
            break;
        case 1:
            totalForHeader = [userDefaults integerForKey:@"totalAdds"];
            achievementHeader.titleLabel.text = [NSString stringWithFormat:@"Addition - %i", totalForHeader];
             achievementHeader.titleLabel.font = [UIFont fontWithName:@"Miso-Bold" size:24];
            achievementHeader.backgroundColor = [UIColor colorWithRed:130.0/255.0 green:183.0/255.0 blue:53.0/255.0 alpha:1];
            break;
        case 2:
            totalForHeader = [userDefaults integerForKey:@"totalFastAdds"];
            achievementHeader.titleLabel.text = [NSString stringWithFormat:@"Speedy Addition - %i", totalForHeader];
             achievementHeader.titleLabel.font = [UIFont fontWithName:@"Miso-Bold" size:24];
            achievementHeader.backgroundColor = [UIColor colorWithRed:130.0/255.0 green:183.0/255.0 blue:53.0/255.0 alpha:1];
            break;
        case 3:
            totalForHeader = [userDefaults integerForKey:@"totalSubs"];
            achievementHeader.titleLabel.text = [NSString stringWithFormat:@"Subtraction - %i", totalForHeader];
             achievementHeader.titleLabel.font = [UIFont fontWithName:@"Miso-Bold" size:24];
            achievementHeader.backgroundColor = [UIColor colorWithRed:222.0/255.0 green:54.0/255.0 blue:64.0/255.0 alpha:1];
            break;
        case 4:
            totalForHeader = [userDefaults integerForKey:@"totalFastSubs"];
            achievementHeader.titleLabel.text = [NSString stringWithFormat:@"Speedy Subtraction - %i", totalForHeader];
             achievementHeader.titleLabel.font = [UIFont fontWithName:@"Miso-Bold" size:24];
            achievementHeader.backgroundColor = [UIColor colorWithRed:222.0/255.0 green:54.0/255.0 blue:64.0/255.0 alpha:1];
            break;
        case 5:
            totalForHeader = [userDefaults integerForKey:@"totalAdds"] + [userDefaults integerForKey:@"totalSubs"] + [userDefaults integerForKey:@"totalMults"] + [userDefaults integerForKey:@"totalDivides"];
            achievementHeader.titleLabel.text = [NSString stringWithFormat:@"Total Math Problems - %i", totalForHeader];
             achievementHeader.titleLabel.font = [UIFont fontWithName:@"Miso-Bold" size:24];
           achievementHeader.backgroundColor = [UIColor colorWithRed:222.0/255.0 green:54.0/255.0 blue:64.0/255.0 alpha:1];
            break;
            
        default:
            break;
    }
    
    return achievementHeader;
}

@end
