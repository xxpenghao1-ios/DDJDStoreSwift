//
//  SpecialAndPromotionsModel.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/6/23.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import ObjectMapper
///特价与促销图片
struct SpecialAndPromotionsModel:Mappable {
    ///标识是特价还是促销(3特价2,促销)
    var mobileOrPc:Int?
    //图片路径
    var advertisingURL:String?
    init?(map: Map) {
    }
    mutating func mapping(map: Map) {
        mobileOrPc <- map["mobileOrPc"]
        advertisingURL <- map["advertisingURL"]
    }
}
