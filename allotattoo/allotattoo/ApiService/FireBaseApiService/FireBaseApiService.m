//
//  FireBaseApiService.m
//  allotattoo
//
//  Created by My Star on 7/12/16.
//  Copyright © 2016 My Star. All rights reserved.
//

#import "FireBaseApiService.h"


@implementation FireBaseApiService
-(id)init
{
    self =[super init];
    return self;
}
+(FireBaseApiService*) instance
{
    static FireBaseApiService *instance =nil;
    if(instance ==nil){
        instance =[[FireBaseApiService alloc]init];
    }
    return instance;
}
#pragma mark Firebase Getting Tattoos Data
+ (void)onGetTattooFromFireBase:(void (^)(NSMutableArray *array))completion failure:(void (^)(NSError *error))failure
{
    NSMutableArray *arrTattoo = [NSMutableArray array];
    [[[mainRef  child:TATTOO_TABLE] queryOrderedByKey] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if (snapshot.exists) {
            for (NSString *theKeys in [[snapshot value] allKeys]) {
                if(theKeys != nil){
                    [arrTattoo addObject:[self parseTattooModelFromDictionary:snapshot.value[theKeys] withKeys:theKeys]];
                }
            }
            completion(arrTattoo);
        }else{
            completion(nil);
        }
    } withCancelBlock:^(NSError * _Nonnull error) {
        NSLog(@"error = %@",error);
        failure(error);
    }];
}
#pragma mark Firebase Getting Tattoos Data
+ (void)onGetTattooFromFireBasewithTattooID:(NSString *)tattoo_id withCompletion:(void (^)(TattooModel *tattooModel))completion failure:(void (^)(NSError *error))failure
{
    [[[mainRef  child:TATTOO_TABLE] child:tattoo_id] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if (snapshot.exists) {
            completion([self parseTattooModelFromDictionary:snapshot.value withKeys:[[snapshot value] allKeys].lastObject]);
        }else{
            completion(nil);
        }
    } withCancelBlock:^(NSError * _Nonnull error) {
        NSLog(@"error = %@",error);
        failure(error);
    }];
}
#pragma mark GetTattooModelWithCategoryID
+ (void)onGetTatttooModelWithCategoryID:(NSString *)categoryID withCompletion:(void(^)(NSMutableArray *arrTattooModelWithCateID))completion
{
    NSMutableArray *arrTattooModelWithCateID = [NSMutableArray array];
    [[[[mainRef child:TATTOO_TABLE] queryOrderedByChild:CATEGORY_ID] queryEqualToValue:categoryID] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if (snapshot.exists) {
            for (NSString *theKeys in [[snapshot value] allKeys]) {
                if(theKeys != nil){
                    [arrTattooModelWithCateID addObject:[self parseTattooModelFromDictionary:snapshot.value[theKeys] withKeys:theKeys]];
                }
            }
            if (completion != nil) {
                completion(arrTattooModelWithCateID);
            }
            
        }else{
            completion(nil);
        }
        
    }];
}
#pragma mark GetTattooModelWithUserID
+ (void)onGetTatttooModelWithUserID:(NSString *)userID withCompletion:(void(^)(NSMutableArray *arrTattooModelWithUserID))completion
{
    NSMutableArray *arrTattooModelWithUserID = [NSMutableArray array];
    [[[[mainRef child:TATTOO_TABLE] queryOrderedByChild:USER_ID] queryEqualToValue:userID] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if (snapshot.exists) {
            for (NSString *theKeys in [[snapshot value] allKeys]) {
                if(theKeys != nil){
                    [arrTattooModelWithUserID addObject:[self parseTattooModelFromDictionary:snapshot.value[theKeys] withKeys:theKeys]];
                }
            }
            if (completion != nil) {
                completion(arrTattooModelWithUserID);
                
            }
            
        }else
        {
            completion(nil);
        }
        
    }];
}

#pragma mark TattooModel Parsing
+ (TattooModel *)parseTattooModelFromDictionary:(NSDictionary *)dictionary withKeys:(NSString *)key{
    NSError *error;
    TattooModel *tattooModel = [[TattooModel alloc] initWithDictionary:dictionary error:&error];
    tattooModel.tattoo_id = key;
    return tattooModel;
}

