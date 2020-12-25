//
//  Tools.h
//  spbhelper
//
//  Created by MrLovelyCbb on 15/4/27.
//  Copyright (c) 2015年 MrLovelyCbb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "MBProgressHUD.h"
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>
#import <MobileCoreServices/UTCoreTypes.h>

@interface Tools : NSObject


+ (void)showHUD:(NSString *)text andView:(UIView *)view andHUD:(MBProgressHUD *)hud;

+ (BOOL)isEmptyOrNull:(NSString *)str;

+ (BOOL)isValidNumber:(NSString *)value;

+ (NSString *)convertNull:(id)object;

+ (void) delImage:(NSString *)imagePath file_name:(NSString *)imageName;

+ (NSString *)getCurrentTime:(NSString *)formatStr;

+ (NSString *)getYwTypeStr:(int)type;

+ (BOOL)validateMobile:(NSString *)mobileNum;

+ (BOOL)validateNumber:(NSString *)strNumber;

+ (void)saveUserDefaultValue:(NSString *)workKey Valuestr:(NSString *)value;

+ (NSString *)getUserDefaultValue:(NSString *)workKey;

@end
