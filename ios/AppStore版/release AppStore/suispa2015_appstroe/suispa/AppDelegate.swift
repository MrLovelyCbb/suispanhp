    //
//  AppDelegate.swift
//  suispa
//
//  Created by MrLovelyCbb on 15/1/28.
//  Copyright (c) 2015年 MrLovelyCbb. All rights reserved.
//

import UIKit
import SystemConfiguration
    
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let isConn = AppDelegate.isConnectedToNetwork()
        if false == isConn {
            println("No Connected")
        }
        application.statusBarHidden = true;
        let userDefaults = NSUserDefaults.standardUserDefaults()
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.makeKeyAndVisible()
        
        var storyboard = UIStoryboard(name: "Main",bundle: NSBundle.mainBundle())
        
        let isGuideScreen = userDefaults.boolForKey(USER_borkenScreen)
        if false  == isGuideScreen {
                var guideVC = storyboard.instantiateViewControllerWithIdentifier(SB_GuideImageView) as! GuideImageViewController
                var guideNC = UINavigationController(rootViewController: guideVC)
                guideNC.setNavigationBarHidden(true, animated: false)
                self.window?.rootViewController = guideNC
                userDefaults.setBool(true, forKey: USER_borkenScreen)
        }else{

            if false == userDefaults.boolForKey(USER_isService) {
                var mainVC = storyboard.instantiateViewControllerWithIdentifier(SB_MainView) as! ViewController
                var mainNC = UINavigationController(rootViewController: mainVC)
                mainNC.setNavigationBarHidden(true, animated: false)
                self.window?.rootViewController = mainNC
            }else {
                var renewVC = storyboard.instantiateViewControllerWithIdentifier(SB_RenewView) as! RenewViewController
                var renewNC = UINavigationController(rootViewController: renewVC)
                renewNC.setNavigationBarHidden(true, animated: false)
                self.window?.rootViewController = renewNC
            }
        }
        
        return true
    }
    
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0)).takeRetainedValue()
        }
        
        var flags: SCNetworkReachabilityFlags = 0
        if SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) == 0 {
            return false
        }
        
        let isReachable = (flags & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        
        return (isReachable && !needsConnection) ? true : false
    }
    
    /*
    9000 订单支付成功
    8000 正在处理中
    4000 订单支付失败
    6001 用户中途取消
    6002 网络连接出错*/
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        println("0000000000000000000000000000-----------------\(url)")
        println("APPdelegate!!!!!!!!!!!\(sourceApplication)")
        if (url.host == "safepay") {
            AlipaySDK.defaultService().processOrderWithPaymentResult(url, standbyCallback: { (resultDic) -> Void in
                println("result AppDelegate\(resultDic)")
                let status:String = resultDic["resultStatus"] as! String
                if status == 9000.description {
                    let renewStoryboard = UIStoryboard(name:"Main",bundle:NSBundle.mainBundle())
                    var renewVC = renewStoryboard.instantiateViewControllerWithIdentifier(SB_RenewView) as! RenewViewController
                    var renewNC = UINavigationController(rootViewController: renewVC)
                    renewNC.setNavigationBarHidden(true, animated: false)
                    self.window?.rootViewController = renewNC
                }
            })
        }
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
//        println("applicationWillResignActive")
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//        println("applicationDidEnterBackground")
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
//        println("applicationWillEnterForeground")
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//        println("applicationDidBecomeActive")
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
//        println("applicationWillTerminate")
    }


}

