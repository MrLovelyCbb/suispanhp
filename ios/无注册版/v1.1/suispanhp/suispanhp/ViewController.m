//
//  ViewController.m
//  suispahp
//
//  Created by MrLovelyCbb on 15/3/10.
//  Copyright (c) 2015年 MrLovelyCbb. All rights reserved.
//


#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *mobileAllPicView;
@property (weak, nonatomic) IBOutlet UIButton *mobileIMEIPicView;
@property (weak, nonatomic) IBOutlet UITextField * txtUserName;
@property (weak, nonatomic) IBOutlet UITextField * txtTelPhoneNum;

-(IBAction)btnOne_Clicked:(id)sender;

-(IBAction)btnTwo_Clicked:(id)sender;

- (IBAction)btnUploadClicked:(id)sender;

@property (nonatomic) UIImagePickerController *imagePickerController;
@property (nonatomic) UIAlertView *alert;
@property (nonatomic) NSMutableArray *capturedImages;

@property (nonatomic,strong) CLLocationManager* locManager;

@property (nonatomic) NSMutableArray *suishpLocations;

@end

static int one_tagPic = 0;

@implementation ViewController

@synthesize txtUserName;
@synthesize txtTelPhoneNum;
@synthesize mobileAllPicView;
@synthesize mobileIMEIPicView;

+ (void)setTagPic:(int)tag
{
    one_tagPic = tag;
}

+ (int)getTagPic
{
    return one_tagPic;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 初始化数组
    self.capturedImages = [[NSMutableArray alloc] init];
    
    // 初始化坐标数组
    self.suishpLocations = [[NSMutableArray alloc] init];
    
    txtUserName.delegate = self;
    txtTelPhoneNum.delegate = self;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];  
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。  
    tapGestureRecognizer.cancelsTouchesInView = NO;  
    //将触摸事件添加到当前view  
    [self.view addGestureRecognizer:tapGestureRecognizer]; 
    
}

- (void)viewDidAppear:(BOOL)animated
{
    // 判断定位操作是否被允许
    if ([CLLocationManager locationServicesEnabled]){
        self.locManager = [[CLLocationManager alloc] init];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"定位不成功，请确认开启定位" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    //如果没有授权则请求用户授权
    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
        [self.locManager requestWhenInUseAuthorization];
    }
}

- (void)locate
{
    if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedWhenInUse){
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
            
//            NSString *apiUrl = [NSString stringWithFormat:@"%@%@%@",@"http://gc.ditu.aliyun.com/regeocoding?l=",[NSString stringWithFormat:@"%f,",placemark.location.coordinate.latitude],[NSString stringWithFormat:@"%f",placemark.location.coordinate.longitude]];
//            
//            NSLog(@"apiUrl:----%@",apiUrl);
            
//            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//            [manager POST:apiUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                NSString *requestTmp = [NSString stringWithString:operation.responseString];  
//                NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];  
//                //系统自带JSON解析  
//                NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
//                
//                NSDictionary *dic1 = [resultDic objectForKey:@"addrList"];
//                
//                [dic1 keyEnumerator]
//                for (NSObject *obj in dic1){
//                    NSLog(@"------%@",obj);
//                }
//                
//                NSLog(@"sucessful");
//            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                NSLog(@"Error %@",error);
//            }];
            
//            [self.suishpLocations addObject:[self convertNull:placemark.administrativeArea]];
//            [self.suishpLocations addObject:[self convertNull:city]];
//            [self.suishpLocations addObject:[self convertNull:placemark.subLocality]];
//            [self.suishpLocations addObject:[self convertNull:placemark.thoroughfare]];
//            [self.suishpLocations addObject:[self convertNull:placemark.postalCode]];
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

-(NSString*)convertNull:(id)object{ 
    
    // 转换空串
    
    if ([object isEqual:[NSNull null]]) {
        return @" ";
    }
    else if ([object isKindOfClass:[NSNull class]])
    {
        return @" ";
    }
    else if (object==nil){
        return @"无";
    }
    return object;
    
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    if (error.code == kCLErrorDenied) {
        // 提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
    }
}

- (IBAction)clickBackground:(id)sender {
    [sender endEditing:YES];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    int moveY = 0;
    if (textField == txtUserName){
        moveY = -230;
    }else if (textField == txtTelPhoneNum){
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

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self resumeView];
    return YES;
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{  
    [txtUserName resignFirstResponder];
    [txtTelPhoneNum resignFirstResponder];
    [self resumeView]; 
}  


-(IBAction)btnOne_Clicked:(id)sender
{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请选择手机机型图片" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从手机相册选择",nil];
//    [alert show];
//    
//    self.alert = alert;
    if ([self.suishpLocations count] == 0){
        [self locate];
    }
    
    [self getMediaFromSource:UIImagePickerControllerSourceTypeCamera];
    [ViewController setTagPic:200];
}

-(IBAction)btnTwo_Clicked:(id)sender
{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请选择手机串号图片" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从手机相册选择",nil];
//    [alert show];
//    
//    self.alert = alert;
    
    if ([self.suishpLocations count] == 0){
        [self locate];
    }
    
    [self getMediaFromSource:UIImagePickerControllerSourceTypeCamera];
    [ViewController setTagPic:300];
}


