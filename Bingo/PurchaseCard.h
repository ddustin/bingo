//
//  PurchaseCard.h
//  Bingo
//
//  Created by Dustin Dettmer on 9/21/12.
//  Copyright (c) 2012 Dusty Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PurchaseCard;

@protocol PurchaseCardDelegate <NSObject>

- (void)purchaseCardBack:(PurchaseCard*)controller;
- (void)purchaseCardPurchaseComplete:(PurchaseCard*)controller;

@end

@interface PurchaseCard : UIViewController

@property (nonatomic, weak) id<PurchaseCardDelegate> delegate;

@end
