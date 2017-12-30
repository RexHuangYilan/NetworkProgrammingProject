//
//  ColorSlider.h
//  NetworkProgrammingProject
//
//  Created by Rex on 2017/12/26.
//  Copyright © 2017年 Rex. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface ColorSlider : UISlider

@property (nonatomic ,strong) IBInspectable UIColor *startColor;

@property (nonatomic ,strong) IBInspectable UIColor *endColor;

-(UIColor *)color;

@end
