//
//  SharedModel.m
//  allotattoo
//
//  Created by My Star on 7/13/16.
//  Copyright © 2016 My Star. All rights reserved.
//

#import "SharedModel.h"

@implementation SharedModel
-(id)init
{
    self =[super init];
    self.arrNotificationModelLike = [[NSMutableArray alloc] init];
    self.arrNotificationModel = [[NSMutableArray alloc] init];
    self.arrUserFollows = [NSMutableArray array];
    self.arrInsUserSearchResult = [NSMutableArray array];
    self.arrInsTattooSearchResult = [NSMutableArray array];
    self.arrInspiUserModels = [NSMutableArray array];
    self.postContentModel = [[PostContentModel alloc] init];
    self.postTattooModel = [[TattooModel alloc] init];
    self.arrTattooShop = [NSMutableArray array];
    self.arrStyles = [NSMutableArray array];
    self.arrTattoos      = [NSMutableArray array];
    self.arrTattooStyles = [NSMutableArray array];
    self.arrFavorTattoos = [NSMutableArray array];
    self.arrFavoriteTattoos = [NSMutableArray array];
    self.arrFavoriteStyleTattoos = [NSMutableArray array];
    self.arrCommentWithUserID = [NSMutableArray array];
    self.arrCommentWithTattooID = [NSMutableArray array];
    self.arrSharedUserModels = [NSMutableArray array];
    self.feedIndex = 0;
    self.msg_recent_counter = 0;
    self.msg_total_counter = 0;
    self.badge_counter = 0;
    self.user_photo_URL = nil;
    self.isLoadedComment = NO;
    self.isUserFollowed = NO;
    self.isUserCheckedFollow = NO;
    self.isArtistFollowed = NO;
    self.isCheckedFollow = NO;
    self.success_post = NO;
    self.isInsFiltered = NO;
    self.isFirstTimeLoad = NO;
    self.isMenuChatSelected = NO;
    self.isNotificaitonPermissioned = YES;
    self.isLoadedLike = NO;
    self.isAnymousMessage = NO;
    self.isAnymousProfile = NO;
    self.isAnymousNotificaiton = NO;
    self.isRightSwipe = NO;
    self.isLeftSwipe = NO;
    return self;
}
+(SharedModel*) instance
{
    static SharedModel *instance =nil;
    if(instance ==nil){
        instance =[[SharedModel alloc]init];
    }
    return instance;
}
@end
