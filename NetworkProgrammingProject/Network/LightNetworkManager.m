//
//  LightNetworkManager.m
//  NetworkProgrammingProject
//
//  Created by Rex on 2017/12/24.
//  Copyright © 2017年 Rex. All rights reserved.
//

#import "LightNetworkManager.h"
#import <FirebaseDatabase/FirebaseDatabase.h>


@interface LightNetworkManager()

@property (nonatomic, strong) FIRDatabaseReference *ref;
@property (readonly) FIRDatabaseReference *refLamp;

@end

@implementation LightNetworkManager

#pragma mark - set

-(void)setLoading:(BOOL)loading
{
    if ([self.delegate respondsToSelector:@selector(setLoading:)]) {
        [self.delegate setLoading:loading];
    }
}

#pragma mark - get

-(FIRDatabaseReference *)refSensor
{
    return [[self.ref child:@"sensor"] child:@"temp"];
}

-(FIRDatabaseReference *)refLamp
{
    return [self.ref child:@"lamp"];
}

-(FIRDatabaseReference *)ref
{
    return [[FIRDatabase database] reference];
}

#pragma mark - public

-(void)loadDataWithBlock:(void (^)(NPPLampObject * _Nonnull))block withCancelBlock:(void (^)(NSError * _Nonnull))cancelBlock
{
    self.loading = YES; //載入中
    __weak typeof(self) weakself = self;    //避免memory leek
    // 對 firebase 操作取得 database 資料
    // self.refLamp 為 [[[FIRDatabase database] reference] child:@"lamp"]] 表示取得lamp這個key的資料
    [self.refLamp observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        weakself.loading = NO;  //載入完成
        // snapshot.value 為lamp的值，資料格式為 dictionary
        // NPPLampObject 為物件，objectFromDictionary 可將 dictionary 轉為物件
        NPPLampObject *lamp = [NPPLampObject objectFromDictionary:snapshot.value];
        
        // 將物件callback回去給呼叫者操作
        if (block) {
            block(lamp);
        }
    } withCancelBlock:^(NSError * _Nonnull error) {
        
        weakself.loading = NO;
        if (cancelBlock) {
            cancelBlock(error);
        }
    }];
}

-(void)setCheck:(BOOL)check
{
    NSNumber *checkNumber = check?@YES:@NO;
    [[self.refLamp child:@"check"] setValue:checkNumber];
}

-(void)setColor:(float)color
{
    [[self.refLamp child:@"color"] setValue:@(color)];
}

-(void)setIntensity:(float)intensity
{
    [[self.refLamp child:@"intensity"] setValue:@(intensity)];
}

-(void)loadSensorDataWithBlock:(void (^)(NSArray<NPPSensorObject *> * _Nonnull))block withCancelBlock:(void (^)(NSError * _Nonnull))cancelBlock
{
    self.loading = YES;
    __weak typeof(self) weakself = self;
    // 對 firebase 操作取得 database 資料
    // self.refSensor 為 [[[[FIRDatabase database] reference] child:@"sensor"] child:@"temp"]] 表示取得sensor.temp 這個key的資料
    [self.refSensor observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        weakself.loading = NO;
        NSDictionary *dict = snapshot.value;
        // 避免資料格式不是 NSDictionary
        if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
            if (cancelBlock) {
                NSError *error = [NSError errorWithDomain:@"com.htw.firebase" code:-1 userInfo:@{@"description":@"return null"}];
                cancelBlock(error);
            }
            return ;
        }
        // 將Dictionary的所有值轉換為物件陣列
        NSArray *arrayTemp = [NPPSensorObject objectFromArray:dict.allValues];
        
        // 依時間排序
        NSArray *sortedArray;
        sortedArray = [arrayTemp sortedArrayUsingComparator:^NSComparisonResult(NPPSensorObject *a, NPPSensorObject *b) {
            NSDate *first = a.time;
            NSDate *second = b.time;
            return [first compare:second];
        }];
        
        // 將物件陣列callback回去給呼叫者操作
        if (block) {
            block(sortedArray);
        }
    } withCancelBlock:^(NSError * _Nonnull error) {
        
        weakself.loading = NO;
        if (cancelBlock) {
            cancelBlock(error);
        }
    }];
}

@end
