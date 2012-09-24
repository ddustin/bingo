//
//  ChooseCard.h
//  Bingo
//
//  Created by Dustin Dettmer on 9/21/12.
//  Copyright (c) 2012 Dusty Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChooseCard;

@protocol ChooseCardDelegate <NSObject>

- (void)chooseCardBack:(ChooseCard*)controller;
- (void)chooseCardChoosen:(ChooseCard*)controller;

@end

@interface ChooseCard : UIViewController

@property (nonatomic, weak) id<ChooseCardDelegate> delegate;

@end
