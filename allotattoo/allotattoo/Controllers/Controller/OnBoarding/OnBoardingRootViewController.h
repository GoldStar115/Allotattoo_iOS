//
//  OnBoardingRootViewController.h
//  AllTattoo
//
//  Created by My Star on 6/30/16.
//  Copyright © 2016 AllTattoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JScrollView+PageControl+AutoScroll.h"
#import "ObBoardingContentViewController.h"
#import "OnBoardingPageViewController.h"
@import FirebaseDatabase;

@interface OnBoardingRootViewController : UIViewController
<JScrollViewViewDelegate>
@property (nonatomic,strong) UIPageViewController *PageViewController;
@property NSUInteger index;
@property UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIImageView *imgBackground;
@property (weak, nonatomic) IBOutlet UIButton *btnOnBoardNav;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblContent;
@property (weak, nonatomic) IBOutlet UIView *viewContent;
@property FIRDatabaseReference *sampleRef;

@end
