//
//  RegisterView.m
//  spbhelper
//
//  Created by MrLovelyCbb on 15/4/27.
//  Copyright (c) 2015年 MrLovelyCbb. All rights reserved.
//

#import "RegisterView.h"
#import "Tools.h"

#define WEBSITE_URL_REG "http://app.youmsj.cn/zs/register.html"
#define WEBSITE_URL_GETCODE "http://app.youmsj.cn/zs/getcode.html"

@implementation RegisterView

@synthesize txtUname,txtUphone,txtUpwd,txtValidNum,btnBack,btnRegister;

static int validCode = 0;

- (void)viewDidAppear:(BOOL)animated
{
    // 判断定位操作是否被允许
    if ([CLLocationManager locationServicesEnabled] || self.locManager == nil){
        self.locManager = [[CLLocationManager alloc] init];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"定位不成功，请确认开启定位" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    // 兼容ios7 ios8以上需要用户授权请求地理位置
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        //如果没有授权则请求用户授权
        if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
            [self.locManager requestWhenInUseAuthorization];
        }
    }
    
    if ([self.suishpLocations count] == 0){
        [self locate];
    }
}

- (void)locate
{
    if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedWhenInUse  || [CLLocationManager locationServicesEnabled]){
        //设置代理
        self.locManager.delegate=self;
        //设置定位精度
        self.locManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        //定位频率,每隔多少米定位一次
        CLLocationDistance distance = kCLLocationAccuracyThreeKilometers;//3000米定位一次
        self.locManager.distanceFilter=distance;
        //启动跟踪定位
        [self.locManager startUpdatingLocation];
    }
}
// ios 6
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [self.suishpLocations addObject:[NSString  stringWithFormat:@"%.4f", newLocation.coordinate.latitude]];
    [self.suishpLocations addObject:[NSString stringWithFormat:@"%.4f", newLocation.coordinate.longitude]];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *currentLocation = [locations lastObject];
    
    // 获取当前所在城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    // 根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (placemarks.count > 0 && error == nil){
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            
            NSLog(@"位置名,%@",placemark.name);                                        // 位置名
            NSLog(@"街道,%@",placemark.thoroughfare);                                 // 街道
            NSLog(@"子街道,%@",placemark.subThoroughfare);                            // 子街道
            NSLog(@"市,%@",placemark.locality);                                      // 市
            NSLog(@"区,%@",placemark.subLocality);                                  // 区
            NSLog(@"国家,%@",placemark.country);                                    // 国家
            NSLog(@"经度 = %f",placemark.location.coordinate.longitude);           // 经度
            NSLog(@"纬度 = %f",placemark.location.coordinate.latitude);           // 纬度
            NSLog(@"eg = %@",placemark.administrativeArea);
            
            NSString *city = placemark.locality;
            
            if (!city){
                city = placemark.administrativeArea;
            }
            
            [self.suishpLocations addObject:[NSString stringWithFormat:@"%f",placemark.location.coordinate.latitude]];
            [self.suishpLocations addObject:[NSString stringWithFormat:@"%f",placemark.location.coordinate.longitude]];
            NSLog(@"city2:%@",city);
        }else if (error == nil && [placemarks count] == 0)
        {
            NSLog(@"No results were returned");
        }else if (error != nil){
            NSLog(@"An error occurred = %@",error);
        }
    }];
    
    
    [manager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    if (error.code == kCLErrorDenied) {
        // 提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
    }
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化坐标数组
    self.suishpLocations = [[NSMutableArray alloc] init];
    
    
    
    txtUname.delegate = self;
    txtUphone.delegate = self;
    txtUpwd.delegate = self;
    txtValidNum.delegate = self;
}
- (IBAction)btnBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

