//
//  LoginView.m
//  spbhelper
//
//  Created by MrLovelyCbb on 15/4/27.
//  Copyright (c) 2015年 MrLovelyCbb. All rights reserved.
//

#import "LoginView.h"

@implementation LoginView

@synthesize txtPassword,txtPhoneNum,btnLogin,btnRegister;
@synthesize txtUpdateUrl;
-(void)viewWillAppear:(BOOL)animated
{
    [self ReqUpdateInfo];
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    txtPassword.delegate = self;
    txtPhoneNum.delegate = self;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];  
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。  
    tapGestureRecognizer.cancelsTouchesInView = NO;  
    //将触摸事件添加到当前view  
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
}


- (void)ReqUpdateInfo{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{
                                 @"ver":[NSString stringWithFormat:@"%d",2],
                                 @"mach":[NSString stringWithFormat:@"%d",3],
                                 @"new":[NSString stringWithFormat:@"%d",0]
                                 };
    [manager POST:@"http://app.youmsj.cn/zs/update.html" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *upstate = [[responseObject objectForKey:@"data"] objectForKey:@"upstate"];
        NSString *upinfo = [[responseObject objectForKey:@"data"] objectForKey:@"info"];
        
        // 0不更新  1更新
        if (upstate.intValue == 1)
        {
            txtUpdateUrl = [[responseObject objectForKey:@"data"] objectForKey:@"url"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新 提示" message:upinfo delegate:self cancelButtonTitle:@"暂不更新" otherButtonTitles:@"更新", nil];
            alert.tag = 2000;
            [alert show];
        }
        
        NSLog(@"responseObject Data ===== %@",upstate);
        //
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //
    }];
     
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 2000) {
        NSString *button = [alertView buttonTitleAtIndex:buttonIndex];
        if ([button  isEqual: @"更新"]) {
           // 跳转至网页
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:txtUpdateUrl]];
        }
    }
}


- (IBAction)btnLoginClicked:(id)sender {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if ([Tools isEmptyOrNull:txtPhoneNum.text]) {
        [Tools showHUD:@"请输入手机号码" andView:self.view andHUD:hud];
        return;
    }
    if (![Tools validateMobile:txtPhoneNum.text]) {
        [Tools showHUD:@"请输入正确手机号码" andView:self.view andHUD:hud];
        return;
    }
    if ([Tools isEmptyOrNull:txtPassword.text]) {
        [Tools showHUD:@"请输入密码" andView:self.view andHUD:hud];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:(SVProgressHUDMaskTypeGradient)];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSDictionary *parameters = @{
                                 @"arr10":[NSString stringWithFormat:@"%@",txtPhoneNum.text],
                                 @"arr11":[NSString stringWithFormat:@"%@",txtPassword.text]
                                 };
    [manager POST:@"http://app.youmsj.cn/zs/login.html" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"登录是否成功------%@",responseObject);
        
        NSString *status = [responseObject objectForKey:@"status"];
        if (status.intValue == 0){
            NSString *helpid = [[[responseObject objectForKey:@"data"] objectForKey:@"userInfo"] objectForKey:@"id"];
            [Tools saveUserDefaultValue:@"helperid" Valuestr:helpid];
            NSUserDefaults *nd = [NSUserDefaults standardUserDefaults];
            [nd setBool:true forKey:@"isLogin"];
            [nd synchronize];
            UIViewController *myMainView = [self.storyboard instantiateViewControllerWithIdentifier:@"mainStoryboard"];
            [self.navigationController pushViewController:myMainView animated:NO];
            [SVProgressHUD showSuccessWithStatus:@"登录成功"];
        }else{
            [SVProgressHUD showSuccessWithStatus:@"密码错误"];
        }
        
        [hud hide:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"失败 %@",error);
        [hud hide:YES];
        [SVProgressHUD showSuccessWithStatus:@"网络错误"];
    }];

}

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self resumeView];
    return YES;
}

-(IBAction)backgroupTap:(id)sender
{
    [txtPhoneNum resignFirstResponder];
    [txtPassword resignFirstResponder];
}

- (IBAction)clickBackground:(id)sender {
    [sender endEditing:YES];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    int moveY = 0;
    if (textField == txtPhoneNum){
        moveY = -230;
    }else if (textField == txtPassword){
        moveY = -215;
    }
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    CGRect rect = CGRectMake(0.0f, moveY, width, height);
    self.view.frame = rect;
    return YES;
}

-(void) resumeView{
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    float y = 0.0f;
    CGRect rect = CGRectMake(0.0f, y, width, height);
    self.view.frame = rect;
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{  
    [txtPhoneNum resignFirstResponder];
    [txtPassword resignFirstResponder];
    [self resumeView]; 
}  

@end
