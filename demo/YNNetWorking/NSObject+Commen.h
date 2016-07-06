//
//  NSObject+Commen.h
//  YNNetWorking
//
//  Created by 员延孬 on 16/7/4.
//  Copyright © 2016年 KeviewYun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Commen)

//返回一个NSDictionary类型的json数据
//+ (id)loadResponseWithPath:(NSString *)requestPath;


+ (void)showHudTipStr:(NSString *)tipStr;

//读取缓存在本地的数据
+ (id)loadResponseWithPath:(NSString *)requestPath;

//缓存请求回来的json对象
+ (BOOL)saveResponseData:(NSDictionary *)data toPath:(NSString *)requestPath;
//创建缓存文件夹
+ (BOOL)createDirInCache:(NSString *)dirName;
//获取fileName的完整地址
+ (NSString* )pathInCacheDirectory:(NSString *)fileName;

//根据路径删除本地缓存文件夹的一个文件
+ (BOOL)deleteResponseCacheForPath:(NSString *)requestPath;
//删除本地缓存文件夹的所有文件
+ (BOOL)deleteResponseCache;


@end
