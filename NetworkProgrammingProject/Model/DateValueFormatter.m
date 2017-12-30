//
//  DateValueFormatter.m
//  NetworkProgrammingProject
//
//  Created by Rex on 2017/12/24.
//  Copyright © 2017年 Rex. All rights reserved.
//

#import "DateValueFormatter.h"

@interface DateValueFormatter ()

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation DateValueFormatter

- (id)init
{
    self = [super init];
    if (self)
    {
        self.dateFormatter = [[NSDateFormatter alloc] init];
        self.dateFormatter.dateFormat = @"MM/dd h:m";
    }
    return self;
}

- (NSString *)stringForValue:(double)value axis:(ChartAxisBase *)axis
{
    return [self.dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:value]];
}

@end
