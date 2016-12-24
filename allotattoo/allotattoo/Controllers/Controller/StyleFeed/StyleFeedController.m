//
//  StyleFeedController.m
//  AllTattoo
//
//  Created by My Star on 7/2/16.
//  Copyright © 2016 AllTattoo. All rights reserved.
//

#import "StyleFeedController.h"
#import "SinglePhotoViewController.h"
#import "ArtistProfileViewController.h"
#import "PhotoSubmitViewController.h"
#import "PhotoFeedViewController.h"
#import "Constant.h"


@interface StyleFeedController ()
{
    BOOL isFirstCellSelect;
    BOOL isFiltered;
    PhotoFeedViewController *photoFeedVC;
}
@property NSMutableArray * arrStyleCategory;
@property NSMutableArray * arrTatto;
@property NSMutableArray * arrUserModels;
@property NSMutableArray * arrTattooSearchResult;
@property NSMutableArray * arrUserSearchResult;


@property UIView *indicatorView;
@end

@implementation StyleFeedController

- (void)viewDidLoad {
    [super viewDidLoad];
    photoFeedVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoFeedViewController"];
    
    isFirstCellSelect = NO;
    _txtSearch.delegate = self;
    _txtSearch.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Nicolas Stouls" attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
    _arrStyleCategory = [NSMutableArray array];
    _arrTatto = [NSMutableArray array];
    _arrUserModels = [NSMutableArray array];
    _arrTattooSearchResult = [NSMutableArray array];
    _arrUserSearchResult = [NSMutableArray array];

    
    [_viewSearch setHidden:YES];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    [self initCustomizeSearchBar];
    
    self.searchBarStyle.layer.borderWidth = 0;

    
    self.collectionCategory.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.collectionCategory.layer.borderWidth = 0;
   
    self.collectionInspiration.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.collectionInspiration.layer.borderWidth = 0;

    CHTCollectionViewWaterfallLayout *layout = (CHTCollectionViewWaterfallLayout *)self.collectionInspiration.collectionViewLayout;
    layout.sectionInset = UIEdgeInsetsMake(7, 7, 7, 7);
    layout.minimumColumnSpacing = 7.0f;
    layout.minimumInteritemSpacing = 7.0f;
    _viewSearch.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _viewSearch.layer.borderWidth = 0.0f;
    [_viewSearch setHidden:YES];
    
    [self getTattooAndUserModelWithStyleID:_style_id];
    self.lblCategoryTitle.text = _style_title;

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    isFiltered = NO;
}
- (void)initCustomizeSearchBar
{
    _viewSearch.layer.cornerRadius = 3.0f;
    _viewSearch.layer.masksToBounds = YES;
    
}
#pragma mark Get Tattoo and UserModel
- (void)getTattooAndUserModelWithStyleID:(NSString *)style_id
{
    [_arrTatto removeAllObjects];
    [_arrUserModels removeAllObjects];
    for (TattooModel *tattooModel in [SharedModel instance].arrTattoos) {
        if ([tattooModel.style_id isEqualToString:style_id]) {
            [_arrTatto addObject:tattooModel];
        }
    }
    UserModel *sel_userModel;
    for (TattooModel *tattooSelectModel in _arrTatto) {
        for (UserModel *userModel in [SharedModel instance].arrSharedUserModels) {
            if ([tattooSelectModel.user_id isEqualToString:userModel.user_id]){
                sel_userModel  = userModel;
                break;
            }
        }
        [_arrUserModels addObject:sel_userModel];
        
    }
    [_collectionInspiration reloadData];
}

