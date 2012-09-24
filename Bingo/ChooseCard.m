//
//  ChooseCard.m
//  Bingo
//
//  Created by Dustin Dettmer on 9/21/12.
//  Copyright (c) 2012 Dusty Technologies. All rights reserved.
//

#import "ChooseCard.h"

@interface ChooseCard ()

@end

@implementation ChooseCard
@synthesize delegate;

- (IBAction)back:(id)sender {
    
    [self.delegate chooseCardBack:self];
}

- (IBAction)choose:(id)sender {
    
    [self.delegate chooseCardChoosen:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
