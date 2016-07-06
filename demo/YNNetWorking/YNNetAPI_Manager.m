//
//  YNNetAPI_Manager.m
//  YNNetWorking
//
//  Created by 员延孬 on 16/7/4.
//  Copyright © 2016年 KeviewYun. All rights reserved.
//

#import "YNNetAPI_Manager.h"
#import "YNNet_APIClient.h"

//http请求head信息
#define ClientVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] //appStore版本号
#define ClientType @"3"//1:Android   2:Android Pad    3:iPhone    4:iPad
#define ClientSID [[UIDevice currentDevice].identifierForVendor UUIDString]//设备的唯一标示符Vendor

@implementation YNNetAPI_Manager

+(instancetype)shareManager{
    static YNNetAPI_Manager * manager=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager=[[self alloc]init];
    });
    return manager;
}

#pragma mark---请求参数拼接
-(NSDictionary*)setParamsWithParamsBody:(NSDictionary *)paramaterBodyDic
{
    NSDictionary * params  =
    @{
      @"Head":
          @{
              @"ClientType":ClientType,
              @"ClientSID":ClientSID,
              @"ClientVersion":ClientVersion,
              @"UserPid":@"",
              @"UserToken":@""
              },
      @"Body":paramaterBodyDic
      };
    return params;
}

-(void)getHomePageProductListWithStart:(NSString*)start withLength:(NSString*)length  withComplationBlock:(CallBackBlock)block{
    [[YNNet_APIClient shareClient] requestJsonDataWithPath:@"/api/product/IndexProList" withParams:[self setParamsWithParamsBody:@{@"Start":start, @"Length":length}] withMethodType:Post shouldCache:YES andBlock:^(id data, NSError *error) {
        if (data) {
            block(data,nil);
        }
        else{
            block(nil,error);
        }
    }];
}
@end
