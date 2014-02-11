//
//  GridViewController.m
//  Mathletes
//
//  Created by Matthew Voracek on 2/10/14.
//  Copyright (c) 2014 Kagan Riedel. All rights reserved.
//

#import "GridViewController.h"

@interface GridViewController ()

@property (weak, nonatomic) IBOutlet UITabBar *operandTabBar;
@property (weak, nonatomic) IBOutlet UITabBarItem *additionTabBarItem;
@property (weak, nonatomic) IBOutlet UITabBarItem *subtractionTabBarItem;

@property NSString *operand;

@end

@implementation GridViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)createGrid
{
    
    int yDirection = 100;
    
    for (int j = 0; j < 10; j++)
    {
        int xDirection = 5;
        
        for (int i = 0; i < 10 ; i++)
        {
            UILabel *gridLabel = [[UILabel alloc] initWithFrame:CGRectMake(xDirection, yDirection, 30, 30)];
            [self.view addSubview:gridLabel];
            gridLabel.backgroundColor = [UIColor colorWithRed:(0/255.0) green:(156.0/255.0) blue:(227/255.0) alpha:1];
            [gridLabel setTextColor:[UIColor whiteColor]];
            [gridLabel setTextAlignment:NSTextAlignmentCenter];
            [gridLabel setFont: [UIFont fontWithName:@"Arial" size:13.0]];
            [gridLabel setText:[NSString stringWithFormat:@"%d%@%d",i,_operand, j]];
            xDirection += 31;
            
        }
        
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
