//
//  ViewController.swift
//  suispa
//
//  Created by MrLovelyCbb on 15/1/28.
//  Copyright (c) 2015年 MrLovelyCbb. All rights reserved.
//

import UIKit

class ViewController: UIViewController , UIActionSheetDelegate {

    @IBOutlet weak var myScrollView: UIScrollView!
    @IBOutlet weak var myPageControl: UIPageControl!
    @IBOutlet weak var myWelcomeUser: UILabel!
    @IBOutlet weak var myDeviceIdLabel: UILabel!
    @IBOutlet weak var btnSelectService: UIButton!
    @IBOutlet weak var myScrollTxt: UITextView!
    @IBOutlet weak var btnCanBao: UIButton!
    
    @IBOutlet weak var menuBtnLogin: UIButton!
    @IBOutlet weak var menuBtnShop: UIButton!
    @IBOutlet weak var menuBtnProtect: UIButton!
    
    
    @IBAction func serviceClicked(sender: AnyObject) {
        selectServicesActionSheetStatic()
    }
    @IBAction func btnMenuLoginClicked(sender: AnyObject) {
        var agreeVC = self.storyboard?.instantiateViewControllerWithIdentifier(SB_AgreeView) as! AgreeViewController
        self.navigationController?.pushViewController(agreeVC, animated: true)
        agreeVC.jumpViewStr = JUMP_login
    }
    @IBAction func btnMenuCanBaoClicked(sender: AnyObject) {
        let defaults2 = NSUserDefaults.standardUserDefaults()
        let isLogin = defaults2.boolForKey("is_Login")
        var uiVC:UIViewController?
        if isLogin {
            uiVC = self.storyboard?.instantiateViewControllerWithIdentifier(SB_PayView) as! PayViewController
            defaults2.setObject(myDeviceIdLabel.text, forKey: USER_renewUUID)
        }else{
            uiVC = self.storyboard?.instantiateViewControllerWithIdentifier(SB_AgreeView) as! AgreeViewController
            (uiVC as! AgreeViewController).jumpViewStr = JUMP_pay
        }
        self.navigationController?.pushViewController(uiVC!, animated: true)
        defaults2.synchronize()
    }
    @IBAction func btnMenuShopClicked(sender: AnyObject) {
        var shopVC = self.storyboard?.instantiateViewControllerWithIdentifier(SB_ShopMarketView) as! ShopMarketViewController
        self.navigationController?.pushViewController(shopVC, animated: true)
    }
    
    var userData:UserInfo?
    // JsonImageData
    var imageScrollData:[JSON]? = []
    // ImageViews
    var imageViews: [UIImageView]? = []
    
    var timer:AnyObject?
    var listServices:Array<ServicesInfo>? = []
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
//        println("viewDidAppear")
        
        

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
//        println("viewWillAppear")
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let is_Login = defaults.boolForKey(USER_isLogin)    // 本事是否登录
        let is_MyService = defaults.boolForKey(USER_isService)  // 本机是否参保
        
        if is_Login && is_MyService {
            // 自动跳转至续保界面
            let reNewVC = self.storyboard?.instantiateViewControllerWithIdentifier(SB_RenewView) as! RenewViewController
            self.navigationController?.pushViewController(reNewVC, animated: false)
        }
        
        updateMenuBtnPoint()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        println("viewDidLoad")
        // 开始隐藏所有MenuButton
        menuBtnLogin.hidden = true
        menuBtnProtect.hidden = true
        menuBtnShop.hidden = true
        
        myWelcomeUser.text = "正在加载数据中..."
        
        var httpPara = HttpParamers().httpArrDescription()
        let defaults = NSUserDefaults.standardUserDefaults()
        if let username = defaults.stringForKey(USER_username) {
            httpPara.updateValue(username, forKey: "arr8")
        }
        if let password = defaults.stringForKey(USER_password) {
            httpPara.updateValue(password, forKey: "arr6")
        }
        
        myDeviceIdLabel.text = httpPara["arr100"]
        
        reqAutoLogin(httpPara)              // 请求自动登录
        reqScrollView(httpPara)             // 请求滚动图片
        
