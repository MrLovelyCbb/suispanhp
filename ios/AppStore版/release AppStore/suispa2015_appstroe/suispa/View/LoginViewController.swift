//
//  LoginViewController.swift
//  suispa
//
//  Created by MrLovelyCbb on 15/2/2.
//  Copyright (c) 2015年 MrLovelyCbb. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController ,UITextViewDelegate , UITextFieldDelegate , UIAlertViewDelegate{

    @IBOutlet weak var myPageControl: UIPageControl!
    @IBOutlet weak var myScrollView: UIScrollView!
    @IBOutlet weak var myDeviceIdLabel: UILabel!
    @IBOutlet weak var txtUserNameField: UITextField!
    @IBOutlet weak var txtPhoneNumField: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var bg_LoginView: UIView!
    
    @IBAction func btnLoginClicked(sender: AnyObject) {
        reqAutoLogin()
    }
    @IBAction func btnLoginBackClicked(sender: AnyObject) {
        var mainVC = self.storyboard?.instantiateViewControllerWithIdentifier(SB_MainView) as! ViewController
        self.navigationController?.pushViewController(mainVC, animated: false)
    }
    @IBAction func btnGoAgreeClicked(sender: AnyObject) {
        var agreeVC = self.storyboard?.instantiateViewControllerWithIdentifier(SB_AgreeView) as! AgreeViewController
        self.navigationController?.pushViewController(agreeVC, animated: false)
        agreeVC.jumpViewStr = "loginOther"
    }
    var jumpViewStr = JUMP_main
    // JsonImageData
    var imageScrollData:[JSON]? = []
    // ImageViews
    var imageViews: [UIImageView]? = []
    let k_KEYBOARD_OFFSET:CGFloat = 185.0
    var timer:AnyObject?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var httpPara = HttpParamers().httpArrDescription()
        let defaults = NSUserDefaults.standardUserDefaults()
        if let username = defaults.stringForKey(USER_username) {
            httpPara.updateValue(username, forKey: "arr8")
        }
        if let password = defaults.stringForKey(USER_password) {
            httpPara.updateValue(password, forKey: "arr6")
        }
        myDeviceIdLabel.text = httpPara["arr100"]
        reqScrollView(httpPara)
        
        
        bg_LoginView.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
    }
    
    func reqAutoLogin() {
        let defaults = NSUserDefaults.standardUserDefaults()
        var httpPara = HttpParamers().httpArrDescription()
        
        let username = self.txtUserNameField.text
        let password = self.txtPhoneNumField.text
        
        // Valid userName or phoneNumber
        if username == "" || password == ""{
            alertDialog()
            return
        }
        // Valid phoneNumber length 11
        if count(password) < 11 {
            alertLengthshort()
            return
        }
        
        httpPara.updateValue(username, forKey: "arr8")
        httpPara.updateValue(password, forKey: "arr6")
        
        request(.POST, get_LoginInfoUrl, parameters: httpPara).responseJSON { (_, _, data, _) -> Void in
            if let _data:AnyObject = data {
                let jsonData = JSON(_data)
//                println("Login Println\(jsonData)")
                // 解析userinfo
                if let usertmpData = jsonData["data"]["userinfo"] as JSON? {
                   let userData = UserInfo(params: usertmpData)
                    defaults.setObject(userData.id, forKey: USER_userID)
                }
                
                if let strSucess = jsonData["status"].string{
                    var alertView:UIAlertView?
                    if strSucess.toInt() == 0 {
                        alertView = UIAlertView(title: "提示", message: "登录成功！", delegate: self, cancelButtonTitle: "确定")
                        defaults.setObject(httpPara["arr8"], forKey: USER_username)
                        defaults.setObject(httpPara["arr6"], forKey: USER_password)
                    }else{
                        alertView = UIAlertView(title: "提示", message: "登录失败！", delegate: self, cancelButtonTitle: "确定")
                    }
                    alertView!.delegate = self
                    alertView!.show()
                    defaults.setBool((strSucess.toInt() == 0), forKey: USER_isLogin)
                    defaults.setBool((strSucess.toInt() == 0), forKey: USER_isService)
                }
                
                defaults.synchronize()
            }else{
                // 检测网络
                if AppDelegate.isConnectedToNetwork() == false {
                    var uiAlert = UIAlertView(title: "网络连接异常!", message: "暂无法访问服务器,请检查是否联网。", delegate: self, cancelButtonTitle: "确定")
                    uiAlert.show()
                    return
                }

            }
        }
    }
    
    func reqScrollView(httpPara:Dictionary<String,String>) {
        request(.POST, get_ScrollViewUrl, parameters: httpPara).responseJSON { (_, _, data, _) -> Void in
            if let _data:AnyObject = data {
                let jsonObj = JSON(data!)
//                println("Println\(jsonObj)")
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
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let pageWidth = myScrollView.frame.size.width
        let page = Int(floor((myScrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
        
        // Update the page control
        myPageControl.currentPage = page
    }
    
    func textFieldShouldReturn(textField:UITextField) ->Bool {
        textField.resignFirstResponder()
        if textField == txtPhoneNumField{
            if textField.text != "" {
                println("No nil")
                reqAutoLogin()
            }
        }
        
        return true
    }
    
    func textField(textField: UITextField,
        shouldChangeCharactersInRange range: NSRange,
        replacementString string: String) -> Bool{
            
            if textField == txtPhoneNumField {
                if count(string) == 0 {
                    return true
                }else {
                    var existedLength = count(textField.text)
                    var selectedLength = range.length
                    var replaceLength = count(string)
                    if (existedLength - selectedLength + replaceLength) > 11 {
                        return false
                    }
                }
            }
            
            return true;
    }

    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
        keyboardWillDisappear()
    }
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        //bg_LoginView.frame.origin.y -= k_KEYBOARD_OFFSET
        if textField.isEqual(txtUserNameField) || textField.isEqual(txtPhoneNumField){
            if self.view.frame.origin.y >= 0 {
                self.moveViewUp(true)
                println("moveViewUp\(self.view.frame.origin.y)")
            }
        }
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 0 {
            let isLogin = NSUserDefaults.standardUserDefaults().boolForKey(USER_isLogin)
            if isLogin == true {
                var mainVC = self.storyboard?.instantiateViewControllerWithIdentifier(SB_MainView) as! ViewController
                //                self.presentViewController(mainVC, animated: false, completion: nil)
                self.navigationController?.pushViewController(mainVC, animated: true)
//                if jumpViewStr == JUMP_main {
//                   
//                }else if jumpViewStr == JUMP_pay {
//                    var payVC = self.storyboard?.instantiateViewControllerWithIdentifier(SB_PayView) as PayViewController
//                    self.navigationController?.pushViewController(payVC, animated: true)
//                }
            }
        }
    }
    
    func alertDialog() {
        var alertView = UIAlertView(title: "警告", message: "用户名和手机号不能为空", delegate: self, cancelButtonTitle: "确定")
        alertView.delegate = self
        alertView.show()
    }
    
    func alertLengthshort() {
        var alertView = UIAlertView(title: "警告", message: "不是正确的手机号码", delegate: self, cancelButtonTitle: "确定")
        alertView.delegate = self
        alertView.show()
    }
    
    func moveViewUp(bMoveUp:Bool) {
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.4)
        var rect:CGRect = self.view.frame
        if bMoveUp {
            rect.origin.y -= k_KEYBOARD_OFFSET
            rect.size.height += k_KEYBOARD_OFFSET
        } else {
            rect.origin.y += k_KEYBOARD_OFFSET
            rect.size.height -= k_KEYBOARD_OFFSET
        }
        
        self.view.frame = rect
        UIView.commitAnimations()
    }
    
    func keyboardWillAppear() {
        
        if self.view.frame.origin.y >= 0 {
            self.moveViewUp(true)
        }
        else if(self.view.frame.origin.y < 0)
        {
            self.moveViewUp(false)
        }
    }
    
    func keyboardWillDisappear() {
        if self.view.frame.origin.y >= 0 {
            self.moveViewUp(true)
        }
        else if self.view.frame.origin.y < 0 {
            self.moveViewUp(false)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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