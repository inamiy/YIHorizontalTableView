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
    _tableView.frame = CGRectMake(50, 100, 200, 100);
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.scrollIndicatorPosition = YIHorizontalTableViewScrollIndicatorPositionBottom;
    
    [self.view addSubview:_tableView];
    [_tableView release];
    
    {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button addTarget:self action:@selector(handleButton:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"Select Index 10" forState:UIControlStateNormal];
        [button sizeToFit];
#if defined(__IPHONE_7_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
        CGRect frame = button.frame;
        frame.origin.y += 20;
        button.frame = frame;
#endif
        [self.view addSubview:button];
    }
    
    {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button addTarget:self action:@selector(handleScrollButton:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"Scroll to visible" forState:UIControlStateNormal];
        [button sizeToFit];
#if defined(__IPHONE_7_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
        CGRect frame = button.frame;
        frame.origin.x += 200;
        frame.origin.y += 20;
        button.frame = frame;
#endif
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

- (void)handleButton:(UIButton*)button
{
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:10 inSection:0];
    [_tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
}

- (void)handleScrollButton:(UIButton*)button
{
    [_tableView scrollRectToVisible:CGRectMake(250, 0, 1, 1) animated:YES]; // NOTE: size={1,1} is required
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

@end
