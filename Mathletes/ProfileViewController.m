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
#import "CMNavBarNotificationView/CMNavBarNotificationView.h"


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
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor], NSForegroundColorAttributeName, [UIFont fontWithName:@"Miso-Bold" size:26], NSFontAttributeName, nil]];
    
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
    
    PFUser *user = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"AcceptedTrade"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for (PFObject *acceptedTrade in objects) {
            [user increaseKey:[NSString stringWithFormat:@"%@Count",[acceptedTrade objectForKey:@"get"]]];
            [CMNavBarNotificationView notifyWithText:@"Your trade was accepted!"
                                              detail:[NSString stringWithFormat:@"You got a %@ sticker!", [acceptedTrade objectForKey:@"get"]]
                                               image:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[acceptedTrade objectForKey:@"get"]]]
                                         andDuration:3.0];
            [acceptedTrade deleteInBackground];
        }
        [user saveInBackground];
    }];
    
    
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
    return @[         [[MathProblem alloc]initWithDifficulty:2 forProblem:0 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:1 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:10 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:11 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:2 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:20 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:21 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:12 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:3 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:30 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:31 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:13 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:4 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:40 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:41 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:14 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:5 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:50 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:51 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:15 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:22 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:23 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:32 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:6 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:60 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:61 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:16 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:7 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:70 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:71 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:17 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:8 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:80 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:81 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:18 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:9 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:90 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:91 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:19 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:33 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:24 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:42 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:25 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:52 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:26 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:62 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:27 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:72 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:28 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:82 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:29 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:92 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:34 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:43 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:35 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:53 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:36 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:63 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:37 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:73 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:6 forProblem:38 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:6 forProblem:83 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:6 forProblem:39 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:6 forProblem:93 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:44 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:54 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:45 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:55 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:46 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:64 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:6 forProblem:47 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:6 forProblem:74 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:6 forProblem:48 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:6 forProblem:84 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:6 forProblem:49 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:6 forProblem:94 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:6 forProblem:56 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:6 forProblem:65 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:6 forProblem:66 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:6 forProblem:57 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:6 forProblem:75 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:58 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:85 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:59 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:95 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:67 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:76 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:68 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:86 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:69 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:96 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:77 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:88 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:99 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:78 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:79 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:87 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:89 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:97 ofProblemType:0],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:98 ofProblemType:0]
                              ].mutableCopy;
}

-(NSMutableArray *)subtractionDifficulty
{
    return  @[                [[MathProblem alloc]initWithDifficulty:2 forProblem:0 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:10 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:11 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:20 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:21 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:22 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:30 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:33 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:31 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:32 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:40 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:44 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:41 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:43 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:42 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:50 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:55 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:51 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:54 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:60 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:66 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:61 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:65 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:70 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:77 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:71 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:76 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:87 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:80 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:88 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:98 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:90 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:99 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:81 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:91 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:52 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:53 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:62 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:64 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:63 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:101 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:72 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:82 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:73 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:2 forProblem:109 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:92 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:97 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:102 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:112 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:75 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:85 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:95 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:105 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:83 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:93 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:86 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:96 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:103 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:113 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:123 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:74 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:84 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:94 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:104 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:108 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:4 forProblem:119 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:6 forProblem:114 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:6 forProblem:124 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:6 forProblem:134 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:6 forProblem:115 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:6 forProblem:125 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:135 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:145 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:6 forProblem:106 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:6 forProblem:116 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:6 forProblem:126 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:136 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:146 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:156 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:6 forProblem:107 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:6 forProblem:117 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:6 forProblem:127 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:137 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:147 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:157 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:167 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:6 forProblem:118 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:6 forProblem:128 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:138 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:148 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:158 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:168 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:178 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:6 forProblem:129 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:139 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:149 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:159 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:169 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:179 ofProblemType:1],
                              [[MathProblem alloc]initWithDifficulty:8 forProblem:189 ofProblemType:1]
                              ].mutableCopy;
    
}



@end
