//
//  TattooUtilis.h
//  allotattoo
//
//  Created by My Star on 7/15/16.
//  Copyright © 2016 My Star. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Constant.h"
#import "OnBoardingRootViewController.h"
#import <RESideMenu.h>
#import "NotificationModel.h"
@interface TattooUtilis : NSObject
+(NSString *)getDeviceID;
+ (BOOL)isReallyUser;
+ (void)saveTattooModelInIns:(NSMutableArray *)tattooArray;
+ (NSMutableArray *)getTattooModelInIns;

+ (void)saveUserModelInIns:(NSMutableArray *)UserArray;
+ (NSMutableArray *)getUserModelInIns;
+ (NSDictionary *)parseFromUserModel:(UserModel *)userModel;
+ (NSDictionary *)parseFromTattooModel:(TattooModel *)tattooModel;

+ (void)saveStyleModels:(NSMutableArray *)arrStyleModels;
+ (NSMutableArray *)getStyleModels;
+ (NSDictionary  *)parseFromStyleModel:(StyleModel *)styleModel;
+ (void)saveRegistToken:(NSString *) registToken;
+ (void)saveIsKindUsers:(NSNumber *) isKindUsers;
+ (void)saveUserModel:(NSDictionary *)userModel;
+ (void)saveTattooistModel:(NSDictionary *)tattooistModel;
+ (NSString *)getRefreshToken;
+ (NSNumber *)getIsKindUsers;
+ (NSDictionary *)getUserModel;
+ (NSDictionary *)getTattooistModel;
+ (void)removeModel:(NSString *)modelKey;

+ (void)resetDefaults ;

+ (NSDictionary *)onConvertFromTattooistModel:(NSDictionary *)tattooistDic;
+ (UserModel *)onConvertFromTattooistModelToUserModel:(TattoistModel *)tattooistModel;
+ (NSMutableArray *)onGetFavorTattooFromTattooModel:(NSMutableArray *)arrTattoos;
+ (NSString *)generateRandomID;
+ (void)sendPushNotificationWithFollowUserID:(NSString *)registerToken withMessageContent:(NSDictionary *)messageDic withUserName:(NSString *)userName;
@property NSInteger delete_sucess;

+(TattooUtilis *) sharedInstance;
@end
