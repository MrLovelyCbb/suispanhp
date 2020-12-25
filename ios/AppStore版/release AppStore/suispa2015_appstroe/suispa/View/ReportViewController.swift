//
//  ReportViewController.swift
//  suispa
//
//  Created by MrLovelyCbb on 15/2/2.
//  Copyright (c) 2015年 MrLovelyCbb. All rights reserved.
//

import UIKit

class ReportViewController: UIViewController ,UITextViewDelegate , UITextFieldDelegate , UIAlertViewDelegate {

    
    @IBOutlet weak var myLblPhoneNum: UILabel!
    @IBOutlet weak var myTxtPhotoNum: UITextField!
    @IBOutlet weak var myTxtAdress: UITextField!
    @IBOutlet weak var myScrollTxt: UITextView!
    
    
    @IBAction func btnCallServiceClicked(sender: AnyObject) {
        callPhoneNum()
    }
    @IBAction func btnUploadInfoClicked(sender: AnyObject) {
        // Send Message
        reqSuggestService()
    }
    
    @IBAction func btnBackClicked(sender: AnyObject) {
        // send Back
        self.navigationController?.popViewControllerAnimated(false)
    }
    
    @IBAction func btnAgreeClicked(sender: AnyObject) {
        var agreeVC = self.storyboard?.instantiateViewControllerWithIdentifier(SB_AgreeView) as! AgreeViewController
//        self.presentViewController(agreeVC, animated: false, completion: nil)
        self.navigationController?.pushViewController(agreeVC, animated: false)
        agreeVC.jumpViewStr = JUMP_report
    }
    
    var insur_info = "(必填)请输入故障描述\n\n温馨提示：\n"
    
    let k_KEYBOARD_OFFSET:CGFloat = 200.0
    var is_sucess:Bool = false
    var hiddenLabel:UILabel = UILabel()
    
    // 当开始加载View之前
    override func viewDidAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillDisappear:", name: UIKeyboardWillHideNotification, object: nil)
        
        myScrollTxt.delegate = self
        myTxtPhotoNum.delegate = self
        myTxtAdress.delegate = self
        
