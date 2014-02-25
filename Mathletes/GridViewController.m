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
    NSInteger problemType;
    
}

@property (weak, nonatomic) IBOutlet UITabBar *operandTabBar;
@property (weak, nonatomic) IBOutlet UITabBarItem *additionTabBarItem;
@property (weak, nonatomic) IBOutlet UITabBarItem *subtractionTabBarItem;
@property (weak, nonatomic) IBOutlet UITabBarItem *multiplicationTabBarItem;
@property (weak, nonatomic) IBOutlet UITabBarItem *divisionTabBarItem;



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
    
    [_operandTabBar setSelectedItem:_operandTabBar.items[0]];
    
    _operand = @"+";
    problemType = 0;
    
    [self queryForProblemType];
    [self createPlaceHolderGrid];
}

-(void)queryForProblemType
{
    PFQuery *problemQuery = [PFQuery queryWithClassName:@"MathProblem"];
    problemQuery.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [problemQuery whereKey:@"problemType" equalTo:[NSNumber numberWithInt:problemType]];
    [problemQuery whereKey:@"mathUser" equalTo:[PFUser currentUser]];
    [problemQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         _gridArray = (NSMutableArray *)objects;
         [self createGrid];
     }];
}

-(void)createPlaceHolderGrid
{
    int yDirection = 10;
    int divisionChange = 1;

    for (int j = 0; j < 10; j++)
    {
        int xDirection = 5;

        for (int i = 0; i < 10; i++)
        {
            UILabel *gridLabel = [[UILabel alloc] initWithFrame:CGRectMake(xDirection, yDirection, 30, 30)];
            gridLabel.backgroundColor = [UIColor myBlueColor];
            gridLabel.text = [NSString stringWithFormat:@"%i+%i", i, j];
            [gridLabel setTextColor:[UIColor whiteColor]];
            [gridLabel setTextAlignment:NSTextAlignmentCenter];
            [gridLabel setFont: [UIFont fontWithName:@"Miso-Bold" size:15.0]];
            xDirection += 31;
            [self.view addSubview:gridLabel];
        }
        yDirection += 31;
        divisionChange += 1;
    }
}

-(void)createGrid
{
    
    int yDirection = 10;
    int subChange = 0;
    int divisionChange = 1;
    int jStart = 0, jEnd = 10, iStart = 0, iEnd = 10;
    float fontSize = 15.0;
    if ([_operand  isEqual: @"/"])
    {
        jStart = 1;
        jEnd = 11;
        iStart = 1;
        iEnd = 11;
        fontSize = 12.0;
    }
    
    //i is horizontal, j is vertical, x&yDirection is spacing
    for (int j = jStart; j < jEnd; j++)
    {
        int xDirection = 5;
        int subtractionValue = 0;
        
        for (int i = iStart; i < (iEnd); i++)
        {
            UILabel *gridLabel = [[UILabel alloc] initWithFrame:CGRectMake(xDirection, yDirection, 30, 30)];
            [self.view addSubview:gridLabel];
            [gridLabel setTextColor:[UIColor whiteColor]];
            [gridLabel setTextAlignment:NSTextAlignmentCenter];
            [gridLabel setFont: [UIFont fontWithName:@"Miso-Bold" size:fontSize]];
            
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
            else if ([_operand isEqual:@"+"] || [_operand isEqual:@"x"])
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
            else if ([_operand isEqual:@"/"])
            {
                
                    [gridLabel setText:[NSString stringWithFormat:@"%d%@%d",i*divisionChange,_operand, j]];
                    
                    NSString *gridValues = [NSString stringWithFormat: @"%d%d",i*divisionChange, j];
                    
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
                gridLabel.backgroundColor = [UIColor myGreenColor];
            }
            else if (attempted == YES)
            {
                gridLabel.backgroundColor = [UIColor myYellowColor];
                
            }
            else
            {
                gridLabel.backgroundColor = [UIColor myBlueColor];
            }
            
            xDirection += 31;
        }
        subChange++;
        yDirection += 31;
        divisionChange += 1;
    }
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if (item == _additionTabBarItem)
    {
        _operand = @"+";
        problemType = 0;
        [self queryForProblemType];
        
    }
    else if (item == _subtractionTabBarItem)
    {
        _operand = @"-";
        problemType = 1;
        [self queryForProblemType];
    }
    else if (item == _multiplicationTabBarItem)
    {
        _operand = @"x";
        problemType = 2;
        [self queryForProblemType];
    }
    else if (item == _divisionTabBarItem)
    {
        _operand = @"/";
        problemType = 3;
        [self queryForProblemType];
    }

}

@end
