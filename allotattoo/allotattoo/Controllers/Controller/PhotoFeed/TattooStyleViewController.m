//
//  TattooStyleViewController.m
//  AllTattoo
//
//  Created by My Star on 7/1/16.
//  Copyright © 2016 AllTattoo. All rights reserved.
//

#import "TattooStyleViewController.h"


@interface TattooStyleViewController ()<UITableViewDataSource,UITableViewDelegate,DBCameraViewControllerDelegate>
{
     NSMutableArray *arrStyles;
     BOOL isFirstTimeLoad;
     PhotoFeedViewController *photoFeedVC;
     UIRefreshControl *refreshControl;
    MGInstagram *instagram;
    UIImage *socialPostImage;
    AAShareBubbles *shareBubbles;
}
@property FIRDatabaseReference *style_Ref;
@property FIRDatabaseReference *favorstyle_Ref;
@end

@implementation TattooStyleViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    isFirstTimeLoad = YES;
    instagram = [MGInstagram new];
    arrStyles = [NSMutableArray array];
    [self.navigationController setNavigationBarHidden:YES];
    photoFeedVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoFeedViewController"];
    
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshData:) forControlEvents:UIControlEventValueChanged];
    [_tblStyle addSubview:refreshControl];
    
    [SharedModel instance].arrTattooStyles = [TattooUtilis getStyleModels];
    StyleModel *styleModel = [SharedModel instance].arrTattooStyles.firstObject;
    if (styleModel != nil) {
        [self getStyleModels];
         [_tblStyle reloadData];
    }else{
        [self getStyleModels];
    }
 
}
- (void)viewWillAppear:(BOOL)animated{
}
- (void)viewDidAppear:(BOOL)animated{
    

}
- (void)getStyleModels{
    [FireBaseApiService onGetTattooStylesFromFireBase:^(NSMutableArray *arrStyleTattoo) {
            [SharedModel instance].arrTattooStyles = arrStyleTattoo;
            [TattooUtilis saveStyleModels:arrStyleTattoo];
            [refreshControl endRefreshing];
            [_tblStyle reloadData];
    } failure:^(NSError *error) {
        [self failedAlertAction:error.localizedDescription];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark refreshData
- (void)refreshData:(id)sender{
    [self getStyleModels];
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
#pragma mark TableView Datasource & delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([SharedModel instance].arrTattooStyles.count > 0) {
        return [SharedModel instance].arrTattooStyles.count;
    }else{
        return 0;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 12 == 0 && indexPath.row > 0) {
        StylePostFooterCell *stylePostFooterCell = (StylePostFooterCell *)[tableView dequeueReusableCellWithIdentifier:@"StylePostFooterCell"];
        [stylePostFooterCell.btnStylePostCamera addTarget:self action:@selector(onCamera:) forControlEvents:UIControlEventTouchUpInside];
        [stylePostFooterCell.btnStylePost setTag:indexPath.row];
        [stylePostFooterCell.btnStylePost addTarget:self action:@selector(gotoHomeScreen:) forControlEvents:UIControlEventAllEvents];
        return stylePostFooterCell;
        
    }else if ((indexPath.row % 6 == 0 && indexPath.row > 0) || (indexPath.row % 18 == 0 && indexPath.row > 0)){
        StyleInviteFooterCell *styleInviteFooterCell = (StyleInviteFooterCell *)[tableView dequeueReusableCellWithIdentifier:@"StyleInviteFooterCell"];
        [styleInviteFooterCell.btnStyleInvite setTag:indexPath.row];
        [styleInviteFooterCell.btnStyleInvite addTarget:self action:@selector(onShareInvite:) forControlEvents:UIControlEventTouchUpInside];
        return styleInviteFooterCell;
    }else{
        StyleCell *styleCell =  (StyleCell *)[tableView dequeueReusableCellWithIdentifier:@"StyleCell"];
        StyleModel *tempStyleModel = [SharedModel instance].arrTattooStyles[indexPath.row];
        [styleCell.imgStyle sd_setImageWithURL:[NSURL URLWithString:tempStyleModel.style_image_url] placeholderImage:[UIImage imageNamed:@"img_placeholder1"]];
        socialPostImage = styleCell.imgStyle.image;
        [[[[mainRef child:FAVORSTYLE_TABLE] child:tempStyleModel.style_id] child:[FIRAuth auth].currentUser.uid] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            if ([snapshot exists]) {
                tempStyleModel.like_flag = [NSNumber numberWithInt:1];
                styleCell.imgPost.image = [UIImage imageNamed:@"btn_style_like"];
            }else{
                tempStyleModel.like_flag = [NSNumber numberWithInt:0];
                styleCell.imgPost.image = [UIImage imageNamed:@"btn_stylle_dislike"];
            }
        }];
        [styleCell.btnStyleLike_Dis setTag:indexPath.row];
        [styleCell.btnStyleLike_Dis addTarget:self action:@selector(onLikeStyle:event:) forControlEvents:UIControlEventTouchUpInside];
        styleCell.lblStyleTitle.text = tempStyleModel.style_title;
        styleCell.lblStyleContent.text = tempStyleModel.style_des;
        return styleCell;
    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 191.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if ((indexPath.row % 6 == 0 || indexPath.row % 12 == 0)  && indexPath.row != 0){

    }else{
        StyleModel *tempStyleModel = [SharedModel instance].arrTattooStyles[indexPath.row];
        StyleFeedController *styleFeedVC = [self.storyboard instantiateViewControllerWithIdentifier:@"StyleFeedController"];
        styleFeedVC.style_id = tempStyleModel.style_id;
        styleFeedVC.style_title = tempStyleModel.style_title;
        [self.navigationController pushViewController:styleFeedVC animated:YES];
    }

}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
#pragma makr OnCamera Tapped
- (void)onCamera:(id)sender {
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
        [self.navigationController pushViewController:customCameraVC animated:NO];
    })];
}

