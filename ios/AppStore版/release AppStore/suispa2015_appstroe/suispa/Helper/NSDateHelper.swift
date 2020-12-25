//
//  NSdateHelper.swift
//  suispa
//
//  Created by JXDS on 14/12/24.
//  Copyright (c) 2014年 ZXHD. All rights reserved.
//

import Foundation

public extension NSDate{
    
    // 现在的 unix 时间戳
    var unixNowTime:NSTimeInterval  {return NSDate().timeIntervalSince1970}
    
    // 现在的字符传 格式
    var stringNowTime:NSString {return dateToString(NSDate(), dateFormat: "")}
    
    // 现在的 时间格式
    var dateNowTime:NSDate {return NSDate()}
    
    //今天的时间格式
    var dateTodayTime:NSDate{return stringToDate(stringTodayTime, dateFormat: "yyyy年MM月dd日")}
    
    //今天的时间戳格式
    var unixTodayTime:NSTimeInterval{return dateToUnix(dateTodayTime)}
    
    //今天的字符串格式
    var stringTodayTime:NSString{return dateToString(dateNowTime, dateFormat: "yyyy年MM月dd日")}
    
    // 时间戳 转 时间
    func unixToDate(unixTime:NSTimeInterval) -> NSDate{
        
        return NSDate(timeIntervalSince1970: unixTime)
    }
    
    var nanosecond:Int { return NSCalendar.currentCalendar().components(.CalendarUnitNanosecond, fromDate: self).nanosecond }
    
    // NSDate().nanosecond  纳秒
    // NSDate().formattedWith("HH:mm:ss.SSS")
    func formattedWith(format:String) -> String {
        let formatter = NSDateFormatter()
        formatter.timeZone = NSTimeZone.localTimeZone()
        formatter.dateFormat = format
        return formatter.stringFromDate(self)
    }
    
    // 高级C写法
//    func adavertTime(maxSize:UInt) -> NSString {
//        var buffer: [CChar] = [CChar](count: maxSize, repeatedValue: 0)
//        var time:time_t = Int(NSDate().timeIntervalSince1970)
//        var length = strftime(&buffer, maxSize, "%-l:%M\u2008%p", localtime(&time))
//        var dateString = NSString(bytes: buffer, length: Int(length), encoding: NSUTF8StringEncoding)
//        return dateString
//    }
    
    // 时间戳
    func unixA(unixTime:NSTimeInterval) -> NSDate {
        return NSDate(timeIntervalSinceReferenceDate: unixTime);
    }
    
    //  时间 转 时间戳
    func dateToUnix(dateTime:NSDate) -> NSTimeInterval{
        
        return dateTime.timeIntervalSince1970
    }
    
    //  时间 转 时间戳
    func dateToString(dateTime:NSDate,dateFormat:String) -> NSString{
        
        var formatter = NSDateFormatter()   //新建一个时间格式化工具
        
        var dateForma = ""
        
        if(dateFormat == ""){dateForma = "yyyy年MM月dd日 HH:mm"}
        
        formatter.dateFormat = dateFormat == "" ?  dateForma : dateFormat
        
        return formatter.stringFromDate(dateTime)
    }
    
    // 时间戳 转 时间字符串
    func unixToString(unixTime:NSTimeInterval,dateFormat:String) -> NSString{
        
        var date = unixToDate(unixTime)
        
        var formatter = NSDateFormatter()   //新建一个时间格式化工具
        
        var dateForma = ""
        
        if(dateFormat == ""){dateForma = "yyyy年MM月dd日 HH:mm"}
        
        formatter.dateFormat = dateFormat == "" ?  dateForma : dateFormat
        
        return formatter.stringFromDate(date)
        
    }
    
    func unixToStrings(unixTime:NSTimeInterval,dateFormat:String) -> NSString {
        var date = unixToDate(unixTime)
        var formatter = NSDateFormatter()
        var dateForma = ""
        if(dateFormat == ""){
            dateForma = "yyyy年MM月dd日"
        }
        formatter.dateFormat = dateFormat == "" ? dateForma : dateFormat
        return formatter.stringFromDate(date)
    }
    
