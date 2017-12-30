//
//  HTWObject.m
//  HTWObjectExmaple
//
//  Created by Rex on 2015/10/1.
//  Copyright (c) 2015年 Rex. All rights reserved.
//

#import <objc/runtime.h>
#import <UIKit/UIKit.h>
#import "HTWObject.h"
#import "UIColor+HexColor.h"

/// 'Y'
static NSString *const STATE_YES_Y            = @"y";
/// 'Yes'
static NSString *const STATE_YES_YES          = @"yes";
/// 'true'
static NSString *const STATE_YES_ture         = @"true";
/// '1'
static NSString *const STATE_YES_1            = @"1";
/// 'checked'
static NSString *const STATE_YES_CHECKED      = @"checked";

typedef NS_ENUM(NSInteger, PropertyNumberType) {
    PropertyNumberTypeNotFound,
    PropertyNumberTypeID,
    PropertyNumberTypeInt,
    PropertyNumberTypeNSInteger,
    PropertyNumberTypeNSUInteger,
    PropertyNumberTypeFloat,
    PropertyNumberTypeDouble,
    PropertyNumberTypeChar,
    PropertyNumberTypeBool,
    PropertyNumberTypeSEL,
};

@interface HTWObject()
{
    NSDictionary *propertyKeys;
}
@end

@interface NSDate(HTWDate)
//取得時間ISO 8601
+ (NSDate *)dateISO8601WithDateStr:(NSString *)dateDtr;

@end

@implementation HTWObject

#pragma mark - class method


+ (NSArray *)objectFromArray:(NSArray *)array
{
    NSMutableArray *newArray = [[NSMutableArray alloc] init];
    for (id item in array) {
        if ([item isKindOfClass:[NSDictionary class]]) {
            [newArray addObject:[self objectFromDictionary:item]];
        }
    }
    if (newArray.count > 0) {
        return newArray;
    }else{
        return array;
    }
}

+ (instancetype)objectFromDictionary:(NSDictionary *)dictionary
{
    if (!dictionary) return nil;
    
    return [[self alloc] initWithDictionary:dictionary];
}

+(SEL)getSetSelWithKey:(NSString *)key
{
    NSString *capitalizedKey = [[[key substringToIndex:1] uppercaseString] stringByAppendingString:[key substringFromIndex:1]];
    NSString *setterName = [NSString stringWithFormat: @"set%@:", capitalizedKey];
    SEL setterSEL = NSSelectorFromString(setterName);
    return setterSEL;
}

#pragma mark - 初始化


- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [self init];
    if (self && dictionary)
    {
        [self setValuesForKeysWithDictionary:dictionary];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        propertyKeys = [self getAllProperty];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    NSDictionary *dict = [self convertToDictionary];
    id obj = [[[self class] allocWithZone:zone] initWithDictionary:dict];
    return obj;
}

#pragma mark - 取得相關


//取得所有的Property
-(NSDictionary *)getAllProperty
{
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
    Class subclass = [self class];
    while (subclass != [NSObject class])
    {
        unsigned int outCount, i;
        objc_property_t *properties = class_copyPropertyList(subclass, &outCount);
        for (i = 0; i < outCount; i++) {
            objc_property_t property = properties[i];
            NSString *propertyName = [NSString stringWithUTF8String:property_getName(property)];
            [tempDict setObject:propertyName forKey:[propertyName lowercaseString]];
        }
        free(properties);
        subclass = [subclass superclass];
    }
    
    
    return tempDict;
}

//取得propertyAttributes
-(NSString *)getPropertyAttributesWithPropertyName:(NSString *)propertyName
{
    objc_property_t property = class_getProperty([self class], [propertyName UTF8String]);
    if (property) {
        NSString* propertyAttributes = [NSString stringWithUTF8String:property_getAttributes(property)];
        return propertyAttributes;
    }
    free(property);
    return nil;
}

//取得propertyClass
-(Class)getPropertyTypeWithAttributes:(NSString *)propertyAttributes
{
    if (propertyAttributes) {
        NSArray* splitPropertyAttributes = [propertyAttributes componentsSeparatedByString:@"\""];
        if ([splitPropertyAttributes count] >= 2)
        {
            return NSClassFromString([splitPropertyAttributes objectAtIndex:1]);
        }
    }
    return nil;
}

