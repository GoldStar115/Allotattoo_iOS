//
//  AboutUSViewController.m
//  AllTattoo
//
//  Created by My Star on 7/4/16.
//  Copyright © 2016 AllTattoo. All rights reserved.
//

#import "AboutUSViewController.h"
#import "PhotoFeedViewController.h"
#import "PrivacyViewController.h"
@interface AboutUSViewController ()

@end

@implementation AboutUSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onBack:(id)sender {
    PhotoFeedViewController *photoFeedVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoFeedViewController"];
    [SharedModel instance].feedIndex = 0;
    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:photoFeedVC] animated:YES];
    [self.sideMenuViewController hideMenuViewController];
}

- (IBAction)onPrivacy:(id)sender {
    PrivacyViewController *privacyVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PrivacyViewController"];
    [self.navigationController pushViewController:privacyVC animated:YES];
}
- (IBAction)onFBConnect:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.facebook.com/allotattoo/"]];
}
- (IBAction)onTWConnect:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/allotattoo"]];
}
- (IBAction)onInsConnect:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.instagram.com/allotattoo/"]];
}
- (IBAction)onConnectAllotattoo:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://allotattoo.com/"]];   
}


@end
