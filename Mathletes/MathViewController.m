//
//  ViewController.m
//  Mathletes
//
//  Created by Kagan Riedel on 2/7/14.
//  Copyright (c) 2014 Kagan Riedel. All rights reserved.
//

#import "MathViewController.h"
#import "MathProblem.h"
#import "CMNavBarNotificationView/CMNavBarNotificationView.h"


@interface MathViewController () <UIAlertViewDelegate>
{
    __weak IBOutlet UILabel *var1Label;
    __weak IBOutlet UILabel *var2Label;
    __weak IBOutlet UIButton *goButton;
    __weak IBOutlet UIButton *newButton;
    __weak IBOutlet UILabel *inputLabel;
    __weak IBOutlet UIButton *oneButton;
    __weak IBOutlet UIButton *twoButton;
    __weak IBOutlet UIButton *threeButton;
    __weak IBOutlet UIButton *fourButton;
    __weak IBOutlet UIButton *fiveButton;
    __weak IBOutlet UIButton *sixButton;
    __weak IBOutlet UIButton *sevenButton;
    __weak IBOutlet UIButton *eightButton;
    __weak IBOutlet UIButton *nineButton;
    __weak IBOutlet UIButton *zeroButton;
    __weak IBOutlet UIButton *backSpaceButton;
    __weak IBOutlet UILabel *feedbackLabel;
    __weak IBOutlet UIImageView *feedbackImageView;
    __weak IBOutlet UIView *feedbackView;
    __weak IBOutlet UILabel *operatorLabel;
    __weak IBOutlet UIImageView *responseImageView;
    
    
    NSMutableArray *mathProblems;
    NSInteger difficulty;
    NSInteger userArrayKey;
    NSInteger firstNonZeroKey;
    int keyAddend;
    NSInteger numkey;
    NSString *newkey;
    
    int countDown;
    NSTimer *countDownTimer;
    NSTimer *correctAnswerTimer;
    
    NSUserDefaults *userDefaults;
    PFUser *user;
}


@end

@implementation MathViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    user = [PFUser currentUser];
    
    [self buildView];
    
    NSInteger problemType;

    for (UILabel* label in self.view.subviews) {
        if([label isKindOfClass:[UILabel class]])
        {
            label.font = [UIFont fontWithName:@"Miso-Bold" size:40];
        }
    }
    
    oneButton.titleLabel.font = [UIFont fontWithName:@"Miso-Bold" size:28];
    twoButton.titleLabel.font = [UIFont fontWithName:@"Miso-Bold" size:28];
    threeButton.titleLabel.font = [UIFont fontWithName:@"Miso-Bold" size:28];
    fourButton.titleLabel.font = [UIFont fontWithName:@"Miso-Bold" size:28];
    fiveButton.titleLabel.font = [UIFont fontWithName:@"Miso-Bold" size:28];
    sixButton.titleLabel.font = [UIFont fontWithName:@"Miso-Bold" size:28];
    sevenButton.titleLabel.font = [UIFont fontWithName:@"Miso-Bold" size:28];
    eightButton.titleLabel.font = [UIFont fontWithName:@"Miso-Bold" size:28];
    nineButton.titleLabel.font = [UIFont fontWithName:@"Miso-Bold" size:28];
    zeroButton.titleLabel.font = [UIFont fontWithName:@"Miso-Bold" size:28];
    goButton.titleLabel.font = [UIFont fontWithName:@"Miso-Bold" size:28];
    newButton.titleLabel.font = [UIFont fontWithName:@"Miso-Bold" size:28];
   
    feedbackLabel.font = [UIFont fontWithName:@"Miso-Bold" size:34];
    inputLabel.font = [UIFont fontWithName:@"Miso-Bold" size:40];

    if ([_operationType isEqualToString:@"+"])
    {
        self.navigationItem.title = @"Addition";
        
        PFQuery *problemQuery = [PFQuery queryWithClassName:@"MathProblem"];
        [problemQuery whereKey:@"problemType" equalTo:@0];
        [problemQuery whereKey:@"mathUser" equalTo:[PFUser currentUser]];
        
        [problemQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
         {
             _userArray = (NSMutableArray *)objects;
             
             [self newMathProblem];
             [self startTimer];
         }];
       
        operatorLabel.textColor = [UIColor colorWithRed:130.0/255.0 green:183.0/255.0 blue:53.0/255.0 alpha:1];
        
    }
    else if ([_operationType isEqualToString:@"-"])
    {
        self.navigationItem.title = @"Subtraction";
        
        PFQuery *problemQuery = [PFQuery queryWithClassName:@"MathProblem"];
        [problemQuery whereKey:@"problemType" equalTo:@1];
        [problemQuery whereKey:@"mathUser" equalTo:[PFUser currentUser]];
        
        [problemQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
         {
             _userArray = (NSMutableArray *)objects;
             
             [self newMathProblem];
             [self startTimer];
         }];
       
        operatorLabel.textColor = [UIColor colorWithRed:222.0/255.0 green:54.0/255.0 blue:64.0/255.0 alpha:1];
    }
    else if ([_operationType isEqualToString:@"x"])
    {
        self.navigationItem.title = @"Multiplication";
        //problemType = 2;
        operatorLabel.textColor = [UIColor colorWithRed:221.0/255.0 green:168.0/255.0 blue:57.0/255.0 alpha:1];
    }
    else if ([_operationType isEqualToString:@"/"])
    {
        self.navigationItem.title = @"Division";
        //problemType = 3;
        operatorLabel.textColor = [UIColor colorWithRed:95.0/255.0 green:162.0/255.0 blue:219.0/255.0 alpha:1];
    }
    
}

