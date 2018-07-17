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
    var lowestMoney:String?
    var supplierName:String?
    var listGoods:[GoodDetailModel]?
    
    required init?(map: Map) {

    }

    func mapping(map: Map) {
        supplierId <- map["supplierId"]
        lowestMoney <- map["lowestMoney"]
        supplierName <- map["supplierName"]
        listGoods <- map["listGoods"]
    }


}
