//
//  CardList.h
//  Bingo
//
//  Created by Dustin Dettmer on 9/24/12.
//  Copyright (c) 2012 Dusty Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PurchaseCard.h"
#import "ChooseCard.h"

@interface CardList : UITableViewController<PurchaseCardDelegate, ChooseCardDelegate>

@end
