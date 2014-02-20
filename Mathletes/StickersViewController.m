//
//  StickersViewController.m
//  Mathletes
//
//  Created by Kagan Riedel on 2/10/14.
//  Copyright (c) 2014 Kagan Riedel. All rights reserved.
//

#import "StickersViewController.h"
#import "StickerCell.h"
#import "StickerDetailViewController.h"
#import "Parse/Parse.h"

@interface StickersViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

{
    __weak IBOutlet UICollectionView *stickerCollectionView;
    NSArray *stickers;
    NSArray *userStickers;
}

@end


@implementation StickersViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
//    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:250.0/255.0 green:228.0/255.0 blue:66.0/255.0 alpha:1.0];
    
    
    stickers = @[@"lion.png",@"kitten.png",@"star.png", @"puppy.png", @"tiger.png", @"murray.png", @"bear.png", @"pizza.png"];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    PFUser *user = [PFUser currentUser];
    
    userStickers = @[[user objectForKey:@"lionCount"]?:@(0),
                     [user objectForKey:@"kittenCount"]?:@(0),
                     [user objectForKey:@"starCount"]?:@(0),
                     [user objectForKey:@"puppyCount"]?:@(0),
                     [user objectForKey:@"tigerCount"]?:@(0),
                     [user objectForKey:@"murrayCount"]?:@(0),
                     [user objectForKey:@"bearCount"]?:@(0),
                     [user objectForKey:@"pizzaCount"]?:@(0)
                     ];
    
    
    [stickerCollectionView reloadData];
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"StickerSegue" sender:indexPath];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"StickerSegue"])
    {
        NSIndexPath *indexPath = sender;
        StickerCell *cell = (StickerCell*)[stickerCollectionView cellForItemAtIndexPath:indexPath];
        
        StickerDetailViewController *vc = segue.destinationViewController;
        vc.stickerImageName = cell.stickerImageName;
        vc.count = cell.count;
    }
}

-(StickerCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    StickerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StickerCell" forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:stickers[indexPath.row]];
    cell.imageView.layer.cornerRadius = 35.0;
    cell.stickerImageName = stickers[indexPath.row];
    
    cell.count = userStickers[indexPath.row];
    if (cell.count.integerValue == 0)
    {
        cell.imageView.alpha = 0.2;
    }
    else
    {
        cell.imageView.alpha = 1.0;
    }
    
    cell.countLabel.text = [NSString stringWithFormat:@"x%@", cell.count];
    
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return stickers.count;
}

@end
