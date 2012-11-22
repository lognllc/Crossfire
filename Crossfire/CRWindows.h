//
//  CRWindows.h
//
//  Created by Rex Sheng on 11/22/12.
//

#import <Foundation/Foundation.h>

@interface CRWindows : NSObject

+ (void)enableWithRootViewControllerClass:(Class)rootViewControllerClass;

@end

@interface UIViewController (CRWindows)

- (BOOL)hasMirroringScreen;
- (BOOL)isMirroringScreen;
- (BOOL)isMainScreen;

@end
