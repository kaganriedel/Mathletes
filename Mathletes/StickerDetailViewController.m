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
        self.navigationItem.title = @"Lion";
        rarityLabel.text = @"This sticker is hard to find!";
        detailLabel.text = @"Lions are found in Africa. They are badass and can run really fast MPH. They're really really cool.";
        [detailLabel sizeToFit];
    }
    
}



@end
