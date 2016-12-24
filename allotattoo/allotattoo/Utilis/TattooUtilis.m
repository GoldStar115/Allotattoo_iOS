//
//  TattooUtilis.m
//  allotattoo
//
//  Created by My Star on 7/15/16.
//  Copyright © 2016 My Star. All rights reserved.
//

#import "TattooUtilis.h"

@implementation TattooUtilis
-(id)init
{
    self =[super init];
    self.delete_sucess = 0;
    return self;
}
+ (BOOL)isReallyUser{
    if ([[FIRAuth auth].currentUser.email isEqualToString:@"no_user@test.com"]) {
        return NO;
    }else{
        return YES;
    }
}
+(NSString *)getDeviceID{
    NSString *UDID;
    UDID = [[[UIDevice currentDevice] identifierForVendor] UUIDString]; // IOS 6+
    NSLog(@"output is : %@", UDID);
    return UDID;
}

#pragma mark write  & read TattooModels
+ (void)saveTattooModelInIns:(NSMutableArray *)tattooArray{
    NSUserDefaults *tattooModelDefaults = [NSUserDefaults standardUserDefaults];
    for (int i = 0; i < tattooArray.count ; i ++) {
        NSDictionary *tattooDIC = [self parseFromTattooModel:tattooArray[i]];
        NSString *key = [NSString stringWithFormat:@"%@%d",TATTOOMODEL_LOCALDATA,i];
        [self removeModel:key];
        [tattooModelDefaults setObject:tattooDIC forKey:key];
        [tattooModelDefaults synchronize];
    }
}
+ (NSMutableArray *)getTattooModelInIns
{
    NSMutableArray *tempArray = [NSMutableArray array];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    for (int n = 0; n < 20 ; n ++)
    {
        TattooModel *tattooModel = [[TattooModel alloc] initWithDictionary:[userDefaults objectForKey:[NSString stringWithFormat:@"%@%d",TATTOOMODEL_LOCALDATA,n]] error:nil];
        if (tattooModel != nil) {
            [tempArray addObject:tattooModel];
        }
    }
    return tempArray;
}
#pragma mark Parse From TattooModel to Dic
+ (NSDictionary *)parseFromTattooModel:(TattooModel *)tattooModel
{
    NSDictionary *tattooDIC = @{
                                USER_ID: tattooModel.user_id ? tattooModel.user_id :@"",
                                TATTOO_IMG_URL:tattooModel.tattoo_image_url ? tattooModel.tattoo_image_url :@"",
                                STYLE_ID:tattooModel.style_id ? tattooModel.style_id : @"",
                                CATEGORY_ID:tattooModel.category_id ? tattooModel.category_id :@"",
                                TATTOO_SHOP_ID:tattooModel.tattooShop_id ? tattooModel.tattooShop_id : @"",
                                TATTOO_LINK :tattooModel.tattoo_link ? tattooModel.tattoo_link :@"",
                                TATTOO_ID:tattooModel.tattoo_id ? tattooModel.tattoo_id : @"",
                                TATTOO_NAME:tattooModel.tattoo_name ? tattooModel.tattoo_name :@"",
                                TATTOOIST_ID:tattooModel.tattoist_ID ? tattooModel.tattoist_ID :@"",
                                LIKE_FLAG:tattooModel.like_flag ? tattooModel.like_flag : [NSNumber numberWithInt:0]
                             };
    return tattooDIC;
}
#pragma mark write & read UserModels
+ (void)saveUserModelInIns:(NSMutableArray *)userArray{
    NSUserDefaults *userModelDefaults = [NSUserDefaults standardUserDefaults];
    for (int j = 0 ; j < userArray.count; j ++) {
        NSDictionary *userDIC = [self parseFromUserModel:userArray[j]];
        NSString *key = [NSString stringWithFormat:@"%@%d",USERMODEL_LOCALDATA,j];
        [self removeModel:key];
        [userModelDefaults setObject:userDIC forKey:key];
        [userModelDefaults synchronize];
    }

}
+ (NSMutableArray *)getUserModelInIns
{
    NSMutableArray *tempArray = [NSMutableArray array];
    NSUserDefaults *userModelDefaults = [NSUserDefaults standardUserDefaults];
    for (int k = 0;  k < 20; k ++) {
        UserModel *userModel = [[UserModel alloc] initWithDictionary:[userModelDefaults objectForKey:[NSString stringWithFormat:@"%@%d",USERMODEL_LOCALDATA,k]] error:nil];
        if (userModel != nil) {
            [tempArray addObject:userModel];
        }
    }
    return tempArray;
}
#pragma mark Parse From UserModel To Dic
+ (NSDictionary *)parseFromUserModel:(UserModel *)userModel
{
    NSDictionary *userDic = @{
                              USER_ID:userModel.user_id,
                              USER_PROVIDER_FBID:userModel.user_provideFBID ? userModel.user_provideFBID :@"" ,
                              USER_NAME:userModel.user_Name,
                              USER_EMAIL:userModel.user_email,
                              USER_PHOTO_URL:userModel.user_photoURL.absoluteString,
                              USER_LOCATION:userModel.userLocation,
                              USER_REFESHTOKEN:userModel.userRefreshToken ,
                              USER_PROVIDER_INSID:userModel.provideINSID ? userModel.provideINSID :@"",
                              CREATE_AT:userModel.createdAt ? userModel.createdAt :@"",
                              USER_FLAG:userModel.user_flag ? userModel.user_flag :[NSNumber numberWithInt:0],
                              TATTOO_SHOP_ID:userModel.tattooshop_id ? userModel.tattooshop_id :@""
                              };
    return userDic;
}
#pragma mark write & read StyleModels
+ (void)saveStyleModels:(NSMutableArray *)arrStyleModels
{
    NSUserDefaults *userModelDefaults = [NSUserDefaults standardUserDefaults];
    for (int j = 0 ; j < arrStyleModels.count; j ++) {
        NSDictionary *styleDic = [self parseFromStyleModel:arrStyleModels[j]];
        NSString *key = [NSString stringWithFormat:@"%@%d",STYLE_LOCALDATA,j];
        [self removeModel:key];
        [userModelDefaults setObject:styleDic forKey:key];
        [userModelDefaults synchronize];
    }
}
+ (NSMutableArray *)getStyleModels{
    NSMutableArray *tempArray = [NSMutableArray array];
    NSUserDefaults *userModelDefaults = [NSUserDefaults standardUserDefaults];
    for (int k = 0;  k < 20; k ++) {
        StyleModel *styleModel = [[StyleModel alloc] initWithDictionary:[userModelDefaults objectForKey:[NSString stringWithFormat:@"%@%d",STYLE_LOCALDATA,k]] error:nil];
        if (styleModel != nil) {
            [tempArray addObject:styleModel];
        }
    }
    return tempArray;
}
+ (NSDictionary  *)parseFromStyleModel:(StyleModel *)styleModel{
    NSDictionary *styleDic = @{
                               USER_ID:styleModel.user_id,
                               STYLE_IMG_URL:styleModel.style_image_url,
                               STYLE_TITLE:styleModel.style_title,
                               STYLE_DES:styleModel.style_des,
                               STYLE_ID:styleModel.style_id,
                               LIKE_FLAG:styleModel.like_flag ? styleModel.like_flag :[NSNumber numberWithInt:0]
                               };
    return styleDic;
}
#pragma mark Save and Get regist Token
+ (void)saveRegistToken:(NSString *) registToken;{
    
    [[NSUserDefaults standardUserDefaults] setObject:registToken forKey:USER_REGISTERATIONTOKEN];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
+ (NSString *)getRefreshToken{
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults]
                 stringForKey:USER_REFESHTOKEN] );
    return [[NSUserDefaults standardUserDefaults]
            stringForKey:USER_REFESHTOKEN];
}
#pragma mark Save Kind Users
+ (void)saveIsKindUsers:(NSNumber *) isKindUsers{
    NSString *strIsKindUsers = [NSString stringWithFormat:@"%d",(int)isKindUsers.intValue];
    [[NSUserDefaults standardUserDefaults] setObject:strIsKindUsers forKey:IS_KIND_USERS];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

+ (NSNumber *)getIsKindUsers{
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults]
                 stringForKey:IS_KIND_USERS] );
    NSNumberFormatter *result = [[NSNumberFormatter alloc] init];
    result.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *isKindNumber = [result numberFromString:[[NSUserDefaults standardUserDefaults]
                                                   stringForKey:IS_KIND_USERS]];
    return isKindNumber;
}
#pragma mark Save and Read a Usermodel
+ (void)saveUserModel:(NSDictionary *)userModel
{
    [[NSUserDefaults standardUserDefaults] setObject:userModel forKey:USER_MODEL];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSDictionary *)getUserModel
{
    return [[NSUserDefaults standardUserDefaults]
            objectForKey:USER_MODEL];
}
#pragma mark Save and Read a tattooistModel
+ (void)saveTattooistModel:(NSDictionary *)tattooistModel
{
    [[NSUserDefaults standardUserDefaults] setObject:tattooistModel forKey:TATTOOIST_MODEL];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

+ (NSDictionary *)getTattooistModel
{
    return [[NSUserDefaults standardUserDefaults]
            objectForKey:TATTOOIST_MODEL];
}

#pragma mark Remove Models for Key
+ (void)removeModel:(NSString *)modelKey
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:modelKey];
}
+(TattooUtilis *) sharedInstance
{

    static TattooUtilis *instance =nil;
    if(instance ==nil){
        instance =[[TattooUtilis alloc]init];
    }
    return instance;
}
+ (void)resetDefaults {
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    NSDictionary * dict = [defs dictionaryRepresentation];
    for (id key in dict) {
        [defs removeObjectForKey:key];
    }
    [defs synchronize];
}
#pragma mark convert UserDic To TattooistDic
+ (NSDictionary *)onConvertFromTattooistModel:(NSDictionary *)tattooistDic
{
    NSDictionary *user_table = @{
                                 USER_ID:tattooistDic[TATTOOIST_ID],
                                 USER_PROVIDER_FBID:tattooistDic[TATTOOIST_PROVIDER_ID],
                                 USER_NAME:tattooistDic[TATTOOIST_NAME],
                                 USER_EMAIL:tattooistDic[TATTOOIST_EMAIL],
                                 USER_PHOTO_URL:tattooistDic[TATTOOIST_PHOTO_URL],
                                 USER_LOCATION:tattooistDic[TATTOOIST_LOCATION],
                                 USER_REFESHTOKEN:tattooistDic[TATTOOIST_REFESHTOKEN]
                                 };
    return user_table;
}
#pragma mark convert TattooistModel to UserModel
+ (UserModel *)onConvertFromTattooistModelToUserModel:(TattoistModel *)tattooistModel
{
    UserModel *userModel  = [[UserModel alloc] init];
    userModel.user_id = tattooistModel.tattoist_ID;
    userModel.user_provideFBID = tattooistModel.tattooist_provideID;
    userModel.user_email = tattooistModel.tattoist_email;
    userModel.user_Name = tattooistModel.tattoist_Name;
    userModel.user_photoURL = tattooistModel.tattoist_photoURL;
    userModel.userLocation = tattooistModel.tattoistLocation;
    userModel.userRefreshToken = tattooistModel.tattooistRefreshToken;
   return userModel;
}

