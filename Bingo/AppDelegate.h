//
//  AppDelegate.h
//  Bingo
//
//  Created by Dustin Dettmer on 8/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Facebook.h"

extern NSString *FacebookLogin;
extern NSString *FacebookLoginFails;

@interface AppDelegate : UIResponder <UIApplicationDelegate, FBSessionDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, readonly) BOOL isFbLoggedIn;

@property (nonatomic, strong) Facebook *facebook;

+ (AppDelegate*)shared;

@end
