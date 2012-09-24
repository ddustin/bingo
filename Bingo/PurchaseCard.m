//
//  PurchaseCard.m
//  Bingo
//
//  Created by Dustin Dettmer on 9/21/12.
//  Copyright (c) 2012 Dusty Technologies. All rights reserved.
//

#import "PurchaseCard.h"

@interface PurchaseCard ()

@end

@implementation PurchaseCard
@synthesize delegate;

- (IBAction)back:(id)sender {
    
    [self.delegate purchaseCardBack:self];
}

- (IBAction)buy:(id)sender {
    
    [self.delegate purchaseCardPurchaseComplete:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
