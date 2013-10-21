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

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.frame = frame; // call custom setFrame
    }
    return self;
}

#pragma mark -

#pragma mark Accessors

- (void)setScrollIndicatorPosition:(YIHorizontalTableViewScrollIndicatorPosition)scrollIndicatorPosition
{
    _scrollIndicatorPosition = scrollIndicatorPosition;
    
    switch (_scrollIndicatorPosition) {
        case YIHorizontalTableViewScrollIndicatorPositionTop:
            self.scrollIndicatorInsets = UIEdgeInsetsZero;
            break;
        case YIHorizontalTableViewScrollIndicatorPositionBottom:
        default:
            self.scrollIndicatorInsets = UIEdgeInsetsMake(self.frame.size.height-10, 0, 0, 0);
            break;
    }
}

#pragma mark Accessors (Override)

- (void)setDataSource:(id <UITableViewDataSource>)aDataSource
{
    _horizontalDataSource = aDataSource;
    [super setDataSource:self];
}

- (CGRect)yi_frame
{
    return [super frame];
}

- (void)setFrame:(CGRect)aFrame
{
    [super setFrame:aFrame];
    self.transform = CGAffineTransformMakeRotation(-M_PI/2.0); // transform after setFrame
    
    self.scrollIndicatorPosition = _scrollIndicatorPosition;
}

- (UIEdgeInsets)yi_scrollIndicatorInsets
{
    UIEdgeInsets insets = [super scrollIndicatorInsets];
    return UIEdgeInsetsMake(insets.right, insets.top, insets.left, insets.bottom);
}

- (void)setScrollIndicatorInsets:(UIEdgeInsets)edgeInsets
{
    [super setScrollIndicatorInsets:UIEdgeInsetsMake(edgeInsets.left, edgeInsets.bottom, edgeInsets.right, edgeInsets.top)];
}

- (UIEdgeInsets)yi_contentInset
{
    UIEdgeInsets insets = [super contentInset];
    return UIEdgeInsetsMake(insets.right, insets.top, insets.left, insets.bottom);
}

- (void)setContentInset:(UIEdgeInsets)edgeInsets
{
    [super setContentInset:UIEdgeInsetsMake(edgeInsets.left, edgeInsets.bottom, edgeInsets.right, edgeInsets.top)];
}

- (CGSize)yi_contentSize
{
    CGSize contentSize = [super contentSize];
    return CGSizeMake(contentSize.height, contentSize.width);
}

// NOTE: don't override getter method which is often used in super methods internally
- (CGPoint)yi_contentOffset
{
    CGPoint contentOffset = [super contentOffset];
    return CGPointMake(contentOffset.y, -contentOffset.x);
}

#pragma mark -

#pragma mark UIScrollView

- (void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated
{
    CGPoint newOffset = CGPointMake(-contentOffset.y, contentOffset.x);
    [super setContentOffset:newOffset animated:animated];
}

- (void)scrollRectToVisible:(CGRect)rect animated:(BOOL)animated
{
    // comment-out: scrollRectToVisible uses overridden-setContentOffset internally
//    CGRect newRect = CGRectMake(rect.origin.y, rect.origin.x, rect.size.height, rect.size.width);
//    [super scrollRectToVisible:newRect animated:animated];
    
    // FIXME: evaluate rect.size to adjust contentOffset more precisely
    [self setContentOffset:rect.origin animated:animated];
}

#pragma mark -

#pragma mark UITableView

- (void)selectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition
{
    [super selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    [self scrollToRowAtIndexPath:indexPath atScrollPosition:scrollPosition animated:animated];
}

- (void)scrollToRowAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated
{
    CGRect cellFrame = [self rectForRowAtIndexPath:indexPath];
    
    CGPoint offset = CGPointZero;
    
    switch (scrollPosition) {
        case UITableViewScrollPositionTop:
            offset = CGPointMake(0, cellFrame.origin.y);
            break;
        case UITableViewScrollPositionBottom:
            offset = CGPointMake(0, cellFrame.origin.y-self.frame.size.width+cellFrame.size.height);
            break;
        case UITableViewScrollPositionMiddle:
            offset = CGPointMake(0, cellFrame.origin.y+(-self.frame.size.width+cellFrame.size.height)/2);
            break;
        default:
            return;
            break;
    }
    [super setContentOffset:offset animated:animated];
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