- (IBAction)btnUploadClicked:(id)sender {

    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"suispanHelper_one.png"];
    NSString *fullPath2 = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"suispanHelper_two.png"];
    
    BOOL blHave = [[NSFileManager defaultManager] fileExistsAtPath:fullPath];
    BOOL blHave2 = [[NSFileManager defaultManager] fileExistsAtPath:fullPath2];
    if (!blHave || !blHave2){
        MBProgressHUD *hud2 = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud2.mode = MBProgressHUDModeText;
        hud2.labelText = @"未选择上传图片...";
        hud2.margin = 10.f;
        hud2.removeFromSuperViewOnHide = YES;
        [hud2 hide:YES afterDelay:1.5];
        return;
    }
    
    NSString *userName = txtUserName.text;
    NSString *phoneNum = txtTelPhoneNum.text;
    
    if (userName.length <1){
        MBProgressHUD *hud3 = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud3.mode = MBProgressHUDModeText;
        hud3.labelText = @"用户名输入错误";
        hud3.margin = 10.f;
        hud3.removeFromSuperViewOnHide = YES;
        [hud3 hide:YES afterDelay:1.5];
        return;
    }
    
    if (phoneNum.length < 11){
        MBProgressHUD *hud4 = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud4.mode = MBProgressHUDModeText;
        hud4.labelText = @"手机号码小于11位";
        hud4.margin = 10.f;
        hud4.removeFromSuperViewOnHide = YES;
        [hud4 hide:YES afterDelay:1.5];
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.labelText = @"加载中...";
    hud.detailsLabelText = @"正在上传数据...";
    hud.square = YES;
    hud.dimBackground = YES;
    hud.delegate = self;
    
    if ([self.suishpLocations count] == 0)
    {
        [self.suishpLocations addObject:@"118.182407"];
        [self.suishpLocations addObject:@"28.442222"];
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{
                                 @"name":userName,
                                 @"phone":phoneNum,
                                 @"latitude":[self.suishpLocations objectAtIndex:0],
                                 @"longitude":[self.suishpLocations objectAtIndex:1]};
    NSURL *filePath = [NSURL fileURLWithPath:fullPath];
    NSURL *filePath2 = [NSURL fileURLWithPath:fullPath2];
    AFHTTPRequestOperation *operation = [manager POST:@"http://app.youmsj.cn/zs/index.html" parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileURL:filePath name:@"img1" fileName:@"suispanHelper_one.png" mimeType:@"image/jpeg" error:nil];
        [formData appendPartWithFileURL:filePath2 name:@"img2" fileName:@"suispanHelper_two.png" mimeType:@"image/jpeg" error:nil];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *infoStr = [responseObject valueForKey:@"info"];
        
        NSLog(@"success reponseobject%@",infoStr);
        [hud hide:YES];
        // 删除Image
        [self delImage:fullPath file_name:@"suispanHelper_one.png"];
        [self delImage:fullPath2 file_name:@"suispanHelper_two.png"];
        [mobileAllPicView setImage:[UIImage imageNamed:@"upload_icon"] forState:UIControlStateNormal];
        [mobileIMEIPicView setImage:[UIImage imageNamed:@"upload_icon"] forState:UIControlStateNormal];
        self.txtUserName.text = @"";
        self.txtTelPhoneNum.text = @"";
        [self.suishpLocations removeAllObjects];
        
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"提示信息" 
                                                       message:infoStr
                                                      delegate:self 
                                             cancelButtonTitle:@"确定" 
                                             otherButtonTitles:nil];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#define AAA 109

#pragma 拍照选择模块
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self shootPicturePrvideo];
    }else if (buttonIndex == 2) {
        [self selectExistingPictureOrVideo];
    }
}

