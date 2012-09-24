//
//  CardList.m
//  Bingo
//
//  Created by Dustin Dettmer on 9/24/12.
//  Copyright (c) 2012 Dusty Technologies. All rights reserved.
//

#import "CardList.h"

@interface CardList ()

@end

@implementation CardList

- (void)purchaseCardBack:(PurchaseCard *)controller {
    
    [controller dismissModalViewControllerAnimated:YES];
}

- (void)purchaseCardPurchaseComplete:(PurchaseCard *)controller {
    
    [controller dismissViewControllerAnimated:YES completion:^{
        
        [self performSegueWithIdentifier:@"toBingoCard" sender:controller];
    }];
}

- (void)chooseCardBack:(ChooseCard *)controller {
    
    [controller dismissModalViewControllerAnimated:YES];
}

- (void)chooseCardChoosen:(ChooseCard *)controller {
    
    [controller dismissViewControllerAnimated:YES completion:^{
        
        [self performSegueWithIdentifier:@"toBingoCard" sender:controller];
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"toPurchaseCard"]) {
        
        PurchaseCard *controller = segue.destinationViewController;
        
        controller.delegate = self;
    }
    
    if([segue.identifier isEqualToString:@"toChooseCard"]) {
        
        ChooseCard *controller = segue.destinationViewController;
        
        controller.delegate = self;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