- (void)buildView
{
    userDefaults = [NSUserDefaults standardUserDefaults];

    _operationLabel.text = _operationType;
    newButton.alpha = 0.0;
    feedbackView.alpha = 0.0;
    

    
    goButton.layer.cornerRadius = 35.0;
    goButton.layer.borderColor = [UIColor colorWithRed:184.0/255.0 green:184.0/255.0 blue:184.0/255.0 alpha:1].CGColor;
    
    newButton.layer.cornerRadius = 35.0;
    newButton.layer.borderColor = [UIColor colorWithRed:184.0/255.0 green:184.0/255.0 blue:184.0/255.0 alpha:1].CGColor;
    
    backSpaceButton.layer.cornerRadius = 35.0;
    backSpaceButton.layer.borderWidth = 1.5;
    backSpaceButton.layer.borderColor = [UIColor colorWithRed:184.0/255.0 green:184.0/255.0 blue:184.0/255.0 alpha:1].CGColor;
    
    zeroButton.layer.cornerRadius = 35.0;
    zeroButton.layer.borderWidth = 1.5;
    zeroButton.layer.borderColor = [UIColor colorWithRed:184.0/255.0 green:184.0/255.0 blue:184.0/255.0 alpha:1].CGColor;
    
    oneButton.layer.cornerRadius = 35.0;
    oneButton.layer.borderWidth = 1.5;
    oneButton.layer.borderColor = [UIColor colorWithRed:184.0/255.0 green:184.0/255.0 blue:184.0/255.0 alpha:1].CGColor;
    
    twoButton.layer.cornerRadius = 35.0;
    twoButton.layer.borderWidth = 1.5;
    twoButton.layer.borderColor = [UIColor colorWithRed:184.0/255.0 green:184.0/255.0 blue:184.0/255.0 alpha:1].CGColor;
    
    threeButton.layer.cornerRadius = 35.0;
    threeButton.layer.borderWidth = 1.5;
    threeButton.layer.borderColor = [UIColor colorWithRed:184.0/255.0 green:184.0/255.0 blue:184.0/255.0 alpha:1].CGColor;
    
    fourButton.layer.cornerRadius = 35.0;
    fourButton.layer.borderWidth = 1.5;
    fourButton.layer.borderColor = [UIColor colorWithRed:184.0/255.0 green:184.0/255.0 blue:184.0/255.0 alpha:1].CGColor;
    
    fiveButton.layer.cornerRadius = 35.0;
    fiveButton.layer.borderWidth = 1.5;
    fiveButton.layer.borderColor = [UIColor colorWithRed:184.0/255.0 green:184.0/255.0 blue:184.0/255.0 alpha:1].CGColor;
    
    sixButton.layer.cornerRadius = 35.0;
    sixButton.layer.borderWidth = 1.5;
    sixButton.layer.borderColor = [UIColor colorWithRed:184.0/255.0 green:184.0/255.0 blue:184.0/255.0 alpha:1].CGColor;
    
    sevenButton.layer.cornerRadius = 35.0;
    sevenButton.layer.borderWidth = 1.5;
    sevenButton.layer.borderColor = [UIColor colorWithRed:184.0/255.0 green:184.0/255.0 blue:184.0/255.0 alpha:1].CGColor;
    
    eightButton.layer.cornerRadius = 35.0;
    eightButton.layer.borderWidth = 1.5;
    eightButton.layer.borderColor = [UIColor colorWithRed:184.0/255.0 green:184.0/255.0 blue:184.0/255.0 alpha:1].CGColor;
    
    nineButton.layer.cornerRadius = 35.0;
    nineButton.layer.borderWidth = 1.5;
    nineButton.layer.borderColor = [UIColor colorWithRed:184.0/255.0 green:184.0/255.0 blue:184.0/255.0 alpha:1].CGColor;
    

    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [countDownTimer invalidate];
}

