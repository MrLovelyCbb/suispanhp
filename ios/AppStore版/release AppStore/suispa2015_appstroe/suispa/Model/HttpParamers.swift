//
//  HttpParamers.swift
//  suispa
//
//  Created by MrLovelyCbb on 15/1/30.
//  Copyright (c) 2015年 MrLovelyCbb. All rights reserved.
//

import UIKit

// 苹果——Applestore   普通版为2
// 苹果——支付宝        企业版为3

// NSUserDefaults
let USER_username = "username"      // 用户名
let USER_password = "password"      // 电话号码
let USER_serviceID = "S_serviceID"  // 服务ID
let USER_servicePrice = "S_price"   // 服务价钱
let USER_userID = "user_ID"         // 用户ID
let USER_isService = "is_Service"   // 此用户是否有服务
let USER_scIsShow = "scIsShow"      // 是否显示商店
let USER_payIsShow = "payIsShow"    // 是否显示支付
let USER_insur = "insur"            // 本机是否参保
let USER_isLogin = "is_Login"       // 是否登录
let USER_renewUUID = "RenewUUID"    // 续保或本机UUID (可选)
let USER_borkenScreen = "BrokenScreenGuide" // 是否完成新手

// Jump ViewController
let JUMP_main = "main"              // 主页
let JUMP_pay  = "pay"               // 支付
let JUMP_renew = "renew"            // 续费
let JUMP_login = "login"            // 登录
let JUMP_report = "report"          // 报修

let SB_MainView = "sb_MainView"                     // storyboard
let SB_RenewView = "sb_RenewView"               // storyboard
let SB_ReportView = "sb_ReportView"             // storyboard
let SB_PayView = "sb_PayView"                   // storyboard
let SB_ShopMarketView = "sb_ShopMarketView"     // storyboard
let SB_AgreeView = "sb_AgreeView"               // storyboard
let SB_LoginView = "sb_LoginView"               // storyboard
let SB_GuideImageView = "sb_GuideImageView"     // storyboard

// Http Url 请求
// 请求列表如下:

// 主页、滚动图、参数Url
let get_ScrollViewUrl = "http://app.youmsj.cn/"
// 获取单个服务信息Url
let get_ServiceInfoUrl = "http://app.youmsj.cn/index/content.html"
// 登陆Url
let get_LoginInfoUrl = "http://app.youmsj.cn/login.html"
// 获取协议Url
let get_ProtocolUrl = "http://app.youmsj.cn/info/about.html"
// 兑换卡支付回调
let get_PayCardCallBackUrl = "http://app.youmsj.cn/ordern/cardCallBack.html"
// 查询订单
let get_QueryPayOrderUrl = "http://app.youmsj.cn/ordern/searchorder.html"
// 生成订单
let get_GeneratePayOrderUrl = "http://app.youmsj.cn/ordern/index.html"
// 检查更新
let get_CheckAppUpdateUrl = "http://app.youmsj.cn/updata/index.html"
// 用户反馈
let send_SuggestUrl = "http://app.youmsj.cn/feedBack/index.html"
// 话费参保
let send_mobileRMBUrl = "http://app.youmsj.cn/HfOrder.html"
// 查看IMEI参保信息
let get_QueryIMEIUrl = "http://app.youmsj.cn/index/iscb.html"
// 发送效验码至服务器验证Apple账单
let get_AppleOrderUrl = "http://app.youmsj.cn/ordern/ioscallback.html"


//定义全局设备类型
let APPLICATION_HTTP_deviceTypeInt = 2          // 设备类型
let APPLICATION_HTTP_Comefrom = 0               // 来源，从哪来
let APPLICATION_HTTP_macAdress = 0              // Mac地址
let APPLICATION_HTTP_ServicePartnerInt = 1      // 服务商
let LockSmith_Service = "LaiGame"               // Ios App 服务供应商
let LockSmith_UserAccount = "MrLovelyCbb"       // Ios 账号
let Application_md5Key = "#i-aola+youx@a.d|bwid_1s*ds&d^ada%da!as~iph(asdn?ak}g"    // MD5秘钥
let Application_LockSmith_AppName = "UUID"      // App UUID
let Application_DefaultPhoneNumber = "00000000000" // 默认的电话号码

class HttpParamers: NSObject {
    var arr0:String,arr1:String,arr2:String,arr3:String,arr4:String,arr5:String,arr6:String,arr7:String,arr100:String
    
    override init() {
        let timestamp = String(Int32(NSDate().unixNowTime))
        let (dictionary,error) = Locksmith.loadDataForUserAccount(LockSmith_UserAccount, inService: LockSmith_Service)
        var UUID:String = ""
        if let dictionary = dictionary
        {
            UUID = dictionary["UUID"] as! String
        }else {
            UUID = NSUUID().UUIDString
            let saveError = Locksmith.saveData([Application_LockSmith_AppName:UUID],forUserAccount:LockSmith_UserAccount,inService:LockSmith_Service)
        }
        
        var PNumber = Application_DefaultPhoneNumber
        var nsUserDefault = NSUserDefaults.standardUserDefaults()
        if let phoneNumber = nsUserDefault.stringForKey(USER_password){
            PNumber = phoneNumber
        }
        self.arr0 = APPLICATION_HTTP_Comefrom.description
        self.arr1 = APPLICATION_HTTP_deviceTypeInt.description    // 设备类型1:安卓 2:IOS 3：IOS企业版
        self.arr2 = APPLICATION_HTTP_ServicePartnerInt.description    // 服务商1：移动 2：电信 3：联通
        self.arr3 = timestamp    // 客户端时序
        self.arr4 = UUID    // 客户端设备号
        self.arr5 = APPLICATION_HTTP_macAdress.description// 客户端mac地址
        self.arr6 = PNumber    // 用户手机号
        self.arr100 = UUID // 设备唯一号
        self.arr7 = (self.arr0 + self.arr1 + self.arr2 + self.arr3 + self.arr4 + self.arr5 + self.arr6 + Application_md5Key).md5    // 效验码
        
        println("设备唯一UUID:---------\(self.arr100)")
    }
    
    func httpArrDescription() -> Dictionary<String,String>{
        var dictionary:Dictionary<String,String> = [
            "arr0":self.arr0,
            "arr1":self.arr1,
            "arr2":self.arr2,
            "arr3":self.arr3,
            "arr4":self.arr4,
            "arr5":self.arr5,
            "arr6":self.arr6,
            "arr7":self.arr7,
            "arr100":self.arr100
        ]
        return dictionary
    }
}
