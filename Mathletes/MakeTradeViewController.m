//
//  TradeViewController.m
//  Mathletes
//
//  Created by Kagan Riedel on 2/17/14.
//  Copyright (c) 2014 Kagan Riedel. All rights reserved.
//

#import "MakeTradeViewController.h"
#import "MakeTradeCell.h"

@interface MakeTradeViewController () <UITableViewDelegate, UITableViewDataSource>
{
    NSUserDefaults *userDefaults;
    
    NSMutableArray *userStickers;
}

@end

@implementation MakeTradeViewController



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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tableView)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GiveCell"];
        cell.imageView.image = [UIImage imageNamed:userStickers[indexPath.row]];
        cell.imageView.clipsToBounds = YES;
        cell.imageView.layer.cornerRadius = 20.0;
        
        return cell;
    }
    else if (tableView == tableView)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GetCell"];
        cell.imageView.image = [UIImage imageNamed:userStickers[indexPath.row]];
        cell.imageView.clipsToBounds = YES;
        cell.imageView.layer.cornerRadius = 20.0;
        
        return cell;
    }
    
    return nil;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}


@end
