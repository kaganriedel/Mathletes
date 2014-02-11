//
//  ProfileViewController.m
//  Mathletes
//
//  Created by Kagan Riedel on 2/7/14.
//  Copyright (c) 2014 Kagan Riedel. All rights reserved.
//

#import "ProfileViewController.h"
#import "Parse/Parse.h"

@interface ProfileViewController () <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>
{
    __weak IBOutlet UIImageView *profileImageView;
    __weak IBOutlet UILabel *userNameLabel;
    
}

@end

@implementation ProfileViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setTitle];
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self checkForLoggedInUserAnimated:animated];
}

-(void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user
{
    [signUpController dismissViewControllerAnimated:YES completion:^{
        [self dismissViewControllerAnimated:YES completion:nil];
        
        //when a new user signs up set all the counts to 0
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        [userDefaults setInteger:0 forKey:@"lionCount"];
        [userDefaults setInteger:0 forKey:@"kittenCount"];
        [userDefaults setInteger:0 forKey:@"starCount"];
        [userDefaults setInteger:0 forKey:@"puppyCount"];
        [userDefaults setInteger:0 forKey:@"tigerCount"];
        [userDefaults setInteger:0 forKey:@"moonCount"];
        [userDefaults setInteger:0 forKey:@"giraffeCount"];
        [userDefaults setInteger:0 forKey:@"sunCount"];
        
        [userDefaults setInteger:0 forKey:@"totalAdds"];
        [userDefaults setInteger:0 forKey:@"totalSubs"];
        [userDefaults setInteger:0 forKey:@"totalMults"];
        [userDefaults setInteger:0 forKey:@"totalDivides"];
        
        [userDefaults synchronize];
    }];
    
    //receive their first sticker and set it to their profile pic
}

-(void)setTitle
{
    userNameLabel.text = [PFUser currentUser].username;
    NSString *cappedFirstChar = [[userNameLabel.text substringToIndex:1] uppercaseString];
    NSString *cappedString = [userNameLabel.text stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:cappedFirstChar];
    self.navigationItem.title = cappedString;
}

-(void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user
{
    [logInController dismissViewControllerAnimated:YES completion:nil];
    [self setTitle];
}

- (IBAction)onLogOut:(id)sender
{
    [PFUser logOut];
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




@end
