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
    NSTimer *countDownTimer;
    
    NSUserDefaults *userDefaults;
}


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
    [countDownTimer invalidate];
}

-(void)startTimer
{
    countDown = 0;
    countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    
}

-(void)timerFired:(NSTimer *)timer
{
    countDown ++;
    NSLog(@"%i",countDown);

    
    if (countDown == 10)
    {
        [countDownTimer invalidate];
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
    feedbackLabel.text = nil;
    answerTextField.text = nil;


    int highestRange = 11;
    int divisionModifier = 0;
    
    [var1Label setText:[NSString stringWithFormat:@"%i", arc4random()%(highestRange-divisionModifier)+divisionModifier]];
    [var2Label setText:[NSString stringWithFormat:@"%i", arc4random()%(highestRange-divisionModifier)+divisionModifier]];
    
    if ([_operationLabel.text isEqualToString:@"/"])
    {
        divisionModifier = 1;
    }
    
    [var1Label setText:[NSString stringWithFormat:@"%i", arc4random()%(highestRange-divisionModifier)+divisionModifier]];
    [var2Label setText:[NSString stringWithFormat:@"%i", arc4random()%(highestRange-divisionModifier)+divisionModifier]];

    
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
    [self newMathProblem];
    [self startTimer];
    newButton.alpha = 0.0;
    goButton.alpha = 1.0;
    
}

-(void)correctAnswer
{
    feedbackLabel.text = @"Correct!";
    newButton.alpha = 1.0;
    goButton.alpha = 0.0;
    
    [countDownTimer invalidate];
    [self updateAchievements];

}

-(void)updateAchievements
{
    if ([_operationLabel.text isEqualToString:@"+"])
    {
        int newTotalAdds = [userDefaults incrementKey:@"totalAdds"];
        NSLog(@"newTotalAdds is: %i", newTotalAdds);

        if (newTotalAdds >= 1)
        {
            [userDefaults setBool:YES forKey:@"Add It Up!"];
        }
        if (newTotalAdds >= 20)
        {
            [userDefaults setBool:YES forKey:@"Add It Up x20!"];
        }
        if (newTotalAdds >= 50)
        {
            [userDefaults setBool:YES forKey:@"Add It Up x50!"];
        }
        if (newTotalAdds >= 100)
        {
            [userDefaults setBool:YES forKey:@"Add It Up x100!"];
        }
        if (newTotalAdds >= 200)
        {
            [userDefaults setBool:YES forKey:@"Add It Up x200!"];
        }
        if (newTotalAdds >= 300)
        {
            [userDefaults setBool:YES forKey:@"Add It Up x300!"];
        }
        if (newTotalAdds >= 400)
        {
            [userDefaults setBool:YES forKey:@"Add It Up x400!"];
        }
        if (newTotalAdds >= 500)
        {
            [userDefaults setBool:YES forKey:@"Add It Up x500!"];
        }
        if (newTotalAdds >= 600)
        {
            [userDefaults setBool:YES forKey:@"Add It Up x600!"];
        }
        if (newTotalAdds >= 700)
        {
            [userDefaults setBool:YES forKey:@"Add It Up x700!"];
        }
        if (newTotalAdds >= 800)
        {
            [userDefaults setBool:YES forKey:@"Add It Up x800!"];
        }
        if (newTotalAdds >= 900)
        {
            [userDefaults setBool:YES forKey:@"Add It Up x900!"];
        }
        if (newTotalAdds >= 1000)
        {
            [userDefaults setBool:YES forKey:@"Add It Up x1000!"];
        }
        
        if (countDown <= 6)
        {
            int newTotalFastAdds = [userDefaults incrementKey:@"totalFastAdds"];
            NSLog(@"Total Fast Adds: %i",newTotalFastAdds);
            
            if (newTotalFastAdds >= 25)
            {
                [userDefaults setBool:YES forKey:@"Adding At 25 Miles Per Hour!"];
            }
            if (newTotalFastAdds >= 50)
            {
                [userDefaults setBool:YES forKey:@"Adding At 50 Miles Per Hour!"];
            }
            if (newTotalFastAdds >= 100)
            {
                [userDefaults setBool:YES forKey:@"Adding At 100 Miles Per Hour!"];
            }
            if (newTotalFastAdds >= 150)
            {
                [userDefaults setBool:YES forKey:@"Adding At 150 Miles Per Hour!"];
            }
            if (newTotalFastAdds >= 200)
            {
                [userDefaults setBool:YES forKey:@"Adding At 200 Miles Per Hour!"];
            }
            if (newTotalFastAdds >= 250)
            {
                [userDefaults setBool:YES forKey:@"Adding At 250 Miles Per Hour!"];
            }
            if (newTotalFastAdds >= 300)
            {
                [userDefaults setBool:YES forKey:@"Adding At 300 Miles Per Hour!"];
            }
            if (newTotalFastAdds >= 350)
            {
                [userDefaults setBool:YES forKey:@"Adding At 350 Miles Per Hour!"];
            }
            if (newTotalFastAdds >= 400)
            {
                [userDefaults setBool:YES forKey:@"Adding At 400 Miles Per Hour!"];
            }
            if (newTotalFastAdds >= 450)
            {
                [userDefaults setBool:YES forKey:@"Adding At 450 Miles Per Hour!"];
            }
            if (newTotalFastAdds >= 500)
            {
                [userDefaults setBool:YES forKey:@"Adding At 500 Miles Per Hour!"];
            }
        }

        
    }
    else if ([_operationLabel.text isEqualToString:@"-"])
    {
        int newTotalSubs = [userDefaults incrementKey:@"totalSubs"];
        NSLog(@"newTotalSubs is: %i", newTotalSubs);
        if (newTotalSubs >= 1)
        {
            [userDefaults setBool:YES forKey:@"Take It Away!"];
        }
        if (newTotalSubs >= 20)
        {
            [userDefaults setBool:YES forKey:@"Take It Away x20!"];
        }
        if (newTotalSubs >= 50)
        {
            [userDefaults setBool:YES forKey:@"Take It Away x50!"];
        }
        if (newTotalSubs >= 100)
        {
            [userDefaults setBool:YES forKey:@"Take It Away x100!"];
        }
        if (newTotalSubs >= 200)
        {
            [userDefaults setBool:YES forKey:@"Take It Away x200!"];
        }
        if (newTotalSubs >= 300)
        {
            [userDefaults setBool:YES forKey:@"Take It Away x300!"];
        }
        if (newTotalSubs >= 400)
        {
            [userDefaults setBool:YES forKey:@"Take It Away x400!"];
        }
        if (newTotalSubs >= 500)
        {
            [userDefaults setBool:YES forKey:@"Take It Away x500!"];
        }
        if (newTotalSubs >= 600)
        {
            [userDefaults setBool:YES forKey:@"Take It Away x600!"];
        }
        if (newTotalSubs >= 700)
        {
            [userDefaults setBool:YES forKey:@"Take It Away x700!"];
        }
        if (newTotalSubs >= 800)
        {
            [userDefaults setBool:YES forKey:@"Take It Away x800!"];
        }
        if (newTotalSubs >= 900)
        {
            [userDefaults setBool:YES forKey:@"Take It Away x900!"];
        }
        if (newTotalSubs >= 1000)
        {
            [userDefaults setBool:YES forKey:@"Take It Away x1000!"];
        }
        
        if (countDown <= 6)
        {
            int newTotalFastSubs = [userDefaults incrementKey:@"totalFastSubs"];
            NSLog(@"Total Fast Subs: %i",newTotalFastSubs);
            if (newTotalFastSubs >= 25)
            {
                [userDefaults setBool:YES forKey:@"Subtracting At 25 Miles Per Hour!"];
            }
            if (newTotalFastSubs >= 50)
            {
                [userDefaults setBool:YES forKey:@"Subtracting At 50 Miles Per Hour!"];
            }
            if (newTotalFastSubs >= 100)
            {
                [userDefaults setBool:YES forKey:@"Subtracting At 100 Miles Per Hour!"];
            }
            if (newTotalFastSubs >= 150)
            {
                [userDefaults setBool:YES forKey:@"Subtracting At 150 Miles Per Hour!"];
            }
            if (newTotalFastSubs >= 200)
            {
                [userDefaults setBool:YES forKey:@"Subtracting At 200 Miles Per Hour!"];
            }
            if (newTotalFastSubs >= 250)
            {
                [userDefaults setBool:YES forKey:@"Subtracting At 250 Miles Per Hour!"];
            }
            if (newTotalFastSubs >= 300)
            {
                [userDefaults setBool:YES forKey:@"Subtracting At 300 Miles Per Hour!"];
            }
            if (newTotalFastSubs >= 350)
            {
                [userDefaults setBool:YES forKey:@"Subtracting At 350 Miles Per Hour!"];
            }
            if (newTotalFastSubs >= 400)
            {
                [userDefaults setBool:YES forKey:@"Subtracting At 400 Miles Per Hour!"];
            }
            if (newTotalFastSubs >= 450)
            {
                [userDefaults setBool:YES forKey:@"Subtracting At 450 Miles Per Hour!"];
            }
            if (newTotalFastSubs >= 500)
            {
                [userDefaults setBool:YES forKey:@"Subtracting At 500 Miles Per Hour!"];
            }
        }
        
    }
    else if ([_operationLabel.text isEqualToString:@"x"])
    {
        [userDefaults incrementKey:@"totalMults"];
    }
    else if ([_operationLabel.text isEqualToString:@"/"])
    {
        [userDefaults incrementKey:@"totalDivides"];
    }
    
    int totalMathProblems = [userDefaults integerForKey:@"totalAdds"] + [userDefaults integerForKey:@"totalSubs"];
    if (totalMathProblems >= 10)
    {
        [userDefaults setBool:YES forKey:@"Keep It Up!"];
    }
    if (totalMathProblems >= 100)
    {
        [userDefaults setBool:YES forKey:@"Keep It Up x100!"];
    }
    if (totalMathProblems >= 200)
    {
        [userDefaults setBool:YES forKey:@"Keep It Up x200!"];
    }
    if (totalMathProblems >= 300)
    {
        [userDefaults setBool:YES forKey:@"Keep It Up x300!"];
    }
    if (totalMathProblems >= 400)
    {
        [userDefaults setBool:YES forKey:@"Keep It Up x400!"];
    }
    if (totalMathProblems >= 500)
    {
        [userDefaults setBool:YES forKey:@"Keep It Up x500!"];
    }
    if (totalMathProblems >= 600)
    {
        [userDefaults setBool:YES forKey:@"Keep It Up x600!"];
    }
    if (totalMathProblems >= 700)
    {
        [userDefaults setBool:YES forKey:@"Keep It Up x700!"];
    }
    if (totalMathProblems >= 800)
    {
        [userDefaults setBool:YES forKey:@"Keep It Up x800!"];
    }
    if (totalMathProblems >= 900)
    {
        [userDefaults setBool:YES forKey:@"Keep It Up x900!"];
    }
    if (totalMathProblems >= 1000)
    {
        [userDefaults setBool:YES forKey:@"Keep It Up x1000!"];
    }
    
    
    [userDefaults synchronize];
}



-(void)giveSticker
{
    int randomSticker = arc4random()%100;
    
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
    else if (randomSticker < 70)
    {
        [userDefaults incrementKey:@"puppyCount"];
        NSLog(@"4th count +1");
    }
    else if (randomSticker < 80)
    {
        [userDefaults incrementKey:@"tigerCount"];
        NSLog(@"5th count +1");
    }
    else if (randomSticker < 90)
    {
        [userDefaults incrementKey:@"moonCount"];
        NSLog(@"6th count +1");
    }else if (randomSticker < 95)
    {
        [userDefaults incrementKey:@"giraffeCount"];
        NSLog(@"7th count +1");
    }else if (randomSticker <= 100)
    {
        [userDefaults incrementKey:@"sunCount"];
        NSLog(@"8th count +1");
    }
    
    [userDefaults synchronize];
}


-(void)wrongAnswer
{
    goButton.alpha = 0.0;
    newButton.alpha = 1.0;
    [countDownTimer invalidate];
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
