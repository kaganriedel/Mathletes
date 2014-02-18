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

@interface TradeWallViewController () <UITableViewDataSource, UITableViewDelegate>
{
    NSArray *trades;
}

@end

@implementation TradeWallViewController


-(void)viewDidLoad
{
    [super viewDidLoad];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Trade"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        trades = objects;
    }];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TradeWallCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TradeCell"];
    
    PFObject *trade = trades[indexPath.row];
    NSString *giveString = [trade objectForKey:@"give"];
    NSString *getString = [trade objectForKey:@"get"];
    cell.imageView1.image = [UIImage imageNamed:[giveString stringByAppendingString:@".png"]];
    cell.imageView2.image = [UIImage imageNamed:[getString stringByAppendingString:@".png"]];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return trades.count;
}


@end
