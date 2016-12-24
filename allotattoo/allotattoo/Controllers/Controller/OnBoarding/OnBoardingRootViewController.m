//
//  OnBoardingRootViewController.m
//  AllTattoo
//
//  Created by My Star on 6/30/16.
//  Copyright © 2016 AllTattoo. All rights reserved.
//

#import "OnBoardingRootViewController.h"
#import "PhotoFeedViewController.h"
#import "MemberTypeViewController.h"
#import <MBProgressHUD.h>
#import "TattooModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "StyleModel.h"

@import Firebase;
//#import <RESideMenu/RESideMenu.h>

@interface OnBoardingRootViewController ()
{
   NSArray *arrPageTitles;
   NSArray *arrContentTitles;
   NSArray *arrPageImages;
   NSMutableArray<FIRDataSnapshot *> *arrTempParse;
   NSMutableArray *arrTattooResult;

}
@end

@implementation OnBoardingRootViewController
@synthesize PageViewController;
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    [TattooUtilis sharedInstance].delete_sucess = 0;
    arrTempParse = [NSMutableArray array];
    arrTattooResult = [NSMutableArray array];
}
- (void) viewWillAppear:(BOOL)animated{
    if([FIRAuth auth].currentUser)
    {
        PhotoFeedViewController *photoFeedVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoFeedViewController"];
        [SharedModel instance].feedIndex = 0;
        [self.navigationController pushViewController:photoFeedVC animated:NO];
    }

}
- (void) viewDidAppear:(BOOL)animated{
//    [super viewDidLoad];
    JScrollView_PageControl_AutoScroll *view=[[JScrollView_PageControl_AutoScroll alloc]initWithFrame:self.viewContent.frame];
    
    UIView *view1 = [[UIView alloc] initWithFrame:self.viewContent.frame];
    [view1 setBackgroundColor:[UIColor clearColor]];
    UILabel *label1Title = [[UILabel alloc] initWithFrame:self.lblTitle.frame];
    [label1Title setBackgroundColor:[UIColor clearColor]];
    label1Title.textColor = [UIColor whiteColor];
    label1Title.text = @"DECOUVRIR";
    label1Title.textAlignment =  NSTextAlignmentCenter;
     label1Title.font = [UIFont fontWithName:@"Arial-BoldMT" size:30.0];

    UILabel *label1Content = [[UILabel alloc] initWithFrame:self.lblContent.frame];
    [label1Content setBackgroundColor:[UIColor clearColor]];
    label1Content.textColor = [UIColor whiteColor];
    label1Content.lineBreakMode = NSLineBreakByWordWrapping;
    label1Content.numberOfLines = 3;
    label1Content.text = @"Explorez les différentes\n catégories de tatouages parmi\n nos galeries d’images";
    label1Content.textAlignment =  NSTextAlignmentCenter;
    label1Content.font = [UIFont fontWithName:@"Arial" size:18.0];
    [view1 addSubview:label1Title];
    [view1 addSubview:label1Content];
    
    UIView *view2 = [[UIView alloc] initWithFrame:self.viewContent.frame];
    UILabel *label2Title = [[UILabel alloc] initWithFrame:self.lblTitle.frame];
    [label2Title setBackgroundColor:[UIColor clearColor]];
    label2Title.textColor = [UIColor whiteColor];
    label2Title.text = @"PARTAGER";
    label2Title.textAlignment =  NSTextAlignmentCenter;
    label2Title.font = [UIFont fontWithName:@"Arial-BoldMT" size:30.0];
    
    UILabel *label2Content = [[UILabel alloc] initWithFrame:self.lblContent.frame];
    [label2Content setBackgroundColor:[UIColor clearColor]];
    label2Content.textColor = [UIColor whiteColor];
    label2Content.lineBreakMode = NSLineBreakByWordWrapping;
    label2Content.numberOfLines = 3;
    label2Content.text = @"Connectez-vous et partagez\n tes tatouages avec le\n reste de la communauté";
    label2Content.textAlignment =  NSTextAlignmentCenter;
    label2Content.font = [UIFont fontWithName:@"Arial" size:18.0];
    [view2 addSubview:label2Title];
    [view2 addSubview:label2Content];
    
    UIView *view3 = [[UIView alloc] initWithFrame:self.viewContent.frame];
    UILabel *label3Title = [[UILabel alloc] initWithFrame:self.lblTitle.frame];
    [label3Title setBackgroundColor:[UIColor clearColor]];
    label3Title.textColor = [UIColor whiteColor];
    label3Title.text = @"TROUVER";
    label3Title.textAlignment =  NSTextAlignmentCenter;
     label3Title.font = [UIFont fontWithName:@"Arial-BoldMT" size:30.0];
    
    UILabel *label3Content = [[UILabel alloc] initWithFrame:self.lblContent.frame];
    [label3Content setBackgroundColor:[UIColor clearColor]];
    label3Content.textColor = [UIColor whiteColor];
    label3Content.lineBreakMode = NSLineBreakByWordWrapping;
    label3Content.numberOfLines = 3;
    label3Content.text = @"Trouvez le tatoueur qui vous\n correspond parmis les centaines\n de professionnels inscrits";
    label3Content.textAlignment =  NSTextAlignmentCenter;
    label3Content.font = [UIFont fontWithName:@"Arial" size:18.0];
    [view3 addSubview:label3Title];
    [view3 addSubview:label3Content];
    
    
    view.autoScrollDelayTime=2.0;
    view.delegate=self;
    NSMutableArray *viewsArray=[[NSMutableArray alloc]initWithObjects:view1,view2,view3,nil];
    [view setViewsArray:viewsArray];
    [self.view addSubview:view];
    [view shouldAutoShow:YES];

}



