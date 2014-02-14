//
//  StickersViewController.m
//  Mathletes
//
//  Created by Kagan Riedel on 2/10/14.
//  Copyright (c) 2014 Kagan Riedel. All rights reserved.
//

#import "StickersViewController.h"
#import "StickerCell.h"
#import "Parse/Parse.h"

@interface StickersViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

{
    __weak IBOutlet UICollectionView *stickerCollectionView;
    NSArray *stickers;
    NSArray *userStickers;
}

@end


@implementation StickersViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
//    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:250.0/255.0 green:228.0/255.0 blue:66.0/255.0 alpha:1.0];
    
    stickers = @[@"murray320x320.jpg",@"puppy160x160.jpg",@"kitten50x50.jpg", @"ThumbsUpButton.png", @"lion.jpg", @"bear.jpg", @"tiger.jpg", @"Star.png"];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    userStickers = @[@([userDefaults integerForKey:@"lionCount"]),
                     @([userDefaults integerForKey:@"kittenCount"]),
                     @([userDefaults integerForKey:@"starCount"]),
                     @([userDefaults integerForKey:@"puppyCount"]),
                     @([userDefaults integerForKey:@"tigerCount"]),
                     @([userDefaults integerForKey:@"moonCount"]),
                     @([userDefaults integerForKey:@"giraffeCount"]),
                     @([userDefaults integerForKey:@"sunCount"]),];
}



-(StickerCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    StickerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StickerCell" forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:stickers[indexPath.row]];
    cell.layer.cornerRadius = 37.5;
    
    NSNumber *stickerCount = userStickers[indexPath.row];
    if (stickerCount.integerValue == 0)
    {
        cell.imageView.alpha = 0.2;
    }
    
    cell.countLabel.text = [NSString stringWithFormat:@"x%@", stickerCount];
    
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return stickers.count;
}

@end
