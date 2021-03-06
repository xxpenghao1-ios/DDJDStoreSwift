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
    ///供应商id
    var supplierId:Int?
    ///商品id
    var goodsbasicinfoId:Int?
    ///商品名称
    var goodInfoName:String?
    ///配送商id
    var subSupplier:Int?
    ///商品图片路径
    var goodPic:String?
    ///规格
    var ucode:String?
    ///商品价格
    var uprice:String?
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
        supplierId <- map["supplierId"]
        goodsbasicinfoId <- map["goodsbasicinfoId"]
        goodInfoName <- map["goodInfoName"]
        subSupplier <- map["subSupplier"]
        goodPic <- map["goodPic"]
        ucode <- map["ucode"]
        uprice <- map["uprice"]
        miniCount <- map["miniCount"]
        goodsBaseCount <- map["goodsBaseCount"]
        goodsStock <- map["goodsStock"]
        goodUnit <- map["goodUnit"]
        uitemPrice <- map["uitemPrice"]
    }

}
