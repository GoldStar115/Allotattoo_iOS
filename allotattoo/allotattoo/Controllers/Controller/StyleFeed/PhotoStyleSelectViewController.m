//
//  PhotoStyleSelectViewController.m
//  AllTattoo
//
//  Created by My Star on 7/4/16.
//  Copyright © 2016 AllTattoo. All rights reserved.
//

#import "PhotoStyleSelectViewController.h"
#import "PhotoStyleCell.h"
@interface PhotoStyleSelectViewController ()
{
    NSString *selectedStyleID;
    NSString *selectedStyleName;
}
@end

@implementation PhotoStyleSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [FireBaseApiService onGetTattooStylesFromFireBase:^(NSMutableArray *arrStyleTattoo) {
        [SharedModel instance].arrStyles = arrStyleTattoo;
        [_collectionStyleSelect reloadData];
    } failure:^(NSError *error) {
        NSLog(@"error = %@",error);
    }];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark collectionview DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [SharedModel instance].arrStyles.count
    ;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return  1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    StyleModel *styleModel = [SharedModel instance].arrStyles[indexPath.row];
    PhotoStyleCell *cell = (PhotoStyleCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoStyleCell"                                                                                forIndexPath:indexPath];
    cell.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cell.layer.borderWidth = 0.5f;
    [cell.imgStyle sd_setImageWithURL:[NSURL URLWithString:styleModel.style_image_url] placeholderImage:[UIImage imageNamed:@"img_style_blackwork"]];
    cell.lblStyleTitle.text = styleModel.style_title;
    return cell;
}

#pragma mark CollectionView Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.viewValid setBackgroundColor:[UIColor colorWithRed:6.0f/255.0f green:190.0f/255.0f blue:189.0f/255.0f alpha:1.0f]];
    PhotoStyleCell *photoStyleCell = (PhotoStyleCell *)[collectionView cellForItemAtIndexPath:indexPath];
    StyleModel *styleModel = [SharedModel instance].arrStyles[indexPath.row];
    selectedStyleID = styleModel.style_id;
    selectedStyleName = styleModel.style_title;
    [photoStyleCell.viewBlur setAlpha:0.7f];
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoStyleCell *photoStyleCell = (PhotoStyleCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [photoStyleCell.viewBlur setAlpha:0.0f];
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.view.frame.size.width/2 - 10, self.view.frame.size.height/6);
}
- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)onValied:(id)sender {
    if (![selectedStyleID  isEqualToString:@""]) {
        [SharedModel instance].postTattooModel.style_id = selectedStyleID;
        [SharedModel instance].postContentModel.style_name = selectedStyleName;
    }
    [self.navigationController popViewControllerAnimated:YES];
}
@end
