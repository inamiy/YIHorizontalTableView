//
//  YIHorizontalTableView.h
//  YIHorizontalTableView
//
//  Created by Yasuhiro Inami on 12/02/01.
//  Copyright 2011 Yasuhiro Inami. All rights reserved.
//

//
//  Ideas from: https://github.com/andrewgubanov/OrientedTableView
//
//  Created by Andrew Gubanov on 5/23/11.
//  Copyright 2011 Andrew Gubanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef enum {
    YIHorizontalTableViewScrollIndicatorPositionDefault = 0,
    YIHorizontalTableViewScrollIndicatorPositionTop,
    YIHorizontalTableViewScrollIndicatorPositionBottom = YIHorizontalTableViewScrollIndicatorPositionDefault
} YIHorizontalTableViewScrollIndicatorPosition;


@interface YIHorizontalTableView : UITableView <UITableViewDataSource> {
    id <UITableViewDataSource> _horizontalDataSource;
}

@property (nonatomic, assign) YIHorizontalTableViewScrollIndicatorPosition scrollIndicatorPosition;

@end
