//
//  UIImage+Color.m
//  NetworkProgrammingProject
//
//  Created by Rex on 2017/12/26.
//  Copyright © 2017年 Rex. All rights reserved.
//

#import "UIImage+Color.h"

@implementation UIImage (Color)

-(UIImage *)replaceColor:(UIColor *)color
{
    UIImage *newImage = [self imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIGraphicsBeginImageContextWithOptions(self.size, NO, newImage.scale);
    [color set];
    [newImage drawInRect:CGRectMake(0, 0, self.size.width, newImage.size.height)];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+(UIImage *)imageWithStartColor:(UIColor *)sColor endColor:(UIColor *)eColor size:(CGSize)size
{
    //使用RGB顏色模型
    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    
    //漸層中所包含的關鍵顏色 RGBA
    CGFloat components[] = {1.0, 0.0, 0.0, 1.0, //紅色 不透明
        0.0, 0.0, 1.0, 1.0 //藍色 不透明
        };//紅色 不透明
    
    //關鍵顏色所出現的位置
    CGFloat locations[] = {0.0, 1.0};
    
    //關鍵顏色的個數
    size_t count = 2;
    
    //製作漸層顏色模型
    CGGradientRef gradient = CGGradientCreateWithColorComponents(rgb, components, locations, count);
    CGColorSpaceRelease(rgb);
    
    
    UIImage *image;
    //開始繪圖
    UIGraphicsBeginImageContext(size);
    
    //指定畫布
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //繪製漸層線條並儲存畫布
//    CGContextDrawLinearGradient(context, gradient, CGPointMake(0.0, 0.0), CGPointMake(300.0, 0.0), 0);
    CGContextDrawRadialGradient(context, gradient, CGPointMake(150, 150), 120, CGPointMake(150, 150), 0, 0);
    CGContextSaveGState(context);
    
    //將畫布指定給ImageView
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    //結束繪圖
    UIGraphicsEndImageContext();
    
    return image;
}

@end
