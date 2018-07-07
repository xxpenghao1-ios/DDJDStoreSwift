//
//  NewGoodModel.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/6/29.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import ObjectMapper
///新品推荐商品
class NewGoodModel:Mappable {
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
    /// 最低起送量
    var miniCount:Int?
    /// 加减基数，就是在购物车添加商品的时候每次添加都会按这个goodsBaseCount得数量添加
    var goodsBaseCount:Int?
    /// 商品库存  -1 库存充足
    var goodsStock:Int?
    /// 单位
    var goodUnit:String?
    /// 建议零售价
    var uitemPrice:String?
    required init?(map: Map) {

    }
    func mapping(map: Map) {
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
        miniCount <- map["miniCount"]
        goodsBaseCount <- map["goodsBaseCount"]
        goodsStock <- map["goodsStock"]
        goodUnit <- map["goodUnit"]
        uitemPrice <- map["uitemPrice"]
    }

}
