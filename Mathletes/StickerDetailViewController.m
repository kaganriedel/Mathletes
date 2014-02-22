//
//  StickerDetailViewController.m
//  Mathletes
//
//  Created by Kagan Riedel on 2/16/14.
//  Copyright (c) 2014 Kagan Riedel. All rights reserved.
//

#import "StickerDetailViewController.h"

@interface StickerDetailViewController ()
{
    __weak IBOutlet UIImageView *stickerImageView;
    __weak IBOutlet UILabel *countLabel;
    __weak IBOutlet UILabel *detailLabel;
    __weak IBOutlet UILabel *rarityLabel;
    __weak IBOutlet UILabel *stickerCountLabel;
}

@end

@implementation StickerDetailViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    stickerCountLabel.font = [UIFont fontWithName:@"Miso-Bold" size:30];
    countLabel.font = [UIFont fontWithName:@"Miso-Bold" size:30];
    rarityLabel.font = [UIFont fontWithName:@"Miso-Bold" size:36];
    detailLabel.font = [UIFont fontWithName:@"Miso-Bold" size:28];
    
    stickerImageView.image = [UIImage imageNamed:_stickerImageName];
    stickerImageView.layer.cornerRadius = 80.0;
    countLabel.text = [NSString stringWithFormat:@"%@", _count];
    
    NSString *stickerName = [_stickerImageName stringByReplacingOccurrencesOfString:@".png" withString:@""];
    
    NSString *cappedFirstChar = [[stickerName substringToIndex:1] uppercaseString];
    NSString *cappedString = [stickerName stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:cappedFirstChar];
    self.navigationItem.title = cappedString;
    
    
    NSString *common = @"COMMON";
    NSString *uncommon = @"UNCOMMON";
    NSString *rare = @"RARE";
    
    //Common stickers
    if ([stickerName isEqualToString:@"lion"])
    {
        rarityLabel.text = common;
        detailLabel.text = @"Lions are found in Africa. They lounge around being kings of all they see.";
    }
    else if ([stickerName isEqualToString:@"kitten"])
    {
        rarityLabel.text = common;
        detailLabel.text = @"Did you know?";
    }
    else if ([stickerName isEqualToString:@"campfire"])
    {
        rarityLabel.text = common;
        detailLabel.text = @"Did you know?";
    }
    
    //Uncommon stickers
    else if ([stickerName isEqualToString:@"puppy"])
    {
        rarityLabel.text = uncommon;
        detailLabel.text = @"Puppies are adorable. They cuddle, jump and play! Then they pee on your carpet.";
    }
    else if ([stickerName isEqualToString:@"tiger"])
    {
        rarityLabel.text = uncommon;
        detailLabel.text = @"Did you know?";
    }
    else if ([stickerName isEqualToString:@"murray"])
    {
        rarityLabel.text = uncommon;
        detailLabel.text = @"Did you know?";
    }
    
    //Rare stickers
    else if ([stickerName isEqualToString:@"bear"])
    {
        rarityLabel.text = rare;
        detailLabel.text = @"Did you know?";
    }
    else if ([stickerName isEqualToString:@"pizza"])
    {
        rarityLabel.text = rare;
        detailLabel.text = @"Delicious delicious pizza.";
    }


    
    
    
    
    [detailLabel sizeToFit];
    
}



@end
