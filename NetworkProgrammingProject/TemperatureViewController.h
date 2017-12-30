//
//  TemperatureViewController.h
//  NetworkProgrammingProject
//
//  Created by Rex on 2017/12/26.
//  Copyright © 2017年 Rex. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LightNetworkManager.h"

@interface TemperatureViewController : UIViewController

-(void)setSensors:(NSArray<NPPSensorObject *> *)sensors;

@end
