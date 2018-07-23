//
//  IntegralRecordModel.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/7/23.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import ObjectMapper
///积分记录
struct IntegralRecordModel:Mappable{
    ///会员ID
    var memberId:Int?;
    ///状态1 兑换商品扣除。2，充值。3，购物获得
    var integralType:Int?;
    ///积分扣除或者充值记录 ； 存储如-5或+5
    var integral:String?;
    ///生成时间
    var time:String?;
    init?(map: Map) {
        mapping(map: map)
    }
    mutating func mapping(map: Map) {
        memberId <- map["memberId"]
        integralType <- map["integralType"]
        integral <- map["integral"]
        time <- map["time"]
    }
}
