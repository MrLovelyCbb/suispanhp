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
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "AFNetworking/AFNetworking.h"
#import "TableSystemCell.h"
#import "SVProgressHUD.h"
#import "PayViewController.h"

@interface ViewController : UIViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,MBProgressHUDDelegate,UITextFieldDelegate,CLLocationManagerDelegate,UITableViewDataSource,UITableViewDelegate>
+(void)setTagPic:(int)tag;
+(int)getTagPic;

@property (nonatomic,copy) NSString * txtUpdateUrl;

@end

