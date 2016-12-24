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

#import "RecentCell.h"

//-------------------------------------------------------------------------------------------------------------------------------------------------
@interface RecentCell()

@property (strong, nonatomic) IBOutlet UIImageView *imageUser;
@property (strong, nonatomic) IBOutlet UILabel *labelDescription;
@property (strong, nonatomic) IBOutlet UILabel *labelLastMessage;
@property (strong, nonatomic) IBOutlet UILabel *labelElapsed;
@property (strong, nonatomic) IBOutlet UILabel *labelCounter;

@end
//-------------------------------------------------------------------------------------------------------------------------------------------------

@implementation RecentCell

@synthesize imageUser;
@synthesize labelDescription, labelLastMessage;
@synthesize labelElapsed, labelCounter;

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)bindData:(FObject *)recent
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	labelDescription.text = recent[FRECENT_DESCRIPTION];
	labelLastMessage.text = [RELCryptor decryptText:recent[FRECENT_LASTMESSAGE] groupId:recent[FRECENT_GROUPID]];
	//---------------------------------------------------------------------------------------------------------------------------------------------
    NSString *strDate;
	NSDate *date = Number2Date(recent[FRECENT_UPDATEDAT]);

	NSTimeInterval seconds = [[NSDate date] timeIntervalSinceDate:date];
	labelElapsed.text = TimeElapsed(seconds);
    if (seconds < 24 * 60 * 60)
    {
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
       [dateFormatter setDateFormat:@"HH:mm"];
        strDate = [dateFormatter stringFromDate:date];
    }
    else
    {
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
       [dateFormatter setDateFormat:@"dd/MM HH:mm"];
       strDate =  [dateFormatter stringFromDate:date];
    }
    labelElapsed.text = strDate;
	//---------------------------------------------------------------------------------------------------------------------------------------------
    
    labelCounter.layer.cornerRadius = labelCounter.frame.size.width/2;
    labelCounter.layer.masksToBounds = YES;
	[SharedModel instance].msg_recent_counter = [recent[FRECENT_COUNTER] integerValue];
    if ([SharedModel instance].msg_recent_counter == 0) {
        [labelCounter setHidden:YES];
    }else{
        labelCounter.text = ([SharedModel instance].msg_recent_counter != 0) ? [NSString stringWithFormat:@"%d", (int)[SharedModel instance].msg_recent_counter] : nil;
    }
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)loadImage:(FObject *)recent TableView:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	imageUser.layer.cornerRadius = imageUser.frame.size.width/2;
	imageUser.layer.masksToBounds = YES;
    [imageUser  sd_setImageWithURL:[NSURL URLWithString:recent[FRECENT_PICTURE]] placeholderImage:[UIImage imageNamed:@"no_photo"]];

}


@end
