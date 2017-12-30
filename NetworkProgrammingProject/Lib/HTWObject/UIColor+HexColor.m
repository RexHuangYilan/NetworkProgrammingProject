//
//  UIColor+HexColor.m
//  ETMall
//
//  Created by Sean on 2015/8/12.
//  Copyright (c) 2015年 Hyxen. All rights reserved.
//

#import "UIColor+HexColor.h"

@implementation UIColor (HexColor)

+ (UIColor *)Color838383
{
    return [self colorForHex:@"838383"];
}

+ (UIColor *)ColorB3B3B3
{
    return [self colorForHex:@"B3B3B3"];
}

+ (UIColor *)ColorCB2530
{
    return [self colorForHex:@"CB2530"];
}

+ (UIColor *)Color970F0F
{
    return [self colorForHex:@"970F0F"];
}

+ (UIColor *)ColorCFCFD1
{
    return [self colorForHex:@"CFCFD1"];
}

+ (UIColor *)ColorF3F3F3
{
    return [self colorForHex:@"F3F3F3"];
}

+ (UIColor *)ColorF4F4F4
{
    return [self colorForHex:@"F4F4F4"];
}

+ (UIColor *)ColorCC0000
{
    return [self colorForHex:@"CC0000"];
}

+ (UIColor *)Color666666
{
    return [self colorForHex:@"666666"];
}

+ (UIColor *)Color999999
{
    return [self colorForHex:@"999999"];
}

+ (UIColor *)ColorAAAAAA
{
    return [self colorForHex:@"AAAAAA"];
}

+ (UIColor *)Color333333
{
    return [self colorForHex:@"333333"];
}

+ (UIColor *)ColorDEDEDE
{
    return [self colorForHex:@"DEDEDE"];
}

+ (UIColor *)ColorCCCCCC
{
    return [self colorForHex:@"CCCCCC"];
}

+ (UIColor *)ColorD91226
{
    return [self colorForHex:@"D91226"];
}

+ (UIColor *)ColorECECEC
{
    return [self colorForHex:@"ECECEC"];
}

+ (UIColor *)ColorFF6600
{
    return [self colorForHex:@"FF6600"];
}

+ (UIColor *)ColorCACACA
{
    return [self colorForHex:@"CACACA"];
}

+ (UIColor *)ColorE8E8E8
{
    return [self colorForHex:@"E8E8E8"];
}

+ (UIColor *)ColorCC1E05
{
    return [self colorForHex:@"cc1e05"];
}

+ (UIColor *)ColorFFECE9
{
    return [self colorForHex:@"FFECE9"];
}

+ (UIColor *)ColorA6A6A6
{
    return [self colorForHex:@"a6a6a6"];
}

+ (UIColor *)ColorF5F5F5
{
    return [self colorForHex:@"f5f5f5"];
}

+ (UIColor *)ColorE1E1E1
{
    return [self colorForHex:@"e1e1e1"];
}

+ (UIColor *)ColorBDBDBD
{
    return [self colorForHex:@"bdbdbd"];
}

+ (UIColor *)Color5D5D5D
{
    return [self colorForHex:@"5d5d5d"];
}

+ (UIColor *)ColorFF0000
{
    return [self colorForHex:@"ff0000"];
}

+ (UIColor *)Color525252
{
    return [self colorForHex:@"525252"];
}

+ (UIColor *)ColorF7F7F7
{
    return [self colorForHex:@"f7f7f7"];
}

+ (UIColor *)colorForHex:(NSString *)hexColor alpha:(CGFloat)alpha{
    hexColor = [[hexColor stringByTrimmingCharactersInSet:
                 [NSCharacterSet whitespaceAndNewlineCharacterSet]
                 ] uppercaseString];
    
    // String should be 6 or 7 characters if it includes '#'
    if ([hexColor length] < 6)
        return [UIColor blackColor];
    
    // strip # if it appears
    if ([hexColor hasPrefix:@"#"])
        hexColor = [hexColor substringFromIndex:1];
    
    // if the value isn't 6 characters at this point return
    // the color black
    if ([hexColor length] != 6)
        return [UIColor blackColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    NSString *rString = [hexColor substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [hexColor substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [hexColor substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    CGFloat setAlpha = 1.0f;
    if (alpha > 1.0f) {
        setAlpha = 1.0f;
    } else if (alpha < 0.0f){
        setAlpha = 0.0f;
    } else {
        setAlpha = alpha;
    }
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:setAlpha];
}

+ (UIColor *)colorForHex:(NSString *)hexColor{
   return [self colorForHex:hexColor alpha:1.0f];
}

@end
