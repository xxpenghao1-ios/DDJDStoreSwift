//
//  CarAPI.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/7/9.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import Moya
///订单
public enum CarAPI{
    //加入购物车  flag1特价，2非特价，3促销
    case insertShoppingCar(memberId:String,goodId:Int,supplierId:Int,subSupplierId:Int,goodsCount:Int,flag:Int,goodsStock:Int,storeId:String,promotionNumber:Int?)
    ///查询购物车商品数量
    case memberShoppingCarCountForMobile(memberId:String)
}
extension CarAPI:TargetType{
    public var path: String {
        switch self {
        case .insertShoppingCar(_,_,_,_,_,_,_,_,_):
            return "insertShoppingCar.xhtml"
        case .memberShoppingCarCountForMobile(_):
            return "memberShoppingCarCountForMobile.xhtml"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .insertShoppingCar(_,_,_,_,_,_,_,_,_),.memberShoppingCarCountForMobile(_):
            return .get
        }
    }

    public var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }

    public var task: Task {
        switch self {
        case let .insertShoppingCar(memberId,goodId,supplierId,subSupplierId,goodsCount,flag, goodsStock,storeId,promotionNumber):
            if promotionNumber != nil{
                return .requestParameters(parameters:["memberId":memberId,"goodId":goodId,"supplierId":supplierId,"subSupplierId":subSupplierId,"goodsCount":goodsCount,"flag":flag,"goodsStock":goodsStock,"storeId":storeId,"promotionNumber":promotionNumber!], encoding:  URLEncoding.default)
            }else{
                return .requestParameters(parameters:["memberId":memberId,"goodId":goodId,"supplierId":supplierId,"subSupplierId":subSupplierId,"goodsCount":goodsCount,"flag":flag,"goodsStock":goodsStock,"storeId":storeId], encoding:  URLEncoding.default)
            }
        case let .memberShoppingCarCountForMobile(memberId):
            return .requestParameters(parameters:["memberId":memberId], encoding: URLEncoding.default)
        }

    }

}

