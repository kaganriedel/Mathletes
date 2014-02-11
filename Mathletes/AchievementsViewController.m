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

@interface AchievementsViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
{
    NSArray *achievements;
}

@end

@implementation AchievementsViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadAllAchievements];
}

-(void)loadAllAchievements
{
    achievements = @[[[Achievement alloc] initWithName:@"Added Up" Description:@"You completed your first addition problem!"],
                     [[Achievement alloc] initWithName:@"Subtracted" Description:@"You completed your first subtraction problem!"],
                     [[Achievement alloc] initWithName:@"5 Adds" Description:@"You completed 5 addition problems!"],
                     [[Achievement alloc] initWithName:@"5 Subtracts" Description:@"You completed 5 subtraction problems!"],
                     [[Achievement alloc] initWithName:@"Keep Going" Description:@"You completed 10 total problems!"]];
}

-(AchievementCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AchievementCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AchievementCell" forIndexPath:indexPath];
    
    cell.achievement = achievements[indexPath.row];
    cell.backgroundColor = [UIColor lightGrayColor];
    
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return achievements.count;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    AchievementCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:cell.achievement.name message:cell.achievement.description delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}



@end
