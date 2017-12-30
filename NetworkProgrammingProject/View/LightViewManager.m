//
//  LightViewManager.m
//  NetworkProgrammingProject
//
//  Created by Rex on 2017/12/24.
//  Copyright © 2017年 Rex. All rights reserved.
//

#import "LightViewManager.h"
#import "ColorSlider.h"
#import "ColorView.h"

#import "UIImage+Color.h"

@interface LightViewManager()

@property (nonatomic, weak) IBOutlet UIButton *btnLight;

@property (weak, nonatomic) IBOutlet UILabel *labelColor;
@property (weak, nonatomic) IBOutlet ColorSlider *sliderColor;

@property (weak, nonatomic) IBOutlet UILabel *labelIntensity;
@property (weak, nonatomic) IBOutlet ColorSlider *sliderIntensity;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingView;
@property (weak, nonatomic) IBOutlet UILabel *labelError;

@property (weak, nonatomic) IBOutlet UILabel *labelTemperature;

@property (weak, nonatomic) IBOutlet ColorView *backgroupView;
@end

@implementation LightViewManager

#pragma mark - IBAction

- (IBAction)changeColor:(id)sender
{
    [self synColor];
}

- (IBAction)changeIntensity:(id)sender
{
    [self synIntensity];
}

#pragma mark - private

-(void)synColor
{
    self.labelColor.text = [NSString stringWithFormat:@"%d",self.color];
    
    UIImage *image = [self.btnLight imageForState:UIControlStateSelected];
    image = [image replaceColor:[self.sliderColor color]];
    [self.btnLight setImage:image forState:UIControlStateSelected];
}

-(void)synIntensity
{
    self.labelIntensity.text = [NSString stringWithFormat:@"%d",self.intensity];
    self.backgroupView.intensity = self.power ? self.intensity / 100.0 : 0;
}

#pragma mark - get

-(BOOL)power
{
    return self.btnLight.selected;
}

-(int)color
{
    return (int)round(self.sliderColor.value/10.0)*10;
}

-(int)intensity
{
    return (int)round(self.sliderIntensity.value/10.0)*10;
}

-(BOOL)loading
{
    return self.loadingView.animating;
}

-(NSString *)error
{
    return self.labelError.text;
}

#pragma mark - set

-(void)setPower:(BOOL)power
{
    self.btnLight.selected = power;
    [self synIntensity];
}

-(void)setColor:(int)color
{
    self.sliderColor.value = color;
    [self synColor];
}

-(void)setIntensity:(int)intensity
{
    self.sliderIntensity.value = intensity;
    [self synIntensity];
}

-(void)setLoading:(BOOL)loading
{
    if (loading) {
        [self.loadingView startAnimating];
    }else{
        [self.loadingView stopAnimating];
    }
}

-(void)setError:(NSString *)error
{
    self.labelError.text = error;
}

-(void)setTemperature:(float)temperature
{
    self.labelTemperature.text = [NSString stringWithFormat:@"%.2f°C",temperature];
}

#pragma mark - public

-(void)updateWithLamp:(NPPLampObject *)lamp
{
    self.power = lamp.check;
    self.color = lamp.color;
    self.intensity = lamp.intensity;
}

@end
