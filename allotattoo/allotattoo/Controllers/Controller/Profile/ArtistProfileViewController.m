//
//  ArtistProfileViewController.m
//  AllTattoo
//
//  Created by My Star on 7/3/16.
//  Copyright © 2016 AllTattoo. All rights reserved.
//

#import "ArtistProfileViewController.h"
#import <RESideMenu.h>
#import "ProfileSettingViewController.h"
#import "ArtistProfileSettingViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ArtistProfileViewController ()
{
    BOOL isShow;
    BOOL isFolllow;
    
    NSMutableArray *arrTattooistTattoos;
    NSMutableArray *arrTattooists;
    CGFloat lastContentOffset;
}
@end

@implementation ArtistProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUpdateBadge:) name:@"MenuUpdateArtist" object:nil];
    
    
    [_btnBack setHidden:YES];
    [_lblArtistName setHidden:YES];
    [_imgBack setHidden:YES];
   
    [SharedModel instance].arrUserFollows = [NSMutableArray array];
    [SharedModel instance].isUserCheckedFollow = NO;
    arrTattooists = [NSMutableArray array];
    arrTattooistTattoos = [NSMutableArray array];

    CHTCollectionViewWaterfallLayout *layout = (CHTCollectionViewWaterfallLayout *)self.collectionFeed.collectionViewLayout;
    layout.sectionInset = UIEdgeInsetsMake(7, 7, 7, 7);
    layout.headerHeight = 273.0f;
    layout.minimumColumnSpacing = 7.0f;
    layout.minimumInteritemSpacing = 7.0f;
    
    [self.collectionFeed registerNib:[UINib nibWithNibName:@"ArtistProfileHeaderView" bundle:nil] forSupplementaryViewOfKind:CHTCollectionElementKindSectionHeader withReuseIdentifier:@"ArtistProfileHeaderVC"];
    
