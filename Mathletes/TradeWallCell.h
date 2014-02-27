//
//  TradeWallCell.h
//  Mathletes
//
//  Created by MobileMath.co on 2/7/14.
//  Copyright (c) 2014 MobileMath.co. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"

@interface TradeWallCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *giveImageView;
@property (weak, nonatomic) IBOutlet UIImageView *getImageView;
@property (weak, nonatomic) IBOutlet UILabel *giveLabel;
@property (weak, nonatomic) IBOutlet UILabel *getLabel;
@property PFObject *trade;

@end
