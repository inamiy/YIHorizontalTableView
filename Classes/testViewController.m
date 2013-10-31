//
//  testViewController.m
//  test
//
//  Created by Andrew Gubanov on 5/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "testViewController.h"

@implementation testViewController

@synthesize tableView = _tableView;

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    _tableView = [[YIHorizontalTableView alloc] init];
    _tableView.frame = CGRectMake(50, 300, 200, 100);
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.contentInset = UIEdgeInsetsMake(200, 0, 200, 0);
    _tableView.scrollIndicatorPosition = YIHorizontalTableViewScrollIndicatorPositionBottom;
    
    [self.view addSubview:_tableView];
    [_tableView release];
    
    NSArray* infos = @[
                       @{
                           @"title"    : @"selectRowAtIndex",
                           @"selector" : @"handleSelectRow"
                           },
                       @{
                           @"title"    : @"scrollToRowAtIndexPath",
                           @"selector" : @"handleScrollToRowAtIndexPath"
                           },
                       @{
                           @"title"    : @"scrollRectToVisible",
                           @"selector" : @"handleScrollRectToVisible"
                           },
                       @{
                           @"title"    : @"setContentOffset",
                           @"selector" : @"handleSetContentOffset"
                           },
                       @{
                           @"title"    : @"setContentOffset+animated",
                           @"selector" : @"handleSetContentOffsetAnimated"
                           },
                       ];
    
    CGFloat top = 0;
#if defined(__IPHONE_7_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
    top = 20;
#endif
    for (NSDictionary* info in infos) {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button addTarget:self
                   action:NSSelectorFromString(info[@"selector"])
         forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:info[@"title"] forState:UIControlStateNormal];
        [button sizeToFit];

        CGRect frame = button.frame;
        frame.origin.x = 20;
        frame.origin.y = top;
        button.frame = frame;
        
        top += button.frame.size.height;
        
        [self.view addSubview:button];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

#pragma mark -

#pragma mark UIButton

- (void)handleSelectRow
{
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:10 inSection:0];
    [_tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
}

- (void)handleScrollToRowAtIndexPath
{
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:10 inSection:0];
    [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

- (void)handleScrollRectToVisible
{
    [_tableView scrollRectToVisible:CGRectMake(0, 250, 1, 1) animated:YES];
}

- (void)handleSetContentOffset
{
    _tableView.contentOffset = CGPointMake(0, 300);
}

- (void)handleSetContentOffsetAnimated
{
    [_tableView setContentOffset:CGPointMake(0, 350) animated:YES];
}

#pragma mark -

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)anIndexPath
{
    UITableViewCell *result = [aTableView dequeueReusableCellWithIdentifier:@"Reuse"];
    if (nil == result)
    {
        result = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Reuse"]
            autorelease];
    }
    
    result.textLabel.text = [NSString stringWithFormat:@"%d", [anIndexPath row]];
    
    return result;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

#pragma mark -

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"offset = %f",scrollView.contentOffset.y);
}

@end
