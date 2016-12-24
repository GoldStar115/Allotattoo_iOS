//
// Copyright (c) 2016 Related Code - http://relatedcode.com
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "RecentView.h"
#import "RecentCell.h"
#import "ChatView.h"
#import "SelectSingleView.h"
#import "SelectMultipleView.h"
#import "NavigationController.h"
#import "PeopleView.h"
#import "PhotoFeedViewController.h"
#import "TattooUtilis.h"

//-------------------------------------------------------------------------------------------------------------------------------------------------
@interface RecentView()
{
	BOOL initialized;
	FIRDatabaseReference *firebase;
    UIRefreshControl *refreshControl;
	NSMutableArray *recents;
	NSMutableArray *recentIds;
    NSString *userName;
    
}
@end
//-------------------------------------------------------------------------------------------------------------------------------------------------

@implementation RecentView

- (void)viewDidLoad

{
	[super viewDidLoad];
    [self.navigationController.navigationBar setHidden:YES];
    refreshControl = [[UIRefreshControl alloc] init];
    [self.btnBack addTarget:self action:@selector(actionBack) forControlEvents:UIControlEventAllTouchEvents];
    [self.btnMessage addTarget:self action:@selector(actionCompose) forControlEvents:UIControlEventAllTouchEvents];
	self.tblMessage.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGFLOAT_MIN)];
	recents = [[NSMutableArray alloc] init];
	recentIds = [[NSMutableArray alloc] init];
    
    _tblMessage.estimatedRowHeight = 120.0f;
    _tblMessage.rowHeight = UITableViewAutomaticDimension;
    
    [refreshControl addTarget:self action:@selector(refreshRecents:) forControlEvents:UIControlEventValueChanged];
    [_tblMessage addSubview:refreshControl];
    
    userName = @"";
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}
- (void)viewDidAppear:(BOOL)animated
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[super viewDidAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if ([FUser currentId] != nil)
	{
        [self initRecents];
	}
	else LoginUser(self);
}
- (void)refreshRecents:(id)sender
{
    [recents removeAllObjects];
    [self loadRecents];
    
}
#pragma mark Write & Read FObejct

- (void)saveRecentInfo:(FObject *)object withKey:(NSString *)key
{
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:object];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:key];
    [defaults synchronize];
}
- (FObject *)loadRecentInfo:(NSString *)key
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaults objectForKey:key];
    FObject *object = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    return object;
}
- (NSMutableArray *)loadRecentFromDefault
{
    NSMutableArray *arrRecents = [NSMutableArray  array];
    for (int i = 0; i < 20; i ++) {
        FObject *object = [self loadRecentInfo:[NSString stringWithFormat:@"%@%d",@"RecentInfo",i]];
        if (object != nil) {
            [arrRecents addObject:object];
        }else{
            break;
        }
    }
    return arrRecents;
}
#pragma mark - Backend methods

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)initRecents
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	if ([FUser currentId] != nil)
	{
		if (initialized == NO)
		{
			initialized = YES;
            recents = [self loadRecentFromDefault];
            if (recents.count > 0) {
                [_tblMessage reloadData];
            }else{
                [self loadRecents];
            }
		}
		else [self.tblMessage reloadData];
	}
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)loadRecents
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[Recents load:^(NSMutableArray *objects)
	{
        int cnt = -1;
		for (FObject *recent in objects)
        {
            cnt ++;
			[self insertRecent:recent];
            if (cnt < 20) {
                [TattooUtilis removeModel:[NSString stringWithFormat:@"%@%d",@"RecentInfo",cnt]];
                [self saveRecentInfo:recent withKey:[NSString stringWithFormat:@"%@%d",@"RecentInfo",cnt]];
            }

        }
		//-----------------------------------------------------------------------------------------------------------------------------------------
        [refreshControl endRefreshing];
		[self.tblMessage reloadData];
		[self updateMsgCounter];
		//-----------------------------------------------------------------------------------------------------------------------------------------
		[self createRecentObservers];
	}];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)createRecentObservers
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	firebase = [[FIRDatabase database] referenceWithPath:FRECENT_PATH];
	FIRDatabaseQuery *query = [[firebase queryOrderedByChild:FRECENT_USERID] queryEqualToValue:[FUser currentId]];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[query observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot *snapshot)
	{
		FObject *recent = [FObject objectWithPath:FRECENT_PATH dictionary:snapshot.value];
		if ([recentIds containsObject:recent[FRECENT_GROUPID]] == NO)
		{
			[self insertRecent:recent];
			[self.tblMessage reloadData];
			[self updateMsgCounter];
		}
	}];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[query observeEventType:FIRDataEventTypeChildChanged withBlock:^(FIRDataSnapshot *snapshot)
	{
		FObject *recent = [FObject objectWithPath:FRECENT_PATH dictionary:snapshot.value];
		[self removeRecent:recent];
		[self insertRecent:recent];
		[self.tblMessage reloadData];
		[self updateMsgCounter];
	}];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[query observeEventType:FIRDataEventTypeChildRemoved withBlock:^(FIRDataSnapshot *snapshot)
	{
		FObject *recent = [FObject objectWithPath:FRECENT_PATH dictionary:snapshot.value];
		[self removeRecent:recent];
		[self.tblMessage reloadData];
		[self updateMsgCounter];
	}];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)insertRecent:(FObject *)recent
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[recents insertObject:recent atIndex:0];
	[recentIds insertObject:recent[FRECENT_GROUPID] atIndex:0];
	[RELPassword set:recent[FRECENT_PASSWORD] groupId:recent[FRECENT_GROUPID]];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)removeRecent:(FObject *)recent
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	for (FObject *temp in recents)
	{
		if ([[recent objectId] isEqualToString:[temp objectId]])
		{
			[recents removeObject:temp];
			[recentIds removeObject:recent[FRECENT_GROUPID]];
			break;
		}
	}
}

