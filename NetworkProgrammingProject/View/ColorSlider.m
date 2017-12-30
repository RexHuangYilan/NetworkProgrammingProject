//
//  ColorSlider.m
//  NetworkProgrammingProject
//
//  Created by Rex on 2017/12/26.
//  Copyright © 2017年 Rex. All rights reserved.
//

#import "ColorSlider.h"

@interface ColorSlider ()

@property (nonatomic, strong) CAGradientLayer *bg;

@end

@implementation ColorSlider

-(void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    
    [self.bg removeFromSuperlayer];
    UIColor *color1 = self.startColor;
    UIColor *color2 = self.endColor;
    self.bg = [CAGradientLayer layer];
    self.bg.colors = @[(id)color1.CGColor,(id)color2.CGColor];
    self.bg.frame = bounds;
    self.bg.startPoint = CGPointMake(0, 0.5);
    self.bg.endPoint = CGPointMake(1.0, 0.5);
    [self.layer insertSublayer:self.bg atIndex:0];
}

-(UIColor *)color
{
    CGFloat sred = 0.0, sgreen = 0.0, sblue = 0.0, salpha = 0.0;
    if ([self.startColor respondsToSelector:@selector(getRed:green:blue:alpha:)]) {
        [self.startColor getRed:&sred green:&sgreen blue:&sblue alpha:&salpha];
    }
    CGFloat ered = 0.0, egreen = 0.0, eblue = 0.0, ealpha = 0.0;
    if ([self.endColor respondsToSelector:@selector(getRed:green:blue:alpha:)]) {
        [self.endColor getRed:&ered green:&egreen blue:&eblue alpha:&ealpha];
    }
    
    float scale = (self.maximumValue - self.value) / self.maximumValue;
    
    float red = fabs(sred - ered) * scale + MIN(sred, ered);
    float green = fabs(sgreen - egreen) * scale + MIN(sgreen, egreen);
    float blue = fabs(sblue - eblue) * scale + MIN(sblue, eblue);
    float alpha = fabs(salpha - ealpha) * scale + MIN(salpha, ealpha);
    
    UIColor *selectColor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    return selectColor;
}

@end