- (void) dismissCamera:(id)cameraViewController{
    [self dismissViewControllerAnimated:YES completion:nil];
    [cameraViewController restoreFullScreenMode];
}
- (void) gotoHomeScreen:(id)sender {
    for (UIViewController * theViewController in self.navigationController.viewControllers) {
        if ([theViewController isKindOfClass:[MemberTypeViewController class]]) {
            [self.navigationController popToViewController:theViewController animated:YES];
            break;
        }
    }
    
}
#pragma mark Social Post
- (void)onShareInvite:(UIButton *)sender{
    if ([TattooUtilis isReallyUser]) {
        if(shareBubbles) {
            shareBubbles = nil;
        }
        shareBubbles = [[AAShareBubbles alloc] initWithPoint:self.view.center radius:100 inView:self.view];
        shareBubbles.delegate = self;
        shareBubbles.bubbleRadius = 30;
        shareBubbles.showFacebookBubble = YES;
        shareBubbles.showInstagramBubble = YES;
        [shareBubbles show];
    }else{
        NotationViewController *notationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NotationViewController"];
        [self.navigationController pushViewController:notationVC animated:YES];
    }


}
#pragma mark AAShareBubbleDelegate
- (void)aaShareBubbles:(AAShareBubbles *)shareBubbles tappedBubbleWithType:(AAShareBubbleType)bubbleType
{
    
    switch (bubbleType) {
        case AAShareBubbleTypeFacebook:
            [self facebookShare:[self postMergeImage:socialPostImage]];
            break;
        case AAShareBubbleTypeInstagram:
            [self postInstagramImage:[self postMergeImage:socialPostImage]];
            break;
        default:
            break;
    }
}
- (void)aaShareBubblesDidHide:(AAShareBubbles *)shareBubbles
{
    
}
#pragma mark faceBook Share
- (void)facebookShare:(UIImage *)image{
    
    FBSDKSharePhoto *photo = [[FBSDKSharePhoto alloc] init];
    photo.image = image;
    photo.userGenerated = NO;
    FBSDKSharePhotoContent *contentPhoto = [[FBSDKSharePhotoContent alloc] init];
    contentPhoto.photos = @[photo];
    [FBSDKShareDialog showFromViewController:self withContent:contentPhoto delegate:nil];
}
#pragma mark ImageMerge
-(UIImage *)postMergeImage :(UIImage *)image
{
    UIView *mergeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 640, 640)];
    UIImageView *imgBackView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 640, 640)];
    imgBackView.image = image;
    [mergeView addSubview:imgBackView];
    
    UIImageView *imageLogoView = [[UIImageView alloc] initWithFrame:CGRectMake(512, 600, 115, 24)];
    imageLogoView.image = [UIImage imageNamed:@"imgLogo"];
    [mergeView addSubview:imageLogoView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(364, 605, 153, 22)];
    label.text = @"Publié avec l’app";
    [label setFont:[UIFont systemFontOfSize:19.0f]];
    [label setTextColor:[UIColor whiteColor]];
    [mergeView addSubview:label];
    
    
    UIGraphicsBeginImageContext(mergeView.bounds.size);
    [mergeView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return  finalImage;
}
- (void) postInstagramImage:(UIImage*) image {
    if ( [MGInstagram isImageCorrectSize:image] && [MGInstagram isAppInstalled]) {
        [instagram postImage:image inView:self.view];
    }
    else {
        [self failedAlertAction:@"Instagram must be installed on the device in order to post images"];
    }
}

