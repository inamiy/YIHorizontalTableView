//
//  testViewController.h
//  test
//
//  Created by Andrew Gubanov on 5/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YIHorizontalTableView.h"

@interface testViewController : UIViewController <UITableViewDataSource>
{
    YIHorizontalTableView *_tableView;
}

@property (retain) IBOutlet YIHorizontalTableView *tableView;

@end

