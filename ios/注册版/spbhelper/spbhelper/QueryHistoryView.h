//
//  QueryHistoryView.h
//  spbhelper
//
//  Created by MrLovelyCbb on 15/4/23.
//  Copyright (c) 2015年 MrLovelyCbb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking/AFNetworking.h"
#import "QueryHistoryBusiness.h"

@interface QueryHistoryView : UIViewController <UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource,UIAlertViewDelegate,UIActionSheetDelegate>
{
    UIDatePicker *datePicker;
    NSLocale *datelocale;
}
@end
