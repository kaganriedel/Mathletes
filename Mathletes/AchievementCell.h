//
//  AchievementCell.h
//  Mathletes
//
//  Created by MobileMath.co on 2/7/14.
//  Copyright (c) 2014 MobileMath.co. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Achievement.h"

@interface AchievementCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property Achievement *achievement;

@end
