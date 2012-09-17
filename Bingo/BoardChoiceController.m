//
//  BoardChoiceController.m
//  Bingo
//
//  Created by Dustin Dettmer on 8/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BoardChoiceController.h"

@interface BoardChoiceController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation BoardChoiceController
@synthesize scrollView;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    CGSize size = self.scrollView.bounds.size;
    
    size.height += 1;
    
    self.scrollView.contentSize = size;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidUnload {
    [self setScrollView:nil];
    [super viewDidUnload];
}
@end
