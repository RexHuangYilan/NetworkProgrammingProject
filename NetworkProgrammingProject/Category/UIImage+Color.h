//
//  UIImage+Color.h
//  NetworkProgrammingProject
//
//  Created by Rex on 2017/12/26.
//  Copyright © 2017年 Rex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Color)

-(UIImage *)replaceColor:(UIColor *)color;

+(UIImage *)imageWithStartColor:(UIColor *)sColor endColor:(UIColor *)eColor size:(CGSize)size;

@end
