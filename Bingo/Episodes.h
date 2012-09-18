//
//  Episodes.h
//  Bingo
//
//  Created by Dustin Dettmer on 9/18/12.
//  Copyright (c) 2012 Dusty Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *EpisodesUpdated;

@interface Episodes : NSObject

@property (nonatomic, strong) NSDictionary *season;
@property (nonatomic, strong) NSArray *episodes;
@property (nonatomic, strong) NSDictionary *bingoCards;

+ (Episodes*)shared;

@end
