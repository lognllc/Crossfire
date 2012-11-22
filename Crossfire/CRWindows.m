//
//  CRWindows.m
//
//  Created by Rex Sheng on 11/22/12.
//

#import "CRWindows.h"

@interface CRWindows ()
@property (nonatomic, strong) NSMutableArray *windows;
@property (nonatomic, unsafe_unretained) Class rootViewControllerClass;
@end

@implementation CRWindows

+ (CRWindows *)shared
{
	static dispatch_once_t onceToken;
	static CRWindows *shared;
	dispatch_once(&onceToken, ^{
		shared = [[CRWindows alloc] init];
	});
	return shared;
}

- (id)init
{
	if (self = [super init]) {
		_windows = [@[] mutableCopy];
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(screenDidConnect:)
													 name:UIScreenDidConnectNotification
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(screenDidDisconnect:)
													 name:UIScreenDidDisconnectNotification
												   object:nil];
	}
	return self;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)enableWithRootViewControllerClass:(Class)rootViewControllerClass
{
	NSAssert(_rootViewControllerClass == nil, @"already enabled");
	_rootViewControllerClass = rootViewControllerClass;
	NSArray *_screens = [UIScreen screens];
	for (UIScreen *_screen in _screens) {
		UIWindow *_window = [self createWindowForScreen:_screen];
		[_window setRootViewController:[[_rootViewControllerClass alloc] init]];
		[_window setHidden:NO];
		
		// If you don't do this here, you will get the "Applications are expected to have a root view controller" message.
		if (_screen == [UIScreen mainScreen]) {
			[_window makeKeyAndVisible];
		}
	}
}

- (UIWindow *)createWindowForScreen:(UIScreen *)screen
{
	UIWindow *_window = nil;
	
	for (UIWindow *window in self.windows) {
		if (window.screen == screen) {
			_window = window;
		}
	}
	if (_window == nil) {
		_window = [[UIWindow alloc] initWithFrame:[screen bounds]];
		[_window setScreen:screen];
		[self.windows addObject:_window];
	}
	
	return _window;
}

- (void)screenDidConnect:(NSNotification *)notification
{
	NSLog(@"Screen connected");
	UIScreen *_screen = [notification object];
	// Get a window for it
	UIWindow *_window = [self createWindowForScreen:_screen];
//	[_window setScreen:_screen];
//	[self.windows addObject:_window];
	[_window setRootViewController:[[_rootViewControllerClass alloc] init]];
	[_window setHidden:NO];
}

- (void)screenDidDisconnect:(NSNotification *)notification
{
	NSLog(@"Screen disconnected");
	UIScreen *_screen = [notification object];
	
	// Find any window attached to this screen, remove it from our window list, and release it.
	for (UIWindow *_window in [self.windows copy]) {
		if (_window.screen == _screen) {
			[self.windows removeObjectIdenticalTo:_window];
		}
	}
	return;
}

+ (void)enableWithRootViewControllerClass:(Class)rootViewControllerClass
{
	[self.shared enableWithRootViewControllerClass:rootViewControllerClass];
}

@end

@implementation UIViewController (CRWindows)

- (BOOL)isMainScreen
{
	return self.view.window.screen == [UIScreen mainScreen];
}

- (BOOL)isMirroringScreen
{
	return ![self isMainScreen];
}

- (BOOL)hasMirroringScreen
{
	return [self isMainScreen] && [CRWindows shared].windows.count > 1;
}

@end
