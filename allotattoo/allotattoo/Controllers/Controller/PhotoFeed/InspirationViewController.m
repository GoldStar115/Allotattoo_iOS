//
//  InspirationViewController.m
//  AllTattoo
//
//  Created by My Star on 7/1/16.
//  Copyright © 2016 AllTattoo. All rights reserved.
//

#import "InspirationViewController.h"



@interface InspirationViewController ()
{
    NSMutableArray *arrInternalTattoos;
    NSMutableArray *arrInternalUserModels;
    NSMutableArray *arrTattooSearchResult;
    NSMutableArray *arrUserSearchResult;
    PhotoFeedViewController *photoFeedVC;
    BOOL isLike;
    BOOL isDisp;
    BOOL isHasDefaultData;
    NSInteger indexFavoriteTattoo;
    NSTimer *counterTimer;
    BOOL  isFiltered;
    int hide_count;
    UIRefreshControl *refreshControl;

}

@property NSMutableArray *arrUserModels;
@end

@implementation InspirationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_viewSuccessPost setHidden:YES];
    
    photoFeedVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoFeedViewController"];
    
    
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor grayColor];
    [refreshControl addTarget:self action:@selector(refreshData:) forControlEvents:UIControlEventAllEvents];
    [self.collectioViewInspiration addSubview:refreshControl];
    self.collectioViewInspiration.alwaysBounceVertical = YES;
    
    
    _arrUserModels = [NSMutableArray array];
    arrInternalTattoos = [NSMutableArray array];
    arrInternalUserModels = [NSMutableArray array];
    arrTattooSearchResult = [NSMutableArray array];
    arrUserSearchResult = [NSMutableArray array];
    
    isFiltered = NO;
    isLike  = NO;
    isDisp = NO;
    isHasDefaultData = NO;
    hide_count = 0;
    [self.navigationController setNavigationBarHidden:YES];
    CHTCollectionViewWaterfallLayout *layout = (CHTCollectionViewWaterfallLayout *)self.collectioViewInspiration.collectionViewLayout;
    layout.sectionInset = UIEdgeInsetsMake(7, 7, 7, 7);
    layout.minimumColumnSpacing = 7.0f;
    layout.minimumInteritemSpacing = 7.0f;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchTextChangedFromSuper:) name:@"SearchTattoos" object:nil];
    if ([SharedModel instance].success_post == YES) {
        [self.viewSuccessPost setHidden:NO];
        self.lblSuccessPost.text = @"Votre tatouage a bien été publié";
        counterTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(hideView:) userInfo:nil repeats:YES];
    }else{


        if ([SharedModel instance].arrTattoos.count > 0) {
             arrInternalTattoos = [SharedModel instance].arrTattoos;
             arrInternalUserModels = [SharedModel instance].arrInspiUserModels;
            [SharedModel instance].arrSharedUserModels = arrInternalUserModels;
            [self getTattooAndUserModels];
            [_collectioViewInspiration reloadData];
        }else{
            [SharedModel instance].arrTattoos = [TattooUtilis getTattooModelInIns];
            [SharedModel instance].arrInspiUserModels = [TattooUtilis getUserModelInIns];
            [SharedModel instance].arrSharedUserModels = [SharedModel instance].arrInspiUserModels;
            if ([SharedModel instance].arrTattoos.count > 0) {
                arrInternalTattoos = [SharedModel instance].arrTattoos;
                arrInternalUserModels = [SharedModel instance].arrInspiUserModels;
                [_collectioViewInspiration reloadData];
            }else{
                [self getTattooAndUserModels];
            }
        }
    }
 
}
- (void)viewWillAppear:(BOOL)animated{    
    [super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated{

}
- (void)viewDidDisappear:(BOOL)animated
{

}
- (void)refreshData:(id)sender{
 
    [self getTattooAndUserModels];
    
    
}
#pragma mark Get Tattoo Table and User Table
- (void)getTattooAndUserModels{
        NSMutableArray *arrUserIDs = [NSMutableArray array];
        [FireBaseApiService onGetTattooFromFireBase:^(NSMutableArray *arrTattoo) {
                    for (TattooModel *tempTattooModel in arrTattoo) {
                        [arrUserIDs addObject:tempTattooModel.user_id];
                    }
                    //get total user model
                    [FireBaseApiService onGetUserArrayFromFireBase:nil withTableName:USER_TABLE withCompletion:^(NSMutableArray *arrUserModel) {
                        [SharedModel instance].arrSharedUserModels  =arrUserModel;
                        [MBProgressHUD hideHUDForView:self.collectioViewInspiration animated:YES];
                        for (NSString *userID in arrUserIDs) {
                            for (UserModel *selUserModel in arrUserModel) {
                                if ([userID isEqualToString:selUserModel.user_id]){
                                    [_arrUserModels addObject:selUserModel];
                                    break;
                                }
                            }
                        }
                        //If now user is fake user......
                        if (![TattooUtilis isReallyUser]) {
                            [SharedModel instance].arrTattoos = arrTattoo;
                            [SharedModel instance].arrInspiUserModels = _arrUserModels;
                            [self saveTattooModelsAndUserModels];
                            [refreshControl endRefreshing];
                            [_collectioViewInspiration reloadData];
                        }else{
                            int index = - 1;
                            NSMutableArray *arrSameTattoos = [NSMutableArray array];
                            NSMutableArray *arrSameUsers = [NSMutableArray array];
                            NSMutableArray *arrDiffTattoos = [NSMutableArray array];
                            NSMutableArray *arrDiffUsers = [NSMutableArray array];
                            for (TattooModel *tempTattooModel in arrTattoo) {
                                index ++;
                                UserModel  *searchUserModel = _arrUserModels[index];
                                NSString *userName = searchUserModel.user_Name;
                                if ([FIRAuth auth].currentUser != nil) {
                                    if ([userName rangeOfString:[FIRAuth auth].currentUser.displayName].location != NSNotFound) {
                                        [arrSameTattoos addObject:tempTattooModel];
                                        [arrSameUsers addObject:searchUserModel];
                                    }else{
                                        [arrDiffUsers addObject:searchUserModel];
                                        [arrDiffTattoos addObject:tempTattooModel];
                                    }
                                }
                                
                            }
                            [SharedModel instance].arrInspiUserModels = [NSMutableArray arrayWithArray:arrSameUsers];
                            [[SharedModel instance].arrInspiUserModels addObjectsFromArray:arrDiffUsers];
                            
                            [SharedModel instance].arrTattoos = [NSMutableArray arrayWithArray:arrSameTattoos];
                            [[SharedModel instance].arrTattoos addObjectsFromArray:arrDiffTattoos];
                           
                            [arrInternalTattoos removeAllObjects];
                            arrInternalTattoos = [SharedModel instance].arrTattoos;
                            
                            [arrInternalUserModels removeAllObjects];
                            arrInternalUserModels = [SharedModel instance].arrInspiUserModels;
                            ///////
                            [self saveTattooModelsAndUserModels];
                            [refreshControl endRefreshing];
                            [_collectioViewInspiration reloadData];
                        
                        }
                    } failure:^(NSError *error) {
                        [MBProgressHUD hideHUDForView:self.collectioViewInspiration animated:YES];
                    }];
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.collectioViewInspiration animated:YES];
            [self failedAlertAction:error.localizedDescription];
        }];
    
}
#pragma mark Save TattooModel and UserModel to default
- (void)saveTattooModelsAndUserModels{
    NSMutableArray *arrTattooModels = [NSMutableArray array];
    NSMutableArray *arrUserModels = [NSMutableArray array];
    int bufferCnt = 20;
    for(int i = 0; i < bufferCnt; i ++)
    {
        [arrTattooModels addObject:[SharedModel instance].arrTattoos[i]];
        [arrUserModels addObject:[SharedModel instance].arrInspiUserModels[i]];
    }
    [TattooUtilis saveTattooModelInIns:arrTattooModels];
    [TattooUtilis saveUserModelInIns:arrUserModels];
    
}
#pragma mark hideView
- (void)hideView:(NSTimer *)timer{
    hide_count  ++;
    if (hide_count == 5) {
        [SharedModel instance].success_post = NO;
        [counterTimer invalidate];
        counterTimer = nil;
        [self.viewSuccessPost setHidden:YES];
        [self getTattooAndUserModels];
    }
}

#pragma mark checkFavoriteTattoo


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark OnCamera
#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (isFiltered) {
        return arrTattooSearchResult.count;
    }else{
        if ([SharedModel instance].arrTattoos.count > 0) {
            return [SharedModel instance].arrTattoos.count;
        }else{
            return 0;
        }
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CustomInspirationCell *cell = (CustomInspirationCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CustomInspirationCell"                                                                                forIndexPath:indexPath];
    cell.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cell.layer.borderWidth = 0.5f;
    TattooModel *cellTattooModel;
    UserModel *cellUserModel;
    if (isFiltered) {
        cellTattooModel = arrTattooSearchResult[indexPath.row];
        cellUserModel = arrUserSearchResult[indexPath.row];
    }else{
        cellTattooModel = [SharedModel instance].arrTattoos[indexPath.row];
        cellUserModel = [SharedModel instance].arrInspiUserModels[indexPath.row];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        cell.imgPhoto.layer.cornerRadius = cell.imgPhoto.frame.size.width/2;
        cell.imgPhoto.clipsToBounds  = YES;
        [cell.imgPhoto  sd_setImageWithURL:cellUserModel.user_photoURL placeholderImage:[UIImage imageNamed:@"no_photo"]];
        cell.lblUserName.text = cellUserModel.user_Name;
    });
    [cell.imgTattoo sd_setImageWithURL:[NSURL URLWithString:cellTattooModel.tattoo_image_url] placeholderImage:[UIImage imageNamed:@"img_placeholder1"]];
    [[[[mainRef child:FAVORTATTOO_TABLE] child:cellTattooModel.tattoo_id] child:[FIRAuth auth].currentUser.uid] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if ([snapshot exists]) {
            cellTattooModel.like_flag = [NSNumber numberWithInt:1];
            cell.imgLikePost.image = [UIImage imageNamed:@"btnlike"];
        }else{
            cellTattooModel.like_flag = [NSNumber numberWithInt:0];
            cell.imgLikePost.image = [UIImage imageNamed:@"btndislike"];
        }
    }];
