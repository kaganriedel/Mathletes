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
#import "CSAnimationView.h"

@interface StickersViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

{
    __weak IBOutlet UICollectionView *stickerCollectionView;
    NSArray *stickers;
    NSArray *userStickers;
    CSAnimationView *stickerDetailView;
    UILabel *stickerTitleLabel;
    UILabel *stickerCountLabel;
    UILabel *stickerRarityLabel;
    UILabel *stickerDetailLabel;
    UIImageView *stickerImageView;
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

    stickerDetailView = [[CSAnimationView alloc] initWithFrame:CGRectMake(10, 10, 300, self.view.frame.size.height - 20)];
    stickerDetailView.alpha = 0.0;
    stickerDetailView.delay = 0.1;
    stickerDetailView.duration = 0.5;
    stickerDetailView.backgroundColor = [UIColor whiteColor];
    stickerDetailView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    stickerDetailView.layer.borderWidth = 2.0;
    stickerDetailView.layer.cornerRadius = 10.0;
    stickerDetailView.layer.masksToBounds = YES;
    
    stickerTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 260, 30)];
    stickerTitleLabel.font = [UIFont fontWithName:@"Miso-Bold" size:30];
    stickerTitleLabel.textColor = [UIColor darkGrayColor];
    stickerTitleLabel.textAlignment = NSTextAlignmentCenter;
    
    stickerCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 210, 120, 30)];
    stickerCountLabel.font = [UIFont fontWithName:@"Miso-Bold" size:30];
    stickerCountLabel.textColor = [UIColor darkGrayColor];
    stickerCountLabel.textAlignment = NSTextAlignmentRight;
    
    stickerRarityLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 210, 120, 30)];
    stickerRarityLabel.font = [UIFont fontWithName:@"Miso-Bold" size:30];
    
    stickerDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 250, 280, stickerDetailView.frame.size.height - 250)];
    stickerDetailLabel.font = [UIFont fontWithName:@"Miso-Bold" size:28];
    stickerDetailLabel.textColor = [UIColor darkGrayColor];
    stickerDetailLabel.lineBreakMode = NSLineBreakByWordWrapping;
    stickerDetailLabel.numberOfLines = 0;
    
    stickerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(60, 40, 160, 160)];
    stickerImageView.layer.cornerRadius = 80.0;
    stickerImageView.layer.masksToBounds = YES;
    
    UITapGestureRecognizer* tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    tapGestureRecognizer.numberOfTouchesRequired = 1;
    [stickerDetailView addGestureRecognizer: tapGestureRecognizer];
    
    [stickerDetailView addSubview:stickerCountLabel];
    [stickerDetailView addSubview:stickerRarityLabel];
    [stickerDetailView addSubview:stickerDetailLabel];
    [stickerDetailView addSubview:stickerImageView];
    [stickerDetailView addSubview:stickerTitleLabel];
    [self.view addSubview:stickerDetailView];
    
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
    
    stickerDetailView.type = CSAnimationTypeZoomOut;
    
    NSString *stickerName = [stickerImageName stringByReplacingOccurrencesOfString:@".png" withString:@""];
    NSString *cappedFirstChar = [[stickerName substringToIndex:1] uppercaseString];
    NSString *cappedString = [stickerName stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:cappedFirstChar];
    stickerTitleLabel.text = cappedString;
    
    stickerCountLabel.text = [NSString stringWithFormat:@"Count: %@", count];
    
    stickerImageView.image = [UIImage imageNamed: stickerImageName];
    
    NSString *common = @"COMMON";
    NSString *uncommon = @"UNCOMMON";
    NSString *rare = @"RARE";
    
    //Common stickers
    if ([stickerName isEqualToString:@"lion"])
    {
        stickerRarityLabel.text = common;
        stickerRarityLabel.textColor = [UIColor myBlueColor];
        stickerDetailLabel.text = @"Lions are found in Africa. They lounge around being kings of all they see.";
    }
    else if ([stickerName isEqualToString:@"kitten"])
    {
        stickerRarityLabel.text = common;
        stickerRarityLabel.textColor = [UIColor myBlueColor];
        stickerDetailLabel.text = @"Did you know?";
    }
    else if ([stickerName isEqualToString:@"campfire"])
    {
        stickerRarityLabel.text = common;
        stickerRarityLabel.textColor = [UIColor myBlueColor];
        stickerDetailLabel.text = @"Did you know?";
    }
    
    //Uncommon stickers
    else if ([stickerName isEqualToString:@"puppy"])
    {
        stickerRarityLabel.text = uncommon;
        stickerRarityLabel.textColor = [UIColor myRedColor];
        stickerDetailLabel.text = @"Puppies are adorable. They cuddle, jump and play! Then they pee on your carpet.";
    }
    else if ([stickerName isEqualToString:@"tiger"])
    {
        stickerRarityLabel.text = uncommon;
        stickerRarityLabel.textColor = [UIColor myRedColor];
        stickerDetailLabel.text = @"Did you know?";
    }
    else if ([stickerName isEqualToString:@"murray"])
    {
        stickerRarityLabel.text = uncommon;
        stickerRarityLabel.textColor = [UIColor myRedColor];
        stickerDetailLabel.text = @"Did you know? Bill Murray knows.";
    }
    
    //Rare stickers
    else if ([stickerName isEqualToString:@"bear"])
    {
        stickerRarityLabel.text = rare;
        stickerRarityLabel.textColor = [UIColor myYellowColor];
        stickerDetailLabel.text = @"Did you know?";
    }
    else if ([stickerName isEqualToString:@"pizza"])
    {
        stickerRarityLabel.text = rare;
        stickerRarityLabel.textColor = [UIColor myYellowColor];
        stickerDetailLabel.text = @"Delicious delicious pizza.";
    }
    stickerDetailLabel.frame = CGRectMake(10, 250, 280, stickerDetailView.frame.size.height - 250);
    [stickerDetailLabel sizeToFit];

    
    
    [stickerDetailView startCanvasAnimation];
}

-(IBAction)handleSingleTap:(id)sender
{
    stickerDetailView.type = CSAnimationTypeZoomIn;
    [stickerDetailView startCanvasAnimation];
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
