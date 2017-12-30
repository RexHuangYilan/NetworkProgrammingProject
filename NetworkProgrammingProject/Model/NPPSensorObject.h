//
//  NPPSensorObject.h
//  NetworkProgrammingProject
//
//  Created by Rex on 2017/12/24.
//  Copyright © 2017年 Rex. All rights reserved.
//

#import "HTWObject.h"

@interface NPPSensorObject : HTWObject

/**
 溫度
 */
@property (nonatomic) float temp;

/**
 時間
 */
@property (nonatomic, strong) NSDate *time;

@end