        btnSelectService.layer.cornerRadius = 10
        myScrollTxt.layer.cornerRadius = 10
        btnCanBao.layer.cornerRadius = 10
        myScrollTxt.layer.borderWidth = 1
        myScrollTxt.layer.borderColor = UIColor.grayColor().CGColor
    }
    
    func reqAutoLogin(httpPara:Dictionary<String,String>) {
        
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
                }
                
                // 解析insur 是否参保（1：参保 0：未参保）
                let insurStr = jsonData["data"]["insur"].description
//                println("------------\(insurStr)")
                if insurStr != "" && insurStr != "null" && insurStr != "0" {
                    var isSelfRenew = false
                    let uuidStr = self.myDeviceIdLabel.text
                    if let insurData = jsonData["data"]["insur"].arrayValue as [JSON]? {
                        for var i = 0;i < insurData.count; i++ {
                            let imeiData = insurData[i]["imei"].stringValue
                            if insurData[i]["imei"].string == uuidStr {
                                isSelfRenew = true
                            }
                        }
                    }
                    
                    // 不管参保还是没有参保，只要账户有参保信息，则跳转至续保界面
                    self.btnCanBao.addTarget(self, action: "xubaoClicked:", forControlEvents: UIControlEvents.TouchUpInside)
                    
                    let defaults = NSUserDefaults.standardUserDefaults()
                    defaults.setObject(user_id, forKey: USER_userID)
                    defaults.setBool(true, forKey: USER_isService)
                    defaults.synchronize()
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        self.btnCanBao.titleLabel?.text = "续保"
                        self.btnCanBao.setTitle("续保", forState: UIControlState.Normal)
                        self.btnCanBao.backgroundColor = UIColor.grayColor()
                        self.btnCanBao.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                    }
                    
                    // 自动跳转至续保界面
                    let reNewVC = self.storyboard?.instantiateViewControllerWithIdentifier(SB_RenewView) as! RenewViewController
