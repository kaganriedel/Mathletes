//
//  ProfileViewController.m
//  Mathletes
//
//  Created by Kagan Riedel on 2/7/14.
//  Copyright (c) 2014 Kagan Riedel. All rights reserved.
//

#import "ProfileViewController.h"
#import "Parse/Parse.h"
#import "MathProblem.h"


@interface ProfileViewController () <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>
{
    NSUserDefaults *userDefaults;
    NSMutableArray *MathProblems;

    __weak IBOutlet UIButton *profileButton;
    __weak IBOutlet UIImageView *profileImageView;
    __weak IBOutlet UILabel *profileLabel;
    __weak IBOutlet UIButton *mathButton;
    __weak IBOutlet UIButton *progressButton;
    __weak IBOutlet UIButton *stickersButton;
    __weak IBOutlet UIButton *achievementsButton;
    
    
    
}

@end

@implementation ProfileViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
   
    
    //set title and font of nav bar
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor], NSForegroundColorAttributeName, [UIFont fontWithName:@"Miso-Bold" size:28], NSFontAttributeName, nil]];
    
    //set color of bar button item
    [self.navigationController.navigationBar setTintColor:[UIColor darkGrayColor]];
    
    //set back button color
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor], NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    

    
    mathButton.titleLabel.font = [UIFont fontWithName:@"Miso-Bold" size:48];
    progressButton.titleLabel.font = [UIFont fontWithName:@"Miso-Bold" size:48];
    stickersButton.titleLabel.font = [UIFont fontWithName:@"Miso-Bold" size:48];
    achievementsButton.titleLabel.font = [UIFont fontWithName:@"Miso-Bold" size:48];
    
    userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSLog(@"time since dailyMathStartDate: %f", [[NSDate date] timeIntervalSinceDate:[userDefaults objectForKey:@"dailyMathStartDate"]]);
    //if its been more than a day since the last reset of dailyMath, reset it
    if ([[NSDate date] timeIntervalSinceDate:[userDefaults objectForKey:@"dailyMathStartDate"]] >= 86400.0)
    {
        
        
        [userDefaults setInteger:0 forKey:@"dailyMath"];
        [userDefaults setBool:NO forKey:@"dailyMath!"];
        [userDefaults setBool:NO forKey:@"dailyMath x20!"];
        [userDefaults setBool:NO forKey:@"dailyMath x30!"];
        [userDefaults setBool:NO forKey:@"dailyMath x40!"];
        [userDefaults setBool:NO forKey:@"dailyMath x50!"];
        [userDefaults synchronize];
    }
    
    for (UILabel* label in self.view.subviews) {
        if([label isKindOfClass:[UILabel class]])
        {
            label.font = [UIFont fontWithName:@"Miso-Bold" size:48];
        }
    }
    
    NSLog(@"dailyMath is: %li", (long)[userDefaults integerForKey:@"dailyMath"]);

    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
   
    profileButton.layer.cornerRadius = 50;
    profileButton.contentMode = UIViewContentModeScaleToFill;
    profileImageView.layer.cornerRadius = 50;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    if ([userDefaults objectForKey:@"profileImage"])
    {
        [profileButton setImage:[UIImage imageNamed:[userDefaults objectForKey:@"profileImage"]] forState:UIControlStateNormal];
    }
    else
    {
    [profileButton setImage:[UIImage imageNamed:@"boy.png"] forState:UIControlStateNormal];
    }


    [self setTitle];
}
-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self checkForLoggedInUserAnimated:animated];
}

