//
//  PayViewController.swift
//  suispa
//
//  Created by MrLovelyCbb on 15/1/30.
//  Copyright (c) 2015年 MrLovelyCbb. All rights reserved.
//

import UIKit

class PayViewController: UIViewController , UITableViewDataSource , UITableViewDelegate , UIAlertViewDelegate , UIActionSheetDelegate{
    
    @IBOutlet weak var btnPayBack: UIButton!
    @IBOutlet weak var btnPayWay: UIButton!
    @IBOutlet weak var myShopTableView: UITableView!
    @IBOutlet weak var myPayTableView: UITableView!
    
    @IBAction func btnPayBackClicked(sender: AnyObject) {
        var mainVC = self.storyboard?.instantiateViewControllerWithIdentifier(SB_MainView) as! ViewController
        self.navigationController?.pushViewController(mainVC, animated: false)
    }
    
    @IBAction func btnPayWayClicked(sender: AnyObject) {
        if isHttpComplete {
            requestOrderID()
        }
    }
    @IBAction func btnAgreeClicked(sender: AnyObject) {
        var agreeVC = self.storyboard?.instantiateViewControllerWithIdentifier(SB_AgreeView) as! AgreeViewController
        self.navigationController?.pushViewController(agreeVC, animated: false)
        agreeVC.jumpViewStr = jumpViewStr
    }
    
    var itemArray:Array<String> = ["商品名称：","商品价格：","参保串号："]
    var detailsList:Array<String> = []
    var payTypeList:Array<PayTypeInfo> = []
    var tempSelected:Int = 0
    var isGenerateComplete = false
    var orderinfo:ServicesInfo?
    var tempExchangeStr:String = ""
    var jumpViewStr = "main"
    var isHttpComplete = false
    

    // Alipay swift By MrLovelyCbb
    let partner = "2088711686468755"
    let seller = "2745812192@qq.com"
    let privateKey = "MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAL5NlsHlWA7nl4D09yBsyIvehBkN1EzWeYEgomoNOXufmiuD/qZKCMcDNlMT9nrUu+DDY7pV8Pgp7JKqd+e9I9GtZSYfy4cfA/bcK1gt4l9tKIDoRRXxA5DXZEdxiRz/wk59KsgAB+lVnrp5M21Utgy0cRuSpQX7hAOQKwGH8YZVAgMBAAECgYAGn5q0qu/SrPrX8S68wSyFubvtR07xUbGu7dzZRhaPF/H8u75cOU1u58y3PYWhps/XNdW9wYn+iS8Dt80ukqWxcifvNvtLxL1Fi1v+IW2GXYl/SYrvFMBLC+23s3ShPAN2gBjIxB6fQsc4iG3EPKaj0eIIdZlJTjs05pUW8TwmLQJBAO4WTe0tmIYe+ggoAAYVMo3jCA4H9dOScHam3+U0PMv/r40eLNg6fjaBIMniFn/vhVImrg0RYmN7cd7iqtVVTBMCQQDMnu+p3JXRdGM5hbPNKDfdJ4anCVEVUblvzisl8Hah5K55nPN+EJo2vg5x5LyUCCGkv48ezRy+65k8VqU5KmD3AkBlVN7jxFU3ODXohMXF0P3MP8Vs21x4KMpu5YVDcyExHeikoiQp/3M6VWkUI4K5/sJ6fXX0n+KFPsPvPf/BfmU7AkAHaLXa267dD67MFWhGRG+JZXX9tFuoPvZM8xUi4YsaH5KluqYiaW18D/Or8hFV9tlpArqm7dxdmWBKDAUdhchPAkEA3H+SbmiTIedq3nd2AowmQqMoKLXyQ+Yl3BfuVKXpn1wWFuTVLDirQZ5Wp6uXAb+pITtoFnet1Gf6bXrGYuV3yQ=="
    let alipay_service = "mobile.securitypay.pay"
    let alipay_paymentType = "1"
    let alipay_inputCharset = "utf-8"
    let alipay_itBPay = "30m"
    let alipay_showUrl = "m.alipay.com"
    let suispa_appScheme = "suispa"
    let alipay_notifyURL = "http://app.youmsj.cn/ordern/alipayiosnotify.html"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isGenerateComplete = false
        // Do any additional setup after loading the view.
        
