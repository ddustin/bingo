//
//  SignInController.m
//  Bingo
//
//  Created by Dustin Dettmer on 9/17/12.
//  Copyright (c) 2012 Dusty Technologies. All rights reserved.
//

#import "SignInController.h"
#import "Util.h"

@interface SignInController ()

@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation SignInController
@synthesize emailField;
@synthesize passwordField;

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"emailSignIn"]) {
        
        NSMutableString *str = [NSMutableString string];
        
        [str appendString:@"https://agileordering.com/bingo/login.php"];
        
        [str appendFormat:@"?device_name=%@", [Util deviceId]];
        [str appendFormat:@"&email=%@", [self.emailField.text stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
        [str appendFormat:@"&password=%@", [self.passwordField.text stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
        
        id request = [NSURLRequest requestWithURL:[NSURL URLWithString:str]];
        
        EmailPendingController *controller = segue.destinationViewController;
        
        controller.delegate = self;
        controller.request = request;
    }
    
    if([segue.identifier isEqualToString:@"facebookRegister"]) {
        
        FacebookPendingController *controller = segue.destinationViewController;
        
        controller.delegate = self;
    }
}

- (void)pendingFailed:(UIViewController *)instance serverResponse:(NSDictionary *)serverResponse {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pendingSucceeded:(UIViewController *)instance serverResponse:(NSDictionary *)serverResponse {
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"signedin"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    UINavigationController *nav = self.navigationController;
    
    [nav popToRootViewControllerAnimated:NO];
    
    [nav.topViewController performSegueWithIdentifier:@"toEpisodes" sender:self];
}

- (void)emailPendingFailed:(EmailPendingController *)instance serverResponse:(NSDictionary *)serverResponse {
    
    UIAlertView *alert = [UIAlertView new];
    
    alert.title = @"Trouble";
    alert.message = @"The email or password was incorrect.";
    
    [alert addButtonWithTitle:@"Okay"];
    
    [alert show];
    
    [self pendingFailed:instance serverResponse:serverResponse];
}

- (void)emailPendingSucceeded:(EmailPendingController *)instance serverResponse:(NSDictionary *)serverResponse {
    
    [self pendingSucceeded:instance serverResponse:serverResponse];
}

- (void)facebookPendingFailed:(FacebookPendingController *)instance serverResponse:(NSDictionary *)serverResponse {
    
    UIAlertView *alert = [UIAlertView new];
    
    alert.title = @"Trouble";
    alert.message = @"There was a problem completing the Facebook registration.";
    
    [alert addButtonWithTitle:@"Okay"];
    
    [alert show];
    
    [self pendingFailed:instance serverResponse:serverResponse];
}

- (void)facebookPendingSucceeded:(FacebookPendingController *)instance serverResponse:(NSDictionary *)serverResponse {
    
    [self pendingSucceeded:instance serverResponse:serverResponse];
}

- (void)viewWillAppear:(BOOL)animated {
    
    self.passwordField.text = @"";
}

- (IBAction)emailDone:(id)sender {
    
    [self.passwordField becomeFirstResponder];
}

- (IBAction)passwordDone:(id)sender {
    
    [self performSegueWithIdentifier:@"emailSignIn" sender:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidUnload {
    [self setEmailField:nil];
    [self setPasswordField:nil];
    [super viewDidUnload];
}

@end