- (IBAction)onBackButtonPressed:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)startTimer
{
    countDown = 0;
    countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
}

-(void)timerFired:(NSTimer *)timer
{
    countDown ++;
    NSLog(@"%i", countDown);

    if (countDown == 10)
    {
        [countDownTimer invalidate];
        feedbackLabel.text = @"Sorry! Time is up!";
        [self wrongAnswer];
    }
}


-(void)sortingArray
{
    NSMutableArray *sortingArray = [NSMutableArray new];
    
    for (MathProblem *mp in _userArray)
    {
        [sortingArray addObject:(mp)];
    }
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"equationDifficulty" ascending:YES];
    _userArray = [sortingArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    
    for (int i = 0; i < _userArray.count; i++)
    {
        MathProblem *mp2 = _userArray[i];
        if (mp2.equationDifficulty > 0)
        {
            firstNonZeroKey = i;
            NSLog(@"%li", (long)firstNonZeroKey);
            break;
        }
    }
    
    for (int i = 0; i < _userArray.count; i++)
    {
        MathProblem *problem = _userArray[i];
        NSLog(@"%i %i %ld",(long)problem.firstValue, problem.secondValue, (long)problem.equationDifficulty);
    }
    
}

-(void)newMathProblem
{
    newButton.alpha = 0.0;
    goButton.alpha = 1.0;
    feedbackLabel.text = nil;
    inputLabel.text = @"";
    feedbackView.alpha = 0.0;
    
    [self sortingArray];
    
    if (firstNonZeroKey <= 99)
    {
        //setting pool of possible problems
        keyAddend = 40;
        
        if (firstNonZeroKey > 25)
        {
            keyAddend = 30;
            
            if (firstNonZeroKey > 50)
            {
                keyAddend = 25;
                
                if (firstNonZeroKey >= 80)
                {
                    keyAddend = 100 - firstNonZeroKey;
                    
                }
            }
        }
        
        userArrayKey = arc4random()%keyAddend + firstNonZeroKey;
        
        
        //allowing for old problems when there is a pool <= 20
        if (firstNonZeroKey > 80)
        {
            int chanceOfOldProblem = arc4random()%4;
            
            if (chanceOfOldProblem == 0)
            {
                userArrayKey = arc4random()%30 + (firstNonZeroKey - 30);
            }
        }
        
    }
    
    else
    {
        int completedProblemsChance = arc4random()%10;
        
        if (completedProblemsChance == 0)
        {
            userArrayKey = arc4random()%50;
        }
        else if (completedProblemsChance > 0 && completedProblemsChance < 5)
        {
            userArrayKey = arc4random()%25 + 50;
        }
        else
        {
            userArrayKey = arc4random()%25 + 75;
        }
    }
    
    MathProblem *mp = _userArray[userArrayKey];
    var1Label.text = [NSString stringWithFormat:@"%i",mp.firstValue];
    var2Label.text = [NSString stringWithFormat:@"%i",mp.secondValue];
}

- (IBAction)onNewButtonPressed:(id)sender
{
    [self newMathProblem];
    [self startTimer];
}

-(void)correctAnswer
{
    inputLabel.text = @"";
    feedbackView.alpha = 1.0;
    responseImageView.image = [UIImage imageNamed:@"ic_correct.png"];
    feedbackView.backgroundColor = [UIColor colorWithRed:130.0/255.0 green:183.0/255.0 blue:53.0/255.0 alpha:1.0];
    if (countDown <= 6)
    {
        //set imageview to smiley face
    }
    else
    {
        //feedbackImageView.image = [UIImage set imageview to check mark
    }
    
    
    feedbackLabel.text = @"Correct!";
    [self updateAchievements];
    
    MathProblem *problem = _userArray[userArrayKey];
    NSInteger proficiencyChange = problem.equationDifficulty;
    
    if (problem.equationDifficulty > 0 && countDown <= 6)
    {
        proficiencyChange -= 1;
    }
    
    problem.equationDifficulty = proficiencyChange;
    problem.haveAttemptedEquation = YES;
    [_userArray enumerateObjectsUsingBlock:^(MathProblem *obj, NSUInteger idx, BOOL *stop)
     {
         [obj saveInBackground];
     }];
    
    correctAnswerTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(correctAnswerTimerFired:) userInfo:nil repeats:NO];
}

