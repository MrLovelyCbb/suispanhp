//
//  ServicesInfo.swift
//  suispa
//
//  Created by MrLovelyCbb on 15/2/9.
//  Copyright (c) 2015年 MrLovelyCbb. All rights reserved.
//

import UIKit

class ServicesInfo: NSObject {
    // 服务信息查询
    var id:String,          // 服务ID
    name:String,            // 服务名
    serdes:String,          // 服务描述
    price:String,           // 价格
    xf_price:String,        // 续费价格
    sid:String,             // 用户购买服务ID
    
    // 生成订单查询
    uid:String,             // 用户ID
    expire:String,          // 用户购买服务过期时间(时间戳)
    imei:String,            // 用户设备IMEI
    dtime:String,           // 支付时间
    utime:String,           // 用户时间
    state:String,           // 订单状态
    sp:String,              // 来源
    usp:String,             // 充值渠道
    orderid:String,         // 订单号
    orderidrn:String,       // 第三方订单号
    prize:String,           // 充值金额
    uuid:String             // 购买服务名称
    
    init(params:JSON) {
        self.id = params["id"].stringValue
        self.name = params["name"].stringValue
        self.serdes = params["serdes"].stringValue
        self.price = params["price"].stringValue
        self.prize = params["prize"].stringValue
        self.xf_price = params["xf_price"].stringValue
        
        self.state = params["state"].stringValue
        self.sp = params["sp"].stringValue
        self.usp = params["usp"].stringValue
        self.orderid = params["orderid"].stringValue
        self.orderidrn = params["orderrn"].stringValue
        self.uuid = params["uuid"].stringValue
        
        self.sid = params["sid"].stringValue
        self.uid = params["uid"].stringValue
        self.expire = params["expire"].stringValue
        self.imei = params["imei"].stringValue
        self.dtime = params["dtime"].stringValue
        self.utime = params["utime"].stringValue
    }
}