        // 请求支付列表
        requestPayType()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
//        println("走进来了............................")
        if !AppDelegate.isConnectedToNetwork(){
            isHttpComplete = false
        }
    }
    
    func payTypeFunc() {
        if tempSelected == 0 {
            let payTypeInfo = self.payTypeList[tempSelected] as PayTypeInfo
            tempSelected = payTypeInfo.payValue!.toInt()!
        }
        switch tempSelected {
        case 1:
            // 银联支付
            break
        case 2:
            // 支付宝支付
            alipayWay()
            break
        case 3:
            // 充值卡支付
            exchangeNumPay()
            break
        case 4:
            // 苹果支付
            applePay()
            break
        default:
            // 默认支付宝
            alipayWay()
            break
        }
    }
    
    // request payTypeList
    func requestPayType() {
        var httpPara = HttpParamers().httpArrDescription()
        let defaults = NSUserDefaults.standardUserDefaults()
        if let service_id = defaults.stringForKey(USER_serviceID) {
            httpPara.updateValue(service_id, forKey: "arr8")
        }
//        println("requestPayType Parameters-------\(httpPara)")
        request(.POST, get_ServiceInfoUrl, parameters: httpPara).responseJSON { (_, _, data, _) -> Void in
            if let _data:AnyObject = data {
                let jsonData = JSON(_data)
//                println("Request HTTP PayTypeList---------\(jsonData)")
                if let payData = jsonData["data"] as JSON? {
                    
                    let tmpOrderData = ServicesInfo(params: payData)
                    self.detailsList.append(tmpOrderData.name)
                    var priceInt:CGFloat = CGFloat(tmpOrderData.price.toInt()!)
                    priceInt = CGFloat(priceInt / 100)
                    let priceStr = priceInt.description 
                    self.detailsList.append(priceStr+"元")
                    if let renewUUID = defaults.stringForKey(USER_renewUUID) {
                        self.detailsList.append(renewUUID)
                    }else{
                        println("12312321312312\(tmpOrderData.imei)\(tmpOrderData.uuid)")
                        self.detailsList.append(httpPara["arr100"]!)
                    }
                    
                    if let payTypeArr = payData["paytype"].arrayValue as [JSON]? {
                        for (var i=0;i < payTypeArr.count;i++){
                            var tmpListPayType:PayTypeInfo = PayTypeInfo(payTypeJson: payTypeArr[i])
                            self.payTypeList.append(tmpListPayType)
                        }
                        // 加载支付 
                        dispatch_async(dispatch_get_main_queue()){
                            self.myPayTableView.delegate = self
                            self.myPayTableView.dataSource = self
                            self.myPayTableView.reloadData()
                            self.tempSelected = 0
                            var selectedIndex:NSIndexPath = NSIndexPath(forRow: 0, inSection: 0)
                            self.myPayTableView.selectRowAtIndexPath(selectedIndex, animated: false, scrollPosition: UITableViewScrollPosition.None)
                        }
                    }

                    // 加载Details
                    dispatch_async(dispatch_get_main_queue()){
                        self.myShopTableView.delegate = self
                        self.myShopTableView.dataSource = self
                        self.myShopTableView.reloadData()
                    }
                    self.isHttpComplete = true
                }
            }else{
                self.isHttpComplete = false
                // 检测网络
//                if AppDelegate.isConnectedToNetwork() == false {
//                    var uiAlert = UIAlertView(title: "网络连接异常!", message: "暂无法访问服务器,请检查是否联网。", delegate: self, cancelButtonTitle: "确定")
//                    uiAlert.show()
//                    return
//                }
            }
        }
    }
    
    
    // request orderID
    // 请求订单号
    // 1、arr8:用户ID  2、arr9:服务ID 3、arr10:充值金额 4、arr11:充值渠道 5、arr12:参保/续保 UUID
    func requestOrderID() {
        var httpPara = HttpParamers().httpArrDescription()
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let user_id = defaults.stringForKey(USER_userID) {
            httpPara.updateValue(user_id, forKey: "arr8")
        }
        if let service_id = defaults.stringForKey(USER_serviceID) {
            httpPara.updateValue(service_id, forKey: "arr9")
        }
        if let service_price = defaults.stringForKey(USER_servicePrice) {
            httpPara.updateValue(service_price, forKey: "arr10")
        }
        if let uuidStr = defaults.stringForKey(USER_renewUUID) {
            httpPara.updateValue(uuidStr, forKey: "arr12")
        }
        if tempSelected == 0 && self.payTypeList.count > 0 {
            let payTypeInfo = self.payTypeList[tempSelected] as PayTypeInfo
            tempSelected = payTypeInfo.payValue!.toInt()!
        }
            httpPara.updateValue(tempSelected.description, forKey: "arr11")
        if tempSelected >= 4 {
            httpPara.updateValue("2", forKey: "arr11")
        }
//        println("订单请求：--------\(httpPara)")
        self.view.alpha = 0.88  
        request(.POST, get_GeneratePayOrderUrl, parameters: httpPara).responseJSON { (_, _, data, _) -> Void in
            if let _data:AnyObject = data {
                let jsonData = JSON(_data)
                if let orderData = jsonData["data"] as JSON? {
                    let tmpOrderData = ServicesInfo(params: orderData)
                    self.orderinfo = tmpOrderData
                    println("订单User:--------\(tmpOrderData.uid)")
                    println("订单ID:----------\(tmpOrderData.orderid)")
                    self.view.alpha = 1
                    self.isGenerateComplete = true
                    self.payTypeFunc()
                }
            }
        }
    }
    
    // Object C CallBack This Function
    func OCAppleCallBack(orderStr:NSString,orderID:NSString) -> Void {
        println("OC Call back This\(orderStr)")
        
        let parameters = [
            "arrOrderId":orderID as String,
            "arrApple":orderStr as String
        ]
        request(.POST, get_AppleOrderUrl, parameters: parameters)
    }
    
    func OCJumpViewController() ->Void {
        // 苹果支付成功之后
//        var uiAlert = UIAlertView(title: "消息!", message: "支付成功", delegate: self, cancelButtonTitle: "确定")
        //                    uiAlert.show()
//        self.navigationController?.pushViewController(reNewVC, animated: true)
    }
    
    // 苹果支付
    func applePay() {
        var iapComFun = IapComFun.shareInstance()
        let priceInt:String = self.orderinfo!.prize
        let nssPrice = priceInt as NSString
        let nssPriceInt = nssPrice.intValue / 100
        let orderIDInt:NSString = self.orderinfo!.orderid as NSString
        iapComFun._iosIapManager(1, sp: 2, iapmoney: nssPriceInt, gameid: orderIDInt as String)
    }
    
    // 支付宝支付
    func alipayWay() {
        let order:Order = Order()
        
        order.partner = partner
        order.seller = seller
        order.tradeNO = self.orderinfo?.orderid
        let tempProductName = self.orderinfo!.name
        order.productName = tempProductName
        order.productDescription = tempProductName
        
        var priceInt:CGFloat = CGFloat(self.orderinfo!.prize.toInt()!)
        priceInt =  CGFloat( priceInt / 100 )
        order.amount = priceInt.description
        //        order.amount = "0.01"
        order.notifyURL = alipay_notifyURL
        order.service = alipay_service
        order.paymentType = alipay_paymentType
        order.itBPay = alipay_itBPay
        order.showUrl = alipay_showUrl
        order.inputCharset = alipay_inputCharset
        
        let orderSpec = order.description
        //        println("OrderSpace--------------:\(orderSpec)")
        var signer = CreateRSADataSigner(privateKey)
        //        let signer2 = RSADataSigner(privateKey: privateKey)
        let signedString = signer.signString(orderSpec)
        //        println("SignString--------------:\(signedString)")
        
        let orderString = "\(orderSpec)&sign=\"\(signedString)\"&sign_type=\"RSA\""
        //        println("OrderID-----------\(orderString)")
        
        AlipaySDK.defaultService().payOrder(orderString, fromScheme: suispa_appScheme) { (resultDic) -> Void in
            println("Alipay result = \(resultDic as Dictionary)")
            // 支付宝成功之后 跳转至续保界面
            var reNewVC = self.storyboard?.instantiateViewControllerWithIdentifier("RenewStoryboard") as! RenewViewController
            self.presentViewController(reNewVC, animated: true, completion: nil)
        }
        
    }
    
    // 
    //  兑换码支付
    //  arr8 = 订单号
    //  arr9 = 兑换卡号
    //
    func exchangeNumPay() {
        var httpPara = HttpParamers().httpArrDescription()
        let defaults = NSUserDefaults.standardUserDefaults()
        
//        if let username = defaults.stringForKey(USER_username) {
//            httpPara.updateValue(username, forKey: "arr8")
//        }
//        if let password = defaults.stringForKey(USER_password) {
//            httpPara.updateValue(password, forKey: "arr6")
//        }

        var arr8 = self.orderinfo!.orderid
        var arr9 = self.tempExchangeStr
        if arr9 == "" || arr9.isEmpty {
            if self.tempExchangeStr == "" {
                exchange()
            }
//            alertExchangeNum()
            return
        }
        
        httpPara.updateValue(arr8, forKey: "arr8")
        httpPara.updateValue(arr9, forKey: "arr9")
        
        println("兑换码请求参数...\(httpPara)")
        request(.POST, get_PayCardCallBackUrl, parameters: httpPara).responseJSON { (request, response, data, error) -> Void in
            println("兑换码请求返回：-------\(data)")
            if let _data:AnyObject = data {
                let jsonObj = JSON(_data)
                // 兑换码支付成功
                if let strSucess = jsonObj["status"].string{
                    var alertView:UIAlertView?
                    if strSucess.toInt() == 0 {
                        alertView = UIAlertView(title: "提示", message: "兑换成功！", delegate: self, cancelButtonTitle: "确定")
                        alertView!.tag = 999
                    }else {
                        alertView = UIAlertView(title: "提示", message: jsonObj["info"].stringValue, delegate: self, cancelButtonTitle: "确定")
                        alertView!.tag = 1000
                    }
                    alertView!.delegate = self
                    alertView!.show()
                    // 点击将清空
                    self.tempExchangeStr = ""
                }
            }
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if tableView.isEqual(myShopTableView) {
            return false
        }
        return true
    }
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if tableView.isEqual(myShopTableView) {
            return false
        }
        return true
    }
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if tableView.isEqual(myShopTableView) {
            return false
        }
        return true
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView.isEqual(myPayTableView) {
            let payTypeInfo = self.payTypeList[indexPath.row] as PayTypeInfo
//            println("点击PayTypeInfo Value：\(payTypeInfo.payName)\(payTypeInfo.payValue)")
            
            if payTypeInfo.payValue!.toInt() == 3 {
                tempSelected = 3
                requestOrderID()
                //exchange()
            }else {
                tempSelected = payTypeInfo.payValue!.toInt()!
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.isEqual(myShopTableView) {
            return self.detailsList.count ?? 0
        } else if tableView.isEqual(myPayTableView) {
            return self.payTypeList.count ?? 0
        }
        return 0
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView.isEqual(myShopTableView) {
            return ""
        }else if tableView.isEqual(myPayTableView) {
            return ""
        }
        return ""
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView.isEqual(myShopTableView) {
            var cell = tableView.dequeueReusableCellWithIdentifier("payDetailsCell") as! PayDetailsTableViewCell
            cell.myLblTitle.text = self.itemArray[indexPath.row] as String
            cell.myLblValue.text = self.detailsList[indexPath.row]
            return cell
        }else if tableView.isEqual(myPayTableView) {
            var cell1:PayWayTableViewCell = tableView.dequeueReusableCellWithIdentifier("PayWayCell") as! PayWayTableViewCell
            let payTypeInfo = self.payTypeList[indexPath.row] as PayTypeInfo
            cell1.myPayWayTitle.text = payTypeInfo.payName
            cell1.myPayWayDescription.text = payTypeInfo.payDescription
            cell1.myPayWayImage.image = payTypeInfo.payImage
            return cell1
        }
        return UITableViewCell()
    }
    
    func alertExchangeNum() {
        var alertView = UIAlertView(title: "警告", message: "兑换码不能为空,请重新输入", delegate: self, cancelButtonTitle: "确定")
        alertView.delegate = self
        alertView.show()
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        var button = alertView.buttonTitleAtIndex(buttonIndex)
        if alertView.tag == 111 {
            if button == "兑换" {
                tempExchangeStr = alertView.textFieldAtIndex(0)!.text
                // 发送请求...Url_ExchangeNum
                println("兑换码：-----\(tempExchangeStr)")
                exchangeNumPay()
            }
        }else if alertView.tag == 999 {
            if self.jumpViewStr == JUMP_renew {
                var reNewVC = self.storyboard?.instantiateViewControllerWithIdentifier(SB_RenewView) as! RenewViewController
//                self.presentViewController(reNewVC, animated: true, completion: nil)
                self.navigationController?.pushViewController(reNewVC, animated: false)
            }else if self.jumpViewStr == JUMP_main {
                var mainVC = self.storyboard?.instantiateViewControllerWithIdentifier(SB_RenewView) as! ViewController
                self.navigationController?.pushViewController(mainVC, animated: false)
            }
        }
    }
    
    func exchange() {
        var alertView = UIAlertView()
        alertView.delegate = self
        alertView.alertViewStyle = UIAlertViewStyle.PlainTextInput
        alertView.title = "输入兑换码"
        alertView.message = "请输入16位数兑换码"
        alertView.addButtonWithTitle("取消")
        alertView.addButtonWithTitle("兑换")
        alertView.textFieldAtIndex(0)?.keyboardType = UIKeyboardType.NumberPad
        alertView.tag = 111
        alertView.show()
        
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