-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    [self searchViewHidden];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView.tag == TAG_CATEGORY) {
        return _arrStyleCategory.count;
    }else if (collectionView.tag == TAG_FEED)
    {
        if (isFiltered) {
            return _arrTattooSearchResult.count;
        }else{
            return _arrTatto.count;
        }
    }else{
        return 0;
    }

}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
        StyleInspirationCell *styleFeedCell = (StyleInspirationCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"StyleInspirationCell"                                                                                forIndexPath:indexPath];
        styleFeedCell.layer.borderColor = [UIColor lightGrayColor].CGColor;
        styleFeedCell.layer.borderWidth = 0.5f;
        TattooModel *tattooModel;
        UserModel *tempUserModel;
        if (isFiltered) {
            tattooModel = _arrTattooSearchResult[indexPath.row];
            tempUserModel = _arrUserSearchResult[indexPath.row];
        }else{
            tattooModel = _arrTatto[indexPath.row];
            tempUserModel = _arrUserModels[indexPath.row];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            styleFeedCell.imgProfilePhoto.layer.cornerRadius = styleFeedCell.imgProfilePhoto.frame.size.width/2;
            styleFeedCell.imgProfilePhoto.clipsToBounds  = YES;
            [styleFeedCell.imgProfilePhoto  sd_setImageWithURL:tempUserModel.user_photoURL placeholderImage:[UIImage imageNamed:@"no_photo"]];
            styleFeedCell.lblProfileName.text = tempUserModel.user_Name;
        });
        [styleFeedCell.imgStyleFeed sd_setImageWithURL:[NSURL URLWithString:tattooModel.tattoo_image_url] placeholderImage:[UIImage imageNamed:@"img_placeholder1"]];
        [[[[mainRef child:FAVORTATTOO_TABLE] child:tattooModel.tattoo_id] child:[FIRAuth auth].currentUser.uid] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            if ([snapshot exists]) {
                tattooModel.like_flag = [NSNumber numberWithInt:1];
                styleFeedCell.imgPostLike.image = [UIImage imageNamed:@"btnlike"];
            }else{
                tattooModel.like_flag = [NSNumber numberWithInt:0];
                styleFeedCell.imgPostLike.image = [UIImage imageNamed:@"btndislike"];
            }
        }];
        [styleFeedCell.btnPostLike addTarget:self action:@selector(onPostCategoryTattoo:event:) forControlEvents:UIControlEventTouchUpInside];
//        [styleFeedCell.btnProfileVisite  addTarget:self action:@selector(myClickEvent:event:) forControlEvents:UIControlEventTouchUpInside];
        return styleFeedCell;

}


#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
        SinglePhotoViewController *singlePhotoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SinglePhotoViewController"];
        if (isFiltered) {
            singlePhotoVC.singleTattooModel = _arrTattooSearchResult[indexPath.row];
        }else{
            singlePhotoVC.singleTattooModel = _arrTatto[indexPath.row];
        }
        [self.navigationController pushViewController:singlePhotoVC animated:YES];
        
 
}
#pragma mark - UICollectionViewFlowLayoutDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
        CGFloat height = 0;
        CGFloat width = 0;
        int scaleFactor = 0;
        scaleFactor = (int)indexPath.row % 4;
        //    float factor = 2.3f;
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

- (IBAction)myClickEvent:(id)sender event:(id)event {
    
    NSSet *touches = [event allTouches];
    
    UITouch *touch = [touches anyObject];
    
    CGPoint currentTouchPosition = [touch locationInView:_collectionInspiration];
    
    NSIndexPath *indexPath = [_collectionInspiration indexPathForItemAtPoint: currentTouchPosition];
    TattooModel *tmpTattooModel = _arrTatto[indexPath.row];
    ArtistProfileViewController *artistProfileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ArtistProfileViewController"];
    OtherArtistProfileViewController *otherArtistVC = [self.storyboard instantiateViewControllerWithIdentifier:@"OtherArtistProfileViewController"];
    if ([tmpTattooModel.user_id isEqualToString:[FIRAuth auth].currentUser.uid]) {
        artistProfileVC.artistProfil_ID = tmpTattooModel.user_id;
        [self.navigationController pushViewController:artistProfileVC animated:YES];
    }else{
        otherArtistVC.artistProfil_ID = tmpTattooModel.user_id;
        [self.navigationController pushViewController:otherArtistVC animated:YES];
    }
    
    
}
#pragma mark Click Cell Post ICON
- (void)onPostCategoryTattoo:(id)sender event:(id)event {
    if ([TattooUtilis isReallyUser]) {
        NSSet *touches = [event allTouches];
        
        UITouch *touch = [touches anyObject];
        
        CGPoint currentTouchPosition = [touch locationInView:_collectionInspiration];
        NSIndexPath *indexPath = [_collectionInspiration indexPathForItemAtPoint: currentTouchPosition];
        TattooModel *temTattoModel =  _arrTatto[indexPath.row];
        if (temTattoModel.like_flag.intValue == 0)
        {
            temTattoModel.like_flag = [NSNumber numberWithInt:1];
            [self onAddFavorTattoo:mainRef withTattooModel:temTattoModel];
            if (![temTattoModel.user_id isEqualToString:[FIRAuth auth].currentUser.uid])
            {
                [FireBaseApiService onGetRegistrationToken:temTattoModel.user_id withCompletion:^(TokenModel *tokenModel) {
                    if (tokenModel != nil && tokenModel.regist_token != nil) {
                        [self sendPushNotificationWithLike:tokenModel.regist_token withTattooID:temTattoModel.tattoo_id];
                        
                    }
                }];
            }

                [_collectionInspiration reloadData];

        }else{
            temTattoModel.like_flag = [NSNumber numberWithInt:0];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self onRemoveFavorTable:mainRef withStyleModel:temTattoModel];
            [_collectionInspiration reloadData];

        }
    }else{
        NotationViewController *notationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NotationViewController"];
        [self.navigationController pushViewController:notationVC animated:YES];
    }

    
}
#pragma mark Post Favor Tattoo
- (void)onAddFavorTattoo:(FIRDatabaseReference *)ref withTattooModel:(TattooModel *)tattooModel{
    [[[[ref  child:FAVORTATTOO_TABLE] child:tattooModel.tattoo_id] child:[FIRAuth auth].currentUser.uid] setValue:@"Like"];
}
#pragma mark Remove TattooStyle From Favor Table
- (void)onRemoveFavorTable:(FIRDatabaseReference *)ref withStyleModel:(TattooModel *)tattooModel{
    FIRDatabaseReference *removeRef = [[[ref child:FAVORTATTOO_TABLE] child:tattooModel.tattoo_id] child:[FIRAuth auth].currentUser.uid];
    [removeRef setValue:nil];
}

