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
#import "CSAnimationView.h"


@interface ProfileViewController () <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, UIAlertViewDelegate>
{
    NSUserDefaults *userDefaults;
    PFUser *user;
    NSMutableArray *MathProblems;

    __weak IBOutlet UIButton *profileButton;
    __weak IBOutlet UILabel *profileLabel;
    __weak IBOutlet UIButton *mathButton;
    __weak IBOutlet UIButton *progressButton;
    __weak IBOutlet UIButton *stickersButton;
    __weak IBOutlet UIButton *achievementsButton;
    
    float loadCounter;
    CSAnimationView *loadView;
    UILabel *percentLabel;
    
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
    mathButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    progressButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    stickersButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    achievementsButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    
    NSLog(@"time since dailyMathStartDate: %f", [[NSDate date] timeIntervalSinceDate:[user objectForKey:@"dailyMathStartDate"]]);
    //if its been more than a day since the last reset of dailyMath, reset it
    if ([[NSDate date] timeIntervalSinceDate:[user objectForKey:@"dailyMathStartDate"]] >= 86400.0)
    {
        [user setObject:@0 forKey:@"dailyMath"];
        
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
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hey Testers!" message:@"If your app is crashing or acting funny, log out and create a new user. We're changing the way users work constantly so sometimes old users don't work. Thanks for testing our app!" delegate:nil cancelButtonTitle:@"On To The Math!" otherButtonTitles: nil];
    [alert show];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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
    loadCounter = 0;
    loadView = [[CSAnimationView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    loadView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:loadView];
    
    UILabel *loadLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 310, 220, 80)];
    loadLabel.text = @"Your user will be ready to go in a moment!";
    loadLabel.textAlignment = NSTextAlignmentCenter;
    loadLabel.font = [UIFont fontWithName:@"Miso-Bold" size:30];
    loadLabel.numberOfLines = 2;
    loadLabel.lineBreakMode = NSLineBreakByWordWrapping;
    loadLabel.textColor = [UIColor darkGrayColor];
    [loadView addSubview:loadLabel];
    
    percentLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, 270, 60, 50)];
    percentLabel.textAlignment = NSTextAlignmentCenter;
    percentLabel.textColor = [UIColor darkGrayColor];
    percentLabel.font = [UIFont fontWithName:@"Miso-Bold" size:30];
    
    [loadView addSubview:percentLabel];
    
    
    
    _userArray = [self cardDifficulty];
    _subtractionUserArray = [self subtractionDifficulty];
    _multplicationUserArray = [self multiplicationDifficulty];
    _divisionUserArray = [self divisionDifficulty];
    
    [PFObject saveAllInBackground:_userArray block:^(BOOL succeeded, NSError *error)
    {
        NSLog(@"Celebrate!");
        loadCounter ++;
        [self checkIfLoadIsFinished];
    }];
    [PFObject saveAllInBackground:_subtractionUserArray block:^(BOOL succeeded, NSError *error)
     {
         NSLog(@"Celebrate 2!");
         loadCounter ++;
         [self checkIfLoadIsFinished];
     }];
    [PFObject saveAllInBackground:_multplicationUserArray block:^(BOOL succeeded, NSError *error)
     {
         NSLog(@"Celebrate 3!");
         loadCounter ++;
         [self checkIfLoadIsFinished];
     }];
    [PFObject saveAllInBackground:_divisionUserArray block:^(BOOL succeeded, NSError *error)
     {
         NSLog(@"Celebrate 4!");
         loadCounter ++;
         [self checkIfLoadIsFinished];
     }];
    
    [signUpController dismissViewControllerAnimated:YES completion:^
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    //receive their first sticker and set it to their profile pic
}

-(void)checkIfLoadIsFinished
{
    percentLabel.text = [NSString stringWithFormat:@"%i%%", @((loadCounter/4)*100).intValue];

    if (loadCounter >= 4)
    {
        [loadView removeFromSuperview];
    }
}

