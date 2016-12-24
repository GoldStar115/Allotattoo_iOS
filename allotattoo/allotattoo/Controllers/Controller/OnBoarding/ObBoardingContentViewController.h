//
//  ObBoardingContentViewController.h
//  AllTattoo
//
//  Created by My Star on 6/30/16.
//  Copyright © 2016 AllTattoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ObBoardingContentViewController : UIViewController
@property  NSUInteger pageIndex;
@property  NSString *imgFile;
@property  NSString *txtTitle;
@property  NSString *txtContentTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIImageView *ivScreenImage;
@property (weak, nonatomic) IBOutlet UILabel *lblContentTitle;
@end
