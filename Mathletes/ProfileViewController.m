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
    NSMutableArray *mathProblems;

    __weak IBOutlet UIButton *profileButton;
    __weak IBOutlet UIImageView *profileImageView;
}

@end

@implementation ProfileViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    }
    NSLog(@"dailyMath is: %li", (long)[userDefaults integerForKey:@"dailyMath"]);

    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
   
    profileImageView.layer.cornerRadius = 25;
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    if ([userDefaults objectForKey:@"profileImage"])
    {
        profileImageView.image = [UIImage imageNamed:[userDefaults objectForKey:@"profileImage"]];
    }
    else
    {
    profileImageView.image = [UIImage imageNamed:@"boy.png"];
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
    _userArray = [self cardDifficulty];
    
    [_userArray enumerateObjectsUsingBlock:^(MathProblem *obj, NSUInteger idx, BOOL *stop)
     {
         [obj saveInBackground];
     }];
    
    [signUpController dismissViewControllerAnimated:YES completion:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    //receive their first sticker and set it to their profile pic
}

-(void)setTitle
{
    NSString *username = [PFUser currentUser].username;
    NSString *cappedFirstChar = [[username substringToIndex:1] uppercaseString];
    NSString *cappedString = [username stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:cappedFirstChar];
    [profileButton setTitle:cappedString forState:UIControlStateNormal];
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
    return @[         [[MathProblem alloc]initWithDifficulty:2 forProblem:0],
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




@end
