//
//  TattoistModel.m
//  allotattoo
//
//  Created by My Star on 7/13/16.
//  Copyright © 2016 My Star. All rights reserved.
//

#import "TattoistModel.h"

@implementation TattoistModel
-(id)init
{
    self =[super init];
    return self;
}
+(TattoistModel*) instance
{
    static TattoistModel *instance =nil;
    if(instance ==nil){
        instance =[[TattoistModel alloc]init];
    }
    return instance;
}

@end
