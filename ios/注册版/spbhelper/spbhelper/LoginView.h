//
//  LoginView.h
//  spbhelper
//
//  Created by MrLovelyCbb on 15/4/27.
//  Copyright (c) 2015年 MrLovelyCbb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tools.h"
@interface LoginView : UIViewController<UITextFieldDelegate,UIAlertViewDelegate>


@property (weak, nonatomic) IBOutlet UITextField *txtPhoneNum;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UIButton *btnRegister;

@property (nonatomic,copy) NSString * txtUpdateUrl;

@end
