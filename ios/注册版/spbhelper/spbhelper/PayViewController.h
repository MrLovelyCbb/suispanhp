//
//  PayViewController.h
//  spbhelper
//
//  Created by MrLovelyCbb on 15/4/23.
//  Copyright (c) 2015年 MrLovelyCbb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tools.h"

@interface PayViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,MBProgressHUDDelegate>

// segue
@property (nonatomic,copy) NSString * txtImgPath;
@property (nonatomic,copy) NSString * txtImgPath2;
@property (nonatomic,copy) NSString * txtUname;
@property (nonatomic,copy) NSString * txtUphone;


@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UIButton *btnBack2;
@property (weak, nonatomic) IBOutlet UILabel *txtService;
@property (weak, nonatomic) IBOutlet UILabel *txtPrice;
@property (weak, nonatomic) IBOutlet UITableView *mytabView;
@property (weak, nonatomic) IBOutlet UIButton *btnConfirm;

@property (strong,nonatomic) NSString * txtExchangeStr;

@end
