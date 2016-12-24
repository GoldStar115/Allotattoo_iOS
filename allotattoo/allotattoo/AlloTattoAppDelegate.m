//
//  AppDelegate.m
//  AllTattoo
//
//  Created by My Star on 6/30/16.
//  Copyright © 2016 AllTattoo. All rights reserved.
//

#import "AlloTattoAppDelegate.h"
#import "NavigationViewController.h"
#import <FBSDKCoreKit.h>
@import Firebase;
@import FirebaseMessaging;

@interface AlloTattoAppDelegate ()

@end

@implementation AlloTattoAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [FIRApp configure];
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    /////FireBase Notification
    UIUserNotificationType allNotificationTypes =
    (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
    
    UIUserNotificationSettings *settings =
    [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tokenRefreshNotification:) name:kFIRInstanceIDScopeFirebaseMessaging  object:nil];
    self.reachability = [Reachability reachabilityForInternetConnection];
    [self initValues];
    
    return YES;
}
- (void)initValues
{
    arrNotiModels = [NSMutableArray array];
    _mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    _navController =(UINavigationController *) self.window.rootViewController;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

#pragma mark FireBase Pushnotification

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [[FIRInstanceID instanceID] setAPNSToken:deviceToken type:FIRInstanceIDAPNSTokenTypeSandbox];
}
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(nonnull UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
 
}
- (void)tokenRefreshNotification:(NSNotification *)notification {
    // Note that this callback will be fired everytime a new token is generated, including the first
    // time. So if you need to retrieve the token as soon as it is available this is where that
    // should be done.
    NSString *refreshedToken = [[FIRInstanceID instanceID] token];
    NSLog(@"InstanceID token: %@", refreshedToken);
    
    // Connect to FCM since connection may have failed when attempted before having a token.
    [self connectToFcm];
    
    // TODO: If necessary send token to appliation server.
}
- (void)connectToFcm {
    [[FIRMessaging messaging] connectWithCompletion:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Unable to connect to FCM. %@", error);
        } else {
            NSLog(@"Connected to FCM.");
        }
    }];
}
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"DidEnterBackground");
}
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"WillEnterForeground");
}
- (void)applicationDidFinishLaunching:(UIApplication *)application
{
    NSLog(@"DidFinishLunching");
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"%@",[SharedModel instance].arrNotificationModel);
    NSLog(@"Message ID: %@", userInfo[@"gcm.message_id"]);
    NSLog(@"Received Notifications = %@", userInfo);

        if (userInfo.count > 0) {
            
            NotificationModel *notiModel = [[NotificationModel alloc] init];
#if TARGET_OS_SIMULATOR
            notiModel = [self parseNotificationModel:userInfo];
#else
            notiModel = [self parseNotificationModel:userInfo];
#endif
//                if (application.applicationState == UIApplicationStateActive){
                    UILocalNotification *localnotification = [[UILocalNotification alloc] init];
                    localnotification.userInfo = userInfo;
                    localnotification.soundName = UILocalNotificationDefaultSoundName;
                    #if TARGET_OS_SIMULATOR
                    localnotification.alertBody = userInfo[@"aps"];
                    #else
                    localnotification.alertBody = userInfo[@"alert"];
                    #endif
                    localnotification.fireDate  = [NSDate  date];
                    [[UIApplication sharedApplication] scheduleLocalNotification:localnotification];
                    
//                }
            [[SharedModel instance].arrNotificationModel addObject:notiModel];
            NSLog(@"%@",[SharedModel instance].arrNotificationModel);
            [_delegate updateDadgeNumber:[SharedModel instance].arrNotificationModel.count];
            [[UIApplication sharedApplication]setApplicationIconBadgeNumber:[SharedModel instance].arrNotificationModel.count];
            NSDictionary *badgeInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:(int)[SharedModel instance].arrNotificationModel.count],@"badgecount", nil];
            NSLog(@"BadgeNumer %@",badgeInfo);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Updatebadge" object:self  userInfo:badgeInfo];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MenuUpdateArtist" object:self  userInfo:badgeInfo];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MenuUpdateUser" object:self  userInfo:badgeInfo];

            if (application.applicationState == UIApplicationStateInactive) {
                if (notiModel != nil) {
                    NSDictionary *notiDic = [NSDictionary dictionaryWithObjectsAndKeys:notiModel,@"notiDic", nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeRootView" object:self userInfo:notiDic];
                    _mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                                bundle: nil];
                    PhotoFeedViewController *photoFeedVC = [self.mainStoryboard instantiateViewControllerWithIdentifier:@"PhotoFeedViewController"];
                    [SharedModel instance].feedIndex = 0;
                    [SharedModel instance].isInsFiltered = NO;
                    [[SharedModel instance].arrInsTattooSearchResult removeAllObjects];
                    [[SharedModel instance].arrInsUserSearchResult removeAllObjects];
                    [self.sliderMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:photoFeedVC] animated:YES];
                    [self.sliderMenuViewController hideMenuViewController];
                }
            }
             completionHandler(UIApplicationBackgroundFetchIntervalNever);
            
        }



}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSLog(@"BecomeActive");
    [FBSDKAppEvents activateApp];
    [UIApplication sharedApplication].applicationIconBadgeNumber = [SharedModel instance].arrNotificationModel.count;
    [self connectToFcm];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSLog(@"Terminate");
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

#pragma mark facebook integration.

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}
+(AlloTattoAppDelegate *) sharedDelegate
{
    AlloTattoAppDelegate  *delegate = (AlloTattoAppDelegate *) [[UIApplication sharedApplication] delegate];
    return delegate;
}
#pragma mark - Location manager methods

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)locationManagerStart
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    if (self.locationManager == nil)
    {
        self.locationManager = [[CLLocationManager alloc] init];
        [self.locationManager setDelegate:self];
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
}

- (NotificationModel *)parseNotificationModel:(NSDictionary *)notiDic
{

    NotificationModel *notifiModel = [[NotificationModel alloc] init];
    notifiModel.arrTattooIDs = notiDic[@"ArrayTattoos"];
    notifiModel.strUserID = notiDic[@"follower_id"];
    notifiModel.strTime   = notiDic[@"Time"];
    notifiModel.strCommentText = notiDic[@"CommentText"];
    notifiModel.numStatus = notiDic[@"NotificationStatus"];
    NSLog(@"%@",notifiModel);
    return notifiModel;
    
}
@end
