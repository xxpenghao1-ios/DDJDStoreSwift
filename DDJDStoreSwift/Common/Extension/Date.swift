//
//  Date.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/7/6.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
extension Date{
    ///根据传入的时间 和天数 换算成 几天后的时间
    func expectDate(dateStr:String?,day:Int) -> String{
        if dateStr == nil{
            return ""
        }
        let dateFormatter=DateFormatter()
        dateFormatter.dateFormat="yyyy-MM-dd HH:mm:ss"
        let orderTime=dateFormatter.date(from:dateStr!)
        if orderTime == nil{
            return ""
        }
        let time=Date(timeInterval:TimeInterval(60*60*24*day),since:orderTime!)
        let date=dateFormatter.string(from: time)
        return date
    }
}
