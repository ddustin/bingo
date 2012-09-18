//
//  SignInController.h
//  Bingo
//
//  Created by Dustin Dettmer on 9/17/12.
//  Copyright (c) 2012 Dusty Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmailPendingController.h"
#import "FacebookPendingController.h"

@interface SignInController : UITableViewController<EmailPendingControllerDelegate, FacebookPendingControllerDelegate>

@end
