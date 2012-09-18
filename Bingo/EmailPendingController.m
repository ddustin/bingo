//
//  EmailRegisterPendingController.m
//  Bingo
//
//  Created by Dustin Dettmer on 9/17/12.
//  Copyright (c) 2012 Dusty Technologies. All rights reserved.
//

#import "EmailPendingController.h"

@interface EmailPendingController ()

@end

@implementation EmailPendingController
@synthesize delegate;
@synthesize request;

- (void)viewDidAppear:(BOOL)animated {
    
    [NSURLConnection sendAsynchronousRequest:self.request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        NSDictionary *result = nil;
        
        if(!error)
            result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        if(error) {
            
            UIAlertView *alert = [UIAlertView new];
            
            alert.title = error.localizedFailureReason ? error.localizedFailureReason : @"Error";
            alert.message = error.localizedRecoverySuggestion ? error.localizedRecoverySuggestion : error.localizedDescription;
            
            [alert addButtonWithTitle:@"Okay"];
            
            [alert show];
            
            [self.delegate emailPendingFailed:self serverResponse:nil];
            return;
        }
        
        if(![result isKindOfClass:NSDictionary.class]) {
            
            NSLog(@"Didn't get a dictionary as the server json.");
            return;
        }
        
        if(![[result objectForKey:@"success"] intValue]) {
            
            [self.delegate emailPendingFailed:self serverResponse:result];
        }
        else {
            
            [self.delegate emailPendingSucceeded:self serverResponse:result];
        }
    }];
    
    self.request = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
