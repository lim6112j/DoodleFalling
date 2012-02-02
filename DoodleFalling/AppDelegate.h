//
//  AppDelegate.h
//  DoodleFalling
//
//  Created by lim byeong cheol on 11. 9. 7..
//  Copyright SK M&S 2011년. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}
- (NSString *)applicationDocumentsDirectory;
@property (nonatomic, retain) UIWindow *window;

@end
