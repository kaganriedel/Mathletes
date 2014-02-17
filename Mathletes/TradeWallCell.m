//
//  TradeWallCell.m
//  Mathletes
//
//  Created by Kagan Riedel on 2/17/14.
//  Copyright (c) 2014 Kagan Riedel. All rights reserved.
//

#import "TradeWallCell.h"

@implementation TradeWallCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    _imageView1.layer.cornerRadius = 20.0;
    _imageView2.layer.cornerRadius = 20.0;

    return self;
}


@end
