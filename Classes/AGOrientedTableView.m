////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//  AGUITableView.m
//
//  Created by Andrew Gubanov on 5/23/11.
//  Copyright 2011 Andrew Gubanov. All rights reserved.
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Imports

#import "AGOrientedTableView.h"
#import <objc/runtime.h>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Private Interface

@interface AGOrientedTableView ()

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Constants

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Implementation

@implementation AGOrientedTableView

@synthesize orientedTableViewDataSource = _orientedTableViewDataSource;
@synthesize tableViewOrientation = _tableViewOrientation;

- (void)setOrientedTableViewDataSource:(id <UITableViewDataSource>)aDataSource
{
    _orientedTableViewDataSource = aDataSource;
    self.dataSource = self;
}

- (void)setTableViewOrientation:(AGTableViewOrientation)anOrientation
{
    if (_tableViewOrientation != anOrientation)
    {
        _tableViewOrientation = anOrientation;
        if (_tableViewOrientation == kAGTableViewOrientationHorizontal)
        {
            CGRect frame = self.frame;
            self.transform = CGAffineTransformMakeRotation(-M_PI/2.0);
            super.frame = frame;
        }
        else
        {
            self.transform = CGAffineTransformMakeRotation(0.0);
        }
        [self reloadData];
    }
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    struct objc_method_description methodDescription = protocol_getMethodDescription(@protocol(UITableViewDataSource), 
        aSelector, NO, YES);
    
    BOOL result = [super respondsToSelector:aSelector];
    if (methodDescription.name != nil)
    {
        result = [self.orientedTableViewDataSource respondsToSelector:aSelector];
    }
    return result;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    struct objc_method_description methodDescription = protocol_getMethodDescription(@protocol(UITableViewDataSource), 
        [anInvocation selector], NO, YES);
    if (methodDescription.name != nil)
    {
        [anInvocation invokeWithTarget:self.orientedTableViewDataSource];
    }
    else
    {
        [super forwardInvocation:anInvocation];
    }
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.orientedTableViewDataSource tableView:tableView numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.orientedTableViewDataSource tableView:tableView cellForRowAtIndexPath:indexPath];
    if (self.tableViewOrientation == kAGTableViewOrientationHorizontal)
    {
        cell.contentView.transform = CGAffineTransformMakeRotation(M_PI/2.0);
    }
    return cell;
}

@end
