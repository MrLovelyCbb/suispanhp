//
//  UserInfo.swift
//  suispa
//
//  Created by MrLovelyCbb on 15/2/9.
//  Copyright (c) 2015年 MrLovelyCbb. All rights reserved.
//

import UIKit

class UserInfo: NSObject {
    var id:String,      // 用户ID
    name:String,        // 用户名
    phone:String,       // 电话
    imei:String,        // 用户设备IMEI
    tel:String,         // 服务商
    mach:String,        // 设备类型
    hb:String,          // 红包
    level:String,       // 等级
    vippoints:String,   // Vip积分
    vippointsot:String, // Vip积分过期时间
    dtime:String,       // 开始时间
    ltime:String,       // 结束时间(expire)
    regip:String,       // 注册时间
    loginnum:String,    // 登录次数
    money:String       // 剩余购机款
    
    init(params:JSON) {
        self.id = params["id"].stringValue
        self.name = params["name"].stringValue
        self.imei = params["imei"].stringValue
        self.tel  = params["tel"].stringValue
        self.mach = params["mach"].stringValue
        self.hb = params["hb"].stringValue
        self.phone = params["phone"].stringValue
        self.level = params["level"].stringValue
        self.vippoints = params["vippoints"].stringValue
        self.vippointsot = params["vippointsot"].stringValue
        self.dtime = params["dtime"].stringValue
        self.ltime = params["ltime"].stringValue
        self.regip = params["regip"].stringValue
        self.loginnum = params["loginnum"].stringValue
        self.money = params["money"].stringValue
    }
}
