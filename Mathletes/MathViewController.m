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
#import "BKECircularProgressView.h"


@interface MathViewController () <UIAlertViewDelegate>
{
    __weak IBOutlet UILabel *var1Label;
    __weak IBOutlet UILabel *var2Label;
    __weak IBOutlet UILabel *inputLabel;
    __weak IBOutlet UILabel *feedbackLabel;
    __weak IBOutlet UIButton *goButton;
    __weak IBOutlet UIButton *newButton;
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
    __weak IBOutlet UIView *feedbackView;
    __weak IBOutlet UIImageView *feedbackImageView;
    __weak IBOutlet UIImageView *operatorImageView;
    __weak IBOutlet UIImageView *responseImageView;
    __weak IBOutlet UIView *mathProblemView;
    UIImageView *progressImageView;
    BKECircularProgressView *progressView;
    
    NSMutableArray *mathProblems;
    NSInteger difficulty;
    NSInteger userArrayKey;
    NSInteger firstNonZeroKey;
    NSInteger problemType;
    NSInteger numkey;
    NSInteger correctAnswer;
    NSString *newkey;
    NSString *operand;
    NSTimer *countDownTimer;
    NSTimer *correctAnswerTimer;
    MathProblem *currentMathProblem;
    
    int keyAddend;
    int countDown;
    BOOL timeIsUp;
    BOOL completedProblems;
    
    NSUserDefaults *userDefaults;
    PFUser *user;
}


@end

@implementation MathViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    oneButton.exclusiveTouch = twoButton.exclusiveTouch = threeButton.exclusiveTouch = fourButton.exclusiveTouch = fiveButton.exclusiveTouch = sixButton.exclusiveTouch = sevenButton.exclusiveTouch = eightButton.exclusiveTouch = nineButton.exclusiveTouch = zeroButton.exclusiveTouch = goButton.exclusiveTouch = newButton.exclusiveTouch = backSpaceButton.exclusiveTouch = YES;
    
    user = [PFUser currentUser];
    userDefaults = [NSUserDefaults standardUserDefaults];
    
    [self buildView];

    for (UILabel* label in mathProblemView.subviews)
    {
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
    
    progressImageView = [[UIImageView alloc] initWithFrame:CGRectMake(275, 10, 35, 35)];
    progressImageView.image = [UIImage imageNamed:@"ic_correctface"];
    progressImageView.backgroundColor = [UIColor myGreenColor];
    progressImageView.clipsToBounds = YES;
    progressImageView.layer.cornerRadius = 17.5;
    [self.view insertSubview:progressImageView atIndex:0];

    
    progressView = [[BKECircularProgressView alloc] initWithFrame:CGRectMake(275, 10, 35, 35)];
    [progressView setProgressTintColor:[UIColor myBlueColor]];
    [progressView setBackgroundTintColor:[UIColor whiteColor]];
    [progressView setLineWidth:2.0f];
    [progressView setProgress:0.0f];
    [self.view insertSubview:progressView atIndex:1];
    
    completedProblems = NO;
    timeIsUp = NO;
    
    if ([_operationType isEqualToString:@"+"])
    {
        self.navigationItem.title = @"Addition";
        operatorImageView.image = [UIImage imageNamed:@"ic_addition_normal.png"];
        problemType = 0;
        [self queryForProblemType];
        if ([user objectForKey:@"completedAdditionProblems"])
        {
            completedProblems = YES;
        }
    }
    else if ([_operationType isEqualToString:@"-"])
    {
        self.navigationItem.title = @"Subtraction";
        operatorImageView.image = [UIImage imageNamed:@"ic_subtract_normal.png"];
        problemType = 1;
        [self queryForProblemType];
        if ([user objectForKey:@"completedSubtractionProblems"])
        {
            completedProblems = YES;
        }
    }
    else if ([_operationType isEqualToString:@"x"])
    {
        self.navigationItem.title = @"Multiplication";
        operatorImageView.image = [UIImage imageNamed:@"ic_multiply_normal.png"];
        problemType = 2;
        [self queryForProblemType];
        if ([user objectForKey:@"completedMultiplicationProblems"])
        {
            completedProblems = YES;
        }
    }
    else if ([_operationType isEqualToString:@"/"])
    {
        self.navigationItem.title = @"Division";
        operatorImageView.image = [UIImage imageNamed:@"ic_division_normal.png"];
        problemType = 3;
        [self queryForProblemType];
        if ([user objectForKey:@"completedDivisionProblems"])
        {
            completedProblems = YES;
        }
    }
}

