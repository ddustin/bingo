//
//  FacebookPendingController.m
//  Bingo
//
//  Created by Dustin Dettmer on 9/17/12.
//  Copyright (c) 2012 Dusty Technologies. All rights reserved.
//

#import "FacebookPendingController.h"
#import "AppDelegate.h"
#import "Util.h"

@interface FacebookPendingController ()

@end

@implementation FacebookPendingController
@synthesize delegate;

- (void)dealloc {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)facebookLogin {
    
    NSLog(@"Requesting me from facebook.");
    
    [AppDelegate.shared.facebook requestWithGraphPath:@"me" andDelegate:self];
}

- (void)facebookLoginFails {
    
    [self.delegate facebookPendingFailed:self serverResponse:nil];
}

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
    
    UIAlertView *alert = [UIAlertView new];
    
    alert.title = @"Trouble";
    alert.message = error.localizedDescription;
    
    [alert addButtonWithTitle:@"Okay"];
    
    [alert show];
    
    [self.delegate facebookPendingFailed:self serverResponse:nil];
}

- (void)request:(FBRequest *)fbRequest didLoad:(id)result {
    
    NSMutableString *str = [NSMutableString string];
    
    NSString *fbId = [result objectForKey:@"id"];
    NSString *name = [result objectForKey:@"name"];
    NSString *email = [result objectForKey:@"email"];
    
    [str appendString:@"https://agileordering.com/bingo/register.php"];
    
    [str appendFormat:@"?device_name=%@", [Util deviceId]];
    [str appendFormat:@"&fbId=%@", [fbId stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
    
    if(name)
        [str appendFormat:@"&name=%@", [name stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
    
    if(email)
        [str appendFormat:@"&email=%@",[email stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
    
    NSLog(@"request: %@", str);
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:str]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        NSDictionary *result = nil;
        
        if(!error)
            result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        if(error) {
            
            UIAlertView *alert = [UIAlertView new];
            
            alert.title = error.localizedFailureReason ? error.localizedFailureReason : @"Error";
            alert.message = error.localizedRecoverySuggestion ? error.localizedRecoverySuggestion : error.localizedDescription;
            
            [alert addButtonWithTitle:@"Okay"];
            
            [alert show];
            
            [self.delegate facebookPendingFailed:self serverResponse:nil];
            return;
        }
        
        if(![result isKindOfClass:NSDictionary.class]) {
            
            NSLog(@"Didn't get a dictionary as the server json.");
            return;
        }
        
        if(![[result objectForKey:@"success"] intValue]) {
            
            [self.delegate facebookPendingFailed:self serverResponse:result];
        }
        else {
            
            [self.delegate facebookPendingSucceeded:self serverResponse:result];
        }
    }];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(facebookLogin) name:FacebookLogin object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(facebookLoginFails) name:FacebookLoginFails object:nil];
}

- (void)viewDidUnload {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated {
    
    Facebook *fb = AppDelegate.shared.facebook;
    
    [fb authorize:[NSArray arrayWithObject:@"email"]];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
