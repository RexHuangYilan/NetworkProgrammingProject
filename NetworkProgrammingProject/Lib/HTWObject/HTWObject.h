//
//  HTWObject.h
//  HTWObjectExmaple
//
//  Created by Rex on 2015/10/1.
//  Copyright (c) 2015年 Rex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTWObject : NSObject<NSCopying>

//建立物件陣列
+ (NSArray *)objectFromArray:(NSArray *)array;

//建立物件
+ (instancetype)objectFromDictionary:(NSDictionary *)dictionary;

//取得設定的SEL
+(SEL)getSetSelWithKey:(NSString *)key;

//初始化
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)convertToDictionary;

@end