+ (NSMutableArray *)onGetFavorTattooFromTattooModel:(NSMutableArray *)arrTattoos{
    NSMutableArray *arrFavorTattooCheck = [NSMutableArray array];
    int i = - 1;
    for (TattooModel *tattooModel in arrTattoos) {
        FavorTattooModel *favorTattooModel = [[FavorTattooModel alloc]  init];
        i ++;
        if (tattooModel.like_flag.intValue == 1) {
            favorTattooModel.user_id = tattooModel.user_id;
            favorTattooModel.favortattoo_id = tattooModel.tattoo_id;
            favorTattooModel.favortattoo_url = tattooModel.tattoo_image_url;
            favorTattooModel.index = [NSNumber numberWithInt:i];
            [arrFavorTattooCheck addObject:favorTattooModel];
        }
    }
    return arrFavorTattooCheck;
    
}
#pragma mark Send Push Notification with RegistToken
+ (void)sendPushNotificationWithFollowUserID:(NSString *)registerToken withMessageContent:(NSDictionary *)messageDic withUserName:(NSString *)userName
{
    if ([SharedModel instance].isNotificaitonPermissioned) {
        NSString *alert = @"";
        NSNumber *index =messageDic[@"NotificationStatus"];
        switch (index.intValue) {
            case IS_FOLLOW_NOTIFICATION:
                alert = [NSString stringWithFormat:@"%@ has just followed you",userName];
                break;
            case IS_LIKE_NOTIFICATION:
                alert = [NSString stringWithFormat:@"%@ like your tattoo",userName];
                break;
            case IS_COMMENT_NOTIFICATION:
                alert = [NSString stringWithFormat:@"%@ post a comment on your photo",userName];
                break;
            case IS_MESSAGE_NOTIFICATION:
                alert = [NSString stringWithFormat:@"You just receive a message from %@",userName];
                break;
            default:
                break;
        }
        NSDictionary *pushDic = @{
                                  @"notification": @{
                                          @"alert":alert,
                                          @"text":alert,
                                          @"sound":@"default",                                                                       @"collapse_key":@"com.app.tattoo",
                                          },
                                  @"to": registerToken,
                                  @"priority": @"high",
                                  @"data":messageDic
                                  };
        NSLog(@"%@",pushDic);
        __block NSMutableDictionary *resultsDictionary;
        
        if ([NSJSONSerialization isValidJSONObject:pushDic]) {
            NSError* error;
            NSData* jsonData = [NSJSONSerialization dataWithJSONObject:pushDic options:NSJSONWritingPrettyPrinted error: &error];
            NSURL* url = [NSURL URLWithString:@"https://fcm.googleapis.com/fcm/send"];
            NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
            [request setHTTPMethod:@"POST"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setValue:[NSString stringWithFormat:@"%lu",(unsigned long)[jsonData length]] forHTTPHeaderField:@"Content-length"];
            
            [request setValue:@"key=AIzaSyBiD5H5p3jvpz4LUx8xjVyQxD0wHXd1WAE" forHTTPHeaderField:@"Authorization"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            
            [request setHTTPBody:jsonData];//set data
            __block NSError *error1 = [[NSError alloc] init];
            
            //use async way to connect network
            [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response,NSData *data,NSError* error)
             {
                 if ([data length] > 0 && error == nil) {
                     resultsDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error1];
                     NSLog(@"resultsDictionary is %@", resultsDictionary);
                     
                 } else if ([data length]==0 && error ==nil) {
                     NSLog(@" download data is null");
                 } else if( error!=nil) {
                     NSLog(@" error is %@",error);
                 }
             }];
        }
    }
}
+ (NSString *)generateRandomID
{
    NSInteger len = 12;
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_";
    NSMutableString *randomString = [NSMutableString stringWithCapacity:len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform((int)[letters length])]];
    }
    
    return randomString;
}
- (void)onSetTattooTableDataToFireBase{
    for (int i = 0 ; i <= 10; i  ++) {
        NSDictionary *tattoo = @{
                                 USER_ID:[FIRAuth auth].currentUser.uid,
                                 TATTOO_IMG_URL:@"10",
                                 STYLE_ID:@"",
                                 CATEGORY_ID:@"",
                                 TATTOO_SHOP_ID:@"",
                                 TATTOO_LINK :@""
                                 };
        [[[mainRef  child:TATTOO_TABLE] childByAutoId] setValue:tattoo];
    }
    
}
- (void)onSetTattooShopTableDataToFireBase{
    for (int i = 0 ; i <= 5; i  ++) {
        NSDictionary *tattoo = @{
                                 TATTOO_SHOP_ID:[NSString stringWithFormat:@"%d",i],
                                 TATTOO_SHOP_IMG_URL:@"https://firebasestorage.googleapis.com/v0/b/allotatto.appspot.com/o/TattooShopTable%2FUserpic%402x.png?alt=media&token=bea955fc-2551-439e-9aec-4cbf801527c3",
                                 TATTOO_SHOP_LOCATION:@"",
                                 TATTOO_SHOP_LINK:@"",
                                 USER_ID:[FIRAuth auth].currentUser.uid,
                                 TATTOO_SHOP_NAME:[NSString stringWithFormat:@"TattooShop %d",i]
                                 };
        [[[mainRef  child:TATTOOSHOP_TABLE] childByAutoId] setValue:tattoo];
    }
    
}
- (void)onSetCommentTableDataToFireBase{
    for (int i = 0 ; i <= 2; i  ++) {
        NSDictionary *comment = @{
                                  USER_ID:@"ds0kp3vzNtfAB9SHFleyFIKTgUv2",
                                  USER_PHOTO_URL:@"https://scontent.xx.fbcdn.net/v/t1.0-1/p100x100/12804749_182899825419382_8419654557357478245_n.jpg?oh=2d9ce71f32ddbd057059d44736b150d8&oe=57F30C05",
                                  COMMENT_CONTENT:@"I’m not a big fan of using eveningwear pieces in day-to-day looks. It’s too special – but you can bring in accessories like cufflinks or a dress scarf, which can be worn witzh other formal look.",
                                  TATTOO_ID:@"-KNWWOIgGZpN8ykZHSkI",
                                  CREATE_AT:@"07/25/16"
                                  };
        [[[mainRef  child:COMMENT_TABLE] childByAutoId] setValue:comment];
    }
    
}
- (void)onSetStyleDataToFireBase{
    
    for (int i = 0 ; i <= 5; i  ++) {
        NSDictionary *style = @{
                                USER_ID:[FIRAuth auth].currentUser.uid,
                                STYLE_IMG_URL:@"10",
                                STYLE_TITLE:@"Block Work",
                                STYLE_DES:@"Plus 50 de tagloues"
                                };
        [[[mainRef  child:STYLE_TABLE] childByAutoId] setValue:style];
    }
    
}
- (void)onCategoryDataToFireBase{
    
    for (int i = 0 ; i <= 5; i  ++) {
        NSDictionary *category = @{
                                   CATEGORY_ID:[FIRAuth auth].currentUser.uid,
                                   CATEGORY_IMG_URL:@"10",
                                   CATEGORY_TITLE:@"Block Work",
                                   CATEGORY_DESCRIPTION:@"Plus 50 de tagloues"
                                   };
        [[[mainRef  child:CATEGORY_TABLE] childByAutoId] setValue:category];
    }
    
}
- (void)onTattooShopDataToFireBase{
    
    for (int i = 0 ; i <= 5; i  ++) {
        NSDictionary *tattooShop = @{
                                     TATTOO_SHOP_ID:[FIRAuth auth].currentUser.uid,
                                     TATTOO_SHOP_LOCATION:@"10",
                                     TATTOO_SHOP_IMG_URL:@"Block Work",
                                     TATTOO_SHOP_LINK:@"Plus 50 de tagloues"
                                     };
        [[[mainRef  child:TATTOOSHOP_TABLE] childByAutoId] setValue:tattooShop];
    }
    
}

@end
