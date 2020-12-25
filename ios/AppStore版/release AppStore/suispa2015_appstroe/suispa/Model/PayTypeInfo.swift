//
//  PayTypeInfo.swift
//  suispa
//
//  Created by MrLovelyCbb on 15/2/9.
//  Copyright (c) 2015年 MrLovelyCbb. All rights reserved.
//

import UIKit

class PayTypeInfo: NSObject {
    var payValue:String?,payName:String?,payDescription:String?
    var payImage:UIImage?
    
    init(payTypeJson:JSON) {
        self.payValue = payTypeJson["value"].stringValue
        self.payName = payTypeJson["name"].stringValue
        
        var payValueInt:Int = payValue!.toInt()!
        var payDesContent = " "
        var payImageName = "ic_alipay_plugin_enabled"
        switch payValueInt {
        case 1:
            payDesContent = "推荐银联卡开通快捷支付使用"
            payImageName = "ic_app_plugin_enabled"
            break
        case 2:
            payDesContent = "推荐有支付宝客户端的用户使用"
            payImageName = "ic_alipay_plugin_enabled"
            break
        case 3:
            payDesContent = "输入16位卡密方式使用"
            payImageName = "ic_exchange_plugin_enabled.png"
            break
        case 4:
            payDesContent = "通过苹果AppStore方式使用"
            payImageName = "ic_app_plugin_enabled"
            break
        default:
            payDesContent = " "
            break
        }
        self.payImage = UIImage(named: payImageName)
        self.payDescription = payDesContent
    }

}
