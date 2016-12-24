//
//  PhotoSubmitViewController.h
//  AllTattoo
//
//  Created by My Star on 7/4/16.
//  Copyright © 2016 AllTattoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotationViewController.h"


@interface PhotoSubmitViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UIImageView *imgSubmitPhoto;
@property (weak, nonatomic) IBOutlet UILabel *lblPost;
@property (weak, nonatomic) IBOutlet UIImageView *imgLogo;
@property (weak, nonatomic) IBOutlet UIView *viewPost;
@property (weak, nonatomic) IBOutlet UIButton *btnCapture;
@property (weak, nonatomic) IBOutlet UIView *viewCaption;
@property (weak, nonatomic) IBOutlet UIImageView *imgBlurCaption;
@property UIImage *imageCaptured;

@end
