//
//  TradeWallCell.h
//  Mathletes
//
//  Created by Kagan Riedel on 2/17/14.
//  Copyright (c) 2014 Kagan Riedel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TradeWallCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *giveImageView;
@property (weak, nonatomic) IBOutlet UIImageView *getImageView;
@property NSString *give;
@property NSString *get;

@end
