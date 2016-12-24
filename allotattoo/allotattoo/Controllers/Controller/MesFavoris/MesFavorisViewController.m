//
//  MesFavorisViewController.m
//  AllTattoo
//
//  Created by My Star on 7/3/16.
//  Copyright © 2016 AllTattoo. All rights reserved.
//



#import "MesFavorisViewController.h"
#import "ArtistProfileViewController.h"

@import FirebaseDatabase;
@import FirebaseStorage;
@import Firebase;

@interface MesFavorisViewController ()
@property FIRDatabaseReference *favor_Ref;
@end

@implementation MesFavorisViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     [self.navigationController setNavigationBarHidden:YES];
    CHTCollectionViewWaterfallLayout *layout = (CHTCollectionViewWaterfallLayout *)self.collectionMesFavoris.collectionViewLayout;
    layout.sectionInset = UIEdgeInsetsMake(7, 7, 7, 7);
    layout.minimumColumnSpacing = 7.0f;
    layout.minimumInteritemSpacing = 7.0f;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _arrMesFavorisImage.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MesFavorisCell *cell = (MesFavorisCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"MesFavorisCell"                                                                                forIndexPath:indexPath];
    cell.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cell.layer.borderWidth = 0.5f;
    FavorTattooModel *tmpTattooModel = _arrMesFavorisImage[indexPath.row];
    [FireBaseApiService onGetUserInfoFromFireBase:tmpTattooModel.user_id withTableName:USER_TABLE withCompletion:^(UserModel *userModel) {
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.imgUserPic.layer.cornerRadius = cell.imgUserPic.frame.size.width/2;
            cell.imgUserPic.clipsToBounds  = YES;
            [cell.imgUserPic  sd_setImageWithURL:userModel.user_photoURL placeholderImage:[UIImage imageNamed:@"no_photo"]];
            cell.lblUserName.text = userModel.user_Name;
        });
    } failure:^(NSError *error) {
        
    }];
    [cell.imgMesFavoris sd_setImageWithURL:[NSURL URLWithString:tmpTattooModel.favortattoo_url] placeholderImage:[UIImage imageNamed:@"img_placeholder1"]];
    if (tmpTattooModel.dislike_flag.intValue == 1) {
        cell.imgLike.image = [UIImage imageNamed:@"btndislike"];
    }else{
        cell.imgLike.image = [UIImage imageNamed:@"btnlike"];
    }
    [cell.btnVisitUserProfile  addTarget:self action:@selector(onVisitUserProfile:event:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnLike addTarget:self action:@selector(onPostFavorTattoo:event:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

#pragma mark - CollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SinglePhotoViewController *singlePhotoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SinglePhotoViewController"];
    FavorTattooModel *favorTattooModel = _arrMesFavorisImage[indexPath.row];
    for (TattooModel *tattooModel in  [SharedModel instance].arrTattoos) {
        if ([tattooModel.tattoo_id isEqualToString:favorTattooModel.favortattoo_id])
        {
            singlePhotoVC.singleTattooModel = tattooModel;
            break;
        }
    }
    [self.navigationController pushViewController:singlePhotoVC animated:YES];
}
#pragma mark - CollectionViewDelegateWaterFallLayout
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
#pragma mark OnBack
- (IBAction)onBack:(id)sender {
    PhotoFeedViewController *photoFeedVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoFeedViewController"];
    [SharedModel instance].feedIndex = 0;
    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:photoFeedVC] animated:YES];
    [self.sideMenuViewController hideMenuViewController];
}
#pragma mark onVisit user profile
- (void)onVisitUserProfile:(id)sender event:(id)event {
    NSSet *touches = [event allTouches];
    
    UITouch *touch = [touches anyObject];
    
    CGPoint currentTouchPosition = [touch locationInView:_collectionMesFavoris
                                    ];
    NSIndexPath *indexPath = [_collectionMesFavoris indexPathForItemAtPoint: currentTouchPosition];
    TattooModel *tmpTattooModel = _arrMesFavorisImage[indexPath.row];
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
- (void)onPostFavorTattoo:(id)sender event:(id)event {
    NSSet *touches = [event allTouches];
    
    UITouch *touch = [touches anyObject];
    
    CGPoint currentTouchPosition = [touch locationInView:_collectionMesFavoris];
    NSIndexPath *indexPath = [_collectionMesFavoris indexPathForItemAtPoint: currentTouchPosition];
    FavorTattooModel *favorTattoModel =  _arrMesFavorisImage[indexPath.row];
    if (favorTattoModel.dislike_flag.intValue == 0)
    {
        favorTattoModel.dislike_flag = [NSNumber numberWithInt:1];
       
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self onRemoveFavorStyleTable:mainRef withFavorTattooModel:favorTattoModel withCompletion:^(BOOL sucess_flag) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (sucess_flag == true) {
                
                TattooModel *updateTattooModel = [SharedModel instance].arrTattoos[favorTattoModel.index.integerValue];
                updateTattooModel.like_flag = [NSNumber numberWithInt:0];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_collectionMesFavoris reloadData];
                });
            }
        }];
    }
    
}

#pragma mark Remove TattooStyle From Favor Table
- (void)onRemoveFavorStyleTable:(FIRDatabaseReference *)ref withFavorTattooModel:(FavorTattooModel *)favorTattooModel withCompletion:(void (^)(BOOL sucess_flag))completion{
    FIRDatabaseReference *removeRef = [ref child:FAVORTATTOO_TABLE];
    FIRDatabaseQuery *query = [[removeRef queryOrderedByChild:FAVORTATTOO_ID] queryEqualToValue:favorTattooModel.favortattoo_id];
    
    [query observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if ([snapshot exists] && favorTattooModel.dislike_flag.intValue == 1){
            NSLog(@"%@",[snapshot.value allValues]);
            for (NSString *theKey in [snapshot.value allKeys]) {
                if(theKey != nil){
                    [self deleteFavorTattooModelFromFireBase:removeRef withDic: snapshot.value[theKey] withKeys:theKey];
                }
            }
            completion(true);
        }
        
    }];
}
#pragma mark DeleteTattooModelFromFavorTattooModel
- (void)deleteFavorTattooModelFromFireBase:(FIRDatabaseReference *)deleteRef withDic:(NSDictionary *)dictionary withKeys:(NSString *)keys{
    NSError *error;
    FavorTattooModel *favorTattooModel = [[FavorTattooModel alloc] initWithDictionary:dictionary error:&error];
    if ([favorTattooModel.user_id isEqualToString:[FIRAuth auth].currentUser.uid]) {
        [[deleteRef child:keys] setValue:nil];
    }
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
