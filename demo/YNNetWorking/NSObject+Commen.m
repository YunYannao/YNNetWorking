//
//  NSObject+Commen.m
//  YNNetWorking
//
//  Created by 员延孬 on 16/7/4.
//  Copyright © 2016年 KeviewYun. All rights reserved.
//

#import "NSObject+Commen.h"
#import "MBProgressHUD.h"
#import "NSString+Commen.h"

#define kPath_ResponseCache @"ResponseCache"

@implementation NSObject (Commen)
+ (void)showHudTipStr:(NSString *)tipStr{
    if (tipStr && tipStr.length > 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].delegate.window animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabel.font = [UIFont boldSystemFontOfSize:15.0];
        hud.detailsLabel.text = tipStr;
        hud.margin = 10.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hideAnimated:YES afterDelay:1.5];
    }
}
//读取缓存在本地的数据
+ (id)loadResponseWithPath:(NSString *)requestPath{
    NSString *abslutePath = [NSString stringWithFormat:@"%@/%@.plist", [self pathInCacheDirectory:kPath_ResponseCache], [requestPath md5Str]];
    NSFileManager * fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:abslutePath]) {
        return [NSMutableDictionary dictionaryWithContentsOfFile:abslutePath];
    }
    return nil;
}
/*缓存网络请求数据*/
+ (BOOL)saveResponseData:(NSDictionary *)data toPath:(NSString *)requestPath{
    //如果用户已登录可以根据用户token来MD5加密一个不同的path
    if ([self createDirInCache:kPath_ResponseCache]) {
        NSString *abslutePath = [NSString stringWithFormat:@"%@/%@.plist", [self pathInCacheDirectory:kPath_ResponseCache], [requestPath md5Str]];
        BOOL isCache= [[data objectForKey:@"Body"] writeToFile:abslutePath atomically:YES];
        return isCache;
    }else{
        return NO;
    }
}

//获取沙盒里缓存文件夹完整地址
+ (NSString* )pathInCacheDirectory:(NSString *)fileName{
    NSArray *cachePaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [cachePaths objectAtIndex:0];
    return [cachePath stringByAppendingPathComponent:fileName];
}

//创建缓存文件夹
+ (BOOL) createDirInCache:(NSString *)dirName{
    NSString *dirPath = [self pathInCacheDirectory:dirName];
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:dirPath isDirectory:&isDir];
    BOOL isCreated = NO;
    if ( !(isDir == YES && existed == YES) ){
        isCreated = [fileManager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if (existed) {
        isCreated = YES;
    }
    return isCreated;
}

//删除缓存文件夹的某一个文件
+ (BOOL)deleteResponseCacheForPath:(NSString *)requestPath{
    NSString *abslutePath = [NSString stringWithFormat:@"%@/%@.plist", [self pathInCacheDirectory:kPath_ResponseCache], [requestPath md5Str]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:abslutePath]) {
        return [fileManager removeItemAtPath:abslutePath error:nil];
    }else{
        return NO;
    }
}

//删除本地缓存文件夹的所有文件
+ (BOOL) deleteResponseCache{
    return [self deleteCacheWithPath:kPath_ResponseCache];
}

+ (BOOL) deleteCacheWithPath:(NSString *)cachePath{
    NSString *dirPath = [self pathInCacheDirectory:cachePath];
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:dirPath isDirectory:&isDir];
    bool isDeleted = false;
    if ( isDir == YES && existed == YES )
    {
        isDeleted = [fileManager removeItemAtPath:dirPath error:nil];
    }
    return isDeleted;
}

@end