-(void)correctAnswerTimerFired:(NSTimer *)timer
{
    [self newMathProblem];
    [self startTimer];
}

-(void)wrongAnswer
{
    goButton.alpha = 0.0;
    newButton.alpha = 1.0;
    responseImageView.image = [UIImage imageNamed:@"ic_wrong_face.png"];

    feedbackView.alpha = 1.0;
    feedbackView.backgroundColor = [UIColor colorWithRed:222.0/255.0 green:54.0/255.0 blue:64.0/255.0 alpha:1];
    
    
    [self addProficiencyForWrongAnswer];
}

-(void)addProficiencyForWrongAnswer
{
    MathProblem *problem = _userArray[userArrayKey];
    NSInteger proficiencyChange = problem.equationDifficulty;
    
    if (problem.equationDifficulty < 10)
    {
        proficiencyChange += 1;
    }
    
    problem.equationDifficulty = proficiencyChange;
    problem.haveAttemptedEquation = YES;
    
    [_userArray enumerateObjectsUsingBlock:^(MathProblem *obj, NSUInteger idx, BOOL *stop)
     {
         [obj saveInBackground];
     }];
}

-(void)updateAchievements
{
    if ([[user objectForKey:@"dailyMath"] intValue] == 0)
    {
        [user setObject:[NSDate date] forKey:@"dailyMathStartDate"];
    }
    
    int newDailyMath = [user increaseKey:@"dailyMath"];
    NSLog(@"newDailyMath is: %i", newDailyMath);
    if (newDailyMath >= 50)
    {
        [self checkForAchievement:@"Daily Math x50!" Minimum:1 Maximum:100];
    }
    else if (newDailyMath >= 40)
    {
        [self checkForAchievement:@"Daily Math x40!" Minimum:1 Maximum:92];
    }
    else if (newDailyMath >= 30)
    {
        [self checkForAchievement:@"Daily Math x30!" Minimum:1 Maximum:92];
    }
    else if (newDailyMath >= 20)
    {
        [self checkForAchievement:@"Daily Math x20!" Minimum:1 Maximum:60];
    }
    else if (newDailyMath >= 10)
    {
        [self checkForAchievement:@"Daily Math x10!" Minimum:1 Maximum:60];
    }
    
    if ([_operationLabel.text isEqualToString:@"+"])
    {
        int newTotalAdds = [user increaseKey:@"totalAdds"];
        NSLog(@"newTotalAdds is: %i", newTotalAdds);
        if (newTotalAdds >= 300)
        {
            [self checkForAchievement:@"Add It Up x300!" Minimum:61 Maximum:100];
        }
        else if (newTotalAdds >= 275)
        {
            [self checkForAchievement:@"Add It Up x275!" Minimum:61 Maximum:100];
        }
        else if (newTotalAdds >= 250)
        {
            [self checkForAchievement:@"Add It Up x250!" Minimum:61 Maximum:100];
        }
        else if (newTotalAdds >= 225)
        {
            [self checkForAchievement:@"Add It Up x225!" Minimum:61 Maximum:100];
        }
        else if (newTotalAdds >= 200)
        {
            [self checkForAchievement:@"Add It Up x200!" Minimum:1 Maximum:100];
        }
        else if (newTotalAdds >= 180)
        {
            [self checkForAchievement:@"Add It Up x180!" Minimum:1 Maximum:100];
        }
        else if (newTotalAdds >= 160)
        {
            [self checkForAchievement:@"Add It Up x160!" Minimum:1 Maximum:100];
        }
        else if (newTotalAdds >= 140)
        {
            [self checkForAchievement:@"Add It Up x140!" Minimum:1 Maximum:100];
        }
        else if (newTotalAdds >= 120)
        {
            [self checkForAchievement:@"Add It Up x120!" Minimum:1 Maximum:100];
        }
        else if (newTotalAdds >= 100)
        {
            [self checkForAchievement:@"Add It Up x100!" Minimum:1 Maximum:100];
        }
        else if (newTotalAdds >= 80)
        {
            [self checkForAchievement:@"Add It Up x80!" Minimum:1 Maximum:92];
        }
        else if (newTotalAdds >= 60)
        {
            [self checkForAchievement:@"Add It Up x60!" Minimum:1 Maximum:92];
        }
        else if (newTotalAdds >= 40)
        {
            [self checkForAchievement:@"Add It Up x40!" Minimum:1 Maximum:92];
        }
        else if (newTotalAdds >= 20)
        {
            [self checkForAchievement:@"Add It Up x20!" Minimum:1 Maximum:60];
        }
        else if (newTotalAdds >= 1)
        {
            [self checkForAchievement:@"Add It Up!" Minimum:1 Maximum:60];
        }
        
        if (countDown <= 6)
        {
            int newTotalFastAdds = [user increaseKey:@"totalFastAdds"];
            NSLog(@"Total Fast Adds: %i",newTotalFastAdds);
            if (newTotalFastAdds >= 250)
            {
                [self checkForAchievement:@"Adding At 250 Miles Per Hour!" Minimum:61 Maximum:100];
            }
            else if (newTotalFastAdds >= 230)
            {
                [self checkForAchievement:@"Adding At 230 Miles Per Hour!" Minimum:61 Maximum:100];
            }
            else if (newTotalFastAdds >= 210)
            {
                [self checkForAchievement:@"Adding At 210 Miles Per Hour!" Minimum:61 Maximum:100];
            }
            else if (newTotalFastAdds >= 190)
            {
                [self checkForAchievement:@"Adding At 190 Miles Per Hour!" Minimum:61 Maximum:100];
            }
            else if (newTotalFastAdds >= 170)
            {
                [self checkForAchievement:@"Adding At 170 Miles Per Hour!" Minimum:61 Maximum:100];
            }
            else if (newTotalFastAdds >= 150)
            {
                [self checkForAchievement:@"Adding At 150 Miles Per Hour!" Minimum:1 Maximum:100];
            }
            else if (newTotalFastAdds >= 135)
            {
                [self checkForAchievement:@"Adding At 135 Miles Per Hour!" Minimum:1 Maximum:100];
            }
            else if (newTotalFastAdds >= 120)
            {
                [self checkForAchievement:@"Adding At 120 Miles Per Hour!" Minimum:1 Maximum:100];
            }
            else if (newTotalFastAdds >= 105)
            {
                [self checkForAchievement:@"Adding At 105 Miles Per Hour!" Minimum:1 Maximum:100];
            }
            else if (newTotalFastAdds >= 90)
            {
                [self checkForAchievement:@"Adding At 90 Miles Per Hour!" Minimum:1 Maximum:100];
            }
            else if (newTotalFastAdds >= 75)
            {
                [self checkForAchievement:@"Adding At 75 Miles Per Hour!" Minimum:1 Maximum:100];
            }
            else if (newTotalFastAdds >= 60)
            {
                [self checkForAchievement:@"Adding At 60 Miles Per Hour!" Minimum:1 Maximum:92];
            }
            else if (newTotalFastAdds >= 45)
            {
                [self checkForAchievement:@"Adding At 45 Miles Per Hour!" Minimum:1 Maximum:92];
            }
            else if (newTotalFastAdds >= 30)
            {
                [self checkForAchievement:@"Adding At 30 Miles Per Hour!" Minimum:1 Maximum:60];
            }
            else if (newTotalFastAdds >= 15)
            {
                [self checkForAchievement:@"Adding At 15 Miles Per Hour!" Minimum:1 Maximum:60];
            }           
        }
    }
    
    else if ([_operationLabel.text isEqualToString:@"-"])
    {
        int newTotalSubs = [user increaseKey:@"totalSubs"];
        NSLog(@"newTotalSubs is: %i", newTotalSubs);
        if (newTotalSubs >= 300)
        {
            [self checkForAchievement:@"Take It Away x300!" Minimum:61 Maximum:100];
        }
        else if (newTotalSubs >= 275)
        {
            [self checkForAchievement:@"Take It Away 275!" Minimum:61 Maximum:100];
        }
        else if (newTotalSubs >= 250)
        {
            [self checkForAchievement:@"Take It Away x250!" Minimum:61 Maximum:100];
        }
        else if (newTotalSubs >= 225)
        {
            [self checkForAchievement:@"Take It Away x225!" Minimum:61 Maximum:100];
        }
        else if (newTotalSubs >= 200)
        {
            [self checkForAchievement:@"Take It Away x200!" Minimum:61 Maximum:100];
        }
        else if (newTotalSubs >= 180)
        {
            [self checkForAchievement:@"Take It Away x180!" Minimum:1 Maximum:100];
        }
        else if (newTotalSubs >= 160)
        {
            [self checkForAchievement:@"Take It Away x160!" Minimum:1 Maximum:100];
        }
        else if (newTotalSubs >= 140)
        {
            [self checkForAchievement:@"Take It Away x140!" Minimum:1 Maximum:100];
        }
        else if (newTotalSubs >= 120)
        {
            [self checkForAchievement:@"Take It Away x120!" Minimum:1 Maximum:100];
        }
        else if (newTotalSubs >= 100)
        {
            [self checkForAchievement:@"Take It Away x100!" Minimum:1 Maximum:100];
        }
        else if (newTotalSubs >= 80)
        {
            [self checkForAchievement:@"Take It Away x80!" Minimum:1 Maximum:92];
        }
        else if (newTotalSubs >= 60)
        {
            [self checkForAchievement:@"Take It Away x60!" Minimum:1 Maximum:92];
        }
        else if (newTotalSubs >= 40)
        {
            [self checkForAchievement:@"Take It Away x40!" Minimum:1 Maximum:92];
        }
        else if (newTotalSubs >= 20)
        {
            [self checkForAchievement:@"Take It Away x20!" Minimum:1 Maximum:60];
        }
        else if (newTotalSubs >= 1)
        {
            [self checkForAchievement:@"Take It Away!" Minimum:1 Maximum:60];
        }

        if (countDown <= 6)
        {
            int newTotalFastSubs = [user increaseKey:@"totalFastSubs"];
            NSLog(@"Total Fast Subs: %i",newTotalFastSubs);
            if (newTotalFastSubs >= 250)
            {
                [self checkForAchievement:@"Subtracting At 250 \nMiles Per Hour!" Minimum:61 Maximum:100];
            }
            else if (newTotalFastSubs >= 230)
            {
                [self checkForAchievement:@"Subtracting At 230 \nMiles Per Hour!" Minimum:61 Maximum:100];
            }
            else if (newTotalFastSubs >= 210)
            {
                [self checkForAchievement:@"Subtracting At 210 \nMiles Per Hour!" Minimum:61 Maximum:100];
            }
            else if (newTotalFastSubs >= 190)
            {
                [self checkForAchievement:@"Subtracting At 190 \nMiles Per Hour!" Minimum:61 Maximum:100];
            }
            else if (newTotalFastSubs >= 170)
            {
                [self checkForAchievement:@"Subtracting At 170 \nMiles Per Hour!" Minimum:61 Maximum:100];
            }
            else if (newTotalFastSubs >= 150)
            {
                [self checkForAchievement:@"Subtracting At 150 \nMiles Per Hour!" Minimum:1 Maximum:100];
            }
            else if (newTotalFastSubs >= 135)
            {
                [self checkForAchievement:@"Subtracting At 135 \nMiles Per Hour!" Minimum:1 Maximum:100];
            }
            else if (newTotalFastSubs >= 120)
            {
                [self checkForAchievement:@"Subtracting At 120 \nMiles Per Hour!" Minimum:1 Maximum:100];
            }
            else if (newTotalFastSubs >= 105)
            {
                [self checkForAchievement:@"Subtracting At 105 \nMiles Per Hour!" Minimum:1 Maximum:100];
            }
            else if (newTotalFastSubs >= 90)
            {
                [self checkForAchievement:@"Subtracting At 90 \nMiles Per Hour!" Minimum:1 Maximum:100];
            }
            else if (newTotalFastSubs >= 75)
            {
                [self checkForAchievement:@"Subtracting At 75 \nMiles Per Hour!" Minimum:1 Maximum:100];
            }
            else if (newTotalFastSubs >= 60)
            {
                [self checkForAchievement:@"Subtracting At 60 \nMiles Per Hour!" Minimum:1 Maximum:92];
            }
            else if (newTotalFastSubs >= 45)
            {
                [self checkForAchievement:@"Subtracting At 45 \nMiles Per Hour!" Minimum:1 Maximum:92];
            }
            else if (newTotalFastSubs >= 30)
            {
                [self checkForAchievement:@"Subtracting At 30 \nMiles Per Hour!" Minimum:1 Maximum:60];
            }
            else if (newTotalFastSubs >= 15)
            {
                [self checkForAchievement:@"Subtracting At 15 \nMiles Per Hour!" Minimum:1 Maximum:60];
            }
        }
    }
    
    else if ([_operationLabel.text isEqualToString:@"x"])
    {
        [user increaseKey:@"totalMults"];
    }
    else if ([_operationLabel.text isEqualToString:@"/"])
    {
        [user increaseKey:@"totalDivides"];
    }
    
    int totalMathProblems = [[user objectForKey:@"totalAdds"] intValue] + [[user objectForKey:@"totalSubs"] intValue] + [[user objectForKey:@"totalMults"] intValue] + [[user objectForKey:@"totalDivides"] intValue];
    
    if (totalMathProblems >= 1500)
    {
        [self checkForAchievement:@"Keep It Up x1500!" Minimum:93 Maximum:100];
    }
    else if (totalMathProblems >= 1400)
    {
        [self checkForAchievement:@"Keep It Up x1400!" Minimum:93 Maximum:100];
    }
    else if (totalMathProblems >= 1300)
    {
        [self checkForAchievement:@"Keep It Up x1300!" Minimum:93 Maximum:100];
    }
    else if (totalMathProblems >= 1200)
    {
        [self checkForAchievement:@"Keep It Up x1200!" Minimum:93 Maximum:100];
    }
    else if (totalMathProblems >= 1100)
    {
        [self checkForAchievement:@"Keep It Up x1100!" Minimum:93 Maximum:100];
    }
    else if (totalMathProblems >= 1000)
    {
        [self checkForAchievement:@"Keep It Up x1000!" Minimum:93 Maximum:100];
    }
    else if (totalMathProblems >= 900)
    {
        [self checkForAchievement:@"Keep It Up x900!" Minimum:61 Maximum:100];
    }
    else if (totalMathProblems >= 800)
    {
        [self checkForAchievement:@"Keep It Up x800!" Minimum:61 Maximum:100];
    }
    else if (totalMathProblems >= 700)
    {
        [self checkForAchievement:@"Keep It Up x700!" Minimum:61 Maximum:100];
    }
    else if (totalMathProblems >= 600)
    {
        [self checkForAchievement:@"Keep It Up x600!" Minimum:61 Maximum:100];
    }
    else if (totalMathProblems >= 500)
    {
        [self checkForAchievement:@"Keep It Up x500!" Minimum:61 Maximum:100];
    }
    else if (totalMathProblems >= 400)
    {
        [self checkForAchievement:@"Keep It Up x400!" Minimum:61 Maximum:100];
    }
    else if (totalMathProblems >= 300)
    {
        [self checkForAchievement:@"Keep It Up x300!" Minimum:61 Maximum:100];
    }
    else if (totalMathProblems >= 200)
    {
        [self checkForAchievement:@"Keep It Up x200!" Minimum:61 Maximum:100];
    }
    else if (totalMathProblems >= 100)
    {
        [self checkForAchievement:@"Keep It Up x100!" Minimum:61 Maximum:100];
    }
   

    [userDefaults synchronize];
}

