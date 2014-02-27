//
//  ViewController.h
//  Mathletes
//
//  Created by Kagan Riedel on 2/7/14.
//  Copyright (c) 2014 Kagan Riedel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface MathViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *operationLabel;
@property NSString *operationType;
@property int addend1, addend2;
@property int cardValue;
@property NSArray *userArray;
@property NSMutableArray *sortedProblems;

@end
