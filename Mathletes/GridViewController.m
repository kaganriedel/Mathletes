//
//  GridViewController.m
//  Mathletes
//
//  Created by MobileMath.co on 2/7/14.
//  Copyright (c) 2014 MobileMath.co. All rights reserved.
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
    
    NSArray *additionGridArray;
    NSArray *subtractionGridArray;
    NSArray *multiplicationGridArray;
    NSArray *divisionGridArray;
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
    
    [[UITabBar appearance] setTintColor:[UIColor myBlueColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor], NSForegroundColorAttributeName, [UIFont fontWithName:@"Miso-Bold" size:28], NSFontAttributeName, nil]];

    excellentLabel.font = [UIFont fontWithName:@"Miso-Bold" size:20];
    proficientLabel.font = [UIFont fontWithName:@"Miso-Bold" size:20];
    effecientLabel.font = [UIFont fontWithName:@"Miso-Bold" size:20];
    
    [_operandTabBar setSelectedItem:_operandTabBar.items[0]];
    
    _operand = @"+";
    problemType = 0;
    

    [self queryForAllGridArrays];
}

-(void)queryForAllGridArrays
{
    PFQuery *additionQuery = [PFQuery queryWithClassName:@"MathProblem"];
    [additionQuery whereKey:@"problemType" equalTo:@0];
    [additionQuery whereKey:@"mathUser" equalTo:[PFUser currentUser]];
    [additionQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         additionGridArray = objects;
         [self createGrid];
     }];
    PFQuery *subtractionQuery = [PFQuery queryWithClassName:@"MathProblem"];
    [subtractionQuery whereKey:@"problemType" equalTo:@1];
    [subtractionQuery whereKey:@"mathUser" equalTo:[PFUser currentUser]];
    [subtractionQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         subtractionGridArray = objects;
     }];
    PFQuery *multiplicationQuery = [PFQuery queryWithClassName:@"MathProblem"];
    [multiplicationQuery whereKey:@"problemType" equalTo:@2];
    [multiplicationQuery whereKey:@"mathUser" equalTo:[PFUser currentUser]];
    [multiplicationQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         multiplicationGridArray = objects;
     }];
    PFQuery *divisionQuery = [PFQuery queryWithClassName:@"MathProblem"];
    [divisionQuery whereKey:@"problemType" equalTo:@3];
    [divisionQuery whereKey:@"mathUser" equalTo:[PFUser currentUser]];
    [divisionQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         divisionGridArray = objects;
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
    MathProblem *mp;
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
                
                [gridLabel setText:[NSString stringWithFormat:@"%d%@%d",i+subtractionValue+subChange,_operand, j]];
                
                NSString *gridValues = [NSString stringWithFormat: @"%d%d",i+subtractionValue+subChange, j];
                
                [subtractionGridArray enumerateObjectsUsingBlock:^(MathProblem *problem, NSUInteger idx, BOOL *stop)
                 {
                     NSString *valuesString = [NSString stringWithFormat: @"%li%i", (long)problem.firstValue, problem.secondValue];
                     
                     if ([valuesString isEqualToString:gridValues])
                     {
                         difficulty = problem.equationDifficulty;
                         key = idx;
                     }
                 }];
                mp = subtractionGridArray[key];
            }
            else if ([_operand isEqual:@"+"])
            {
                
                [gridLabel setText:[NSString stringWithFormat:@"%d%@%d",i,_operand, j]];
                
                NSString *gridValues = [NSString stringWithFormat: @"%d%d",i, j];
                
                [additionGridArray enumerateObjectsUsingBlock:^(MathProblem *problem, NSUInteger idx, BOOL *stop)
                 {
                     NSString *valuesString = [NSString stringWithFormat: @"%li%i", (long)problem.firstValue, problem.secondValue];
                     
                     if ([valuesString isEqualToString:gridValues])
                     {
                         difficulty = problem.equationDifficulty;
                         key = idx;
                     }
                 }];
                
                mp = additionGridArray[key];
                
            }
            else if ([_operand isEqual:@"/"])
            {
                
                    [gridLabel setText:[NSString stringWithFormat:@"%d%@%d",i*divisionChange,_operand, j]];
                    
                    NSString *gridValues = [NSString stringWithFormat: @"%d%d",i*divisionChange, j];
                    
                    [divisionGridArray enumerateObjectsUsingBlock:^(MathProblem *problem, NSUInteger idx, BOOL *stop)
                     {
                         NSString *valuesString = [NSString stringWithFormat: @"%li%i", (long)problem.firstValue, problem.secondValue];
                         
                         if ([valuesString isEqualToString:gridValues])
                         {
                             difficulty = problem.equationDifficulty;
                             key = idx;
                         }
                     }];
                
                mp = divisionGridArray[key];
            }
            else if ([_operand isEqual:@"x"])
            {
                
                [gridLabel setText:[NSString stringWithFormat:@"%d%@%d",i,_operand, j]];
                
                NSString *gridValues = [NSString stringWithFormat: @"%d%d",i, j];
                
                [multiplicationGridArray enumerateObjectsUsingBlock:^(MathProblem *problem, NSUInteger idx, BOOL *stop)
                 {
                     NSString *valuesString = [NSString stringWithFormat: @"%li%i", (long)problem.firstValue, problem.secondValue];
                     
                     if ([valuesString isEqualToString:gridValues])
                     {
                         difficulty = problem.equationDifficulty;
                         key = idx;
                     }
                 }];
                
                mp = multiplicationGridArray[key];
                
            }

            
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
        [self createGrid];
    }
    else if (item == _subtractionTabBarItem)
    {
        _operand = @"-";
        problemType = 1;
        [self createGrid];
    }
    else if (item == _multiplicationTabBarItem)
    {
        _operand = @"x";
        problemType = 2;
        [self createGrid];
    }
    else if (item == _divisionTabBarItem)
    {
        _operand = @"/";
        problemType = 3;
        [self createGrid];
    }

}

@end
