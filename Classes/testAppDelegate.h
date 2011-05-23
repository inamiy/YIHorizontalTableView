//
//  testAppDelegate.h
//  test
//
//  Created by Andrew Gubanov on 5/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class testViewController;

@interface testAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    testViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet testViewController *viewController;

@end

