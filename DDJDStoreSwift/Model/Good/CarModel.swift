//
//  CarModel.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/7/17.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import ObjectMapper
///购物车model
class CarModel:Mappable{

    var supplierId:Int?
    ///最低起送价
    var lowestMoney:String?
    var supplierName:String?
    var listGoods:[GoodDetailModel]?
    ///当前组是否选中 1选中 2未选中 默认选中
    var isSelected:Int=1
    ///每组商品价格统计 默认0
    var sumPrice:String?="0"
    required init?(map: Map) {

    }

    func mapping(map: Map) {
        supplierId <- map["supplierId"]
        lowestMoney <- map["lowestMoney"]
        supplierName <- map["supplierName"]
        listGoods <- map["listGoods"]
    }


}
