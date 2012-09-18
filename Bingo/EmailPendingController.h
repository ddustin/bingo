//
//  EmailRegisterPendingController.h
//  Bingo
//
//  Created by Dustin Dettmer on 9/17/12.
//  Copyright (c) 2012 Dusty Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EmailPendingController;

@protocol EmailPendingControllerDelegate <NSObject>

- (void)emailPendingSucceeded:(EmailPendingController*)instance serverResponse:(NSDictionary*)serverResponse;
- (void)emailPendingFailed:(EmailPendingController*)instance serverResponse:(NSDictionary*)serverResponse;

@end

@interface EmailPendingController : UIViewController

@property (nonatomic, weak) id<EmailPendingControllerDelegate> delegate;

@property (nonatomic, strong) NSURLRequest *request;

@end
