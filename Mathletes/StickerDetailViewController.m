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
    __weak IBOutlet UILabel *locationLabel;
    __weak IBOutlet UILabel *countLabel;
    __weak IBOutlet UILabel *detailLabel;
    
}

@end

@implementation StickerDetailViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    stickerImageView.image = [UIImage imageNamed:_stickerImageName];
    stickerImageView.layer.cornerRadius = 80.0;
    countLabel.text = [NSString stringWithFormat:@"x%@", _count];
    
    NSString *stickerName = [[_stickerImageName stringByReplacingOccurrencesOfString:@".jpg" withString:@""]stringByReplacingOccurrencesOfString:@".png" withString:@""];
    if ([stickerName isEqualToString:@"lion"])
    {
        locationLabel.text = @"Lions live in Africa";
        detailLabel.text = @"Lions are badass and can run really fast MPH";
    }
    
}



@end
