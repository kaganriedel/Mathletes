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
    __weak IBOutlet UIView *newAchievementView;
    
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
    newButton.alpha = 0.0;
    newAchievementView.alpha = 0.0;
    
    [self newMathProblem];
    [self startTimer];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

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
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Time Is Up!" message:@"Oops! Next problem" delegate:self cancelButtonTitle:@"Next" otherButtonTitles:nil];
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
    goButton.alpha = 0.0;
    newButton.alpha = 1.0;
    newButton.backgroundColor = [UIColor yellowColor];
    [self updateAchievements];
}

-(void)updateAchievements
{
    if ([_operationLabel.text isEqualToString:@"+"])
    {
        int newTotalAdds = [userDefaults incrementKey:@"totalAdds"];
        NSLog(@"newTotalAdds is: %i", newTotalAdds);
        if (newTotalAdds >= 1200)
        {
            [self checkForAchievement:@"Add It Up x1200!"];
        }
        else if (newTotalAdds >= 1100)
        {
            [self checkForAchievement:@"Add It Up x1100!"];
        }
        else if (newTotalAdds >= 1000)
        {
            [self checkForAchievement:@"Add It Up x1000!"];
        }
        else if (newTotalAdds >= 900)
        {
            [self checkForAchievement:@"Add It Up x900!"];
        }
        else if (newTotalAdds >= 800)
        {
            [self checkForAchievement:@"Add It Up x800!"];
        }
        else if (newTotalAdds >= 700)
        {
            [self checkForAchievement:@"Add It Up x700!"];
        }
        else if (newTotalAdds >= 600)
        {
            [self checkForAchievement:@"Add It Up x600!"];
        }
        else if (newTotalAdds >= 500)
        {
            [self checkForAchievement:@"Add It Up x500!"];
        }
        else if (newTotalAdds >= 400)
        {
            [self checkForAchievement:@"Add It Up x400!"];
        }
        else if (newTotalAdds >= 300)
        {
            [self checkForAchievement:@"Add It Up x300!"];
        }
        else if (newTotalAdds >= 200)
        {
            [self checkForAchievement:@"Add It Up x200!"];
        }
        else if (newTotalAdds >= 100)
        {
            [self checkForAchievement:@"Add It Up x100!"];
        }
        else if (newTotalAdds >= 50)
        {
            [self checkForAchievement:@"Add It Up x50!"];
        }
        else if (newTotalAdds >= 20)
        {
            [self checkForAchievement:@"Add It Up x20!"];
        }
        else if (newTotalAdds >= 1)
        {
            [self checkForAchievement:@"Add It Up!"];
        }
        
        if (countDown <= 6)
        {
            int newTotalFastAdds = [userDefaults incrementKey:@"totalFastAdds"];
            NSLog(@"Total Fast Adds: %i",newTotalFastAdds);
            if (newTotalFastAdds >= 700)
            {
                [self checkForAchievement:@"Adding At 700 Miles Per Hour!"];
            }
            else if (newTotalFastAdds >= 650)
            {
                [self checkForAchievement:@"Adding At 650 Miles Per Hour!"];
            }
            else if (newTotalFastAdds >= 600)
            {
                [self checkForAchievement:@"Adding At 600 Miles Per Hour!"];
            }
            else if (newTotalFastAdds >= 550)
            {
                [self checkForAchievement:@"Adding At 500 Miles Per Hour!"];
            }
            else if (newTotalFastAdds >= 500)
            {
                [self checkForAchievement:@"Adding At 500 Miles Per Hour!"];
            }
            else if (newTotalFastAdds >= 450)
            {
                [self checkForAchievement:@"Adding At 450 Miles Per Hour!"];
            }
            else if (newTotalFastAdds >= 400)
            {
                [self checkForAchievement:@"Adding At 400 Miles Per Hour!"];
            }
            else if (newTotalFastAdds >= 350)
            {
                [self checkForAchievement:@"Adding At 350 Miles Per Hour!"];
            }
            else if (newTotalFastAdds >= 300)
            {
                [self checkForAchievement:@"Adding At 300 Miles Per Hour!"];
            }
            else if (newTotalFastAdds >= 250)
            {
                [self checkForAchievement:@"Adding At 250 Miles Per Hour!"];
            }
            else if (newTotalFastAdds >= 200)
            {
                [self checkForAchievement:@"Adding At 200 Miles Per Hour!"];
            }
            else if (newTotalFastAdds >= 150)
            {
                [self checkForAchievement:@"Adding At 150 Miles Per Hour!"];
            }
            else if (newTotalFastAdds >= 100)
            {
                [self checkForAchievement:@"Adding At 100 Miles Per Hour!"];
            }
            else if (newTotalFastAdds >= 50)
            {
                [self checkForAchievement:@"Adding At 50 Miles Per Hour!"];
            }
            else if (newTotalFastAdds >= 25)
            {
                [self checkForAchievement:@"Adding At 25 Miles Per Hour!"];
            }           
        }
    }
    
    else if ([_operationLabel.text isEqualToString:@"-"])
    {
        int newTotalSubs = [userDefaults incrementKey:@"totalSubs"];
        NSLog(@"newTotalSubs is: %i", newTotalSubs);
        if (newTotalSubs >= 1200)
        {
            [self checkForAchievement:@"Take It Away x1200!"];
        }
        else if (newTotalSubs >= 1100)
        {
            [self checkForAchievement:@"Take It Away 1100!"];
        }
        else if (newTotalSubs >= 1000)
        {
            [self checkForAchievement:@"Take It Away x1000!"];
        }
        else if (newTotalSubs >= 900)
        {
            [self checkForAchievement:@"Take It Away x900!"];
        }
        else if (newTotalSubs >= 800)
        {
            [self checkForAchievement:@"Take It Away x800!"];
        }
        else if (newTotalSubs >= 700)
        {
            [self checkForAchievement:@"Take It Away x700!"];
        }
        else if (newTotalSubs >= 600)
        {
            [self checkForAchievement:@"Take It Away x600!"];
        }
        else if (newTotalSubs >= 500)
        {
            [self checkForAchievement:@"Take It Away x500!"];
        }
        else if (newTotalSubs >= 400)
        {
            [self checkForAchievement:@"Take It Away x400!"];
        }
        else if (newTotalSubs >= 300)
        {
            [self checkForAchievement:@"Take It Away x300!"];
        }
        else if (newTotalSubs >= 200)
        {
            [self checkForAchievement:@"Take It Away x200!"];
        }
        else if (newTotalSubs >= 100)
        {
            [self checkForAchievement:@"Take It Away x100!"];
        }
        else if (newTotalSubs >= 50)
        {
            [self checkForAchievement:@"Take It Away x50!"];
        }
        else if (newTotalSubs >= 20)
        {
            [self checkForAchievement:@"Take It Away x20!"];
        }
        else if (newTotalSubs >= 1)
        {
            [self checkForAchievement:@"Take It Away!"];
        }

        if (countDown <= 6)
        {
            int newTotalFastSubs = [userDefaults incrementKey:@"totalFastSubs"];
            NSLog(@"Total Fast Subs: %i",newTotalFastSubs);
            if (newTotalFastSubs >= 700)
            {
                [self checkForAchievement:@"Subtracting At 700 \nMiles Per Hour!"];
            }
            else if (newTotalFastSubs >= 650)
            {
                [self checkForAchievement:@"Subtracting At 650 \nMiles Per Hour!"];
            }
            else if (newTotalFastSubs >= 600)
            {
                [self checkForAchievement:@"Subtracting At 600 \nMiles Per Hour!"];
            }
            else if (newTotalFastSubs >= 550)
            {
                [self checkForAchievement:@"Subtracting At 550 \nMiles Per Hour!"];
            }
            else if (newTotalFastSubs >= 500)
            {
                [self checkForAchievement:@"Subtracting At 500 \nMiles Per Hour!"];
            }
            else if (newTotalFastSubs >= 450)
            {
                [self checkForAchievement:@"Subtracting At 450 \nMiles Per Hour!"];
            }
            else if (newTotalFastSubs >= 400)
            {
                [self checkForAchievement:@"Subtracting At 400 \nMiles Per Hour!"];
            }
            else if (newTotalFastSubs >= 350)
            {
                [self checkForAchievement:@"Subtracting At 350 \nMiles Per Hour!"];
            }
            else if (newTotalFastSubs >= 300)
            {
                [self checkForAchievement:@"Subtracting At 300 \nMiles Per Hour!"];
            }
            else if (newTotalFastSubs >= 250)
            {
                [self checkForAchievement:@"Subtracting At 250 \nMiles Per Hour!"];
            }
            else if (newTotalFastSubs >= 200)
            {
                [self checkForAchievement:@"Subtracting At 200 \nMiles Per Hour!"];
            }
            else if (newTotalFastSubs >= 150)
            {
                [self checkForAchievement:@"Subtracting At 150 \nMiles Per Hour!"];
            }
            else if (newTotalFastSubs >= 100)
            {
                [self checkForAchievement:@"Subtracting At 100 \nMiles Per Hour!"];
            }
            else if (newTotalFastSubs >= 50)
            {
                [self checkForAchievement:@"Subtracting At 50 \nMiles Per Hour!"];
            }
            else if (newTotalFastSubs >= 25)
            {
                [self checkForAchievement:@"Subtracting At 25 \nMiles Per Hour!"];
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
    if (totalMathProblems >= 1400)
    {
        [self checkForAchievement:@"Keep It Up x1400!"];
    }
    else if (totalMathProblems >= 1300)
    {
        [self checkForAchievement:@"Keep It Up x1300!"];
    }
    else if (totalMathProblems >= 1200)
    {
        [self checkForAchievement:@"Keep It Up x1200!"];
    }
    else if (totalMathProblems >= 1100)
    {
        [self checkForAchievement:@"Keep It Up x1100!"];
    }
    else if (totalMathProblems >= 1000)
    {
        [self checkForAchievement:@"Keep It Up x1000!"];
    }
    else if (totalMathProblems >= 900)
    {
        [self checkForAchievement:@"Keep It Up x900!"];
    }
    else if (totalMathProblems >= 800)
    {
        [self checkForAchievement:@"Keep It Up x800!"];
    }
    else if (totalMathProblems >= 700)
    {
        [self checkForAchievement:@"Keep It Up x700!"];
    }
    else if (totalMathProblems >= 600)
    {
        [self checkForAchievement:@"Keep It Up x600!"];
    }
    else if (totalMathProblems >= 500)
    {
        [self checkForAchievement:@"Keep It Up x500!"];
    }
    else if (totalMathProblems >= 400)
    {
        [self checkForAchievement:@"Keep It Up x400!"];
    }
    else if (totalMathProblems >= 300)
    {
        [self checkForAchievement:@"Keep It Up x300!"];
    }
    else if (totalMathProblems >= 200)
    {
        [self checkForAchievement:@"Keep It Up x200!"];
    }
    else if (totalMathProblems >= 100)
    {
        [self checkForAchievement:@"Keep It Up x100!"];
    }
    else if (totalMathProblems >= 10)
    {
        [self checkForAchievement:@"Keep It Up!"];
    }

    [userDefaults synchronize];
}

-(void)checkForAchievement:(NSString *)key
{
    if (![userDefaults boolForKey:key])
    {
        [userDefaults setBool:YES forKey:key];
        [self giveSticker];
    }
}

-(void)giveSticker
{
    newAchievementView.alpha = 1.0;
    [UIView animateWithDuration:4.0 animations:^{
        newAchievementView.alpha = 0.0;
    }];
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
    newButton.backgroundColor = [UIColor redColor];
}

- (IBAction)onGoButtonPressed:(id)sender
{
    if (![answerTextField.text isEqualToString:@""])
    {
        [countDownTimer invalidate];

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
