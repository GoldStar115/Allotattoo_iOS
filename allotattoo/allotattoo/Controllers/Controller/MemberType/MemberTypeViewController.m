//
//  MemberTypeViewController.m
//  AllTattoo
//
//  Created by My Star on 6/30/16.
//  Copyright © 2016 AllTattoo. All rights reserved.
//

#import "MemberTypeViewController.h"
#import "SignUpWithUserViewController.h"
#import "SignUpTattoistViewController.h"
#import <RESideMenu/RESideMenu.h>
@interface MemberTypeViewController ()

@end

@implementation MemberTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES];

    // Do any additional setup after loading the view.
}
- (void) viewWillAppear:(BOOL)animated {
//    [_btnSignUpShow setBackgroundImage:[UIImage imageNamed:@"btn_signup_nav_unsel"] forState:UIControlStateNormal];
//    [_btnSignUpShow setBackgroundImage:[UIImage imageNamed:@"btn_signup_nav_sel"] forState:UIControlStateHighlighted];

//    [_btnLoginShow setBackgroundImage:[UIImage imageNamed:@"btn_login_nav_unsel"] forState:UIControlStateNormal];
//    [_btnLoginShow setBackgroundImage:[UIImage imageNamed:@"btn_login_nav_sel"] forState:UIControlStateHighlighted];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onLoginShow:(id)sender {
    UIButton *temp = (UIButton *)sender;
    if (temp.isTouchInside) {
        [_btnLoginShow setBackgroundImage:[UIImage imageNamed:@"btn_login_nav_sel"] forState:UIControlStateNormal];
    }else{
        [_btnLoginShow setBackgroundImage:[UIImage imageNamed:@"btn_login_nav_unsel"] forState:UIControlStateNormal];
    }
    double delayInSeconds = 0.3;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        SignUpWithUserViewController *signUpUserVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SignUpWithUserViewController"];
        [self.navigationController pushViewController:signUpUserVC animated:YES];
    });


}
- (IBAction)onSignUpShow:(id)sender {
    UIButton *temp = (UIButton *)sender;
    if (temp.isTouchInside) {
        [_btnSignUpShow setBackgroundImage:[UIImage imageNamed:@"btn_signup_nav_sel"] forState:UIControlStateNormal];
        
    }else{
        [_btnSignUpShow setBackgroundImage:[UIImage imageNamed:@"btn_signup_nav_unsel"] forState:UIControlStateNormal];
    }
    

    double delayInSeconds = 0.3;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        SignUpTattoistViewController *signUpTattoistVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SignUpTattoistViewController"];
        [self.navigationController pushViewController:signUpTattoistVC animated:YES];
    });
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)onShowMenu:(id)sender {
    [self.sideMenuViewController presentLeftMenuViewController];
}

@end