//minimum and maximum are used to determine how rare of a sticker to give for that particular achievement
-(void)checkForAchievement:(NSString *)key Minimum:(int)minimum Maximum:(int)maximum
{
    if (![userDefaults boolForKey:key])
    {
        [userDefaults setBool:YES forKey:key];
        [self giveStickerForAchievement:[key stringByReplacingOccurrencesOfString:@"\n" withString:@""] Minimum:(int)minimum Maximum:(int)maximum];
    }
}

-(void)giveStickerForAchievement:(NSString*)achievement Minimum:(int)minimum Maximum:(int)maximum
{
    UIImage *notificationImage;
    NSString *stickerString;

    int randomSticker = arc4random()%(maximum + 1 - minimum) + minimum;
    NSLog(@"random sticker: %i", randomSticker);

    if (randomSticker <= 20)
    {
        stickerString = @"lion";
        [user increaseKey:[NSString stringWithFormat:@"%@Count", stickerString]];
        notificationImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", stickerString]];
        
        NSLog(@"%@ count +1", stickerString);
    }
    else if (randomSticker <= 40)
    {
        stickerString = @"kitten";
        [user increaseKey:[NSString stringWithFormat:@"%@Count", stickerString]];
        notificationImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", stickerString]];
        
        NSLog(@"%@ count +1", stickerString);
    }
    else if (randomSticker <= 60)
    {
        stickerString = @"campfire";
        [user increaseKey:[NSString stringWithFormat:@"%@Count", stickerString]];
        notificationImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", stickerString]];
        
        NSLog(@"%@ count +1", stickerString);
    }
    else if (randomSticker <= 70)
    {
        stickerString = @"puppy";
        [user increaseKey:[NSString stringWithFormat:@"%@Count", stickerString]];
        notificationImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", stickerString]];
        
        NSLog(@"%@ count +1", stickerString);
    }
    else if (randomSticker <= 81)
    {
        stickerString = @"tiger";
        [user increaseKey:[NSString stringWithFormat:@"%@Count", stickerString]];
        notificationImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", stickerString]];
        
        NSLog(@"%@ count +1", stickerString);
    }
    else if (randomSticker <= 92)
    {
        stickerString = @"murray";
        [user increaseKey:[NSString stringWithFormat:@"%@Count", stickerString]];
        notificationImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", stickerString]];
        
        NSLog(@"%@ count +1", stickerString);
    }
    else if (randomSticker <= 96)
    {
        stickerString = @"bear";
        [user increaseKey:[NSString stringWithFormat:@"%@Count", stickerString]];
        notificationImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", stickerString]];
        
        NSLog(@"%@ count +1", stickerString);
    }else if (randomSticker <= 100)
    {
        stickerString = @"pizza";
        [user increaseKey:[NSString stringWithFormat:@"%@Count", stickerString]];
        notificationImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", stickerString]];

        NSLog(@"%@ count +1", stickerString);
    }
    
    [CMNavBarNotificationView notifyWithText:[NSString stringWithFormat:@"%@", achievement]
                                      detail:[NSString stringWithFormat:@"You got a %@ sticker!", stickerString]
                                       image:notificationImage
                                 andDuration:3.0];
   
    [user saveInBackground];

    
    [userDefaults synchronize];

}