//                    self.presentViewController(reNewVC, animated: false, completion: nil)
                    self.navigationController?.pushViewController(reNewVC, animated: false)
                }
                
                
                if let statusStr = jsonData["status"].string {
                    if statusStr.toInt() == 1 {
                        self.myWelcomeUser.text = "尚未登录...!"
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
    
    func xubaoClicked() {
        var renewVC = RenewViewController()
        self.navigationController?.pushViewController(renewVC, animated: true)
    }
    
    func reqScrollView(httpPara:Dictionary<String,String>) {
        let defaults = NSUserDefaults.standardUserDefaults()
        request(.POST, get_ScrollViewUrl, parameters: httpPara).responseJSON { (_, _, data, _) -> Void in
            if let _data:AnyObject = data {
                let jsonObj = JSON(data!)
//                println(jsonObj)
                // Services
                if let tempServiceData = jsonObj["data"]["services"].arrayValue as [JSON]? {
                    for i in (0...tempServiceData.count - 1) {
                        var servicseData:ServicesInfo = ServicesInfo(params: tempServiceData[i])
                        self.listServices?.append(servicseData)
                    }
                    self.myScrollTxt.text = self.txtGetServiceDes(tempServiceData[0]["serdes"].stringValue)
                    
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
                
                dispatch_async(dispatch_get_main_queue()){
                    // 控制商店是否显示
                    if let isShowShop = jsonObj["data"]["scIsShow"].string {
                        if isShowShop == 0.description {
                            // 隐藏
                            defaults.setBool(false, forKey: USER_scIsShow)
                        }else {
                            // 显示
                            defaults.setBool(true, forKey: USER_scIsShow)
                        }
                    }
                    // 控制是否显示支付
                    if let isShowPay = jsonObj["data"]["zfIsShow"].string {
                        if isShowPay == 0.description {
                            defaults.setBool(false, forKey: USER_payIsShow)
                        }else {
                            defaults.setBool(true, forKey: USER_payIsShow)
                        }
                    }
                    
                    // 本机是否参保
                    if let isSelfProduct = jsonObj["data"]["insur"].string {
                        if isSelfProduct == 1.description {
                            defaults.setBool(true, forKey: USER_insur)
                            self.btnCanBao.setTitle("本机已参保", forState: UIControlState.Normal)
                        }else{
                            defaults.setBool(false, forKey: USER_insur)
                            self.btnCanBao.setTitle("业务审核中", forState: UIControlState.Normal)
                        }
                    }
                }
                
                defaults.synchronize()
                self.updateMenuBtnPoint()
            }
        }
    }
    
    func updateMenuBtnPoint() {
        dispatch_async(dispatch_get_main_queue()){
            let defaults2 = NSUserDefaults.standardUserDefaults()
            let isLogin = defaults2.boolForKey(USER_isLogin)
            let isShowShop = defaults2.boolForKey(USER_scIsShow)
            let isShowPay = defaults2.boolForKey(USER_payIsShow)
            
            // 如果登录  
            if isLogin {
                //  显示参保（需判断商店是否开启）
                self.menuBtnProtect.hidden = false
                self.menuBtnLogin.hidden = true
                if isShowShop {
                    self.menuBtnShop.hidden = false
                    self.menuBtnShop.frame.origin = CGPoint(x: 56, y: self.menuBtnShop.frame.origin.y)
                    self.menuBtnProtect.frame.origin = CGPoint(x: 225.0, y: self.menuBtnProtect.frame.origin.y)
                }else{
                    if isShowPay{
                        self.menuBtnShop.hidden = true
                        self.menuBtnProtect.frame.origin = CGPoint(x: 141.0, y: self.menuBtnProtect.frame.origin.y)
                    }else {
                        self.menuBtnShop.hidden = true
                        self.menuBtnProtect.hidden = true
                    }
                }
            }else {
                // 显示参保及登录按钮（需判断商店是否开启）
                self.menuBtnLogin.hidden = false
                self.menuBtnProtect.hidden = false
                if isShowShop {
                    self.menuBtnShop.hidden = false
                    self.menuBtnLogin.frame.origin = CGPoint(x: 32, y: self.menuBtnLogin.frame.origin.y)
                    self.menuBtnShop.frame.origin = CGPoint(x: 141, y: self.menuBtnShop.frame.origin.y)
                    self.menuBtnProtect.frame.origin = CGPoint(x: 245.0, y: self.menuBtnProtect.frame.origin.y)
                }else{
                    if isShowPay {
                        self.menuBtnShop.hidden = true
                        self.menuBtnLogin.frame.origin = CGPoint(x: 56, y: self.menuBtnLogin.frame.origin.y)
                        self.menuBtnProtect.frame.origin = CGPoint(x: 225, y: self.menuBtnProtect.frame.origin.y)
                    }else {
                        self.menuBtnShop.hidden = true
                        self.menuBtnProtect.hidden = true
                        self.menuBtnLogin.frame.origin = CGPoint(x:141.0,y:self.menuBtnProtect.frame.origin.y)
                    }
                }
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
    
    func txtGetServiceDes(str:String) -> String {
        let scrollArr = str.componentsSeparatedByString("|")
        var scrolltxts = ""
        for var k = 0; k < scrollArr.count; k++ {
            scrolltxts += (k==0 ? "" : "\n")+String(k+1)+"."+scrollArr[k]
        }
        return scrolltxts
    }
    
    func selectServicesActionSheetStatic() {
        var uisheet:UIActionSheet = UIActionSheet(title: "选择服务项", delegate: self, cancelButtonTitle: nil, destructiveButtonTitle: nil)
        
        for (var i=0;i < self.listServices?.count;i++){
            var tempData:ServicesInfo = self.listServices![i] as ServicesInfo
            uisheet.addButtonWithTitle(tempData.name)
        }
        uisheet.addButtonWithTitle("取消")
        uisheet.cancelButtonIndex = uisheet.numberOfButtons - 1
        
        uisheet.frame = self.myScrollView.bounds
        uisheet.delegate = self
        uisheet.showInView(self.view)
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        for index in 0..<count(self.listServices!){
            var tempData = self.listServices![index] as ServicesInfo
            let defaults = NSUserDefaults.standardUserDefaults()
            if (tempData.name == actionSheet.buttonTitleAtIndex(buttonIndex)){
                defaults.setObject(tempData.id, forKey: "S_serviceID")
                defaults.setObject(tempData.price, forKey: "S_price")
                defaults.synchronize()
                btnSelectService.setTitle(tempData.name, forState: UIControlState.Normal)
                self.myScrollTxt.text! = txtGetServiceDes(tempData.serdes)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    
    
    
    
    

}

