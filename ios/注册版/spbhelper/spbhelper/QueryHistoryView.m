//
//  QueryHistoryView.m
//  spbhelper
//
//  Created by MrLovelyCbb on 15/4/23.
//  Copyright (c) 2015年 MrLovelyCbb. All rights reserved.
//

#import "QueryHistoryView.h"

@interface QueryHistoryView ()

@property (weak, nonatomic) IBOutlet UITextField *txtStartDate;
@property (weak, nonatomic) IBOutlet UITextField *txtEndDate;
@property (weak, nonatomic) IBOutlet UITextField *txtUname;
@property (weak, nonatomic) IBOutlet UITextField *txtUpwd;
@property (weak, nonatomic) IBOutlet UIButton *btnSheetMenu;
@property (weak, nonatomic) IBOutlet UIButton *btnQuery;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;

@end

static long someGlobalNSInteger = 1000;
static long queryType = 0;

@implementation QueryHistoryView

- (IBAction)btnSheetMenuClicked:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"查询类型" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"全部" otherButtonTitles:@"Boss业务",@"卡密业务", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
}
- (IBAction)btnBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btnQueryClicked:(id)sender {
    
    // 查询历史办理记录
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{
                                 @"arr10":@"",
                                 @"arr11":@"",
                                 @"arr12":@"",
                                 @"arr13":@"",
                                 @"arr14":@"",
                                 @"arr15":@""};

    AFHTTPRequestOperation *operation = [manager GET:@"" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //
    }];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        queryType = buttonIndex;
        [self.btnSheetMenu setTitle:@"全部" forState:UIControlStateNormal];
    }else if (buttonIndex == 1){
        queryType = buttonIndex;
        [self.btnSheetMenu setTitle:@"Boss业务" forState:UIControlStateNormal];
    }else if (buttonIndex == 2){
        queryType = buttonIndex;
        [self.btnSheetMenu setTitle:@"卡密业务" forState:UIControlStateNormal];
    }else if (buttonIndex ==3){
        queryType = 0;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.txtStartDate.delegate = self;
    self.txtEndDate.delegate = self;
    self.txtUname.delegate = self;
    self.txtUpwd.delegate = self;
    
    self.txtStartDate.tag = 1000;
    self.txtEndDate.tag = 1001;
    
    datePicker = [[UIDatePicker alloc]init];
    datelocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    datePicker.locale = datelocale;
    datePicker.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    datePicker.datePickerMode = UIDatePickerModeDate;
    
    _txtStartDate.inputView = datePicker;
    _txtEndDate.inputView = datePicker;
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(cancelPicker)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    toolBar.items = [NSArray arrayWithObjects:space,right, nil];
    
    _txtStartDate.inputAccessoryView = toolBar;
    _txtEndDate.inputAccessoryView = toolBar;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    [formatter setLocale:datelocale];
    
    _txtStartDate.text = [NSString stringWithFormat:@"%@",[formatter stringFromDate:datePicker.date]];
    _txtEndDate.text = [NSString stringWithFormat:@"%@",[formatter stringFromDate:datePicker.date]];
    
    [datePicker addTarget:self action:@selector(showDate:) forControlEvents:(UIControlEventValueChanged)];
} 

-(void) showDate:(UIDatePicker *)datesPicker {
    NSDate *date = datesPicker.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    if (someGlobalNSInteger == 1000){
        _txtStartDate.text = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    }else if (someGlobalNSInteger == 1001){
        _txtEndDate.text = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    }
}

-(void) cancelPicker {
    if ([self.view endEditing:NO]) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd";
        [formatter setLocale:datelocale];

        if (someGlobalNSInteger == 1000){
            _txtStartDate.text = [NSString stringWithFormat:@"%@",[formatter stringFromDate:datePicker.date]];
        }else if (someGlobalNSInteger == 1001){
            _txtEndDate.text = [NSString stringWithFormat:@"%@",[formatter stringFromDate:datePicker.date]];
        }
    }
}

-(void) textFieldDidBeginEditing:(UITextField *)textField {
    someGlobalNSInteger = textField.tag;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    if (someGlobalNSInteger == 1000){
        _txtStartDate.text = [NSString stringWithFormat:@"%@",[formatter stringFromDate:datePicker.date]];
    }else if (someGlobalNSInteger == 1001){
        _txtEndDate.text = [NSString stringWithFormat:@"%@",[formatter stringFromDate:datePicker.date]];
    } 
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"Source Controller = %@",[segue sourceViewController]);
    
    NSLog(@"Destinatoin Controller = %@",[segue destinationViewController]);
    
    if ([[segue identifier] isEqualToString:@"historyresult2"]) {
        QueryHistoryBusiness *viewController = [segue destinationViewController];
        
        NSLog(@"startTime = %@",self.txtStartDate.text);
        NSLog(@"endTime = %@",self.txtEndDate.text);
        viewController.txtStartDate = self.txtStartDate.text;
        viewController.txtEndDate = self.txtEndDate.text;
        viewController.queryTypes = [NSString stringWithFormat:@"%ld",queryType];
        viewController.txtUname = self.txtUname.text;
        viewController.txtUphone = self.txtUpwd.text;
    }
}

@end
