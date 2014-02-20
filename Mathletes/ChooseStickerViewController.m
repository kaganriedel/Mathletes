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
    NSUserDefaults *userDefaults;
    
    NSMutableArray *userStickers;
}

@end

@implementation ChooseStickerViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    userDefaults = [NSUserDefaults standardUserDefaults];
    
    userStickers = [NSMutableArray new];

    //check to see which stickers the user has collected and display the ones they have
    PFUser *user = [PFUser currentUser];
    if ([[user objectForKey:@"lionCount"] intValue] > 0)
    {
        [userStickers addObject:@"lion.png"];
    }
    if ([[user objectForKey:@"kittenCount"] intValue] > 0)
    {
        [userStickers addObject:@"kitten.png"];
    }
    if ([[user objectForKey:@"starCount"] intValue] > 0)
    {
        [userStickers addObject:@"star.png"];
    }
    if ([[user objectForKey:@"puppyCount"] intValue] > 0)
    {
        [userStickers addObject:@"puppy.png"];
    }
    if ([[user objectForKey:@"tigerCount"] intValue] > 0)
    {
        [userStickers addObject:@"tiger.png"];
    }
    if ([[user objectForKey:@"murrayCount"] intValue] > 0)
    {
        [userStickers addObject:@"murray.png"];
    }
    if ([[user objectForKey:@"bearCount"] intValue] > 0)
    {
        [userStickers addObject:@"bear.png"];
    }
    if ([[user objectForKey:@"pizzaCount"] intValue] > 0)
    {
        [userStickers addObject:@"pizza.png"];
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ChooseStickerCell *cell = (ChooseStickerCell*)[collectionView cellForItemAtIndexPath:indexPath];
    [userDefaults setObject:cell.imageName forKey:@"profileImage"];
    [userDefaults synchronize];
    [self.navigationController popViewControllerAnimated:YES];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ChooseStickerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ChooseStickerCell" forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:userStickers[indexPath.row]];
    cell.imageName = userStickers[indexPath.row];
    cell.imageView.layer.cornerRadius = 35.0;

    
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return userStickers.count;
}

@end
