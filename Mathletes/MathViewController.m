//
//  ViewController.m
//  Mathletes
//
//  Created by Kagan Riedel on 2/7/14.
//  Copyright (c) 2014 Kagan Riedel. All rights reserved.
//

#import "MathViewController.h"
#import "MathProblem.h"


@interface MathViewController () <UIAlertViewDelegate>
{
    __weak IBOutlet UILabel *var1Label;
    __weak IBOutlet UILabel *var2Label;
    __weak IBOutlet UIButton *goButton;
    __weak IBOutlet UIButton *newButton;
    __weak IBOutlet UIView *newStickerView;
    __weak IBOutlet UIImageView *stickerImageView;
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
}


@end

@implementation MathViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self cardDifficulty];

    if ([_operationType isEqualToString:@"+"])
    {
        self.navigationItem.title = @"Addition";
    }
    else if ([_operationType isEqualToString:@"-"])
    {
        self.navigationItem.title = @"Subtraction";
    }
    else if ([_operationType isEqualToString:@"x"])
    {
        self.navigationItem.title = @"Multiplication";
    }
    else if ([_operationType isEqualToString:@"/"])
    {
        self.navigationItem.title = @"Division";
    }
    
    _userArray = mathProblems;
    
    userDefaults = [NSUserDefaults standardUserDefaults];

    _operationLabel.text = _operationType;
    newButton.alpha = 0.0;
    feedbackView.alpha = 0.0;
    
    [self newMathProblem];
    [self startTimer];
    
    goButton.layer.cornerRadius = 35.0;
    goButton.layer.borderWidth = 1.5;
    goButton.layer.borderColor = [UIColor colorWithRed:184.0/255.0 green:184.0/255.0 blue:184.0/255.0 alpha:1].CGColor;
    
    newButton.layer.cornerRadius = 35.0;
    newButton.layer.borderWidth = 1.5;
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
    
    stickerImageView.clipsToBounds = YES;
    stickerImageView.layer.cornerRadius = 30.0;

    

    
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
    
    
    for (int i = 0; i < 100; i++)
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
        NSLog(@"%li %ld",(long)problem.mathProblemValue, (long)problem.equationDifficulty);
    }
    
}

-(void)setNewKey
{
    newkey = [NSString stringWithFormat:@"%i%i",_addend1,_addend2];
    
    numkey = newkey.intValue;
    
    [_userArray enumerateObjectsUsingBlock:^(MathProblem *problem, NSUInteger idx, BOOL *stop)
     {
         if (numkey == problem.mathProblemValue)
         {
             difficulty = problem.equationDifficulty;
             userArrayKey = idx;
         }
     }];
}

-(void)newMathProblem
{
    newStickerView.alpha = 0.0;
    newButton.alpha = 0.0;
    goButton.alpha = 1.0;
    feedbackLabel.text = nil;
    inputLabel.text = @"";
    feedbackView.alpha = 0.0;
    
    [self sortingArray];
    
    //original random value
    _addend1 = arc4random()%10;
    _addend2 = arc4random()%10;
    
    [self setNewKey];
    
    //setting pool of possible problems
    keyAddend = 40;
    
    if (firstNonZeroKey > 35)
    {
        keyAddend = 30;
        
        if (firstNonZeroKey > 50)
        {
            keyAddend = 25;
            
            if (firstNonZeroKey > 80)
            {
                keyAddend = 100 - firstNonZeroKey;
                
            }
        }
    }
    
    //rechoosing problem if proficiency is reached
    if (userArrayKey < firstNonZeroKey || userArrayKey > (firstNonZeroKey + keyAddend))
    {
        //allowing for old problems when there is a pool < 20
        if (firstNonZeroKey > 80)
        {
            int chanceOfOldProblem = arc4random()%4;
            
            if (chanceOfOldProblem == 0)
            {
                _addend1 = arc4random()%4 + 4;
                _addend2 = arc4random()%4 + 4;
                
                [self setNewKey];
            }
            else
            {
                [self newMathProblem];
            }
        }
        else
        {
            [self newMathProblem];
        }
    }
    
    
    [var1Label setText:[NSString stringWithFormat:@"%i", _addend1]];
    [var2Label setText:[NSString stringWithFormat:@"%i", _addend2]];
    
}


/*
-(void)newMathProblem
{
    feedbackLabel.text = nil;
    inputLabel.text = @"";

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
*/


- (IBAction)onNewButtonPressed:(id)sender
{
    [self newMathProblem];
    [self startTimer];
}

-(void)correctAnswer
{
    inputLabel.text = @"";
    feedbackView.alpha = 1.0;
    feedbackView.backgroundColor = [UIColor colorWithRed:151.0/255.0 green:244.0/255.0 blue:101.0/255.0 alpha:1.0];
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

    feedbackView.alpha = 1.0;
    feedbackView.backgroundColor = [UIColor redColor];
    
    //feedbackImageView.image = [UIImage set imageview to frowny face
    
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
}