-(void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user
{
//    self.view.backgroundColor = [UIColor colorWithPatternImage:
//                                 [UIImage imageNamed:@"math_login_screen_brand.png"]];
    _userArray = [self cardDifficulty];
    _subtractionUserArray = [self subtractionDifficulty];
    
    [_userArray enumerateObjectsUsingBlock:^(MathProblem *obj, NSUInteger idx, BOOL *stop)
     {
         [obj saveInBackground];
     }];
    
    [_subtractionUserArray enumerateObjectsUsingBlock:^(MathProblem *obj, NSUInteger idx, BOOL *stop)
     {
         [obj saveInBackground];
     }];
    
    [signUpController dismissViewControllerAnimated:YES completion:^
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    //receive their first sticker and set it to their profile pic
}

-(void)setTitle
{
    NSString *username = [PFUser currentUser].username;
    NSString *cappedFirstChar = [[username substringToIndex:1] uppercaseString];
    NSString *cappedString = [username stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:cappedFirstChar];
    profileLabel.text = cappedString;
}

-(void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user
{
    [logInController dismissViewControllerAnimated:YES completion:nil];
   
    
}

- (IBAction)onLogOut:(id)sender
{
    [PFUser logOut];
    
    [userDefaults removePersistentDomainForName:[NSBundle mainBundle].bundleIdentifier];
    [userDefaults synchronize];
    
    [self checkForLoggedInUserAnimated:YES];
}



-(void)checkForLoggedInUserAnimated:(BOOL)animated
{
    if (![PFUser currentUser])
    {
        PFLogInViewController *login = [PFLogInViewController new];
        login.delegate = self;
        login.signUpController.delegate = self;
        [self presentViewController:login animated:animated completion:nil];
    }
}

-(NSMutableArray *)cardDifficulty
{
    return @[         [[MathProblem alloc]initWithDifficulty:2 ofProblemType:0 forFirstValue:0 forSecondValue:0],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:0 forFirstValue:0 forSecondValue:1],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:0 forFirstValue:1 forSecondValue:0],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:0 forFirstValue:1 forSecondValue:1],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:0 forFirstValue:0 forSecondValue:2],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:0 forFirstValue:2 forSecondValue:0],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:0 forFirstValue:2 forSecondValue:1],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:0 forFirstValue:1 forSecondValue:2],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:0 forFirstValue:0 forSecondValue:3],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:0 forFirstValue:3 forSecondValue:0],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:0 forFirstValue:3 forSecondValue:1],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:0 forFirstValue:1 forSecondValue:3],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:0 forFirstValue:0 forSecondValue:4],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:0 forFirstValue:4 forSecondValue:0],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:0 forFirstValue:4 forSecondValue:1],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:0 forFirstValue:1 forSecondValue:4],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:0 forFirstValue:0 forSecondValue:5],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:0 forFirstValue:5 forSecondValue:0],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:0 forFirstValue:5 forSecondValue:1],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:0 forFirstValue:1 forSecondValue:5],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:0 forFirstValue:2 forSecondValue:2],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:0 forFirstValue:2 forSecondValue:3],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:0 forFirstValue:3 forSecondValue:2],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:0 forFirstValue:0 forSecondValue:6],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:0 forFirstValue:6 forSecondValue:0],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:0 forFirstValue:6 forSecondValue:1],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:0 forFirstValue:1 forSecondValue:6],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:0 forFirstValue:0 forSecondValue:7],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:0 forFirstValue:7 forSecondValue:0],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:0 forFirstValue:7 forSecondValue:1],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:0 forFirstValue:1 forSecondValue:7],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:0 forFirstValue:0 forSecondValue:8],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:0 forFirstValue:8 forSecondValue:0],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:0 forFirstValue:8 forSecondValue:1],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:0 forFirstValue:1 forSecondValue:8],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:0 forFirstValue:0 forSecondValue:9],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:0 forFirstValue:9 forSecondValue:0],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:0 forFirstValue:9 forSecondValue:1],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:0 forFirstValue:1 forSecondValue:9],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:0 forFirstValue:3 forSecondValue:3],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:0 forFirstValue:2 forSecondValue:4],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:0 forFirstValue:4 forSecondValue:2],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:0 forFirstValue:2 forSecondValue:5],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:0 forFirstValue:5 forSecondValue:2],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:0 forFirstValue:2 forSecondValue:6],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:0 forFirstValue:6 forSecondValue:2],
                              [[MathProblem alloc]initWithDifficulty:4 ofProblemType:0 forFirstValue:2 forSecondValue:7],
                              [[MathProblem alloc]initWithDifficulty:4 ofProblemType:0 forFirstValue:7 forSecondValue:2],
                              [[MathProblem alloc]initWithDifficulty:4 ofProblemType:0 forFirstValue:2 forSecondValue:8],
                              [[MathProblem alloc]initWithDifficulty:4 ofProblemType:0 forFirstValue:8 forSecondValue:2],
                              [[MathProblem alloc]initWithDifficulty:4 ofProblemType:0 forFirstValue:2 forSecondValue:9],
                              [[MathProblem alloc]initWithDifficulty:4 ofProblemType:0 forFirstValue:9 forSecondValue:2],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:0 forFirstValue:3 forSecondValue:4],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:0 forFirstValue:4 forSecondValue:3],
                              [[MathProblem alloc]initWithDifficulty:4 ofProblemType:0 forFirstValue:3 forSecondValue:5],
                              [[MathProblem alloc]initWithDifficulty:4 ofProblemType:0 forFirstValue:5 forSecondValue:3],
                              [[MathProblem alloc]initWithDifficulty:4 ofProblemType:0 forFirstValue:3 forSecondValue:6],
                              [[MathProblem alloc]initWithDifficulty:4 ofProblemType:0 forFirstValue:6 forSecondValue:3],
                              [[MathProblem alloc]initWithDifficulty:4 ofProblemType:0 forFirstValue:3 forSecondValue:7],
                              [[MathProblem alloc]initWithDifficulty:4 ofProblemType:0 forFirstValue:7 forSecondValue:3],
                              [[MathProblem alloc]initWithDifficulty:6 ofProblemType:0 forFirstValue:3 forSecondValue:8],
                              [[MathProblem alloc]initWithDifficulty:6 ofProblemType:0 forFirstValue:8 forSecondValue:3],
                              [[MathProblem alloc]initWithDifficulty:6 ofProblemType:0 forFirstValue:3 forSecondValue:9],
                              [[MathProblem alloc]initWithDifficulty:6 ofProblemType:0 forFirstValue:9 forSecondValue:3],
                              [[MathProblem alloc]initWithDifficulty:4 ofProblemType:0 forFirstValue:4 forSecondValue:4],
                              [[MathProblem alloc]initWithDifficulty:4 ofProblemType:0 forFirstValue:5 forSecondValue:4],
                              [[MathProblem alloc]initWithDifficulty:4 ofProblemType:0 forFirstValue:4 forSecondValue:5],
                              [[MathProblem alloc]initWithDifficulty:4 ofProblemType:0 forFirstValue:5 forSecondValue:5],
                              [[MathProblem alloc]initWithDifficulty:4 ofProblemType:0 forFirstValue:4 forSecondValue:6],
                              [[MathProblem alloc]initWithDifficulty:4 ofProblemType:0 forFirstValue:6 forSecondValue:4],
                              [[MathProblem alloc]initWithDifficulty:6 ofProblemType:0 forFirstValue:4 forSecondValue:7],
                              [[MathProblem alloc]initWithDifficulty:6 ofProblemType:0 forFirstValue:7 forSecondValue:4],
                              [[MathProblem alloc]initWithDifficulty:6 ofProblemType:0 forFirstValue:4 forSecondValue:8],
                              [[MathProblem alloc]initWithDifficulty:6 ofProblemType:0 forFirstValue:8 forSecondValue:4],
                              [[MathProblem alloc]initWithDifficulty:6 ofProblemType:0 forFirstValue:4 forSecondValue:9],
                              [[MathProblem alloc]initWithDifficulty:6 ofProblemType:0 forFirstValue:9 forSecondValue:4],
                              [[MathProblem alloc]initWithDifficulty:6 ofProblemType:0 forFirstValue:5 forSecondValue:6],
                              [[MathProblem alloc]initWithDifficulty:6 ofProblemType:0 forFirstValue:6 forSecondValue:5],
                              [[MathProblem alloc]initWithDifficulty:6 ofProblemType:0 forFirstValue:6 forSecondValue:6],
                              [[MathProblem alloc]initWithDifficulty:6 ofProblemType:0 forFirstValue:5 forSecondValue:7],
                              [[MathProblem alloc]initWithDifficulty:6 ofProblemType:0 forFirstValue:7 forSecondValue:5],
                              [[MathProblem alloc]initWithDifficulty:8 ofProblemType:0 forFirstValue:5 forSecondValue:8],
                              [[MathProblem alloc]initWithDifficulty:8 ofProblemType:0 forFirstValue:8 forSecondValue:5],
                              [[MathProblem alloc]initWithDifficulty:8 ofProblemType:0 forFirstValue:5 forSecondValue:9],
                              [[MathProblem alloc]initWithDifficulty:8 ofProblemType:0 forFirstValue:9 forSecondValue:5],
                              [[MathProblem alloc]initWithDifficulty:8 ofProblemType:0 forFirstValue:6 forSecondValue:7],
                              [[MathProblem alloc]initWithDifficulty:8 ofProblemType:0 forFirstValue:7 forSecondValue:6],
                              [[MathProblem alloc]initWithDifficulty:8 ofProblemType:0 forFirstValue:6 forSecondValue:8],
                              [[MathProblem alloc]initWithDifficulty:8 ofProblemType:0 forFirstValue:8 forSecondValue:6],
                              [[MathProblem alloc]initWithDifficulty:8 ofProblemType:0 forFirstValue:6 forSecondValue:9],
                              [[MathProblem alloc]initWithDifficulty:8 ofProblemType:0 forFirstValue:9 forSecondValue:6],
                              [[MathProblem alloc]initWithDifficulty:8 ofProblemType:0 forFirstValue:7 forSecondValue:7],
                              [[MathProblem alloc]initWithDifficulty:8 ofProblemType:0 forFirstValue:8 forSecondValue:8],
                              [[MathProblem alloc]initWithDifficulty:8 ofProblemType:0 forFirstValue:9 forSecondValue:9],
                              [[MathProblem alloc]initWithDifficulty:8 ofProblemType:0 forFirstValue:7 forSecondValue:8],
                              [[MathProblem alloc]initWithDifficulty:8 ofProblemType:0 forFirstValue:7 forSecondValue:9],
                              [[MathProblem alloc]initWithDifficulty:8 ofProblemType:0 forFirstValue:8 forSecondValue:7],
                              [[MathProblem alloc]initWithDifficulty:8 ofProblemType:0 forFirstValue:8 forSecondValue:9],
                              [[MathProblem alloc]initWithDifficulty:8 ofProblemType:0 forFirstValue:9 forSecondValue:7],
                              [[MathProblem alloc]initWithDifficulty:8 ofProblemType:0 forFirstValue:9 forSecondValue:8]
                              ].mutableCopy;
}