-(void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)loggedInUser
{
    [logInController dismissViewControllerAnimated:YES completion:nil];
    user = loggedInUser;
    [self setProfileImage];
    [self checkAchievementsForLoggedInUser];
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

-(void)checkAchievementsForLoggedInUser
{
    //daily math
    int dailyMath = [[user objectForKey:@"dailyMath"] intValue];
    if (dailyMath >= 50)
    {
        [userDefaults setBool:YES forKey:@"Daily Math x50!"];
    }
    if (dailyMath >= 40)
    {
        [userDefaults setBool:YES forKey:@"Daily Math x40!"];
    }
    if (dailyMath >= 30)
    {
        [userDefaults setBool:YES forKey:@"Daily Math x30!"];
    }
    if (dailyMath >= 20)
    {
        [userDefaults setBool:YES forKey:@"Daily Math x20!"];
    }
    if (dailyMath >= 10)
    {
        [userDefaults setBool:YES forKey:@"Daily Math x10!"];
    }
    
    //addition
    int totalAdds = [[user objectForKey:@"totalAdds"] intValue];
    if (totalAdds >= 300)
    {
        [userDefaults setBool:YES forKey:@"Add It Up x300!"];
    }
    if (totalAdds >= 275)
    {
        [userDefaults setBool:YES forKey:@"Add It Up x275!"];
    }
    if (totalAdds >= 250)
    {
        [userDefaults setBool:YES forKey:@"Add It Up x250!"];
    }
    if (totalAdds >= 225)
    {
        [userDefaults setBool:YES forKey:@"Add It Up x225!"];
    }
    if (totalAdds >= 200)
    {
        [userDefaults setBool:YES forKey:@"Add It Up x200!"];
    }
    if (totalAdds >= 180)
    {
        [userDefaults setBool:YES forKey:@"Add It Up x180!"];
    }
    if (totalAdds >= 160)
    {
        [userDefaults setBool:YES forKey:@"Add It Up x160!"];
    }
    if (totalAdds >= 140)
    {
        [userDefaults setBool:YES forKey:@"Add It Up x140!"];
    }
    if (totalAdds >= 120)
    {
        [userDefaults setBool:YES forKey:@"Add It Up x120!"];
    }
    if (totalAdds >= 100)
    {
        [userDefaults setBool:YES forKey:@"Add It Up x100!"];
    }
    if (totalAdds >= 80)
    {
        [userDefaults setBool:YES forKey:@"Add It Up x80!"];
    }
    if (totalAdds >= 60)
    {
        [userDefaults setBool:YES forKey:@"Add It Up x60!"];
    }
    if (totalAdds >= 40)
    {
        [userDefaults setBool:YES forKey:@"Add It Up x40!"];
    }
    if (totalAdds >= 20)
    {
        [userDefaults setBool:YES forKey:@"Add It Up x20!"];
    }
    if (totalAdds >= 1)
    {
        [userDefaults setBool:YES forKey:@"Add It Up!"];
    }
    
    int totalFastAdds = [[user objectForKey:@"totalFastAdds"] intValue];
    if (totalFastAdds >= 250)
    {
        [userDefaults setBool:YES forKey:@"Adding At 250 Miles Per Hour!"];
    }
    if (totalFastAdds >= 230)
    {
        [userDefaults setBool:YES forKey:@"Adding At 230 Miles Per Hour!"];
    }
    if (totalFastAdds >= 210)
    {
        [userDefaults setBool:YES forKey:@"Adding At 210 Miles Per Hour!"];
    }
    if (totalFastAdds >= 190)
    {
        [userDefaults setBool:YES forKey:@"Adding At 190 Miles Per Hour!"];
    }
    if (totalFastAdds >= 170)
    {
        [userDefaults setBool:YES forKey:@"Adding At 170 Miles Per Hour!"];
    }
    if (totalFastAdds >= 150)
    {
        [userDefaults setBool:YES forKey:@"Adding At 150 Miles Per Hour!"];
    }
    if (totalFastAdds >= 135)
    {
        [userDefaults setBool:YES forKey:@"Adding At 135 Miles Per Hour!"];
    }
    if (totalFastAdds >= 120)
    {
        [userDefaults setBool:YES forKey:@"Adding At 120 Miles Per Hour!"];
    }
    if (totalFastAdds >= 105)
    {
        [userDefaults setBool:YES forKey:@"Adding At 105 Miles Per Hour!"];
    }
    if (totalFastAdds >= 90)
    {
        [userDefaults setBool:YES forKey:@"Adding At 90 Miles Per Hour!"];
    }
    if (totalFastAdds >= 75)
    {
        [userDefaults setBool:YES forKey:@"Adding At 75 Miles Per Hour!"];
    }
    if (totalFastAdds >= 60)
    {
        [userDefaults setBool:YES forKey:@"Adding At 60 Miles Per Hour!"];
    }
    if (totalFastAdds >= 45)
    {
        [userDefaults setBool:YES forKey:@"Adding At 45 Miles Per Hour!"];
    }
    if (totalFastAdds >= 30)
    {
        [userDefaults setBool:YES forKey:@"Adding At 30 Miles Per Hour!"];
    }
    if (totalFastAdds >= 15)
    {
        [userDefaults setBool:YES forKey:@"Adding At 15 Miles Per Hour!"];
    }
    
    //subtraction
    int totalSubs = [[user objectForKey:@"totalSubs"] intValue];
    if (totalSubs >= 300)
    {
        [userDefaults setBool:YES forKey:@"Take It Away x300!"];
    }
    if (totalSubs >= 275)
    {
        [userDefaults setBool:YES forKey:@"Take It Away x275!"];
    }
    if (totalSubs >= 250)
    {
        [userDefaults setBool:YES forKey:@"Take It Away x250!"];
    }
    if (totalSubs >= 225)
    {
        [userDefaults setBool:YES forKey:@"Take It Away x225!"];
    }
    if (totalSubs >= 200)
    {
        [userDefaults setBool:YES forKey:@"Take It Away x200!"];
    }
    if (totalSubs >= 180)
    {
        [userDefaults setBool:YES forKey:@"Take It Away x180!"];
    }
    if (totalSubs >= 160)
    {
        [userDefaults setBool:YES forKey:@"Take It Away x160!"];
    }
    if (totalSubs >= 140)
    {
        [userDefaults setBool:YES forKey:@"Take It Away x140!"];
    }
    if (totalSubs >= 120)
    {
        [userDefaults setBool:YES forKey:@"Take It Away x120!"];
    }
    if (totalSubs >= 100)
    {
        [userDefaults setBool:YES forKey:@"Take It Away x100!"];
    }
    if (totalSubs >= 80)
    {
        [userDefaults setBool:YES forKey:@"Take It Away x80!"];
    }
    if (totalSubs >= 60)
    {
        [userDefaults setBool:YES forKey:@"Take It Away x60!"];
    }
    if (totalSubs >= 40)
    {
        [userDefaults setBool:YES forKey:@"Take It Away x40!"];
    }
    if (totalSubs >= 20)
    {
        [userDefaults setBool:YES forKey:@"Take It Away x20!"];
    }
    if (totalSubs >= 1)
    {
        [userDefaults setBool:YES forKey:@"Take It Away!"];
    }
    
    int totalFastSubs = [[user objectForKey:@"totalFastSubs"] intValue];
    if (totalFastSubs >= 250)
    {
        [userDefaults setBool:YES forKey:@"Subtracting At 250 \nMiles Per Hour!"];
    }
    if (totalFastSubs >= 230)
    {
        [userDefaults setBool:YES forKey:@"Subtracting At 230 \nMiles Per Hour!"];
    }
    if (totalFastSubs >= 210)
    {
        [userDefaults setBool:YES forKey:@"Subtracting At 210 \nMiles Per Hour!"];
    }
    if (totalFastSubs >= 190)
    {
        [userDefaults setBool:YES forKey:@"Subtracting At 190 \nMiles Per Hour!"];
    }
    if (totalFastSubs >= 170)
    {
        [userDefaults setBool:YES forKey:@"Subtracting At 170 \nMiles Per Hour!"];
    }
    if (totalFastSubs >= 150)
    {
        [userDefaults setBool:YES forKey:@"Subtracting At 150 \nMiles Per Hour!"];
    }
    if (totalFastSubs >= 135)
    {
        [userDefaults setBool:YES forKey:@"Subtracting At 135 \nMiles Per Hour!"];
    }
    if (totalFastSubs >= 120)
    {
        [userDefaults setBool:YES forKey:@"Subtracting At 120 \nMiles Per Hour!"];
    }
    if (totalFastSubs >= 105)
    {
        [userDefaults setBool:YES forKey:@"Subtracting At 105 \nMiles Per Hour!"];
    }
    if (totalFastSubs >= 90)
    {
        [userDefaults setBool:YES forKey:@"Subtracting At 90 \nMiles Per Hour!"];
    }
    if (totalFastSubs >= 75)
    {
        [userDefaults setBool:YES forKey:@"Subtracting At 75 \nMiles Per Hour!"];
    }
    if (totalFastSubs >= 60)
    {
        [userDefaults setBool:YES forKey:@"Subtracting At 60 \nMiles Per Hour!"];
    }
    if (totalFastSubs >= 45)
    {
        [userDefaults setBool:YES forKey:@"Subtracting At 45 \nMiles Per Hour!"];
    }
    if (totalFastSubs >= 30)
    {
        [userDefaults setBool:YES forKey:@"Subtracting At 30 \nMiles Per Hour!"];
    }
    if (totalFastSubs >= 15)
    {
        [userDefaults setBool:YES forKey:@"Subtracting At 15 \nMiles Per Hour!"];
    }
    
    //multiplication
    int totalMults = [[user objectForKey:@"totalMults"] intValue];
    if (totalMults >= 300)
    {
        [userDefaults setBool:YES forKey:@"Multiplicity x300!"];
    }
    if (totalMults >= 275)
    {
        [userDefaults setBool:YES forKey:@"Multiplicity x275!"];
    }
    if (totalMults >= 250)
    {
        [userDefaults setBool:YES forKey:@"Multiplicity x250!"];
    }
    if (totalMults >= 225)
    {
        [userDefaults setBool:YES forKey:@"Multiplicity x225!"];
    }
    if (totalMults >= 200)
    {
        [userDefaults setBool:YES forKey:@"Multiplicity x200!"];
    }
    if (totalMults >= 180)
    {
        [userDefaults setBool:YES forKey:@"Multiplicity x180!"];
    }
    if (totalMults >= 160)
    {
        [userDefaults setBool:YES forKey:@"Multiplicity x160!"];
    }
    if (totalMults >= 140)
    {
        [userDefaults setBool:YES forKey:@"Multiplicity x140!"];
    }
    if (totalMults >= 120)
    {
        [userDefaults setBool:YES forKey:@"Multiplicity x120!"];
    }
    if (totalMults >= 100)
    {
        [userDefaults setBool:YES forKey:@"Multiplicity x100!"];
    }
    if (totalMults >= 80)
    {
        [userDefaults setBool:YES forKey:@"Multiplicity x80!"];
    }
    if (totalMults >= 60)
    {
        [userDefaults setBool:YES forKey:@"Multiplicity x60!"];
    }
    if (totalMults >= 40)
    {
        [userDefaults setBool:YES forKey:@"Multiplicity x40!"];
    }
    if (totalMults >= 20)
    {
        [userDefaults setBool:YES forKey:@"Multiplicity x20!"];
    }
    if (totalMults >= 1)
    {
        [userDefaults setBool:YES forKey:@"Multiplicity!"];
    }
    
    int totalFastMults = [[user objectForKey:@"totalFastMults"] intValue];
    if (totalFastMults >= 250)
    {
        [userDefaults setBool:YES forKey:@"Multiplying At 250 \nMiles Per Hour!"];
    }
    if (totalFastMults >= 230)
    {
        [userDefaults setBool:YES forKey:@"Multiplying At 230 \nMiles Per Hour!"];
    }
    if (totalFastMults >= 210)
    {
        [userDefaults setBool:YES forKey:@"Multiplying At 210 \nMiles Per Hour!"];
    }
    if (totalFastMults >= 190)
    {
        [userDefaults setBool:YES forKey:@"Multiplying At 190 \nMiles Per Hour!"];
    }
    if (totalFastMults >= 170)
    {
        [userDefaults setBool:YES forKey:@"Multiplying At 170 \nMiles Per Hour!"];
    }
    if (totalFastMults >= 150)
    {
        [userDefaults setBool:YES forKey:@"Multiplying At 150 \nMiles Per Hour!"];
    }
    if (totalFastMults >= 135)
    {
        [userDefaults setBool:YES forKey:@"Multiplying At 135 \nMiles Per Hour!"];
    }
    if (totalFastMults >= 120)
    {
        [userDefaults setBool:YES forKey:@"Multiplying At 120 \nMiles Per Hour!"];
    }
    if (totalFastMults >= 105)
    {
        [userDefaults setBool:YES forKey:@"Multiplying At 105 \nMiles Per Hour!"];
    }
    if (totalFastMults >= 90)
    {
        [userDefaults setBool:YES forKey:@"Multiplying At 90 \nMiles Per Hour!"];
    }
    if (totalFastMults >= 75)
    {
        [userDefaults setBool:YES forKey:@"Multiplying At 75 \nMiles Per Hour!"];
    }
    if (totalFastMults >= 60)
    {
        [userDefaults setBool:YES forKey:@"Multiplying At 60 \nMiles Per Hour!"];
    }
    if (totalFastMults >= 45)
    {
        [userDefaults setBool:YES forKey:@"Multiplying At 45 \nMiles Per Hour!"];
    }
    if (totalFastMults >= 30)
    {
        [userDefaults setBool:YES forKey:@"Multiplying At 30 \nMiles Per Hour!"];
    }
    if (totalFastMults >= 15)
    {
        [userDefaults setBool:YES forKey:@"Multiplying At 15 \nMiles Per Hour!"];
    }
    
    //division
    int totalDivides = [[user objectForKey:@"totalDivides"] intValue];
    if (totalDivides >= 300)
    {
        [userDefaults setBool:YES forKey:@"Divide And Conquer x300!"];
    }
    if (totalDivides >= 275)
    {
        [userDefaults setBool:YES forKey:@"Divide And Conquer x275!"];
    }
    if (totalDivides >= 250)
    {
        [userDefaults setBool:YES forKey:@"Divide And Conquer x250!"];
    }
    if (totalDivides >= 225)
    {
        [userDefaults setBool:YES forKey:@"Divide And Conquer x225!"];
    }
    if (totalDivides >= 200)
    {
        [userDefaults setBool:YES forKey:@"Divide And Conquer x200!"];
    }
    if (totalDivides >= 180)
    {
        [userDefaults setBool:YES forKey:@"Divide And Conquer x180!"];
    }
    if (totalDivides >= 160)
    {
        [userDefaults setBool:YES forKey:@"Divide And Conquer x160!"];
    }
    if (totalDivides >= 140)
    {
        [userDefaults setBool:YES forKey:@"Divide And Conquer x140!"];
    }
    if (totalDivides >= 120)
    {
        [userDefaults setBool:YES forKey:@"Divide And Conquer x120!"];
    }
    if (totalDivides >= 100)
    {
        [userDefaults setBool:YES forKey:@"Divide And Conquer x100!"];
    }
    if (totalDivides >= 80)
    {
        [userDefaults setBool:YES forKey:@"Divide And Conquer x80!"];
    }
    if (totalDivides >= 60)
    {
        [userDefaults setBool:YES forKey:@"Divide And Conquer x60!"];
    }
    if (totalDivides >= 40)
    {
        [userDefaults setBool:YES forKey:@"Divide And Conquer x40!"];
    }
    if (totalDivides >= 20)
    {
        [userDefaults setBool:YES forKey:@"Divide And Conquer x20!"];
    }
    if (totalDivides >= 1)
    {
        [userDefaults setBool:YES forKey:@"Divide And Conquer!"];
    }
    
    int totalFastDivides = [[user objectForKey:@"totalFastDivides"] intValue];
    if (totalFastDivides >= 250)
    {
        [userDefaults setBool:YES forKey:@"Dividing At 250 \nMiles Per Hour!"];
    }
    if (totalFastDivides >= 230)
    {
        [userDefaults setBool:YES forKey:@"Dividing At 230 \nMiles Per Hour!"];
    }
    if (totalFastDivides >= 210)
    {
        [userDefaults setBool:YES forKey:@"Dividing At 210 \nMiles Per Hour!"];
    }
    if (totalFastDivides >= 190)
    {
        [userDefaults setBool:YES forKey:@"Dividing At 190 \nMiles Per Hour!"];
    }
    if (totalFastDivides >= 170)
    {
        [userDefaults setBool:YES forKey:@"Dividing At 170 \nMiles Per Hour!"];
    }
    if (totalFastDivides >= 150)
    {
        [userDefaults setBool:YES forKey:@"Dividing At 150 \nMiles Per Hour!"];
    }
    if (totalFastDivides >= 135)
    {
        [userDefaults setBool:YES forKey:@"Dividing At 135 \nMiles Per Hour!"];
    }
    if (totalFastDivides >= 120)
    {
        [userDefaults setBool:YES forKey:@"Dividing At 120 \nMiles Per Hour!"];
    }
    if (totalFastDivides >= 105)
    {
        [userDefaults setBool:YES forKey:@"Dividing At 105 \nMiles Per Hour!"];
    }
    if (totalFastDivides >= 90)
    {
        [userDefaults setBool:YES forKey:@"Dividing At 90 \nMiles Per Hour!"];
    }
    if (totalFastDivides >= 75)
    {
        [userDefaults setBool:YES forKey:@"Dividing At 75 \nMiles Per Hour!"];
    }
    if (totalFastDivides >= 60)
    {
        [userDefaults setBool:YES forKey:@"Dividing At 60 \nMiles Per Hour!"];
    }
    if (totalFastDivides >= 45)
    {
        [userDefaults setBool:YES forKey:@"Dividing At 45 \nMiles Per Hour!"];
    }
    if (totalFastDivides >= 30)
    {
        [userDefaults setBool:YES forKey:@"Dividing At 30 \nMiles Per Hour!"];
    }
    if (totalFastDivides >= 15)
    {
        [userDefaults setBool:YES forKey:@"Dividing At 15 \nMiles Per Hour!"];
    }

    
    //total math problems
    int totalMathProblems = [[user objectForKey:@"totalAdds"] intValue] + [[user objectForKey:@"totalSubs"] intValue] + [[user objectForKey:@"totalMults"] intValue] + [[user objectForKey:@"totalDivides"] intValue];
    if (totalMathProblems >= 1500)
    {
        [userDefaults setBool:YES forKey:@"Keep It Up x1500!"];
    }
    if (totalMathProblems >= 1400)
    {
        [userDefaults setBool:YES forKey:@"Keep It Up x1400!"];
    }
    if (totalMathProblems >= 1300)
    {
        [userDefaults setBool:YES forKey:@"Keep It Up x1300!"];
    }
    if (totalMathProblems >= 1200)
    {
        [userDefaults setBool:YES forKey:@"Keep It Up x1200!"];
    }
    if (totalMathProblems >= 1100)
    {
        [userDefaults setBool:YES forKey:@"Keep It Up x1100!"];
    }
    if (totalMathProblems >= 1000)
    {
        [userDefaults setBool:YES forKey:@"Keep It Up x1000!"];
    }
    if (totalMathProblems >= 900)
    {
        [userDefaults setBool:YES forKey:@"Keep It Up x900!"];
    }
    if (totalMathProblems >= 800)
    {
        [userDefaults setBool:YES forKey:@"Keep It Up x800!"];
    }
    if (totalMathProblems >= 700)
    {
        [userDefaults setBool:YES forKey:@"Keep It Up x700!"];
    }
    if (totalMathProblems >= 600)
    {
        [userDefaults setBool:YES forKey:@"Keep It Up x600!"];
    }
    if (totalMathProblems >= 500)
    {
        [userDefaults setBool:YES forKey:@"Keep It Up x500!"];
    }
    if (totalMathProblems >= 400)
    {
        [userDefaults setBool:YES forKey:@"Keep It Up x400!"];
    }
    if (totalMathProblems >= 300)
    {
        [userDefaults setBool:YES forKey:@"Keep It Up x300!"];
    }
    if (totalMathProblems >= 200)
    {
        [userDefaults setBool:YES forKey:@"Keep It Up x200!"];
    }
    if (totalMathProblems >= 100)
    {
        [userDefaults setBool:YES forKey:@"Keep It Up x100!"];
    }
    
    //excellence achievements
    NSString *achievementKey = @"Add It All Up!";
    NSNumber *boolNumber = [user objectForKey: achievementKey];
    [userDefaults setBool: boolNumber.boolValue forKey:achievementKey];
    
    achievementKey = @"Take It All Away!";
    boolNumber = [user objectForKey: achievementKey];
    [userDefaults setBool: boolNumber.boolValue forKey:achievementKey];
    
    achievementKey = @"Multiplication Magician!";
    boolNumber = [user objectForKey: achievementKey];
    [userDefaults setBool: boolNumber.boolValue forKey:achievementKey];
    
    achievementKey = @"Conquer Division!";
    boolNumber = [user objectForKey: achievementKey];
    [userDefaults setBool: boolNumber.boolValue forKey:achievementKey];
    
    achievementKey = @"Math Master!";
    boolNumber = [user objectForKey: achievementKey];
    [userDefaults setBool: boolNumber.boolValue forKey:achievementKey];

    [userDefaults synchronize];
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

-(NSMutableArray *)multiplicationDifficulty
{
    return @[         [[MathProblem alloc]initWithDifficulty:2 ofProblemType:2 forFirstValue:0 forSecondValue:0],
                      [[MathProblem alloc]initWithDifficulty:2 ofProblemType:2 forFirstValue:0 forSecondValue:1],
                      [[MathProblem alloc]initWithDifficulty:2 ofProblemType:2 forFirstValue:1 forSecondValue:0],
                      [[MathProblem alloc]initWithDifficulty:2 ofProblemType:2 forFirstValue:1 forSecondValue:1],
                      [[MathProblem alloc]initWithDifficulty:2 ofProblemType:2 forFirstValue:0 forSecondValue:2],
                      [[MathProblem alloc]initWithDifficulty:2 ofProblemType:2 forFirstValue:2 forSecondValue:0],
                      [[MathProblem alloc]initWithDifficulty:2 ofProblemType:2 forFirstValue:2 forSecondValue:1],
                      [[MathProblem alloc]initWithDifficulty:2 ofProblemType:2 forFirstValue:1 forSecondValue:2],
                      [[MathProblem alloc]initWithDifficulty:2 ofProblemType:2 forFirstValue:0 forSecondValue:3],
                      [[MathProblem alloc]initWithDifficulty:2 ofProblemType:2 forFirstValue:3 forSecondValue:0],
                      [[MathProblem alloc]initWithDifficulty:2 ofProblemType:2 forFirstValue:3 forSecondValue:1],
                      [[MathProblem alloc]initWithDifficulty:2 ofProblemType:2 forFirstValue:1 forSecondValue:3],
                      [[MathProblem alloc]initWithDifficulty:2 ofProblemType:2 forFirstValue:0 forSecondValue:4],
                      [[MathProblem alloc]initWithDifficulty:2 ofProblemType:2 forFirstValue:4 forSecondValue:0],
                      [[MathProblem alloc]initWithDifficulty:2 ofProblemType:2 forFirstValue:4 forSecondValue:1],
                      [[MathProblem alloc]initWithDifficulty:2 ofProblemType:2 forFirstValue:1 forSecondValue:4],
                      [[MathProblem alloc]initWithDifficulty:2 ofProblemType:2 forFirstValue:0 forSecondValue:5],
                      [[MathProblem alloc]initWithDifficulty:2 ofProblemType:2 forFirstValue:5 forSecondValue:0],
                      [[MathProblem alloc]initWithDifficulty:2 ofProblemType:2 forFirstValue:5 forSecondValue:1],
                      [[MathProblem alloc]initWithDifficulty:2 ofProblemType:2 forFirstValue:1 forSecondValue:5],
                      [[MathProblem alloc]initWithDifficulty:2 ofProblemType:2 forFirstValue:2 forSecondValue:2],
                      [[MathProblem alloc]initWithDifficulty:2 ofProblemType:2 forFirstValue:2 forSecondValue:3],
                      [[MathProblem alloc]initWithDifficulty:2 ofProblemType:2 forFirstValue:3 forSecondValue:2],
                      [[MathProblem alloc]initWithDifficulty:2 ofProblemType:2 forFirstValue:0 forSecondValue:6],
                      [[MathProblem alloc]initWithDifficulty:2 ofProblemType:2 forFirstValue:6 forSecondValue:0],
                      [[MathProblem alloc]initWithDifficulty:2 ofProblemType:2 forFirstValue:6 forSecondValue:1],
                      [[MathProblem alloc]initWithDifficulty:2 ofProblemType:2 forFirstValue:1 forSecondValue:6],
                      [[MathProblem alloc]initWithDifficulty:2 ofProblemType:2 forFirstValue:0 forSecondValue:7],
                      [[MathProblem alloc]initWithDifficulty:2 ofProblemType:2 forFirstValue:7 forSecondValue:0],
                      [[MathProblem alloc]initWithDifficulty:2 ofProblemType:2 forFirstValue:7 forSecondValue:1],
                      [[MathProblem alloc]initWithDifficulty:2 ofProblemType:2 forFirstValue:1 forSecondValue:7],
                      [[MathProblem alloc]initWithDifficulty:2 ofProblemType:2 forFirstValue:0 forSecondValue:8],
                      [[MathProblem alloc]initWithDifficulty:2 ofProblemType:2 forFirstValue:8 forSecondValue:0],
                      [[MathProblem alloc]initWithDifficulty:2 ofProblemType:2 forFirstValue:8 forSecondValue:1],
                      [[MathProblem alloc]initWithDifficulty:2 ofProblemType:2 forFirstValue:1 forSecondValue:8],
                      [[MathProblem alloc]initWithDifficulty:2 ofProblemType:2 forFirstValue:0 forSecondValue:9],
                      [[MathProblem alloc]initWithDifficulty:2 ofProblemType:2 forFirstValue:9 forSecondValue:0],
                      [[MathProblem alloc]initWithDifficulty:2 ofProblemType:2 forFirstValue:9 forSecondValue:1],
                      [[MathProblem alloc]initWithDifficulty:2 ofProblemType:2 forFirstValue:1 forSecondValue:9],
                      [[MathProblem alloc]initWithDifficulty:2 ofProblemType:2 forFirstValue:3 forSecondValue:3],
                      [[MathProblem alloc]initWithDifficulty:2 ofProblemType:2 forFirstValue:2 forSecondValue:4],
                      [[MathProblem alloc]initWithDifficulty:2 ofProblemType:2 forFirstValue:4 forSecondValue:2],
                      [[MathProblem alloc]initWithDifficulty:2 ofProblemType:2 forFirstValue:2 forSecondValue:5],
                      [[MathProblem alloc]initWithDifficulty:2 ofProblemType:2 forFirstValue:5 forSecondValue:2],
                      [[MathProblem alloc]initWithDifficulty:2 ofProblemType:2 forFirstValue:2 forSecondValue:6],
                      [[MathProblem alloc]initWithDifficulty:2 ofProblemType:2 forFirstValue:6 forSecondValue:2],
                      [[MathProblem alloc]initWithDifficulty:4 ofProblemType:2 forFirstValue:2 forSecondValue:7],
                      [[MathProblem alloc]initWithDifficulty:4 ofProblemType:2 forFirstValue:7 forSecondValue:2],
                      [[MathProblem alloc]initWithDifficulty:4 ofProblemType:2 forFirstValue:2 forSecondValue:8],
                      [[MathProblem alloc]initWithDifficulty:4 ofProblemType:2 forFirstValue:8 forSecondValue:2],
                      [[MathProblem alloc]initWithDifficulty:4 ofProblemType:2 forFirstValue:2 forSecondValue:9],
                      [[MathProblem alloc]initWithDifficulty:4 ofProblemType:2 forFirstValue:9 forSecondValue:2],
                      [[MathProblem alloc]initWithDifficulty:2 ofProblemType:2 forFirstValue:3 forSecondValue:4],
                      [[MathProblem alloc]initWithDifficulty:2 ofProblemType:2 forFirstValue:4 forSecondValue:3],
                      [[MathProblem alloc]initWithDifficulty:4 ofProblemType:2 forFirstValue:3 forSecondValue:5],
                      [[MathProblem alloc]initWithDifficulty:4 ofProblemType:2 forFirstValue:5 forSecondValue:3],
                      [[MathProblem alloc]initWithDifficulty:4 ofProblemType:2 forFirstValue:3 forSecondValue:6],
                      [[MathProblem alloc]initWithDifficulty:4 ofProblemType:2 forFirstValue:6 forSecondValue:3],
                      [[MathProblem alloc]initWithDifficulty:4 ofProblemType:2 forFirstValue:3 forSecondValue:7],
                      [[MathProblem alloc]initWithDifficulty:4 ofProblemType:2 forFirstValue:7 forSecondValue:3],
                      [[MathProblem alloc]initWithDifficulty:6 ofProblemType:2 forFirstValue:3 forSecondValue:8],
                      [[MathProblem alloc]initWithDifficulty:6 ofProblemType:2 forFirstValue:8 forSecondValue:3],
                      [[MathProblem alloc]initWithDifficulty:6 ofProblemType:2 forFirstValue:3 forSecondValue:9],
                      [[MathProblem alloc]initWithDifficulty:6 ofProblemType:2 forFirstValue:9 forSecondValue:3],
                      [[MathProblem alloc]initWithDifficulty:4 ofProblemType:2 forFirstValue:4 forSecondValue:4],
                      [[MathProblem alloc]initWithDifficulty:4 ofProblemType:2 forFirstValue:5 forSecondValue:4],
                      [[MathProblem alloc]initWithDifficulty:4 ofProblemType:2 forFirstValue:4 forSecondValue:5],
                      [[MathProblem alloc]initWithDifficulty:4 ofProblemType:2 forFirstValue:5 forSecondValue:5],
                      [[MathProblem alloc]initWithDifficulty:4 ofProblemType:2 forFirstValue:4 forSecondValue:6],
                      [[MathProblem alloc]initWithDifficulty:4 ofProblemType:2 forFirstValue:6 forSecondValue:4],
                      [[MathProblem alloc]initWithDifficulty:6 ofProblemType:2 forFirstValue:4 forSecondValue:7],
                      [[MathProblem alloc]initWithDifficulty:6 ofProblemType:2 forFirstValue:7 forSecondValue:4],
                      [[MathProblem alloc]initWithDifficulty:6 ofProblemType:2 forFirstValue:4 forSecondValue:8],
                      [[MathProblem alloc]initWithDifficulty:6 ofProblemType:2 forFirstValue:8 forSecondValue:4],
                      [[MathProblem alloc]initWithDifficulty:6 ofProblemType:2 forFirstValue:4 forSecondValue:9],
                      [[MathProblem alloc]initWithDifficulty:6 ofProblemType:2 forFirstValue:9 forSecondValue:4],
                      [[MathProblem alloc]initWithDifficulty:6 ofProblemType:2 forFirstValue:5 forSecondValue:6],
                      [[MathProblem alloc]initWithDifficulty:6 ofProblemType:2 forFirstValue:6 forSecondValue:5],
                      [[MathProblem alloc]initWithDifficulty:6 ofProblemType:2 forFirstValue:6 forSecondValue:6],
                      [[MathProblem alloc]initWithDifficulty:6 ofProblemType:2 forFirstValue:5 forSecondValue:7],
                      [[MathProblem alloc]initWithDifficulty:6 ofProblemType:2 forFirstValue:7 forSecondValue:5],
                      [[MathProblem alloc]initWithDifficulty:8 ofProblemType:2 forFirstValue:5 forSecondValue:8],
                      [[MathProblem alloc]initWithDifficulty:8 ofProblemType:2 forFirstValue:8 forSecondValue:5],
                      [[MathProblem alloc]initWithDifficulty:8 ofProblemType:2 forFirstValue:5 forSecondValue:9],
                      [[MathProblem alloc]initWithDifficulty:8 ofProblemType:2 forFirstValue:9 forSecondValue:5],
                      [[MathProblem alloc]initWithDifficulty:8 ofProblemType:2 forFirstValue:6 forSecondValue:7],
                      [[MathProblem alloc]initWithDifficulty:8 ofProblemType:2 forFirstValue:7 forSecondValue:6],
                      [[MathProblem alloc]initWithDifficulty:8 ofProblemType:2 forFirstValue:6 forSecondValue:8],
                      [[MathProblem alloc]initWithDifficulty:8 ofProblemType:2 forFirstValue:8 forSecondValue:6],
                      [[MathProblem alloc]initWithDifficulty:8 ofProblemType:2 forFirstValue:6 forSecondValue:9],
                      [[MathProblem alloc]initWithDifficulty:8 ofProblemType:2 forFirstValue:9 forSecondValue:6],
                      [[MathProblem alloc]initWithDifficulty:8 ofProblemType:2 forFirstValue:7 forSecondValue:7],
                      [[MathProblem alloc]initWithDifficulty:8 ofProblemType:2 forFirstValue:8 forSecondValue:8],
                      [[MathProblem alloc]initWithDifficulty:8 ofProblemType:2 forFirstValue:9 forSecondValue:9],
                      [[MathProblem alloc]initWithDifficulty:8 ofProblemType:2 forFirstValue:7 forSecondValue:8],
                      [[MathProblem alloc]initWithDifficulty:8 ofProblemType:2 forFirstValue:7 forSecondValue:9],
                      [[MathProblem alloc]initWithDifficulty:8 ofProblemType:2 forFirstValue:8 forSecondValue:7],
                      [[MathProblem alloc]initWithDifficulty:8 ofProblemType:2 forFirstValue:8 forSecondValue:9],
                      [[MathProblem alloc]initWithDifficulty:8 ofProblemType:2 forFirstValue:9 forSecondValue:7],
                      [[MathProblem alloc]initWithDifficulty:8 ofProblemType:2 forFirstValue:9 forSecondValue:8]
                      ].mutableCopy;
}

-(NSMutableArray *)divisionDifficulty
{
    return  @[                [[MathProblem alloc]initWithDifficulty:2 ofProblemType:3 forFirstValue:1 forSecondValue:1],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:3 forFirstValue:2 forSecondValue:1],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:3 forFirstValue:2 forSecondValue:2],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:3 forFirstValue:3 forSecondValue:1],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:3 forFirstValue:3 forSecondValue:3],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:3 forFirstValue:4 forSecondValue:1],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:3 forFirstValue:4 forSecondValue:4],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:3 forFirstValue:5 forSecondValue:1],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:3 forFirstValue:5 forSecondValue:5],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:3 forFirstValue:10 forSecondValue:10],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:3 forFirstValue:10 forSecondValue:1],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:3 forFirstValue:20 forSecondValue:2],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:3 forFirstValue:20 forSecondValue:10],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:3 forFirstValue:4 forSecondValue:2],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:3 forFirstValue:6 forSecondValue:2],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:3 forFirstValue:6 forSecondValue:3],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:3 forFirstValue:9 forSecondValue:3],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:3 forFirstValue:30 forSecondValue:3],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:3 forFirstValue:30 forSecondValue:10],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:3 forFirstValue:40 forSecondValue:4],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:3 forFirstValue:40 forSecondValue:10],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:3 forFirstValue:50 forSecondValue:5],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:3 forFirstValue:50 forSecondValue:10],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:3 forFirstValue:6 forSecondValue:1],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:3 forFirstValue:6 forSecondValue:6],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:3 forFirstValue:7 forSecondValue:1],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:3 forFirstValue:7 forSecondValue:7],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:3 forFirstValue:8 forSecondValue:1],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:3 forFirstValue:8 forSecondValue:8],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:3 forFirstValue:9 forSecondValue:1],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:3 forFirstValue:9 forSecondValue:9],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:3 forFirstValue:8 forSecondValue:2],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:3 forFirstValue:8 forSecondValue:4],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:3 forFirstValue:10 forSecondValue:2],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:3 forFirstValue:10 forSecondValue:5],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:3 forFirstValue:12 forSecondValue:2],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:3 forFirstValue:12 forSecondValue:6],
                              [[MathProblem alloc]initWithDifficulty:4 ofProblemType:3 forFirstValue:14 forSecondValue:2],
                              [[MathProblem alloc]initWithDifficulty:4 ofProblemType:3 forFirstValue:16 forSecondValue:2],
                              [[MathProblem alloc]initWithDifficulty:4 ofProblemType:3 forFirstValue:18 forSecondValue:2],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:3 forFirstValue:60 forSecondValue:6],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:3 forFirstValue:90 forSecondValue:9],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:3 forFirstValue:60 forSecondValue:10],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:3 forFirstValue:70 forSecondValue:10],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:3 forFirstValue:70 forSecondValue:7],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:3 forFirstValue:80 forSecondValue:8],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:3 forFirstValue:80 forSecondValue:10],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:3 forFirstValue:90 forSecondValue:10],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:3 forFirstValue:100 forSecondValue:10],
                              [[MathProblem alloc]initWithDifficulty:4 ofProblemType:3 forFirstValue:14 forSecondValue:7],
                              [[MathProblem alloc]initWithDifficulty:4 ofProblemType:3 forFirstValue:12 forSecondValue:3],
                              [[MathProblem alloc]initWithDifficulty:4 ofProblemType:3 forFirstValue:15 forSecondValue:3],
                              [[MathProblem alloc]initWithDifficulty:4 ofProblemType:3 forFirstValue:12 forSecondValue:4],
                              [[MathProblem alloc]initWithDifficulty:4 ofProblemType:3 forFirstValue:16 forSecondValue:4],
                              [[MathProblem alloc]initWithDifficulty:4 ofProblemType:3 forFirstValue:15 forSecondValue:5],
                              [[MathProblem alloc]initWithDifficulty:4 ofProblemType:3 forFirstValue:20 forSecondValue:5],
                              [[MathProblem alloc]initWithDifficulty:4 ofProblemType:3 forFirstValue:25 forSecondValue:5],
                              [[MathProblem alloc]initWithDifficulty:4 ofProblemType:3 forFirstValue:18 forSecondValue:6],
                              [[MathProblem alloc]initWithDifficulty:4 ofProblemType:3 forFirstValue:24 forSecondValue:6],
                              [[MathProblem alloc]initWithDifficulty:4 ofProblemType:3 forFirstValue:21 forSecondValue:7],
                              [[MathProblem alloc]initWithDifficulty:4 ofProblemType:3 forFirstValue:16 forSecondValue:8],
                              [[MathProblem alloc]initWithDifficulty:4 ofProblemType:3 forFirstValue:24 forSecondValue:8],
                              [[MathProblem alloc]initWithDifficulty:4 ofProblemType:3 forFirstValue:18 forSecondValue:9],
                              [[MathProblem alloc]initWithDifficulty:4 ofProblemType:3 forFirstValue:27 forSecondValue:9],
                              [[MathProblem alloc]initWithDifficulty:6 ofProblemType:3 forFirstValue:18 forSecondValue:3],
                              [[MathProblem alloc]initWithDifficulty:6 ofProblemType:3 forFirstValue:21 forSecondValue:3],
                              [[MathProblem alloc]initWithDifficulty:6 ofProblemType:3 forFirstValue:20 forSecondValue:4],
                              [[MathProblem alloc]initWithDifficulty:6 ofProblemType:3 forFirstValue:24 forSecondValue:4],
                              [[MathProblem alloc]initWithDifficulty:6 ofProblemType:3 forFirstValue:30 forSecondValue:5],
                              [[MathProblem alloc]initWithDifficulty:6 ofProblemType:3 forFirstValue:35 forSecondValue:5],
                              [[MathProblem alloc]initWithDifficulty:6 ofProblemType:3 forFirstValue:30 forSecondValue:6],
                              [[MathProblem alloc]initWithDifficulty:6 ofProblemType:3 forFirstValue:36 forSecondValue:6],
                              [[MathProblem alloc]initWithDifficulty:6 ofProblemType:3 forFirstValue:28 forSecondValue:7],
                              [[MathProblem alloc]initWithDifficulty:6 ofProblemType:3 forFirstValue:35 forSecondValue:7],
                              [[MathProblem alloc]initWithDifficulty:6 ofProblemType:3 forFirstValue:32 forSecondValue:8],
                              [[MathProblem alloc]initWithDifficulty:6 ofProblemType:3 forFirstValue:40 forSecondValue:8],
                              [[MathProblem alloc]initWithDifficulty:6 ofProblemType:3 forFirstValue:36 forSecondValue:9],
                              [[MathProblem alloc]initWithDifficulty:6 ofProblemType:3 forFirstValue:45 forSecondValue:9],
                              [[MathProblem alloc]initWithDifficulty:8 ofProblemType:3 forFirstValue:24 forSecondValue:3],
                              [[MathProblem alloc]initWithDifficulty:8 ofProblemType:3 forFirstValue:27 forSecondValue:3],
                              [[MathProblem alloc]initWithDifficulty:8 ofProblemType:3 forFirstValue:28 forSecondValue:4],
                              [[MathProblem alloc]initWithDifficulty:8 ofProblemType:3 forFirstValue:32 forSecondValue:4],
                              [[MathProblem alloc]initWithDifficulty:8 ofProblemType:3 forFirstValue:36 forSecondValue:4],
                              [[MathProblem alloc]initWithDifficulty:8 ofProblemType:3 forFirstValue:40 forSecondValue:5],
                              [[MathProblem alloc]initWithDifficulty:8 ofProblemType:3 forFirstValue:45 forSecondValue:5],
                              [[MathProblem alloc]initWithDifficulty:8 ofProblemType:3 forFirstValue:42 forSecondValue:6],
                              [[MathProblem alloc]initWithDifficulty:8 ofProblemType:3 forFirstValue:48 forSecondValue:6],
                              [[MathProblem alloc]initWithDifficulty:8 ofProblemType:3 forFirstValue:54 forSecondValue:6],
                              [[MathProblem alloc]initWithDifficulty:8 ofProblemType:3 forFirstValue:42 forSecondValue:7],
                              [[MathProblem alloc]initWithDifficulty:8 ofProblemType:3 forFirstValue:49 forSecondValue:7],
                              [[MathProblem alloc]initWithDifficulty:8 ofProblemType:3 forFirstValue:56 forSecondValue:7],
                              [[MathProblem alloc]initWithDifficulty:8 ofProblemType:3 forFirstValue:63 forSecondValue:7],
                              [[MathProblem alloc]initWithDifficulty:8 ofProblemType:3 forFirstValue:48 forSecondValue:8],
                              [[MathProblem alloc]initWithDifficulty:8 ofProblemType:3 forFirstValue:56 forSecondValue:8],
                              [[MathProblem alloc]initWithDifficulty:8 ofProblemType:3 forFirstValue:64 forSecondValue:8],
                              [[MathProblem alloc]initWithDifficulty:8 ofProblemType:3 forFirstValue:72 forSecondValue:8],
                              [[MathProblem alloc]initWithDifficulty:8 ofProblemType:3 forFirstValue:54 forSecondValue:9],
                              [[MathProblem alloc]initWithDifficulty:8 ofProblemType:3 forFirstValue:63 forSecondValue:9],
                              [[MathProblem alloc]initWithDifficulty:8 ofProblemType:3 forFirstValue:72 forSecondValue:9],
                              [[MathProblem alloc]initWithDifficulty:8 ofProblemType:3 forFirstValue:81 forSecondValue:9]
                            ].mutableCopy;
}

@end
