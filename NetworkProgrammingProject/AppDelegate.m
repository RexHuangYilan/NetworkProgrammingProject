//
//  AppDelegate.m
//  NetworkProgrammingProject
//
//  Created by Rex on 2017/12/24.
//  Copyright © 2017年 Rex. All rights reserved.
//

#import "AppDelegate.h"

@import Firebase;

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Use Firebase library to configure APIs
    [FIRApp configure];
    return YES;
}

@end
