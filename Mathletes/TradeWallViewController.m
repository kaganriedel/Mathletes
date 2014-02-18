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
    NSArray *trades;
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
        trades = objects;
        [tradeTableView reloadData];
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TradeWallCell *cell = (TradeWallCell*)[tableView cellForRowAtIndexPath:indexPath];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Trade" message:[NSString stringWithFormat:@"Do you want to accept this trade?\nGive 1 %@ sticker.\nGet 1 %@ sticker.", cell.give, cell.get] delegate:self cancelButtonTitle:@"No Thanks" otherButtonTitles:@"Accept Trade", nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        //make the trade happen
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TradeWallCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TradeCell"];
    
    PFObject *trade = trades[indexPath.row];
    
    //"give" and "get" are reversed here because what someone offers to "give/get" is the opposite of what the other person accepts to "give/get"
    NSString *giveString = [trade objectForKey:@"get"];
    cell.giveImageView.image = [UIImage imageNamed:[giveString stringByAppendingString:@".png"]];
    cell.giveImageView.layer.cornerRadius = 35.0;
    cell.give = giveString;

    NSString *getString = [trade objectForKey:@"give"];
    cell.getImageView.image = [UIImage imageNamed:[getString stringByAppendingString:@".png"]];
    cell.getImageView.layer.cornerRadius = 35.0;
    cell.get = getString;
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return trades.count;
}


@end
