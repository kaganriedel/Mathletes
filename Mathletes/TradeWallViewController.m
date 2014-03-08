//
//  TradeWallViewController.m
//  ;
//
//  Created by MobileMath.co on 2/7/14.
//  Copyright (c) 2014 MobileMath.co. All rights reserved.
//

#import "TradeWallViewController.h"
#import "TradeWallCell.h"
#import "Parse/Parse.h"

@interface TradeWallViewController () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
{
    __weak IBOutlet UITableView *tradeTableView;
    __weak IBOutlet UISegmentedControl *tradeSegmentedControl;

    NSMutableArray *trades;
    NSTimer *timer;
    PFUser *user;
}

@end

@implementation TradeWallViewController


-(void)viewDidLoad
{
    [super viewDidLoad];

    user = [PFUser currentUser];
    
    tradeTableView.separatorColor = [UIColor lightGrayColor];    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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

- (IBAction)unwindFromMakeTradeViewController:(UIStoryboardSegue *)unwindSegue
{
    if ([unwindSegue.identifier isEqualToString:@"unwindToTradeWall"])
    {
        tradeSegmentedControl.selectedSegmentIndex = 1;
        [self reloadTrades];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TradeWallCell *cell = (TradeWallCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    PFUser *tradeUser = [cell.trade objectForKey:@"user"];
    if ([tradeUser.objectId isEqualToString:[PFUser currentUser].objectId])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cancel Trade?" message:@"Do you want to cancel this trade?" delegate:self cancelButtonTitle:@"No Thanks" otherButtonTitles:@"Yes, Cancel It", nil];
        alert.tag = 0;
        [alert show];
    }
    else
    {
        NSString *getUnderscoreRemovedString = [[cell.trade objectForKey:@"get"] stringByReplacingOccurrencesOfString:@"_" withString:@" "];
        NSString *giveUnderscoreRemovedString = [[cell.trade objectForKey:@"give"] stringByReplacingOccurrencesOfString:@"_" withString:@" "];
        NSNumber *giveCount = [cell.trade objectForKey:@"giveCount"] ?: @1;
        NSNumber *getCount = [cell.trade objectForKey:@"getCount"] ?: @1;
        NSString *givePlural = @"";
        NSString *getPlural = @"";
        if (giveCount.intValue > 1)
        {
            givePlural = @"s";
        }
        if (getCount.intValue > 1)
        {
            getPlural = @"s";
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Trade" message:[NSString stringWithFormat:@"Do you want to accept this trade?\nGive %@ %@ sticker%@.\nGet %@ %@ sticker%@.", getCount, getUnderscoreRemovedString, getPlural, giveCount, giveUnderscoreRemovedString, givePlural] delegate:self cancelButtonTitle:@"No Thanks" otherButtonTitles:@"Accept Trade", nil];
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
            [trades removeObjectAtIndex:selectedIndexPath.row];
            [tradeTableView deleteRowsAtIndexPaths:@[selectedIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
            NSNumber *count = [trade objectForKey:@"giveCount"] ?: @1;
            for (int x = 0; x < count.intValue; x++)
            {
                [user increaseKey:[NSString stringWithFormat:@"%@Count", [trade objectForKey:@"give"]]];
            }
            [trade deleteInBackground];
            [user saveInBackground];
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
            NSNumber *getCount = [trade objectForKey:@"getCount"] ?: @1;
            if([[user objectForKey:[NSString stringWithFormat:@"%@Count", [trade objectForKey:@"get"]]] intValue] < getCount.intValue)
            {
                NSString *underscoreRemovedString = [[trade objectForKey:@"get"] stringByReplacingOccurrencesOfString:@"_" withString:@" "];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry!" message:[NSString stringWithFormat:@"Sorry! You don't have enough %@ stickers to trade.", underscoreRemovedString] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
                [tradeTableView deselectRowAtIndexPath:[tradeTableView indexPathForSelectedRow] animated:YES];
            }
            else
            {
                PFObject *acceptedTrade = [PFObject objectWithClassName:@"AcceptedTrade"];
                [acceptedTrade setObject:[cell.trade objectForKey:@"user"] forKey:@"user"];
                [acceptedTrade setObject:[trade objectForKey:@"get"] forKey:@"get"];
                [acceptedTrade setObject:getCount forKey:@"getCount"];
                [acceptedTrade saveInBackground];
                
                [trades removeObjectAtIndex:selectedIndexPath.row];
                [tradeTableView deleteRowsAtIndexPaths:@[selectedIndexPath] withRowAnimation:UITableViewRowAnimationLeft];

                NSNumber *giveCount = [trade objectForKey:@"giveCount"] ?: @1;
                for (int x = 0; x < giveCount.intValue; x++)
                {
                    [user increaseKey:[NSString stringWithFormat:@"%@Count", [trade objectForKey:@"give"]]];
                }
                for (int x = 0; x < getCount.intValue; x++)
                {
                    [user decrementKey:[NSString stringWithFormat:@"%@Count", [trade objectForKey:@"get"]]];
                }
                [user saveInBackground];
                [trade deleteInBackground];
            }
        }
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TradeWallCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TradeCell"];
    
    cell.trade = trades[indexPath.row];
    cell.giveLabel.font = [UIFont fontWithName:@"Miso-Bold" size:34.0f];
    cell.giveLabel.textColor = [UIColor darkGrayColor];
    cell.getLabel.font = [UIFont fontWithName:@"Miso-Bold" size:34.0f];
    cell.getLabel.textColor = [UIColor darkGrayColor];
    
    
    //the order of "give" and "get" are reversed here because what someone offers to "give/get" is the opposite of what the other person accepts to "give/get"

    
    if (tradeSegmentedControl.selectedSegmentIndex == 1)
    {
        cell.giveImageView.image = [UIImage imageNamed:[[cell.trade objectForKey:@"give"] stringByAppendingString:@".png"]];
        cell.giveLabel.text = [NSString stringWithFormat:@"GIVE %@", [cell.trade objectForKey:@"giveCount"] ?: @1];
        
        cell.getImageView.image = [UIImage imageNamed:[[cell.trade objectForKey:@"get"] stringByAppendingString:@".png"]];
        cell.getLabel.text = [NSString stringWithFormat:@"GET %@", [cell.trade objectForKey:@"getCount"] ?: @1];
    }
    else
    {
        cell.giveImageView.image = [UIImage imageNamed:[[cell.trade objectForKey:@"get"] stringByAppendingString:@".png"]];
        cell.giveLabel.text = [NSString stringWithFormat:@"GIVE %@", [cell.trade objectForKey:@"getCount"] ?: @1];
        
        cell.getImageView.image = [UIImage imageNamed:[[cell.trade objectForKey:@"give"] stringByAppendingString:@".png"]];
        cell.getLabel.text = [NSString stringWithFormat:@"GET %@", [cell.trade objectForKey:@"giveCount"] ?: @1];
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
        [trades removeObjectAtIndex:indexPath.row];
        [tradeTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        NSNumber *count = [trade objectForKey:@"giveCount"] ?: @1;
        for (int x = 0; x < count.intValue; x++)
        {
            [user increaseKey:[NSString stringWithFormat:@"%@Count", [trade objectForKey:@"give"]]];
        }
        [trade deleteInBackground];
        [user saveInBackground];
    }
}

@end
