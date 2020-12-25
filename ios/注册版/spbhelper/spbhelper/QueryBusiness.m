//
//  QueryBusiness.m
//  spbhelper
//
//  Created by MrLovelyCbb on 15/4/23.
//  Copyright (c) 2015年 MrLovelyCbb. All rights reserved.
//

#import "QueryBusiness.h"

@implementation QueryBusiness


@synthesize btnBack = _btnBack;
@synthesize txtCurrentTime = _txtCurrentTime;

-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.txtCurrentTime.text = [Tools getCurrentTime:@"yyyy年MM月dd号"];
}


- (IBAction)btnBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

@end
