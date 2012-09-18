//
//  FacebookPendingController.h
//  Bingo
//
//  Created by Dustin Dettmer on 9/17/12.
//  Copyright (c) 2012 Dusty Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Facebook.h"

@class FacebookPendingController;

@protocol FacebookPendingControllerDelegate <NSObject>

- (void)facebookPendingSucceeded:(FacebookPendingController*)instance serverResponse:(NSDictionary*)serverResponse;
- (void)facebookPendingFailed:(FacebookPendingController*)instance serverResponse:(NSDictionary*)serverResponse;

@end

@interface FacebookPendingController : UIViewController<FBRequestDelegate>

@property (nonatomic, weak) id<FacebookPendingControllerDelegate> delegate;

@end
