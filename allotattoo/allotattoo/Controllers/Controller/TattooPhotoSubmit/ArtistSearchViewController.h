
#import "ArtistTableCell.h"
#import "Constant.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UserProfileViewController.h"
#import "OtherUserProfileViewController.h"
#import "PhotoPushViewController.h"
#import <UIKit/UIKit.h>

@interface ArtistSearchViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *viewSearch;
@property (weak, nonatomic) IBOutlet UIButton *btnSearchDismiss;
@property (weak, nonatomic) IBOutlet UITextField *txtSearch;

@property (weak, nonatomic) IBOutlet UIView *viewValid;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBarArtist;
@property (weak, nonatomic) IBOutlet UITableView *tblArtistList;
@property NSMutableArray *arrArtistUserModel;
@property NSMutableArray *arrLikeTattoos;
@property NSMutableArray *arrCheckStatus;
@property NSString       *likeTattooID;
@property NSString       *strRecommendArtist;
@end
