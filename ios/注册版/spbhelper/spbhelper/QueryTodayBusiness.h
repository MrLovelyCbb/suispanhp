//
//  QueryTodayBusiness.h
//  spbhelper
//
//  Created by MrLovelyCbb on 15/4/23.
//  Copyright (c) 2015年 MrLovelyCbb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableQueryCell.h"
#import "Tools.h"

@interface QueryTodayBusiness : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    UIButton *_bottomRefresh;
    NSInteger _pageCount;
    NSInteger _pages;
}
@property (weak, nonatomic) IBOutlet UITableView *today_tbview;
@property (weak, nonatomic) IBOutlet UILabel *txtDataNum;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;

@property (strong,nonatomic) NSMutableArray *listData;
@property (strong,nonatomic) UITableViewCell *tableViewCell;

@property (strong,nonatomic) UIRefreshControl *refreshControl;


@end