- (void)didClickPage:(JScrollView_PageControl_AutoScroll *)view atIndex:(NSInteger)index
{
    NSLog(@"click at %d",(int)index  );
}
- (TattooModel *)parseTattooFromDictionary:(NSDictionary *)dictionary {
    NSError *error;
    TattooModel *tattooModel = [[TattooModel alloc] initWithDictionary:dictionary error:&error];
    NSLog(@"TattooModel = %@",tattooModel);
    return tattooModel;
}
- (StyleModel *)parseStyleFromDictionary:(NSDictionary *)dictionary {
    NSError *error;
    StyleModel *styleModel = [[StyleModel alloc] initWithDictionary:dictionary error:&error];
    NSLog(@"StyleModel = %@",styleModel);
    return styleModel;
}
#pragma mark Firebase testing
- (void)onGetParseTattoFirebase{
    _sampleRef = [[FIRDatabase database] reference];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[_sampleRef  child:@"Tattoo_table"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSDictionary *postDict = snapshot.value;
        NSLog(@"Get Dic %@",postDict);
        for (NSDictionary *theDic in postDict) {///Convert from array to dictionary
                if(theDic != nil){
                    NSLog(@"%@",theDic);
            
                    NSDictionary * tmpDic = snapshot.value[[NSString stringWithFormat:@"%@",theDic]];
                    [arrTattooResult addObject:[self parseTattooFromDictionary:tmpDic]];
                }
        }
    } withCancelBlock:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"error = %@",error);
    }];
}

- (void)onParseTattoo:(NSMutableArray *)array{
    NSError *error;
    for (FIRDataSnapshot *snapShot in array) {
        TattooModel *tattooModel = [[TattooModel alloc] initWithDictionary:snapShot.value error:&error];
        [arrTattooResult addObject:tattooModel];
    }
}

- (void)imageUpload{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    FIRStorage *storage = [FIRStorage storage];
    FIRStorageReference *storageRef = [storage referenceForURL:@"gs://allotatto.appspot.com/images/1.png"];
    NSData *imageData = UIImagePNGRepresentation([UIImage imageNamed:@"img_placeholder1"]);
    [storageRef putData:imageData metadata:nil completion:^(FIRStorageMetadata * _Nullable metadata, NSError * _Nullable error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!error) {
            NSURL *downloadURL = metadata.downloadURL;
            [self showImageFromFireBase:downloadURL];
            NSLog(@"DownLoad URL = %@",downloadURL);
        }else
        {
            NSLog(@"Error = %@",error);
        }
    }];
}
- (void) showImageFromFireBase:(NSURL *)imgURL{
    
      [_imgBackground sd_setImageWithURL:imgURL placeholderImage:[UIImage imageNamed:@"imgOnBoardingRoot"]];
}
#pragma mark onBoardNav
- (IBAction)onBoardNav:(id)sender {
    UIButton *temp = (UIButton *)sender;
    if (!temp.isSelected) {
        [_btnOnBoardNav setBackgroundImage:[UIImage imageNamed:@"btnOnBoard_sel"] forState:UIControlStateNormal];
    }else{
        [_btnOnBoardNav setBackgroundImage:[UIImage imageNamed:@"btnOnBoard_unsel"] forState:UIControlStateNormal];
    }
    double delayInSeconds = 0.3;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [_btnOnBoardNav setBackgroundImage:[UIImage imageNamed:@"btnOnBoard_unsel"] forState:UIControlStateNormal];

        MemberTypeViewController *memberTypeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MemberTypeViewController"];
        [self.navigationController pushViewController:memberTypeVC animated:YES];
    });

}



@end
