//
//  Constant.h
//  allotattoo
//
//  Created by My Star on 7/17/16.
//  Copyright © 2016 My Star. All rights reserved.
//

#ifndef Constant_h
#define Constant_h


#import "FavorStyleModel.h"
#import "TattooModel.h"
#import "FavorTattooModel.h"
#import "SharedModel.h"
#import "TattoistModel.h"
#import "StyleModel.h"
#import "UserModel.h"
#import "NotificationModel/NotificationModel.h"
#import "FireBaseApiService.h"
#import "TattooUtilis.h"
#import "CommentModel.h"
#import "CategoryModel.h"
#import "TattooShopModel.h"
#import "FavorUserModel.h"
#import "FavorTattooModel.h"
#import "CategoryModel.h"
#import "TattooShopModel.h"
#import "SharedModel.h"
#import "PostContentModel.h"
#import "TokenModel.h"


#define mainRef [[FIRDatabase database] referenceFromURL:@"https://allotatto.firebaseio.com/"]
#define FCM_API_KEY                 @"AIzaSyBiD5H5p3jvpz4LUx8xjVyQxD0wHXd1WAE"
#define STYLE_LOCALDATA             @"stylemodel_localdata"
#define USERMODEL_LOCALDATA         @"usermodel_localdata"
#define TATTOOMODEL_LOCALDATA       @"tattoomodel_localdata"
#define USER_FOLLOW_TABLE           @"User_follow_table"
#define USER_FLAG                   @"user_flag"
#define TATTOOIST_FLAG              @"tattooist_flag"
#define TATTOOIST_FOLLOW_TABLE      @"Tattooist_follow_table"
#define USER_TABLE                  @"User_table"
#define TATTOOIST_TABLE             @"Tattoist_table"
#define STYLE_TABLE                 @"Style_table"
#define TATTOO_TABLE                @"Tattoo_table"
#define FAVORTATTOO_TABLE           @"FavorTattoo_table"
#define FAVORSTYLE_TABLE            @"FavorStyle_table"
#define COMMENT_TABLE               @"Comment_table"
#define CATEGORY_TABLE              @"Category_table"
#define FAVOR_TATTOOIST_TABLE       @"Favor_tattoist_table"
#define FAVOR_USER_TABLE            @"Favor_user_table"
#define TATTOOSHOP_TABLE            @"Tattoo_shop_table"
#define REGISTTOKEN_TABLE           @"RegistToken_table"



#define TOKEN_KEY                   @"token_key"


#define USER_ID                     @"user_id"

#define USER_MODEL                  @"userModel"
#define TATTOOIST_MODEL             @"tattooistModel"

#define TATTOOIST_ID                @"tattoist_ID"
#define TATTOOIST_PROVIDER_ID       @"tattooist_provideID"
#define TATTOOIST_NAME              @"tattoist_Name"
#define TATTOOIST_EMAIL             @"tattoist_email"
#define TATTOOIST_PHOTO_URL         @"tattoist_photoURL"
#define TATTOOIST_LOCATION          @"tattoistLocation"
#define TATTOOIST_REFESHTOKEN       @"tattoistRefreshToken"


#define USER_PROVIDER_FBID          @"user_provideFBID"
#define USER_PROVIDER_INSID         @"user_provideINSID"
#define USER_NAME                   @"user_Name"
#define USER_EMAIL                  @"user_email"
#define USER_PHOTO_URL              @"user_photoURL"
#define USER_LOCATION               @"userLocation"
#define USER_REFESHTOKEN            @"userRefreshToken"
#define USER_REGISTERATIONTOKEN     @"regist_token"
#define TATTOO_LINK                 @"tattoo_link"
#define TATTOO_NAME                 @"tattoo_name"

#define FAVORSTYLE_ID               @"favorstyle_id"
#define FAVORSTYLE_URL              @"favorstyle_url"


#define FAVORTATTOO_ID              @"favortattoo_id"
#define FAVORTATTOO_URL             @"favortattoo_url"


#define STYLE_ID                    @"style_id"
#define STYLE_IMG_URL               @"style_image_url"
#define STYLE_TITLE                 @"style_title"
#define STYLE_DES                   @"style_des"
#define LIKE_FLAG                   @"like_flag"

#define TATTOO_ID                   @"tattoo_id"
#define TATTOO_IMG_URL              @"tattoo_image_url"
#define TATTOO_SHOP_ID              @"tattooshop_id"
#define TATTOO_SHOP_LOCATION        @"tattoo_shop_location"
#define TATTOO_SHOP_IMG_URL         @"tattoo_shop_img_url"
#define TATTOO_SHOP_LINK            @"tattoo_shop_link"
#define TATTOO_SHOP_NAME            @"tattoo_shop_name"


#define FAVOR_USER_ID               @"favor_user_id"
#define FAVOR_USER_PHOTO_URL        @"favor_user_photo_url"

#define FAVOR_TATTOOIST_ID          @"favor_tattooist_id"
#define FAVOR_TATTOOIST_PHOTO_URL   @"favor_tattooist_photo_url"

#define CATEGORY_ID                 @"category_id"
#define CATEGORY_IMG_URL            @"category_img_url"
#define CATEGORY_TITLE              @"category_title"
#define CATEGORY_DESCRIPTION        @"category_description"

#define COMMENT_ID                  @"comment_id"
#define COMMENT_CONTENT             @"comment_content"
#define CREATE_AT                   @"createdAt"

#define FOLLOW_ID                   @"follower_id"
#define FOLLOW_PHOTO_URL            @"follower_photo_url"



#define IS_KIND_USERS               @"IS_KINDUSERS"

#define isKindTattooUser            0
#define isKindTattooist             1

#define IS_FOLLOW_NOTIFICATION      0
#define IS_LIKE_NOTIFICATION        1
#define IS_COMMENT_NOTIFICATION     2
#define IS_MESSAGE_NOTIFICATION     3

#define CELL_HEIGHT1                210
#define CELL_HEIGHT2                300

#endif /* Constant_h */