        var tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("callPhoneNum"))
        myLblPhoneNum.userInteractionEnabled = true
        myLblPhoneNum.addGestureRecognizer(tap)
        
        let defautls = NSUserDefaults.standardUserDefaults()
        myTxtPhotoNum.placeholder = defautls.stringForKey(USER_password)
        myScrollTxt.layer.borderWidth = 2
        myScrollTxt.layer.borderColor = UIColor.greenColor().CGColor
    }
    
    func callPhoneNum() {
        let phone = "tel://400820136"
        let url:NSURL = NSURL(string: phone)!
        UIApplication.sharedApplication().openURL(url)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestUpdateInfo()

    }
    
    
    func requestUpdateInfo() {
        // 请求
        request(.POST, get_CheckAppUpdateUrl, parameters: nil).responseJSON { (_, _, data, _) -> Void in
            if let _data:AnyObject = data {
                let jsonData = JSON(_data)
                if let updateData = jsonData["data"]["insur_info"].string{
//                    println("Update:-----\(updateData)")
                    self.insur_info += self.txtGetUpdateDes(updateData)
                    if (self.myScrollTxt.text == "") {
                        self.textViewDidEndEditing(self.myScrollTxt)
                    }
                }
            }
        }
//        hideViewOnkeyboard()
    }
    
    
    func reqSuggestService() {
        var httpPara = HttpParamers().httpArrDescription()
        let defaults = NSUserDefaults.standardUserDefaults()

        var arr10 = self.myTxtPhotoNum.text
        var arr11 = self.myScrollTxt.text
        var arr12 = self.myTxtAdress.text
        
        if count(arr11) < 10 || arr11.hasPrefix("(必填)"){
            alertScrollTxtDialog()
            return
        }
        
        if arr11 == "" || arr12 == "" {
            alertDialog()
            return
        }
        
        // Valid phoneNumber length 11
        if count(arr10) < 11 {
            alertLengthshort()
            return
        }

        
        if let username = defaults.stringForKey(USER_username) {
            httpPara.updateValue(username, forKey: "arr9")
        }
        
        if let password = defaults.stringForKey(USER_password) {
            httpPara.updateValue(arr10, forKey: "arr10")
        }else{
            httpPara.updateValue(arr10, forKey: "arr10")
        }
        if let user_id = defaults.stringForKey(USER_userID) {
            httpPara.updateValue(user_id, forKey: "arr8")
        }
        
        httpPara.updateValue(arr11, forKey: "arr11")
        httpPara.updateValue(arr12, forKey: "arr12")
        
        // arr8:userid arr9:联系人 arr10:联系电话  arr11:内容（不少于5个字节） arr12:地址
        // 发送反馈至服务器
        request(.POST, send_SuggestUrl, parameters: httpPara).responseJSON { (_, _, data, _) -> Void in
            if (data != nil){
                let jsonObj = JSON(data!)
                if let strSucess = jsonObj["status"].string{
                    var alertView:UIAlertView?
                    if strSucess.toInt() == 0 {
                        alertView = UIAlertView(title: "提示", message: "发送成功！", delegate: self, cancelButtonTitle: "确定")
                        self.is_sucess = true
                    }else{
                        alertView = UIAlertView(title: "提示", message: "发送失败！", delegate: self, cancelButtonTitle: "确定")
                        self.is_sucess = false
                    }
                    alertView!.delegate = self
                    alertView!.show()
                }
            }

        }
    }
    
    
    
    // 提示警告对话框
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 0 && is_sucess == true {
            var reNewVC = self.storyboard?.instantiateViewControllerWithIdentifier(SB_RenewView) as! RenewViewController
//            self.presentViewController(reNewVC, animated: true, completion: nil)
            self.navigationController?.pushViewController(reNewVC, animated: false)
        }
    }
    
    func alertScrollTxtDialog() {
        var alertView = UIAlertView(title: "警告", message: "反馈内容不能少于10个字符", delegate: self, cancelButtonTitle: "确定")
        alertView.delegate = self
        alertView.show()
    }
    
    func alertDialog() {
        var alertView = UIAlertView(title: "警告", message: "用户名、手机号和反馈内容不能为空！", delegate: self, cancelButtonTitle: "确定")
        alertView.delegate = self
        alertView.show()
    }
    
    func alertLengthshort() {
        var alertView = UIAlertView(title: "警告", message: "请输入有效的手机号码", delegate: self, cancelButtonTitle: "确定")
        alertView.delegate = self
        alertView.show()
    }
    
    func textFieldShouldReturn(textField:UITextField) ->Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        myScrollTxt.resignFirstResponder()
        myTxtAdress.resignFirstResponder()
        myTxtPhotoNum.resignFirstResponder()
    }
    
    let myPhoneNumOffset = -240
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.isEqual(myTxtPhotoNum) {
            if myTxtPhotoNum.placeholder! != "" {
                myTxtPhotoNum.text = myTxtPhotoNum.placeholder!
            }
            //            self.view.frame.origin.y = CGFloat(myPhoneNumOffset)
        } else if textField.isEqual(myTxtAdress) {
            // do some thing
            //            self.view.frame.origin.y = CGFloat(myPhoneNumOffset)
        }
    }
    
    // textView开始输入时
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.isEqual(myScrollTxt) {
            println("TextView Touch This---------++\(self.view.frame.origin.y)")
            textView.textColor = UIColor.blackColor()
            self.view.frame.origin.y += 60
            if (textView.text == insur_info) {
                textView.text = ""
                textView.textColor = UIColor.lightGrayColor()
            }
            //            textView.resignFirstResponder()
        }
    }
    
    // textview结束输入时
    func textViewDidEndEditing(textView: UITextView) {
        if (textView.text == "") {
            textView.text = insur_info
            textView.textColor = UIColor.lightGrayColor()
        }
        //        textView.becomeFirstResponder()
    }
    
    func textViewDidChange(textView: UITextView) {
        //        println("Change!!!")
        
        if textView.text.hasSuffix("\n") {
            textView.resignFirstResponder()
            //            keyboardWillDisappear()
            if self.view.frame.origin.y < 0 {
                self.view.frame.origin.y = 0
            } else if self.view.frame.origin.y > 0 {
                self.view.frame.origin.y = 0
            }
        }
    }
    
    // 整个View上移
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
    
    func hideViewOnkeyboard() -> UILabel{
        hiddenLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width - 10, height: 30))
        hiddenLabel.text = "完成"
        hiddenLabel.textColor = UIColor.grayColor()
        hiddenLabel.textAlignment = .Center
        
        var tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("hideKeyboard"))
        hiddenLabel.userInteractionEnabled = true
        hiddenLabel.addGestureRecognizer(tap)
        self.view.addSubview(hiddenLabel)
        return hiddenLabel
    }
    
    // 分割字符串
    func txtGetUpdateDes(str:String) -> String {
        let scrollArr = str.componentsSeparatedByString("+")
        var scrolltxts = ""
        for var k = 0; k < scrollArr.count; k++ {
            scrolltxts += (k==0 ? "" : "\n")+scrollArr[k]
        }
        return scrolltxts
    }
    
    func hideKeyboard(){
        myScrollTxt.resignFirstResponder()
        myTxtAdress.resignFirstResponder()
        myTxtPhotoNum.resignFirstResponder()
    }
    
    // 当键盘即将出现
    func keyboardWillShow(sender: NSNotification!) {
        if let userInfo = sender.userInfo {
            
            
            
            // when keyboard begin appear // 当键盘开始出现
            let beginKeyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue()
            
            // when keyboard end appear // 当键盘结束出现
            let endKeyboardSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue()
            
            // get when keyboard change frame // 取得出现到开始之间的值
            
            var deltaY:CGFloat = endKeyboardSize!.origin.y - beginKeyboardSize!.origin.y
            
            println("deltaY:!!!!!!!\(deltaY)")
            //        println("deltay:!!!!%f", &deltaY)
            
            self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+deltaY, self.view.frame.size.width, self.view.frame.size.height)
            
            
            if let keyboardSize = (sender.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
                println("height!!!!!!\(keyboardSize.height)")
                println("view height!!!!\(self.view.frame.size.height)")
                UIView.animateWithDuration(0.1, animations: { () -> Void in
                    
                })
            }
            
        }
    }
    
    // 当键盘即将消失
    func keyboardWillDisappear(notification:NSNotification) {
        if self.view.frame.origin.y > 0 {
            //            self.moveViewUp(true)
            self.view.frame.origin.y = 0
        }
        else if self.view.frame.origin.y < 0 {
            //            self.moveViewUp(false)
            self.view.frame.origin.y = 0
        }
    }
    
    // 当View消失时移除监听事件
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        
        myScrollTxt.resignFirstResponder()
        myTxtAdress.resignFirstResponder()
        myTxtPhotoNum.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
