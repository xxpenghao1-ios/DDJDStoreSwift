//
//  StoreModel.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/4/28.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import ObjectMapper
///店铺信息
struct StoreModel:Mappable{
    /// 市
    var city:String?
    /// 店铺id
    var storeId:String?
    /// 区
    var county:String?
    /// 区县id
    var countyId:String?
    /// 会员id
    var memberId:String?
    /// 省
    var province:String?
    /// 店铺唯一标识码
    var storeFlagCode:String?
    /// 店铺名称
    var storeName:String?
    /// 分站id
    var substationId:String?
    /// 店铺电话号码
    var subStationPhoneNumber:String?
    /// 店铺二维码图片路径
    var qrcode:String?
    
    init?(map: Map) {

    }
    mutating func mapping(map: Map) {
        memberId <- map["memberId"]
        storeId <- map["storeId"]
        storeName <- map["storeName"]
        province <- map["province"]
        city <- map["city"]
        countyId <- map["countyId"]
        county <- map["county"]
        storeFlagCode <- map["storeFlagCode"]
        substationId <- map["substationId"]
        subStationPhoneNumber <- map["subStationPhoneNumber"]
        qrcode <- map["qrcode"]
    }
}
