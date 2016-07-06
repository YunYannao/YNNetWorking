//
//  YNNetAPI_Manager.h
//  YNNetWorking
//
//  Created by 员延孬 on 16/7/4.
//  Copyright © 2016年 KeviewYun. All rights reserved.


               /*该类提供了工程所需的所有API接口*/

#import <Foundation/Foundation.h>

//请求的结果以block的形式返回
typedef void(^CallBackBlock)(id data,NSError * error);

@interface YNNetAPI_Manager : NSObject
+(instancetype)shareManager;

#pragma mark---carList

-(void)getHomePageProductListWithStart:(NSString*)start withLength:(NSString*)length  withComplationBlock:(CallBackBlock)block;

@end
