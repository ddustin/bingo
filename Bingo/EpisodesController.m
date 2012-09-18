//
//  SeasonsController.m
//  Bingo
//
//  Created by Dustin Dettmer on 8/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EpisodesController.h"
#import "Util.h"
#import "AppDelegate.h"
#import "Episodes.h"

@interface EpisodesController ()

@property (nonatomic, strong) NSArray *episodes;

@end

@implementation EpisodesController
@synthesize episodes;

- (void)dealloc {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = YES;
    
    self.episodes = Episodes.shared.episodes;
    
    if([Episodes.shared.season objectForKey:@"number"])
        self.navigationItem.title = [NSString stringWithFormat:@"Season %@", [Episodes.shared.season objectForKey:@"number"]];
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(episodesUpdated) name:EpisodesUpdated object:nil];
}

- (void)viewDidUnload {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    [super viewDidUnload];
}

- (void)episodesUpdated {
    
    self.episodes = Episodes.shared.episodes;
    
    if([Episodes.shared.season objectForKey:@"number"])
        self.navigationItem.title = [NSString stringWithFormat:@"Season %@", [Episodes.shared.season objectForKey:@"number"]];
    
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self performSegueWithIdentifier:@"toBoardChoice" sender:self];
}

- (IBAction)logout:(id)sender {
    
    [AppDelegate.shared.facebook logout];
    
    NSMutableString *str = [NSMutableString string];
    
    [str appendFormat:@"https://agileordering.com/bingo/logout.php"];
    
    [str appendFormat:@"?device_name=%@", [Util deviceId]];
    
    id req = [NSURLRequest requestWithURL:[NSURL URLWithString:str]];
    
    [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *resp, NSData *data, NSError *error) {
        
        if(error) {
            
            UIAlertView *alert = [UIAlertView new];
            
            alert.title = @"Trouble";
            alert.message = error.localizedFailureReason ? error.localizedFailureReason : error.localizedDescription;
            
            [alert addButtonWithTitle:@"Okay"];
            
            [alert show];
        }
        else {
            
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"signedin"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.episodes.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    NSDictionary *episode = [self.episodes objectAtIndex:indexPath.row];
    
    if([[episode objectForKey:@"name"] length]) {
        
        cell.textLabel.text = [episode objectForKey:@"name"];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Episode %@", [episode objectForKey:@"number"]];
    }
    else {
        
        cell.textLabel.text = [NSString stringWithFormat:@"Episode %@", [episode objectForKey:@"number"]];
        cell.detailTextLabel.text = @"";
    }
    
    return cell;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
