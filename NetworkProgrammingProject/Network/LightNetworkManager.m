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
    self.loading = YES;
    __weak typeof(self) weakself = self;
    [self.refLamp observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        weakself.loading = NO;
        NPPLampObject *lamp = [NPPLampObject objectFromDictionary:snapshot.value];
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
//    self.loading = YES;
    NSNumber *checkNumber = check?@YES:@NO;
    [[self.refLamp child:@"check"] setValue:checkNumber];
}

-(void)setColor:(float)color
{
//    self.loading = YES;
    [[self.refLamp child:@"color"] setValue:@(color)];
}

-(void)setIntensity:(float)intensity
{
//    self.loading = YES;
    [[self.refLamp child:@"intensity"] setValue:@(intensity)];
}

-(void)loadSensorDataWithBlock:(void (^)(NSArray<NPPSensorObject *> * _Nonnull))block withCancelBlock:(void (^)(NSError * _Nonnull))cancelBlock
{
    self.loading = YES;
    __weak typeof(self) weakself = self;
    [self.refSensor observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        weakself.loading = NO;
        NSDictionary *dict = snapshot.value;
        if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
            if (cancelBlock) {
                NSError *error = [NSError errorWithDomain:@"com.htw.firebase" code:-1 userInfo:@{@"description":@"return null"}];
                cancelBlock(error);
            }
            return ;
        }
        NSArray *arrayTemp = [NPPSensorObject objectFromArray:dict.allValues];
        
        NSArray *sortedArray;
        sortedArray = [arrayTemp sortedArrayUsingComparator:^NSComparisonResult(NPPSensorObject *a, NPPSensorObject *b) {
            NSDate *first = a.time;
            NSDate *second = b.time;
            return [first compare:second];
        }];
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