-(void)cardDifficulty
{
    mathProblems = @[         [[MathProblem alloc]initWithDifficulty:2 forProblem:0],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:1],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:10],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:11],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:2],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:20],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:21],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:12],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:3],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:30],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:31],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:13],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:4],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:40],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:41],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:14],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:5],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:50],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:51],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:15],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:22],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:23],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:32],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:6],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:60],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:61],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:16],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:7],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:70],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:71],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:17],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:8],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:80],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:81],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:18],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:9],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:90],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:91],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:19],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:33],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:24],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:42],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:25],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:52],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:26],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:62],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:27],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:72],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:28],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:82],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:29],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:92],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:34],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:43],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:35],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:53],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:36],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:63],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:37],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:73],
                              [[MathProblem alloc]initWithDifficulty:6 forProblem:38],
                              [[MathProblem alloc]initWithDifficulty:6 forProblem:83],
                              [[MathProblem alloc]initWithDifficulty:6 forProblem:39],
                              [[MathProblem alloc]initWithDifficulty:6 forProblem:93],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:44],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:54],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:45],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:55],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:46],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:64],
                              [[MathProblem alloc]initWithDifficulty:6 forProblem:47],
                              [[MathProblem alloc]initWithDifficulty:6 forProblem:74],
                              [[MathProblem alloc]initWithDifficulty:6 forProblem:48],
                              [[MathProblem alloc]initWithDifficulty:6 forProblem:84],
                              [[MathProblem alloc]initWithDifficulty:6 forProblem:49],
                              [[MathProblem alloc]initWithDifficulty:6 forProblem:94],
                              [[MathProblem alloc]initWithDifficulty:6 forProblem:56],
                              [[MathProblem alloc]initWithDifficulty:6 forProblem:65],
                              [[MathProblem alloc]initWithDifficulty:6 forProblem:66],
                              [[MathProblem alloc]initWithDifficulty:6 forProblem:57],
                              [[MathProblem alloc]initWithDifficulty:6 forProblem:75],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:58],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:85],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:59],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:95],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:67],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:76],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:68],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:86],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:69],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:96],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:77],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:88],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:99],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:78],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:79],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:87],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:89],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:97],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:98]
                              ].mutableCopy;
}

-(void)updateAchievements
{
    if ([userDefaults integerForKey:@"dailyMath"] == 0)
    {
        [userDefaults setObject:[NSDate date] forKey:@"dailyMathStartDate"];
    }
    
    int newDailyMath = [userDefaults incrementKey:@"dailyMath"];
    NSLog(@"newDailyMath is: %i", newDailyMath);
    if (newDailyMath >= 50)
    {
        [self checkForAchievement:@"Daily Math x50!"];
    }
    else if (newDailyMath >= 40)
    {
        [self checkForAchievement:@"Daily Math x40!"];
    }
    else if (newDailyMath >= 30)
    {
        [self checkForAchievement:@"Daily Math x30!"];
    }
    else if (newDailyMath >= 20)
    {
        [self checkForAchievement:@"Daily Math x20!"];
    }
    else if (newDailyMath >= 10)
    {
        [self checkForAchievement:@"Daily Math!"];
    }
    
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
    
    int randomSticker = arc4random()%100;
    
    if (randomSticker < 20)
    {
        [userDefaults incrementKey:@"lionCount"];
        stickerImageView.image = [UIImage imageNamed:@"lion.png"];
        NSLog(@"1st count +1");
    }
    else if (randomSticker < 40)
    {
        [userDefaults incrementKey:@"kittenCount"];
        stickerImageView.image = [UIImage imageNamed:@"kitten.png"];
        NSLog(@"2nd count +1");
    }
    else if (randomSticker < 60)
    {
        [userDefaults incrementKey:@"starCount"];
        stickerImageView.image = [UIImage imageNamed:@"star.png"];
        NSLog(@"3rd count +1");
    }
    else if (randomSticker < 70)
    {
        [userDefaults incrementKey:@"puppyCount"];
        stickerImageView.image = [UIImage imageNamed:@"puppy.png"];
        NSLog(@"4th count +1");
    }
    else if (randomSticker < 80)
    {
        [userDefaults incrementKey:@"tigerCount"];
        stickerImageView.image = [UIImage imageNamed:@"tiger.png"];
        NSLog(@"5th count +1");
    }
    else if (randomSticker < 90)
    {
        [userDefaults incrementKey:@"murrayCount"];
        stickerImageView.image = [UIImage imageNamed:@"murray.png"];
        NSLog(@"6th count +1");
    }else if (randomSticker < 95)
    {
        [userDefaults incrementKey:@"bearCount"];
        stickerImageView.image = [UIImage imageNamed:@"bear.png"];
        NSLog(@"7th count +1");
    }else if (randomSticker <= 100)
    {
        [userDefaults incrementKey:@"pizzaCount"];
        stickerImageView.image = [UIImage imageNamed:@"pizza.png"];
        NSLog(@"8th count +1");
    }
    
    newStickerView.alpha = 1.0;
    
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
                feedbackLabel.text = [NSString stringWithFormat: @"The correct answer is %i", var1Label.text.intValue * var2Label.text.intValue];
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
                feedbackLabel.text = [NSString stringWithFormat: @"The correct answer is %i", var1Label.text.intValue / var2Label.text.intValue];
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
                feedbackLabel.text = [NSString stringWithFormat: @"The correct answer is %i", var1Label.text.intValue + var2Label.text.intValue];
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
                feedbackLabel.text = [NSString stringWithFormat: @"The correct answer is %i", var1Label.text.intValue - var2Label.text.intValue];
                [self wrongAnswer];
            }
        }
    }
}


@end
