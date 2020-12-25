//
//  QueryTodayBusiness.m
//  spbhelper
//
//  Created by MrLovelyCbb on 15/4/23.
//  Copyright (c) 2015年 MrLovelyCbb. All rights reserved.
//

#import "QueryTodayBusiness.h"

#define RRowCount 100
#define RCellHeight 50

@implementation QueryTodayBusiness

@synthesize listData = _listData;
@synthesize today_tbview = _tableView;
@synthesize tableViewCell = _tableViewCell;
@synthesize txtDataNum = _txtDataNum;
@synthesize refreshControl = _refreshControl;
@synthesize btnBack = _btnBack;


- (IBAction)btnBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) pullToRefresh
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"刷新中"];
    
    double delayInSeconds = 0.8;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int16_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
       
        _pages++;
        [self getQueryTodayData];
        
        
        self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
    });
}

-(void) upToRefresh
{
    _bottomRefresh.enabled = NO;
    [SVProgressHUD showWithStatus:@"加载中..."];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    double delayInSeconds = 0.8;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        _pages++;
        [self getQueryTodayData];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    });

}

-(void) viewDidLoad {
    
    [super viewDidLoad];
    
    self.today_tbview.delegate = self;
    self.today_tbview.dataSource = self;
    _pages = 1;
    _pageCount = 100;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
    [self.refreshControl addTarget:self action:@selector(pullToRefresh) forControlEvents:UIControlEventValueChanged];
    [self.today_tbview addSubview:self.refreshControl];
    
    _bottomRefresh = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bottomRefresh setTitle:@"查看更多" forState:UIControlStateNormal];
    [_bottomRefresh setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_bottomRefresh setContentEdgeInsets:UIEdgeInsetsMake(15, 0, 0, 0)];
    [_bottomRefresh addTarget:self action:@selector(upToRefresh) forControlEvents:UIControlEventTouchUpInside];
    _bottomRefresh.frame = CGRectMake(0, _pageCount*RCellHeight, 320, RCellHeight);
    [self.today_tbview addSubview:_bottomRefresh];
    
    [self getQueryTodayData];
}

-(void) getQueryTodayData
{
    // 查询今日办理记录       arr10 营业员ID
    //                     arr11 业务类型   0全部  1 Boss业务 2 卡密业务
    [SVProgressHUD showWithStatus:@"加载中..."];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSLog(@"营业员ID = %@",[NSString stringWithFormat:@"%@",[Tools getUserDefaultValue:@"helperid"]]);
    NSDictionary *parameters = @{
                                 @"arr10":[NSString stringWithFormat:@"%@",[Tools getUserDefaultValue:@"helperid"]],
                                 @"arr11":@"0"
                                 }; // 全部
    
    [manager GET:@"http://app.youmsj.cn/zs/todayOrder.html" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"---------dsfdsfdsfds--%@",responseObject);
        
        NSString *status = [responseObject valueForKey:@"status"];
        id ns = [[responseObject valueForKey:@"data"] valueForKey:@"data"];
        if (status.intValue == 0 && ![Tools isEmptyOrNull:[Tools convertNull:ns]]) {
            self.listData = [[responseObject valueForKey:@"data"] valueForKey:@"data"];
            _pageCount = [self.listData count];
            self.txtDataNum.text = [NSString stringWithFormat:@"查询结果(%ld人)",(long)_pageCount];
            _bottomRefresh.frame = CGRectMake(0, (_pageCount*RCellHeight) - 10, 320, RCellHeight);
            _bottomRefresh.enabled = YES;
            [SVProgressHUD showSuccessWithStatus:self.txtDataNum.text];
        }else{
            self.txtDataNum.text = [NSString stringWithFormat:@"查询结果(%d人)",0];
            [SVProgressHUD showSuccessWithStatus:self.txtDataNum.text];
        }
        [self.today_tbview reloadData];
        [self.refreshControl endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络错误"];
    }];
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    _pageCount = [self.listData count];
    
    return _pageCount + 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [self.listData count])
    {
        UITableViewCell *loadMoreCell = [[UITableViewCell alloc] init];
        return loadMoreCell;
    }
    static NSString *cellid = @"myquerycell";
    TableQueryCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    
    if (_pageCount <= [self.listData count]) {
        
    NSDictionary *tempDictionary = [self.listData objectAtIndex:indexPath.row];
    cell.txtuname.text = [tempDictionary objectForKey:@"uname"];
    cell.txtnumber.text = [tempDictionary objectForKey:@"uphone"];
        // 类型
        NSString *types = [tempDictionary objectForKey:@"yw_type"];
    cell.txtservices.text = [Tools getYwTypeStr:types.intValue];
    cell.txtdates.text = [tempDictionary objectForKey:@"add_time"];
    }
    
    return cell;
}


-(void) loadMore {
    NSMutableArray *more;
    [self performSelectorOnMainThread:@selector(appendTableWith:) withObject:more waitUntilDone:NO];
}

-(void) appendTableWith:(NSMutableArray *)data
{
    for (int i=0; [data count]; i++) {
        [self.listData addObject:[data objectAtIndex:i]];
    }
    NSMutableArray *insertIndexPaths = [NSMutableArray arrayWithCapacity:100];
    for (int ind = 0; [data count]; ind++) {
        NSIndexPath *newPath = [NSIndexPath indexPathForRow:[self.listData indexOfObject:[data objectAtIndex:ind]] inSection:0];
        [insertIndexPaths addObject:newPath];
    }
    [self.today_tbview insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationFade];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

// 单元格高度
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return RCellHeight;
}
// 设置单元格缩进
-(NSInteger) tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    if (row % 2 == 0) {
        return 0;
    }
    return 0;
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSInteger row = [indexPath row];
//    NSString *rowValue = [self.listData objectAtIndex:row];
//    NSString *message = [[NSString alloc] initWithFormat:@"You selected%@",rowValue];
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    [alert show];
}


@end