//    [cell.btnProfile  addTarget:self action:@selector(onVisitUserProfile:event:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnLikePost addTarget:self action:@selector(onLikeTattoo:event:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
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
            height = 230;
            break;
        case 1:
           
            height = 290;
            break;
        case 2:
           
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
#pragma UICollectionView delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SinglePhotoViewController *singlePhotoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SinglePhotoViewController"];
    if (isFiltered) {
        singlePhotoVC.singleTattooModel =arrTattooSearchResult[indexPath.row];
    }else{
       singlePhotoVC.singleTattooModel = [SharedModel instance].arrTattoos[indexPath.row];
    }
    [self.navigationController pushViewController:singlePhotoVC animated:YES];
}
#pragma mark scroll view delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
#pragma mark Open Camera
- (IBAction)onCameraOpen:(id)sender {
    if ([TattooUtilis isReallyUser]){
        [self openCamera];
    }else{
        NotationViewController *notationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NotationViewController"];
        [self.navigationController pushViewController:notationVC animated:YES];
    }
}
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
#pragma mark onVisit user profile
- (void)onVisitUserProfile:(id)sender event:(id)event {
    NSSet *touches = [event allTouches];
    
    UITouch *touch = [touches anyObject];
    
    CGPoint currentTouchPosition = [touch locationInView:_collectioViewInspiration
                                    ];
    NSIndexPath *indexPath = [_collectioViewInspiration indexPathForItemAtPoint: currentTouchPosition];
    TattooModel *tempTattooModel;
    UserModel *userModel;
    if (isFiltered) {
        tempTattooModel =arrTattooSearchResult[indexPath.row];
        userModel = arrUserSearchResult[indexPath.row];
    }else{
        tempTattooModel = [SharedModel instance].arrTattoos[indexPath.row];
        userModel = [SharedModel instance].arrInspiUserModels[indexPath.row];
    }
    ArtistProfileViewController *artistProfileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ArtistProfileViewController"];
    OtherArtistProfileViewController *otherArtistVC = [self.storyboard instantiateViewControllerWithIdentifier:@"OtherArtistProfileViewController"];
    if ([tempTattooModel.user_id isEqualToString:[FIRAuth auth].currentUser.uid]) {
        artistProfileVC.artistProfil_ID = tempTattooModel.user_id;
        artistProfileVC.artistModelProfil = [[UserModel alloc] init];
        artistProfileVC.artistModelProfil = userModel;
        [self.navigationController pushViewController:artistProfileVC animated:YES];
    }else{
        otherArtistVC.artistProfil_ID = tempTattooModel.user_id;
        [self.navigationController pushViewController:otherArtistVC animated:YES];
    }
}
#pragma mark Click Cell Post ICON
- (void)onLikeTattoo:(id)sender event:(id)event {
    if ([TattooUtilis isReallyUser]){
        
        NSSet *touches = [event allTouches];
        
        UITouch *touch = [touches anyObject];
        
        CGPoint currentTouchPosition = [touch locationInView:_collectioViewInspiration];
        NSIndexPath *indexPath = [_collectioViewInspiration indexPathForItemAtPoint: currentTouchPosition];
        TattooModel *tempTattooModel;
        if (isFiltered) {
            tempTattooModel = arrTattooSearchResult[indexPath.row];
        }else{
            tempTattooModel = [SharedModel instance].arrTattoos[indexPath.row];
        }
        if (tempTattooModel.like_flag.intValue == 0)
        {
            tempTattooModel.like_flag = [NSNumber numberWithInt:1];
            [self onAddFavorTattoo:mainRef withTattooModel:tempTattooModel];
            [_collectioViewInspiration reloadData];
            if (![tempTattooModel.user_id isEqualToString:[FIRAuth auth].currentUser.uid]) {
                [FireBaseApiService onGetRegistrationToken:tempTattooModel.user_id withCompletion:^(TokenModel *tokenModel) {
                    if (tokenModel != nil && tokenModel.regist_token != nil) {
                        [self sendPushNotificationWithLike:tokenModel.regist_token withTattooID:tempTattooModel.tattoo_id];
                        
                    }
                }];
            }
            
        }else{
            tempTattooModel.like_flag = [NSNumber numberWithInt:0];
            [self onRemoveFavorTable:mainRef withStyleModel:tempTattooModel];
            [_collectioViewInspiration reloadData];
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
#pragma mark Remove TattooStyle From Favor Table
- (void)onRemoveFavorTable:(FIRDatabaseReference *)ref withStyleModel:(TattooModel *)tattooModel{
    FIRDatabaseReference *removeRef = [[[ref child:FAVORTATTOO_TABLE] child:tattooModel.tattoo_id] child:[FIRAuth auth].currentUser.uid];
    [removeRef setValue:nil];
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


-(void) searchTextChangedFromSuper:(NSNotification *) notification {
    NSString *searchText = notification.userInfo[@"searchtext"];
    NSLog(@"Changed text :%@", searchText);
    [arrUserSearchResult removeAllObjects];
    [arrTattooSearchResult removeAllObjects];
    int index = -1;
    if (searchText.length == 0) {
        isFiltered = NO;
        [self refreshData:refreshControl];
    }else{
        isFiltered = YES;
        for (TattooModel *searchTattooModel in [SharedModel instance].arrTattoos)
        {
            index ++;
            UserModel *searchUserModel = [SharedModel instance].arrInspiUserModels[index];
            NSString *userName = searchUserModel.user_Name;
            if ([userName rangeOfString:searchText].location != NSNotFound) {
                [arrTattooSearchResult addObject:searchTattooModel];
                [arrUserSearchResult addObject:searchUserModel];
            }
        }
        [_collectioViewInspiration reloadData];
    }
}

@end
