//
//  ResetPasswordView.m
//  spbhelper
//
//  Created by MrLovelyCbb on 15/4/27.
//  Copyright (c) 2015年 MrLovelyCbb. All rights reserved.
//

#import "ResetPasswordView.h"

#define WEBSITE_URL_PWD "http://app.youmsj.cn/zs/forgetPassword.html"

@implementation ResetPasswordView

@synthesize txtNewPwd,txtPhoneNum,txtValidCode,btnBack,btnResetPwd;

static long validCode = 0;

-(void) viewDidLoad {
    [super viewDidLoad];
    
    txtNewPwd.delegate = self;
    txtPhoneNum.delegate = self;
    txtValidCode.delegate = self;
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)btnGetValidCodeClicked:(id)sender {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if ([Tools isEmptyOrNull:txtPhoneNum.text]) {
        [Tools showHUD:@"请输入手机号码" andView:self.view andHUD:hud];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:(SVProgressHUDMaskTypeGradient)];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSDictionary *parameters = @{
                                 @"arr10":[NSString stringWithFormat:@"%@",txtPhoneNum.text],
                                 @"arr11":[NSString stringWithFormat:@"%d",2]
                                 };
    [manager POST:@"http://app.youmsj.cn/zs/getcode.html" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"获取短信是否成功------%@",responseObject);
        NSDictionary *data = [responseObject valueForKey:@"data"];
        NSString *status = [responseObject valueForKey:@"status"];
        if (status.intValue == 0){
            NSString *code = [data valueForKey:@"code"];
            validCode = code.intValue;
            [SVProgressHUD showSuccessWithStatus:@"获取成功"];
        }else{
            [SVProgressHUD showSuccessWithStatus:@"短信获取失败"];
        }
        [hud hide:true];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"失败 %@",error);
        [SVProgressHUD showSuccessWithStatus:@"网络错误"];
        [hud hide:true];
    }];

}

- (IBAction)backgroundTap:(id)sender {
    [txtValidCode resignFirstResponder];
    [txtNewPwd resignFirstResponder];
    [txtPhoneNum resignFirstResponder];
}

- (IBAction)btnBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}
- (IBAction)btnResetClicked:(id)sender {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if ([Tools isEmptyOrNull:txtPhoneNum.text]) {
        [Tools showHUD:@"请输入手机号码" andView:self.view andHUD:hud];
        return;
    }
    if ([Tools isEmptyOrNull:txtNewPwd.text]) {
        [Tools showHUD:@"请输入新密码" andView:self.view andHUD:hud];
        return;
    }
    if ([Tools isEmptyOrNull:txtValidCode.text]) {
        [Tools showHUD:@"请输入短信验证码" andView:self.view andHUD:hud];
        return;
    }
    if (validCode != txtValidCode.text.integerValue){
        [Tools showHUD:@"输入的短信验证码不正确" andView:self.view andHUD:hud];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"正在修改中..." maskType:(SVProgressHUDMaskTypeGradient)];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSDictionary *parameters = @{
                                 @"arr10":[NSString stringWithFormat:@"%@",txtPhoneNum.text],
                                 @"arr11":[NSString stringWithFormat:@"%@",txtNewPwd.text],
                                 @"arr12":[NSString stringWithFormat:@"%@",txtValidCode.text]};
    
    [manager GET:@WEBSITE_URL_PWD parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"重置密码是否成功------%@",responseObject);
        NSString *status = [responseObject objectForKey:@"status"];
        
        if (status.intValue == 0){
            UIViewController *myLoginView = [self.storyboard instantiateViewControllerWithIdentifier:@"loginStoryboard"];
            [self.navigationController pushViewController:myLoginView animated:YES];           
            [SVProgressHUD showSuccessWithStatus:@"密码重置成功"];
        }else{
            [SVProgressHUD showSuccessWithStatus:@"密码重置失败"];
        }
        
        [hud hide:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"网络错误 ------%@",error);
        [hud hide:YES];
        [SVProgressHUD showSuccessWithStatus:@"网络错误"];
    }];
}

@end
