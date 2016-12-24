//
//  UserModel.m
//  AllTattoo
//
//  Created by My Star on 7/7/16.
//  Copyright © 2016 AllTattoo. All rights reserved.
//

#import "UserModel.h"
@implementation UserModel
-(id)init
{
    self =[super init];
    return self;
}
+(UserModel*) instance
{
    static UserModel *instance =nil;
    if(instance ==nil){
        instance =[[UserModel alloc]init];
    }
    return instance;
}
@end
