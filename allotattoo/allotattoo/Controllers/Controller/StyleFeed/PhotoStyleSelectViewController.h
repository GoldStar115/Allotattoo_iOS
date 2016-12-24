//
//  PhotoStyleSelectViewController.h
//  AllTattoo
//
//  Created by My Star on 7/4/16.
//  Copyright © 2016 AllTattoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoStyleCell.h"
#import "Constant.h"
#import <MBProgressHUD.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <CLGCommentInputViewController.h>
#import "PhotoPushViewController.h"

@interface PhotoStyleSelectViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionStyleSelect;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UIButton *btnValied
;
@property (weak, nonatomic) IBOutlet UIView *viewValid;

@property NSMutableArray *arrPhotoStyle;
@property NSMutableArray *arrPhotoStyleTitle;

@end