- (IBAction)onOneButtonPressed:(id)sender
{
    inputLabel.text = [inputLabel.text stringByAppendingString:@"1"];
}

- (IBAction)onTwoButtonPressed:(id)sender
{
    inputLabel.text = [inputLabel.text stringByAppendingString:@"2"];
}

- (IBAction)onThreeButtonPressed:(id)sender
{
   inputLabel.text = [inputLabel.text stringByAppendingString:@"3"];
}

- (IBAction)onFourButtonPressed:(id)sender
{
    inputLabel.text = [inputLabel.text stringByAppendingString:@"4"];
}

- (IBAction)onFiveButtonPressed:(id)sender
{
    inputLabel.text = [inputLabel.text stringByAppendingString:@"5"];
}

- (IBAction)onSixButtonPressed:(id)sender
{
    inputLabel.text =[inputLabel.text stringByAppendingString:@"6"];
}

- (IBAction)onSevenButtonPressed:(id)sender
{
  inputLabel.text = [inputLabel.text stringByAppendingString:@"7"];
}

- (IBAction)onEightButtonPressed:(id)sender
{
   inputLabel.text = [inputLabel.text stringByAppendingString:@"8"];
}

- (IBAction)onNineButtonPressed:(id)sender
{
   inputLabel.text = [inputLabel.text stringByAppendingString:@"9"];
}

