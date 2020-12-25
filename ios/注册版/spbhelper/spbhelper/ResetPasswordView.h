//
//  ResetPasswordView.h
//  spbhelper
//
//  Created by MrLovelyCbb on 15/4/27.
//  Copyright (c) 2015年 MrLovelyCbb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tools.h"

@interface ResetPasswordView : UIViewController<UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UITextField *txtPhoneNum;
@property (weak, nonatomic) IBOutlet UITextField *txtValidCode;
@property (weak, nonatomic) IBOutlet UITextField *txtNewPwd;
@property (weak, nonatomic) IBOutlet UIButton *btnResetPwd;

@end
