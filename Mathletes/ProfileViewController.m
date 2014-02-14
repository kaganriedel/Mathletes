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
    __weak IBOutlet UILabel *userNameLabel;
    __weak IBOutlet UIButton *profileImageButton;
    
}

@end

@implementation ProfileViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
   
    profileImageButton.layer.cornerRadius = 25;
    [profileImageButton setBackgroundImage:[UIImage imageNamed:@"boy.png"] forState:UIControlStateNormal];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];

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
    }];
    
    //receive their first sticker and set it to their profile pic
}

-(void)setTitle
{
    NSString *username = [PFUser currentUser].username;
    NSString *cappedFirstChar = [[username substringToIndex:1] uppercaseString];
    NSString *cappedString = [username stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:cappedFirstChar];
    userNameLabel.text = cappedString;
}

-(void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user
{
    [logInController dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)onLogOut:(id)sender
{
    [PFUser logOut];
    
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:[NSBundle mainBundle].bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
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
