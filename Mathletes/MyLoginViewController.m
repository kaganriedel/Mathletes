//
//  MyLoginViewController.m
//  Mathletes
//
//  Created by MobileMath.co on 2/7/14.
//  Copyright (c) 2014 MobileMath.co. All rights reserved.
//

#import "MyLoginViewController.h"
#import "UIImage+ImageWithColor.h"

@interface MyLoginViewController ()

@end

@implementation MyLoginViewController

- (id)init
{
    self = [super init];
    self.fields = PFLogInFieldsUsernameAndPassword | PFLogInFieldsLogInButton | PFLogInFieldsSignUpButton | PFLogInFieldsPasswordForgotten;
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
            button.clipsToBounds = YES;
            button.layer.cornerRadius = 5.0;
            button.layer.borderWidth = 1.0f;
            button.layer.borderColor = [[UIColor lightGrayColor]CGColor];
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

    
    img = [UIImage imageWithColor:[UIColor myBlueColor]];
    [self.logInView.logInButton setBackgroundImage:img forState:UIControlStateNormal];

    
    if (self.view.frame.size.height > 500)
    {
        [self.logInView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mobile_math_signup_brand"]]];
    }
    else
    {
        [self.logInView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mobile_math_signup_brand_small"]]];

    }
    
    
}

@end
