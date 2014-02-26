//
//  MyLoginViewController.m
//  Mathletes
//
//  Created by Sonam Mehta on 2/24/14.
//  Copyright (c) 2014 Kagan Riedel. All rights reserved.
//

#import "MyLoginViewController.h"
#import "UIImage+ImageWithColor.h"

@interface MyLoginViewController () <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

@end

@implementation MyLoginViewController

- (id)init
{
    self = [super init];
    self.fields = PFLogInFieldsUsernameAndPassword | PFLogInFieldsLogInButton | PFLogInFieldsSignUpButton;
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    for (UIButton *button in self.view.subviews)
    {
        if ([button isKindOfClass:[UIButton class]])
        {
            button.titleLabel.font = [UIFont fontWithName:@"Miso-Bold" size:24];
            button.layer.shadowOpacity = 1.0f;
            button.layer.borderWidth = 1.0f;
            button.layer.borderColor = [[UIColor lightGrayColor]CGColor];
            //button.reversesTitleShadowWhenHighlighted = YES;
        }
    }
    
    for (UITextField *textField in self.view.subviews)
    {
        if ([textField isKindOfClass:[UITextField class]])
        {
            textField.font = [UIFont fontWithName:@"Miso-Bold" size:20];
            textField.textColor = [UIColor darkGrayColor];
            textField.layer.cornerRadius = 5.0;
            textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:textField.placeholder attributes:@{NSFontAttributeName: [UIFont fontWithName:@"Miso-Light" size:20]}];
            textField.layer.borderColor = [[UIColor lightGrayColor]CGColor];
            textField.layer.borderWidth = 1.0f;
            textField.layer.masksToBounds = YES;
        }
    }
    
    for (UILabel *label in self.view.subviews)
    {
        if ([label isKindOfClass:[UILabel class]])
        {
            label.font = [UIFont fontWithName:@"Miso-Bold" size:16];
            label.textColor = [UIColor darkGrayColor];
        }
    }
    
    [self.logInView setBackgroundColor:[UIColor whiteColor]];
    UIImage *img = [UIImage imageWithColor:[UIColor myGreenColor]];
    [self.logInView.signUpButton setBackgroundImage:img forState:UIControlStateNormal];
    self.logInView.signUpButton.clipsToBounds = YES;
    self.logInView.signUpButton.layer.cornerRadius = 5.0;
    
    img = [UIImage imageWithColor:[UIColor myBlueColor]];
    [self.logInView.logInButton setBackgroundImage:img forState:UIControlStateNormal];
    self.logInView.logInButton.clipsToBounds = YES;
    self.logInView.logInButton.layer.cornerRadius = 5.0;
    
    [self.logInView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"math_login_screen_brand"]]];
    
    //[self.logInView.logInButton setFrame:CGRectMake(35.0f, 385.0f, 250.0f, 40.0f)];
    //[self.logInView.signUpButton setFrame:CGRectMake(35.0f, 385.0f, 250.0f, 40.0f)];
    
}

@end
