//
//  YIHorizontalTableView.m
//  YIHorizontalTableView
//
//  Created by Yasuhiro Inami on 12/02/01.
//  Copyright 2011 Yasuhiro Inami. All rights reserved.
//

#import "YIHorizontalTableView.h"
#import <objc/runtime.h>

#define IS_IOS_AT_LEAST(ver)    ([[[UIDevice currentDevice] systemVersion] compare:ver] != NSOrderedAscending)

#if defined(__IPHONE_7_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
#define IS_FLAT_DESIGN          IS_IOS_AT_LEAST(@"7.0")
#else
#define IS_FLAT_DESIGN          NO
#endif


@implementation YIHorizontalTableView

@synthesize scrollIndicatorPosition = _scrollIndicatorPosition;

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.frame = frame; // call custom setFrame
        
        if (IS_FLAT_DESIGN) {
            self.separatorInset = UIEdgeInsetsZero;
        }
    }
    return self;
}

#pragma mark -

#pragma mark Accessors

- (void)setDataSource:(id <UITableViewDataSource>)aDataSource
{
    _horizontalDataSource = aDataSource;
    [super setDataSource:self];
}

- (void)setFrame:(CGRect)aFrame
{
    [super setFrame:aFrame];
    self.transform = CGAffineTransformMakeRotation(-M_PI/2.0); // transform after setFrame
    
    self.scrollIndicatorPosition = _scrollIndicatorPosition;
}

- (void)setScrollIndicatorPosition:(YIHorizontalTableViewScrollIndicatorPosition)scrollIndicatorPosition
{
    _scrollIndicatorPosition = scrollIndicatorPosition;
    
    switch (_scrollIndicatorPosition) {
        case YIHorizontalTableViewScrollIndicatorPositionTop:
            self.scrollIndicatorInsets = UIEdgeInsetsZero;
            break;
        case YIHorizontalTableViewScrollIndicatorPositionBottom:
        default:
            self.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, self.frame.size.height-10);
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
