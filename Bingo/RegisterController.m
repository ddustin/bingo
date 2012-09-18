//
//  RegisterController.m
//  Bingo
//
//  Created by Dustin Dettmer on 9/17/12.
//  Copyright (c) 2012 Dusty Technologies. All rights reserved.
//

#import "RegisterController.h"

@interface RegisterController ()

@end

@implementation RegisterController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"facebookRegister"]) {
        
        FacebookPendingController *controller = segue.destinationViewController;
        
        controller.delegate = self;
    }
}

- (void)facebookPendingFailed:(FacebookPendingController *)instance serverResponse:(NSDictionary *)serverResponse {
    
    if([serverResponse objectForKey:@"message"]) {
        
        UIAlertView *alert = [UIAlertView new];
        
        alert.title = @"Trouble";
        alert.message = [serverResponse objectForKey:@"message"];
        
        [alert addButtonWithTitle:@"Okay"];
        
        [alert show];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)facebookPendingSucceeded:(FacebookPendingController *)instance serverResponse:(NSDictionary *)serverResponse {
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"signedin"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    UINavigationController *nav = self.navigationController;
    
    [nav popToRootViewControllerAnimated:NO];
    
    [nav.topViewController performSegueWithIdentifier:@"toEpisodes" sender:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
