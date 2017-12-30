//
//  TemperatureViewController.m
//  NetworkProgrammingProject
//
//  Created by Rex on 2017/12/26.
//  Copyright © 2017年 Rex. All rights reserved.
//

#import "TemperatureViewController.h"
#import "DateValueFormatter.h"


@import Charts;



@interface TemperatureViewController ()

@property (strong, nonatomic) NSArray<ChartDataEntry *> *charts;
@property (weak, nonatomic) IBOutlet LineChartView *chartView;

@end

@implementation TemperatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"溫度";
    
    LineChartDataSet *lineChartDataSet = [[LineChartDataSet alloc] initWithValues:self.charts label:@"溫度"];
    LineChartData *lineChartData = [[LineChartData alloc] initWithDataSet:lineChartDataSet];
    self.chartView.data = lineChartData;
}

-(void)setSensors:(NSArray<NPPSensorObject *> *)sensors
{
    NSMutableArray<ChartDataEntry *> *dataEntries = [NSMutableArray array];
    for (NPPSensorObject *sensor in sensors) {
        NSTimeInterval y = sensor.time.timeIntervalSince1970;
        ChartDataEntry *dataEntry = [[ChartDataEntry alloc] initWithX:y y:sensor.temp];
        [dataEntries addObject:dataEntry];
    }
    self.charts = dataEntries;
}

-(void)setChartView:(LineChartView *)chartView
{
    _chartView = chartView;
    
    _chartView.chartDescription.enabled = NO;
    
    _chartView.dragEnabled = YES;
    [_chartView setScaleEnabled:YES];
    _chartView.pinchZoomEnabled = YES;
    _chartView.drawGridBackgroundEnabled = NO;
    _chartView.rightAxis.enabled = NO;
    
    [_chartView animateWithXAxisDuration:2.5];
    
    ChartXAxis *xAxis = chartView.xAxis;
    xAxis.valueFormatter = [[DateValueFormatter alloc] init];
}

@end
