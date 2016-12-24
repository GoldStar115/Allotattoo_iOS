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

//#import "utilities.h"

#import "StickersView.h"
#import "Constant.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImageDownloader.h>
#import "UserModel.h"
//-------------------------------------------------------------------------------------------------------------------------------------------------
@interface ChatView : JSQMessagesViewController <RNGridMenuDelegate, UIImagePickerControllerDelegate, IQAudioRecorderControllerDelegate, StickersDelegate>
//-------------------------------------------------------------------------------------------------------------------------------------------------
@property NSString *chat_group_id;
- (id)initWith:(NSString *)groupId_;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIView *viewNav;

@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property NSString *userName;
@property FObject *recent;
@end
