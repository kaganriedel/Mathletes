//
//  ChooseOperationsViewController.m
//  Mathletes
//
//  Created by Kagan Riedel on 2/7/14.
//  Copyright (c) 2014 Kagan Riedel. All rights reserved.
//

#import "ChooseOperationsViewController.h"
#import "MathViewController.h"

@interface ChooseOperationsViewController ()

@end

@implementation ChooseOperationsViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    MathViewController *mathVC = segue.destinationViewController;
    
    if ([segue.identifier isEqualToString:@"AdditionSegue"])
    {
        
        mathVC.operationType = @"+";
    }
    else if ([segue.identifier isEqualToString:@"SubtractionSegue"])
    {
        mathVC.operationType = @"-";

    }
    else if ([segue.identifier isEqualToString:@"MultiplicationSegue"])
    {
        mathVC.operationType = @"x";

    }
    else if ([segue.identifier isEqualToString:@"DivisionSegue"])
    {
        mathVC.operationType = @"/";

    }
    
}
@end