// TESTING ONLY IF YOU WANT TO
//- (void)viewDidAppear:(BOOL)animated
//{
//    [NSTimer scheduledTimerWithTimeInterval:1.9 target:self selector:@selector(correctAnswer) userInfo:nil repeats:YES];
//}

-(void)queryForProblemType
{
    PFQuery *problemQuery = [PFQuery queryWithClassName:@"MathProblem"];
    //problemQuery.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [problemQuery whereKey:@"problemType" equalTo:[NSNumber numberWithInt:problemType]];
    [problemQuery whereKey:@"mathUser" equalTo:[PFUser currentUser]];
    
    [problemQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         _userArray = objects;
         
         [self startTimer];
         [self newMathProblem];
     }];
}

- (void)buildView
{
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

- (IBAction)onDoneButtonPressed:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)startTimer
{
    countDown = 0;
    countDownTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
}

-(void)timerFired:(NSTimer *)timer
{
    countDown ++;
    [progressView setProgress:countDown/120.0f];
    NSLog(@"%i", countDown);

    if (countDown == 60)
    {
        progressImageView.image = [UIImage imageNamed:@"ic_checkmark"];
    }
    if (countDown == 120)
    {
        [countDownTimer invalidate];
        [progressView setProgress:0.0f];
        timeIsUp = YES;
        feedbackLabel.text = @"Sorry! Time is up!";
        
        if ([_operationLabel.text isEqualToString:@"x"])
        {
            operand = @"x";
            correctAnswer = var1Label.text.intValue * var2Label.text.intValue;
        }
        else if ([_operationLabel.text isEqualToString:@"/"])
        {
            operand = @"/";
            correctAnswer = var1Label.text.intValue / var2Label.text.intValue;
        }
        else if ([_operationLabel.text isEqualToString:@"+"])
        {
            operand = @"+";
            correctAnswer = var1Label.text.intValue + var2Label.text.intValue;
        }
        else if ([_operationLabel.text isEqualToString:@"-"])
        {
            operand = @"-";
            correctAnswer = var1Label.text.intValue - var2Label.text.intValue;
        }

        [self printForWrongAnswer];
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
    
    firstNonZeroKey = 100;
    
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
    
}

-(void)newMathProblem
{
    [progressView setProgress:0.0f];
    progressImageView.image = [UIImage imageNamed:@"ic_correctface"];
    newButton.alpha = 0.0;
    goButton.alpha = 1.0;
    feedbackLabel.text = nil;
    inputLabel.text = @"";
    feedbackView.alpha = 0.0;
    
    [self sortingArray];
        
    if (firstNonZeroKey < 100 )
    {
        //setting pool of possible problems
        keyAddend = 40;
        
        if (firstNonZeroKey > 25)
        {
            keyAddend = 30;
            
            if (firstNonZeroKey > 50)
            {
                keyAddend = 25;
                
                if (firstNonZeroKey >= 75)
                    keyAddend = 100 - firstNonZeroKey;
                
            }
        }
        
        userArrayKey = arc4random()%keyAddend + firstNonZeroKey;
        
        
        //allowing for old problems when there is a pool <= 20
        if (firstNonZeroKey > 80)
        {
            int oldQuestionRandomness = 4;
            
            if (firstNonZeroKey > 95)
            {
                oldQuestionRandomness = 2;
            }
            int chanceOfOldProblem = arc4random()%oldQuestionRandomness;
            
            if (chanceOfOldProblem == 0)
            {
                userArrayKey = arc4random()%30 + (firstNonZeroKey - 30);
            }
        }
    }
    
    else
    {
        [self completedProblemsCheck];
        
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
    
    currentMathProblem = _userArray[userArrayKey];
    var1Label.text = [NSString stringWithFormat:@"%i",currentMathProblem.firstValue];
    var2Label.text = [NSString stringWithFormat:@"%i",currentMathProblem.secondValue];
}

-(void)completedProblemsCheck
{
    if ([_operationType isEqualToString:@"+"])
    {
        if (completedProblems == NO)
        {
            [countDownTimer invalidate];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Congratulations!" message:@"You are excellent at addition! Keep practicing to earn more stickers and achievements!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
            [user setObject:@YES forKey:@"completedAdditionProblems"];
            [userDefaults setBool:YES forKey:@"Add It All Up!"];
            completedProblems = YES;
            [self giveStickerForAchievement:@"Add It All Up!" Minimum:93 Maximum:100];
        }
    }
    else if ([_operationType isEqualToString:@"-"])
    {
        if (completedProblems == NO)
        {
            [countDownTimer invalidate];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Congratulations!" message:@"You are excellent at Subtraction! Keep practicing to earn more stickers and achievements!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
            [user setObject:@YES forKey:@"completedSubtractionProblems"];
            [userDefaults setBool:YES forKey:@"Take It All Away!"];
            completedProblems = YES;
            [self giveStickerForAchievement:@"Take It All Away!" Minimum:93 Maximum:100];
        }
    }
    else if ([_operationType isEqualToString:@"x"])
    {
        if (completedProblems == NO)
        {
            [countDownTimer invalidate];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Congratulations!" message:@"You are excellent at Multiplication! Keep practicing to earn more stickers and achievements!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
            [user setObject:@YES forKey:@"completedMultiplicationProblems"];
            [userDefaults setBool:YES forKey:@"Multiplication Magician!"];
            completedProblems = YES;
            [self giveStickerForAchievement:@"Multiplication Magician!" Minimum:93 Maximum:100];
        }
    }
    else if ([_operationType isEqualToString:@"/"])
    {
        if (completedProblems == NO)
        {
            [countDownTimer invalidate];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Congratulations!" message:@"You are excellent at Division! Keep practicing to earn more stickers and achievements!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
            [user setObject:@YES forKey:@"completedDivisionProblems"];
            [userDefaults setBool:YES forKey:@"Conquer Division!"];
            completedProblems = YES;
            [self giveStickerForAchievement:@"Conquer Division!" Minimum:93 Maximum:100];
        }
    }
    
    if ([userDefaults boolForKey:@"Add It All Up!"] && [userDefaults boolForKey:@"Take It All Away!"] && [userDefaults boolForKey:@"Multiplication Magician!"] && [userDefaults boolForKey:@"Conquer Division!"])
    {
        [countDownTimer invalidate];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Congratulations!" message:@"You are a Math Master! Keep practicing to earn more stickers and achievements!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        [user setObject:@YES forKey:@"completedAllProblems"];
        [userDefaults setBool:YES forKey:@"Math Master!"];
        [self giveStickerForAchievement:@"Math Master!" Minimum:93 Maximum:100];
    }

    [userDefaults synchronize];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self startTimer];
}

- (IBAction)onNewButtonPressed:(id)sender
{
    [self startTimer];
    [self newMathProblem];
}

-(void)correctAnswer
{
    inputLabel.text = @"";
    feedbackView.alpha = 1.0;
    feedbackView.backgroundColor = [UIColor colorWithRed:130.0/255.0 green:183.0/255.0 blue:53.0/255.0 alpha:1.0];
    if (countDown <= 60)
    {
        responseImageView.image = [UIImage imageNamed:@"ic_correctface"];
        feedbackLabel.text = @"Great!";
    }
    else
    {
        responseImageView.image = [UIImage imageNamed:@"ic_correct.png"];
        feedbackLabel.text = @"Correct!";
    }
    
    NSInteger proficiencyChange = currentMathProblem.equationDifficulty;
    
    if (currentMathProblem.equationDifficulty > 0 && countDown <= 60 && completedProblems == NO)
    {
        proficiencyChange -= 1;
    }
    
    [self updateAchievements];
    
    currentMathProblem.equationDifficulty = proficiencyChange;
    currentMathProblem.haveAttemptedEquation = YES;
    [currentMathProblem saveInBackground];
    
    correctAnswerTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(correctAnswerTimerFired:) userInfo:nil repeats:NO];
}

