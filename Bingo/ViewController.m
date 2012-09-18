//
//  ViewController.m
//  Bingo
//
//  Created by Dustin Dettmer on 8/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)pushAheadIfLoggedIn {
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"signedin"] boolValue]) {
        
        [self performSegueWithIdentifier:@"toEpisodes" sender:self];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    if(!animated)
        [self pushAheadIfLoggedIn];
}

- (void)viewDidAppear:(BOOL)animated {
    
    if(animated)
        [self pushAheadIfLoggedIn];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
