//
//  MySignInViewController.m
//  Mathletes
//
//  Created by MobileMath.co on 2/7/14.
//  Copyright (c) 2014 MobileMath.co. All rights reserved.
//

#import "MySignUpViewController.h"
#import "UIImage+ImageWithColor.h"

@interface MySignUpViewController ()

@end

@implementation MySignUpViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    for (UIButton *button in self.view.subviews)
    {
        if ([button isKindOfClass:[UIButton class]])
        {
            button.titleLabel.font = [UIFont fontWithName:@"Miso-Bold" size:24];
            UIImage *img = [UIImage imageWithColor:[UIColor myGreenColor]];
            [self.signUpView.signUpButton setBackgroundImage:img forState:UIControlStateNormal];
            self.signUpView.signUpButton.clipsToBounds = YES;
            self.signUpView.signUpButton.layer.cornerRadius = 5.0;
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
    
    self.signUpView.signUpButton.layer.borderWidth = 1.0f;
    self.signUpView.signUpButton.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    
    [self.signUpView setBackgroundColor:[UIColor whiteColor]];
    
    [self.signUpView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mobile_math_signup_brand"]]];
    
}

@end
