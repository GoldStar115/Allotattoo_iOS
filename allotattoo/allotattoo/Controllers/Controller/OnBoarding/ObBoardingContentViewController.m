//
//  ObBoardingContentViewController.m
//  AllTattoo
//
//  Created by My Star on 6/30/16.
//  Copyright © 2016 AllTattoo. All rights reserved.
//

#import "ObBoardingContentViewController.h"

@interface ObBoardingContentViewController ()

@end

@implementation ObBoardingContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor clearColor]];
    self.ivScreenImage.image = [UIImage imageNamed:self.imgFile];
    self.lblTitle.text = self.txtTitle;
    self.lblContentTitle.text = self.txtContentTitle;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
