//
//  GridViewController.m
//  Mathletes
//
//  Created by Matthew Voracek on 2/10/14.
//  Copyright (c) 2014 Kagan Riedel. All rights reserved.
//

#import "GridViewController.h"
#import "MathViewController.h"
#import "MathProblem.h"

@interface GridViewController () <UITabBarDelegate>
{
    NSInteger key;
    NSInteger difficulty;
    __weak IBOutlet UILabel *excellentLabel;
    __weak IBOutlet UILabel *proficientLabel;
    __weak IBOutlet UILabel *effecientLabel;
    
    
}

@property (weak, nonatomic) IBOutlet UITabBar *operandTabBar;
@property (weak, nonatomic) IBOutlet UITabBarItem *additionTabBarItem;
@property (weak, nonatomic) IBOutlet UITabBarItem *subtractionTabBarItem;

@property NSString *operand;

@end

@implementation GridViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor], NSForegroundColorAttributeName, [UIFont fontWithName:@"Miso-Bold" size:28], NSFontAttributeName, nil]];

    excellentLabel.font = [UIFont fontWithName:@"Miso-Bold" size:20];
    proficientLabel.font = [UIFont fontWithName:@"Miso-Bold" size:20];
    effecientLabel.font = [UIFont fontWithName:@"Miso-Bold" size:20];
}

-(void)buildView
{
    self.title = _additionTabBarItem.title;
    [_operandTabBar setSelectedItem:_operandTabBar.items[0]];
    _operand = @"+";
    
    PFQuery *problemQuery = [PFQuery queryWithClassName:@"MathProblem"];
    [problemQuery whereKey:@"problemType" equalTo:@0];
    [problemQuery whereKey:@"mathUser" equalTo:[PFUser currentUser]];
    
    [problemQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         _gridArray = (NSMutableArray *)objects;
         
         for (int i = 0; i < _gridArray.count; i++)
         {
             MathProblem *problem = _gridArray[i];
             NSLog(@"%i %i %ld",problem.firstValue, problem.secondValue,(long)problem.equationDifficulty);
         }
         
         [self buildView];
     }];
    

    
}

-(void)buildView
{
    [_operandTabBar setSelectedItem:_operandTabBar.items[0]];
    _operand = @"+";

    [self createGrid];
}

-(void)createGrid
{
    
    int yDirection = 10;
    int subChange = 0;
    
    //i is horizontal, j is vertical, x&yDirection is spacing
    for (int j = 0; j < 10; j++)
    {
        int xDirection = 5;
        int subtractionValue = 0;
        
        for (int i = 0; i < 10; i++)
        {
            UILabel *gridLabel = [[UILabel alloc] initWithFrame:CGRectMake(xDirection, yDirection, 30, 30)];
            [self.view addSubview:gridLabel];
            [gridLabel setTextColor:[UIColor whiteColor]];
            [gridLabel setTextAlignment:NSTextAlignmentCenter];
            [gridLabel setFont: [UIFont fontWithName:@"Miso-Bold" size:15.0]];
            
            //set values
            
            if ([_operand isEqual:@"-"])
            {
                
                for (int k = subtractionValue; k < 10; k++)
                {
                    [gridLabel setText:[NSString stringWithFormat:@"%d%@%d",i+subtractionValue+subChange,_operand, j]];
                    
                    NSString *gridValues = [NSString stringWithFormat: @"%d%d",i+subtractionValue+subChange, j];
                    
                    [_gridArray enumerateObjectsUsingBlock:^(MathProblem *problem, NSUInteger idx, BOOL *stop)
                     {
                         NSString *valuesString = [NSString stringWithFormat: @"%i%i", problem.firstValue, problem.secondValue];
                         
                         if ([valuesString isEqualToString:gridValues])
                         {
                             difficulty = problem.equationDifficulty;
                             key = idx;
                         }
                     }];
                }
            }
            else if ([_operand isEqual:@"+"])
            {
                
                [gridLabel setText:[NSString stringWithFormat:@"%d%@%d",i,_operand, j]];
                
                NSString *gridValues = [NSString stringWithFormat: @"%d%d",i, j];
                
                [_gridArray enumerateObjectsUsingBlock:^(MathProblem *problem, NSUInteger idx, BOOL *stop)
                 {
                     NSString *valuesString = [NSString stringWithFormat: @"%i%i", problem.firstValue, problem.secondValue];
                     
                     if ([valuesString isEqualToString:gridValues])
                     {
                         difficulty = problem.equationDifficulty;
                         key = idx;
                     }
                 }];
                
            }
            
            MathProblem *mp = _gridArray[key];
            difficulty = mp.equationDifficulty;
            BOOL attempted = mp.haveAttemptedEquation;
            
            //background color
            if (difficulty == 0)
            {
                gridLabel.backgroundColor = [UIColor colorWithRed:130.0/255.0 green:183.0/255.0 blue:53.0/255.0 alpha:1];
            }
            else if (attempted == YES)
            {
                gridLabel.backgroundColor = [UIColor colorWithRed:(221.0/255.0) green:(168.0/255.0) blue:(57.0/255.0) alpha:0.9];
                
            }
            else
            {
                gridLabel.backgroundColor = [UIColor colorWithRed:(95.0/255.0) green:(162.0/255.0) blue:(219/255.0) alpha:1];
            }
            
            xDirection += 31;
            
        }
        subChange++;
        yDirection += 31;
    }
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if (item == _additionTabBarItem)
    {
        _operand = @"+";
        
        PFQuery *problemQuery = [PFQuery queryWithClassName:@"MathProblem"];
        [problemQuery whereKey:@"problemType" equalTo:@0];
        [problemQuery whereKey:@"mathUser" equalTo:[PFUser currentUser]];
        
        [problemQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
         {
             _gridArray = (NSMutableArray *)objects;
             
             for (int i = 0; i < _gridArray.count; i++)
             {
                 MathProblem *problem = _gridArray[i];
                 NSLog(@"%i %i %ld",problem.firstValue, problem.secondValue,(long)problem.equationDifficulty);
             }
             
             [self buildView];
         }];
        
    }
    else if (item == _subtractionTabBarItem)
    {
        _operand = @"-";
        
        PFQuery *problemQuery = [PFQuery queryWithClassName:@"MathProblem"];
        [problemQuery whereKey:@"problemType" equalTo:@1];
        [problemQuery whereKey:@"mathUser" equalTo:[PFUser currentUser]];
        
        [problemQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
         {
             _gridArray = (NSMutableArray *)objects;
             
             for (int i = 0; i < _gridArray.count; i++)
             {
                 MathProblem *problem = _gridArray[i];
                 NSLog(@"%i %i %ld",problem.firstValue, problem.secondValue,(long)problem.equationDifficulty);
             }
             
             [self buildView];
         }];
        
    }
    
    [self createGrid];
}

/*
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
*/




@end
