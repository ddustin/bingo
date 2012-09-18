//
//  SeasonsController.m
//  Bingo
//
//  Created by Dustin Dettmer on 8/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EpisodesController.h"
#import "Util.h"

@interface EpisodesController ()

@end

@implementation EpisodesController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self performSegueWithIdentifier:@"toBoardChoice" sender:self];
}

- (IBAction)logout:(id)sender {
    
    NSMutableString *str = [NSMutableString string];
    
    [str appendFormat:@"https://agileordering.com/bingo/logout.php"];
    
    [str appendFormat:@"?device_name=%@", [Util deviceId]];
    
    id req = [NSURLRequest requestWithURL:[NSURL URLWithString:str]];
    
    [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *resp, NSData *data, NSError *error) {
        
        if(error) {
            
            UIAlertView *alert = [UIAlertView new];
            
            alert.title = @"Trouble";
            alert.message = error.localizedFailureReason ? error.localizedFailureReason : error.localizedDescription;
            
            [alert addButtonWithTitle:@"Okay"];
            
            [alert show];
        }
        else {
            
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"signedin"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
