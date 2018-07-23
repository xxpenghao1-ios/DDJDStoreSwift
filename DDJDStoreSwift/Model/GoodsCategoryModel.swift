//
//  GoodsCategoryModel.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/6/13.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import ObjectMapper
///商品分类
struct GoodsCategoryModel:Mappable {
    ///商品分类ID
    var goodsCategoryId:Int?
    ///商品分类名称
    var goodsCategoryName:String?
    ///商品上级分类ID
    var goodsCategoryPid:Int?
    ///商品分类图标(原图)
    var goodsCategoryIco:String?
    ///分类描述
    var goodsCategoryIdRemark:String?
    ///分类类型  1跳转到 购物记录 2跳转到点单商城  其他跳转分类
    var categoryType:Int?
    /// 分站品牌名字
    var brandName:String?
    /// 分站品牌ID
    var brandId:String?
    /// 分站分类ID
    var goodscategoryId:Int?
    /// 分站ID
    var substationId:String?
    init(){}
    init?(map: Map) {
    }
    mutating func mapping(map: Map) {
        goodsCategoryId <- map["goodsCategoryId"]
        goodsCategoryName <- map["goodsCategoryName"]
        goodsCategoryPid <- map["goodsCategoryPid"]
        goodsCategoryIco <- map["goodsCategoryIco"]
        goodsCategoryIdRemark <- map["goodsCategoryIdRemark"]
        brandName <- map["brandname"]
        brandId <- map["brandId"]
        goodscategoryId <- map["goodscategoryId"]
        categoryType <- map["categoryType"]
        substationId <- map["substationId"]
    }
}
