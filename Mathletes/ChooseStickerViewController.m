//
//  ChooseStickerViewController.m
//  Mathletes
//
//  Created by Kagan Riedel on 2/16/14.
//  Copyright (c) 2014 Kagan Riedel. All rights reserved.
//

#import "ChooseStickerViewController.h"
#import "ChooseStickerCell.h"

@interface ChooseStickerViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
{
    PFUser *user;
    
    NSMutableArray *userStickers;
}

@end

@implementation ChooseStickerViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    user = [PFUser currentUser];
    
    userStickers = [NSMutableArray new];
    

    //check to see which stickers the user has collected and display the ones they have
    NSString *key = @"Mountain";
    if ([[user objectForKey: [NSString stringWithFormat:@"%@Count", key]] intValue] > 0)
    {
        [userStickers addObject:[NSString stringWithFormat:@"%@.png", key]];
    }
    key = @"Apple";
    if ([[user objectForKey: [NSString stringWithFormat:@"%@Count", key]] intValue] > 0)
    {
        [userStickers addObject:[NSString stringWithFormat:@"%@.png", key]];
    }
    key = @"Monkey";
    if ([[user objectForKey: [NSString stringWithFormat:@"%@Count", key]] intValue] > 0)
    {
        [userStickers addObject:[NSString stringWithFormat:@"%@.png", key]];
    }
    key = @"Puppy";
    if ([[user objectForKey: [NSString stringWithFormat:@"%@Count", key]] intValue] > 0)
    {
        [userStickers addObject:[NSString stringWithFormat:@"%@.png", key]];
    }
    key = @"Cookies";
    if ([[user objectForKey: [NSString stringWithFormat:@"%@Count", key]] intValue] > 0)
    {
        [userStickers addObject:[NSString stringWithFormat:@"%@.png", key]];
    }
    key = @"Palm_Tree";
    if ([[user objectForKey: [NSString stringWithFormat:@"%@Count", key]] intValue] > 0)
    {
        [userStickers addObject:[NSString stringWithFormat:@"%@.png", key]];
    }
    key = @"Rocket_Ship";
    if ([[user objectForKey: [NSString stringWithFormat:@"%@Count", key]] intValue] > 0)
    {
        [userStickers addObject:[NSString stringWithFormat:@"%@.png", key]];
    }
    key = @"Flower";
    if ([[user objectForKey: [NSString stringWithFormat:@"%@Count", key]] intValue] > 0)
    {
        [userStickers addObject:[NSString stringWithFormat:@"%@.png", key]];
    }
    key = @"Ice_Cream";
    if ([[user objectForKey: [NSString stringWithFormat:@"%@Count", key]] intValue] > 0)
    {
        [userStickers addObject:[NSString stringWithFormat:@"%@.png", key]];
    }
    key = @"Campfire";
    if ([[user objectForKey: [NSString stringWithFormat:@"%@Count", key]] intValue] > 0)
    {
        [userStickers addObject:[NSString stringWithFormat:@"%@.png", key]];
    }
    key = @"Murray";
    if ([[user objectForKey: [NSString stringWithFormat:@"%@Count", key]] intValue] > 0)
    {
        [userStickers addObject:[NSString stringWithFormat:@"%@.png", key]];
    }
    key = @"Watermelon";
    if ([[user objectForKey: [NSString stringWithFormat:@"%@Count", key]] intValue] > 0)
    {
        [userStickers addObject:[NSString stringWithFormat:@"%@.png", key]];
    }

}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ChooseStickerCell *cell = (ChooseStickerCell*)[collectionView cellForItemAtIndexPath:indexPath];
    [user setObject:cell.imageName forKey:@"profileImage"];
    [user saveInBackground];
    [self.navigationController popViewControllerAnimated:YES];
 
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ChooseStickerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ChooseStickerCell" forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:userStickers[indexPath.row]];
    cell.imageName = userStickers[indexPath.row];
    cell.imageView.layer.cornerRadius = 34.0;

    
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return userStickers.count;
}

@end
