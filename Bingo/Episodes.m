//
//  Episodes.m
//  Bingo
//
//  Created by Dustin Dettmer on 9/18/12.
//  Copyright (c) 2012 Dusty Technologies. All rights reserved.
//

#import "Episodes.h"
#import <objc/runtime.h>
#import <objc/message.h>

NSString *EpisodesUpdated = @"EpisodesUpdated";

// Seconds until episde list will refresh.
//#define EPISODES_REFRESH_INTERVAL 86400
#define EPISODES_REFRESH_INTERVAL 30

@interface Episodes ()

@property (nonatomic, strong) NSDate *lastUpdate;

- (void)update;

@end

@implementation Episodes
@synthesize season, episodes, bingoCards;
@synthesize lastUpdate;

+ (Episodes*)shared {
    
    static Episodes *shared = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        shared = [Episodes new];
    });
    
    return shared;
}

- (id) init {
    
    self = [super init];
    
    if(self) {
        
        self.season = [[NSUserDefaults standardUserDefaults] objectForKey:@"Episodes-season"];
        self.episodes = [[NSUserDefaults standardUserDefaults] objectForKey:@"Episodes-episodes"];
        self.bingoCards = [[NSUserDefaults standardUserDefaults] objectForKey:@"Episodes-bingoCards"];
        
        self.lastUpdate = [[NSUserDefaults standardUserDefaults] objectForKey:@"EpisodesLastUpdate"];
        
        [self update];
    }
    
    return self;
}

- (void)update {
    
    __block Episodes *instance = self;
    
    void (^performUpdate)() = ^{
        
        NSMutableString *str = [NSMutableString string];
        
        [str appendFormat:@"https://agileordering.com/bingo/currentSeason.php"];
        
        [str appendFormat:@"?show_id=1"];
        
        id req = [NSURLRequest requestWithURL:[NSURL URLWithString:str]];
        
        [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *resp, NSData *data, NSError *error) {
            
            NSDictionary *result = nil;
            
            if(!error)
                result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            
            NSParameterAssert(error || [result isKindOfClass:NSDictionary.class]);
            
            if(error) {
                
                UIAlertView *alert = [UIAlertView new];
                
                alert.title = @"Trouble";
                alert.message = error.localizedFailureReason ? error.localizedFailureReason : error.localizedDescription;
                
                [alert addButtonWithTitle:@"Okay"];
                
                [alert show];
            }
            else {
                
                instance.season = [result objectForKey:@"season"];
                instance.episodes = [result objectForKey:@"episodes"];
                instance.bingoCards = [result objectForKey:@"bingoCards"];
                
                instance.lastUpdate = [NSDate date];
                
                [[NSUserDefaults standardUserDefaults] setObject:instance.season forKey:@"Episodes-season"];
                [[NSUserDefaults standardUserDefaults] setObject:instance.episodes forKey:@"Episodes-episodes"];
                [[NSUserDefaults standardUserDefaults] setObject:instance.bingoCards forKey:@"Episodes-bingoCards"];
                
                [[NSUserDefaults standardUserDefaults] setObject:instance.lastUpdate forKey:@"EpisodesLastUpdate"];
                
                [NSUserDefaults.standardUserDefaults synchronize];
                
                [NSNotificationCenter.defaultCenter postNotificationName:@"EpisodesUpdated" object:self];
            }
        }];
    };
    
    NSTimeInterval t = self.lastUpdate.timeIntervalSinceNow;
    
    NSParameterAssert(!self.lastUpdate || t < 0);
    
    if(!self.lastUpdate || t < -EPISODES_REFRESH_INTERVAL) {
        
        performUpdate();
        
        t = 0;
    }
    
    [self performSelector:@selector(update) withObject:nil afterDelay:EPISODES_REFRESH_INTERVAL + t];
}

@end
