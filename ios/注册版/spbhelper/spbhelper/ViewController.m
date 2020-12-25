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
@property (weak, nonatomic) IBOutlet UITableView * mytabView;
@property (weak, nonatomic) IBOutlet UIButton *btnLogout;

-(IBAction)btnOne_Clicked:(id)sender;

-(IBAction)btnTwo_Clicked:(id)sender;

- (IBAction)btnUploadClicked:(id)sender;

@property (nonatomic) UIImagePickerController *imagePickerController;
@property (nonatomic) UIAlertView *alert;
@property (nonatomic) NSMutableArray *capturedImages;


@property (nonatomic) NSMutableArray *listData;

@end

static int one_tagPic = 0;

@implementation ViewController

@synthesize txtUserName;
@synthesize txtTelPhoneNum;
@synthesize mobileAllPicView;
@synthesize mobileIMEIPicView;
@synthesize mytabView;
@synthesize txtUpdateUrl;
@synthesize listData = _listData;

+ (void)setTagPic:(int)tag
{
    one_tagPic = tag;
}

+ (int)getTagPic
{
    return one_tagPic;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self ReqUpdateInfo];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 初始化数组
    self.capturedImages = [[NSMutableArray alloc] init];
    
    txtUserName.delegate = self;
    txtTelPhoneNum.delegate = self;
    
    mytabView.delegate = self;
    mytabView.dataSource = self;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];  
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。  
    tapGestureRecognizer.cancelsTouchesInView = NO;  
    //将触摸事件添加到当前view  
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    
    // 请求公告列表
    [self reqScrollView];
}

- (IBAction)clickBackground:(id)sender {
    [sender endEditing:YES];
}
- (IBAction)btnLogoutClicked:(id)sender {
    UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"提示信息" 
                                                   message:@"是否要注销当前登录账号"
                                                  delegate:self 
                                         cancelButtonTitle:@"取消" 
                                         otherButtonTitles:@"注销", nil];
    alert.tag = 999;
    [alert show];
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
    
    [self getMediaFromSource:UIImagePickerControllerSourceTypeCamera];
    [ViewController setTagPic:200];
}

-(IBAction)btnTwo_Clicked:(id)sender
{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请选择手机串号图片" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从手机相册选择",nil];
//    [alert show];
//    
//    self.alert = alert;
    
    
    [self getMediaFromSource:UIImagePickerControllerSourceTypeCamera];
    [ViewController setTagPic:300];
}


