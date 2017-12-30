//
//  NPPLampObject.h
//  NetworkProgrammingProject
//
//  Created by Rex on 2017/12/24.
//  Copyright © 2017年 Rex. All rights reserved.
//

#import "HTWObject.h"

@interface NPPLampObject : HTWObject

/**
 燈具開關
 */
@property (nonatomic) BOOL check;

/**
 顏色
 */
@property (nonatomic) float color;

/**
 亮度
 */
@property (nonatomic) float intensity;

@end
