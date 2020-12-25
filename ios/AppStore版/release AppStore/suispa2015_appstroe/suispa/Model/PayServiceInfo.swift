//
//  PayServiceInfo.swift
//  suispa
//
//  Created by MrLovelyCbb on 15/2/9.
//  Copyright (c) 2015年 MrLovelyCbb. All rights reserved.
//

import UIKit

class PayServiceInfo: NSObject {
    var imei:String,            // IMEI or UUID
    dtime:String,               // 开始服务时间
    expire:String               // 过期服务时间
    
    init(params:JSON) {
        self.imei = params["imei"].stringValue
        self.dtime = params["dtime"].stringValue
        self.expire = params["expire"].stringValue
    }
}
