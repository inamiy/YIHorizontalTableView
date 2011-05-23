//
//  testViewController.h
//  test
//
//  Created by Andrew Gubanov on 5/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGOrientedTableView.h"

@interface testViewController : UIViewController <UITableViewDataSource>
{
AGOrientedTableView *_tableView;
}

@property (retain) IBOutlet AGOrientedTableView *tableView;

@end

