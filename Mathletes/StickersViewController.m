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
#import "CSAnimationView.h"

@interface StickersViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

{
    __weak IBOutlet UICollectionView *stickerCollectionView;
    NSArray *stickerArray;
    CSAnimationView *stickerDetailView;
    UILabel *stickerTitleLabel;
    UILabel *stickerCountLabel;
    UILabel *stickerRarityLabel;
    UILabel *stickerDetailLabel;
    UIImageView *stickerImageView;
    
    PFUser *user;
}

@end


@implementation StickersViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    user = [PFUser currentUser];
    stickerArray = [NSArray stickerArray];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

    stickerDetailView = [[CSAnimationView alloc] initWithFrame:CGRectMake(10, 30, 300, self.view.frame.size.height + 24)];
    stickerDetailView.alpha = 0.0;
    stickerDetailView.delay = 0.0;
    stickerDetailView.duration = 0.5;
    stickerDetailView.backgroundColor = [UIColor whiteColor];
    stickerDetailView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    stickerDetailView.layer.borderWidth = 0.0;
    stickerDetailView.layer.cornerRadius = 10.0;
    stickerDetailView.layer.masksToBounds = YES;
    
    stickerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(70, 10, 160, 160)];
    stickerImageView.layer.cornerRadius = 80.0;
    stickerImageView.layer.masksToBounds = YES;
    
    stickerTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 170, 260, 40)];
    stickerTitleLabel.font = [UIFont fontWithName:@"Miso-Bold" size:36];
    stickerTitleLabel.textColor = [UIColor darkGrayColor];
    stickerTitleLabel.textAlignment = NSTextAlignmentCenter;
    
    UIView *underline = [[UIView alloc] initWithFrame:CGRectMake(15, 215, 270, 1)];
    underline.backgroundColor = [UIColor lightGrayColor];
    
    stickerCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(165, 225, 120, 30)];
    stickerCountLabel.font = [UIFont fontWithName:@"Miso-Bold" size:24];
    stickerCountLabel.textColor = [UIColor darkGrayColor];
    stickerCountLabel.textAlignment = NSTextAlignmentRight;
    
    stickerRarityLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 225, 120, 30)];
    stickerRarityLabel.font = [UIFont fontWithName:@"Miso-Bold" size:24];
    
    stickerDetailLabel = [UILabel new];
    stickerDetailLabel.font = [UIFont fontWithName:@"Miso-Bold" size:24];
    stickerDetailLabel.textColor = [UIColor darkGrayColor];
    stickerDetailLabel.lineBreakMode = NSLineBreakByWordWrapping;
    stickerDetailLabel.numberOfLines = 4;
    
    
    
    UITapGestureRecognizer* tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    tapGestureRecognizer.numberOfTouchesRequired = 1;
    [stickerDetailView addGestureRecognizer: tapGestureRecognizer];
    [stickerDetailView addSubview:underline];
    [stickerDetailView addSubview:stickerCountLabel];
    [stickerDetailView addSubview:stickerRarityLabel];
    [stickerDetailView addSubview:stickerDetailLabel];
    [stickerDetailView addSubview:stickerImageView];
    [stickerDetailView addSubview:stickerTitleLabel];
    [self.view addSubview:stickerDetailView];
    
    
    [stickerCollectionView reloadData];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [stickerDetailView removeFromSuperview];
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

        [self.navigationController setNavigationBarHidden:YES animated:YES];
        stickerCollectionView.backgroundColor = [UIColor darkGrayColor];

    
    StickerCell *cell = (StickerCell*)[stickerCollectionView cellForItemAtIndexPath:indexPath];
    NSString *stickerImageName = cell.stickerImageName;
    NSNumber *count = cell.count;
    
    stickerDetailView.type = CSAnimationTypeZoomOut;
    
    NSString *stickerName = [stickerImageName stringByReplacingOccurrencesOfString:@".png" withString:@""];
    NSString *titleString = [stickerName stringByReplacingOccurrencesOfString:@"_" withString:@" "];
    stickerTitleLabel.text = titleString;
    
    stickerCountLabel.text = [NSString stringWithFormat:@"Count: %@", count];
    
    stickerImageView.image = [UIImage imageNamed: stickerImageName];
    
    NSString *common = @"COMMON";
    NSString *uncommon = @"UNCOMMON";
    NSString *rare = @"RARE";
    
    //Common stickers
    if ([stickerName isEqualToString:@"Mountain"])
    {
        stickerRarityLabel.text = common;
        stickerDetailLabel.text = @"The tallest mountain is Mount Everest at over 29,000 feet! Did you know about one fifth of the world is covered in mountains?";
    }
    else if ([stickerName isEqualToString:@"Apple"])
    {
        stickerRarityLabel.text = common;
        stickerDetailLabel.text = @"There are more than 2,500 varieties of apples grown in America. It takes nearly 36 apples to make 1 gallon of apple cider!";
    }
    else if ([stickerName isEqualToString:@"Monkey"])
    {
        stickerRarityLabel.text = common;
        stickerDetailLabel.text = @"The smallest monkey weighs only 1/4 of a pound and the heaviest can weigh up to 80 pounds. Their tails can be as long as 3 feet!";
    }
    else if ([stickerName isEqualToString:@"Puppy"])
    {
        stickerRarityLabel.text = common;
        stickerDetailLabel.text = @"A puppy spends about 14 hours sleeping per day. Every year, more than 5 million puppies are born!";
    }
    else if ([stickerName isEqualToString:@"Cookies"])
    {
        stickerRarityLabel.text = common;
        stickerDetailLabel.text = @"Cookies were first invented more than 2,000 years ago. The average American eats 35,000 cookies in their lifetime!";
    }
    else if ([stickerName isEqualToString:@"Palm_Tree"])
    {
        stickerRarityLabel.text = common;
        stickerDetailLabel.text = @"There are nearly 3,000 different species of palm trees in the world. The tallest palm tree is almost 230 feet!";
    }
    else if ([stickerName isEqualToString:@"Rocket_Ship"])
    {
        stickerRarityLabel.text = common;
        stickerDetailLabel.text = @"Rockets travel at 17,500 miles per hour to lift off and they burn more than 500,000 gallons of fuel. Blast off!";
    }
    else if ([stickerName isEqualToString:@"Kitten"])
    {
        stickerRarityLabel.text = common;
        stickerDetailLabel.text = @"Did you know cats can jump five times their height? On average cats sleep 16 hours a day. Cat nap!";
    }
    else if ([stickerName isEqualToString:@"Fish"])
    {
        stickerRarityLabel.text = common;
        stickerDetailLabel.text = @"There are over 30,000 known types of fish. The fastest fish can swim at speeds of up to 68 mph!";
    }
    else if ([stickerName isEqualToString:@"Earth"])
    {
        stickerRarityLabel.text = common;
        stickerDetailLabel.text = @"About 70% of the Earth is covered in water! Did you know the Earth is about 4.54 billion years old?";
    }
    else if ([stickerName isEqualToString:@"Galaxy"])
    {
        stickerRarityLabel.text = common;
        stickerDetailLabel.text = @"A galaxy is a group of millions or billions of stars. The Earth is part of the galaxy called the Milky Way!";
    }
    else if ([stickerName isEqualToString:@"Train"])
    {
        stickerRarityLabel.text = common;
        stickerDetailLabel.text = @"Trains can carry big, heavy loads across long distances. The heaviest train in the world was heavier than 27,000 elephants!";
    }
    
    //Uncommon stickers
    else if ([stickerName isEqualToString:@"Flower"])
    {
        stickerRarityLabel.text = uncommon;
        stickerDetailLabel.text = @"There are 103 different varieties of flowers in America. The oldest flower discovered lived 125 million years ago!";
    }
    else if ([stickerName isEqualToString:@"Ice_Cream"])
    {
        stickerRarityLabel.text = uncommon;
        stickerDetailLabel.text = @"The ice cream cone was invented at the 1904 World Fair in St. Louis. Americans eat an average of 20 quarts a year!";
    }
    else if ([stickerName isEqualToString:@"Campfire"])
    {
        stickerRarityLabel.text = uncommon;
        stickerDetailLabel.text = @"Campfires can get as hot as 2,000 degrees! Did you know the hottest spot in the flame is blue?";
    }
    else if ([stickerName isEqualToString:@"Giraffe"])
    {
        stickerRarityLabel.text = uncommon;
        stickerDetailLabel.text = @"Giraffes are the tallest mammals on Earth. Their legs alone are taller than most people at 6 feet tall!";
    }
    else if ([stickerName isEqualToString:@"Comet"])
    {
        stickerRarityLabel.text = uncommon;
        stickerDetailLabel.text = @"Comets are sometimes called dirty snowballs because they are made of ice and water along with dust, rocks and gases!";
    }
    else if ([stickerName isEqualToString:@"Sports_Car"])
    {
        stickerRarityLabel.text = uncommon;
        stickerDetailLabel.text = @"The first car was invented in 1886 and could only go 10 miles per hour. Now, the fastest car can go 270 miles per hour!";
    }
    else if ([stickerName isEqualToString:@"School_Bus"])
    {
        stickerRarityLabel.text = uncommon;
        stickerDetailLabel.text = @"School buses can carry up to 60 kids to school! Did you know school busses are yellow because it is safer and easier to see them?";
    }
    else if ([stickerName isEqualToString:@"Pirate_Ship"])
    {
        stickerRarityLabel.text = uncommon;
        stickerDetailLabel.text = @"Pirate ship facts";
    }
    else if ([stickerName isEqualToString:@"Tent"])
    {
        stickerRarityLabel.text = uncommon;
        stickerDetailLabel.text = @"Tent facts";
    }
    
    //Rare stickers
    else if ([stickerName isEqualToString:@"Watermelon"])
    {
        stickerRarityLabel.text = rare;
        stickerDetailLabel.text = @"The average watermelon has 350 seeds and is 92% water. Some watermelons can weigh up to 90 pounds!";
    }
    else if ([stickerName isEqualToString:@"Helicopter"])
    {
        stickerRarityLabel.text = rare;
        stickerDetailLabel.text = @"Helicopters can fly in all directions and their blades can spin 500 times per minute!";
    }
    else if ([stickerName isEqualToString:@"Panda"])
    {
        stickerRarityLabel.text = rare;
        stickerDetailLabel.text = @"Panda facts";
    }
    
    //to be decided




   
    else if ([stickerName isEqualToString:@"Cherry"])
    {
        stickerRarityLabel.text = common;
        stickerDetailLabel.text = @"About 300 million pounds of cherries are produced each year! Did you know an average cherry tree holds enough cherries to make 28 cherry pies?";
    }
    else if ([stickerName isEqualToString:@"Pine_Tree"])
    {
        stickerRarityLabel.text = common;
        stickerDetailLabel.text = @"Some types of pine trees can reach over 250 feet in height. The oldest living pine tree is 4,840 years old!";
    }
    else if ([stickerName isEqualToString:@"Moon"])
    {
        stickerRarityLabel.text = common;
        stickerDetailLabel.text = @"No sound can be heard on the Moon, and the sky is always black there. Did you know the moon is about 27% the size of the Earth?";
    }
    else if ([stickerName isEqualToString:@"Motorcycle"])
    {
        stickerRarityLabel.text = common;
        stickerDetailLabel.text = @"Did you know up to 8 motorcycles can fit in a parking space for one car? The fastest motorcycle can go 250 miles per hour!";
    }
    
    
    stickerDetailLabel.frame = CGRectMake(15, 260, 270, stickerDetailView.frame.size.height - 235);
    [stickerDetailLabel sizeToFit];

    if ([stickerRarityLabel.text isEqualToString:common])
    {
        stickerRarityLabel.textColor = [UIColor myBlueColor];
    }
    else if ([stickerRarityLabel.text isEqualToString:uncommon])
    {
        stickerRarityLabel.textColor = [UIColor myRedColor];
    }
    else if ([stickerRarityLabel.text isEqualToString:rare])
    {
        stickerRarityLabel.textColor = [UIColor myYellowColor];

    }
    
    
    [stickerDetailView startCanvasAnimation];
}

-(IBAction)handleSingleTap:(id)sender
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    stickerCollectionView.backgroundColor = [UIColor whiteColor];
    
    stickerDetailView.type = CSAnimationTypeZoomIn;
    [stickerDetailView startCanvasAnimation];
}


-(StickerCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    StickerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StickerCell" forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:stickerArray[indexPath.row]];
    cell.imageView.layer.cornerRadius = 35.0;
    cell.stickerImageName = stickerArray[indexPath.row];
    cell.countLabel.font = [UIFont fontWithName:@"Miso-Bold" size:14.0f];
    
    cell.count = [user objectForKey:[NSString stringWithFormat:@"%@Count", stickerArray[indexPath.row]]] ?: @(0);
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
    return stickerArray.count;
}

@end
