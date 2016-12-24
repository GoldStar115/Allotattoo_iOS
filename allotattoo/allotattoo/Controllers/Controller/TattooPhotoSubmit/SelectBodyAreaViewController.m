//
//  SelectBodyAreaViewController.m
//  AllTattoo
//
//  Created by My Star on 7/4/16.
//  Copyright © 2016 AllTattoo. All rights reserved.
//

#import "SelectBodyAreaViewController.h"
#import "PhotoPushViewController.h"
@interface SelectBodyAreaViewController ()
{
    NSString *strCategory;
    NSString *strCategoryName;
    BOOL isAucune;
    BOOL isTete;
    BOOL isVisage;
    BOOL isNuque;
    BOOL isCou;
    BOOL isHaut;
    BOOL isBars;
    BOOL isCrops;
}

@end

@implementation SelectBodyAreaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isAucune = NO;
    isTete = NO;
    isVisage = NO;
    isNuque = NO;
    isCou = NO;
    isHaut = NO;
    isBars = NO;
    isCrops = NO;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)onSelectAucune:(id)sender {
    if (!isAucune) {
        [self.viewValid setBackgroundColor:[UIColor colorWithRed:6.0f/255.0f green:190.0f/255.0f blue:189.0f/255.0f alpha:1.0f]];
        isAucune = !isAucune;
        _imgAucuneSelect.image = [UIImage imageNamed:@"imgCheckCircle"];
        _imgTete.image = [UIImage imageNamed:@"imgCircle"];
        _imgVisageSelect.image = [UIImage imageNamed:@"imgCircle"];
        _imgBras.image = [UIImage imageNamed:@"imgCircle"];
        _imgCouSelect.image = [UIImage imageNamed:@"imgCircle"];
        _imgBasCrops.image = [UIImage imageNamed:@"imgCircle"];
        _imgHatCrops.image = [UIImage imageNamed:@"imgCircle"];
        _imgNuqueSelect.image = [UIImage imageNamed:@"imgCircle"];
        strCategory = @"1";
        strCategoryName = @"Aucune zone";
    }else{
        isAucune = !isAucune;
        _imgAucuneSelect.image = [UIImage imageNamed:@"imgCircle"];
        strCategory = nil;
        strCategoryName = nil;
    }
    
}
- (IBAction)onSelectTete:(id)sender {
    if (!isTete) {
        [self.viewValid setBackgroundColor:[UIColor colorWithRed:6.0f/255.0f green:190.0f/255.0f blue:189.0f/255.0f alpha:1.0f]];
        isTete = !isTete;
        _imgTete.image = [UIImage imageNamed:@"imgCheckCircle"];
        _imgAucuneSelect.image = [UIImage imageNamed:@"imgCircle"];
        _imgVisageSelect.image = [UIImage imageNamed:@"imgCircle"];
        _imgBras.image = [UIImage imageNamed:@"imgCircle"];
        _imgCouSelect.image = [UIImage imageNamed:@"imgCircle"];
        _imgBasCrops.image = [UIImage imageNamed:@"imgCircle"];
        _imgHatCrops.image = [UIImage imageNamed:@"imgCircle"];
        _imgNuqueSelect.image = [UIImage imageNamed:@"imgCircle"];
        strCategory = @"2";
        strCategoryName = @"Tete";
    }else{
        isTete = !isTete;
        _imgTete.image = [UIImage imageNamed:@"imgCircle"];
        strCategory = nil;
        strCategoryName = nil;
    }
}
- (IBAction)onSelectVisage:(id)sender {
    if (!isVisage) {
        [self.viewValid setBackgroundColor:[UIColor colorWithRed:6.0f/255.0f green:190.0f/255.0f blue:189.0f/255.0f alpha:1.0f]];
        isVisage = !isVisage;
        strCategory = @"3";
        _imgVisageSelect.image = [UIImage imageNamed:@"imgCheckCircle"];
        _imgAucuneSelect.image = [UIImage imageNamed:@"imgCircle"];
        _imgTete.image = [UIImage imageNamed:@"imgCircle"];
        _imgBras.image = [UIImage imageNamed:@"imgCircle"];
        _imgCouSelect.image = [UIImage imageNamed:@"imgCircle"];
        _imgBasCrops.image = [UIImage imageNamed:@"imgCircle"];
        _imgHatCrops.image = [UIImage imageNamed:@"imgCircle"];
        _imgNuqueSelect.image = [UIImage imageNamed:@"imgCircle"];
        strCategoryName = @"Viasge";
    }else{
        isVisage = !isVisage;
        strCategory = nil;
        _imgVisageSelect.image = [UIImage imageNamed:@"imgCircle"];
        strCategoryName = nil;
    }
}
- (IBAction)onSelectNuque:(id)sender {
    if (!isNuque) {
        [self.viewValid setBackgroundColor:[UIColor colorWithRed:6.0f/255.0f green:190.0f/255.0f blue:189.0f/255.0f alpha:1.0f]];
        isNuque = !isNuque;
        strCategory = @"4";
        _imgNuqueSelect.image = [UIImage imageNamed:@"imgCheckCircle"];
        _imgAucuneSelect.image = [UIImage imageNamed:@"imgCircle"];
        _imgTete.image = [UIImage imageNamed:@"imgCircle"];
        _imgVisageSelect.image = [UIImage imageNamed:@"imgCircle"];
        _imgBras.image = [UIImage imageNamed:@"imgCircle"];
        _imgCouSelect.image = [UIImage imageNamed:@"imgCircle"];
        _imgBasCrops.image = [UIImage imageNamed:@"imgCircle"];
        _imgHatCrops.image = [UIImage imageNamed:@"imgCircle"];
        strCategoryName = @"Nuque";
    }else{
        isNuque = !isNuque;
        strCategory = nil;
        _imgNuqueSelect.image = [UIImage imageNamed:@"imgCircle"];
        strCategoryName = nil;
    }
}
- (IBAction)onSelectCou:(id)sender {
    if (!isCou) {
        [self.viewValid setBackgroundColor:[UIColor colorWithRed:6.0f/255.0f green:190.0f/255.0f blue:189.0f/255.0f alpha:1.0f]];
        isCou = !isCou;
        strCategory = @"5";
        _imgCouSelect.image = [UIImage imageNamed:@"imgCheckCircle"];
        _imgVisageSelect.image = [UIImage imageNamed:@"imgCircle"];
        _imgAucuneSelect.image = [UIImage imageNamed:@"imgCircle"];
        _imgTete.image = [UIImage imageNamed:@"imgCircle"];
        _imgBras.image = [UIImage imageNamed:@"imgCircle"];
        _imgBasCrops.image = [UIImage imageNamed:@"imgCircle"];
        _imgHatCrops.image = [UIImage imageNamed:@"imgCircle"];
        _imgNuqueSelect.image = [UIImage imageNamed:@"imgCircle"];
        strCategoryName = @"Cou";
    }else{
        isCou = !isCou;
        strCategory = nil;
        _imgCouSelect.image = [UIImage imageNamed:@"imgCircle"];
        strCategoryName = nil;
    }
}
- (IBAction)onSelectHaut:(id)sender {
    if (!isCrops) {
        [self.viewValid setBackgroundColor:[UIColor colorWithRed:6.0f/255.0f green:190.0f/255.0f blue:189.0f/255.0f alpha:1.0f]];
        isCrops = !isCrops;
        _imgHatCrops.image = [UIImage imageNamed:@"imgCheckCircle"];
        _imgVisageSelect.image = [UIImage imageNamed:@"imgCircle"];
        _imgAucuneSelect.image = [UIImage imageNamed:@"imgCircle"];
        _imgTete.image = [UIImage imageNamed:@"imgCircle"];
        _imgBras.image = [UIImage imageNamed:@"imgCircle"];
        _imgCouSelect.image = [UIImage imageNamed:@"imgCircle"];
        _imgBasCrops.image = [UIImage imageNamed:@"imgCircle"];
        _imgNuqueSelect.image = [UIImage imageNamed:@"imgCircle"];
        strCategory = @"6";
        strCategoryName = @"Haut du Crops";
    }else{
        isCrops = !isCrops;
        strCategory = nil;
        _imgHatCrops.image = [UIImage imageNamed:@"imgCircle"];
        strCategoryName = nil;
    }
}
- (IBAction)onSelectBras:(id)sender {
    if (!isBars) {
        [self.viewValid setBackgroundColor:[UIColor colorWithRed:6.0f/255.0f green:190.0f/255.0f blue:189.0f/255.0f alpha:1.0f]];
        isBars = !isBars;
        strCategory = @"7";
        _imgBras.image = [UIImage imageNamed:@"imgCheckCircle"];
        _imgHatCrops.image = [UIImage imageNamed:@"imgCircle"];
        _imgVisageSelect.image = [UIImage imageNamed:@"imgCircle"];
        _imgAucuneSelect.image = [UIImage imageNamed:@"imgCircle"];
        _imgTete.image = [UIImage imageNamed:@"imgCircle"];
        _imgCouSelect.image = [UIImage imageNamed:@"imgCircle"];
        _imgBasCrops.image = [UIImage imageNamed:@"imgCircle"];
        _imgNuqueSelect.image = [UIImage imageNamed:@"imgCircle"];
        strCategoryName = @"Bars";
    }else{
        isBars = !isBars;
        strCategory = nil;
        _imgBras.image = [UIImage imageNamed:@"imgCircle"];
        strCategoryName = nil;
    }
}
- (IBAction)onBasduCrops:(id)sender {
    if (!isCrops) {
        [self.viewValid setBackgroundColor:[UIColor colorWithRed:6.0f/255.0f green:190.0f/255.0f blue:189.0f/255.0f alpha:1.0f]];
        isCrops = !isCrops;
        strCategory = @"8";
        _imgBasCrops.image = [UIImage imageNamed:@"imgCheckCircle"];
        _imgBras.image = [UIImage imageNamed:@"imgCircle"];
        _imgHatCrops.image = [UIImage imageNamed:@"imgCircle"];
        _imgVisageSelect.image = [UIImage imageNamed:@"imgCircle"];
        _imgAucuneSelect.image = [UIImage imageNamed:@"imgCircle"];
        _imgTete.image = [UIImage imageNamed:@"imgCircle"];
        _imgCouSelect.image = [UIImage imageNamed:@"imgCircle"];
        _imgNuqueSelect.image = [UIImage imageNamed:@"imgCircle"];
        strCategoryName = @"Crops";
    }else{
        isCrops = !isCrops;
        strCategory = nil;
        _imgBasCrops.image = [UIImage imageNamed:@"imgCircle"];
        strCategoryName = nil;
    }
}
- (IBAction)onValid:(id)sender {
    if (![strCategory isEqualToString:@""]) {
        [SharedModel instance].postTattooModel.category_id = strCategory;
        [SharedModel instance].postContentModel.category_name = strCategoryName;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
