//
//  MyLoginViewController.m
//  Mathletes
//
//  Created by Sonam Mehta on 2/24/14.
//  Copyright (c) 2014 Kagan Riedel. All rights reserved.
//

#import "MyLoginViewController.h"

@interface MyLoginViewController () <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

@end

@implementation MyLoginViewController


//- (void)viewDidLoad
//{
//        [super viewDidLoad];
//        
//        [self.logInView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"main_background.png"]]];
//        [self.logInView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]]];
//        
//        // Set buttons appearance
//        [self.logInView.dismissButton setImage:[UIImage imageNamed:@"exit.png"] forState:UIControlStateNormal];
//        [self.logInView.dismissButton setImage:[UIImage imageNamed:@"exit_down.png"] forState:UIControlStateHighlighted];
//        
//        [self.logInView.signUpButton setBackgroundImage:[UIImage imageNamed:@"signup.png"] forState:UIControlStateNormal];
//        [self.logInView.signUpButton setBackgroundImage:[UIImage imageNamed:@"signup_down.png"] forState:UIControlStateHighlighted];
//        [self.logInView.signUpButton setTitle:@"" forState:UIControlStateNormal];
//        [self.logInView.signUpButton setTitle:@"" forState:UIControlStateHighlighted];
//        
//        // Add login field background
//        fieldsBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
//        [self.logInView insertSubview:fieldsBackground atIndex:1];
//        
//        // Remove text shadow
//        CALayer *layer = self.logInView.usernameField.layer;
//        layer.shadowOpacity = 0.0;
//        layer = self.logInView.passwordField.layer;
//        layer.shadowOpacity = 0.0;
//        
//        // Set field text color
//        [self.logInView.usernameField setTextColor:[UIColor colorWithRed:135.0f/255.0f green:118.0f/255.0f blue:92.0f/255.0f alpha:1.0]];
//        [self.logInView.passwordField setTextColor:[UIColor colorWithRed:135.0f/255.0f green:118.0f/255.0f blue:92.0f/255.0f alpha:1.0]];
//        
//}



@end