-(NSMutableArray *)subtractionDifficulty
{
    return  @[                [[MathProblem alloc]initWithDifficulty:2 ofProblemType:1 forFirstValue:0 forSecondValue:0],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:1 forFirstValue:1 forSecondValue:0],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:1 forFirstValue:1 forSecondValue:1],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:1 forFirstValue:2 forSecondValue:0],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:1 forFirstValue:2 forSecondValue:1],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:1 forFirstValue:2 forSecondValue:2],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:1 forFirstValue:3 forSecondValue:0],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:1 forFirstValue:3 forSecondValue:3],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:1 forFirstValue:3 forSecondValue:1],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:1 forFirstValue:3 forSecondValue:2],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:1 forFirstValue:4 forSecondValue:0],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:1 forFirstValue:4 forSecondValue:4],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:1 forFirstValue:4 forSecondValue:1],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:1 forFirstValue:4 forSecondValue:3],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:1 forFirstValue:4 forSecondValue:2],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:1 forFirstValue:5 forSecondValue:0],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:1 forFirstValue:5 forSecondValue:5],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:1 forFirstValue:5 forSecondValue:1],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:1 forFirstValue:5 forSecondValue:4],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:1 forFirstValue:6 forSecondValue:0],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:1 forFirstValue:6 forSecondValue:6],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:1 forFirstValue:6 forSecondValue:1],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:1 forFirstValue:6 forSecondValue:5],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:1 forFirstValue:7 forSecondValue:0],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:1 forFirstValue:7 forSecondValue:7],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:1 forFirstValue:7 forSecondValue:1],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:1 forFirstValue:7 forSecondValue:6],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:1 forFirstValue:8 forSecondValue:7],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:1 forFirstValue:8 forSecondValue:0],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:1 forFirstValue:8 forSecondValue:8],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:1 forFirstValue:9 forSecondValue:8],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:1 forFirstValue:9 forSecondValue:0],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:1 forFirstValue:9 forSecondValue:9],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:1 forFirstValue:8 forSecondValue:1],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:1 forFirstValue:9 forSecondValue:1],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:1 forFirstValue:5 forSecondValue:2],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:1 forFirstValue:5 forSecondValue:3],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:1 forFirstValue:6 forSecondValue:2],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:1 forFirstValue:6 forSecondValue:4],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:1 forFirstValue:6 forSecondValue:3],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:1 forFirstValue:10 forSecondValue:1],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:1 forFirstValue:7 forSecondValue:2],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:1 forFirstValue:8 forSecondValue:2],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:1 forFirstValue:7 forSecondValue:3],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:1 forFirstValue:10 forSecondValue:9],
                              [[MathProblem alloc]initWithDifficulty:4 ofProblemType:1 forFirstValue:9 forSecondValue:2],
                              [[MathProblem alloc]initWithDifficulty:4 ofProblemType:1 forFirstValue:9 forSecondValue:7],
                              [[MathProblem alloc]initWithDifficulty:4 ofProblemType:1 forFirstValue:10 forSecondValue:2],
                              [[MathProblem alloc]initWithDifficulty:4 ofProblemType:1 forFirstValue:11 forSecondValue:2],
                              [[MathProblem alloc]initWithDifficulty:4 ofProblemType:1 forFirstValue:7 forSecondValue:5],
                              [[MathProblem alloc]initWithDifficulty:4 ofProblemType:1 forFirstValue:8 forSecondValue:5],
                              [[MathProblem alloc]initWithDifficulty:4 ofProblemType:1 forFirstValue:9 forSecondValue:5],
                              [[MathProblem alloc]initWithDifficulty:4 ofProblemType:1 forFirstValue:10 forSecondValue:5],
                              [[MathProblem alloc]initWithDifficulty:4 ofProblemType:1 forFirstValue:8 forSecondValue:3],
                              [[MathProblem alloc]initWithDifficulty:4 ofProblemType:1 forFirstValue:9 forSecondValue:3],
                              [[MathProblem alloc]initWithDifficulty:4 ofProblemType:1 forFirstValue:8 forSecondValue:6],
                              [[MathProblem alloc]initWithDifficulty:4 ofProblemType:1 forFirstValue:9 forSecondValue:6],
                              [[MathProblem alloc]initWithDifficulty:4 ofProblemType:1 forFirstValue:10 forSecondValue:3],
                              [[MathProblem alloc]initWithDifficulty:4 ofProblemType:1 forFirstValue:11 forSecondValue:3],
                              [[MathProblem alloc]initWithDifficulty:4 ofProblemType:1 forFirstValue:12 forSecondValue:3],
                              [[MathProblem alloc]initWithDifficulty:4 ofProblemType:1 forFirstValue:7 forSecondValue:4],
                              [[MathProblem alloc]initWithDifficulty:4 ofProblemType:1 forFirstValue:8 forSecondValue:4],
                              [[MathProblem alloc]initWithDifficulty:4 ofProblemType:1 forFirstValue:9 forSecondValue:4],
                              [[MathProblem alloc]initWithDifficulty:4 ofProblemType:1 forFirstValue:10 forSecondValue:4],
                              [[MathProblem alloc]initWithDifficulty:4 ofProblemType:1 forFirstValue:10 forSecondValue:8],
                              [[MathProblem alloc]initWithDifficulty:4 ofProblemType:1 forFirstValue:11 forSecondValue:9],
                              [[MathProblem alloc]initWithDifficulty:6 ofProblemType:1 forFirstValue:12 forSecondValue:9],
                              [[MathProblem alloc]initWithDifficulty:6 ofProblemType:1 forFirstValue:10 forSecondValue:6],
                              [[MathProblem alloc]initWithDifficulty:6 ofProblemType:1 forFirstValue:13 forSecondValue:4],
                              [[MathProblem alloc]initWithDifficulty:6 ofProblemType:1 forFirstValue:11 forSecondValue:6],
                              [[MathProblem alloc]initWithDifficulty:6 ofProblemType:1 forFirstValue:12 forSecondValue:6],
                              [[MathProblem alloc]initWithDifficulty:6 ofProblemType:1 forFirstValue:10 forSecondValue:7],
                              [[MathProblem alloc]initWithDifficulty:6 ofProblemType:1 forFirstValue:11 forSecondValue:7],
                              [[MathProblem alloc]initWithDifficulty:6 ofProblemType:1 forFirstValue:11 forSecondValue:8],
                              [[MathProblem alloc]initWithDifficulty:6 ofProblemType:1 forFirstValue:12 forSecondValue:4],
                              [[MathProblem alloc]initWithDifficulty:6 ofProblemType:1 forFirstValue:12 forSecondValue:5],
                              [[MathProblem alloc]initWithDifficulty:6 ofProblemType:1 forFirstValue:11 forSecondValue:5],
                              [[MathProblem alloc]initWithDifficulty:6 ofProblemType:1 forFirstValue:12 forSecondValue:7],
                              [[MathProblem alloc]initWithDifficulty:6 ofProblemType:1 forFirstValue:11 forSecondValue:4],
                              [[MathProblem alloc]initWithDifficulty:6 ofProblemType:1 forFirstValue:12 forSecondValue:8],
                              [[MathProblem alloc]initWithDifficulty:8 ofProblemType:1 forFirstValue:14 forSecondValue:7],
                              [[MathProblem alloc]initWithDifficulty:8 ofProblemType:1 forFirstValue:16 forSecondValue:8],
                              [[MathProblem alloc]initWithDifficulty:8 ofProblemType:1 forFirstValue:18 forSecondValue:9],
                              [[MathProblem alloc]initWithDifficulty:8 ofProblemType:1 forFirstValue:13 forSecondValue:9],
                              [[MathProblem alloc]initWithDifficulty:8 ofProblemType:1 forFirstValue:13 forSecondValue:5],
                              [[MathProblem alloc]initWithDifficulty:8 ofProblemType:1 forFirstValue:13 forSecondValue:8],
                              [[MathProblem alloc]initWithDifficulty:8 ofProblemType:1 forFirstValue:13 forSecondValue:7],
                              [[MathProblem alloc]initWithDifficulty:8 ofProblemType:1 forFirstValue:13 forSecondValue:6],
                              [[MathProblem alloc]initWithDifficulty:8 ofProblemType:1 forFirstValue:14 forSecondValue:9],
                              [[MathProblem alloc]initWithDifficulty:8 ofProblemType:1 forFirstValue:14 forSecondValue:5],
                              [[MathProblem alloc]initWithDifficulty:8 ofProblemType:1 forFirstValue:14 forSecondValue:6],
                              [[MathProblem alloc]initWithDifficulty:8 ofProblemType:1 forFirstValue:14 forSecondValue:8],
                              [[MathProblem alloc]initWithDifficulty:8 ofProblemType:1 forFirstValue:15 forSecondValue:6],
                              [[MathProblem alloc]initWithDifficulty:8 ofProblemType:1 forFirstValue:15 forSecondValue:9],
                              [[MathProblem alloc]initWithDifficulty:8 ofProblemType:1 forFirstValue:15 forSecondValue:8],
                              [[MathProblem alloc]initWithDifficulty:8 ofProblemType:1 forFirstValue:15 forSecondValue:7],
                              [[MathProblem alloc]initWithDifficulty:8 ofProblemType:1 forFirstValue:16 forSecondValue:9],
                              [[MathProblem alloc]initWithDifficulty:8 ofProblemType:1 forFirstValue:16 forSecondValue:7],
                              [[MathProblem alloc]initWithDifficulty:8 ofProblemType:1 forFirstValue:17 forSecondValue:9],
                              [[MathProblem alloc]initWithDifficulty:8 ofProblemType:1 forFirstValue:17 forSecondValue:8]
                              ].mutableCopy;
    
}



@end
