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

@interface MakeTradeViewController () <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>
{
    PFUser *user;
    
    NSMutableArray *userStickers;
    NSArray *stickerArray;
    NSIndexPath *giveTableCheckedIndexPath;
    NSIndexPath *getTableCheckedIndexPath;

    
    __weak IBOutlet UITableView *giveTableView;
    __weak IBOutlet UITableView *getTableView;
    __weak IBOutlet UILabel *giveLabel;
    __weak IBOutlet UILabel *getLabel;
}

@end

@implementation MakeTradeViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    user = [PFUser currentUser];
    for (UILabel* label in self.view.subviews) {
        if([label isKindOfClass:[UILabel class]])
        {
            label.font = [UIFont fontWithName:@"Miso-Bold" size:36.0f];
        }
    }
    giveLabel.font = [UIFont fontWithName:@"Miso-Bold" size:36.0f];
    getLabel.font = [UIFont fontWithName:@"Miso-Bold" size:36.0f];
    
    
    userStickers = [NSMutableArray new];
    stickerArray = [NSArray stickerArray];

    //check to see which stickers the user has collected and display the ones they have
    for (NSString *key in stickerArray)
    {
        if ([[user objectForKey: [NSString stringWithFormat:@"%@Count", key]] intValue] > 0)
        {
            [userStickers addObject:[NSString stringWithFormat:@"%@.png", key]];
        }
    }
}



- (IBAction)onDoneButtonPressed:(id)sender
{
    if (getTableCheckedIndexPath && giveTableCheckedIndexPath)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Complete Trade" message:@"Are you sure you want to make this trade?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
        [alert show];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Make sure to pick 1 sticker to trade and 1 sticker to get." delegate:nil cancelButtonTitle:@"OK!" otherButtonTitles: nil];
        [alert show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        MakeTradeCell *giveCell = (MakeTradeCell*)[giveTableView cellForRowAtIndexPath:giveTableCheckedIndexPath];
        MakeTradeCell *getCell = (MakeTradeCell*)[getTableView cellForRowAtIndexPath:getTableCheckedIndexPath];
        NSDictionary *dictionary = @{@"give": giveCell.sticker, @"get": getCell.sticker, @"user": [PFUser currentUser]};
        PFObject *trade = [PFObject objectWithClassName:@"Trade" dictionary:dictionary];
        [trade saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded)
            {
                [user decrementKey:[NSString stringWithFormat:@"%@Count", giveCell.sticker]];
                [user saveInBackground];
            }
        }];
//        [self.navigationController popViewControllerAnimated:YES];
        [self performSegueWithIdentifier:@"unwindToTradeWall" sender:self];
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
        cell.stickerImageView.layer.cornerRadius = 35.0;
        NSString *imageString = userStickers[indexPath.row];
        cell.sticker = [imageString stringByReplacingOccurrencesOfString:@".png" withString:@""];
        
        return cell;
    }
    else if (tableView == getTableView)
    {
        MakeTradeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GetCell"];
        cell.stickerImageView.image = [UIImage imageNamed:stickerArray[indexPath.row]];
        cell.stickerImageView.clipsToBounds = YES;
        cell.stickerImageView.layer.cornerRadius = 35.0;
        NSString *imageString = stickerArray[indexPath.row];
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
        return stickerArray.count;
    }
}


@end
