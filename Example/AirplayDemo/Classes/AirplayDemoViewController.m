//
//  AirplayDemoViewController.m
//  AirplayDemo
//
//  Created by Rex Sheng on 11/22/12.
//

#import "AirplayDemoViewController.h"

@implementation AirplayDemoViewController
{
	UILabel *titleLabel;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];
	titleLabel = [[UILabel alloc] initWithFrame:self.view.bounds];
	titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	titleLabel.textAlignment = NSTextAlignmentCenter;
	titleLabel.font = [UIFont fontWithName:@"Courier" size:20];
	[self.view addSubview:titleLabel];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	BOOL isMainScreen = self.view.window.screen == [UIScreen mainScreen];
	titleLabel.text = isMainScreen ? @"MainScreen" : @"Apple TV";
}

@end