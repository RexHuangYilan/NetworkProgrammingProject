//
//  ViewController.m
//  NetworkProgrammingProject
//
//  Created by Rex on 2017/12/24.
//  Copyright © 2017年 Rex. All rights reserved.
//

#import "ViewController.h"

#import "NPPLampObject.h"
#import "LightViewManager.h"
#import "LightNetworkManager.h"

#import "TemperatureViewController.h"


@interface ViewController ()
<
    LightNetworkManagerDelegate
>

@property (nonatomic,strong) NPPLampObject *lamp;
@property (strong, nonatomic) IBOutlet LightViewManager *lightManager;
@property (strong, nonatomic) IBOutlet LightNetworkManager *networkManager;

@property (strong, nonatomic) NSArray<NPPSensorObject *> *charts;

@property (nonatomic, strong) CAGradientLayer *bg;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"控制中心";
    self.navigationController.navigationBar.translucent = YES;
    
    [self loadData];
}

#pragma mark - get


#pragma mark - set

-(void)setNetworkManager:(LightNetworkManager *)networkManager
{
    _networkManager = networkManager;
    networkManager.delegate = self;
}

-(void)setLamp:(NPPLampObject *)lamp
{
    _lamp = lamp;
    [self.lightManager updateWithLamp:self.lamp];
}

-(void)setCharts:(NSArray<NPPSensorObject *> *)charts
{
    _charts = charts;
    NPPSensorObject *entry = charts.lastObject;
    [self.lightManager setTemperature:entry.temp];
}

#pragma mark - private

-(void)loadData
{
    __weak typeof(self) weakself = self;
    [self.networkManager loadDataWithBlock:^(NPPLampObject * _Nonnull lamp) {
        weakself.lightManager.error = @"";
        
        weakself.lamp = lamp;
    } withCancelBlock:^(NSError * _Nonnull error) {
        
        weakself.lightManager.error = error.localizedDescription;
    }];
    
    [self.networkManager loadSensorDataWithBlock:^(NSArray<NPPSensorObject *> * _Nonnull sensors) {
        weakself.lightManager.error = @"";
        
        weakself.charts = sensors;
    } withCancelBlock:^(NSError * _Nonnull error) {
        
        weakself.lightManager.error = error.localizedDescription;
    }];
}

#pragma mark - private

- (IBAction)doBtnLight:(UIButton *)sender
{
    [self.networkManager setCheck:!self.lightManager.power];
}

- (IBAction)changeColor:(id)sender
{
    [self.networkManager setColor:self.lightManager.color];
}

- (IBAction)changeIntensity:(id)sender
{
    [self.networkManager setIntensity:self.lightManager.intensity];
}

- (IBAction)doBtnMore:(id)sender
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TemperatureViewController *vc = [sb instantiateViewControllerWithIdentifier:@"TemperatureViewController"];
    [vc setSensors:self.charts];
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - LightNetworkManagerDelegate

-(void)setLoading:(BOOL)loading
{
    self.lightManager.loading = loading;
}

@end
