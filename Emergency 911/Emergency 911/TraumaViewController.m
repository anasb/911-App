//
//  TraumaViewController.m
//  Emergency 911
//
//  Created by Anas Bouzoubaa on 26/11/15.
//  Copyright © 2015 Cornell Tech. All rights reserved.
//

#import "TraumaViewController.h"
#import "CurrentReport.h"

@interface TraumaViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) IBOutlet UICollectionView *myCollectionView;

@end

@implementation TraumaViewController

//------------------------------------------------------------------------------------------
#pragma mark - View lifecycle -
//------------------------------------------------------------------------------------------

- (void)viewDidLoad {

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(175, 175)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [flowLayout setSectionInset:UIEdgeInsetsMake(25, 10, 0, 10)];
    
    [self.myCollectionView setCollectionViewLayout:flowLayout];
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//------------------------------------------------------------------------------------------
#pragma mark - UICollectionView -
//------------------------------------------------------------------------------------------

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 6;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    UILabel *label = (UILabel*)[cell viewWithTag:100];
    
    NSArray *traumas = [NSArray arrayWithObjects:@"Fall", @"Pedestrian Struck", @"Motor Vehicle Accident", @"Assault", @"Burn", @"Other", nil];
    [label setText:traumas[indexPath.row]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *traumas = [NSArray arrayWithObjects:@"Fall", @"Pedestrian Struck", @"Motor Vehicle Accident", @"Assault", @"Burn", @"Other", nil];
    [[CurrentReport sharedReport] setTraumaType:[traumas objectAtIndex:indexPath.row]];
}

@end
