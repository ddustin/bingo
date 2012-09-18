//
//  EmailRegisterController.m
//  Bingo
//
//  Created by Dustin Dettmer on 9/17/12.
//  Copyright (c) 2012 Dusty Technologies. All rights reserved.
//

#import "EmailRegisterController.h"
#import "Util.h"

@interface EmailRegisterController ()

@property (weak, nonatomic) IBOutlet UITextField *fullNameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *passwordRepeatField;

@end

@implementation EmailRegisterController
@synthesize fullNameField;
@synthesize emailField;
@synthesize passwordField;
@synthesize passwordRepeatField;

- (IBAction)fullNameFinished:(id)sender {
    
    [self.emailField becomeFirstResponder];
}

- (IBAction)emailFinished:(id)sender {
    
    [self.passwordField becomeFirstResponder];
}

- (IBAction)passwordField:(id)sender {
    
    [self.passwordRepeatField becomeFirstResponder];
}

- (IBAction)passwordRepeatFinished:(id)sender {
    
    [self performSegueWithIdentifier:@"emailRegistration" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"emailRegistration"]) {
        
        NSMutableString *str = [NSMutableString string];
        
        [str appendString:@"https://agileordering.com/bingo/register.php"];
        
        [str appendFormat:@"?device_name=%@", [Util deviceId]];
        [str appendFormat:@"&name=%@",  [self.fullNameField.text stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
        [str appendFormat:@"&email=%@", [self.emailField.text stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
        [str appendFormat:@"&password=%@", [self.passwordField.text stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
        [str appendFormat:@"&passwordRepeat=%@", [self.passwordRepeatField.text stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
        
        NSLog(@"Request: %@", str);
        
        id request = [NSURLRequest requestWithURL:[NSURL URLWithString:str]];
        
        EmailPendingController *controller = segue.destinationViewController;
        
        controller.delegate = self;
        controller.request = request;
    }
}

- (void)emailPendingFailed:(EmailPendingController *)instance serverResponse:(NSDictionary *)serverResponse {
    
    if([serverResponse objectForKey:@"message"]) {
        
        UIAlertView *alert = [UIAlertView new];
        
        alert.title = @"Trouble";
        alert.message = [serverResponse objectForKey:@"message"];
        
        [alert addButtonWithTitle:@"Okay"];
        
        [alert show];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)emailPendingSucceeded:(EmailPendingController *)instance serverResponse:(NSDictionary *)serverResponse {
    
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

- (void)viewDidUnload {
    [self setFullNameField:nil];
    [self setEmailField:nil];
    [self setPasswordField:nil];
    [self setPasswordRepeatField:nil];
    [super viewDidUnload];
}
@end