//    if ([TattooUtilis getUserModel] != nil) {
//        artistModelProfil = [[UserModel alloc] initWithDictionary:[TattooUtilis getUserModel] error:nil];
        _artistModelProfil = [[UserModel alloc] initWithDictionary:[TattooUtilis getUserModel] error:nil];
        _lblArtistName.text = _artistModelProfil.user_Name;
        if (_artistModelProfil != nil) {
            int index = - 1;
            for (TattooModel *tempTattooModel in [SharedModel instance].arrTattoos) {
                index ++;
                NSString *userID = tempTattooModel.user_id;
                if ([userID rangeOfString:_artistModelProfil.user_id].location != NSNotFound) {
                    [arrTattooistTattoos addObject:tempTattooModel];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [_collectionFeed reloadData];
            });
            
        }
}
- (void)handleUpdateBadge:(NSNotification *)notifcation
{
    NSNumber *cnt_num = [notifcation.userInfo objectForKey:@"badgecount"];
    if ([notifcation.name isEqualToString:@"MenuUpdateArtist"] && cnt_num.intValue > 0) {

    }
}
- (void) initCustomUI:(UserModel *)artistModel  withHeaderView:(ArtistProfileHeaderView *)headerView{
    if ([SharedModel instance].arrNotificationModel.count > 0) {
        [headerView.imgBadge setHidden:NO];
    }else{
        [headerView.imgBadge setHidden:YES];
    }
    headerView.imgUserPic.layer.backgroundColor=[[UIColor clearColor] CGColor];
    headerView.imgUserPic.layer.cornerRadius=headerView.imgUserPic.frame.size.width/2;
    headerView.imgUserPic.clipsToBounds = YES;
    headerView.imgUserPic.layer.borderColor=[[UIColor redColor] CGColor];
    [headerView.imgUserPic sd_setImageWithURL:artistModel.user_photoURL placeholderImage:[UIImage imageNamed:@"no_photo"]];
    if ([artistModel.user_Name isEqualToString:@""] && artistModel.user_Name == nil) {
        headerView.lblArtistName.text = @"Nicalas Stouls";
    }else{
        headerView.lblArtistName.text = artistModel.user_Name;
    }
    
    if ([artistModel.userLocation isEqualToString:@""] && artistModel.userLocation == nil) {
        headerView.lblLocation.text = @"Paris";
    }else{
        headerView.lblLocation.text = artistModel.userLocation;
    }
    [FireBaseApiService onGetCommentCountWithUserID:artistModel.user_id withCompletion:^(NSMutableArray *arrCommentModel) {
        if (arrCommentModel.count > 0) {
            [SharedModel instance].arrCommentWithUserID = arrCommentModel;
            headerView.lblCommentCnt.text = [NSString stringWithFormat:@"%d",(int)[SharedModel instance].arrCommentWithUserID.count];
        }else{
            headerView.lblCommentCnt.text = [NSString stringWithFormat:@"%d",(int)0];
        }
    }];
    [FireBaseApiService onGetFollowersWithUserID:artistModel.user_id withCompletion:^(NSMutableArray *arrFollowers) {
        [SharedModel instance].isUserCheckedFollow = YES;
        if (arrFollowers.count > 0) {            
            headerView.lblFollowerCnt.text = [NSString stringWithFormat:@"%d",(int)arrFollowers.count];
        }
    }];
    if (arrTattooistTattoos.count > 0) {
        headerView.lblPostCnt.text = [NSString stringWithFormat:@"%d",(int)arrTattooistTattoos.count];
    }

    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];

}
#pragma mark UICollectionViewHeaderDelegate
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reuseView = nil;
    if ([kind isEqualToString:CHTCollectionElementKindSectionHeader]) {
        ArtistProfileHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"ArtistProfileHeaderVC" forIndexPath:indexPath];
        [self initCustomUI:_artistModelProfil withHeaderView:headerView];
        [headerView.btnMenu addTarget:self action:@selector(onShowMenuLeft:) forControlEvents:UIControlEventAllEvents];
        [headerView.btnProfileSetting addTarget:self action:@selector(onShowProfileSetting:) forControlEvents:UIControlEventAllEvents];
        reuseView = headerView;
    }
    return reuseView;
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (arrTattooistTattoos.count > 0) {
        return arrTattooistTattoos.count;
    }else{
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UserTattoFeedCell *cell = (UserTattoFeedCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"UserTattoFeedCell"                                                                                forIndexPath:indexPath];
    cell.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cell.layer.borderWidth = 0.5f;
    TattooModel *tempTattooModel = arrTattooistTattoos[indexPath.row];
    [cell.imgTatto sd_setImageWithURL:[NSURL URLWithString:tempTattooModel.tattoo_image_url] placeholderImage:[UIImage imageNamed:@"img_placeholder1"]];
    [FireBaseApiService onGetFavorTattooFromWithTattooIDFireBase:tempTattooModel.tattoo_id withQuery:nil withCompleteion:^(NSMutableArray *arrFavorTattoo) {
        tempTattooModel.like_number = [NSNumber numberWithInteger:arrFavorTattoo.count];
        if (tempTattooModel.like_number.intValue > 0) {
            cell.imgListPost.image = [UIImage imageNamed:@"btnlike"];
            cell.lblUserLikeNumber.text = [NSString stringWithFormat:@"%d",tempTattooModel.like_number.intValue];
        }else{
            cell.imgListPost.image = [UIImage imageNamed:@"btndislike"];
            cell.lblUserLikeNumber.text = [NSString stringWithFormat:@"%d",0];
        }
    } failure:^(NSError *error) {
        
    }];
    [FireBaseApiService onGetCommentCount:tempTattooModel.tattoo_id withCompletion:^(NSMutableArray *arrComment) {
        [SharedModel instance].arrCommentWithTattooID  = arrComment;
        tempTattooModel.comment_number = [NSNumber numberWithInteger:[SharedModel instance].arrCommentWithTattooID.count];
        cell.lblUserCommitNumber.text = [NSString stringWithFormat:@"%d",tempTattooModel.comment_number.intValue];
        
    }];  
    
    return cell;
}
#pragma UICollectionView delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SinglePhotoViewController *singlePhotoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SinglePhotoViewController"];
    singlePhotoVC.singleTattooModel = arrTattooistTattoos[indexPath.row];
    [self.navigationController pushViewController:singlePhotoVC animated:YES];
}
#pragma mark - CollectionViewDelegateWaterFallLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    CGFloat width = 0;
    int scaleFactor = 0;
    scaleFactor = (int)indexPath.row % 4;
    switch (scaleFactor) {
        case 0:
            //            height = self.view.frame.size.height/factor;
            height = 230;
            break;
        case 1:
            //            height = self.view.frame.size.height/factor + 60 ;
            height = 290;
            break;
        case 2:
            //            height = self.view.frame.size.height/factor + 60;
            height = 290;
            break;
        case 3:
            height = 230;
            break;
        default:
            break;
    }
    width = self.view.frame.size.width/2 - 10;
    return CGSizeMake(width, height);
}
#pragma mark ScrollViewDelegate
#pragma mark Scrollview delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    lastContentOffset = scrollView.contentOffset.y;
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.viewNav layoutIfNeeded];
    if (lastContentOffset < scrollView.contentOffset.y && scrollView.contentOffset.y > 250) {
        self.constraintViewNav.constant = 84.0f;
//
        [UIView animateWithDuration:0.8 animations:^{
            [_imgBack setHidden:NO];
            [_btnBack setHidden:NO];
            [_lblArtistName setHidden:NO];
            [self.viewNav layoutIfNeeded];
        }];
    }else if(lastContentOffset > scrollView.contentOffset.y && scrollView.contentOffset.y < 250){
        self.constraintViewNav.constant = 0.0f;
//        
        [UIView animateWithDuration:0.5 animations:^{
            [_imgBack setHidden:YES];
            [_btnBack setHidden:YES];
            [_lblArtistName setHidden:YES];
            [self.viewNav layoutIfNeeded];
        }];
    }
    
}


