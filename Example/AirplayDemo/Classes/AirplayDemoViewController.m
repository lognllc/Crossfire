//
//  AirplayDemoViewController.m
//  AirplayDemo
//
//  Created by Rex Sheng on 11/22/12.
//

#import "AirplayDemoViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "CRWindows.h"

@implementation AirplayDemoViewController
{
	UILabel *titleLabel;
	UISwitch *shakeSwitch;
	BOOL shakeMainScreen;
}

- (void)tap:(UITapGestureRecognizer *)tap
{
	if ([self isMainScreen]) {
		if (shakeMainScreen) {
			[self performShakeAnimation];
		} else {
			[[NSNotificationCenter defaultCenter] postNotificationName:@"Shake" object:nil];
		}
	} else {
		[self performShakeAnimation];
	}
}

- (void)performShakeAnimation
{
	CALayer *layer = titleLabel.layer;
	CGFloat ox = layer.position.x;
	[layer addAnimation:((^{
		CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"position.x"];
		anim.duration = .5;
		NSMutableArray *values = [NSMutableArray array];
		NSMutableArray *timings = [NSMutableArray array];
		NSMutableArray *keytimes = [NSMutableArray array];
		
		CGFloat time = 0.0;
		int times = 7;
		CGFloat step = 1.0 / (times + 1);
		for (int i = 0; i < times; i++) {
			[values addObject:[NSNumber numberWithFloat:ox + 5 * (i % 2 == 0 ? -1 : 1)]];
			[timings addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
			[keytimes addObject:[NSNumber numberWithFloat:time]];
			time += step;
		}
		
		// fihish right
		[values addObject:[NSNumber numberWithFloat:ox]];
		[keytimes addObject:[NSNumber numberWithFloat:1.0]];
		
		anim.values = values;
		anim.timingFunctions = timings;
		anim.keyTimes = keytimes;
		return anim;
	})()) forKey:@"shake"];
}

- (void)switchShakeOption:(UISwitch *)option
{
	shakeMainScreen = option.on;
}

#pragma mark - View Lifecycle
- (void)viewDidLoad
{
	[super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];
	UIFont *font = [UIFont fontWithName:@"Courier" size:20];;
	titleLabel = [[UILabel alloc] initWithFrame:self.view.bounds];
	titleLabel.backgroundColor = [UIColor clearColor];
	titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	titleLabel.textAlignment = NSTextAlignmentCenter;
	titleLabel.font = font;
	[self.view addSubview:titleLabel];
	titleLabel.userInteractionEnabled = YES;
	[titleLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
	
	shakeSwitch = [[UISwitch alloc] init];
	[shakeSwitch sizeToFit];
	CGSize size = self.view.bounds.size;
	shakeSwitch.frame = CGRectOffset(shakeSwitch.frame, size.width - shakeSwitch.frame.size.width, size.height - shakeSwitch.frame.size.height);
	shakeSwitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
	[self.view addSubview:shakeSwitch];
	[shakeSwitch addTarget:self action:@selector(switchShakeOption:) forControlEvents:UIControlEventValueChanged];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	titleLabel.text = [self isMainScreen] ? @"MainScreen" : @"Apple TV";
	[[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
	if ([self isMirroringScreen]) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(performShakeAnimation) name:@"Shake" object:nil];
		shakeSwitch.hidden = YES;
	}
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)canBecomeFirstResponder
{
	return YES;
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)receivedEvent
{
	if (receivedEvent.type == UIEventTypeRemoteControl) {
		NSLog(@"subtype %d", receivedEvent.subtype);
	}
}

@end