#pragma mark send push message with Topic
- (void)sendPushNotificationWithLike:(NSString *)registToken withTattooID:(NSString *)tattooID{
    NSMutableArray *arrTattooIDs = [NSMutableArray array];
    [arrTattooIDs addObject:tattooID];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSLog(@"%@",[dateFormatter stringFromDate:[NSDate date]]);
    NSString *time = [dateFormatter stringFromDate:[NSDate date]];
    NSDictionary *messageDic = @{FOLLOW_ID:[FIRAuth auth].currentUser.uid,
                                 @"Time":time,
                                 @"CommentText":@"",
                                 @"NotificationStatus":[NSNumber numberWithInt:IS_LIKE_NOTIFICATION],
                                 @"ArrayTattoos":tattooID
                                 };
    [TattooUtilis sendPushNotificationWithFollowUserID:registToken withMessageContent:messageDic withUserName:[FIRAuth auth].currentUser.displayName];
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
#pragma mark OnSearchEvent
- (IBAction)onSearchFeed:(id)sender {
    [self searchViewShow];
    [self.view endEditing:YES];
}
- (IBAction)onBackController:(id)sender {
////    [SharedModel instance].feedIndex = 1;
//    [self.navigationController popViewControllerAnimated:YES];
    [SharedModel instance].feedIndex = 1;
    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:photoFeedVC] animated:YES];
    [self.sideMenuViewController hideMenuViewController];
}
#pragma  mark OnCamera
- (IBAction)onCamera:(id)sender {
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

- (void)searchViewHidden{
    _txtSearch.text = @"";
    [_viewSearch setHidden:YES];
    [_txtSearch setHidden:YES];
    [_btnSearchDismiss setHidden:YES];
    [_btnSearchBack setHidden:YES];
    [_btnSearch setHidden:NO];
    [_btnBack setHidden:NO];
    [_imgBtnBack setHidden:NO];
    [_lblCategoryTitle setHidden:NO];
    [self.view endEditing:YES];
}
- (void)searchViewShow{
//    _txtSearch.text = @"Rechercher";
    [_viewSearch setHidden:NO];
    [_txtSearch setHidden:NO];
    [_btnSearchDismiss setHidden:NO];
    [_btnSearchBack setHidden:NO];
    [_btnSearch setHidden:YES];
    [_btnBack setHidden:YES];
    [_imgBtnBack setHidden:YES];
    [_lblCategoryTitle setHidden:YES];
    
    
}
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self searchViewHidden];
    [self.view endEditing:YES];
}
- (IBAction)txtFieldDidChangeEdit:(id)sender {
    UITextField *txtField = (UITextField *)sender;
    [_arrUserSearchResult removeAllObjects];
    [_arrTattooSearchResult removeAllObjects];
    int index = -1;
    if (txtField.text.length == 0) {
        isFiltered = NO;
    }else{
        isFiltered = YES;
        for (TattooModel *tempTattooModel in _arrTatto) {
            index ++;
            UserModel  *searchUserModel = _arrUserModels[index];
            NSString *userName = searchUserModel.user_Name;
            if ([userName rangeOfString:txtField.text].location != NSNotFound) {
                [_arrUserSearchResult addObject:searchUserModel];
                [_arrTattooSearchResult addObject:tempTattooModel];
            }
        }
    }
    [_collectionInspiration reloadData];
}
- (IBAction)onSearchBackTapped:(id)sender {

}
- (IBAction)onSearchDissmissTapped:(id)sender {
    [self searchViewHidden];
    isFiltered = NO;
    [_collectionInspiration reloadData];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self searchViewHidden];
    [textField resignFirstResponder];
    return  YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _txtSearch.text = @"";
    [_btnSearchDismiss setHidden:NO];
}
@end
