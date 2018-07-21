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
    //取消订单
    case storeCancelOrder(orderId:Int)
    //确认收货
    case updataOrderStatus4Store(orderinfoId:Int)
    //下单
    case storeOrderForAndroid(goodsList:String,detailAddress:String,phoneNumber:String,shippName:String,storeId:String,pay_message:String,tag:Int,cashCouponId:Int?)
    ///每种订单的数量
    case queryOrderStatusSumByMemberId(memberId:String)
}
extension OrderAPI:TargetType{
    public var path: String {
        switch self {
        case .queryOrderInfo4AndroidStoreByOrderStatus(_,_,_,_):
            return "queryOrderInfo4AndroidStoreByOrderStatus.xhtml"
        case .queryOrderInfo4AndroidByorderId(_):
            return "queryOrderInfo4AndroidByorderId.xhtml"
        case .storeCancelOrder(_):
            return "storeCancelOrder.xhtml"
        case .updataOrderStatus4Store(_):
            return "updataOrderStatus4Store.xhtml"
        case .storeOrderForAndroid(_,_,_,_,_,_,_,_):
            return "storeOrderForAndroid.xhtml"
        case .queryOrderStatusSumByMemberId(_):
            return "queryOrderStatusSumByMemberId"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .queryOrderInfo4AndroidStoreByOrderStatus(_,_,_,_),.queryOrderInfo4AndroidByorderId(_),.storeCancelOrder(_),.updataOrderStatus4Store(_),.queryOrderStatusSumByMemberId(_):
            return .get
        case .storeOrderForAndroid(_,_,_,_,_,_,_,_):
            return .post
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
        case let .storeCancelOrder(orderId):
            return .requestParameters(parameters:["orderId":orderId], encoding: URLEncoding.default)
        case let .updataOrderStatus4Store(orderinfoId):
            return .requestParameters(parameters:["orderinfoId":orderinfoId], encoding: URLEncoding.default)
        case let .storeOrderForAndroid(goodsList, detailAddress, phoneNumber, shippName, storeId, pay_message, tag,cashCouponId):
            if cashCouponId == nil{
                return .requestParameters(parameters:["goodsList":goodsList,"detailAddress":detailAddress,"phoneNumber":phoneNumber,"shippName":shippName,"storeId":storeId,"pay_message":pay_message,"tag":tag], encoding:  URLEncoding.default)
            }else{
                return .requestParameters(parameters:["goodsList":goodsList,"detailAddress":detailAddress,"phoneNumber":phoneNumber,"shippName":shippName,"storeId":storeId,"pay_message":pay_message,"tag":tag,"cashCouponId":cashCouponId!], encoding:  URLEncoding.default)
            }
        case let .queryOrderStatusSumByMemberId(memberId):
            return .requestParameters(parameters:["memberId":memberId], encoding: URLEncoding.default)
        }
    }
    
}