#pragma mark - Helper methods

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)updateMsgCounter
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	NSInteger total = 0;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	for (FObject *recent in recents)
	{
		total += [recent[FRECENT_COUNTER] integerValue];
	}
    [SharedModel instance].msg_total_counter = total;
    [_delegate updateMessageBadge:[SharedModel instance].msg_total_counter];

}

#pragma mark - User actions

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)actionChat:(NSString *)groupId withRecent:(FObject *)recent
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	ChatView *chatView = [[ChatView alloc] initWith:groupId];
    chatView.userName = userName;
    chatView.recent = recent;
	chatView.hidesBottomBarWhenPushed = YES;
	[self.navigationController pushViewController:chatView animated:YES];
}
- (void)actionBack
{
    if ([SharedModel instance].isMenuChatSelected){
        [SharedModel instance].isMenuChatSelected = NO;
        PhotoFeedViewController *photoFeedVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoFeedViewController"];
        [SharedModel instance].feedIndex = 0;
        [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:photoFeedVC] animated:YES];
        [self.sideMenuViewController hideMenuViewController];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)actionCompose
{
    [self actionSelectSingle];
}

- (void)actionSelectSingle
{
    SelectSingleView *selectSingleView = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectSingleView"];
	selectSingleView.delegate = self;
    [self presentViewController:selectSingleView animated:YES completion:nil];

}

#pragma mark - SelectSingleDelegate

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)didSelectSingleUser:(FUser *)user2
{
	NSString *groupId = StartPrivateChat(user2);
    userName = user2[FUSER_NAME];
	[self actionChat:groupId withRecent:user2];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)actionSelectMultiple
{
	SelectMultipleView *selectMultipleView = [[SelectMultipleView alloc] init];
	selectMultipleView.delegate = self;
	NavigationController *navController = [[NavigationController alloc] initWithRootViewController:selectMultipleView];
	[self presentViewController:navController animated:YES completion:nil];
}

#pragma mark - SelectMultipleDelegate

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)didSelectMultipleUsers:(NSMutableArray *)users
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
//	NSString *groupId = StartMultipleChat(users);
//	[self actionChat:groupId];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)actionCleanup
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[firebase removeAllObservers]; firebase = nil;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[recents removeAllObjects];
	[recentIds removeAllObjects];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[self.tblMessage reloadData];
	[self updateMsgCounter];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	initialized = NO;
}

#pragma mark - Table view data source

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	return 1;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    if (recents.count > 0) {
       	return [recents count];
    }else{
        return 0;
    }

}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	RecentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecentCell" forIndexPath:indexPath];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[cell bindData:recents[indexPath.row]];
	[cell loadImage:recents[indexPath.row] TableView:tableView IndexPath:indexPath];
	//---------------------------------------------------------------------------------------------------------------------------------------------
    
	return cell;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	return YES;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	FObject *recent = recents[indexPath.row];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[self removeRecent:recent];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[self updateMsgCounter];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[self.tblMessage deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[self performSelector:@selector(delayedDeleteRecentItem:) withObject:recent afterDelay:0.5];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)delayedDeleteRecentItem:(FObject *)recent
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[recent deleteInBackground:^(NSError *error)
	{
		if (error != nil) [ProgressHUD showError:@"Network error."];
	}];
}

#pragma mark - Table view delegate

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	FObject *recent = recents[indexPath.row];
	//---------------------------------------------------------------------------------------------------------------------------------------------
    userName = recent[FRECENT_DESCRIPTION];
	RestartRecentChat(recent);
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[self actionChat:recent[FRECENT_GROUPID] withRecent:recent];
}

@end
