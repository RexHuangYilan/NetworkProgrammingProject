//
//  ColorView.h
//  NetworkProgrammingProject
//
//  Created by Rex on 2017/12/28.
//  Copyright © 2017年 Rex. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface ColorView : UIView

@property (nonatomic ,strong) IBInspectable UIColor *startColor;

@property (nonatomic ,strong) IBInspectable UIColor *endColor;

/**
 intensity 0 .. 1
 */
@property (nonatomic) IBInspectable float intensity;

@end
