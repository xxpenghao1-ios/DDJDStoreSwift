//
//  AdMessgInfoModel.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/6/30.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import ObjectMapper
///公告栏model
struct AdMessgInfoModel:Mappable {
    /// 消息标题
    var messTitle:String?
    /// 消息内容
    var messContent:String?
    init() {}
    init?(map: Map) {

    }
    mutating func mapping(map: Map) {
        messTitle <- map["messTitle"]
        messContent <- map["messContent"]
    }
}
