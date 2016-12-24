//
//  NotificationModel.m
//  allotattoo
//
//  Created by My Star on 8/6/16.
//  Copyright © 2016 My Star. All rights reserved.
//

#import "NotificationModel.h"

@implementation NotificationModel
-(id)init
{
    self =[super init];
    self.numStatus = [[NSNumber alloc] init];
    self.arrTattooIDs = @"";
    self.strCommentText = @"";
    self.strTime = @"";
    self.strUserID = @"";
    return self;
}
//+(NotificationModel*) instance
//{
//    static NotificationModel *instance =nil;
//    if(instance ==nil){
//        instance =[[NotificationModel alloc]init];
//    }
//    return instance;
//}

@end
