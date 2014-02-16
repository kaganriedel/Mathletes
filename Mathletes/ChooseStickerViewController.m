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
    if ([userDefaults integerForKey:@"lionCount"] > 0)
    {
        [userStickers addObject:@"murray320x320.jpg"];
    }
    if ([userDefaults integerForKey:@"kittenCount"] > 0)
    {
        [userStickers addObject:@"puppy160x160.jpg"];
    }
    if ([userDefaults integerForKey:@"starCount"] > 0)
    {
        [userStickers addObject:@"kitten50x50.jpg"];
    }
    if ([userDefaults integerForKey:@"puppyCount"] > 0)
    {
        [userStickers addObject:@"ThumbsUpButton.png"];
    }
    if ([userDefaults integerForKey:@"tigerCount"] > 0)
    {
        [userStickers addObject:@"lion.jpg"];
    }
    if ([userDefaults integerForKey:@"moonCount"] > 0)
    {
        [userStickers addObject:@"bear.jpg"];
    }
    if ([userDefaults integerForKey:@"giraffeCount"] > 0)
    {
        [userStickers addObject:@"tiger.jpg"];
    }
    if ([userDefaults integerForKey:@"sunCount"] > 0)
    {
        [userStickers addObject:@"Star.png"];
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ChooseStickerCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    [userDefaults setObject:cell.imageName forKey:@"profileImage"];
    [userDefaults synchronize];
    [self.navigationController popViewControllerAnimated:YES];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ChooseStickerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ChooseStickerCell" forIndexPath:indexPath];
    cell.layer.cornerRadius = 37.0;
    cell.imageView.image = [UIImage imageNamed:userStickers[indexPath.row]];
    cell.imageName = userStickers[indexPath.row];
    
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return userStickers.count;
}

@end
