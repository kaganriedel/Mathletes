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
{
    
    __weak IBOutlet UIButton *additionButton;
    __weak IBOutlet UIButton *subtractionButton;
    __weak IBOutlet UIButton *multiplicationButton;
    __weak IBOutlet UIButton *divisionButton;
}


@end

@implementation ChooseOperationsViewController



- (void)viewDidLoad
{
    [super viewDidLoad];


    additionButton.titleLabel.font = [UIFont fontWithName:@"Miso-Bold" size:48];
    additionButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    subtractionButton.titleLabel.font = [UIFont fontWithName:@"Miso-Bold" size:48];
    subtractionButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    multiplicationButton.titleLabel.font = [UIFont fontWithName:@"Miso-Bold" size:48];
    multiplicationButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    divisionButton.titleLabel.font = [UIFont fontWithName:@"Miso-Bold" size:48];
    divisionButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    

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
