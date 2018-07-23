//
//  ExchangeRecordModel.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/7/23.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import ObjectMapper
///兑换记录
struct ExchangeRecordModel:Mappable{
    /// 商品名称
    var goodsName:String?
    /// 商品状态
    var exchangeStatu:Int?
    /// 图片路径
    var goodsPic:String?
    /// 时间
    var addTime:String?
    /// 兑换数量
    var exchangeCount:Int?
    init?(map: Map) {

    }
    mutating func mapping(map: Map) {
        goodsName <- map["goodsName"]
        exchangeStatu <- map["exchangeStatu"]
        goodsPic <- map["goodsPic"]
        addTime <- map["addTime"]
        exchangeCount <- map["exchangeCount"]
    }
}
