//
//  TradeViewController.m
//  Mathletes
//
//  Created by MobileMath.co on 2/7/14.
//  Copyright (c) 2014 MobileMath.co. All rights reserved.
//

#import "MakeTradeViewController.h"
#import "MakeTradeCell.h"
#import "Parse/Parse.h"
#import "ActionSheetPicker.h"

@interface MakeTradeViewController () <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, ActionSheetCustomPickerDelegate>
{
    __weak IBOutlet UITableView *giveTableView;
    __weak IBOutlet UITableView *getTableView;
    __weak IBOutlet UIButton *giveCountButton;
    __weak IBOutlet UIButton *getCountButton;
    
    PFUser *user;
    
    NSMutableArray *userStickers;
    NSMutableArray *userStickerCounts;
    NSArray *stickerArray;
    NSIndexPath *giveTableCheckedIndexPath;
    NSIndexPath *getTableCheckedIndexPath;
    NSArray *numbers;
    ActionSheetCustomPicker *tradeActionSheetPicker;

    NSInteger selectedRow;
    NSString *selectedButton;
    NSNumber *giveCount;
    NSNumber *getCount;
}

@end

@implementation MakeTradeViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    user = [PFUser currentUser];
    
    giveCountButton.titleLabel.font = [UIFont fontWithName:@"Miso-Bold" size:36.0f];
    [giveCountButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];

    getCountButton.titleLabel.font = [UIFont fontWithName:@"Miso-Bold" size:36.0f];
    [getCountButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    tradeActionSheetPicker = [[ActionSheetCustomPicker alloc] initWithTitle:@"How many?" delegate:self showCancelButton:YES origin:self.view];
    
    giveCount = @1;
    getCount = @1;
    
    userStickers = [NSMutableArray new];
    userStickerCounts = [NSMutableArray new];
    stickerArray = [NSArray stickerArray];
    numbers = @[@1, @2, @3, @4, @5, @6, @7, @8, @9, @10];
    
    //check to see which stickers the user has collected and display the ones they have
    for (NSString *key in stickerArray)
    {
        if ([[user objectForKey: [NSString stringWithFormat:@"%@Count", key]] intValue] > 0)
        {
            [userStickers addObject:[NSString stringWithFormat:@"%@.png", key]];
            [userStickerCounts addObject:[user objectForKey:[NSString stringWithFormat:@"%@Count", key]]];
            NSLog(@"count: %@",[user objectForKey:[NSString stringWithFormat:@"%@Count", key]]);
        }
    }
}

- (IBAction)onCountButtonPressed:(UIButton *)sender
{
    if (sender.tag == 0)
    {
        selectedButton = @"give";
    }
    else if (sender.tag == 1)
    {
        selectedButton = @"get";
    }
    selectedRow = 0;
    [tradeActionSheetPicker showActionSheetPicker];
}

- (IBAction)onDoneButtonPressed:(id)sender
{
    if (getTableCheckedIndexPath && giveTableCheckedIndexPath)
    {
        NSNumber *count = userStickerCounts[giveTableCheckedIndexPath.row];
        NSLog(@"giveCount: %@, userStickerCount: %@", giveCount, count);
        if (giveCount.intValue > count.intValue)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"You don't have enough stickers to make this trade." delegate:nil cancelButtonTitle:@"OK!" otherButtonTitles: nil];
            [alert show];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Complete Trade" message:@"Are you sure you want to make this trade?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
            [alert show];
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Make sure to pick a sticker to trade and a sticker to get." delegate:nil cancelButtonTitle:@"OK!" otherButtonTitles: nil];
        [alert show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        MakeTradeCell *giveCell = (MakeTradeCell*)[giveTableView cellForRowAtIndexPath:giveTableCheckedIndexPath];
        MakeTradeCell *getCell = (MakeTradeCell*)[getTableView cellForRowAtIndexPath:getTableCheckedIndexPath];
        NSDictionary *dictionary = @{@"give": giveCell.sticker, @"giveCount": giveCount, @"get": getCell.sticker, @"getCount": getCount, @"user": [PFUser currentUser]};
        PFObject *trade = [PFObject objectWithClassName:@"Trade" dictionary:dictionary];
        [trade saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded)
            {
                for (int x = 0; x < giveCount.intValue; x++)
                {
                    [user decrementKey:[NSString stringWithFormat:@"%@Count", giveCell.sticker]];
                }
                [user saveInBackground];
            }
        }];
        [self performSegueWithIdentifier:@"unwindToTradeWall" sender:self];
    }
}

#pragma mark UITableView delegate
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
        cell.countLabel.text = [NSString stringWithFormat:@"x%@", userStickerCounts[indexPath.row]];
        cell.countLabel.font = [UIFont fontWithName:@"Miso-Bold" size:14.0f];
        if (indexPath.row == giveTableCheckedIndexPath.row && giveTableCheckedIndexPath)
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
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
        if (indexPath.row == getTableCheckedIndexPath.row && getTableCheckedIndexPath)
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
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

#pragma mark ActionSheetPicker delegate

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return numbers.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [numbers[row] description];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    selectedRow = row;
}

-(void)actionSheetPickerDidSucceed:(AbstractActionSheetPicker *)actionSheetPicker origin:(id)origin
{
    if ([selectedButton isEqualToString:@"give"])
    {
        [giveCountButton setTitle:[NSString stringWithFormat:@"GIVE %@",[numbers[selectedRow] description]] forState:UIControlStateNormal];
        giveCount = numbers[selectedRow];
    }
    else if ([selectedButton isEqualToString:@"get"])
    {
        [getCountButton setTitle:[NSString stringWithFormat:@"GET %@",[numbers[selectedRow] description]] forState:UIControlStateNormal];
        getCount = numbers[selectedRow];
    }
}
@end
