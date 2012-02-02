//
//  YIHorizontalTableView.m
//  YIHorizontalTableView
//
//  Created by Yasuhiro Inami on 12/02/01.
//  Copyright 2011 Yasuhiro Inami. All rights reserved.
//

#import "YIHorizontalTableView.h"
#import <objc/runtime.h>


@implementation YIHorizontalTableView

@synthesize scrollIndicatorPosition = _scrollIndicatorPosition;

#pragma mark -

#pragma mark Accessors

- (void)setDataSource:(id <UITableViewDataSource>)aDataSource
{
    _horizontalDataSource = aDataSource;
    [super setDataSource:self];
}

- (void)setFrame:(CGRect)aFrame
{
    [super setFrame:CGRectMake(aFrame.origin.x+(aFrame.size.width-aFrame.size.height)/2.0, 
                               aFrame.origin.y+(aFrame.size.height-aFrame.size.width)/2.0,
                               aFrame.size.height,
                               aFrame.size.width)];
    self.transform = CGAffineTransformMakeRotation(-M_PI/2.0); // transform after setFrame
    
    self.scrollIndicatorPosition = _scrollIndicatorPosition;
}

- (void)setScrollIndicatorInsets:(UIEdgeInsets)edgeInsets
{
    [super setScrollIndicatorInsets:UIEdgeInsetsMake(edgeInsets.left, edgeInsets.bottom, edgeInsets.right, edgeInsets.top)];
}

- (void)setContentInset:(UIEdgeInsets)edgeInsets
{
    [super setContentInset:UIEdgeInsetsMake(edgeInsets.left, edgeInsets.bottom, edgeInsets.right, edgeInsets.top)];
}

- (void)setScrollIndicatorPosition:(YIHorizontalTableViewScrollIndicatorPosition)scrollIndicatorPosition
{
    _scrollIndicatorPosition = scrollIndicatorPosition;
    
    switch (_scrollIndicatorPosition) {
        case YIHorizontalTableViewScrollIndicatorPositionTop:
            self.scrollIndicatorInsets = UIEdgeInsetsZero;
            break;
        case YIHorizontalTableViewScrollIndicatorPositionBottom:
            self.scrollIndicatorInsets = UIEdgeInsetsMake(self.frame.size.height-10, 0, 0, 0);
            break;
        default:
            break;
    }
}

#pragma mark -

#pragma mark NSObject

- (BOOL)respondsToSelector:(SEL)aSelector
{
    struct objc_method_description methodDescription = protocol_getMethodDescription(@protocol(UITableViewDataSource), aSelector, NO, YES);
    
    if (methodDescription.name != nil) {
        return [_horizontalDataSource respondsToSelector:aSelector];
    }
    else {
        return [super respondsToSelector:aSelector];
    }
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    struct objc_method_description methodDescription = protocol_getMethodDescription(@protocol(UITableViewDataSource), [anInvocation selector], NO, YES);
    
    if (methodDescription.name != nil) {
        [anInvocation invokeWithTarget:_horizontalDataSource];
    }
    else {
        [super forwardInvocation:anInvocation];
    }
}

#pragma mark -

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_horizontalDataSource tableView:tableView numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [_horizontalDataSource tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.contentView.transform = CGAffineTransformMakeRotation(M_PI/2.0);
    
    return cell;
}

@end
