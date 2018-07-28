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
    ///商品id
    var goodsbasicinfoId:Int?
    ///促销商品id
    var collectionGoodId:Int?
    var goodsId:Int? //也是商品id
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
    /// 特价库存
    var stock:Int?
    /// 商品数量
    var goodsCount:Int?
    /// 单位
    var goodUnit:String?
    /// 建议零售价
    var uitemPrice:String?
    /// 销量
    var salesCount:Int?
    /// 特价价格
    var preferentialPrice:String?
    /// 特价id
    var preferentialId:Int?
    /// 商品详情特价
    var prefertialPrice:String?
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
    /// 促销商品库存
    var promotionEachCount:Int?
    /// 促销店铺限购数
    var promotionStoreEachCount:Int?
    /// 促销信息
    var goodsDes:String?
    /// 促销结束时间
    var promotionEndTime:String?
    ///默认为null；如果=1，此商品被用户收藏
    var goodsCollectionStatu:Int?
    ///特价商品限购数
    var eachCount:Int?
    ///特价结束时间
    var endTime:String?
    ///商品是否可退；1可退；2不可退
    var returnGoodsFlag:Int?
    ///商品的状态 ；  1特价，2普通,3促销
    var flag:Int?
    ///购物车是否选中 1选中 2未选中 默认选中
    var isSelected:Int=1
    ///购物车商品数量
    var carNumber:Int?
    ///购物车商品总价
    var goodsSumMoney:String?
    ///收藏供应商id
    var collectionSupplierId:Int?
    ///收藏配送商id
    var collectionSubSupplierId:Int?
    ///配送商品价格
    var subSupplierUprice:String?
    init(){}
    required init?(map: Map) {

    }
    func mapping(map: Map) {
        supplierId <- map["supplierId"]
        goodsbasicinfoId <- map["goodsbasicinfoId"]
        collectionGoodId <- map["collectionGoodId"]
        goodsId <- map["goodsId"]
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
        stock <- map["stock"]
        goodsCount <- map["goodsCount"]
        goodUnit <- map["goodUnit"]
        uitemPrice <- map["uitemPrice"]
        salesCount <- map["salesCount"]
        preferentialPrice <- map["preferentialPrice"]
        preferentialId <- map["preferentialId"]
        prefertialPrice <- map["prefertialPrice"]
        supplierName <- map["supplierName"]
        goodInfoCode <- map["goodInfoCode"]
        goodLife <- map["goodLife"]
        isPromotionFlag <- map["isPromotionFlag"]
        promotionNumber <- map["promotionNumber"]
        promotionEachCount <- map["promotionEachCount"]
        promotionStoreEachCount <- map["promotionStoreEachCount"]
        goodsDes <- map["goodsDes"]
        promotionEndTime <- map["promotionEndTime"]
        goodsCollectionStatu <- map["goodsCollectionStatu"]
        eachCount <- map["eachCount"]
        endTime <- map["endTime"]
        returnGoodsFlag <- map["returnGoodsFlag"]
        flag <- map["flag"]
        carNumber <- map["carNumber"]
        goodsSumMoney <- map["goodsSumMoney"]
        collectionSupplierId <- map["collectionSupplierId"]
        collectionSubSupplierId <- map["collectionSubSupplierId"]
        subSupplierUprice <- map["subSupplierUprice"]
    }
}
