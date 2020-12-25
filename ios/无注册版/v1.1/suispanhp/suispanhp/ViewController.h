//
//  ViewController.h
//  suispahp
//
//  Created by MrLovelyCbb on 15/3/10.
//  Copyright (c) 2015年 MrLovelyCbb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface ViewController : UIViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,MBProgressHUDDelegate,UITextFieldDelegate,CLLocationManagerDelegate>
+(void)setTagPic:(int)tag;
+(int)getTagPic;

@end

