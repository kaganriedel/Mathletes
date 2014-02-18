//
//  TradeWallViewController.m
//  Mathletes
//
//  Created by Kagan Riedel on 2/16/14.
//  Copyright (c) 2014 Kagan Riedel. All rights reserved.
//

#import "TradeWallViewController.h"
#import "TradeWallCell.h"
#import "Parse/Parse.h"

@interface TradeWallViewController () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
{
    NSUserDefaults *userDefaults;
    NSMutableArray *trades;
    __weak IBOutlet UITableView *tradeTableView;
}

@end

@implementation TradeWallViewController


-(void)viewDidLoad
{
    [super viewDidLoad];
    
    userDefaults = [NSUserDefaults standardUserDefaults];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Trade"];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        trades = objects.mutableCopy;
        [tradeTableView reloadData];
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TradeWallCell *cell = (TradeWallCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    PFUser *user = [cell.trade objectForKey:@"user"];
    if ([user.objectId isEqualToString:[PFUser currentUser].objectId])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cancel Trade?" message:@"Do you want to cancel this trade?" delegate:self cancelButtonTitle:@"No Thanks" otherButtonTitles:@"Yes, Cancel It", nil];
        alert.tag = 0;
        [alert show];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Trade" message:[NSString stringWithFormat:@"Do you want to accept this trade?\nGive 1 %@ sticker.\nGet 1 %@ sticker.", [cell.trade objectForKey:@"get"], [cell.trade objectForKey:@"give"]] delegate:self cancelButtonTitle:@"No Thanks" otherButtonTitles:@"Accept Trade", nil];
        alert.tag = 1;
        [alert show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 0)
    {
        if (buttonIndex == 0)
        {
            //deselect the tableviewcell
        }
        if (buttonIndex == 1)
        {
            NSIndexPath *selectedIndexPath = [tradeTableView indexPathForSelectedRow];
            TradeWallCell *cell = (TradeWallCell*)[tradeTableView cellForRowAtIndexPath:selectedIndexPath];
            PFObject *trade = cell.trade;
            [trade deleteEventually];
            [trades removeObjectAtIndex:selectedIndexPath.row];
            [tradeTableView deleteRowsAtIndexPaths:@[selectedIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
            [userDefaults incrementKey:[NSString stringWithFormat:@"%@Count", [trade objectForKey:@"give"]]];
            [trade saveInBackground];
        }
    }
    if (alertView.tag == 1)
    {
  
        if (buttonIndex == 0)
        {
            //deselect the tableviewcell
        }
        if (buttonIndex == 1)
        {
            NSIndexPath *selectedIndexPath = [tradeTableView indexPathForSelectedRow];
            TradeWallCell *cell = (TradeWallCell*)[tradeTableView cellForRowAtIndexPath:selectedIndexPath];
            PFObject *trade = cell.trade;
            [trade deleteEventually];
            [trades removeObjectAtIndex:selectedIndexPath.row];
            [tradeTableView deleteRowsAtIndexPaths:@[selectedIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
            [userDefaults incrementKey:[NSString stringWithFormat:@"%@Count", [trade objectForKey:@"get"]]];
            [trade saveInBackground];
            
            //make the trade happen
        }
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TradeWallCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TradeCell"];
    
    cell.trade = trades[indexPath.row];
    
    //the order of "give" and "get" are reversed here because what someone offers to "give/get" is the opposite of what the other person accepts to "give/get"
    PFUser *user = [cell.trade objectForKey:@"user"];
    if ([user.objectId isEqualToString:[PFUser currentUser].objectId])
    {
        cell.myTradeLabel.alpha = 1.0;
    }
    else
    {
        cell.myTradeLabel.alpha = 0.0;
    }
    
    cell.giveImageView.image = [UIImage imageNamed:[[cell.trade objectForKey:@"get"] stringByAppendingString:@".png"]];
    cell.giveImageView.layer.cornerRadius = 35.0;

    cell.getImageView.image = [UIImage imageNamed:[[cell.trade objectForKey:@"give"] stringByAppendingString:@".png"]];
    cell.getImageView.layer.cornerRadius = 35.0;
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return trades.count;
}


@end
