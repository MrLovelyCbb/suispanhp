//
//  QueryHistoryBusiness.h
//  spbhelper
//
//  Created by MrLovelyCbb on 15/4/23.
//  Copyright (c) 2015年 MrLovelyCbb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableQueryCell.h"
#import "Tools.h"


@interface QueryHistoryBusiness : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    UIButton *_bottomRefresh;
    NSInteger _pageCount;
    NSInteger _pages;
    
}

//segue
@property (nonatomic,copy) NSString * txtStartDate;
@property (nonatomic,copy) NSString * txtEndDate;
@property (nonatomic,copy) NSString * queryTypes;
@property (nonatomic,copy) NSString * txtUname;
@property (nonatomic,copy) NSString * txtUphone;





@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UITableView *mytabview;
@property (weak, nonatomic) IBOutlet UILabel *txtQueryResult;

@property (strong,nonatomic) NSMutableArray *listData;
@property (strong,nonatomic) UIRefreshControl *refreshControl;
@property (strong,nonatomic) UITableViewCell *tableViewCell;

@end
