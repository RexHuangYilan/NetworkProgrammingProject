//
//  LightViewManager.h
//  NetworkProgrammingProject
//
//  Created by Rex on 2017/12/24.
//  Copyright © 2017年 Rex. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NPPLampObject.h"

/**
 亮燈 - 畫面管理
 */
@interface LightViewManager : NSObject

/**
 開關
 */
@property (readwrite) BOOL power;

/**
 顏色
 */
@property (readwrite) int color;

/**
 亮度
 */
@property (readwrite) int intensity;

/**
 讀取中
 */
@property (readwrite) BOOL loading;

/**
 錯誤訊息
 */
@property (readwrite) NSString *error;

/**
 更新畫面

 @param lamp 讀取得資料
 */
-(void)updateWithLamp:(NPPLampObject *)lamp;

-(void)setTemperature:(float)temperature;
@end
