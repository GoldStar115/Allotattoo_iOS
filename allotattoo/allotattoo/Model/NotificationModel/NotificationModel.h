//
//  NotificationModel.h
//  allotattoo
//
//  Created by My Star on 8/6/16.
//  Copyright © 2016 My Star. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface NotificationModel : JSONModel
@property NSString<Optional> *strUserID;
@property NSString<Optional> *strTime;
@property NSString<Optional> *strCommentText;
@property NSNumber<Optional> *numStatus;
@property NSString<Optional> *arrTattooIDs;
//+(NotificationModel*) instance;
@end
