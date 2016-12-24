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

#import "CreateGroupView.h"

//-------------------------------------------------------------------------------------------------------------------------------------------------
@interface CreateGroupView()
{
	NSString *linkPicture;

	NSMutableArray *users;
	NSMutableArray *sections;
	NSMutableArray *selection;
}

@property (strong, nonatomic) IBOutlet UIImageView *imageGroup;
@property (strong, nonatomic) IBOutlet UITextField *fieldName;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
//-------------------------------------------------------------------------------------------------------------------------------------------------

@implementation CreateGroupView

@synthesize imageGroup, fieldName, searchBar;

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[super viewDidLoad];
	self.title = @"Create Group";
	//---------------------------------------------------------------------------------------------------------------------------------------------
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self
																						  action:@selector(actionCancel)];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self
																						   action:@selector(actionDone)];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
	[self.tableView addGestureRecognizer:gestureRecognizer];
	gestureRecognizer.cancelsTouchesInView = NO;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	self.tableView.tableFooterView = [[UIView alloc] init];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	users = [[NSMutableArray alloc] init];
	selection = [[NSMutableArray alloc] init];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[self loadUsers];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidAppear:(BOOL)animated
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[super viewDidAppear:animated];
	[fieldName becomeFirstResponder];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)viewWillDisappear:(BOOL)animated
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[super viewWillDisappear:animated];
	[self dismissKeyboard];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)dismissKeyboard
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[self.view endEditing:YES];
}

#pragma mark - Backend actions

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)loadUsers
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[users removeAllObjects];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	for (FUser *user in [Users objects])
	{
		if ([user isCurrent] == NO)
			[users addObject:user];
	}
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if ([searchBar.text length] > 0)
		[self searchUser];
	else [self setObjects:users];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)searchUser
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	NSMutableArray *searches = [[NSMutableArray alloc] init];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	for (FUser *user in users)
	{
		NSString *text_lower = [searchBar.text lowercaseString];
		NSString *name_lower = user[FUSER_NAME_LOWER];
		if ([name_lower rangeOfString:text_lower].location != NSNotFound)
		{
			[searches addObject:user];
		}
	}
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[self setObjects:searches];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)setObjects:(NSArray *)objects
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	if (sections != nil) [sections removeAllObjects];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	NSInteger sectionTitlesCount = [[[UILocalizedIndexedCollation currentCollation] sectionTitles] count];
	sections = [[NSMutableArray alloc] initWithCapacity:sectionTitlesCount];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	for (NSUInteger i=0; i<sectionTitlesCount; i++)
	{
		[sections addObject:[NSMutableArray array]];
	}
	//---------------------------------------------------------------------------------------------------------------------------------------------
	for (FUser *object in objects)
	{
		NSInteger section = [[UILocalizedIndexedCollation currentCollation] sectionForObject:object collationStringSelector:@selector(name)];
		[sections[section] addObject:object];
	}
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[self.tableView reloadData];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)createGroup
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[ProgressHUD show:nil Interaction:NO];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	FObject *group = [FObject objectWithPath:FGROUP_PATH Subpath:[FUser currentId]];
	group[FGROUP_NAME] = fieldName.text;
	group[FGROUP_MEMBERS] = selection;
	if (linkPicture != nil) group[FGROUP_PICTURE] = linkPicture;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[group saveInBackground:^(NSError *error)
	{
		if (error == nil)
		{
			[ProgressHUD dismiss];
			[self dismissViewControllerAnimated:YES completion:nil];
		}
		else [ProgressHUD showError:@"Network error."];
	}];
}

#pragma mark - User actions

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)actionCancel
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)actionDone
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	NSString *name = fieldName.text;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if ([name length] == 0)		{ [ProgressHUD showError:@"Group name must be set."]; return; }
	if ([selection count] == 0) { [ProgressHUD showError:@"Please select some users."]; return; }
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[selection addObject:[FUser currentId]];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[self createGroup];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (IBAction)actionImage:(id)sender
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[self dismissKeyboard];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];

	UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"Open camera" style:UIAlertActionStyleDefault
													handler:^(UIAlertAction *action) { PresentPhotoCamera(self, YES); }];
	UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"Photo library" style:UIAlertActionStyleDefault
													handler:^(UIAlertAction *action) { PresentPhotoLibrary(self, YES); }];
	UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];

	[alert addAction:action1]; [alert addAction:action2]; [alert addAction:action3];
	[self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	UIImage *image = info[UIImagePickerControllerEditedImage];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	UIImage *imagePicture = [RELImage square:image size:100];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	NSData *dataPicture = UIImageJPEGRepresentation(imagePicture, 0.6);
	//---------------------------------------------------------------------------------------------------------------------------------------------
	FIRStorage *storage = [FIRStorage storage];
	FIRStorageReference *reference = [[storage referenceForURL:FIREBASE_STORAGE] child:Filename(@"group", @"jpg")];
	[reference putData:dataPicture metadata:nil completion:^(FIRStorageMetadata *metadata, NSError *error)
	{
		if (error == nil)
		{
			imageGroup.image = imagePicture;
			linkPicture = metadata.downloadURL.absoluteString;
		}
		else [ProgressHUD showError:@"Network error."];
	}];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIScrollViewDelegate

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[self dismissKeyboard];
}

#pragma mark - Table view data source

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	return [sections count];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	return [sections[section] count];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	if ([sections[section] count] != 0)
	{
		return [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section];
	}
	else return nil;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	return [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
	if (cell == nil) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];

	NSMutableArray *userstemp = sections[indexPath.section];
	FUser *user = userstemp[indexPath.row];

	cell.textLabel.text = user[FUSER_NAME];
	cell.accessoryType = [selection containsObject:[user objectId]] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;

	return cell;
}

#pragma mark - Table view delegate

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	NSMutableArray *userstemp = sections[indexPath.section];
	FUser *user = userstemp[indexPath.row];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if ([selection containsObject:[user objectId]])
		[selection removeObject:[user objectId]];
	else [selection addObject:[user objectId]];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	cell.accessoryType = [selection containsObject:[user objectId]] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
}

#pragma mark - UISearchBarDelegate

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	if ([searchText length] > 0)
		[self searchUser];
	else [self setObjects:users];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar_
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[searchBar setShowsCancelButton:YES animated:YES];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar_
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[searchBar setShowsCancelButton:NO animated:YES];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar_
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	searchBar.text = @"";
	[searchBar resignFirstResponder];
	[self setObjects:users];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar_
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[searchBar resignFirstResponder];
}

@end