#pragma mark Click Cell Post ICON
- (void)onLikeStyle:(UIButton *)sender event:(id)event {

    if ([TattooUtilis isReallyUser]) {
        StyleModel *tempStyleModel =  [[SharedModel instance].arrTattooStyles objectAtIndex:sender.tag];
        if (tempStyleModel.like_flag.intValue == 0)
        {
            
            tempStyleModel.like_flag = [NSNumber numberWithInt:1];
            [self onAddFavorStyleTable:mainRef withStyleModel:tempStyleModel];
            [self onAddToTattooTable:mainRef withStyleModel:tempStyleModel withCategoryID:sender.tag];
            [_tblStyle reloadData];
            
            
        }
        else if(tempStyleModel.like_flag.intValue == 1)
        {
            tempStyleModel.like_flag = [NSNumber numberWithInt:0];
            [self onRemoveFavorStyleTable:mainRef withStyleModel:tempStyleModel];
            [_tblStyle reloadData];

        }

    }else{
        NotationViewController *notationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NotationViewController"];
        [self.navigationController pushViewController:notationVC animated:YES];
    }
}
#pragma mark Remove TattooStyle From Favor Table
- (void)onRemoveFavorStyleTable:(FIRDatabaseReference *)ref withStyleModel:(StyleModel *)styleModel{
    FIRDatabaseReference *removeRef = [[[mainRef child:FAVORSTYLE_TABLE] child:styleModel.style_id] child:[FIRAuth auth].currentUser.uid];
    [removeRef setValue:nil];

}

#pragma mark Add TattooStyle To Favor Table
- (void)onAddFavorStyleTable:(FIRDatabaseReference *)ref withStyleModel:(StyleModel*)styleModel{
    [[[[mainRef  child:FAVORSTYLE_TABLE] child:styleModel.style_id] child:[FIRAuth auth].currentUser.uid ] setValue:styleModel.style_image_url];
}
#pragma mark Add TattooStyle To Tattoo Table
- (void)onAddToTattooTable:(FIRDatabaseReference *)ref withStyleModel:(StyleModel*)styleModel withCategoryID:(NSInteger )categoryID{
    NSDictionary *postTattooDic = @{USER_ID:[FIRAuth auth].currentUser.uid,
                                    TATTOO_IMG_URL:styleModel.style_image_url,
                                    STYLE_ID:styleModel.style_id,
                                    CATEGORY_ID:[NSString stringWithFormat:@"%d",(int)categoryID + 1],
                                    TATTOO_SHOP_ID:@"",
                                    TATTOO_LINK:@"https://www.facebook.com/",
                                    TATTOO_NAME:styleModel.style_title,
                                    TATTOOIST_ID:[FIRAuth auth].currentUser.uid
                                    };
    [[[mainRef child:TATTOO_TABLE] childByAutoId] setValue:postTattooDic];

}
@end
