//
//  RegisterView.h
//  spbhelper
//
//  Created by MrLovelyCbb on 15/4/27.
//  Copyright (c) 2015年 MrLovelyCbb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tools.h"

@interface RegisterView : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,MBProgressHUDDelegate,UITextFieldDelegate,CLLocationManagerDelegate,UITableViewDataSource,UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UITextField *txtUname;
@property (weak, nonatomic) IBOutlet UITextField *txtUphone;
@property (weak, nonatomic) IBOutlet UITextField *txtValidNum;
@property (weak, nonatomic) IBOutlet UITextField *txtUpwd;
@property (weak, nonatomic) IBOutlet UIButton *btnRegister;

@property (nonatomic,strong) CLLocationManager* locManager;
@property (nonatomic) NSMutableArray *suishpLocations;

@end
