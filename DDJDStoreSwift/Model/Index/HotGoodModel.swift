//
//  HotGoodModel.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/6/23.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import ObjectMapper
///首页热门商品
struct HotGoodModel:Mappable {
    var carNumber:Int?
    ///供应商id
    var supplierId:Int?
    ///商品名称
    var goodsbasicinfoId:Int?
    ///商品名称
    var goodInfoName:String?
    ///描述
    var remark:String?
    ///时间
    var ctime:String?
    ///配送商id
    var subSupplier:Int?
    ///商品图片路径
    var goodPic:String?
    ///规格
    var ucode:String?
    ///商品价格
    var uprice:String?
    /// 该商品是否被重新分配给了分销商或物流配送商1-未分配  2-分配了
    var isDistribution:Int?
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        carNumber <- map["carNumber"]
        supplierId <- map["supplierId"]
        goodsbasicinfoId <- map["goodsbasicinfoId"]
        goodInfoName <- map["goodInfoName"]
        remark <- map["remark"]
        ctime <- map["ctime"]
        subSupplier <- map["subSupplier"]
        goodPic <- map["goodPic"]
        ucode <- map["ucode"]
        uprice <- map["uprice"]
        isDistribution <- map["isDistribution"]
    }

}
