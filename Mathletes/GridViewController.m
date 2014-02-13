//
//  GridViewController.m
//  Mathletes
//
//  Created by Matthew Voracek on 2/10/14.
//  Copyright (c) 2014 Kagan Riedel. All rights reserved.
//

#import "GridViewController.h"
#import "MathViewController.h"

@interface GridViewController () <UITabBarDelegate>

@property (weak, nonatomic) IBOutlet UITabBar *operandTabBar;
@property (weak, nonatomic) IBOutlet UITabBarItem *additionTabBarItem;
@property (weak, nonatomic) IBOutlet UITabBarItem *subtractionTabBarItem;

@property NSString *operand;

@end

@implementation GridViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    
    self.title = _additionTabBarItem.title;
    [_operandTabBar setSelectedItem:_operandTabBar.items[0]];
    _operand = @"+";
    [self createGrid];
}

- (void)createGrid
{
    
    
    int yDirection = 100;
    int subChange = 0;
    
    //i is horizontal, j is vertical, x&yDirection is spacing
    for (int j = 0; j < 10; j++)
    {
        int xDirection = 5;
        int subtractionValue = 0;
        
        for (int i = 0; i < 10 ; i++)
        {
            UILabel *gridLabel = [[UILabel alloc] initWithFrame:CGRectMake(xDirection, yDirection, 30, 30)];
            [self.view addSubview:gridLabel];
            [gridLabel setTextColor:[UIColor blackColor]];
            [gridLabel setTextAlignment:NSTextAlignmentCenter];
            [gridLabel setFont: [UIFont fontWithName:@"Arial" size:13.0]];
            
            //setting values
            if ([_operand isEqual:@"-"])
            {
                for (int k = subtractionValue; k < 10; k++)
                {
                    [gridLabel setText:[NSString stringWithFormat:@"%d%@%d",i+subtractionValue+subChange,_operand, j]];
                }
            }
            else if ([_operand isEqual:@"+"])
            {
               [gridLabel setText:[NSString stringWithFormat:@"%d%@%d",i,_operand, j]];
            }
            
            //background color
            if (i + j <= 10)
            {
                gridLabel.backgroundColor = [UIColor greenColor];
            }
            else if (i + j <= 14)
            {
                gridLabel.backgroundColor = [UIColor colorWithRed:(255.0/255.0) green:(239/255.0) blue:(0/255.0) alpha:1];

            }
            else if (i + j <= 18)
            {
                gridLabel.backgroundColor = [UIColor colorWithRed:(0/255.0) green:(156.0/255.0) blue:(227/255.0) alpha:1];
            }
            
            xDirection += 31;
        }
        subChange++;
        yDirection += 31;
    }
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    self.title = item.title;
    if (item == _additionTabBarItem)
    {
        _operand = @"+";
    }
    else if (item == _subtractionTabBarItem)
    {
        _operand = @"-";
    }
    
    [self createGrid];
}


@end
