//
//  StringHelper.swift
//  testProject
//
//  Created by JXDS on 14-11-20.
//  Copyright (c) 2014年 ZXHD. All rights reserved.
//

import Foundation
import UIKit

extension String {
    var md5:String!{
        let str = self.cStringUsingEncoding(NSUTF8StringEncoding)
        let strlen = CC_LONG(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen)
        
        CC_MD5(str!, strlen, result)
        
        var hash = NSMutableString()
        for i in 0 ..< digestLen
        {
            hash.appendFormat("%02x", result[i])
        }
        result.destroy()
        
        return String(format:hash as String)
    }
    
    // html
    var htmlString:NSAttributedString {
        return NSAttributedString(data: dataUsingEncoding(NSUTF8StringEncoding)!, options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType], documentAttributes: nil, error: nil)!
    }
    
    // SplitStr  分割字符串为数组
    var splitStr:Array<String> {
        let myStringArr = self.componentsSeparatedByString("|")
        return myStringArr
    }
    
    func appendParameter(arr8:String,arr9:String,arr10:String,arr11:String,arr12:String) -> NSDictionary{
        let userDefaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let md5Key:String = userDefaults.valueForKey("C_md5Key")!.description
        let date = NSDate()
        let timestamp = String(Int32(date.unixNowTime))
        println("时间戳：\(timestamp)")
        let arr7 = ("" + "" + "" + "" + "" + "" + "" + "" + md5Key).md5
        let parameters = [
            "arr0":"",
            "arr1":"",
            "arr2":"",
            "arr3":timestamp,
            "arr4":"",
            "arr5":"",
            "arr6":"15527006075",
            "arr7":arr7,
            "arr8":arr8,
            "arr9":arr9,
            "arr10":arr10,
            "arr11":arr11,
            "arr12":arr12
        ]
        
        return parameters
    }
}


extension UIViewController {
//   public override func  -> Bool {
//        return true
//    }
}
