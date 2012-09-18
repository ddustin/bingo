//
//  Util.m
//  Bingo
//
//  Created by Dustin Dettmer on 9/17/12.
//  Copyright (c) 2012 Dusty Technologies. All rights reserved.
//

#import "Util.h"

@implementation Util

+ (NSString*)deviceId {
    
    NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceId"];
	
	if(!str) {
        
        CFUUIDRef ref = CFUUIDCreate(NULL);
		
        CFStringRef strRef = CFUUIDCreateString(NULL, ref);
        
        CFRelease(ref);
        
        str = (__bridge NSString*)strRef;
        
		[[NSUserDefaults standardUserDefaults] setObject:str forKey:@"deviceId"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        CFRelease(strRef);
	}
    
    return str;
}

@end