    // 字符串 转  时间
    func stringToDate(stringTime:NSString,dateFormat:String) -> NSDate{
        
        var outputFormatter = NSDateFormatter()
        
        var dateForma = ""
        
        if(dateFormat == ""){dateForma = "yyyy年MM月dd日 HH:mm"}
        
        
        outputFormatter.dateFormat = dateFormat == "" ? dateForma : dateFormat
        
        return outputFormatter.dateFromString(stringTime as String)!
    }
    
    // 字符串 转 时间戳
    func stringToUnix(stringTime:NSString) -> NSTimeInterval{
        
        
        return dateToUnix(stringToDate(stringTime, dateFormat: ""))
    }
    
    //调整日期
    func adjustDate(date:NSDate,intervalDay:NSInteger) -> NSDate{
        
        var datTime = 33600 * 24
        
        var timeSS = intervalDay * datTime
        
        return date.dateByAddingTimeInterval(Double(timeSS))
        
    }
    
    
    
    func timeStdate(intiDate:NSDate) ->NSString{//这个方法有错误，希望指正。这是算时间间隔的，但是对于字符串的截取真心不会
        
        var unixStringTime = "\(intiDate.timeIntervalSince1970)"    //把传入的时间转换成时间戳格式
        
        var timeSp = unixStringTime.substringToIndex(advance(unixStringTime.startIndex, 10)) as NSString    //截取前10个字符
        
        var StringTime:NSString?    //设置一个字符串事件类型那个的字段
        
        var nowDate = NSDate()  //获取当前的时间
        
        var seconds = nowDate.timeIntervalSince1970 //获取当前时间的unix时间戳格式
        
        var timeDistance:Double = seconds - timeSp.doubleValue //现在的时间 和 之前的时间  时间差
        
        var aHourTime:Double = 660 * 60 //  每一个小时有多少秒
        
        var time = timeSp.doubleValue   //将字符串转换成时间戳
        
        var detaildate = NSDate(timeIntervalSince1970: time)    //通过时间戳转换为 时间格式
        
        var formatter = NSDateFormatter()   //新建一个时间格式化工具
        
        formatter.dateFormat = "yyyy年MM月dd日 HH:mm"  //设置工具格式化格式
        
        var ayear = formatter.stringFromDate(nowDate)
        
        var year = ayear.substringToIndex(advance(ayear.startIndex, 4))
        
        var current = formatter.stringFromDate(detaildate)
        
        var today = stringTodayTime
        
        var yesterday = adjustDate(dateTodayTime, intervalDay: -1)
        
        var range = NSRange(location: 0,length: 11)
        
        var isYestoday = current.substringToIndex(advance(unixStringTime.startIndex, 11))
        
        if(timeDistance >= aHourTime){
            
            var result = current.substringFromIndex(advance(current.startIndex, 12))
            
            if(isYestoday == today){
                
                var range = Range<String.Index>(start: advance(current.startIndex, 11),end: advance(current.startIndex, 2))
                
                //                var result = current.substringFromIndex(advance(current.startIndex, 12))
                
                if((current.substringWithRange(range) as NSString).doubleValue > 12){
                    
                    return "上午\(result)"
                }else{
                    
                    return "下午\(result)"
                }
            }else if(isYestoday == yesterday){
                
                return "下午\(result)"
                
            }else{
                
                //                if ([current hasPrefix:year]) {//今年
                //                NSString *finalTime=[NSString stringWithFormat:@"%@",[current substringFromIndex:5]];
                //                return finalTime;
                //            }else{
                //                return [[formatter stringFromDate:detaildate] substringToIndex:11];
                //            }
                
                if(current.hasPrefix("year")){
                    
                    var name = current.substringFromIndex(advance(current.startIndex,5))
                    
                    return name
                    
                }else{
                    
                    var name = dateToString(detaildate, dateFormat: "") as NSString
                    
                    return current.substringFromIndex(advance(current.startIndex, 11))
                }
                
            }
            
            
        }else if(timeDistance >= 60){
            
            var minutes = timeDistance / 60
            
            return "\(minutes)分钟前"
            
        }else{
            
            return "刚刚"
            
        }
    }
}