-(IBAction)backgroundTap:(id)sender {
    [txtUname resignFirstResponder];
    [txtUphone resignFirstResponder];
    [txtUpwd resignFirstResponder];
    [txtValidNum resignFirstResponder];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return [Tools validateNumber:string];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)btnRegisterClicked:(id)sender {
    
    if (![self validateRegister:txtUname.text phone:txtUphone.text code:txtValidNum.text pwd:txtUpwd.text]){
        return;
    }
    
    [SVProgressHUD showWithStatus:@"注册中..."];
    
    if ([self.suishpLocations count] == 0)
    {
        [self.suishpLocations addObject:@"118.182407"];
        [self.suishpLocations addObject:@"28.442222"];
    }

    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    
    NSDictionary *parameters = @{
                                 @"arr10":[NSString stringWithFormat:@"%@",txtUphone.text],
                                 @"arr11":[NSString stringWithFormat:@"%@",txtUpwd.text],
                                 @"arr12":[NSString stringWithFormat:@"%@",txtValidNum.text],
                                 @"arr13":[NSString stringWithFormat:@"%@",[self.suishpLocations objectAtIndex:1]],
                                 @"arr14":[NSString stringWithFormat:@"%@",[self.suishpLocations objectAtIndex:0]],
                                 @"arr15":[NSString stringWithFormat:@"%@",txtUname.text]};
    
    [manager GET:@WEBSITE_URL_REG parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"注册账号是否成功------%@",responseObject);
        
        NSString *status = [responseObject objectForKey:@"status"];
        
        if (status.intValue == 0) {
            NSString *b = [[[responseObject objectForKey:@"data"] objectForKey:@"info"] objectForKey:@"id"];
            [Tools saveUserDefaultValue:@"helperid" Valuestr:b];
            [SVProgressHUD showSuccessWithStatus:@"注册成功"];
            UIViewController *myLoginView = [self.storyboard instantiateViewControllerWithIdentifier:@"loginStoryboard"];
            [self.navigationController pushViewController:myLoginView animated:YES];
            // 删除坐标数组
            [self.suishpLocations removeAllObjects];
        }else {
            [SVProgressHUD showSuccessWithStatus:@"注册失败或可能已有账号"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showSuccessWithStatus:@"网络错误"];
    }];

}
- (IBAction)btnGetValidCode:(id)sender {
    [self getValidCode];
}

- (BOOL)validateRegister:(NSString *)uname phone:(NSString *)uphone code:(NSString *)validCodes pwd:(NSString *)txtPwd {
     MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if ([Tools isEmptyOrNull:uname]){
        [Tools showHUD:@"请输入用户名" andView:self.view andHUD:hud];
        return false;
    }
    if ([Tools isEmptyOrNull:uphone]){
        [Tools showHUD:@"请输入手机号" andView:self.view andHUD:hud];
        return false;
    }
    if (![Tools validateMobile:uphone]){
        [Tools showHUD:@"输入的手机号码不正确" andView:self.view andHUD:hud];
        return false;
    }
    if ([Tools validateMobile:validCodes]){
        [Tools showHUD:@"请输入短信验证码" andView:self.view andHUD:hud];
        return false;
    }
    if ([Tools isValidNumber:validCodes]){
        [Tools showHUD:@"请输入6位短信验证码" andView:self.view andHUD:hud];
        return false;
    }
    
    if (validCode != validCodes.integerValue){
        [Tools showHUD:@"输入的短信验证码不正确" andView:self.view andHUD:hud];
        return false;
    }
    
    if ([Tools isEmptyOrNull:txtPwd]){
        [Tools showHUD:@"请输入密码" andView:self.view andHUD:hud];
        return false;
    }
    
    [hud hide:true afterDelay:0.5];
    return true;
}

- (void)getValidCode {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if ([Tools isEmptyOrNull:txtUphone.text]) {
        [Tools showHUD:@"请输入手机号码" andView:self.view andHUD:hud];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:(SVProgressHUDMaskTypeGradient)];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSDictionary *parameters = @{
                                 @"arr10":[NSString stringWithFormat:@"%@",txtUphone.text],
                                 @"arr11":[NSString stringWithFormat:@"%d",1]
                                 };
    [manager POST:@WEBSITE_URL_GETCODE parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"获取短信是否成功------%@",responseObject);
        NSDictionary *data = [responseObject valueForKey:@"data"];
        NSString *status = [responseObject valueForKey:@"status"];
        if (status.intValue == 0){
            NSString *code = [data valueForKey:@"code"];
            validCode = code.intValue;
            [SVProgressHUD showSuccessWithStatus:@"获取成功"];
        }else{
            [SVProgressHUD showSuccessWithStatus:@"获取失败,此手机号已经注册过岁岁屏安"];
        }
        [hud hide:true];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"失败 %@",error);
        [SVProgressHUD showSuccessWithStatus:@"网络错误"];
        [hud hide:true];
    }];
}

@end
