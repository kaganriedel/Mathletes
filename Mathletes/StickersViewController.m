//
//  StickersViewController.m
//  Mathletes
//
//  Created by Kagan Riedel on 2/10/14.
//  Copyright (c) 2014 Kagan Riedel. All rights reserved.
//

#import "StickersViewController.h"
#import "StickerCell.h"
#import "StickerDetailViewController.h"
#import "Parse/Parse.h"

@interface StickersViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

{
    __weak IBOutlet UICollectionView *stickerCollectionView;
    NSArray *stickers;
    NSArray *userStickers;
    UIView *stickerDetailView;
}

@end


@implementation StickersViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    
    stickers = @[@"lion.png",@"kitten.png",@"campfire.png", @"puppy.png", @"tiger.png", @"murray.png", @"bear.png", @"pizza.png"];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    PFUser *user = [PFUser currentUser];
    
    userStickers = @[[user objectForKey:@"lionCount"]?:@(0),
                     [user objectForKey:@"kittenCount"]?:@(0),
                     [user objectForKey:@"campfireCount"]?:@(0),
                     [user objectForKey:@"puppyCount"]?:@(0),
                     [user objectForKey:@"tigerCount"]?:@(0),
                     [user objectForKey:@"murrayCount"]?:@(0),
                     [user objectForKey:@"bearCount"]?:@(0),
                     [user objectForKey:@"pizzaCount"]?:@(0)
                     ];
    
    
    [stickerCollectionView reloadData];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [stickerDetailView removeFromSuperview];
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    StickerCell *cell = (StickerCell*)[stickerCollectionView cellForItemAtIndexPath:indexPath];
    NSString *stickerImageName = cell.stickerImageName;
    NSNumber *count = cell.count;
    
    stickerDetailView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 300, self.view.frame.size.height -20)];
    stickerDetailView.backgroundColor = [UIColor lightGrayColor];
    stickerDetailView.layer.cornerRadius = 10.0;
    stickerDetailView.layer.masksToBounds = YES;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 260, 30)];
    titleLabel.font = [UIFont fontWithName:@"Miso-Bold" size:30];
    titleLabel.textColor = [UIColor darkGrayColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    NSString *stickerName = [stickerImageName stringByReplacingOccurrencesOfString:@".png" withString:@""];
    NSString *cappedFirstChar = [[stickerName substringToIndex:1] uppercaseString];
    NSString *cappedString = [stickerName stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:cappedFirstChar];
    titleLabel.text = cappedString;
    
    UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 210, 120, 30)];
    countLabel.font = [UIFont fontWithName:@"Miso-Bold" size:30];
    countLabel.textColor = [UIColor darkGrayColor];
    countLabel.text = [NSString stringWithFormat:@"Count: %@", count];
    countLabel.textAlignment = NSTextAlignmentRight;
    
    UILabel *rarityLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 210, 120, 30)];
    rarityLabel.font = [UIFont fontWithName:@"Miso-Bold" size:30];
    
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 250, 280, stickerDetailView.frame.size.height - 250)];
    detailLabel.font = [UIFont fontWithName:@"Miso-Bold" size:28];
    detailLabel.textColor = [UIColor darkGrayColor];
    detailLabel.lineBreakMode = NSLineBreakByWordWrapping;
    detailLabel.numberOfLines = 0;
    
    UIImageView *stickerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(60, 40, 160, 160)];
    stickerImageView.layer.cornerRadius = 80.0;
    stickerImageView.layer.masksToBounds = YES;
    stickerImageView.image = [UIImage imageNamed: stickerImageName];
    
    UITapGestureRecognizer* tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    tapGestureRecognizer.numberOfTouchesRequired = 1;
    [stickerDetailView addGestureRecognizer: tapGestureRecognizer];

    
    
    NSString *common = @"COMMON";
    NSString *uncommon = @"UNCOMMON";
    NSString *rare = @"RARE";
    
    //Common stickers
    if ([stickerName isEqualToString:@"lion"])
    {
        rarityLabel.text = common;
        rarityLabel.textColor = [UIColor myBlueColor];
        detailLabel.text = @"Lions are found in Africa. They lounge around being kings of all they see.";
    }
    else if ([stickerName isEqualToString:@"kitten"])
    {
        rarityLabel.text = common;
        rarityLabel.textColor = [UIColor myBlueColor];
        detailLabel.text = @"Did you know?";
    }
    else if ([stickerName isEqualToString:@"campfire"])
    {
        rarityLabel.text = common;
        rarityLabel.textColor = [UIColor myBlueColor];
        detailLabel.text = @"Did you know?";
    }
    
    //Uncommon stickers
    else if ([stickerName isEqualToString:@"puppy"])
    {
        rarityLabel.text = uncommon;
        rarityLabel.textColor = [UIColor myRedColor];
        detailLabel.text = @"Puppies are adorable. They cuddle, jump and play! Then they pee on your carpet.";
    }
    else if ([stickerName isEqualToString:@"tiger"])
    {
        rarityLabel.text = uncommon;
        rarityLabel.textColor = [UIColor myRedColor];
        detailLabel.text = @"Did you know?";
    }
    else if ([stickerName isEqualToString:@"murray"])
    {
        rarityLabel.text = uncommon;
        rarityLabel.textColor = [UIColor myRedColor];
        detailLabel.text = @"Did you know? Bill Murray knows.";
    }
    
    //Rare stickers
    else if ([stickerName isEqualToString:@"bear"])
    {
        rarityLabel.text = rare;
        rarityLabel.textColor = [UIColor myYellowColor];
        detailLabel.text = @"Did you know?";
    }
    else if ([stickerName isEqualToString:@"pizza"])
    {
        rarityLabel.text = rare;
        rarityLabel.textColor = [UIColor myYellowColor];
        detailLabel.text = @"Delicious delicious pizza.";
    }
    
    [detailLabel sizeToFit];

    [stickerDetailView addSubview:countLabel];
    [stickerDetailView addSubview:rarityLabel];
    [stickerDetailView addSubview:detailLabel];
    [stickerDetailView addSubview:stickerImageView];
    [stickerDetailView addSubview:titleLabel];
    [self.view addSubview:stickerDetailView];
}

-(IBAction)handleSingleTap:(id)sender
{
    [stickerDetailView removeFromSuperview];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"StickerSegue"])
    {
        NSIndexPath *indexPath = sender;
        StickerCell *cell = (StickerCell*)[stickerCollectionView cellForItemAtIndexPath:indexPath];
        
        StickerDetailViewController *vc = segue.destinationViewController;
        vc.stickerImageName = cell.stickerImageName;
        vc.count = cell.count;
    }
}

-(StickerCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    StickerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StickerCell" forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:stickers[indexPath.row]];
    cell.imageView.layer.cornerRadius = 34.0;
    cell.stickerImageName = stickers[indexPath.row];
    cell.countLabel.font = [UIFont fontWithName:@"Miso-Bold" size:14.0f];
    
    cell.count = userStickers[indexPath.row];
    if (cell.count.integerValue == 0)
    {
        cell.imageView.alpha = 0.2;
    }
    else
    {
        cell.imageView.alpha = 1.0;
    }
    
    cell.countLabel.text = [NSString stringWithFormat:@"x%@", cell.count];
    
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return stickers.count;
}

@end
