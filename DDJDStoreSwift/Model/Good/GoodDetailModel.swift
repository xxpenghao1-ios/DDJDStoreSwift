//
//  GoodDetailModel.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/7/9.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import ObjectMapper
///商品详情
class GoodDetailModel:Mappable{
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
    ///商品原价
    var oldPrice:String?
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
    /// 销量
    var salesCount:Int?
    /// 特价价格
    var preferentialPrice:String?
    /// 配送商名称
    var supplierName:String?
    /// 条码
    var goodInfoCode:String?
    /// 保质期
    var goodLife:String?
    /// 是否是促销商品 1是
    var isPromotionFlag:Int?
    /// 促销期号
    var promotionNumber:Int?
    ///默认为null；如果=1，此商品被用户收藏
    var goodsCollectionStatu:Int?
    ///商品限购数
    var eachCount:Int?
    init(){}
    required init?(map: Map) {

    }
    func mapping(map: Map) {
        supplierId <- map["supplierId"]
        goodsbasicinfoId <- map["goodsbasicinfoId"]
        goodInfoName <- map["goodInfoName"]
        remark <- map["remark"]
        ctime <- map["ctime"]
        subSupplier <- map["subSupplier"]
        goodPic <- map["goodPic"]
        ucode <- map["ucode"]
        uprice <- map["uprice"]
        oldPrice <- map["oldPrice"]
        isDistribution <- map["isDistribution"]
        miniCount <- map["miniCount"]
        goodsBaseCount <- map["goodsBaseCount"]
        goodsStock <- map["goodsStock"]
        goodUnit <- map["goodUnit"]
        uitemPrice <- map["uitemPrice"]
        salesCount <- map["salesCount"]
        preferentialPrice <- map["preferentialPrice"]
        supplierName <- map["supplierName"]
        goodInfoCode <- map["goodInfoCode"]
        goodLife <- map["goodLife"]
        isPromotionFlag <- map["isPromotionFlag"]
        promotionNumber <- map["promotionNumber"]
        goodsCollectionStatu <- map["goodsCollectionStatu"]
        eachCount <- map["eachCount"]
    }
}
