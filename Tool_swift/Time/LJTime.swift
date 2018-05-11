//
//  LJTime.swift
//  Tool_swift
//
//  Created by 杰刘 on 2018/5/11.
//  Copyright © 2018年 刘杰. All rights reserved.
//

import UIKit

class LJTime: NSObject {
    
    //MARK:  获取当前设备的语言
    static func getCurrentLanguage() -> String {
        let preferredLang = Bundle.main.preferredLocalizations.first! as NSString
        //        print("当前系统语言:\(preferredLang)")
        switch String(describing: preferredLang) {
        case "en-US", "en-CN":
            return "en"//英文
        case "zh-Hans-US","zh-Hans-CN","zh-Hant-CN","zh-TW","zh-HK","zh-Hans":
            return "en"//中文
        case "ja":
            return "en"//ri
        case "ko":
            return "en"//han
        case "ru":
            return "en"//俄语
        case "hi":
            return "en"//印度语
        default:
            return "en"
        }
    }
    //MARK: 计算出当前时间
    static func getNowDateFromatAnDate(currentdate:String) -> Int {
        
        //转换为时间
        let timeInterval:TimeInterval = TimeInterval(currentdate)!
        let date = NSDate(timeIntervalSince1970: timeInterval)
        //源时区
        let sourceTimeZone = NSTimeZone.init(abbreviation: "UTC")
        //目标的时区
        let destinationTimeZone = NSTimeZone.local
        //得到源日期与世界标准时间的偏移量
        let sourceGMTOffset = sourceTimeZone?.secondsFromGMT(for: date as Date)
        //目标日期与本地时区的偏移量
        let destinationGMTOffset = destinationTimeZone.secondsFromGMT(for: date as Date)
        //得到时间偏移量的差值
        let interval = destinationGMTOffset - sourceGMTOffset!
        
        let currentdateint = Int(currentdate)
        
        let sourceInt = currentdateint! + interval
   
        return sourceInt
        
    }
    
    //转为时间戳 。
    static func changeDate(currentdate:String) -> String {
        
        
        let timeInterval:TimeInterval = TimeInterval(currentdate)!
        let date = NSDate(timeIntervalSince1970: timeInterval)
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "HH:mm" //自定义日期格式
        let time = dateformatter.string(from: date as Date)
        return time
    }
    
    //转为年月日时间戳 。
    static func getYMDNowTime(currentdate:String) -> String {
        
        //转换为时间
        let timeInterval:TimeInterval = TimeInterval(currentdate)!
        let date = NSDate(timeIntervalSince1970: timeInterval)
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MMM/dd/yyyy"
        let time = dateformatter.string(from: date as Date)
        return time
    }

  //当前时间的时间戳
    static func gettimestamp() -> String{
        let now = Date()
        //当前时间的时间戳
        let timeInterval:TimeInterval = now.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        
        return String(timeStamp)
        
        
    }

}
