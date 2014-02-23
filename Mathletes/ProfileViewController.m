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
    PFUser *user;
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
   
    userDefaults = [NSUserDefaults standardUserDefaults];
    user = [PFUser currentUser];
    
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
    
    
    NSLog(@"time since dailyMathStartDate: %f", [[NSDate date] timeIntervalSinceDate:[user objectForKey:@"dailyMathStartDate"]]);
    //if its been more than a day since the last reset of dailyMath, reset it
    if ([[NSDate date] timeIntervalSinceDate:[user objectForKey:@"dailyMathStartDate"]] >= 86400.0)
    {
        [user setObject:0 forKey:@"dailyMath"];
        
        [userDefaults setBool:NO forKey:@"dailyMath x10!"];
        [userDefaults setBool:NO forKey:@"dailyMath x20!"];
        [userDefaults setBool:NO forKey:@"dailyMath x30!"];
        [userDefaults setBool:NO forKey:@"dailyMath x40!"];
        [userDefaults setBool:NO forKey:@"dailyMath x50!"];
        
        [user saveInBackground];
        [userDefaults synchronize];
    }
    
    for (UILabel* label in self.view.subviews) {
        if([label isKindOfClass:[UILabel class]])
        {
            label.font = [UIFont fontWithName:@"Miso-Bold" size:48];
        }
    }
    
    NSLog(@"dailyMath is: %i", [[user objectForKey:@"dailyMath"] intValue]);

    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
   
    profileButton.layer.cornerRadius = 50;
    profileImageView.layer.cornerRadius = 50;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hey Testers!" message:@"If your app is crashing or acting funny, log out and create a new user. We're changing the way users work constantly so sometimes old users don't work. Thanks for testing our app!" delegate:nil cancelButtonTitle:@"On To The Math!" otherButtonTitles: nil];
    [alert show];
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [self setProfileImage];

    [self setTitle];
}
-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self checkForLoggedInUserAnimated:animated];
    
}

-(void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user
{
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

-(void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)loggedInUser
{
    [logInController dismissViewControllerAnimated:YES completion:nil];
    user = loggedInUser;
    [self setProfileImage];
}

-(void)setProfileImage
{
    if ([user objectForKey:@"profileImage"])
    {
        [profileButton setImage:[UIImage imageNamed:[user objectForKey:@"profileImage"]] forState:UIControlStateNormal];
    }
    else
    {
        [profileButton setImage:[UIImage imageNamed:@"boy.png"] forState:UIControlStateNormal];
    }
}

-(void)setTitle
{
    NSString *username = [PFUser currentUser].username;
    NSString *cappedFirstChar = [[username substringToIndex:1] uppercaseString];
    NSString *cappedString = [username stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:cappedFirstChar];
    profileLabel.text = cappedString;
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
    else
    {
        
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