//取得PropertyNumberType
-(PropertyNumberType)getPropertyNumberTypeWithAttributes:(NSString *)propertyAttributes
{
    PropertyNumberType propertyNumberType = PropertyNumberTypeNotFound;
    if (propertyAttributes) {
        NSArray* splitPropertyAttributes = [propertyAttributes componentsSeparatedByString:@","];
        if ([splitPropertyAttributes count] > 1)
        {
            NSString *propertyString = [splitPropertyAttributes objectAtIndex:0];
            NSString * propertyType = [propertyString substringFromIndex:1];
            const char * rawPropertyType = [propertyType UTF8String];
            
            if (strcmp(rawPropertyType, @encode(int)) == 0) {
                propertyNumberType = PropertyNumberTypeInt;
            }else if (strcmp(rawPropertyType, @encode(NSInteger)) == 0) {
                propertyNumberType = PropertyNumberTypeNSInteger;
            }else if (strcmp(rawPropertyType, @encode(NSUInteger)) == 0) {
                propertyNumberType = PropertyNumberTypeNSUInteger;
            }else if (strcmp(rawPropertyType, @encode(id)) == 0) {
                propertyNumberType = PropertyNumberTypeID;
            }else if (strcmp(rawPropertyType, @encode(float)) == 0) {
                propertyNumberType = PropertyNumberTypeFloat;
            }else if (strcmp(rawPropertyType, @encode(double)) == 0) {
                propertyNumberType = PropertyNumberTypeDouble;
            }else if (strcmp(rawPropertyType, @encode(BOOL)) == 0) { //32bit 的BOOL會跟char一樣，所以若在32bit時有用char會出問題 by rex
                propertyNumberType = PropertyNumberTypeBool;
            }else if (strcmp(rawPropertyType, @encode(char)) == 0) {
                propertyNumberType = PropertyNumberTypeChar;
            }else if (strcmp(rawPropertyType, @encode(SEL)) == 0) {
                propertyNumberType = PropertyNumberTypeSEL;
            }
        }
    }
    return propertyNumberType;
}

//依傳入參數取得Property內容
-(id)getNumberWithValue:(id)value forPropertyNumberType:(PropertyNumberType)propertyNumberType
{
    if ([value isKindOfClass:[NSString class]]) {
        NSString *string = value;
        switch (propertyNumberType) {
            case PropertyNumberTypeInt:
            {
                value = @([string intValue]);
            }
                break;
            case PropertyNumberTypeNSInteger:
            case PropertyNumberTypeNSUInteger:
            {
                value = @([string integerValue]);
            }
                break;
            case PropertyNumberTypeFloat:
            {
                value = @([string floatValue]);
            }
                break;
            case PropertyNumberTypeDouble:
            {
                value = @([string doubleValue]);
            }
                break;
            case PropertyNumberTypeChar:
            {
                value = @([string UTF8String]);
            }
                break;
            case PropertyNumberTypeBool:
            {
                value = @([self isTrueValue:string]);
            }
                break;
            case PropertyNumberTypeSEL:
            {
                SEL selector = NSSelectorFromString(string);
                value = [NSValue value:&selector withObjCType:@encode(SEL)];
            }
                break;
            default:
                break;
        }
    }
    return value;
}

//取得正確的內容
-(id)getRightValue:(id)value forKey:(NSString *)key
{
    NSString *propertyName = [propertyKeys objectForKey:[key lowercaseString]];
    if (propertyName) {
        NSString *propertyAttributes = [self getPropertyAttributesWithPropertyName:propertyName];
        Class propertyType = [self getPropertyTypeWithAttributes:propertyAttributes];
        if (propertyType) {
            if (![value isKindOfClass:propertyType]) {
                if (propertyType == [NSNumber class]) {
                    if ([value isKindOfClass:[NSString class]]) {
                        value = [NSNumber numberWithInteger:[value integerValue]];
                    }
                }else if ([propertyType isSubclassOfClass:[HTWObject class]]){
                    if ([value isKindOfClass:[NSDictionary class]]) {
                        value = [[propertyType alloc] initWithDictionary:value];
                    }
                }else if (propertyType == [UIColor class]){
                    if ([value isKindOfClass:[NSString class]]) {
                        value = [UIColor colorForHex:value];
                    }
                }else if (propertyType == [NSDate class]){
                    if ([value isKindOfClass:[NSString class]]) {
                        NSDate *date = [NSDate dateISO8601WithDateStr:value];
                        if (date) {
                            value = date;
                        }
                    }else if ([value isKindOfClass:[NSNumber class]]) {
                        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[value integerValue]];
                        if (date) {
                            value = date;
                        }
                    }
                }else if (propertyType == [NSString class]){
                    if ([value isKindOfClass:[NSNumber class]]) {
                        value = [(NSNumber *)value stringValue];
                    }
                }
            }
        }else{
            PropertyNumberType propertyNumberType = [self getPropertyNumberTypeWithAttributes:propertyAttributes];
            value = [self getNumberWithValue:value forPropertyNumberType:propertyNumberType];
        }
    }
    return value;
}

