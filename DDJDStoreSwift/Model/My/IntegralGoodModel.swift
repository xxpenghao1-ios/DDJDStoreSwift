//
//  IntegralGoodModel.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/7/23.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import ObjectMapper
///积分商品model
class IntegralGoodModel:Mappable{
    //商城商品主键ID
    var integralMallId:Int?;
    ///所属分站Id
    var subStationId:Int?;
    ///商品名称
    var goodsName:String?;
    ///商品描述
    var goodsDescribe:String?;
    ///商品图片
    var goodsPic:String?;
    ///添加时间
    var addTime:String?;
    ///兑换所需积分
    var exchangeIntegral:Int?;
    ///剩余的商品数量
    var goodsSurplusCount:Int?=0;
    ///商品状态； 1可以兑换，2已下架
    var goodsStatu:Int?;
    /// 供应商名称
    var subSupplierName:String?
    
    required init?(map: Map) {

    }

    func mapping(map: Map) {
        integralMallId <- map["integralMallId"]
        subStationId <- map["subStationId"]
        goodsName <- map["goodsName"]
        goodsDescribe <- map["goodsDescribe"]
        goodsPic <- map["goodsPic"]
        addTime <- map["addTime"]
        exchangeIntegral <- map["exchangeIntegral"]
        goodsSurplusCount <- map["goodsSurplusCount"]
        goodsStatu <- map["goodsStatu"]
        subSupplierName <- map["subSupplierName"]
    }
}
