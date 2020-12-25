//
//  RenewViewController.swift
//  suispa
//
//  Created by MrLovelyCbb on 15/2/2.
//  Copyright (c) 2015年 MrLovelyCbb. All rights reserved.
//

import UIKit

class RenewViewController: UIViewController , UITextFieldDelegate , UIActionSheetDelegate , UIAlertViewDelegate {

    @IBOutlet weak var myWelcomeUser: UILabel!
    @IBOutlet weak var myDeviceIdLabel: UILabel!
    @IBOutlet weak var myPayDeviceBtn: UIButton!
    @IBOutlet weak var myDeviceMoney: UILabel!
    @IBOutlet weak var btnSelectService: UIButton!
    
    @IBOutlet weak var myStartService: UILabel!
    @IBOutlet weak var myEndService: UILabel!
    
    @IBOutlet weak var myScrollView: UIScrollView!
    @IBOutlet weak var myPageControl: UIPageControl!
    
    @IBOutlet weak var myRenewTimeView: UIView!
    
    @IBOutlet weak var btnMyorRepair: UIButton!
    @IBOutlet weak var btnRenewPay: UIButton!
    
    @IBAction func btnMyorRepairClicked(sender: AnyObject) {
        if btnMyorRepair.titleLabel?.text == "我要修屏" && isHttpConnect {
            var reportVC = self.storyboard?.instantiateViewControllerWithIdentifier(SB_ReportView) as! ReportViewController
//            self.presentViewController(reportVC, animated: false, completion: nil)
            self.navigationController?.pushViewController(reportVC, animated: false)
//            println("--------我要修屏")
        } else if btnMyorRepair.titleLabel?.text == "参保本机" {
//            println("--------参保本机")
            var payVC = self.storyboard?.instantiateViewControllerWithIdentifier(SB_PayView) as! PayViewController
            let uuidStr = self.myDeviceIdLabel.text
            NSUserDefaults.standardUserDefaults().setObject(uuidStr, forKey: USER_renewUUID)
//            self.presentViewController(payVC, animated: false, completion: nil)
            self.navigationController?.pushViewController(payVC, animated: false)
            payVC.jumpViewStr = JUMP_pay
            NSUserDefaults.standardUserDefaults().synchronize()
        } else if btnMyorRepair.titleLabel?.text == "注销" {
            resetLogin()
        }
    }
    
    @IBAction func btnAgreeClicked(sender: AnyObject) {
        var agreeVC = self.storyboard?.instantiateViewControllerWithIdentifier(SB_AgreeView) as! AgreeViewController
//        self.presentViewController(agreeVC, animated: false, completion: nil)
        self.navigationController?.pushViewController(agreeVC, animated: false)
        agreeVC.jumpViewStr = JUMP_renew
    }
    @IBAction func btnSelectDevicesClicked(sender: AnyObject) {
        selectPayUUIDAction()
    }
    @IBAction func btnSelectedServicesClicked(sender: AnyObject) {
        selectServiceAction()
    }
    @IBAction func btnRenewPayClicked(sender: AnyObject) {
        if btnRenewPay.titleLabel?.text == "注销" && isHttpConnect {
            resetLogin()
            return
        }
        var renewPayVC = self.storyboard?.instantiateViewControllerWithIdentifier(SB_PayView) as! PayViewController
//        self.presentViewController(renewPayVC, animated: false, completion: nil)
        self.navigationController?.pushViewController(renewPayVC, animated: false)
        let uuidStr = self.myPayDeviceBtn.titleLabel?.text
        NSUserDefaults.standardUserDefaults().setValue(uuidStr, forKey: "RenewUUID")
        renewPayVC.jumpViewStr = JUMP_pay
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    // JsonImageData
    var imageScrollData:[JSON]? = []
    // ImageViews
    var imageViews: [UIImageView]? = []
    
    var timer:AnyObject? = nil
    
    var selectedServiceAction:UIActionSheet?
    var payServiceAction:UIActionSheet?
    
    var isHttpConnect = false
    var isSelfCanbao = false
    var isShowPayWay = false
    
    var listServices:Array<ServicesInfo> = []
    var listPayServices:Array<PayServiceInfo> = []
    var userData:UserInfo?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myRenewTimeView.layer.borderWidth = 1
        myRenewTimeView.layer.borderColor = UIColor.grayColor().CGColor
        
        myWelcomeUser.text = "正在加载数据中...!"
        
        var httpPara = HttpParamers().httpArrDescription()
        let defaults = NSUserDefaults.standardUserDefaults()
        if let username = defaults.stringForKey(USER_username) {
            httpPara.updateValue(username, forKey: "arr8")
        }
        if let password = defaults.stringForKey(USER_password) {
            httpPara.updateValue(password, forKey: "arr6")
        }
        // 是否显示支付方式
        self.isShowPayWay = defaults.boolForKey(USER_payIsShow)
        
        
        myDeviceIdLabel.text = httpPara["arr100"]
        
        reqAutoLogin(httpPara)              // 请求自动登录
        reqScrollView(httpPara)             // 请求滚动图片
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if !AppDelegate.isConnectedToNetwork(){
            isHttpConnect = false
            isSelfCanbao = false
        }
        
        let defaults = NSUserDefaults.standardUserDefaults();
        // 更新是否显示
        self.isShowPayWay = defaults.boolForKey(USER_payIsShow)
        
        updatePayBtn()
    }
    
