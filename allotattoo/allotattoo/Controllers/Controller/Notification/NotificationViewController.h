//
//  NotificationViewController.h
//  AllTattoo
//
//  Created by My Star on 7/4/16.
//  Copyright © 2016 AllTattoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "TableInsideCollectionCell.h"
#import "AlloTattoAppDelegate.h"
#import "ArtistProfileViewController.h"
#import "OtherArtistProfileViewController.h"

@interface NotificationViewController : UIViewController
@property NSMutableArray *arrMessageStr;
@property NSMutableArray *arrMessageUserPic;
@property NSMutableArray *arrMessageTime;
@property (weak, nonatomic) IBOutlet UITableView *tableNotification;
@property NSMutableArray *arrName;
@end
