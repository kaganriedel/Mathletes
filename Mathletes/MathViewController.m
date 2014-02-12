//
//  ViewController.m
//  Mathletes
//
//  Created by Kagan Riedel on 2/7/14.
//  Copyright (c) 2014 Kagan Riedel. All rights reserved.
//

#import "MathViewController.h"

@interface NSUserDefaults (mathletes)
@end
@implementation NSUserDefaults (mathletes)

- (int)incrementKey:(NSString *)key
{
    int value = [self integerForKey:key] + 1;
    [self setInteger:value forKey:key];
    return value;
}

@end


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

-(void)viewDidDisappear:(BOOL)animated
{
    [self.countDownTimer invalidate];
}

-(void)startTimer
{
    countDown = 0;
    self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    
}

-(void)timerFired:(NSTimer *)timer
{
    countDown ++;
    
    if (countDown == 5)
    {
        [self.countDownTimer invalidate];
        [self showMessage];
    }
}

- (void)showMessage
{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Time Is Up!"
                                                      message:@"Oops! Next problem"
                                                     delegate:self
                                            cancelButtonTitle:@"Next"
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
    [self startTimer];
    feedbackLabel.text = nil;
    newButton.alpha = 0.0;
    goButton.alpha = 1.0;
    
}

-(void)correctAnswer
{
    feedbackLabel.text = @"Correct!";
    newButton.alpha = 1.0;
    goButton.alpha = 0.0;
    
    [self.countDownTimer invalidate];
    [self updateAchievements];
    [self giveSticker];

}

-(void)updateAchievements
{
    if ([_operationLabel.text isEqualToString:@"+"])
    {
        int newTotalAdds = [userDefaults incrementKey:@"totalAdds"];
        if (newTotalAdds > 0)
        {
            [userDefaults setBool:YES forKey:@"Added Up!"];
        }
    }
    else if ([_operationLabel.text isEqualToString:@"-"])
    {
        [userDefaults incrementKey:@"totalSubs"];
    }
    else if ([_operationLabel.text isEqualToString:@"x"])
    {
        [userDefaults incrementKey:@"totalMults"];
    }
    else if ([_operationLabel.text isEqualToString:@"/"])
    {
        [userDefaults incrementKey:@"totalDivides"];
    }
    [userDefaults synchronize];
}

/*
 achievements = @[[[Achievement alloc] initWithName:@"Added Up!" Description:@"Complete 1 addition problem" Message:@"You completed your first addition problem!"],
 [[Achievement alloc] initWithName:@"Subtracted!" Description:@"Complete 1 subtraction problem" Message:@"You completed your first subtraction problem!"],
 [[Achievement alloc] initWithName:@"5 Adds!" Description:@"Complete 5 addition problems" Message:@"You completed 5 addition problems!"],
 [[Achievement alloc] initWithName:@"5 Subtracts!" Description:@"Complete 5 subtraction problems" Message:@"You completed 5 subtraction problems!"],
 [[Achievement alloc] initWithName:@"Keep It Up!" Description:@"Complete 10 total math problems" Message:@"You completed 10 total problems!"]];
 */

-(void)giveSticker
{
    int randomSticker = arc4random()%100;
    NSLog(@"%i",randomSticker);
    
    
    if (randomSticker < 20)
    {
        [userDefaults incrementKey:@"lionCount"];
        NSLog(@"1st count +1");
    }
    else if (randomSticker < 40)
    {
        [userDefaults incrementKey:@"kittenCount"];
        NSLog(@"2nd count +1");
    }
    else if (randomSticker < 60)
    {
        [userDefaults incrementKey:@"starCount"];
        NSLog(@"3rd count +1");
    }
    else if (randomSticker < 80)
    {
        [userDefaults incrementKey:@"puppyCount"];
        NSLog(@"4th count +1");
    }
    else if (randomSticker <= 100)
    {
        [userDefaults incrementKey:@"tigerCount"];
        NSLog(@"5th count +1");
    }

    [userDefaults synchronize];
}


-(void)wrongAnswer
{
    goButton.alpha = 0.0;
    newButton.alpha = 1.0;
    [self.countDownTimer invalidate];
}

- (IBAction)onGoButtonPressed:(id)sender
{
    if (![answerTextField.text isEqualToString:@""])
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
}


@end
