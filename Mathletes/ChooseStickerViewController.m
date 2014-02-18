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
        [userStickers addObject:@"lion.png"];
    }
    if ([userDefaults integerForKey:@"kittenCount"] > 0)
    {
        [userStickers addObject:@"kitten.png"];
    }
    if ([userDefaults integerForKey:@"starCount"] > 0)
    {
        [userStickers addObject:@"star.png"];
    }
    if ([userDefaults integerForKey:@"puppyCount"] > 0)
    {
        [userStickers addObject:@"puppy.png"];
    }
    if ([userDefaults integerForKey:@"tigerCount"] > 0)
    {
        [userStickers addObject:@"tiger.png"];
    }
    if ([userDefaults integerForKey:@"murrayCount"] > 0)
    {
        [userStickers addObject:@"murray.png"];
    }
    if ([userDefaults integerForKey:@"bearCount"] > 0)
    {
        [userStickers addObject:@"bear.png"];
    }
    if ([userDefaults integerForKey:@"pizzaCount"] > 0)
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
