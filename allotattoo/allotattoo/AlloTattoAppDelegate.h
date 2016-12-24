//
//  AppDelegate.h
//  AllTattoo
//
//  Created by My Star on 6/30/16.
//  Copyright © 2016 AllTattoo. All rights reserved.
//
#import "utilities.h"
#import <UIKit/UIKit.h>
#import "PhotoFeedViewController.h"
#import "TattooUtilis.h"
#import <RESideMenu.h>
#import "Constant.h"
#import <CoreLocation/CoreLocation.h>
@protocol UpdateBadgeNumberDelegate
//-------------------------------------------------------------------------------------------------------------------------------------------------

- (void)updateDadgeNumber:(NSInteger)counter;

@end
@interface AlloTattoAppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate>
{
    NSMutableArray *arrNotiModels;
}
@property (strong, nonatomic) Reachability *reachability;
@property RESideMenu *sliderMenuViewController;
@property (strong, nonatomic) UIWindow *window;
@property CLLocationManager *locationManager;
@property CLGeocoder *geocoder;
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property UIStoryboard *mainStoryboard;
@property UINavigationController *navController;
+ (AlloTattoAppDelegate *)sharedDelegate;
@property id<UpdateBadgeNumberDelegate> delegate;

@end

