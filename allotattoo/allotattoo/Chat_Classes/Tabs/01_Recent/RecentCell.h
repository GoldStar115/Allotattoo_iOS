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
#import <UIKit/UIKit.h>
#import "Constant.h"
#import <SDWebImage/UIImageView+WebCache.h>

//-------------------------------------------------------------------------------------------------------------------------------------------------
@interface RecentCell : UITableViewCell
//-------------------------------------------------------------------------------------------------------------------------------------------------

- (void)bindData:(FObject *)recent;

- (void)loadImage:(FObject *)recent TableView:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath;

@end
