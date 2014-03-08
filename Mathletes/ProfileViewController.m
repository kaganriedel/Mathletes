//
//  ProfileViewController.m
//  Mathletes
//
//  Created by MobileMath.co on 2/7/14.
//  Copyright (c) 2014 MobileMath.co. All rights reserved.
//

#import "ProfileViewController.h"
#import "Parse/Parse.h"
#import "MathProblem.h"
#import "CMNavBarNotificationView/CMNavBarNotificationView.h"
#import "CSAnimationView.h"
#import "MyLoginViewController.h"
#import "MySignUpViewController.h"


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
    
    CSAnimationView *loadView;
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
    
    profileButton.exclusiveTouch = stickersButton.exclusiveTouch = achievementsButton.exclusiveTouch = mathButton.exclusiveTouch = progressButton.exclusiveTouch = YES;
    
    
    
    NSLog(@"time since dailyMathStartDate: %f", [[NSDate date] timeIntervalSinceDate:[user objectForKey:@"dailyMathStartDate"]]);
    //if its been more than a day since the last reset of dailyMath, reset it
    if ([[NSDate date] timeIntervalSinceDate:[user objectForKey:@"dailyMathStartDate"]] >= 86400.0)
    {
        [user setObject:@0 forKey:@"dailyMath"];
        
        [userDefaults setBool:NO forKey:@"Daily Math x10!"];
        [userDefaults setBool:NO forKey:@"Daily Math x20!"];
        [userDefaults setBool:NO forKey:@"Daily Math x30!"];
        [userDefaults setBool:NO forKey:@"Daily Math x40!"];
        [userDefaults setBool:NO forKey:@"Daily Math x50!"];
        
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

-(void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)signedUpUser
{
    user = signedUpUser;
    [self loadMathProblems];
    [signUpController dismissViewControllerAnimated:YES completion:^
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    //receive their first sticker and set it to their profile pic
}

- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController
           shouldBeginSignUp:(NSDictionary *)info
{
    NSString *username = info[@"username"];
    
    if (username.length > 15)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Username Too Long" message:@"Try a name that is not more than 15 characters." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
    }
    
    return (BOOL)(username.length <= 15);
}

-(void)checkForMathProblems
{
    PFQuery *query = [PFQuery queryWithClassName:@"MathProblem"];
    [query whereKey:@"mathUser" equalTo:user];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error)
        {
            if (objects.count == 0)
            {
                [self loadMathProblems];
            }
        }
    }];
}

-(void)loadMathProblems
{
    loadView = [[CSAnimationView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:loadView];
    
    UILabel *loadLabel = [UILabel new];
    loadLabel.text = @"Your user will be ready to go in a moment!";
    loadLabel.textAlignment = NSTextAlignmentCenter;
    loadLabel.font = [UIFont fontWithName:@"Miso-Bold" size:30];
    loadLabel.numberOfLines = 2;
    loadLabel.lineBreakMode = NSLineBreakByWordWrapping;
    loadLabel.textColor = [UIColor whiteColor];
    [loadView addSubview:loadLabel];

    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [spinner startAnimating];
    [loadView addSubview:spinner];

    if (self.view.frame.size.height > 500)
    {
        loadView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"mobilemath-splash_big.png"]];
        loadLabel.frame = CGRectMake(50, 375, 220, 80);
        spinner.center = CGPointMake(160, 340);
    }
    else
    {
        loadView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"mobilemath-splash_small.png"]];
        loadLabel.frame = CGRectMake(50, 330, 240, 80);
        spinner.center = CGPointMake(160, 310);
    }
    
    _userArray = [self cardDifficulty];
    _subtractionUserArray = [self subtractionDifficulty];
    _multplicationUserArray = [self multiplicationDifficulty];
    _divisionUserArray = [self divisionDifficulty];
    
    NSMutableArray *allMathProblems = [NSMutableArray new];
    [allMathProblems addObjectsFromArray:_userArray];
    [allMathProblems addObjectsFromArray:_subtractionUserArray];
    [allMathProblems addObjectsFromArray:_multplicationUserArray];
    [allMathProblems addObjectsFromArray:_divisionUserArray];
    
    [PFObject saveAllInBackground:allMathProblems block:^(BOOL succeeded, NSError *error)
    {
        if (succeeded)
        {
            [loadView removeFromSuperview];
        }
        else
        {
            [[[UIAlertView alloc] initWithTitle:@"Oops! Try logging in again" message:error.localizedFailureReason delegate:self cancelButtonTitle:@"Log Out" otherButtonTitles:nil] show];
        }
    }];
}

