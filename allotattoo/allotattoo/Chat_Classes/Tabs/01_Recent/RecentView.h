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

#import "SelectSingleView.h"
#import "SelectMultipleView.h"
#import "Constant.h"
@protocol RecentViewDelegate

- (void)updateMessageBadge:(NSInteger )counter;

@end
//-------------------------------------------------------------------------------------------------------------------------------------------------
@interface RecentView : UIViewController <SelectSingleDelegate, SelectMultipleDelegate,UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UIButton *btnMessage;
@property (weak, nonatomic) IBOutlet UITableView *tblMessage;
@property (nonatomic, assign) IBOutlet id<RecentViewDelegate>delegate;
- (void)saveRecentInfo:(FObject *)object withKey:(NSString *)key;
- (FObject *)loadRecentInfo:(NSString *)key;
@end
