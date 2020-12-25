//
//  PayViewController.m
//  spbhelper
//
//  Created by MrLovelyCbb on 15/4/23.
//  Copyright (c) 2015年 MrLovelyCbb. All rights reserved.
//

#import "PayViewController.h"

@implementation PayViewController

@synthesize btnBack,btnBack2;
@synthesize txtPrice,txtService;
@synthesize mytabView;
@synthesize txtExchangeStr = _txtExchangeStr;

@synthesize txtUname = _txtUname;
@synthesize txtUphone = _txtUphone;
@synthesize txtImgPath = _txtImgPath;
@synthesize txtImgPath2 = _txtImgPath2;


-(void)viewDidLoad 
{
    [super viewDidLoad];
    
    mytabView.delegate = self;
    mytabView.dataSource = self;
}


- (IBAction)btnBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

- (IBAction)btnBack2Clicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btnConfirmClicked:(id)sender {
    [self payExchange];
}

- (void)payExchange {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"输入兑换码" message:@"请输入兑换码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"兑换", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *tf = [alert textFieldAtIndex:0];
    tf.keyboardType = UIKeyboardTypeNumberPad;
    
    alert.tag = 111;
    
    [alert show];
}

- (void)requestExchange {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if ([Tools isEmptyOrNull:self.txtExchangeStr]) {
        [Tools showHUD:@"请输入兑换码" andView:self.view andHUD:hud];
        return;
    }
    
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.labelText = @"加载中...";
    hud.detailsLabelText = @"正在上传数据...";
    hud.square = YES;
    hud.dimBackground = YES;
    hud.delegate = self;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{
                                 @"name":self.txtUname,
                                 @"phone":self.txtUphone,
                                 @"saleId":[NSString stringWithFormat:@"%@",[Tools getUserDefaultValue:@"helperid"]],
                                 @"cnum":[NSString stringWithFormat:@"%@",self.txtExchangeStr]};
    NSLog(@"支付。。。。。参数  = %@",parameters);
    AFHTTPRequestOperation *operation = [manager POST:@"http://app.youmsj.cn/zs/index.html" parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:self.txtImgPath] name:@"img1" fileName:@"suispanHelper_one.png" mimeType:@"image/jpeg" error:nil];
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:self.txtImgPath2] name:@"img2" fileName:@"suispanHelper_two.png" mimeType:@"image/jpeg" error:nil];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *infoStr = [responseObject valueForKey:@"info"];
        
        NSLog(@"success reponseobject%@",infoStr);
        [hud hide:YES];
        
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"提示信息" 
                                                       message:infoStr
                                                      delegate:self 
                                             cancelButtonTitle:@"确定" 
                                             otherButtonTitles:nil];
        alert.tag = 222;
        [alert show];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@ ", error);
        hud.labelText = @"加载中...";
        hud.detailsLabelText = @"数据上传错误...";
        [hud hide:YES afterDelay:3.0];
    }];
    
    
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        hud.progress = totalBytesWritten*1.0/totalBytesExpectedToWrite;
        //        NSLog(@"百分比:%f",totalBytesWritten*1.0/totalBytesExpectedToWrite);
    }];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:mytabView]) {
        if ([indexPath row] == 0) {
            [self payExchange];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 111) {
        NSString *button = [alertView buttonTitleAtIndex:buttonIndex];
        if ([button  isEqual: @"兑换"]) {
           self.txtExchangeStr = [[alertView textFieldAtIndex:0] text];
            NSLog(@"数值.....%@",self.txtExchangeStr);
            // 发送兑换请求
            [self requestExchange];
        }
    }
    if (alertView.tag == 222) {
        [Tools delImage:self.txtImgPath file_name:@"suispanHelper_one.png"];
        [Tools delImage:self.txtImgPath2 file_name:@"suispanHelper_two.png"];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.textLabel.text = @"岁岁屏安卡";
    return cell;
}

@end
