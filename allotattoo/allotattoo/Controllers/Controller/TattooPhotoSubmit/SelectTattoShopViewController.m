//
//  SelectTattoShopViewController.m
//  AllTattoo
//
//  Created by My Star on 7/4/16.
//  Copyright © 2016 AllTattoo. All rights reserved.
//

#import "SelectTattoShopViewController.h"
#import "ArtistTableCell.h"
#import "TattooShopSearchCell.h"

@interface SelectTattoShopViewController ()<UISearchBarDelegate>
{
    BOOL isChecked;
    NSString *strTattooShopID;
    NSString *strTattooShopName;
    NSMutableArray *arrayCheck;
    NSMutableArray *arrSearchResult;
    BOOL isFiltered;
}
@end

@implementation SelectTattoShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.txtSearch.delegate = self;
    [self initSearchTextfiled];
    isChecked = NO;
    isFiltered = NO;
    
    arrayCheck = [NSMutableArray array];
    arrSearchResult = [NSMutableArray array];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self dataInit];
}
- (void)initSearchTextfiled{
    _viewSearch.layer.cornerRadius = _viewSearch.frame.size.height/2;
    _txtSearch.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Rechercher" attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
    
}
- (void)dataInit{
    if ([SharedModel instance].arrTattooShop.count  > 0 ) {
        for (int i  = 0; i < [SharedModel instance].arrTattooShop.count; i ++) {
            [arrayCheck addObject:@"uncheck"];
        }
        [FireBaseApiService onGetUserInfoFromFireBase:[FIRAuth auth].currentUser.uid withTableName:USER_TABLE withCompletion:^(UserModel *userModel) {
            if (userModel != nil) {
                if (userModel.user_flag.intValue == isKindTattooist) {
                    _searchTattooshop.placeholder = userModel.user_Name;
                }
            }
        } failure:^(NSError *error) {
            
        }];
    }else{
        [FireBaseApiService onGetTotalTattooShopInfoWithTattooShopID:^(NSMutableArray *arrTattooShopModel) {
            [SharedModel instance].arrTattooShop = arrTattooShopModel;
            for (int i  = 0; i < arrTattooShopModel.count; i ++) {
                [arrayCheck addObject:@"uncheck"];
            }
            [FireBaseApiService onGetUserInfoFromFireBase:[FIRAuth auth].currentUser.uid withTableName:USER_TABLE withCompletion:^(UserModel *userModel) {
                if (userModel != nil) {
                    if (userModel.user_flag.intValue == isKindTattooist) {
                        _searchTattooshop.placeholder = userModel.user_Name;
                    }
                }
            } failure:^(NSError *error) {
                
            }];
            [_tblTattooShop reloadData];
        }];
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark UITableViewData Source

-  (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (isFiltered) {
        return arrSearchResult.count;
    }else{
        if ([SharedModel instance].arrTattooShop.count > 0) {
            return [SharedModel instance].arrTattooShop.count;
        }else{
            return 0;
        }
    }
    
}
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TattooShopSearchCell *shopCell = (TattooShopSearchCell *)[tableView dequeueReusableCellWithIdentifier:@"TattooShopSearchCell"];
    TattooShopModel *tattooShopModel;
    if (isFiltered) {
        tattooShopModel = arrSearchResult[indexPath.row];
    }else{
        tattooShopModel = [SharedModel instance].arrTattooShop[indexPath.row];
    }
    [shopCell.imgTattooShop sd_setImageWithURL:[NSURL URLWithString:tattooShopModel.tattoo_shop_img_url] placeholderImage:[UIImage imageNamed:@""]];
    shopCell.lblShopDes.text = @"Asnière-sur-Seine";
    shopCell.lblTattooShopName.text = tattooShopModel.tattoo_shop_name;
    if ([[arrayCheck objectAtIndex:indexPath.row] isEqualToString:@"uncheck"]) {
        [shopCell.btnPlus setBackgroundImage:[UIImage imageNamed:@"imgPlus"] forState:UIControlStateNormal];
    }else{
        [shopCell.btnPlus setBackgroundImage:[UIImage imageNamed:@"imgCheckCircle"] forState:UIControlStateNormal];
    }
    [shopCell.btnPlus addTarget:self action:@selector(onCheckValid:event:) forControlEvents:UIControlEventTouchUpInside];
    return shopCell;
}

#pragma mark delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.view.frame.size.height/8;
}

- (IBAction)onBacl:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark check valid
- (void) onCheckValid:(id)sender event:(id)event{
    [self.viewValid setBackgroundColor:[UIColor colorWithRed:6.0f/255.0f green:190.0f/255.0f blue:189.0f/255.0f alpha:1.0f]];
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:_tblTattooShop
                                    ];
    NSIndexPath *indexPath = [_tblTattooShop indexPathForRowAtPoint: currentTouchPosition];
    TattooShopSearchCell *tattooShopCell = (TattooShopSearchCell *)[_tblTattooShop cellForRowAtIndexPath:indexPath];
    if ([[arrayCheck objectAtIndex:indexPath.row] isEqualToString:@"uncheck"]) {
        [tattooShopCell.btnPlus setBackgroundImage:[UIImage imageNamed:@"imgCheckCircle"] forState:UIControlStateNormal];
        TattooShopModel *tempTattooShopModel = [SharedModel instance].arrTattooShop[indexPath.row];
        strTattooShopID = tempTattooShopModel.tattooshop_id;
        strTattooShopName = tempTattooShopModel.tattoo_shop_name;
        for (int i = 0 ;  i < arrayCheck.count;  i ++) {
            if (i == (int)indexPath.row) {
                [arrayCheck replaceObjectAtIndex:i withObject:@"check"];
            }else{
                [arrayCheck replaceObjectAtIndex:i withObject:@"uncheck"];
            }
            
        }
    }else{
        [tattooShopCell.btnPlus setBackgroundImage:[UIImage imageNamed:@"imgPlus"] forState:UIControlStateNormal];
        [arrayCheck replaceObjectAtIndex:indexPath.row withObject:@"uncheck"];
    }
    [_tblTattooShop reloadData];
}

#pragma mark onValid
- (IBAction)onValid:(id)sender {
    if (![strTattooShopID isEqualToString:@""]) {
        [SharedModel instance].postTattooModel.tattooShop_id = strTattooShopID;
        [SharedModel instance].postContentModel.tattooshop_name = strTattooShopName;
    }
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark UISearchBar Delegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{

}
- (IBAction)txtEditChanged:(id)sender {
    UITextField *txtField = (UITextField *)sender;
    [arrSearchResult removeAllObjects];
    if (txtField.text.length == 0) {
        isFiltered = NO;
    }else{
        isFiltered = YES;
        for (TattooShopModel *tempModel in [SharedModel instance].arrTattooShop) {
            NSString *tattooShopName = tempModel.tattoo_shop_name;
            if ([tattooShopName rangeOfString:txtField.text].location != NSNotFound){
                [arrSearchResult addObject:tempModel];
            }
        }
    }
    [_tblTattooShop reloadData];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _txtSearch.text = @"";
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    textField.text = @"";
    [textField resignFirstResponder];
    return  YES;
}
- (IBAction)btnSearchDismiss:(id)sender {
    _txtSearch.text = @"";
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
@end
