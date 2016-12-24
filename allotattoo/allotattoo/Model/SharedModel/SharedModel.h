//
//  SharedModel.h
//  allotattoo
//
//  Created by My Star on 7/13/16.
//  Copyright © 2016 My Star. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constant.h"
#import "PostContentModel.h"

@interface SharedModel : NSObject
@property NSMutableArray *arrSharedUserModels;
@property BOOL isNotificaitonPermissioned;
@property BOOL isFirstTimeLoad;
@property BOOL isMenuChatSelected;
@property NSMutableArray *arrNotificationModel;
@property NSMutableArray *arrNotificationModelLike;
@property NSMutableArray *arrInsUserSearchResult;
@property NSMutableArray *arrInsTattooSearchResult;
@property BOOL isInsFiltered;
@property NSMutableArray *arrInspiUserModels;
@property NSMutableArray *arrTattoos;
@property NSMutableArray *arrStyles;
@property NSMutableArray *arrTattooStyles;
@property NSMutableArray *arrFavorTattoos;
@property NSMutableArray *arrFavoriteTattoos;
@property NSMutableArray *arrFavoriteStyleTattoos;
@property NSMutableArray *arrCommentWithTattooID;
@property NSMutableArray *arrCommentWithUserID;
@property NSMutableArray *arrTattooShop;
@property NSMutableArray *arrUserFollows;
@property NSURL *user_photo_URL;
@property NSInteger feedIndex;
@property NSInteger msg_recent_counter;
@property NSInteger msg_total_counter;
@property NSInteger badge_counter;
@property BOOL isLoadedLike;
@property BOOL isLoadedComment;
@property BOOL isUserCheckedFollow;
@property BOOL isUserFollowed;
@property BOOL isCheckedFollow;
@property BOOL isArtistFollowed;
@property BOOL isAnymousMessage;
@property BOOL isAnymousNotificaiton;
@property BOOL isAnymousProfile;
@property BOOL isRightSwipe;
@property BOOL isLeftSwipe;
@property TattooModel *postTattooModel;
@property PostContentModel *postContentModel;
@property BOOL success_post;
+(SharedModel*) instance;
@end
