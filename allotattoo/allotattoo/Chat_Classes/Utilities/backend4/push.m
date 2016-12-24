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

//-------------------------------------------------------------------------------------------------------------------------------------------------
void SendPushNotification1(FObject *message)
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	NSString *groupId = message[FMESSAGE_GROUPID];
	NSString *text = [RELCryptor decryptText:message[FMESSAGE_TEXT] groupId:groupId];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	FIRDatabaseReference *firebase = [[FIRDatabase database] referenceWithPath:FRECENT_PATH];
	FIRDatabaseQuery *query = [[firebase queryOrderedByChild:FRECENT_GROUPID] queryEqualToValue:groupId];
	[query observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot)
	{
		if (snapshot.value != [NSNull null])
		{
			NSMutableArray *members = [[NSMutableArray alloc] init];
			//-------------------------------------------------------------------------------------------------------------------------------------
			for (NSDictionary *dictionary in [snapshot.value allValues])
			{
				NSString *userId = dictionary[FRECENT_USERID];
				if ([userId isEqualToString:[FUser currentId]] == NO)
					[members addObject:userId];
			}
			//-------------------------------------------------------------------------------------------------------------------------------------
			SendPushNotification2(members, text);
		}
	}];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
void SendPushNotification2(NSArray *members, NSString *text)
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    if (members.count > 0) {
        [FireBaseApiService onGetRegistrationToken:members.firstObject withCompletion:^(TokenModel *tokenModel) {
            if (tokenModel != nil && tokenModel.regist_token != nil) {
                SendPushNotificationWithMessage(tokenModel.regist_token,text,members.firstObject);
            }
        }];
    }
}
#pragma mark send push message with Topic
void SendPushNotificationWithMessage(NSString *registToken, NSString *message, NSString *userID){
    //    NSMutableArray *arrTattooIDs = [NSMutableArray array];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSLog(@"%@",[dateFormatter stringFromDate:[NSDate date]]);
    NSString *time = [dateFormatter stringFromDate:[NSDate date]];
    NSDictionary *messageDic = @{FOLLOW_ID:[FIRAuth auth].currentUser.uid,
                                 @"Time":time,
                                 @"CommentText":message,
                                 @"NotificationStatus":[NSNumber numberWithInt:IS_MESSAGE_NOTIFICATION],
                                 @"ArrayTattoos":@""
                                 };
    [TattooUtilis sendPushNotificationWithFollowUserID:registToken withMessageContent:messageDic withUserName:[FIRAuth auth].currentUser.displayName];
  
}