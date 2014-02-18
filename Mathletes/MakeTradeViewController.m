//
//  TradeViewController.m
//  Mathletes
//
//  Created by Kagan Riedel on 2/17/14.
//  Copyright (c) 2014 Kagan Riedel. All rights reserved.
//

#import "MakeTradeViewController.h"
#import "MakeTradeCell.h"
#import "Parse/Parse.h"

@interface MakeTradeViewController () <UITableViewDelegate, UITableViewDataSource>
{
    NSUserDefaults *userDefaults;
    
    NSMutableArray *userStickers;
    NSArray *allStickers;
    
    NSIndexPath *giveTableCheckedIndexPath;
    NSIndexPath *getTableCheckedIndexPath;

    
    __weak IBOutlet UITableView *giveTableView;
    __weak IBOutlet UITableView *getTableView;
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
    if ([userDefaults integerForKey:@"moonCount"] > 0)
    {
        [userStickers addObject:@"murray.png"];
    }
    if ([userDefaults integerForKey:@"giraffeCount"] > 0)
    {
        [userStickers addObject:@"bear.png"];
    }
    if ([userDefaults integerForKey:@"sunCount"] > 0)
    {
        [userStickers addObject:@"pizza.png"];
    }


    
    allStickers = @[@"lion.png", @"kitten.png", @"star.png", @"puppy.png", @"tiger.png", @"murray.png", @"bear.png", @"pizza.png"];

}

- (IBAction)onDoneButtonPressed:(id)sender
{
    if (getTableCheckedIndexPath && giveTableCheckedIndexPath)
    {
        MakeTradeCell *giveCell = (MakeTradeCell*)[giveTableView cellForRowAtIndexPath:giveTableCheckedIndexPath];
        MakeTradeCell *getCell = (MakeTradeCell*)[getTableView cellForRowAtIndexPath:getTableCheckedIndexPath];
        NSDictionary *dictionary = @{@"give": giveCell.sticker, @"get": getCell.sticker};
        PFObject *trade = [PFObject objectWithClassName:@"Trade" dictionary:dictionary];
        [trade saveInBackground];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Make sure to pick 1 sticker to trade and 1 sticker to get." delegate:nil cancelButtonTitle:@"OK!" otherButtonTitles: nil];
        [alert show];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == giveTableView)
    {
        if (giveTableCheckedIndexPath)
        {
            UITableViewCell* uncheckCell = [tableView cellForRowAtIndexPath:giveTableCheckedIndexPath];
            uncheckCell.accessoryType = UITableViewCellAccessoryNone;
        }
        if([giveTableCheckedIndexPath isEqual:indexPath])
        {
            giveTableCheckedIndexPath = nil;
        }
        else
        {
            UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            giveTableCheckedIndexPath = indexPath;
        }
    }
    else if (tableView == getTableView)
    {
        if (getTableCheckedIndexPath)
        {
            UITableViewCell* uncheckCell = [tableView cellForRowAtIndexPath:getTableCheckedIndexPath];
            uncheckCell.accessoryType = UITableViewCellAccessoryNone;
        }
        if([getTableCheckedIndexPath isEqual:indexPath])
        {
            getTableCheckedIndexPath = nil;
        }
        else
        {
            UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            getTableCheckedIndexPath = indexPath;
        }
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == giveTableView)
    {
        MakeTradeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GiveCell"];
        cell.stickerImageView.image = [UIImage imageNamed:userStickers[indexPath.row]];
        cell.stickerImageView.clipsToBounds = YES;
        cell.stickerImageView.layer.cornerRadius = 20.0;
        NSString *imageString = userStickers[indexPath.row];
        cell.sticker = [imageString stringByReplacingOccurrencesOfString:@".png" withString:@""];
        
        return cell;
    }
    else if (tableView == getTableView)
    {
        MakeTradeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GetCell"];
        cell.stickerImageView.image = [UIImage imageNamed:allStickers[indexPath.row]];
        cell.stickerImageView.clipsToBounds = YES;
        cell.stickerImageView.layer.cornerRadius = 20.0;
        NSString *imageString = allStickers[indexPath.row];
        cell.sticker = [imageString stringByReplacingOccurrencesOfString:@".png" withString:@""];
        
        return cell;
    }
    
    return nil;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == giveTableView)
    {
        return userStickers.count;
    }
    else
    {
        return allStickers.count;
    }
}


@end
