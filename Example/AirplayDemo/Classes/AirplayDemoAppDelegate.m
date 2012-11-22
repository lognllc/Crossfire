//
//  AirplayDemoAppDelegate.m
//  AirplayDemo
//
//  Created by Rex Sheng on 11/22/12.
//

#import "AirplayDemoAppDelegate.h"
#import "AirplayDemoViewController.h"
#import "CRWindows.h"

@implementation AirplayDemoAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	[CRWindows enableWithRootViewControllerClass:[AirplayDemoViewController class]];
    return YES;
}

@end
