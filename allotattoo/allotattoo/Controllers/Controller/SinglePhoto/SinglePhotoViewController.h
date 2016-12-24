//
//  SinglePhotoViewController.h
//  AllTattoo
//
//  Created by My Star on 7/3/16.
//  Copyright © 2016 AllTattoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinglePhotoCommitCell.h"
#import <MBProgressHUD.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "Constant.h"
#import <CLGCommentInputViewController.h>
#import "OtherUserProfileViewController.h"
#import "OtherArtistProfileViewController.h"
#import "SingleTattooHeaderCell.h"
#import <AAShareBubbles.h>
#import <MGInstagram.h>
#import "NotationViewController.h"

@interface SinglePhotoViewController : UIViewController<UITableViewDelegate,UITableViewDataSource, AAShareBubblesDelegate>
@property (weak, nonatomic) IBOutlet UIView *viewNavigation;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imgBack;

@property (weak, nonatomic) IBOutlet UIView *viewComment;



@property (weak, nonatomic) IBOutlet UITableView *tblCommitContent;



@property NSMutableArray *arrImageCommitUserPic;
@property NSMutableArray *arrCommitUserName;
@property NSMutableArray *arrCommitDate;
@property NSMutableArray *arrCommitContent;

@property TattooModel *singleTattooModel;

@end