#pragma mark Firebase Getting FavorTattooModels Data
+ (void)onGetFavorTattooFromFireBase:query withCompleteion:(void (^)(NSMutableArray *arrFavorTattoo))completion failure:(void (^)(NSError *error))failure {
    NSMutableArray *arrFavorTattoos = [NSMutableArray array];
    [[mainRef  child:FAVORTATTOO_TABLE]  observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if ([snapshot exists]) {
            for (NSString *theKeys in [[snapshot value] allKeys]) {
                if(theKeys != nil){
                    [arrFavorTattoos addObject:[self parseFavorTattooModelFromDictionary:snapshot.value[theKeys] withKeys:theKeys]];
                }
            }
            completion(arrFavorTattoos);
        }else{
            completion(nil);
        }
        
    } withCancelBlock:^(NSError * _Nonnull error) {
        NSLog(@"error = %@",error);
        failure(error);
    }];
}
+ (void)onGetFavorTattooFromWithTattooIDFireBase:query withQuery:(NSString *)query2 withCompleteion:(void (^)(NSMutableArray *arrFavorTattoo))completion failure:(void (^)(NSError *error))failure {
    NSMutableArray *arrFavorTattoos = [NSMutableArray array];
    [[[mainRef  child:FAVORTATTOO_TABLE] child:query] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if ([snapshot exists]) {
            for (NSString *theKeys in [[snapshot value] allKeys]) {
                if(theKeys != nil){
                    [arrFavorTattoos addObject:theKeys];
                }
            }
            completion(arrFavorTattoos);
        }else{
            completion(nil);
        }
        
    } withCancelBlock:^(NSError * _Nonnull error) {
        NSLog(@"error = %@",error);
        failure(error);
    }];
}
+ (FavorTattooModel *)parseFavorTattooModelFromDictionary:(NSDictionary *)dictionary withKeys:(NSString *)key{
    NSError *error;
    FavorTattooModel *favortattooModel = [[FavorTattooModel alloc] initWithDictionary:dictionary error:&error];
    return favortattooModel;
}


#pragma mark Firebase Getting Tattoo Styles Data
+ (void)onGetTattooStylesFromFireBase:(void (^)(NSMutableArray *array))completion failure:(void (^)(NSError *error))failure {
    NSMutableArray *arrStyles = [NSMutableArray array];
   [[mainRef  child:STYLE_TABLE] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
       if (snapshot.exists) {
           for (NSString *theKey in [[snapshot value] allKeys]) {///Convert from array to dictionary
               if(theKey != nil){
                   [arrStyles addObject:[self parseStyleModelFromDictionary:snapshot.value[theKey] withKeys:theKey]];
               }
           }
           completion(arrStyles);
       }else{
           completion(nil);
       }


    } withCancelBlock:^(NSError * _Nonnull error) {
        NSLog(@"error = %@",error);
        failure(error);
    }];
}
+ (StyleModel *)parseStyleModelFromDictionary:(NSDictionary *)dictionary withKeys:(NSString *)keys{
    NSError *error;
    StyleModel *styleModel = [[StyleModel alloc] initWithDictionary:dictionary error:&error];
    styleModel.style_id = keys;
    return styleModel;
}


