//
//  NotificationViewController.m
//  AllTattoo
//
//  Created by My Star on 7/4/16.
//  Copyright © 2016 AllTattoo. All rights reserved.
//

#import "NotificationViewController.h"
#import "PhotoFeedViewController.h"
#import "NotificationCellComment.h"
#import "NotificationCellFollow.h"
#import "NotificationCellLike.h"
#import "NotificationModel.h"
#import <MBProgressHUD.h>
#import "AlloTattoAppDelegate.h"

@interface NotificationViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
@property NSMutableArray *arrUserModels;
@property NSMutableArray *arrUserIDs;
@property NSMutableArray *arrTempImg;
@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    _arrUserIDs = [NSMutableArray array];
    _arrUserModels = [NSMutableArray array];
    _arrTempImg = [NSMutableArray array];
    [self getTattooAndUserModels];

        
}
- (void)initNotificationData{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark Get Tattoo Table and User Table
- (void)getTattooAndUserModels{
   

}


#pragma mark TableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([SharedModel instance].arrNotificationModel.count > 0) {
        return [SharedModel instance].arrNotificationModel.count;
    }else{
        return 0;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        NotificationCellFollow *notificationCellFollow = (NotificationCellFollow *)[tableView dequeueReusableCellWithIdentifier:@"NotificationCellFollow"];
        NotificationCellLike *notificaitonCellLike = (NotificationCellLike *)[tableView dequeueReusableCellWithIdentifier:@"NotificationCellLike"];
        NotificationCellComment *notificationCellComment = (NotificationCellComment *)[tableView dequeueReusableCellWithIdentifier:@"NotificationCellComment"];
        NotificationModel *notiModel = [SharedModel instance].arrNotificationModel[indexPath.row];
    
        if(notiModel.numStatus.intValue == IS_FOLLOW_NOTIFICATION)
        {
            [FireBaseApiService onGetUserInfoFromFireBase:notiModel.strUserID withTableName:USER_TABLE withCompletion:^(UserModel *userModel) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    notificationCellFollow.imgUserPic.layer.cornerRadius = notificationCellFollow.imgUserPic.frame.size.width/2;
                    notificationCellFollow.imgUserPic.clipsToBounds = YES;
                    [notificationCellFollow.imgUserPic sd_setImageWithURL:userModel.user_photoURL placeholderImage:[UIImage imageNamed:@"no_photo"]];
                    notificationCellFollow.lblUserName.text = userModel.user_Name;
                    notificationCellFollow.lblStatus.text = @"vous suit";
                });
            } failure:^(NSError *error) {
                NSLog(@"error = %@",error);
            }];

            notificationCellFollow.lblTime.text  = notiModel.strTime;
            return notificationCellFollow;
            
            
        }
    
        else if(notiModel.numStatus.intValue == IS_LIKE_NOTIFICATION)
        {
            [_arrTempImg removeAllObjects];
            [_arrTempImg addObject:notiModel.arrTattooIDs];
            [FireBaseApiService onGetUserInfoFromFireBase:notiModel.strUserID withTableName:USER_TABLE withCompletion:^(UserModel *userModel) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    notificaitonCellLike.imgUserPicFollow.layer.cornerRadius = notificaitonCellLike.imgUserPicFollow.frame.size.width/2;
                    notificaitonCellLike.imgUserPicFollow.clipsToBounds = YES;
                    [notificaitonCellLike.imgUserPicFollow sd_setImageWithURL:userModel.user_photoURL placeholderImage:[UIImage imageNamed:@"no_photo"]];
                    notificaitonCellLike.lblUserNameFollow.text = userModel.user_Name;
                    notificaitonCellLike.lblStatusFollow.text = @"aime votre photo";
                });
            } failure:^(NSError *error) {
                NSLog(@"error = %@",error);
            }];
            
            [notificaitonCellLike setCollectionViewDataSourceDelegate:self indexPath:indexPath];
            notificaitonCellLike.lblTimeFollow.text = notiModel.strTime;
            return notificaitonCellLike;
        }
    
        else if(notiModel.numStatus.intValue == IS_COMMENT_NOTIFICATION){
            [FireBaseApiService onGetUserInfoFromFireBase:notiModel.strUserID withTableName:USER_TABLE withCompletion:^(UserModel *userModel) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    notificationCellComment.imgUserPicComment.layer.cornerRadius = notificationCellComment.imgUserPicComment.frame.size.width/2;
                    notificationCellComment.imgUserPicComment.clipsToBounds = YES;
                    [notificationCellComment.imgUserPicComment sd_setImageWithURL:userModel.user_photoURL placeholderImage:[UIImage imageNamed:@"no_photo"]];
                    notificationCellComment.lblUserNameComment.text = userModel.user_Name;
                    notificationCellComment.lblStatusComment.text = @"a commenté votre tattoo";
                    
                });
            } failure:^(NSError *error) {
                NSLog(@"error = %@",error);
            }];

            notificationCellComment.lblComment.text = [NSString stringWithFormat:@"«%@.»",notiModel.strCommentText];;
            notificationCellComment.lblTimeComment.text = notiModel.strTime;
            [tableView sizeToFit];
            return notificationCellComment;
            
        }
        else if(notiModel.numStatus.intValue == IS_MESSAGE_NOTIFICATION){
            [FireBaseApiService onGetUserInfoFromFireBase:notiModel.strUserID withTableName:USER_TABLE withCompletion:^(UserModel *userModel) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    notificationCellComment.imgUserPicComment.layer.cornerRadius = notificationCellComment.imgUserPicComment.frame.size.width/2;
                    notificationCellComment.imgUserPicComment.clipsToBounds = YES;
                    [notificationCellComment.imgUserPicComment sd_setImageWithURL:userModel.user_photoURL placeholderImage:[UIImage imageNamed:@"no_photo"]];
                    notificationCellComment.lblUserNameComment.text = userModel.user_Name;
                    notificationCellComment.lblStatusComment.text = @"recevoir un message";
                });
            } failure:^(NSError *error) {
                NSLog(@"error = %@",error);
            }];
           notificationCellComment.lblComment.text = [NSString stringWithFormat:@"«%@.»",notiModel.strCommentText];
            notificationCellComment.lblTimeComment.text = notiModel.strTime;
            [tableView sizeToFit];
            return notificationCellComment;
            
        }
    
        else{
            return nil;
        }
}

