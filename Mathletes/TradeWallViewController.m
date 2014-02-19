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
    __weak IBOutlet UITableView *tradeTableView;
    __weak IBOutlet UISegmentedControl *tradeSegmentedControl;

    NSUserDefaults *userDefaults;
    NSMutableArray *trades;
    NSTimer *timer;

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
    
    [self reloadTrades];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:15.0 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [timer invalidate];
}

-(void)timerFired
{
    [self reloadTrades];
}

-(void)reloadTrades
{
    PFQuery *query = [PFQuery queryWithClassName:@"Trade"];
    if (tradeSegmentedControl.selectedSegmentIndex == 1)
    {
        [query whereKey:@"user" equalTo:[PFUser currentUser]];
    }
    else
    {
        [query whereKey:@"user" notEqualTo:[PFUser currentUser]];
    }
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error)
        {
            trades = objects.mutableCopy;
            [tradeTableView reloadData];
        }
        if (error)
        {
            NSLog(@"Error: %@", error);
        }
    }];
}
- (IBAction)segmentChanged:(UISegmentedControl *)segmentedControl
{
    [self reloadTrades];
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
    if (alertView.tag == 0) //deleting a trade
    {
        if (buttonIndex == 0)
        {
            [tradeTableView deselectRowAtIndexPath:[tradeTableView indexPathForSelectedRow] animated:YES];
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
    if (alertView.tag == 1) //accepting a trade
    {
  
        if (buttonIndex == 0)
        {
            [tradeTableView deselectRowAtIndexPath:[tradeTableView indexPathForSelectedRow] animated:YES];
        }
        if (buttonIndex == 1)
        {
            NSIndexPath *selectedIndexPath = [tradeTableView indexPathForSelectedRow];
            TradeWallCell *cell = (TradeWallCell*)[tradeTableView cellForRowAtIndexPath:selectedIndexPath];
            PFObject *trade = cell.trade;
            if ([userDefaults integerForKey:[NSString stringWithFormat:@"%@Count", [trade objectForKey:@"get"]]] <= 0)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry!" message:[NSString stringWithFormat:@"Sorry! You don't have any %@ stickers to trade.", [trade objectForKey:@"get"]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
                [tradeTableView deselectRowAtIndexPath:[tradeTableView indexPathForSelectedRow] animated:YES];
            }
            else
            {
                [trade deleteEventually];
                [trades removeObjectAtIndex:selectedIndexPath.row];
                [tradeTableView deleteRowsAtIndexPaths:@[selectedIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
                [userDefaults incrementKey:[NSString stringWithFormat:@"%@Count", [trade objectForKey:@"give"]]];
                [userDefaults decrementKey:[NSString stringWithFormat:@"%@Count", [trade objectForKey:@"get"]]];
                [trade saveInBackground];
                
                //make the trade happen
            }
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
    
    if (tradeSegmentedControl.selectedSegmentIndex == 1)
    {
        cell.giveImageView.image = [UIImage imageNamed:[[cell.trade objectForKey:@"give"] stringByAppendingString:@".png"]];
        cell.getImageView.image = [UIImage imageNamed:[[cell.trade objectForKey:@"get"] stringByAppendingString:@".png"]];
    }
    else
    {
        cell.giveImageView.image = [UIImage imageNamed:[[cell.trade objectForKey:@"get"] stringByAppendingString:@".png"]];
        cell.getImageView.image = [UIImage imageNamed:[[cell.trade objectForKey:@"give"] stringByAppendingString:@".png"]];
    }
    cell.giveImageView.layer.cornerRadius = 35.0;

    cell.getImageView.layer.cornerRadius = 35.0;
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return trades.count;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tradeSegmentedControl.selectedSegmentIndex == 1) {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        TradeWallCell *cell = (TradeWallCell*)[tradeTableView cellForRowAtIndexPath:indexPath];
        PFObject *trade = cell.trade;
        [trade deleteEventually];
        [trades removeObjectAtIndex:indexPath.row];
        [tradeTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [userDefaults incrementKey:[NSString stringWithFormat:@"%@Count", [trade objectForKey:@"give"]]];
        [trade saveInBackground];
    }
}

@end