#pragma mark FireBase Getting Favor Tattoo Style Data
+(void)onGetFavorStyleFromFireBase:(NSString *)query withCompleteion:(void (^)(NSMutableArray *))completion failure:(void (^)(NSError *))failure{
    NSMutableArray *arrFavorStyle = [NSMutableArray array];
    [[[[mainRef child:FAVORSTYLE_TABLE] queryOrderedByChild:query] queryEqualToValue:[FIRAuth auth].currentUser.uid] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if ([snapshot exists]) {
            for (NSString *theKeys in [[snapshot value] allKeys]) {
                if(theKeys != nil){
                    [arrFavorStyle addObject:[self parseFavorStyleModelFromDictionary:snapshot.value[theKeys] withKeys:theKeys]];
                }
            }
            completion(arrFavorStyle);
        }else{
            completion(nil);
        }
    }withCancelBlock:^(NSError * _Nonnull error) {
        failure(error);
        
    }];
    
}
+ (FavorStyleModel *)parseFavorStyleModelFromDictionary:(NSDictionary *)dictionary withKeys:(NSString *)key
{
    NSError *error;
    FavorStyleModel *styleModel = [[FavorStyleModel alloc] initWithDictionary:dictionary error:&error];
    return styleModel;
}
#pragma mark Get UserInfo
+ (void)onGetUserInfoFromFireBase:(NSString *)user_id withTableName:(NSString *)tableName withCompletion:(void (^)(UserModel *userModel))completion failure:(void(^)(NSError *error))failure{
    [[[mainRef child:USER_TABLE] child:user_id] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if ([snapshot exists] && [TattooUtilis sharedInstance].delete_sucess == 0) {
            completion([self parseUserModelFromDictionary:snapshot.value]);
        }else{
            completion(nil);
        }
    }withCancelBlock:^(NSError * _Nonnull error) {
        failure(error);
    }];
    
}
+ (void)onGetUserArrayFromFireBase:(NSMutableArray *)arrUserID withTableName:(NSString *)tableName withCompletion:(void (^)(NSMutableArray *arrUserModel))completion failure:(void(^)(NSError *error))failure
{
    NSMutableArray *arrUserModels = [NSMutableArray array];
    [[mainRef child:USER_TABLE]observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if (snapshot.exists) {
            for (NSString *theKeys in [[snapshot value] allKeys]) {
                if(theKeys != nil){
                    [arrUserModels addObject:[self parseUserModelFromDictionary:snapshot.value[theKeys]]];
                }
            }
            completion(arrUserModels);
        }else{
            completion(nil);
        }
    }];
}
+ (void)onGetTotalUserInfoFromFireBase:(NSString *)tableName withCompletion:(void (^)(NSMutableArray *arrUserModel))completion failure:(void (^)(NSError *))failure
{
    NSMutableArray *arrUserModel = [NSMutableArray array];
    [[mainRef child:tableName] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if ([snapshot exists] && [TattooUtilis sharedInstance].delete_sucess == 0) {
            for (NSString *theKeys in [[snapshot value] allKeys]) {
                if(theKeys != nil){
                    [arrUserModel addObject:[self parseUserModelFromDictionary:snapshot.value[theKeys]]];
                }
            }
            completion(arrUserModel);
        }else{
            completion(nil);
        }
    }withCancelBlock:^(NSError * _Nonnull error) {
        failure(error);
    }];
}
+ (UserModel *)parseUserModelFromDictionary:(NSDictionary *)dictionary
{
    UserModel *userModel = [[UserModel alloc] initWithDictionary:dictionary error:nil];
    return userModel;
}
#pragma mark TattooistInfo
+ (void)onGetTattooistInfoFromFireBase:(NSString *)tattooist_id withTableName:(NSString *)tableName withCompletion:(void (^)(TattoistModel *tattooistModel))completion failure:(void(^)(NSError *error))failure
{
    [[[mainRef child:tableName] child:tattooist_id] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if ([snapshot exists] && [TattooUtilis sharedInstance].delete_sucess == 0) {
            completion([self parseTattooistModelFromDictionary:snapshot.value]);
        }else{
            completion(nil);
        }
    }withCancelBlock:^(NSError * _Nonnull error) {
        failure(error);
    }];
}
+ (TattoistModel *)parseTattooistModelFromDictionary:(NSDictionary *)dictionary {
    TattoistModel *tattooistModel = [[TattoistModel alloc] initWithDictionary:dictionary error:nil];
 
    return tattooistModel;
}

#pragma mark Get RegisterationToken
+ (void)onGetRegistrationToken:(NSString *)userID withCompletion:(void (^)(TokenModel *tokenModel))completion
{
   [[[mainRef child:REGISTTOKEN_TABLE] child:userID] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
       if (snapshot.exists) {
           completion([self parseTokenModelWithDic:snapshot.value]);
       }else{
           completion(nil);
       }
        
    }];
}
+ (TokenModel *)parseTokenModelWithDic:(NSDictionary *)tokenDic
{
    TokenModel *tokenModel = [[TokenModel alloc] initWithDictionary:tokenDic error:nil];
    return tokenModel;
}
#pragma mark Get CommentModel
+ (void)onGetCommentCount:(NSString *)tattooID withCompletion:(void(^)(NSMutableArray *arrComment))completion
{
    NSMutableArray *arrCommentModel = [NSMutableArray array];
    [[[mainRef child:COMMENT_TABLE] child:tattooID] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if (snapshot.exists && ![SharedModel instance].isLoadedComment) {
            for (NSString *theKeys in [[snapshot value] allKeys]) {
                if(theKeys != nil){
                    [arrCommentModel addObject:[self parseCommnetModelFromDictionary:snapshot.value[theKeys] withKeys:theKeys]];
                }
            }
            if (completion != nil) {
                completion(arrCommentModel);
              
            }
            
        }else{
            completion(nil);
        }
    }];
}
+ (void)onGetCommentCountWithUserID:(NSString *)userID withCompletion:(void(^)(NSMutableArray *arrCommentModel))completion
{
    NSMutableArray *arrCommentModel = [NSMutableArray array];
    [[mainRef child:COMMENT_TABLE] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            if (snapshot.exists) {
                for (NSString *theKeys in [[snapshot value] allKeys]) {
                    if(theKeys != nil){
                        for (NSString *subkeys in snapshot.value[theKeys])
                        {
                            if (subkeys != nil && snapshot.value[theKeys] != nil){
                                NSLog(@"Value %@",snapshot.value[theKeys][subkeys]);
                                CommentModel *commentModel = [self parseCommnetModelFromDictionary:snapshot.value[theKeys][subkeys] withKeys:nil];
//                                NSDictionary *dic = [NSDictionary dictionaryWithDictionary:snapshot.value[theKeys][subkeys]];
                                if ([userID isEqualToString:commentModel.user_id]) {
                                    [arrCommentModel addObject:theKeys];
                                    break;
                                }
                            }
                        }
                    }
                }
                completion(arrCommentModel);
            }else{
                completion(nil);
            }
        }];
   
}
+ (CommentModel *)parseCommnetModelFromDictionary:(NSDictionary *)dictionary withKeys:(NSString *)key
{
    CommentModel *commentModel = [[CommentModel alloc] initWithDictionary:dictionary error:nil];
    commentModel.comment_id = key;
    return commentModel;
}


