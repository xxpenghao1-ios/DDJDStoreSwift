//
//  VouchersModel.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/7/20.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import ObjectMapper
///代金劵
struct VouchersModel:Mappable{
    ///金额
    var cashCouponAmountOfMoney:Int?
    ///到期时间
    var cashCouponExpirationDate:String?
    ///剩余时间
    var cashCouponExpirationDateInt:String?
    ///id
    var cashCouponId:Int?
    ///代金券是否过期；1 没过期；2 已过期 ；3 已使用
    var cashCouponStatu:Int?
    ///代金券获取方式； 1，积分转换获得；2，系统赠送
    var cashCouponObtainFlag:Int?
    init?(map: Map) {
    }
    mutating func mapping(map: Map) {
        cashCouponAmountOfMoney <- map["cashCouponAmountOfMoney"]
        cashCouponExpirationDate <- map["cashCouponExpirationDate"]
        cashCouponExpirationDateInt <- map["cashCouponExpirationDateInt"]
        cashCouponId <- map["cashCouponId"]
        cashCouponStatu <- map["cashCouponStatu"]
        cashCouponObtainFlag <- map["cashCouponObtainFlag"]

    }
}
