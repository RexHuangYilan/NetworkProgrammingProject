//
//  LightNetworkManager.h
//  NetworkProgrammingProject
//
//  Created by Rex on 2017/12/24.
//  Copyright © 2017年 Rex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NPPLampObject.h"
#import "NPPSensorObject.h"

@protocol LightNetworkManagerDelegate <NSObject>

-(void)setLoading:(BOOL)loading;

@end


/**
 亮燈 - 網路管理
 */
@interface LightNetworkManager : NSObject

@property (nonatomic, weak) id<LightNetworkManagerDelegate> _Nullable delegate;

/**
 讀取資料

 @param block 成功回傳lamp
 @param cancelBlock 失敗回傳Error
 */
-(void)loadDataWithBlock:(void (^_Nullable)(NPPLampObject * _Nonnull lamp))block
         withCancelBlock:(nullable void (^)(NSError* _Nonnull error))cancelBlock;

/**
 改變開關

 @param check 開/關
 */
-(void)setCheck:(BOOL)check;

/**
 改變顏色

 @param color 顏色
 */
-(void)setColor:(float)color;

/**
 改變亮度

 @param intensity 亮度
 */
-(void)setIntensity:(float)intensity;

/**
 取得Sensor資料

 @param block 成功回傳Array
 @param cancelBlock 失敗回傳Error
 */
-(void)loadSensorDataWithBlock:(void (^_Nullable)(NSArray<NPPSensorObject *> * _Nonnull sensors))block
               withCancelBlock:(void (^_Nullable)(NSError * _Nonnull error))cancelBlock;
@end