-(void)correctAnswerTimerFired:(NSTimer *)timer
{
    [self startTimer];
    [self newMathProblem];
}

-(void)wrongAnswer
{
    goButton.alpha = 0.0;
    newButton.alpha = 1.0;
    responseImageView.image = [UIImage imageNamed:@"ic_wrong_face.png"];

    feedbackView.alpha = 1.0;
    feedbackView.backgroundColor = [UIColor colorWithRed:222.0/255.0 green:54.0/255.0 blue:64.0/255.0 alpha:1];
    timeIsUp = NO;
    
    [self addProficiencyForWrongAnswer];
}

-(void)addProficiencyForWrongAnswer
{
    NSInteger proficiencyChange = currentMathProblem.equationDifficulty;
    
    if (currentMathProblem.equationDifficulty < 10 && completedProblems == NO)
    {
        proficiencyChange += 1;
    }
    
    currentMathProblem.equationDifficulty = proficiencyChange;
    currentMathProblem.haveAttemptedEquation = YES;
    [currentMathProblem saveInBackground];
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
        [self checkForAchievement:@"Daily Math x40!" Minimum:1 Maximum:94];
    }
    else if (newDailyMath >= 30)
    {
        [self checkForAchievement:@"Daily Math x30!" Minimum:1 Maximum:94];
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
            [self checkForAchievement:@"Add It Up x80!" Minimum:1 Maximum:94];
        }
        else if (newTotalAdds >= 60)
        {
            [self checkForAchievement:@"Add It Up x60!" Minimum:1 Maximum:94];
        }
        else if (newTotalAdds >= 40)
        {
            [self checkForAchievement:@"Add It Up x40!" Minimum:1 Maximum:94];
        }
        else if (newTotalAdds >= 20)
        {
            [self checkForAchievement:@"Add It Up x20!" Minimum:1 Maximum:60];
        }
        else if (newTotalAdds >= 1)
        {
            [self checkForAchievement:@"Add It Up!" Minimum:1 Maximum:60];
        }
        
        if (countDown <= 60)
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
                [self checkForAchievement:@"Adding At 60 Miles Per Hour!" Minimum:1 Maximum:94];
            }
            else if (newTotalFastAdds >= 45)
            {
                [self checkForAchievement:@"Adding At 45 Miles Per Hour!" Minimum:1 Maximum:94];
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
            [self checkForAchievement:@"Take It Away x80!" Minimum:1 Maximum:94];
        }
        else if (newTotalSubs >= 60)
        {
            [self checkForAchievement:@"Take It Away x60!" Minimum:1 Maximum:94];
        }
        else if (newTotalSubs >= 40)
        {
            [self checkForAchievement:@"Take It Away x40!" Minimum:1 Maximum:94];
        }
        else if (newTotalSubs >= 20)
        {
            [self checkForAchievement:@"Take It Away x20!" Minimum:1 Maximum:60];
        }
        else if (newTotalSubs >= 1)
        {
            [self checkForAchievement:@"Take It Away!" Minimum:1 Maximum:60];
        }

        if (countDown <= 60)
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
                [self checkForAchievement:@"Subtracting At 60 \nMiles Per Hour!" Minimum:1 Maximum:94];
            }
            else if (newTotalFastSubs >= 45)
            {
                [self checkForAchievement:@"Subtracting At 45 \nMiles Per Hour!" Minimum:1 Maximum:94];
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
        int newTotalMults = [user increaseKey:@"totalMults"];
        NSLog(@"Total Mults: %i",newTotalMults);

        if (newTotalMults >= 300)
        {
            [self checkForAchievement:@"Multiplicity x300!" Minimum:61 Maximum:100];
        }
        else if (newTotalMults >= 275)
        {
            [self checkForAchievement:@"Multiplicity 275!" Minimum:61 Maximum:100];
        }
        else if (newTotalMults >= 250)
        {
            [self checkForAchievement:@"Multiplicity x250!" Minimum:61 Maximum:100];
        }
        else if (newTotalMults >= 225)
        {
            [self checkForAchievement:@"Multiplicity x225!" Minimum:61 Maximum:100];
        }
        else if (newTotalMults >= 200)
        {
            [self checkForAchievement:@"Multiplicity x200!" Minimum:61 Maximum:100];
        }
        else if (newTotalMults >= 180)
        {
            [self checkForAchievement:@"Multiplicity x180!" Minimum:1 Maximum:100];
        }
        else if (newTotalMults >= 160)
        {
            [self checkForAchievement:@"Multiplicity x160!" Minimum:1 Maximum:100];
        }
        else if (newTotalMults >= 140)
        {
            [self checkForAchievement:@"Multiplicity x140!" Minimum:1 Maximum:100];
        }
        else if (newTotalMults >= 120)
        {
            [self checkForAchievement:@"Multiplicity x120!" Minimum:1 Maximum:100];
        }
        else if (newTotalMults >= 100)
        {
            [self checkForAchievement:@"Multiplicity x100!" Minimum:1 Maximum:100];
        }
        else if (newTotalMults >= 80)
        {
            [self checkForAchievement:@"Multiplicity x80!" Minimum:1 Maximum:94];
        }
        else if (newTotalMults >= 60)
        {
            [self checkForAchievement:@"Multiplicity x60!" Minimum:1 Maximum:94];
        }
        else if (newTotalMults >= 40)
        {
            [self checkForAchievement:@"Multiplicity x40!" Minimum:1 Maximum:94];
        }
        else if (newTotalMults >= 20)
        {
            [self checkForAchievement:@"Multiplicity x20!" Minimum:1 Maximum:60];
        }
        else if (newTotalMults >= 1)
        {
            [self checkForAchievement:@"Multiplicity!" Minimum:1 Maximum:60];
        }
        if (countDown <= 60)
        {
            int newTotalFastMults = [user increaseKey:@"totalFastMults"];
            NSLog(@"Total Fast Mults: %i",newTotalFastMults);
            if (newTotalFastMults >= 250)
            {
                [self checkForAchievement:@"Multiplying At 250 \nMiles Per Hour!" Minimum:61 Maximum:100];
            }
            else if (newTotalFastMults >= 230)
            {
                [self checkForAchievement:@"Multiplying At 230 \nMiles Per Hour!" Minimum:61 Maximum:100];
            }
            else if (newTotalFastMults >= 210)
            {
                [self checkForAchievement:@"Multiplying At 210 \nMiles Per Hour!" Minimum:61 Maximum:100];
            }
            else if (newTotalFastMults >= 190)
            {
                [self checkForAchievement:@"Multiplying At 190 \nMiles Per Hour!" Minimum:61 Maximum:100];
            }
            else if (newTotalFastMults >= 170)
            {
                [self checkForAchievement:@"Multiplying At 170 \nMiles Per Hour!" Minimum:61 Maximum:100];
            }
            else if (newTotalFastMults >= 150)
            {
                [self checkForAchievement:@"Multiplying At 150 \nMiles Per Hour!" Minimum:1 Maximum:100];
            }
            else if (newTotalFastMults >= 135)
            {
                [self checkForAchievement:@"Multiplying At 135 \nMiles Per Hour!" Minimum:1 Maximum:100];
            }
            else if (newTotalFastMults >= 120)
            {
                [self checkForAchievement:@"Multiplying At 120 \nMiles Per Hour!" Minimum:1 Maximum:100];
            }
            else if (newTotalFastMults >= 105)
            {
                [self checkForAchievement:@"Multiplying At 105 \nMiles Per Hour!" Minimum:1 Maximum:100];
            }
            else if (newTotalFastMults >= 90)
            {
                [self checkForAchievement:@"Multiplying At 90 \nMiles Per Hour!" Minimum:1 Maximum:100];
            }
            else if (newTotalFastMults >= 75)
            {
                [self checkForAchievement:@"Multiplying At 75 \nMiles Per Hour!" Minimum:1 Maximum:100];
            }
            else if (newTotalFastMults >= 60)
            {
                [self checkForAchievement:@"Multiplying At 60 \nMiles Per Hour!" Minimum:1 Maximum:94];
            }
            else if (newTotalFastMults >= 45)
            {
                [self checkForAchievement:@"Multiplying At 45 \nMiles Per Hour!" Minimum:1 Maximum:94];
            }
            else if (newTotalFastMults >= 30)
            {
                [self checkForAchievement:@"Multiplying At 30 \nMiles Per Hour!" Minimum:1 Maximum:60];
            }
            else if (newTotalFastMults >= 15)
            {
                [self checkForAchievement:@"Multiplying At 15 \nMiles Per Hour!" Minimum:1 Maximum:60];
            }
        }
    }
    else if ([_operationLabel.text isEqualToString:@"/"])
    {
        int newTotalDivides = [user increaseKey:@"totalDivides"];
        NSLog(@"Total Divides: %i",newTotalDivides);
        
        if (newTotalDivides >= 300)
        {
            [self checkForAchievement:@"Divide And Conquer x300!" Minimum:61 Maximum:100];
        }
        else if (newTotalDivides >= 275)
        {
            [self checkForAchievement:@"Divide And Conquer 275!" Minimum:61 Maximum:100];
        }
        else if (newTotalDivides >= 250)
        {
            [self checkForAchievement:@"Divide And Conquer x250!" Minimum:61 Maximum:100];
        }
        else if (newTotalDivides >= 225)
        {
            [self checkForAchievement:@"Divide And Conquer x225!" Minimum:61 Maximum:100];
        }
        else if (newTotalDivides >= 200)
        {
            [self checkForAchievement:@"Divide And Conquer x200!" Minimum:61 Maximum:100];
        }
        else if (newTotalDivides >= 180)
        {
            [self checkForAchievement:@"Divide And Conquer x180!" Minimum:1 Maximum:100];
        }
        else if (newTotalDivides >= 160)
        {
            [self checkForAchievement:@"Divide And Conquer x160!" Minimum:1 Maximum:100];
        }
        else if (newTotalDivides >= 140)
        {
            [self checkForAchievement:@"Divide And Conquer x140!" Minimum:1 Maximum:100];
        }
        else if (newTotalDivides >= 120)
        {
            [self checkForAchievement:@"Divide And Conquer x120!" Minimum:1 Maximum:100];
        }
        else if (newTotalDivides >= 100)
        {
            [self checkForAchievement:@"Divide And Conquer x100!" Minimum:1 Maximum:100];
        }
        else if (newTotalDivides >= 80)
        {
            [self checkForAchievement:@"Divide And Conquer x80!" Minimum:1 Maximum:94];
        }
        else if (newTotalDivides >= 60)
        {
            [self checkForAchievement:@"Divide And Conquer x60!" Minimum:1 Maximum:94];
        }
        else if (newTotalDivides >= 40)
        {
            [self checkForAchievement:@"Divide And Conquer x40!" Minimum:1 Maximum:94];
        }
        else if (newTotalDivides >= 20)
        {
            [self checkForAchievement:@"Divide And Conquer x20!" Minimum:1 Maximum:60];
        }
        else if (newTotalDivides >= 1)
        {
            [self checkForAchievement:@"Divide And Conquer!" Minimum:1 Maximum:60];
        }
        if (countDown <= 60)
        {
            int newTotalFastDivides = [user increaseKey:@"totalFastDivides"];
            NSLog(@"Total Fast Mults: %i",newTotalFastDivides);
            if (newTotalFastDivides >= 250)
            {
                [self checkForAchievement:@"Dividing At 250 \nMiles Per Hour!" Minimum:61 Maximum:100];
            }
            else if (newTotalFastDivides >= 230)
            {
                [self checkForAchievement:@"Dividing At 230 \nMiles Per Hour!" Minimum:61 Maximum:100];
            }
            else if (newTotalFastDivides >= 210)
            {
                [self checkForAchievement:@"Dividing At 210 \nMiles Per Hour!" Minimum:61 Maximum:100];
            }
            else if (newTotalFastDivides >= 190)
            {
                [self checkForAchievement:@"Dividing At 190 \nMiles Per Hour!" Minimum:61 Maximum:100];
            }
            else if (newTotalFastDivides >= 170)
            {
                [self checkForAchievement:@"Dividing At 170 \nMiles Per Hour!" Minimum:61 Maximum:100];
            }
            else if (newTotalFastDivides >= 150)
            {
                [self checkForAchievement:@"Dividing At 150 \nMiles Per Hour!" Minimum:1 Maximum:100];
            }
            else if (newTotalFastDivides >= 135)
            {
                [self checkForAchievement:@"Dividing At 135 \nMiles Per Hour!" Minimum:1 Maximum:100];
            }
            else if (newTotalFastDivides >= 120)
            {
                [self checkForAchievement:@"Dividing At 120 \nMiles Per Hour!" Minimum:1 Maximum:100];
            }
            else if (newTotalFastDivides >= 105)
            {
                [self checkForAchievement:@"Dividing At 105 \nMiles Per Hour!" Minimum:1 Maximum:100];
            }
            else if (newTotalFastDivides >= 90)
            {
                [self checkForAchievement:@"Dividing At 90 \nMiles Per Hour!" Minimum:1 Maximum:100];
            }
            else if (newTotalFastDivides >= 75)
            {
                [self checkForAchievement:@"Dividing At 75 \nMiles Per Hour!" Minimum:1 Maximum:100];
            }
            else if (newTotalFastDivides >= 60)
            {
                [self checkForAchievement:@"Dividing At 60 \nMiles Per Hour!" Minimum:1 Maximum:94];
            }
            else if (newTotalFastDivides >= 45)
            {
                [self checkForAchievement:@"Dividing At 45 \nMiles Per Hour!" Minimum:1 Maximum:94];
            }
            else if (newTotalFastDivides >= 30)
            {
                [self checkForAchievement:@"Dividing At 30 \nMiles Per Hour!" Minimum:1 Maximum:60];
            }
            else if (newTotalFastDivides >= 15)
            {
                [self checkForAchievement:@"Dividing At 15 \nMiles Per Hour!" Minimum:1 Maximum:60];
            }
        }
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

    NSArray *stickerArray = [NSArray stickerArray];
    //common
    if (randomSticker <= 5)
    {
        stickerString = stickerArray[0];
        [user increaseKey:[NSString stringWithFormat:@"%@Count", stickerString]];
        notificationImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", stickerString]];
    }
    else if (randomSticker <= 10)
    {
        stickerString = stickerArray[1];
        [user increaseKey:[NSString stringWithFormat:@"%@Count", stickerString]];
        notificationImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", stickerString]];
    }
    else if (randomSticker <= 15)
    {
        stickerString = stickerArray[2];
        [user increaseKey:[NSString stringWithFormat:@"%@Count", stickerString]];
        notificationImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", stickerString]];
    }
    else if (randomSticker <= 20)
    {
        stickerString = stickerArray[3];
        [user increaseKey:[NSString stringWithFormat:@"%@Count", stickerString]];
        notificationImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", stickerString]];
    }
    else if (randomSticker <= 25)
    {
        stickerString = stickerArray[4];
        [user increaseKey:[NSString stringWithFormat:@"%@Count", stickerString]];
        notificationImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", stickerString]];
    }
    else if (randomSticker <= 30)
    {
        stickerString = stickerArray[5];
        [user increaseKey:[NSString stringWithFormat:@"%@Count", stickerString]];
        notificationImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", stickerString]];
    }
    else if (randomSticker <= 35)
    {
        stickerString = stickerArray[6];
        [user increaseKey:[NSString stringWithFormat:@"%@Count", stickerString]];
        notificationImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", stickerString]];
    }
    else if (randomSticker <= 40)
    {
        stickerString = stickerArray[7];
        [user increaseKey:[NSString stringWithFormat:@"%@Count", stickerString]];
        notificationImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", stickerString]];
    }
    else if (randomSticker <= 45)
    {
        stickerString = stickerArray[8];
        [user increaseKey:[NSString stringWithFormat:@"%@Count", stickerString]];
        notificationImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", stickerString]];
    }
    else if (randomSticker <= 50)
    {
        stickerString = stickerArray[9];
        [user increaseKey:[NSString stringWithFormat:@"%@Count", stickerString]];
        notificationImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", stickerString]];
    }
    else if (randomSticker <= 55)
    {
        stickerString = stickerArray[10];
        [user increaseKey:[NSString stringWithFormat:@"%@Count", stickerString]];
        notificationImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", stickerString]];
    }
    else if (randomSticker <= 60)
    {
        stickerString = stickerArray[11];
        [user increaseKey:[NSString stringWithFormat:@"%@Count", stickerString]];
        notificationImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", stickerString]];
    }
    //uncommon
    else if (randomSticker <= 64)
    {
        stickerString = stickerArray[12];
        [user increaseKey:[NSString stringWithFormat:@"%@Count", stickerString]];
        notificationImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", stickerString]];
    }
    else if (randomSticker <=68)
    {
        stickerString = stickerArray[13];
        [user increaseKey:[NSString stringWithFormat:@"%@Count", stickerString]];
        notificationImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", stickerString]];
    }
    else if (randomSticker <= 72)
    {
        stickerString = stickerArray[14];
        [user increaseKey:[NSString stringWithFormat:@"%@Count", stickerString]];
        notificationImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", stickerString]];
    }
    else if (randomSticker <= 76)
    {
        stickerString = stickerArray[15];
        [user increaseKey:[NSString stringWithFormat:@"%@Count", stickerString]];
        notificationImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", stickerString]];
    }
    else if (randomSticker <= 80)
    {
        stickerString = stickerArray[16];
        [user increaseKey:[NSString stringWithFormat:@"%@Count", stickerString]];
        notificationImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", stickerString]];
    }
    else if (randomSticker <= 84)
    {
        stickerString = stickerArray[17];
        [user increaseKey:[NSString stringWithFormat:@"%@Count", stickerString]];
        notificationImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", stickerString]];
    }
    else if (randomSticker <= 88)
    {
        stickerString = stickerArray[18];
        [user increaseKey:[NSString stringWithFormat:@"%@Count", stickerString]];
        notificationImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", stickerString]];
    }
    else if (randomSticker <= 91)
    {
        stickerString = stickerArray[19];
        [user increaseKey:[NSString stringWithFormat:@"%@Count", stickerString]];
        notificationImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", stickerString]];
    }
    else if (randomSticker <= 94)
    {
        stickerString = stickerArray[20];
        [user increaseKey:[NSString stringWithFormat:@"%@Count", stickerString]];
        notificationImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", stickerString]];
    }
    //rare
    else if (randomSticker <= 96)
    {
        stickerString = stickerArray[21];
        [user increaseKey:[NSString stringWithFormat:@"%@Count", stickerString]];
        notificationImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", stickerString]];
    }
    else if (randomSticker <= 98)
    {
        stickerString = stickerArray[22];
        [user increaseKey:[NSString stringWithFormat:@"%@Count", stickerString]];
        notificationImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", stickerString]];
    }
    else if (randomSticker <= 100)
    {
        stickerString = stickerArray[23];
        [user increaseKey:[NSString stringWithFormat:@"%@Count", stickerString]];
        notificationImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", stickerString]];
    }
    
    NSString *firstCharacterString = [stickerString substringToIndex:1];
    NSString *aOrAnString = @"a";
    if ([firstCharacterString isEqualToString:@"A"] || [firstCharacterString isEqualToString:@"E"] || [firstCharacterString isEqualToString:@"I"] || [firstCharacterString isEqualToString:@"O"] || [firstCharacterString isEqualToString:@"U"])
    {
        aOrAnString = @"an";
    }
    NSString *removedUnderscoresString = [stickerString stringByReplacingOccurrencesOfString:@"_" withString:@" "];
    
    [CMNavBarNotificationView notifyWithText:[NSString stringWithFormat:@"%@", achievement]
                                      detail:[NSString stringWithFormat:@"You got %@ %@ sticker!", aOrAnString, removedUnderscoresString]
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
            operand = @"x";
            
            if (inputLabel.text.intValue == var1Label.text.intValue * var2Label.text.intValue)
            {
                [self correctAnswer];
            }
            else
            {
                correctAnswer = var1Label.text.intValue * var2Label.text.intValue;
                [self printForWrongAnswer];
            }
        }
        else if ([_operationLabel.text isEqualToString:@"/"])
        {
            operand = @"/";
            if (inputLabel.text.intValue == var1Label.text.intValue / var2Label.text.intValue)
            {
                [self correctAnswer];
            }
            else
            {
                correctAnswer = var1Label.text.intValue / var2Label.text.intValue;
                [self printForWrongAnswer];
            }
        }
        else if ([_operationLabel.text isEqualToString:@"+"])
        {
            operand = @"+";
            if (inputLabel.text.intValue == var1Label.text.intValue + var2Label.text.intValue)
            {
                [self correctAnswer];
            }
            else
            {
                correctAnswer = var1Label.text.intValue + var2Label.text.intValue;
                [self printForWrongAnswer];
            }
        }
        else if ([_operationLabel.text isEqualToString:@"-"])
        {
            operand = @"-";
            if (inputLabel.text.intValue == var1Label.text.intValue - var2Label.text.intValue)
            {
                [self correctAnswer];
            }
            else
            {
                correctAnswer = var1Label.text.intValue - var2Label.text.intValue;
                [self printForWrongAnswer];
            }
        }
    }
}


-(void)printForWrongAnswer
{
    if (timeIsUp == YES)
    {
        feedbackLabel.text = [NSString stringWithFormat: @"Time is up!  %@ %@ %@ = %i", var1Label.text, operand, var2Label.text, correctAnswer];
    }
    else
    {
        feedbackLabel.text = [NSString stringWithFormat: @"%@ %@ %@ = %i", var1Label.text, operand, var2Label.text, correctAnswer];
    }
    
    [self wrongAnswer];
}

@end