#pragma mark - 設定相關


//設定內容
-(void)setValue:(id)value forKey:(NSString *)key
{
    NSString *propertyName = [propertyKeys objectForKey:[key lowercaseString]];
    value = [self getRightValue:value forKey:key];
    if (propertyName) {
        key = propertyName;
    }
    if (value) {
        if ([value isKindOfClass:NSValue.class]) {
            NSValue *temp = value;
            if (strcmp(temp.objCType, @encode(SEL)) == 0)
            {
                SEL setterSEL = [[self class] getSetSelWithKey:key];
                if ([self respondsToSelector: setterSEL]) {
                    IMP imp = [self methodForSelector: setterSEL];
                    SEL toSet;
                    [temp getValue:&toSet];
                    ((void (*)(id, SEL, SEL))imp)(self, setterSEL, toSet);
                    return;
                }
            }
        }
        [super setValue:value forKey:key];
    }
}

//當沒有property時呼叫，value為NSDictionary時會再轉物件一次
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"%@ no Property: %@",self,key);
    
    if ([value isKindOfClass:[NSDictionary class]]) {
//        [self setValuesForKeysWithDictionary:value];
    }
}

-(NSArray *)convertToArray:(NSArray *)array
{
    NSMutableArray *temparray = [NSMutableArray array];
    for (id object in array) {
        id value = object;
        if ([object isKindOfClass:[HTWObject class]]) {
            value = [(HTWObject *)object convertToDictionary];
        }
        [temparray addObject:value];
    }
    return temparray;
}

-(NSDictionary *)convertToDictionary
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    for (NSString *propertyName in [propertyKeys allValues]) {
        id value = [self valueForKey:propertyName];
        NSString *propertyAttributes = [self getPropertyAttributesWithPropertyName:propertyName];
        Class propertyType = [self getPropertyTypeWithAttributes:propertyAttributes];
        if (propertyType) {
            if (propertyType == [HTWObject class]) {
                value = [(HTWObject *)value convertToDictionary];
            }else if (propertyType == [NSArray class]){
                value = [self convertToArray:value];
            }
        }else{
            PropertyNumberType propertyNumberType = [self getPropertyNumberTypeWithAttributes:propertyAttributes];
            value = [self getNumberWithValue:value forPropertyNumberType:propertyNumberType];
        }
        
        if (value) {
            [dict setObject:value forKey:propertyName];
        }
    }
    [dict removeObjectForKey:@"debugDescription"];
    [dict removeObjectForKey:@"description"];
    [dict removeObjectForKey:@"hash"];
    [dict removeObjectForKey:@"superclass"];
    return dict;
}

#pragma mark - 檢查相關

//取得bool
- (BOOL)isTrueValue:(NSString *)trueString
{
    NSString *capitalString = [trueString lowercaseString];
    return [capitalString isEqualToString:STATE_YES_Y] ||
    [capitalString isEqualToString:STATE_YES_YES] ||
    [capitalString isEqualToString:STATE_YES_ture] ||
    [capitalString isEqualToString:STATE_YES_1] ||
    [capitalString isEqualToString:STATE_YES_CHECKED];
}
@end

@implementation NSDate(HTWDate)

+(NSDateFormatter *)taipeiFormat
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    //強迫設為台北時間
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Taipei"]];
    return formatter;
}

+(NSDateFormatter *)usFormat
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    return formatter;
}

//取得時間ISO 8601
+ (NSDate *)dateISO8601WithDateStr:(NSString *)dateDtr
{
    NSDateFormatter *formatter = [self taipeiFormat];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSDate *date = [formatter dateFromString:dateDtr];
    
    if (!date) {
        formatter = [self usFormat];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
        date = [formatter dateFromString:dateDtr];
    }
    
    return date;
}

@end
