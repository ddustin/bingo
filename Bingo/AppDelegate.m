//
//  AppDelegate.m
//  Bingo
//
//  Created by Dustin Dettmer on 8/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "BWQuincyManager.h"

NSString *FacebookLogin = @"FacebookLogin";
NSString *FacebookLoginFails = @"FacebookLoginFails";

@implementation AppDelegate
@synthesize facebook;
@synthesize window = _window;

static AppDelegate *instance = nil;

+ (AppDelegate*)shared {
    
    return instance;
}

- (Facebook*)facebook {
    
    if(!facebook) {
        
        facebook = [[Facebook alloc] initWithAppId:@"354569227963046" urlSchemeSuffix:@"bingoguido" andDelegate:self];
        
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"FBAccessTokenKey"]
            && [[NSUserDefaults standardUserDefaults] objectForKey:@"FBExpirationDateKey"]) {
            
            facebook.accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"FBAccessTokenKey"];
            facebook.expirationDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"FBExpirationDateKey"];
        }
    }
    
    return facebook;
}

- (void)fbDidLogin {
    
    [[NSUserDefaults standardUserDefaults] setObject:self.facebook.accessToken forKey:@"FBAccessTokenKey"];
    [[NSUserDefaults standardUserDefaults] setObject:self.facebook.expirationDate forKey:@"FBExpirationDateKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [NSNotificationCenter.defaultCenter postNotificationName:FacebookLogin object:nil];
}

- (BOOL)isFbLoggedIn {
    
    if(!self.facebook.expirationDate)
        return NO;
    
    return [self.facebook.expirationDate earlierDate:[NSDate date]] != self.facebook.expirationDate;
}

- (void)fbDidNotLogin:(BOOL)cancelled {
    
    [NSNotificationCenter.defaultCenter postNotificationName:FacebookLoginFails object:nil];
}

- (void)fbDidExtendToken:(NSString*)accessToken expiresAt:(NSDate*)expiresAt {
    
    NSLog(@"fbDidExtendToken");
}

- (void)fbDidLogout {
    
    AppDelegate.shared.facebook.accessToken = nil;
    AppDelegate.shared.facebook.expirationDate = nil;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults removeObjectForKey:@"FBAccessTokenKey"];
    [defaults removeObjectForKey:@"FBExpirationDateKey"];
    
    [defaults synchronize];
}

- (void)fbSessionInvalidated {
    
    AppDelegate.shared.facebook.accessToken = nil;
    AppDelegate.shared.facebook.expirationDate = nil;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults removeObjectForKey:@"FBAccessTokenKey"];
    [defaults removeObjectForKey:@"FBExpirationDateKey"];
    
    [defaults synchronize];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    instance = self;
    
    [[BWQuincyManager sharedQuincyManager] setSubmissionURL:@"http://www.agileordering.com/quincy/crash_v200.php"];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    instance = self;
    
    return [self.facebook handleOpenURL:url];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
    instance = nil;
}

@end
