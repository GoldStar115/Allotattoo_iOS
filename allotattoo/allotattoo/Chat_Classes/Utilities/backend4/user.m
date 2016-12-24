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

#import "utilities.h"

#import "WelcomeView.h"
#import "NavigationController.h"

//-------------------------------------------------------------------------------------------------------------------------------------------------
void LoginUser(id target)
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	NavigationController *navigationController = [[NavigationController alloc] initWithRootViewController:[[WelcomeView alloc] init]];
	[target presentViewController:navigationController animated:YES completion:^{
		UIViewController *view = (UIViewController *)target;
		[view.tabBarController setSelectedIndex:DEFAULT_TAB];
	}];
}

#pragma mark -

//-------------------------------------------------------------------------------------------------------------------------------------------------
void UserLoggedIn(NSString *loginMethod)
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	UpdateUserSettings(loginMethod);
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[NotificationCenter post:NOTIFICATION_USER_LOGGED_IN];
	//---------------------------------------------------------------------------------------------------------------------------------------------
//	[ProgressHUD showSuccess:[NSString stringWithFormat:@"Welcome %@!", [FUser name]]];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
void UpdateUserSettings(NSString *loginMethod)
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	BOOL update = NO;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	FUser *user = [FUser currentUser];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if (user[FUSER_NAME_LOWER] == nil)		{	update = YES;	user[FUSER_NAME_LOWER] = [user[FUSER_NAME] lowercaseString];	}
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if (user[FUSER_LOGINMETHOD] == nil)		{	update = YES;	user[FUSER_LOGINMETHOD] = loginMethod;			}
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if (user[FUSER_KEEPMEDIA] == nil)		{	update = YES;	user[FUSER_KEEPMEDIA] = @(KEEPMEDIA_FOREVER);	}
	if (user[FUSER_NETWORKIMAGE] == nil)	{	update = YES;	user[FUSER_NETWORKIMAGE] = @(NETWORK_ALL);		}
	if (user[FUSER_NETWORKVIDEO] == nil)	{	update = YES;	user[FUSER_NETWORKVIDEO] = @(NETWORK_ALL);		}
	if (user[FUSER_NETWORKAUDIO] == nil)	{	update = YES;	user[FUSER_NETWORKAUDIO] = @(NETWORK_ALL);		}
	if (user[FUSER_AUTOSAVEMEDIA] == nil)	{	update = YES;	user[FUSER_AUTOSAVEMEDIA] = @NO;				}
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if (update) [user saveInBackground];
}
