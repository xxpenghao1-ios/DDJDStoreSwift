//
//  OrderCountModel.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/7/21.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import ObjectMapper
///订单数量model
struct OrderCountModel:Mappable {
    ///1-未发，2已发货，3-已经完成
    var orderStatus:Int?
    ///订单数量
    var orderSum:Int?
    init?(map: Map) {

    }
    mutating func mapping(map: Map) {
        orderStatus <- map["orderStatus"]
        orderSum <- map["orderSum"]
    }
}