#pragma mark Get CategoryModel
+ (void)onGetCateGoryModel:(void (^)(NSMutableArray *arrCategoryModel))completion
{
    NSMutableArray *arrCategoryModel = [NSMutableArray array];
    [[[mainRef child:CATEGORY_TABLE] queryOrderedByChild:CATEGORY_ID] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if (snapshot.exists) {
            for (NSString *theKeys in [[snapshot value] allKeys]) {
                if(theKeys != nil){
                    [arrCategoryModel addObject:[self parseCategoryModelWithDictionary:snapshot.value[theKeys] withKeys:theKeys]];
                }
            }
            if (completion != nil) {
                completion(arrCategoryModel);
               
            }
            
        }else{
            completion(nil);
        }
        
    }];
}
+ (CategoryModel *)parseCategoryModelWithDictionary:(NSDictionary *)dic withKeys:(NSString *)keys
{
    CategoryModel *categoryModel = [[CategoryModel alloc] initWithDictionary:dic error:nil];
    categoryModel.category_id = keys;
    return categoryModel;
}

#pragma mark Get TattooShopInfo
+ (void)onGetTattooShopInfoWithTattooShopID:(NSString *)tattooShopID withCompletion:(void (^)(TattooShopModel *))completion{
    [[[[mainRef child:TATTOOSHOP_TABLE] queryOrderedByChild:TATTOO_SHOP_ID] queryEqualToValue:tattooShopID] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if (snapshot.exists) {
            completion([self parseTattooShopModelWithDic:[[snapshot value] allValues].lastObject withKeys:[[snapshot value] allKeys].lastObject]);
        }else{
            completion(nil);
        }
        
    }];
}
+ (void)onGetTotalTattooShopInfoWithTattooShopID:(void (^)(NSMutableArray *))completion
{
    NSMutableArray *arrTattooShopModel = [NSMutableArray array];
    [[[mainRef child:TATTOOSHOP_TABLE] queryOrderedByChild:TATTOO_SHOP_ID]  observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if (snapshot.exists) {
            for (NSString *theKeys in [[snapshot value] allKeys]) {
                if(theKeys != nil){
                    [arrTattooShopModel addObject:[self parseTattooShopModelWithDic:snapshot.value[theKeys] withKeys:theKeys]];
                }
            }
            completion(arrTattooShopModel);
        }else{
            completion(nil);
        }
        
    }];
    
}
+ (TattooShopModel *)parseTattooShopModelWithDic:(NSDictionary *)dic withKeys:(NSString *)key
{
    TattooShopModel *tattooShopModel = [[TattooShopModel alloc] initWithDictionary:dic error:nil];
    tattooShopModel.tattooshop_id = key;
    return tattooShopModel;
}

#pragma mark OnCheck FollowStatus
+ (void)onCheckFollowStatus:(NSString *)follower_id withCompletion:(void (^)(BOOL isExist))completion{
    [[[[mainRef child:USER_FOLLOW_TABLE] queryOrderedByChild:FOLLOW_ID] queryEqualToValue:follower_id] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if(snapshot.exists && ![SharedModel instance].isCheckedFollow)
        {
            [SharedModel instance].isCheckedFollow = YES;
            completion(true);
        }else if(!snapshot.exists && ![SharedModel instance].isCheckedFollow){
            [SharedModel instance].isCheckedFollow = YES;
            completion(false);
        }
        else{
            completion(false);
        }
    }];
}


#pragma mark getFollowers

+(void)onGetFollowersWithUserID:(NSString *)userID withCompletion:(void (^)(NSMutableArray *arrFollowers))completion
{
    NSMutableArray *arrUserFollowers = [NSMutableArray array];
    [[[mainRef child:USER_FOLLOW_TABLE] child:userID] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if (snapshot.exists && ![SharedModel instance].isUserCheckedFollow) {
            for (NSString *theKeys in [[snapshot value] allKeys]) {
                if(theKeys != nil){
                   [arrUserFollowers addObject:theKeys];
                }
            }
            completion(arrUserFollowers);
        }else{
            completion(nil);
        }
    }];
}
+ (UserFollowModel *)parseUserFollowModelWithDic:(NSDictionary *)dic
{
    UserFollowModel *userFollowModel = [[UserFollowModel alloc] initWithDictionary:dic error:nil];
    return userFollowModel;
}

@end