    func updatePayBtn() -> Void{
        if self.isShowPayWay
        {
            if self.isSelfCanbao == false {
                self.btnMyorRepair.setTitle("参保本机", forState: UIControlState.Normal)
            }else{
                self.btnMyorRepair.setTitle("我要修屏", forState: UIControlState.Normal)
            }
        }else{
            if self.isSelfCanbao {
                self.btnMyorRepair.setTitle("我要修屏", forState: UIControlState.Normal)
                self.btnRenewPay.setTitle("注销", forState: UIControlState.Normal)
            }else{
                self.btnMyorRepair.setTitle("注销", forState: UIControlState.Normal)
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.isShowPayPosition()
    }
    
    // hide Pay
    func isShowPayPosition() {
        if !self.isShowPayWay && !self.isSelfCanbao
        {
            let width = self.view.frame.width;
            let height = self.view.frame.height;
            btnRenewPay.hidden = true
            var rect = CGRect(x: (width*0.5) - (self.btnMyorRepair.frame.width*0.5), y: self.btnMyorRepair.frame.origin.y, width: self.btnMyorRepair.frame.width, height: self.btnMyorRepair.frame.height)
            self.btnMyorRepair.frame = rect
        }else{
            btnRenewPay.hidden = false
        }
    }
    
    func reqAutoLogin(httpPara:Dictionary<String,String>) {
        let defaults = NSUserDefaults.standardUserDefaults()
        //        println("httpPara:\(httpPara)")
        request(.POST, get_LoginInfoUrl, parameters: httpPara).responseJSON { (_, _, data, _) -> Void in
            if let _data:AnyObject = data {
                let jsonData = JSON(_data)
//                println("登录信息：------------\(jsonData)")
                
                var user_id:String = ""
                
                // 解析userinfo
                if let usertmpData = jsonData["data"]["userinfo"] as JSON? {
                    self.userData = UserInfo(params: usertmpData)
                    user_id = self.userData!.id
                    dispatch_async(dispatch_get_main_queue()){
                        self.myDeviceMoney.text = self.userData!.money
                        self.myDeviceMoney.text! += "元"
                    }
                }
                
                if let statusStr = jsonData["status"].string {
                    if statusStr.toInt() == 1 {
                        self.myWelcomeUser.text = "尚未登录...!"
                        self.isHttpConnect = false
                    }else{
                        self.myWelcomeUser.text = "尊敬的用户：\(self.userData!.name),您已登录！"
                    }
                }

                // 解析insur 是否参保（1：参保 0：未参保）
                let insurStr = jsonData["data"]["insur"].description
                if insurStr != "" && insurStr != "null" && insurStr != "0" {
                    var isSelfRenew = false
                    let uuidStr = self.myDeviceIdLabel.text
                    if let insurData = jsonData["data"]["insur"].arrayValue as [JSON]? {
                        self.listPayServices = []
                        self.isSelfCanbao = false
                        var strStartTime:String = "1423831003"
                        var strEndTime:String = "1455379199"
                        var firstTime:String = strStartTime
                        var endTime:String = strEndTime
                        let uuidStr = self.myDeviceIdLabel.text
                        for var i = 0;i < insurData.count; i++ {
                            //  弹出  参保  串号
                            let payServiceInfo:PayServiceInfo = PayServiceInfo(params: insurData[i])
                            self.listPayServices.append(payServiceInfo)
                            if insurData[i]["imei"].stringValue == uuidStr {
                                self.myPayDeviceBtn.setTitle(uuidStr, forState: UIControlState.Normal)
                                firstTime = insurData[i]["dtime"].stringValue
                                endTime = insurData[i]["expire"].stringValue
                                self.isSelfCanbao = true
                            }else {
                                self.myPayDeviceBtn.setTitle(insurData[0]["imei"].stringValue, forState: UIControlState.Normal)
                                strStartTime = insurData[i]["dtime"].stringValue
                                strEndTime = insurData[i]["expire"].stringValue
                            }
                        }
                        let strTime1 = strStartTime as NSString
                        let strTime2 = strEndTime as NSString
                        let time1 = NSDate(timeIntervalSince1970: strTime1.doubleValue).unixToStrings(strTime1.doubleValue, dateFormat: "yyyy年MM月dd日HH时")
                        let time2 = NSDate(timeIntervalSince1970: strTime2.doubleValue).unixToStrings(strTime2.doubleValue, dateFormat: "yyyy年MM月dd日HH时")
                        self.myStartService.text = time1 as String
                        self.myEndService.text = time2 as String
                        
                        if let statusStr = jsonData["status"].string {
                            if statusStr.toInt() == 1 {
                                self.myWelcomeUser.text = "尚未登录...!"
                                self.isHttpConnect = false
                            }else{
                                self.myWelcomeUser.text = "尊敬的用户：\(self.userData!.name),您已登录！"
                            }
                        }
                        
                        self.updatePayBtn()
                        
                        if self.isSelfCanbao == false {
                            dispatch_async(dispatch_get_main_queue()){
//                            self.btnMyorRepair.setTitle("参保本机", forState: UIControlState.Normal)
                        }
//                            self.myIndicatorView.stopAnimating()
//                            self.myIndicatorView.hidden = true
                            self.isHttpConnect = true
                            defaults.setBool(true, forKey: USER_isService)
                            return
                        }else {
//                            self.btnMyorRepair.setTitle("我要修屏", forState: UIControlState.Normal)
                            let strTime1 = firstTime as NSString
                            let strTime2 = endTime as NSString
                            let time1 = NSDate(timeIntervalSince1970: strTime1.doubleValue).unixToStrings(strTime1.doubleValue, dateFormat: "yyyy年MM月dd日HH时")
                            let time2 = NSDate(timeIntervalSince1970: strTime2.doubleValue).unixToStrings(strTime2.doubleValue, dateFormat: "yyyy年MM月dd日HH时")
                            self.myStartService.text = time1 as String
                            self.myEndService.text = time2 as String
                        }
                        
                        self.isHttpConnect = true
//                        self.myIndicatorView.stopAnimating()
//                        self.myIndicatorView.hidden = true
                        defaults.setBool(true, forKey: USER_isService)
                    }
                }else{
                    var mainVC = self.storyboard?.instantiateViewControllerWithIdentifier(SB_MainView) as! ViewController
//                    self.presentViewController(mainVC, animated: false, completion: nil)
                    self.navigationController?.pushViewController(mainVC, animated: false)
                    defaults.setBool(false, forKey: USER_isService)
                }
                
                if let statusStr = jsonData["status"].string {
                    if statusStr.toInt() == 1 {
                        self.myWelcomeUser.text = "尚未登录...!"
                        self.isHttpConnect = false
                    }else{
                        self.myWelcomeUser.text = "尊敬的用户：\(self.userData!.name),您已登录！"
                    }
                }
                
            }else{
                // 检测网络
                if AppDelegate.isConnectedToNetwork() == false {
                    self.myWelcomeUser.text = "网络异常，请检查网络设置！"
                    var uiAlert = UIAlertView(title: "网络连接异常!", message: "暂无法访问服务器,请检查是否联网。", delegate: self, cancelButtonTitle: "确定")
                    uiAlert.show()
                    return
                }
            }
        }
    }
    
    func reqScrollView(httpPara:Dictionary<String,String>) {
        let defaults = NSUserDefaults.standardUserDefaults()
        request(.POST, get_ScrollViewUrl, parameters: httpPara).responseJSON { (_, _, data, _) -> Void in
            if let _data:AnyObject = data {
                let jsonObj = JSON(data!)
                println("RenewView ImageArray:!------\(jsonObj)")
                // Services
                if let tempServiceData = jsonObj["data"]["services"].arrayValue as [JSON]? {
                    for i in (0...tempServiceData.count - 1) {
                        var servicseData:ServicesInfo = ServicesInfo(params: tempServiceData[i])
                        self.listServices.append(servicseData)
                    }
                    
                    let s_id:String = tempServiceData[0]["id"].stringValue
                    let priceInt:String = tempServiceData[0]["price"].stringValue
                    
                    defaults.setObject(s_id, forKey: USER_serviceID)
                    defaults.setObject(priceInt, forKey: USER_servicePrice)
                }
                
                // ImgData
                if let imgData = jsonObj["data"]["img"].arrayValue as [JSON]? {
                    dispatch_async(dispatch_get_main_queue()){
                        self.imageScrollData = imgData
                        let pageCount = self.imageScrollData?.count
                        // ScrollImageView
                        self.myScrollView.contentSize = CGSizeMake(self.myScrollView.frame.size.width * CGFloat(pageCount!), 0)
                        // PageControl
                        self.myPageControl.numberOfPages = pageCount!
                        
                        var indexImage = 0
                        for imageData in self.imageScrollData! {
                            var urlString = imageData["img"]
                            var imageView:UIImageView = UIImageView()
                            let imgurl = NSURL(string:urlString.stringValue)
                            var scrollFrame = self.myScrollView.bounds
                            scrollFrame.origin.x = scrollFrame.size.width * CGFloat(indexImage)
                            scrollFrame.origin.y = 0.0
                            imageView.frame = scrollFrame
                            imageView.hnk_setImageFromURL(imgurl!)
                            self.imageViews?.append(imageView)
                            self.myScrollView.addSubview(imageView)
                            indexImage++
                        }
                        
                        self.timer = NSTimer.scheduledTimerWithTimeInterval(3.8, target: self, selector: Selector("someSelector"), userInfo: nil, repeats: true)
                    }
                }
                defaults.synchronize()
            }
        }
    }
    
    
    
    func someSelector() {
        var page = self.myPageControl.currentPage
        var pageCount = imageScrollData?.count
        var pagea = pageCount! - 1
        if page == pagea {
            page = 0
        }else{
            page++
        }
        var pageX = CGFloat(page) * self.myScrollView.frame.width
        self.myScrollView.setContentOffset(CGPointMake(pageX, 0.0), animated: true)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView!) {
        let pageWidth = myScrollView.frame.size.width
        let page = Int(floor((myScrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
        
        // Update the page control
        myPageControl.currentPage = page
    }
    
    
    func selectPayUUIDAction() {
        payServiceAction = UIActionSheet(title: "选择参保串号", delegate: self, cancelButtonTitle: nil, destructiveButtonTitle: nil)
        let uuidStr = self.myDeviceIdLabel.text
        if self.isSelfCanbao {
            //            payServiceAction!.addButtonWithTitle(uuidStr!)
        }
        for (var i=0;i < self.listPayServices.count;i++){
            var tempData:PayServiceInfo = self.listPayServices[i] as PayServiceInfo
            payServiceAction!.addButtonWithTitle(tempData.imei)
        }
        payServiceAction!.addButtonWithTitle("取消")
        payServiceAction!.cancelButtonIndex = payServiceAction!.numberOfButtons - 1
        
        payServiceAction!.frame = self.myScrollView.bounds
        payServiceAction!.delegate = self
        payServiceAction!.showInView(self.view)
    }
    
    func selectServiceAction() {
        selectedServiceAction = UIActionSheet(title: "选择服务项", delegate: self, cancelButtonTitle: nil, destructiveButtonTitle: nil)
        
        for (var i=0;i < self.listServices.count;i++){
            var tempData:ServicesInfo = self.listServices[i] as ServicesInfo
            selectedServiceAction!.addButtonWithTitle(tempData.name)
        }
        selectedServiceAction!.addButtonWithTitle("取消")
        selectedServiceAction!.cancelButtonIndex = selectedServiceAction!.numberOfButtons - 1
        
        selectedServiceAction!.frame = self.myScrollView.bounds
        selectedServiceAction!.delegate = self
        selectedServiceAction!.showInView(self.view)
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        let defaults = NSUserDefaults.standardUserDefaults()
        if actionSheet.isEqual(selectedServiceAction) {
            for index in 0..<count(self.listServices){
                var tempData = self.listServices[index] as ServicesInfo
                if (tempData.name == actionSheet.buttonTitleAtIndex(buttonIndex)){
                    println("id!!!!!!\(tempData.id)")
                    defaults.setInteger(tempData.id.toInt()!, forKey: USER_serviceID)
                    defaults.setValue(tempData.xf_price, forKey: USER_servicePrice)
                    btnSelectService.setTitle(tempData.name, forState: UIControlState.Normal)
                }
            }
        }else if actionSheet.isEqual(payServiceAction) {
            let uuidStr = self.myDeviceIdLabel.text
            for index in 0..<count(self.listPayServices){
                var tempData = self.listPayServices[index] as PayServiceInfo
                if (tempData.imei == actionSheet.buttonTitleAtIndex(buttonIndex)) || actionSheet.buttonTitleAtIndex(buttonIndex) == uuidStr{
                    
                    var strStartTime = tempData.dtime
                    var strEndTime = tempData.expire
                    if actionSheet.buttonTitleAtIndex(buttonIndex) == uuidStr && tempData.imei == uuidStr {
                        println("Selected UUID!!!!\(uuidStr)")
                        println("UUID Data\(tempData.imei)")
                        defaults.setValue(uuidStr, forKey: USER_renewUUID)
                        myPayDeviceBtn.setTitle(uuidStr, forState: UIControlState.Normal)
                        let strTime1 = strStartTime as NSString
                        let strTime2 = strEndTime as NSString
                        let time1 = NSDate(timeIntervalSince1970: strTime1.doubleValue).unixToStrings(strTime1.doubleValue, dateFormat: "yyyy年MM月dd日HH时")
                        let time2 = NSDate(timeIntervalSince1970: strTime2.doubleValue).unixToStrings(strTime2.doubleValue, dateFormat: "yyyy年MM月dd日HH时")
                        self.myStartService.text = time1 as String
                        self.myEndService.text = time2 as String
                        break
                    }else {
                        println("Selected IMEI!!!!\(tempData.imei)")
                        defaults.setValue(tempData.imei, forKey: USER_renewUUID)
                        myPayDeviceBtn.setTitle(tempData.imei, forState: UIControlState.Normal)
                        strStartTime = tempData.dtime
                        strEndTime = tempData.expire
                    }
                    
                    // 开始日期  结束日期跟随  参保UUID变
                    
                    let strTime1 = strStartTime as NSString
                    let strTime2 = strEndTime as NSString
                    let time1 = NSDate(timeIntervalSince1970: strTime1.doubleValue).unixToStrings(strTime1.doubleValue, dateFormat: "yyyy年MM月dd日HH时")
                    let time2 = NSDate(timeIntervalSince1970: strTime2.doubleValue).unixToStrings(strTime2.doubleValue, dateFormat: "yyyy年MM月dd日HH时")
                    self.myStartService.text = time1 as String
                    self.myEndService.text = time2 as String
                }
            }
            
        }
        defaults.synchronize()
    }
    
    
    func resetLogin() {
        var alert = UIAlertController(title: "注销", message: "是否注销此账户", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "注销", style: UIAlertActionStyle.Default, handler: { (ACTION:UIAlertAction!) -> Void in
            let defaults = NSUserDefaults.standardUserDefaults();
            defaults.setObject("", forKey: USER_username)
            defaults.setObject("", forKey: USER_userID)
            defaults.setBool(false, forKey: USER_isLogin)
            defaults.setBool(false, forKey: USER_isService)
            var mainVC = self.storyboard?.instantiateViewControllerWithIdentifier(SB_MainView) as! ViewController
            self.navigationController?.pushViewController(mainVC, animated: false)
            defaults.setBool(false, forKey: USER_isService)
        }))
       self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func back(segue:UIStoryboardSegue){
    
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
    