//
//  ColorView.m
//  NetworkProgrammingProject
//
//  Created by Rex on 2017/12/28.
//  Copyright © 2017年 Rex. All rights reserved.
//

#import "ColorView.h"

@implementation ColorView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    [self inspectableDefaults];
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (!self) {
        return nil;
    }
    
    [self inspectableDefaults];
    
    return self;
}

- (void)inspectableDefaults
{
    _intensity = 0.001;
}

-(void)setEndColor:(UIColor *)endColor
{
    _endColor = endColor;
    self.backgroundColor = endColor;
}

-(void)setIntensity:(float)intensity
{
    if (intensity == 0) {
        intensity = 0.001;
    }else if (intensity > 1) {
        intensity = 1;
    }
    _intensity = intensity;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    //使用RGB顏色模型
    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    
    CGFloat sred = 0.0, sgreen = 0.0, sblue = 0.0, salpha = 0.0;
    if ([self.startColor respondsToSelector:@selector(getRed:green:blue:alpha:)]) {
        [self.startColor getRed:&sred green:&sgreen blue:&sblue alpha:&salpha];
    }
    CGFloat ered = 0.0, egreen = 0.0, eblue = 0.0, ealpha = 0.0;
    if ([self.endColor respondsToSelector:@selector(getRed:green:blue:alpha:)]) {
        [self.endColor getRed:&ered green:&egreen blue:&eblue alpha:&ealpha];
    }
    //漸層中所包含的關鍵顏色 RGBA
    CGFloat components[] = {sred, sgreen, sblue, salpha,
        ered, egreen, eblue, ealpha};
    
    //關鍵顏色所出現的位置
    CGFloat intensity = 1.0 - self.intensity;
    
    CGFloat locations[] = {1.0, intensity};
    
    //關鍵顏色的個數
    size_t count = 2;
    
    //製作漸層顏色模型
    CGGradientRef gradient = CGGradientCreateWithColorComponents(rgb, components, locations, count);
    CGColorSpaceRelease(rgb);
    
    //指定畫布
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGPoint center = CGPointMake(CGRectGetWidth(self.bounds) / 2.0, CGRectGetHeight(self.bounds) / 2.0);
    
    //繪製漸層線條並儲存畫布
    CGContextDrawRadialGradient(context, gradient, center, MIN(CGRectGetWidth(rect),CGRectGetHeight(rect)) , center, 0, 0);
    CGContextSaveGState(context);
}


@end
