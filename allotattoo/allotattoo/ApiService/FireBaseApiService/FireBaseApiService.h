//
//  FireBaseApiService.h
//  allotattoo
//
//  Created by My Star on 7/12/16.
//  Copyright © 2016 My Star. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constant.h"
#import "CommentModel.h"
#import "CategoryModel.h"
#import "TattooShopModel.h"
#import "TokenModel.h"
#import "UserFollowModel.h"

@import Firebase;
@import FirebaseDatabase;
@interface FireBaseApiService : NSObject
#pragma mark Get TattooModel
+ (void)onGetTattooFromFireBase:(void (^)(NSMutableArray *arrTattoo))completion failure:(void (^)(NSError *error))failure;

+ (void)onGetTattooFromFireBasewithTattooID:(NSString *)tattoo_id withCompletion:(void (^)(TattooModel *tattooModel))completion failure:(void (^)(NSError *error))failure;

+ (void)onGetTatttooModelWithUserID:(NSString *)userID withCompletion:(void(^)(NSMutableArray *arrTattooModelWithUserID))completion;

+ (void)onGetTatttooModelWithCategoryID:(NSString *)categoryID withCompletion:(void(^)(NSMutableArray *arrTattooModelWithCateID))completion;
+ (TattooModel *)parseTattooModelFromDictionary:(NSDictionary *)dictionary withKeys:(NSString *)key;

#pragma mark Get FavorTattooModel
+ (void)onGetFavorTattooFromFireBase:(NSString *)query withCompleteion:(void (^)(NSMutableArray *arrFavorTattoo))completion failure:(void (^)(NSError *error))failure;

+ (void)onGetFavorTattooFromWithTattooIDFireBase:(NSString *)query withQuery:(NSString *)query2 withCompleteion:(void (^)(NSMutableArray *arrFavorTattoo))completion failure:(void (^)(NSError *error))failure;

+ (FavorTattooModel *)parseFavorTattooModelFromDictionary:(NSDictionary *)dictionary withKeys:(NSString *)key;


#pragma mark Get TattooStyleModels

+ (void)onGetTattooStylesFromFireBase:(void (^)(NSMutableArray *arrStyleTattoo))completion failure:(void (^)(NSError *error))failure;
+ (StyleModel *)parseStyleModelFromDictionary:(NSDictionary *)dictionary withKeys:(NSString *)keys;

#pragma mark Get FavorTattooStyleModels
+ (void)onGetFavorStyleFromFireBase:(NSString *)query withCompleteion:(void (^)(NSMutableArray *arrFavorTattoo))completion failure:(void (^)(NSError *error))failure;
+ (FavorStyleModel *)parseFavorStyleModelFromDictionary:(NSDictionary *)dictionary withKeys:(NSString *)key;

#pragma mark Get UserInfo
+ (void)onGetUserInfoFromFireBase:(NSString *)user_id withTableName:(NSString *)tableName withCompletion:(void (^)(UserModel *userModel))completion failure:(void(^)(NSError *error))failure;

+ (void)onGetUserArrayFromFireBase:(NSMutableArray *)arrUserID withTableName:(NSString *)tableName withCompletion:(void (^)(NSMutableArray *arrUserModel))completion failure:(void(^)(NSError *error))failure;

+ (void)onGetTotalUserInfoFromFireBase:(NSString *)tableName withCompletion:(void (^)(NSMutableArray *arrUserModel))completion failure:(void (^)(NSError *))failure;
+ (UserModel *)parseUserModelFromDictionary:(NSDictionary *)dictionary;
#pragma makr Get Tattooist Info
+ (void)onGetTattooistInfoFromFireBase:(NSString *)tattooist_id withTableName:(NSString *)tableName withCompletion:(void (^)(TattoistModel *tattooistModel))completion failure:(void(^)(NSError *error))failure;
+ (TattoistModel *)parseTattooistModelFromDictionary:(NSDictionary *)dictionary;

#pragma mark Get Registeration Token
+ (void)onGetRegistrationToken:(NSString *)userID withCompletion:(void (^)(TokenModel *tokenModel))completion;
+ (TokenModel *)parseTokenModelWithDic:(NSDictionary *)tokenDic;

#pragma mark Get Comment Models
+ (void)onGetCommentCount:(NSString *)tattooID withCompletion:(void(^)(NSMutableArray *arrComment))completion;
+ (void)onGetCommentCountWithUserID:(NSString *)userID withCompletion:(void(^)(NSMutableArray *arrCommentModel))completion;
+ (CommentModel *)parseCommnetModelFromDictionary:(NSDictionary *)dictionary withKeys:(NSString *)key;



#pragma mark Get CategoryModel
+ (void)onGetCateGoryModel:(void (^)(NSMutableArray *arrCategoryModel))completion;
+ (CategoryModel *)parseCategoryModelWithDictionary:(NSDictionary *)dic withKeys:(NSString *)keys;

#pragma mark Get TattooShop
+ (void)onGetTattooShopInfoWithTattooShopID:(NSString *)tattooShopID withCompletion:(void (^)(TattooShopModel *tattooShopModel))completion;
+ (void)onGetTotalTattooShopInfoWithTattooShopID:(void (^)(NSMutableArray *arrTattooShopModel))completion;
+ (TattooShopModel *)parseTattooShopModelWithDic:(NSDictionary *)dic withKeys:(NSString *)key;

#pragma mark OnCheck FollowStatus
+ (void)onCheckFollowStatus:(NSString *)follower_id withCompletion:(void (^)(BOOL isExist))completion;

#pragma mark getFollowers

+(void)onGetFollowersWithUserID:(NSString *)userID withCompletion:(void (^)(NSMutableArray *arrFollowers))completion;

+(FireBaseApiService *) instance;
@end
