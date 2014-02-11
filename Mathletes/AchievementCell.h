//
//  AchievementCell.h
//  Mathletes
//
//  Created by Kagan Riedel on 2/10/14.
//  Copyright (c) 2014 Kagan Riedel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Achievement.h"

@interface AchievementCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property Achievement *achievement;

@end
