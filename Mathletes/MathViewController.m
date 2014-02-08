//
//  ViewController.m
//  Mathletes
//
//  Created by Kagan Riedel on 2/7/14.
//  Copyright (c) 2014 Kagan Riedel. All rights reserved.
//

#import "MathViewController.h"

@interface MathViewController ()
{
    __weak IBOutlet UILabel *var1Label;
    __weak IBOutlet UILabel *var2Label;
    __weak IBOutlet UILabel *operationLabel;
    __weak IBOutlet UIButton *goButton;
    __weak IBOutlet UIButton *newButton;
    __weak IBOutlet UILabel *feedbackLabel;
    __weak IBOutlet UITextField *answerTextField;
}

@end

@implementation MathViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [operationLabel setText:[NSString stringWithFormat:@"-"]];
    [self newMathProblem];
    
    newButton.alpha = 0.0;
}


-(void)newMathProblem
{
    int highestRange = 101;
    int divisionModifier = 0;
    
    if ([operationLabel.text isEqualToString:@"/"])
    {
        divisionModifier = 1;
    }
    
    [var1Label setText:[NSString stringWithFormat:@"%i", arc4random()%(highestRange-divisionModifier)+divisionModifier]];
    [var2Label setText:[NSString stringWithFormat:@"%i", arc4random()%(highestRange-divisionModifier)+divisionModifier]];
    NSLog(@"var1: %i var2: %i", var1Label.text.intValue, var2Label.text.intValue);

    
    if (([operationLabel.text isEqualToString:@"-"] || [operationLabel.text isEqualToString:@"/"]) && var1Label.text.intValue < var2Label.text.intValue)
    {
        NSString *tempString = var2Label.text;
        var2Label.text = var1Label.text;
        var1Label.text = tempString;
    }
    if ([operationLabel.text isEqualToString:@"/"] && var1Label.text.intValue % var2Label.text.intValue != 0.0)
    {
        [self newMathProblem];
    }
}

- (IBAction)onNewButtonPressed:(id)sender
{
    answerTextField.text = nil;
    [self newMathProblem];
    feedbackLabel.text = nil;
    newButton.alpha = 0.0;
    goButton.alpha = 1.0;
    
}

-(void)correctAnswer
{
    feedbackLabel.text = @"Correct!";
    newButton.alpha = 1.0;
    goButton.alpha = 0.0;
}

-(void)wrongAnswer
{
    goButton.alpha = 0.0;
    newButton.alpha = 1.0;
}

- (IBAction)onGoButtonPressed:(id)sender
{
    if ([operationLabel.text isEqualToString:@"x"])
    {
        if (answerTextField.text.intValue == var1Label.text.intValue * var2Label.text.intValue)
        {
            [self correctAnswer];
        }
        else
        {
            feedbackLabel.text = [NSString stringWithFormat: @"The correct answer is %i", var1Label.text.intValue * var2Label.text.intValue];
            [self wrongAnswer];
        }
    }
    else if ([operationLabel.text isEqualToString:@"/"])
    {
        if (answerTextField.text.intValue == var1Label.text.intValue / var2Label.text.intValue)
        {
            [self correctAnswer];
        }
        else
        {
            feedbackLabel.text = [NSString stringWithFormat: @"The correct answer is %i", var1Label.text.intValue / var2Label.text.intValue];
            [self wrongAnswer];

        }
    }
   else if ([operationLabel.text isEqualToString:@"+"])
    {
        if (answerTextField.text.intValue == var1Label.text.intValue + var2Label.text.intValue)
        {
            [self correctAnswer];
        }
        else
        {
            feedbackLabel.text = [NSString stringWithFormat: @"The correct answer is %i", var1Label.text.intValue + var2Label.text.intValue];
            [self wrongAnswer];

        }
    }
    else if ([operationLabel.text isEqualToString:@"-"])
    {
        if (answerTextField.text.intValue == var1Label.text.intValue - var2Label.text.intValue)
        {
            [self correctAnswer];
        }
        else
        {
            feedbackLabel.text = [NSString stringWithFormat: @"The correct answer is %i", var1Label.text.intValue - var2Label.text.intValue];
            [self wrongAnswer];

        }
    }
}



@end