- (IBAction)btnUploadClicked:(id)sender {

    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"suispanHelper_one.png"];
    NSString *fullPath2 = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"suispanHelper_two.png"];
    
    NSString *userName = txtUserName.text;
    NSString *phoneNum = txtTelPhoneNum.text;
    
    if (![self validDataForm:fullPath path2:fullPath2]) {
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.labelText = @"加载中...";
    hud.detailsLabelText = @"正在上传数据...";
    hud.square = YES;
    hud.dimBackground = YES;
    hud.delegate = self;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{
                                 @"name":userName,
                                 @"phone":phoneNum,
                                 @"saleId":[Tools getUserDefaultValue:@"helperid"]};
    
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
    if (alertView.tag == 2000) {
        NSString *button = [alertView buttonTitleAtIndex:buttonIndex];
        if ([button  isEqual: @"更新"]) {
            // 跳转至网页
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:txtUpdateUrl]];
        }
    }else if (alertView.tag == 999)
    {
        NSString *button = [alertView buttonTitleAtIndex:buttonIndex];
        if ([button isEqual: @"注销"]) {
            NSUserDefaults *nd = [NSUserDefaults standardUserDefaults];
            [nd setBool:false forKey:@"isLogin"];
            [nd setObject:@"" forKey:@"helperid"];
            [nd synchronize];
            UIViewController *myLoginView = [self.storyboard instantiateViewControllerWithIdentifier:@"loginStoryboard"];
            [self.navigationController pushViewController:myLoginView animated:NO];
        }
    }else{
        if (buttonIndex == 1) {
            [self shootPicturePrvideo];
        }else if (buttonIndex == 2) {
            [self selectExistingPictureOrVideo];
        }
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellid = @"mysystemcell";
    TableSystemCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    NSDictionary *tempDictionary = [self.listData objectAtIndex:indexPath.row];
    cell.mysysTxt.text = [NSString stringWithFormat:@"%ld.%@",(long)indexPath.row + 1,[tempDictionary objectForKey:@"title"]];
    
    return cell;
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listData.count;
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
        
        //0 不更新  1 更新
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

-(void)reqScrollView {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    // arr10 1 安卓 2苹果 3苹果企业版   arr11 0 老版本(注册的版本)  1 新版本(没注册的版本)
    NSDictionary *parameters = @{
                                 @"arr10":@"3",
                                 @"arr11":@"1"};
    
    [manager GET:@"http://app.youmsj.cn/zs/notice.html" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *status = [responseObject objectForKey:@"status"];
        
        if (status.intValue == 0) {
            self.listData = [responseObject objectForKey:@"data"];
            [mytabView reloadData];
        }else{
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络错误"];
    }];

}

-(BOOL)validDataForm:(NSString *)fullPath path2:(NSString *)fullPath2
{
    BOOL blHave = [[NSFileManager defaultManager] fileExistsAtPath:fullPath];
    BOOL blHave2 = [[NSFileManager defaultManager] fileExistsAtPath:fullPath2];
    if (!blHave || !blHave2){
        MBProgressHUD *hud2 = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud2.mode = MBProgressHUDModeText;
        hud2.labelText = @"未选择上传图片...";
        hud2.margin = 10.f;
        hud2.removeFromSuperViewOnHide = YES;
        [hud2 hide:YES afterDelay:1.5];
        return false;
    }
    
    NSString *userName = txtUserName.text;
    NSString *phoneNum = txtTelPhoneNum.text;
    
    if ([Tools isEmptyOrNull:userName]){
        MBProgressHUD *hud3 = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud3.mode = MBProgressHUDModeText;
        hud3.labelText = @"请输入用户名";
        hud3.margin = 10.f;
        hud3.removeFromSuperViewOnHide = YES;
        [hud3 hide:YES afterDelay:1.5];
        return false;
    }
    
    if ([Tools isEmptyOrNull:phoneNum] || [Tools isValidNumber:phoneNum]){
        MBProgressHUD *hud4 = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud4.mode = MBProgressHUDModeText;
        hud4.labelText = @"手机号码错误";
        hud4.margin = 10.f;
        hud4.removeFromSuperViewOnHide = YES;
        [hud4 hide:YES afterDelay:1.5];
        return false;
    }
    
    return true;
}

- (IBAction)btnGoPayClicked:(id)sender {
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"suispanHelper_one.png"];
    NSString *fullPath2 = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"suispanHelper_two.png"];
    
    if (![self validDataForm:fullPath path2:fullPath2]) {
        return;
    }
    
    PayViewController *myView = [self.storyboard instantiateViewControllerWithIdentifier:@"payStoryboard"];
    myView.txtImgPath = fullPath;
    myView.txtImgPath2 = fullPath2;
    myView.txtUname = self.txtUserName.text;
    myView.txtUphone = self.txtTelPhoneNum.text;
    
    [self.navigationController pushViewController:myView animated:YES];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"payIdentifiter"]) {
        PayViewController *viewController = [segue destinationViewController];
        
        NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"suispanHelper_one.png"];
        NSString *fullPath2 = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"suispanHelper_two.png"];
        
        viewController.txtImgPath = fullPath;
        viewController.txtImgPath2 = fullPath2;
        viewController.txtUname = self.txtUserName.text;
        viewController.txtUphone = self.txtTelPhoneNum.text;
    }
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