#pragma mark TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NotificationModel *notiModel = [SharedModel instance].arrNotificationModel[indexPath.row];
    if(notiModel.numStatus.intValue == IS_FOLLOW_NOTIFICATION)
    {
        ArtistProfileViewController *artistProfileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ArtistProfileViewController"];
        OtherArtistProfileViewController *otherArtistVC = [self.storyboard instantiateViewControllerWithIdentifier:@"OtherArtistProfileViewController"];
        if ([notiModel.strUserID isEqualToString:[FIRAuth auth].currentUser.uid]) {
            [self.navigationController pushViewController:artistProfileVC animated:YES];
        }else{
            otherArtistVC.artistProfil_ID = notiModel.strUserID;
            [self.navigationController pushViewController:otherArtistVC animated:YES];
        }
    }
    else if(notiModel.numStatus.intValue == IS_LIKE_NOTIFICATION)
    {
        PhotoFeedViewController *photoFeedVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoFeedViewController"];
        [SharedModel instance].feedIndex = 0;
        [SharedModel instance].isInsFiltered = NO;
        [[SharedModel instance].arrInsTattooSearchResult removeAllObjects];
        [[SharedModel instance].arrInsUserSearchResult removeAllObjects];
        [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:photoFeedVC] animated:YES];
        [self.sideMenuViewController hideMenuViewController];
        
    }
    else if(notiModel.numStatus.intValue == IS_COMMENT_NOTIFICATION)
    {
        SinglePhotoViewController *singlePhotoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SinglePhotoViewController"];
        for (TattooModel *tattooModel in [SharedModel instance].arrTattoos) {
            if ([notiModel.arrTattooIDs isEqualToString:tattooModel.tattoo_id]) {
                singlePhotoVC.singleTattooModel = tattooModel;
            }
        }
        [self.navigationController pushViewController:singlePhotoVC animated:YES];
      
    }
    else if(notiModel.numStatus.intValue == IS_MESSAGE_NOTIFICATION)
    {
        RecentView *recentView = [self.storyboard instantiateViewControllerWithIdentifier:@"RecentView"];
        [self.navigationController pushViewController:recentView animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{


    NotificationModel *notiModel = [SharedModel instance].arrNotificationModel[indexPath.row];
    CGFloat height = 0;
    if(notiModel.numStatus.intValue == IS_FOLLOW_NOTIFICATION)
    {
        height = 90;
        
    }
    else if(notiModel.numStatus.intValue == IS_LIKE_NOTIFICATION)
    {
        height = 150;
    }
    else if(notiModel.numStatus.intValue == IS_COMMENT_NOTIFICATION){
        if ([self getLabelHeight:notiModel.strCommentText] < 100 && [self getLabelHeight:notiModel.strCommentText] > 50) {
            height = 105 + [self getLabelHeight:notiModel.strCommentText];
        }else if([self getLabelHeight:notiModel.strCommentText] < 50){
            height = 85 + [self getLabelHeight:notiModel.strCommentText];
        }else if([self getLabelHeight:notiModel.strCommentText] > 100)
        {
            height = 150 + [self getLabelHeight:notiModel.strCommentText];
        }
        
    }
    else if(notiModel.numStatus.intValue == IS_MESSAGE_NOTIFICATION){
        if ([self getLabelHeight:notiModel.strCommentText] < 100 && [self getLabelHeight:notiModel.strCommentText] > 50) {
            height = 105 + [self getLabelHeight:notiModel.strCommentText];
        }else if([self getLabelHeight:notiModel.strCommentText] < 50){
            height = 85 + [self getLabelHeight:notiModel.strCommentText];
        }else if([self getLabelHeight:notiModel.strCommentText] > 100)
        {
            height = 150 + [self getLabelHeight:notiModel.strCommentText];
        }
    }
    return height;
}
- (CGFloat)getLabelHeight:(NSString*)string
{
    CGSize constraint = CGSizeMake(self.view.frame.size.width - 70, CGFLOAT_MAX);
    CGSize size;
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    CGSize boundingBox = [string boundingRectWithSize:constraint
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Arial" size:15.0]}
                                                  context:context].size;
    size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
    NSLog(@"%d",(int)size.height);
    return size.height;
}
#pragma mark CollectionViewDataSource
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (_arrTempImg.count > 0)
    {
        return _arrTempImg.count;
    }else{
        return 0;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TableInsideCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TableInsideCollectionCell" forIndexPath:indexPath];
    [FireBaseApiService onGetTattooFromFireBasewithTattooID:_arrTempImg[indexPath.row] withCompletion:^(TattooModel *tattooModel) {
        [cell.imgNotiLike sd_setImageWithURL:[NSURL URLWithString:tattooModel.tattoo_image_url] placeholderImage:[UIImage imageNamed:@"img_placeholder1"]];
        NSLog(@"URLs %@",tattooModel.tattoo_image_url);
    } failure:^(NSError *error) {
        
    }];
    return cell;
}

- (IBAction)onBack:(id)sender {
    PhotoFeedViewController *photoFeedVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoFeedViewController"];
    [SharedModel instance].feedIndex = 0;
    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:photoFeedVC] animated:YES];
    [self.sideMenuViewController hideMenuViewController];
}


@end
