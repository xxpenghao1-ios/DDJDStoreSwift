//
//  OrderGoodModel.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/7/5.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import ObjectMapper
///订单商品model
struct OrderGoodModel:Mappable{
    ///商品名称
    var goodInfoName:String?
    ///商品图片
    var goodPic:String?
    ///商品数量
    var goodsSumCount:Int?
    ///商品价格
    var goodsUprice:Double?
    ///商品是否可以退换
    var returnGoodsFlag:Int?
    init?(map: Map) {

    }
    mutating func mapping(map:Map){
        goodInfoName <- map["goodInfoName"]
        goodPic <- map["goodPic"]
        goodsSumCount <- map["goodsSumCount"]
        goodsUprice <- map["goodsUprice"]
        returnGoodsFlag <- map["returnGoodsFlag"]
    }
}
