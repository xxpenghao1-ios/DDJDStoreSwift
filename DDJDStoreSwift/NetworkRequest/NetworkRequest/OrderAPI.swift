//
//  OrderAPI.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/7/5.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import Moya
///订单
public enum OrderAPI{
    //查询店铺订单状态 3已完成 2已发货 1未发货
    case queryOrderInfo4AndroidStoreByOrderStatus(orderStatus:Int,storeId:String,pageSize:Int,currentPage:Int)
    //查询订单详情
    case queryOrderInfo4AndroidByorderId(orderinfoId:Int)
}
extension OrderAPI:TargetType{
    public var path: String {
        switch self {
        case .queryOrderInfo4AndroidStoreByOrderStatus(_,_,_,_):
            return "queryOrderInfo4AndroidStoreByOrderStatus.xhtml"
        case .queryOrderInfo4AndroidByorderId(_):
            return "queryOrderInfo4AndroidByorderId.xhtml"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .queryOrderInfo4AndroidStoreByOrderStatus(_,_,_,_),.queryOrderInfo4AndroidByorderId(_):
            return .get
        }
    }

    public var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }

    public var task: Task {
        switch self {
        case let .queryOrderInfo4AndroidStoreByOrderStatus(orderStatus,storeId, pageSize, currentPage):
            return .requestParameters(parameters:["orderStatus":orderStatus,"storeId":storeId,"pageSize":pageSize,"currentPage":currentPage], encoding: URLEncoding.default)
        case let .queryOrderInfo4AndroidByorderId(orderinfoId):
            return .requestParameters(parameters:["orderinfoId":orderinfoId], encoding: URLEncoding.default)
        }
    }
    
}
