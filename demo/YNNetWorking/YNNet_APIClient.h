//
//  YNNet_APIClient.h
//  YNNetWorking
//
//  Created by 员延孬 on 16/7/4.
//  Copyright © 2016年 KeviewYun. All rights reserved

/*该类继承自AFHttpSessionManager*/

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void(^CallBackBlock)(id data,NSError * error);

//网络请求方式
typedef NS_ENUM(NSInteger,NetRequestType){
    Get=0,
    Post,
    Delete
};

@interface YNNet_APIClient : AFHTTPSessionManager

+(instancetype)shareClient;

-(id)handleResponse:(id)responseJSON autoShowError:(BOOL)autoShowError;

- (void)requestJsonDataWithPath:(NSString *)aPath
                     withParams:(NSDictionary*)params
                 withMethodType:(NetRequestType)type
                    shouldCache:(BOOL)shouldAutoCache
                       andBlock:(CallBackBlock)block;

- (void)requestJsonDataWithPath:(NSString *)aPath
                     withParams:(NSDictionary*)params
                 withMethodType:(NetRequestType)type
                  autoShowError:(BOOL)autoShowError
                    shouldCache:(BOOL)shouldAutoCache
                       andBlock:(CallBackBlock)block;
@end