- (IBAction)onZeroButtonPressed:(id)sender
{
    inputLabel.text = [inputLabel.text stringByAppendingString:@"0"];
}

- (IBAction)onBackSpaceButtonPressed:(id)sender
{
    inputLabel.text = [inputLabel.text substringToIndex:inputLabel.text.length-(inputLabel.text.length>0)];
}

- (IBAction)onGoButtonPressed:(id)sender
{
    if (![inputLabel.text isEqualToString:@""])
    {
        [countDownTimer invalidate];

        if ([_operationLabel.text isEqualToString:@"x"])
        {
            if (inputLabel.text.intValue == var1Label.text.intValue * var2Label.text.intValue)
            {
                [self correctAnswer];
            }
            else
            {
                feedbackLabel.text = [NSString stringWithFormat: @"%@ x %@ = %i", var1Label.text, var2Label.text, var1Label.text.intValue * var2Label.text.intValue];
                [self wrongAnswer];
            }
        }
        else if ([_operationLabel.text isEqualToString:@"/"])
        {
            if (inputLabel.text.intValue == var1Label.text.intValue / var2Label.text.intValue)
            {
                [self correctAnswer];
            }
            else
            {
                feedbackLabel.text = [NSString stringWithFormat: @"%@ / %@ = %i", var1Label.text, var2Label.text, var1Label.text.intValue / var2Label.text.intValue];
                [self wrongAnswer];
            }
        }
        else if ([_operationLabel.text isEqualToString:@"+"])
        {
            if (inputLabel.text.intValue == var1Label.text.intValue + var2Label.text.intValue)
            {
                [self correctAnswer];
            }
            else
            {
                feedbackLabel.text = [NSString stringWithFormat: @"%@ + %@ = %i", var1Label.text, var2Label.text, var1Label.text.intValue + var2Label.text.intValue];
                [self wrongAnswer];
            }
        }
        else if ([_operationLabel.text isEqualToString:@"-"])
        {
            if (inputLabel.text.intValue == var1Label.text.intValue - var2Label.text.intValue)
            {
                [self correctAnswer];
            }
            else
            {
                feedbackLabel.text = [NSString stringWithFormat: @"%@ - %@ = %i", var1Label.text, var2Label.text, var1Label.text.intValue - var2Label.text.intValue];
                [self wrongAnswer];
            }
        }
    }
}


@end