-(void)setProfileImage
{
    if ([user objectForKey:@"profileImage"])
    {
        [profileButton setImage:[UIImage imageNamed:[user objectForKey:@"profileImage"]] forState:UIControlStateNormal];
    }
    else
    {
        [profileButton setImage:[UIImage imageNamed:@"mobilemath_logo-100-100.png"] forState:UIControlStateNormal];
    }
}

-(void)setTitle
{
    NSString *username = [PFUser currentUser].username;
    NSString *cappedFirstChar = [[username substringToIndex:1] uppercaseString];
    NSString *cappedString = [username stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:cappedFirstChar];
    profileLabel.text = cappedString;
    profileLabel.adjustsFontSizeToFitWidth = YES;
    profileLabel.minimumScaleFactor = 0.8;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [PFUser logOut];
}

-(void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)loggedInUser
{
    [logInController dismissViewControllerAnimated:YES completion:nil];
    user = loggedInUser;
    [self setProfileImage];
    [self checkAchievementsForLoggedInUser];
    [self checkForMathProblems];
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
        MyLoginViewController *loginViewController = [MyLoginViewController new];
        loginViewController.delegate = self;
        
        MySignUpViewController *signUpViewController = [MySignUpViewController new];
        signUpViewController.delegate = self;
        loginViewController.signUpController = signUpViewController;
        
        [self presentViewController:loginViewController animated:YES completion:NULL];
        [self presentViewController:signUpViewController animated:YES completion:NULL];
    }
    else
    {
        PFQuery *query = [PFQuery queryWithClassName:@"AcceptedTrade"];
        [query whereKey:@"user" equalTo:[PFUser currentUser]];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            for (PFObject *acceptedTrade in objects) {
                NSString *removedUnderscoresString = [[acceptedTrade objectForKey:@"get"] stringByReplacingOccurrencesOfString:@"_" withString:@" "];
                NSNumber *getCount = [acceptedTrade objectForKey:@"getCount"] ?: @1;
                for (int x = 0; x < getCount.intValue; x++)
                {
                    [user increaseKey:[NSString stringWithFormat:@"%@Count",[acceptedTrade objectForKey:@"get"]]];
                }
                NSString *getPluralString = @"";
                if (getCount.intValue > 1)
                {
                    getPluralString = @"s";
                }
                [CMNavBarNotificationView notifyWithText:@"Your trade was accepted!"
                                                  detail:[NSString stringWithFormat:@"You got %@ %@ sticker%@!", getCount, removedUnderscoresString, getPluralString]
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
    if (totalAdds >= 450)
    {
        [userDefaults setBool:YES forKey:@"Add It Up x450!"];
    }
    if (totalAdds >= 420)
    {
        [userDefaults setBool:YES forKey:@"Add It Up x420!"];
    }
    if (totalAdds >= 390)
    {
        [userDefaults setBool:YES forKey:@"Add It Up x390!"];
    }
    if (totalAdds >= 360)
    {
        [userDefaults setBool:YES forKey:@"Add It Up x360!"];
    }
    if (totalAdds >= 330)
    {
        [userDefaults setBool:YES forKey:@"Add It Up x330!"];
    }
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
    if (totalFastAdds >= 500)
    {
        [userDefaults setBool:YES forKey:@"Adding At 500 Miles Per Hour!"];
    }
    if (totalFastAdds >= 450)
    {
        [userDefaults setBool:YES forKey:@"Adding At 450 Miles Per Hour!"];
    }
    if (totalFastAdds >= 400)
    {
        [userDefaults setBool:YES forKey:@"Adding At 400 Miles Per Hour!"];
    }
    if (totalFastAdds >= 350)
    {
        [userDefaults setBool:YES forKey:@"Adding At 350 Miles Per Hour!"];
    }
    if (totalFastAdds >= 300)
    {
        [userDefaults setBool:YES forKey:@"Adding At 300 Miles Per Hour!"];
    }
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
    if (totalSubs >= 450)
    {
        [userDefaults setBool:YES forKey:@"Take It Away x450!"];
    }
    if (totalSubs >= 420)
    {
        [userDefaults setBool:YES forKey:@"Take It Away x420!"];
    }
    if (totalSubs >= 390)
    {
        [userDefaults setBool:YES forKey:@"Take It Away x390!"];
    }
    if (totalSubs >= 360)
    {
        [userDefaults setBool:YES forKey:@"Take It Away x360!"];
    }
    if (totalSubs >= 330)
    {
        [userDefaults setBool:YES forKey:@"Take It Away x330!"];
    }
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
    if (totalFastSubs >= 500)
    {
        [userDefaults setBool:YES forKey:@"Subtracting At 500 \nMiles Per Hour!"];
    }
    if (totalFastSubs >= 450)
    {
        [userDefaults setBool:YES forKey:@"Subtracting At 450 \nMiles Per Hour!"];
    }
    if (totalFastSubs >= 400)
    {
        [userDefaults setBool:YES forKey:@"Subtracting At 400 \nMiles Per Hour!"];
    }
    if (totalFastSubs >= 350)
    {
        [userDefaults setBool:YES forKey:@"Subtracting At 350 \nMiles Per Hour!"];
    }
    if (totalFastSubs >= 300)
    {
        [userDefaults setBool:YES forKey:@"Subtracting At 300 \nMiles Per Hour!"];
    }
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
    if (totalMults >= 450)
    {
        [userDefaults setBool:YES forKey:@"Multiplicity x450!"];
    }
    if (totalMults >= 420)
    {
        [userDefaults setBool:YES forKey:@"Multiplicity x420!"];
    }
    if (totalMults >= 390)
    {
        [userDefaults setBool:YES forKey:@"Multiplicity x390!"];
    }
    if (totalMults >= 360)
    {
        [userDefaults setBool:YES forKey:@"Multiplicity x360!"];
    }
    if (totalMults >= 330)
    {
        [userDefaults setBool:YES forKey:@"Multiplicity x330!"];
    }
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
    if (totalFastMults >= 500)
    {
        [userDefaults setBool:YES forKey:@"Multiplying At 500 \nMiles Per Hour!"];
    }
    if (totalFastMults >= 450)
    {
        [userDefaults setBool:YES forKey:@"Multiplying At 450 \nMiles Per Hour!"];
    }
    if (totalFastMults >= 400)
    {
        [userDefaults setBool:YES forKey:@"Multiplying At 400 \nMiles Per Hour!"];
    }
    if (totalFastMults >= 350)
    {
        [userDefaults setBool:YES forKey:@"Multiplying At 350 \nMiles Per Hour!"];
    }
    if (totalFastMults >= 300)
    {
        [userDefaults setBool:YES forKey:@"Multiplying At 300 \nMiles Per Hour!"];
    }
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
    if (totalDivides >= 450)
    {
        [userDefaults setBool:YES forKey:@"Divide And Conquer x450!"];
    }
    if (totalDivides >= 420)
    {
        [userDefaults setBool:YES forKey:@"Divide And Conquer x420!"];
    }
    if (totalDivides >= 390)
    {
        [userDefaults setBool:YES forKey:@"Divide And Conquer x390!"];
    }
    if (totalDivides >= 360)
    {
        [userDefaults setBool:YES forKey:@"Divide And Conquer x360!"];
    }
    if (totalDivides >= 330)
    {
        [userDefaults setBool:YES forKey:@"Divide And Conquer x330!"];
    }
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
    if (totalFastDivides >= 500)
    {
        [userDefaults setBool:YES forKey:@"Dividing At 500 \nMiles Per Hour!"];
    }
    if (totalFastDivides >= 450)
    {
        [userDefaults setBool:YES forKey:@"Dividing At 450 \nMiles Per Hour!"];
    }
    if (totalFastDivides >= 400)
    {
        [userDefaults setBool:YES forKey:@"Dividing At 400 \nMiles Per Hour!"];
    }
    if (totalFastDivides >= 350)
    {
        [userDefaults setBool:YES forKey:@"Dividing At 350 \nMiles Per Hour!"];
    }
    if (totalFastDivides >= 300)
    {
        [userDefaults setBool:YES forKey:@"Dividing At 300 \nMiles Per Hour!"];
    }
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
    if (totalMathProblems >= 2000)
    {
        [userDefaults setBool:YES forKey:@"Keep It Up x2000!"];
    }
    if (totalMathProblems >= 1900)
    {
        [userDefaults setBool:YES forKey:@"Keep It Up x1900!"];
    }
    if (totalMathProblems >= 1800)
    {
        [userDefaults setBool:YES forKey:@"Keep It Up x1800!"];
    }
    if (totalMathProblems >= 1700)
    {
        [userDefaults setBool:YES forKey:@"Keep It Up x1700!"];
    }
    if (totalMathProblems >= 1600)
    {
        [userDefaults setBool:YES forKey:@"Keep It Up x1600!"];
    }
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
    NSNumber *boolNumber = [user objectForKey: @"completedAdditionProblems"];
    [userDefaults setBool: boolNumber.boolValue forKey:@"Add It All Up!"];
    
    achievementKey = @"Take It All Away!";
    boolNumber = [user objectForKey: @"completedSubtractionProblems"];
    [userDefaults setBool: boolNumber.boolValue forKey:@"Take It All Away!"];
    
    achievementKey = @"Multiplication Magician!";
    boolNumber = [user objectForKey: @"completedMultiplicationProblems"];
    [userDefaults setBool: boolNumber.boolValue forKey:@"Multiplication Magician!"];
    
    achievementKey = @"Conquer Division!";
    boolNumber = [user objectForKey: @"completedDivisionProblems"];
    [userDefaults setBool: boolNumber.boolValue forKey:@"Conquer Division!"];
    
    achievementKey = @"Math Master!";
    boolNumber = [user objectForKey: @"completedAllProblems"];
    [userDefaults setBool: boolNumber.boolValue forKey:@"Math Master!"];

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
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:3 forFirstValue:10 forSecondValue:1],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:3 forFirstValue:20 forSecondValue:2],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:3 forFirstValue:4 forSecondValue:2],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:3 forFirstValue:6 forSecondValue:2],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:3 forFirstValue:6 forSecondValue:3],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:3 forFirstValue:9 forSecondValue:3],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:3 forFirstValue:30 forSecondValue:3],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:3 forFirstValue:40 forSecondValue:4],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:3 forFirstValue:50 forSecondValue:5],
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
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:3 forFirstValue:10 forSecondValue:10],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:3 forFirstValue:20 forSecondValue:10],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:3 forFirstValue:60 forSecondValue:6],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:3 forFirstValue:90 forSecondValue:9],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:3 forFirstValue:70 forSecondValue:7],
                              [[MathProblem alloc]initWithDifficulty:2 ofProblemType:3 forFirstValue:80 forSecondValue:8],
                              [[MathProblem alloc]initWithDifficulty:4 ofProblemType:3 forFirstValue:30 forSecondValue:10],
                              [[MathProblem alloc]initWithDifficulty:4 ofProblemType:3 forFirstValue:40 forSecondValue:10],
                              [[MathProblem alloc]initWithDifficulty:4 ofProblemType:3 forFirstValue:50 forSecondValue:10],
                              [[MathProblem alloc]initWithDifficulty:4 ofProblemType:3 forFirstValue:14 forSecondValue:2],
                              [[MathProblem alloc]initWithDifficulty:4 ofProblemType:3 forFirstValue:16 forSecondValue:2],
                              [[MathProblem alloc]initWithDifficulty:4 ofProblemType:3 forFirstValue:18 forSecondValue:2],
                              [[MathProblem alloc]initWithDifficulty:4 ofProblemType:3 forFirstValue:60 forSecondValue:10],
                              [[MathProblem alloc]initWithDifficulty:4 ofProblemType:3 forFirstValue:70 forSecondValue:10],
                              [[MathProblem alloc]initWithDifficulty:4 ofProblemType:3 forFirstValue:14 forSecondValue:7],
                              [[MathProblem alloc]initWithDifficulty:4 ofProblemType:3 forFirstValue:12 forSecondValue:3],
                              [[MathProblem alloc]initWithDifficulty:4 ofProblemType:3 forFirstValue:15 forSecondValue:3],
                              [[MathProblem alloc]initWithDifficulty:4 ofProblemType:3 forFirstValue:80 forSecondValue:10],
                              [[MathProblem alloc]initWithDifficulty:4 ofProblemType:3 forFirstValue:90 forSecondValue:10],
                              [[MathProblem alloc]initWithDifficulty:4 ofProblemType:3 forFirstValue:100 forSecondValue:10],
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
                              [[MathProblem alloc]initWithDifficulty:8 ofProblemType:3 forFirstValue:35 forSecondValue:7],
                              [[MathProblem alloc]initWithDifficulty:8 ofProblemType:3 forFirstValue:32 forSecondValue:8],
                              [[MathProblem alloc]initWithDifficulty:8 ofProblemType:3 forFirstValue:40 forSecondValue:8],
                              [[MathProblem alloc]initWithDifficulty:6 ofProblemType:3 forFirstValue:36 forSecondValue:9],
                              [[MathProblem alloc]initWithDifficulty:6 ofProblemType:3 forFirstValue:45 forSecondValue:9],
                              [[MathProblem alloc]initWithDifficulty:6 ofProblemType:3 forFirstValue:24 forSecondValue:3],
                              [[MathProblem alloc]initWithDifficulty:6 ofProblemType:3 forFirstValue:27 forSecondValue:3],
                              [[MathProblem alloc]initWithDifficulty:6 ofProblemType:3 forFirstValue:28 forSecondValue:4],
                              [[MathProblem alloc]initWithDifficulty:8 ofProblemType:3 forFirstValue:32 forSecondValue:4],
                              [[MathProblem alloc]initWithDifficulty:8 ofProblemType:3 forFirstValue:36 forSecondValue:4],
                              [[MathProblem alloc]initWithDifficulty:8 ofProblemType:3 forFirstValue:40 forSecondValue:5],
                              [[MathProblem alloc]initWithDifficulty:8 ofProblemType:3 forFirstValue:45 forSecondValue:5],
                              [[MathProblem alloc]initWithDifficulty:8 ofProblemType:3 forFirstValue:42 forSecondValue:6],
                              [[MathProblem alloc]initWithDifficulty:8 ofProblemType:3 forFirstValue:42 forSecondValue:7],
                              [[MathProblem alloc]initWithDifficulty:8 ofProblemType:3 forFirstValue:49 forSecondValue:7],
                              [[MathProblem alloc]initWithDifficulty:8 ofProblemType:3 forFirstValue:48 forSecondValue:8],
                              [[MathProblem alloc]initWithDifficulty:8 ofProblemType:3 forFirstValue:48 forSecondValue:6],
                              [[MathProblem alloc]initWithDifficulty:8 ofProblemType:3 forFirstValue:56 forSecondValue:8],
                              [[MathProblem alloc]initWithDifficulty:8 ofProblemType:3 forFirstValue:56 forSecondValue:7],
                              [[MathProblem alloc]initWithDifficulty:8 ofProblemType:3 forFirstValue:64 forSecondValue:8],
                              [[MathProblem alloc]initWithDifficulty:8 ofProblemType:3 forFirstValue:54 forSecondValue:9],
                              [[MathProblem alloc]initWithDifficulty:8 ofProblemType:3 forFirstValue:54 forSecondValue:6],
                              [[MathProblem alloc]initWithDifficulty:8 ofProblemType:3 forFirstValue:63 forSecondValue:9],
                              [[MathProblem alloc]initWithDifficulty:8 ofProblemType:3 forFirstValue:63 forSecondValue:7],
                              [[MathProblem alloc]initWithDifficulty:8 ofProblemType:3 forFirstValue:72 forSecondValue:9],
                              [[MathProblem alloc]initWithDifficulty:8 ofProblemType:3 forFirstValue:81 forSecondValue:9],
                              [[MathProblem alloc]initWithDifficulty:8 ofProblemType:3 forFirstValue:72 forSecondValue:8]
                            ].mutableCopy;
}

@end
