//
//  Tools.m
//  spbhelper
//
//  Created by MrLovelyCbb on 15/4/27.
//  Copyright (c) 2015年 MrLovelyCbb. All rights reserved.
//

#import "Tools.h"

@implementation Tools

/**
    helperid 营业员ID
 
 
 
 
 */


+ (void)showHUD:(NSString *)text andView:(UIView *)view andHUD:(MBProgressHUD *)hud
{
    [view addSubview:hud];
    hud.mode = MBProgressHUDModeText;
    hud.removeFromSuperViewOnHide = YES;
    hud.labelText = text;
    //hud.dimBackground = YES;
    [hud hide:YES afterDelay:1.5];
}

#pragma 删除Document图片
+ (void) delImage:(NSString *)imagePath file_name:(NSString *)imageName
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

+ (NSString*)convertNull:(id)object
{ 
    
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

#pragma 是否为空
+ (BOOL)isEmptyOrNull:(NSString *)str 
{
    if (!str) {
        return true;
    }else {
        // 兼容 数组
        if ([str isKindOfClass:[NSArray class]] || [str isKindOfClass:[NSDictionary class]])
        {
            return false;
        }
        NSString *trimedString = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([trimedString length] == 0 || str == NULL || str == nil) {
            return true;
        }else{
            return false;
        }
    }
}

#pragma 获取当前时间  yyyy-MM-dd HH:mm:ss  yyyy年MM月dd号
+ (NSString *)getCurrentTime:(NSString *)formatStr
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatStr];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}

+ (NSString *)getYwTypeStr:(int)type
{
    switch (type) {
        case 1:
            return @"boss业务";
        case 2:
            return @"卡密业务";
    }
    return @"未知业务";
}

#pragma 保存Userdefault值
+ (void)saveUserDefaultValue:(NSString *)workKey Valuestr:(NSString *)value
{
    NSUserDefaults *nd = [NSUserDefaults standardUserDefaults];
    [nd setObject:value forKey:workKey];
    [nd synchronize];
}

#pragma 获取Userdefault值
+ (NSString*)getUserDefaultValue:(NSString *)workKey 
{
    NSUserDefaults *nd = [NSUserDefaults standardUserDefaults];
    return [nd objectForKey:workKey];
}

#pragma 判断是否为数字
+ (BOOL)isValidNumber:(NSString *)value
{
    const char *cvalue = [value UTF8String];
    long len = strlen(cvalue);
    for (int i = 0; i < len; i++) {
        if (isnumber(cvalue[i])) {
            return false;
        }
    }
    return true;
}

#pragma 判断指定数字
+ (BOOL)validateNumber:(NSString *)strNumber
{
    BOOL res = true;
    NSCharacterSet * tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < strNumber.length) {
        NSString *string = [strNumber substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = false;
            break;
        }
        
        i++;
    }
    
    return true;
}

#pragma 判断电话号码
+ (BOOL)validateMobile:(NSString *)mobileNum  
{  
    /** 
     * 手机号码 
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188 
     * 联通：130,131,132,152,155,156,185,186 
     * 电信：133,1349,153,180,189 
     */  
    NSString * MOBILE = @"^1(3[0-9]|4[0-9]|5[0-9]|7[0-9]|8[0-9])\\d{8}$";  
    /** 
     10         * 中国移动：China Mobile 
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188 
     12         */  
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";  
    /** 
     15         * 中国联通：China Unicom 
     16         * 130,131,132,152,155,156,185,186 
     17         */  
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";  
    /** 
     20         * 中国电信：China Telecom 
     21         * 133,1349,153,180,189 
     22         */  
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";  
    /** 
     25         * 大陆地区固话及小灵通 
     26         * 区号：010,020,021,022,023,024,025,027,028,029 
     27         * 号码：七位或八位 
     28         */  
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";  
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];  
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];  
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];  
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];  
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)  
        || ([regextestcm evaluateWithObject:mobileNum] == YES)  
        || ([regextestct evaluateWithObject:mobileNum] == YES)  
        || ([regextestcu evaluateWithObject:mobileNum] == YES))  
    {  
        return YES;  
    }  
    else  
    {  
        return NO;  
    }  
} 

@end