#pragma 拍照模块
// 从相机上选择
-(void) shootPicturePrvideo {
    [self getMediaFromSource:UIImagePickerControllerSourceTypeCamera];
}

// 从相册中选择
-(void) selectExistingPictureOrVideo {
    [self getMediaFromSource:UIImagePickerControllerSourceTypePhotoLibrary];
}

#pragma 拍照及相册模块
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    [self.capturedImages addObject:image];
    
    // 如果是照相机 
    if (self.imagePickerController.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        // 存入系统相册
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                if ([ViewController getTagPic] == 200) {
                    [self saveImage:image withName:@"suispanHelper_one.png"];
                }else {
                    [self saveImage:image withName:@"suispanHelper_two.png"];
                }
            });
        });
    }else if (self.imagePickerController.sourceType == UIImagePickerControllerSourceTypePhotoLibrary)
    {
        if ([ViewController getTagPic] == 200) {
            [self saveImage:image withName:@"suispanHelper_one.png"];
        }else {
            [self saveImage:image withName:@"suispanHelper_two.png"];
        }
    }else {
        if ([ViewController getTagPic] == 200) {
            [self saveImage:image withName:@"suispanHelper_one.png"];
        }else {
            [self saveImage:image withName:@"suispanHelper_two.png"];
        }
    }
    
    [self finishAndUpdate];
}

// 结束并更新UI
- (void)finishAndUpdate
{
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    if ([self.capturedImages count] > 0)
    {
        if ([self.capturedImages count] == 1)
        {
            // 相机拍了一张照片
            if ([ViewController getTagPic] == 200) {
                [self.mobileAllPicView setImage:[self.capturedImages objectAtIndex:0] forState:UIControlStateNormal];
                 
            }else {
                [self.mobileIMEIPicView setImage:[self.capturedImages objectAtIndex:0] forState:UIControlStateNormal];
            }
        }
        
        // 为了重新开始，清除capturedImages数组
        [self.capturedImages removeAllObjects];
    }
    
    self.imagePickerController = nil;
    self.alert = nil;
}

// 取消选择
-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 选择类型操作
-(void)getMediaFromSource:(UIImagePickerControllerSourceType)sourceType
{
    if (self.capturedImages.count > 0)
    {
        [self.capturedImages removeAllObjects];
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.modalPresentationStyle = UIModalPresentationCurrentContext;
    picker.sourceType = sourceType;
    picker.delegate = self;
    
    self.imagePickerController = picker;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma 保存图片到document
-(void) saveImage:(UIImage *)image withName:(NSString *)imageName
{
    [self delImage:@"" file_name:imageName];
    
    // 图片上传质量
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    NSLog(@"%@",fullPath);
    [imageData writeToFile:fullPath atomically:NO];
    
    imageData = nil;
}

//- (void)hide:(BOOL)animated afterDelay:(NSTimeInterval)delay {
//    [self performSelector:@selector(hideDelayed:) withObject:[NSNumber numberWithBool:animated] afterDelay:delay];
//}

#pragma 删除Document图片
-(void) delImage:(NSString *)imagePath file_name:(NSString *)imageName
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *uniquePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:imageName];
    
    BOOL blHave = [[NSFileManager defaultManager] fileExistsAtPath:uniquePath];
    if (blHave) {
        BOOL blDelete = [fileManager removeItemAtPath:uniquePath error:nil];
        if (blDelete){
            NSLog(@"success Delete Function And Remove Object");
            fileManager = nil;
            paths = nil;
            uniquePath = nil;
        }
    }
}

// 改变图像的尺寸，方便上传服务器
- (UIImage *) scaleFromImage: (UIImage *) image toSize: (CGSize) size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

// 保存至系统相册回调函数
- (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo
{
//    UIAlertView *alert;
//    
//    if (error)
//    {
//        alert = [[UIAlertView alloc] initWithTitle:@"错误"
//                                           message:@"保存失败"
//                                          delegate:self cancelButtonTitle:@"确定"
//                                 otherButtonTitles:nil];
//    }
//    else
//    {
//        alert = [[UIAlertView alloc] initWithTitle:@"成功"
//                                           message:@"保存成功"
//                                          delegate:self cancelButtonTitle:@"确定"
//                                 otherButtonTitles:nil];
//    }
//    [alert show];
    
    // 保存至系统回调函数
}

-(void)showHUD:(NSString *)text addView:(UIView *)view addHUD:(MBProgressHUD *)hud
{
    [view addSubview:hud];
    hud.labelText  = text;
    hud.dimBackground = YES;
    hud.square = YES;
    [hud show:YES];
}

@end
