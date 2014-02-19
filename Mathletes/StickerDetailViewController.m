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
    
    NSString *stickerName = [_stickerImageName stringByReplacingOccurrencesOfString:@".png" withString:@""];
    
    NSString *cappedFirstChar = [[stickerName substringToIndex:1] uppercaseString];
    NSString *cappedString = [stickerName stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:cappedFirstChar];
    self.navigationItem.title = cappedString;
    
    if ([stickerName isEqualToString:@"lion"])
    {
        rarityLabel.text = @"This sticker is hard to find!";
        detailLabel.text = @"Lions are found in Africa. They are badass and can run really fast MPH. They're really really cool.";
    }
    else if ([stickerName isEqualToString:@"puppy"])
    {
        rarityLabel.text = @"This sticker is easy to find!";
        detailLabel.text = @"Puppies are totes adorbs. They cuddle at a rate of 50 cuddles per hour and can slobber all over your face faster than a humming bird flaps its wings!";
    }
//    else if ([stickerName isEqualToString:@"puppy"])
//    {
//        rarityLabel.text = @"This sticker is easy to find!";
//        detailLabel.text = @"Puppies are totes adorbs. They cuddle at a rate of 50 cuddles per hour and can slobber all over your face faster than a humming bird flaps its wings!";
//    }

    
    
    
    
    [detailLabel sizeToFit];
    
}



@end
