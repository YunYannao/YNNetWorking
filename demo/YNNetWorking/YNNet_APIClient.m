//
//  YNNet_APIClient.m
//  YNNetWorking
//
//  Created by 员延孬 on 16/7/4.
//  Copyright © 2016年 KeviewYun. All rights reserved.
//

#import "YNNet_APIClient.h"
#import "NSObject+Commen.h"

#define DebugLog(s, ...) NSLog(@"%s(%d): %@", __FUNCTION__, __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__])
#define Base_Url @"http://175.102.15.84:8011"


@implementation YNNet_APIClient


+(instancetype)shareClient{
    static YNNet_APIClient * client=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        client=[[self alloc]initWithBaseURL:[NSURL URLWithString:Base_Url]];
    });
    return client;
}


-(NSError*)handleResponse:(id)responseJSON autoShowError:(BOOL)autoShowError{
    NSError *error = nil;
    //code为非10000时，表示有错
    NSNumber *resultCode = [[responseJSON valueForKeyPath:@"Head"] objectForKey:@"ErrorCode"];
    if ([resultCode intValue]!=10000) {
        error = [NSError errorWithDomain:Base_Url code:resultCode.intValue userInfo:responseJSON];
        if (autoShowError) {
            [NSObject showHudTipStr:[[responseJSON valueForKeyPath:@"Head"] objectForKey:@"Msg"]];
        }
    }
    return error;
}
/*重写父类方法 父类的方法中拼接了基URL和不同的API路径，并且能规定了请求序列和相应序列
  重写的目的在于设置更多的属性，比如超时时间、缓存要求、声明可接收的文本类型、请求类型、设置header信息等*/
-(id)initWithBaseURL:(NSURL *)url{
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    self.requestSerializer.cachePolicy=NSURLRequestReloadIgnoringLocalCacheData;
    
    AFJSONResponseSerializer * res = [AFJSONResponseSerializer serializer];
    res.removesKeysWithNullValues=YES;
    self.responseSerializer=res;
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
    
    self.requestSerializer.timeoutInterval=6;
    
    [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [self.requestSerializer setValue:url.absoluteString forHTTPHeaderField:@"Referer"];
    
    self.securityPolicy.allowInvalidCertificates = YES;
    
    return self;
}



- (void)requestJsonDataWithPath:(NSString *)aPath
                     withParams:(NSDictionary*)params
                 withMethodType:(NetRequestType)type
                    shouldCache:(BOOL)shouldAutoCache
                       andBlock:(CallBackBlock)block{
    [self requestJsonDataWithPath:aPath withParams:params withMethodType:type autoShowError:YES shouldCache:shouldAutoCache andBlock:block];
}


- (void)requestJsonDataWithPath:(NSString *)aPath
                     withParams:(NSDictionary*)params
                 withMethodType:(NetRequestType)type
                  autoShowError:(BOOL)autoShowError
                    shouldCache:(BOOL)shouldAutoCache
                       andBlock:(CallBackBlock)block{
    //请求的路径错误、直接退出
    if (!aPath || aPath.length <= 0) {
        return;
    }
    //获取本地缓存的路径
    NSMutableString * localPath=[aPath mutableCopy];
    if (params) {
        [localPath appendString:[[params objectForKey:@"Head"] objectForKey:@"UserToken"]];
    }
    //根据请求的方式，设置不同的请求策略
    switch (type) {
        case Get:{
            [self GET:aPath parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                DebugLog(@"\n===========response===========\n%@:\n%@", aPath, responseObject);
                NSError *  error=[self handleResponse:responseObject autoShowError:autoShowError];
                if (error) {
                    //get请求失败 从缓存中读取数据
                    [NSObject showHudTipStr:error.localizedDescription];
                    responseObject=[NSObject loadResponseWithPath:localPath];
                    block(responseObject,error);
                    DebugLog(@"\n===========response===========\n%@:\n%@:\n%@", responseObject, aPath,error);
                }
                else{
                    //请求成功 根据情况缓存
                    if(shouldAutoCache){
                        if([NSObject saveResponseData:responseObject toPath:localPath]){
                            DebugLog(@"缓存成功");
                        }
                    }
                    block(responseObject,nil);
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                DebugLog(@"\n===========response===========\n%@:\n%@", aPath, error);
                [NSObject showHudTipStr:error.localizedDescription];
                id responseObject = [NSObject loadResponseWithPath:localPath];
                block(responseObject, error);
            }];
            break;
        }
        case Post:{
            [self POST:aPath parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
                DebugLog(@"__%f",[uploadProgress fractionCompleted]);
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                DebugLog(@"\n===========response===========\n%@:\n%@", aPath, responseObject);
                NSError * error = [self handleResponse:responseObject autoShowError:autoShowError];
                if (error) {
                    [NSObject showHudTipStr:error.localizedDescription];
                    responseObject=[NSObject loadResponseWithPath:localPath];
                    block(responseObject,error);
                    DebugLog(@"\n===========response===========\n%@:\n%@:\n%@", responseObject, aPath,error);
                }
                else{
                    if(shouldAutoCache){
                        if ([NSObject saveResponseData:responseObject toPath:localPath]){
                            DebugLog(@"缓存成功");
                        }
                    }
                }
                block(responseObject, nil);
            }
            failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [NSObject showHudTipStr:error.localizedDescription];
                id responseObject = [NSObject loadResponseWithPath:localPath];
                block(responseObject, error);
                DebugLog(@"\n===========response===========\n%@:\n%@:\n%@", aPath, error,responseObject);
            }];
            break;
        }
        case Delete:{
            [self DELETE:aPath parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSError * error = [self handleResponse:responseObject autoShowError:autoShowError];
                if (error) {
                    block(nil, error);
                }else{
                    DebugLog(@"\n===========response===========\n%@:\n%@", aPath, responseObject);
                    if(shouldAutoCache){
                        [NSObject saveResponseData:responseObject toPath:localPath];
                        DebugLog(@"缓存成功");
                    }
                    block(responseObject, nil);
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                DebugLog(@"\n===========response===========\n%@:\n%@", aPath, error);
                [NSObject showHudTipStr:error.localizedDescription];
                block(nil, error);
            }];
        }
        default:
            break;
    }

}
@end