#pragma mark events
- (IBAction)onShowMenuLeft:(id)sender {
//    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[self onScreenCapture],@"image", nil];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateImage" object:self userInfo:userInfo];
    [self.sideMenuViewController presentLeftMenuViewController];
}
#pragma mark OnScreenCpature
- (UIImage *)onScreenCapture{
    UIGraphicsBeginImageContext(CGSizeMake(60, self.view.frame.size.height));
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
- (IBAction)onShowProfileSetting:(id)sender {
    ArtistProfileSettingViewController *profileSettingVC  = [self.storyboard instantiateViewControllerWithIdentifier:@"ArtistProfileSettingViewController"];
    [self presentViewController:profileSettingVC animated:YES completion:nil];
}
- (IBAction)onBackTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)onCaptureTattoo:(id)sender {
    [self openCamera];
}

#pragma mark Open Camera
- (void) openCamera
{
    DBCameraContainerViewController *cameraContainer = [[DBCameraContainerViewController alloc] initWithDelegate:self];
    [cameraContainer setFullScreenMode];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:cameraContainer];
    [nav setNavigationBarHidden:YES];
    [self presentViewController:nav animated:YES completion:nil];
}
#pragma mark - DBCameraViewControllerDelegate

- (void) camera:(id)cameraViewController didFinishWithImage:(UIImage *)image withMetadata:(NSDictionary *)metadata
{
    PhotoSubmitViewController *customCameraVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoSubmitViewController"];
    dispatch_async(dispatch_get_main_queue(), ^{        
        customCameraVC.imageCaptured = image;
    });
    [self.presentedViewController dismissViewControllerAnimated:NO completion:(^{
        [self.navigationController pushViewController:customCameraVC animated:YES];
    })];
}

- (void) dismissCamera:(id)cameraViewController{
    [self dismissViewControllerAnimated:YES completion:nil];
    [cameraViewController restoreFullScreenMode];
}
#pragma mark failedAlertAction
- (void)failedAlertAction:(NSString*)message {
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:nil
                                  message:message
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Ok"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}
@end
