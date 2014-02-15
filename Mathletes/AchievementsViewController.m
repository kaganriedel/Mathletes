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

    
    NSUserDefaults *userDefaults;
}

@end

@implementation AchievementsViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    userDefaults = [NSUserDefaults standardUserDefaults];
//    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:242.0/255.0 green:71.0/255.0 blue:80.0/255.0 alpha:1.0];
    
    [self loadAllAchievements];
    
}

-(void)loadAllAchievements
{
 
    achievements = @[
                     @[[[Achievement alloc] initWithName:@"Add It Up!" Description:@"Complete 1 addition problem" Message:@"You completed your first addition problem!"],
                       [[Achievement alloc] initWithName:@"Add It Up x20!" Description:@"Complete 20 addition problems" Message:@"You completed 20 addition problems!"],
                       [[Achievement alloc] initWithName:@"Add It Up x50!" Description:@"Complete 50 addition problems" Message:@"You completed 50 addition problems!"],
                       [[Achievement alloc] initWithName:@"Add It Up x100!" Description:@"Complete 100 addition problems" Message:@"You completed 100 addition problems!"],
                       [[Achievement alloc] initWithName:@"Add It Up x200!" Description:@"Complete 200 addition problems" Message:@"You completed 200 addition problems!"],
                       [[Achievement alloc] initWithName:@"Add It Up x300!" Description:@"Complete 300 addition problems" Message:@"You completed 300 addition problems!"],
                       [[Achievement alloc] initWithName:@"Add It Up x400!" Description:@"Complete 400 addition problems" Message:@"You completed 400 addition problems!"],
                       [[Achievement alloc] initWithName:@"Add It Up x500!" Description:@"Complete 500 addition problems" Message:@"You completed 500 addition problems!"],
                       [[Achievement alloc] initWithName:@"Add It Up x600!" Description:@"Complete 600 addition problems" Message:@"You completed 600 addition problems!"],
                       [[Achievement alloc] initWithName:@"Add It Up x700!" Description:@"Complete 700 addition problems" Message:@"You completed 700 addition problems!"],
                       [[Achievement alloc] initWithName:@"Add It Up x800!" Description:@"Complete 800 addition problems" Message:@"You completed 800 addition problems!"],
                       [[Achievement alloc] initWithName:@"Add It Up x900!" Description:@"Complete 900 addition problems" Message:@"You completed 900 addition problems!"],
                       [[Achievement alloc] initWithName:@"Add It Up x1000!" Description:@"Complete 1000 addition problems" Message:@"You completed 1000 addition problems!"],
                       [[Achievement alloc] initWithName:@"Add It Up x1100!" Description:@"Complete 1100 addition problems" Message:@"You completed 1100 addition problems!"],
                       [[Achievement alloc] initWithName:@"Add It Up x1200!" Description:@"Complete 1200 addition problems" Message:@"You completed 1200 addition problems!"]],
                     
                     @[[[Achievement alloc] initWithName:@"Adding At 25 Miles Per Hour!" Description:@"Complete 25 addition problems in less than 6 seconds" Message:@"You completed 25 addition problems in less than 6 seconds!"],
                       [[Achievement alloc] initWithName:@"Adding At 50 Miles Per Hour!" Description:@"Complete 50 addition problems in less than 6 seconds" Message:@"You completed 50 addition problems in less than 6 seconds!"],
                       [[Achievement alloc] initWithName:@"Adding At 100 Miles Per Hour!" Description:@"Complete 100 addition problems in less than 6 seconds" Message:@"You completed 100 addition problems in less than 6 seconds!"],
                       [[Achievement alloc] initWithName:@"Adding At 150 Miles Per Hour!" Description:@"Complete 150 addition problems in less than 6 seconds" Message:@"You completed 150 addition problems in less than 6 seconds!"],
                       [[Achievement alloc] initWithName:@"Adding At 200 Miles Per Hour!" Description:@"Complete 200 addition problems in less than 6 seconds" Message:@"You completed 200 addition problems in less than 6 seconds!"],
                       [[Achievement alloc] initWithName:@"Adding At 250 Miles Per Hour!" Description:@"Complete 250 addition problems in less than 6 seconds" Message:@"You completed 250 addition problems in less than 6 seconds!"],
                       [[Achievement alloc] initWithName:@"Adding At 300 Miles Per Hour!" Description:@"Complete 300 addition problems in less than 6 seconds" Message:@"You completed 300 addition problems in less than 6 seconds!"],
                       [[Achievement alloc] initWithName:@"Adding At 350 Miles Per Hour!" Description:@"Complete 350 addition problems in less than 6 seconds" Message:@"You completed 350 addition problems in less than 6 seconds!"],
                       [[Achievement alloc] initWithName:@"Adding At 400 Miles Per Hour!" Description:@"Complete 400 addition problems in less than 6 seconds" Message:@"You completed 400 addition problems in less than 6 seconds!"],
                       [[Achievement alloc] initWithName:@"Adding At 450 Miles Per Hour!" Description:@"Complete 450 addition problems in less than 6 seconds" Message:@"You completed 450 addition problems in less than 6 seconds!"],
                       [[Achievement alloc] initWithName:@"Adding At 500 Miles Per Hour!" Description:@"Complete 500 addition problems in less than 6 seconds" Message:@"You completed 500 addition problems in less than 6 seconds!"],
                       [[Achievement alloc] initWithName:@"Adding At 550 Miles Per Hour!" Description:@"Complete 550 addition problems in less than 6 seconds" Message:@"You completed 550 addition problems in less than 6 seconds!"],
                       [[Achievement alloc] initWithName:@"Adding At 600 Miles Per Hour!" Description:@"Complete 600 addition problems in less than 6 seconds" Message:@"You completed 600 addition problems in less than 6 seconds!"],
                       [[Achievement alloc] initWithName:@"Adding At 650 Miles Per Hour!" Description:@"Complete 650 addition problems in less than 6 seconds" Message:@"You completed 650 addition problems in less than 6 seconds!"],
                       [[Achievement alloc] initWithName:@"Adding At 700 Miles Per Hour!" Description:@"Complete 700 addition problems in less than 6 seconds" Message:@"You completed 700 addition problems in less than 6 seconds!"]],
                     
                     @[[[Achievement alloc] initWithName:@"Take It Away!" Description:@"Complete 1 subtraction problem" Message:@"You completed your first subtraction problem!"],
                       [[Achievement alloc] initWithName:@"Take It Away x20!" Description:@"Complete 20 subtraction problems" Message:@"You completed 20 subtraction problems!"],
                       [[Achievement alloc] initWithName:@"Take It Away x50!" Description:@"Complete 50 subtraction problems" Message:@"You completed 50 subtraction problems!"],
                       [[Achievement alloc] initWithName:@"Take It Away x100!" Description:@"Complete 100 subtraction problems" Message:@"You completed 100 subtraction problems!"],
                       [[Achievement alloc] initWithName:@"Take It Away x200!" Description:@"Complete 200 subtraction problems" Message:@"You completed 200 subtraction problems!"],
                       [[Achievement alloc] initWithName:@"Take It Away x300!" Description:@"Complete 300 subtraction problems" Message:@"You completed 300 subtraction problems!"],
                       [[Achievement alloc] initWithName:@"Take It Away x400!" Description:@"Complete 400 subtraction problems" Message:@"You completed 400 subtraction problems!"],
                       [[Achievement alloc] initWithName:@"Take It Away x500!" Description:@"Complete 500 subtraction problems" Message:@"You completed 500 subtraction problems!"],
                       [[Achievement alloc] initWithName:@"Take It Away x600!" Description:@"Complete 600 subtraction problems" Message:@"You completed 600 subtraction problems!"],
                       [[Achievement alloc] initWithName:@"Take It Away x700!" Description:@"Complete 700 subtraction problems" Message:@"You completed 700 subtraction problems!"],
                       [[Achievement alloc] initWithName:@"Take It Away x800!" Description:@"Complete 800 subtraction problems" Message:@"You completed 800 subtraction problems!"],
                       [[Achievement alloc] initWithName:@"Take It Away x900!" Description:@"Complete 900 subtraction problems" Message:@"You completed 900 subtraction problems!"],
                       [[Achievement alloc] initWithName:@"Take It Away x1000!" Description:@"Complete 1000 subtraction problems" Message:@"You completed 1000 subtraction problems!"],
                       [[Achievement alloc] initWithName:@"Take It Away x1100!" Description:@"Complete 1100 subtraction problems" Message:@"You completed 1100 subtraction problems!"],
                       [[Achievement alloc] initWithName:@"Take It Away x1200!" Description:@"Complete 1200 subtraction problems" Message:@"You completed 1200 subtraction problems!"]],
                     
                     @[[[Achievement alloc] initWithName:@"Subtracting At 25 \nMiles Per Hour!" Description:@"Complete 25 subtraction problems in less than 6 seconds" Message:@"You completed 25 subtraction problems in less than 6 seconds!"],
                       [[Achievement alloc] initWithName:@"Subtracting At 50 \nMiles Per Hour!" Description:@"Complete 50 subtraction problems in less than 6 seconds" Message:@"You completed 50 subtraction problems in less than 6 seconds!"],
                       [[Achievement alloc] initWithName:@"Subtracting At 100 \nMiles Per Hour!" Description:@"Complete 100 subtraction problems in less than 6 seconds" Message:@"You completed 100 subtraction problems in less than 6 seconds!"],
                       [[Achievement alloc] initWithName:@"Subtracting At 150 \nMiles Per Hour!" Description:@"Complete 150 subtraction problems in less than 6 seconds" Message:@"You completed 150 subtraction problems in less than 6 seconds!"],
                       [[Achievement alloc] initWithName:@"Subtracting At 200 \nMiles Per Hour!" Description:@"Complete 200 subtraction problems in less than 6 seconds" Message:@"You completed 200 subtraction problems in less than 6 seconds!"],
                       [[Achievement alloc] initWithName:@"Subtracting At 250 \nMiles Per Hour!" Description:@"Complete 250 subtraction problems in less than 6 seconds" Message:@"You completed 250 subtraction problems in less than 6 seconds!"],
                       [[Achievement alloc] initWithName:@"Subtracting At 300 \nMiles Per Hour!" Description:@"Complete 300 subtraction problems in less than 6 seconds" Message:@"You completed 300 subtraction problems in less than 6 seconds!"],
                       [[Achievement alloc] initWithName:@"Subtracting At 350 \nMiles Per Hour!" Description:@"Complete 350 subtraction problems in less than 6 seconds" Message:@"You completed 350 subtraction problems in less than 6 seconds!"],
                       [[Achievement alloc] initWithName:@"Subtracting At 400 \nMiles Per Hour!" Description:@"Complete 400 subtraction problems in less than 6 seconds" Message:@"You completed 400 subtraction problems in less than 6 seconds!"],
                       [[Achievement alloc] initWithName:@"Subtracting At 450 \nMiles Per Hour!" Description:@"Complete 450 subtraction problems in less than 6 seconds" Message:@"You completed 450 subtraction problems in less than 6 seconds!"],
                       [[Achievement alloc] initWithName:@"Subtracting At 500 \nMiles Per Hour!" Description:@"Complete 500 subtraction problems in less than 6 seconds" Message:@"You completed 500 subtraction problems in less than 6 seconds!"],
                       [[Achievement alloc] initWithName:@"Subtracting At 550 \nMiles Per Hour!" Description:@"Complete 550 subtraction problems in less than 6 seconds" Message:@"You completed 550 subtraction problems in less than 6 seconds!"],
                       [[Achievement alloc] initWithName:@"Subtracting At 600 \nMiles Per Hour!" Description:@"Complete 600 subtraction problems in less than 6 seconds" Message:@"You completed 600 subtraction problems in less than 6 seconds!"],
                       [[Achievement alloc] initWithName:@"Subtracting At 650 \nMiles Per Hour!" Description:@"Complete 650 subtraction problems in less than 6 seconds" Message:@"You completed 650 subtraction problems in less than 6 seconds!"],
                       [[Achievement alloc] initWithName:@"Subtracting At 700 \nMiles Per Hour!" Description:@"Complete 700 subtraction problems in less than 6 seconds" Message:@"You completed 700 subtraction problems in less than 6 seconds!"]],
                     
                     @[[[Achievement alloc] initWithName:@"Keep It Up!" Description:@"Complete 10 total math problems" Message:@"You completed 10 total problems!"],
                       [[Achievement alloc] initWithName:@"Keep It Up x100!" Description:@"Complete 100 total math problems" Message:@"You completed 100 total problems!"],
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
                       [[Achievement alloc] initWithName:@"Keep It Up x1400!" Description:@"Complete 1400 total math problems" Message:@"You completed 1400 total problems!"]]
                     ];
    
}

-(AchievementCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AchievementCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AchievementCell" forIndexPath:indexPath];
    
    cell.achievement = achievements[indexPath.section][indexPath.row];
    
    cell.imageView.image = [UIImage imageNamed:@"Star.png"];
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
    AchievementCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    
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
    AchievementHeader *achievementHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"AchievementHeader" forIndexPath:indexPath];
    switch (indexPath.section)
    {
        case 0:
            achievementHeader.titleLabel.text = @"Addition";
            break;
        case 1:
            achievementHeader.titleLabel.text = @"Speedy Addition";
            break;
        case 2:
            achievementHeader.titleLabel.text = @"Subtraction";
            break;
        case 3:
            achievementHeader.titleLabel.text = @"Speedy Subtraction";
            break;
        case 4:
            achievementHeader.titleLabel.text = @"Total Math Problems";
            break;
            
        default:
            break;
    }
    
    return achievementHeader;
}

@end
