//
//  ViewController.m
//  Mathletes
//
//  Created by Kagan Riedel on 2/7/14.
//  Copyright (c) 2014 Kagan Riedel. All rights reserved.
//

#import "MathViewController.h"

@interface MathViewController () <UIAlertViewDelegate>
{
    __weak IBOutlet UILabel *var1Label;
    __weak IBOutlet UILabel *var2Label;
    __weak IBOutlet UIButton *goButton;
    __weak IBOutlet UIButton *newButton;
    __weak IBOutlet UILabel *feedbackLabel;
    __weak IBOutlet UITextField *answerTextField;
    NSInteger countDown;
    
    NSUserDefaults *userDefaults;

}

@property (nonatomic, strong) NSTimer *countDownTimer;

@end

@implementation MathViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    userDefaults = [NSUserDefaults standardUserDefaults];

    _operationLabel.text = _operationType;
    
    [self newMathProblem];
    
    newButton.alpha = 0.0;
    [self startTimer];
    
    
    

}

-(void)startTimer
{
    countDown = 0;
    self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    
}

-(void)timerFired:(NSTimer *)timer
{
    countDown++;
    
    if (countDown ==5)
    {
        [self.countDownTimer invalidate];
        [self showMessage];
    }
    
}

- (void)showMessage
{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Time is UP!"
                                                      message:@"Oops! Next problem"
                                                     delegate:self
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    
    [message show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self newMathProblem];
    [self startTimer];
    
}

-(void)newMathProblem
{
    int highestRange = 11;
    int divisionModifier = 0;
    
    [var1Label setText:[NSString stringWithFormat:@"%i", arc4random()%(highestRange-divisionModifier)+divisionModifier]];
    [var2Label setText:[NSString stringWithFormat:@"%i", arc4random()%(highestRange-divisionModifier)+divisionModifier]];
    NSLog(@"var1: %i var2: %i", var1Label.text.intValue, var2Label.text.intValue);
    
    
    
    if ([_operationLabel.text isEqualToString:@"/"])
    {
        divisionModifier = 1;
    }
    
    [var1Label setText:[NSString stringWithFormat:@"%i", arc4random()%(highestRange-divisionModifier)+divisionModifier]];
    [var2Label setText:[NSString stringWithFormat:@"%i", arc4random()%(highestRange-divisionModifier)+divisionModifier]];
    NSLog(@"var1: %i var2: %i", var1Label.text.intValue, var2Label.text.intValue);

    
    if (([_operationLabel.text isEqualToString:@"-"] || [_operationLabel.text isEqualToString:@"/"]) && var1Label.text.intValue < var2Label.text.intValue)
    {
        NSString *tempString = var2Label.text;
        var2Label.text = var1Label.text;
        var1Label.text = tempString;
    }
    if ([_operationLabel.text isEqualToString:@"/"] && var1Label.text.intValue % var2Label.text.intValue != 0.0)
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
    
    [self updateAchievements];
    [self giveSticker];
}

-(void)updateAchievements
{
    if ([_operationLabel.text isEqualToString:@"+"])
    {
        [userDefaults setInteger:[userDefaults integerForKey:@"totalAdds"] +1 forKey:@"totalAdds"];
        NSLog(@"totalAdds = %i", [userDefaults integerForKey:@"totalAdds"]);
    }
    else if ([_operationLabel.text isEqualToString:@"-"])
    {
        [userDefaults setInteger:[userDefaults integerForKey:@"totalSubs"] +1 forKey:@"totalSubs"];
        NSLog(@"totalSubs = %i", [userDefaults integerForKey:@"totalSubs"]);
    }
    else if ([_operationLabel.text isEqualToString:@"x"])
    {
        [userDefaults setInteger:[userDefaults integerForKey:@"totalMults"] +1 forKey:@"totalMults"];
        NSLog(@"totalMults = %i", [userDefaults integerForKey:@"totalMults"]);
    }
    else if ([_operationLabel.text isEqualToString:@"/"])
    {
        [userDefaults setInteger:[userDefaults integerForKey:@"totalDivides"] +1 forKey:@"totalDivides"];
        NSLog(@"totalDivides = %i", [userDefaults integerForKey:@"totalDivides"]);
    }

}

-(void)giveSticker
{
    int randomSticker = arc4random()%100;
    NSLog(@"%i",randomSticker);
    
    userDefaults = [NSUserDefaults standardUserDefaults];
    
    if (randomSticker < 20)
    {
        [userDefaults setInteger:[userDefaults integerForKey:@"lionCount"] +1 forKey:@"lionCount"];
        NSLog(@"1st count +1");
    }
    else if (randomSticker < 40)
    {
        [userDefaults setInteger:[userDefaults integerForKey:@"kittenCount"] +1 forKey:@"kittenCount"];
        NSLog(@"2nd count +1");
    }
    else if (randomSticker < 60)
    {
        [userDefaults setInteger:[userDefaults integerForKey:@"starCount"] +1 forKey:@"starCount"];
        NSLog(@"3rd count +1");
    }
    else if (randomSticker < 80)
    {
        [userDefaults setInteger:[userDefaults integerForKey:@"puppyCount"] +1 forKey:@"puppyCount"];
        NSLog(@"4th count +1");
    }
    else if (randomSticker <= 100)
    {
        [userDefaults setInteger:[userDefaults integerForKey:@"tigerCount"] +1 forKey:@"tigerCount"];
        NSLog(@"5th count +1");
    }

    [userDefaults synchronize];
}


-(void)wrongAnswer
{
    goButton.alpha = 0.0;
    newButton.alpha = 1.0;
}

- (IBAction)onGoButtonPressed:(id)sender
{
    if ([_operationLabel.text isEqualToString:@"x"])
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
    else if ([_operationLabel.text isEqualToString:@"/"])
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
   else if ([_operationLabel.text isEqualToString:@"+"])
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
    else if ([_operationLabel.text isEqualToString:@"-"])
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
