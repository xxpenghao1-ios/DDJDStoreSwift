//
//  MyAPI.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/7/4.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import Moya
///个人中心
public enum MyAPI{
    ///查询我的消息
    case queryMessageToStore(substationId:String,pageSize:Int,currentPage:Int)
    ///查询代金券是否可以使用
    case querySubStationCC(substationId:String)
   //请求分站信息和推荐人
    case queryStoreMember(storeId:String,memberId:String)
    ///查询店铺收货地址
    case queryStoreShippAddressforAndroid(storeId:String)
    //删除收货地址
    case deleteStoreShippAddressforAndroid(shippAddressId:Int)
    //修改收货地址
    case updateStoreShippAddressforAndroid(flag:Int,storeId:String,county:String,city:String,province:String,shippName:String,detailAddress:String,phoneNumber:String,shippAddressId:Int)
    //添加收货地址
    case addStoreShippAddressforAndroid(flag:Int,storeId:String,county:String,city:String,province:String,shippName:String,detailAddress:String,phoneNumber:String)
    //问题反馈
    case complaintsAndSuggestions(complaint:String,storeId:String)
    ///积分兑换
    case integralMallExchange(integralMallId:Int,memberId:String,exchangeCount:Int)
    ///查看剩余积分
    case queryMemberIntegral(memberId:String)
    ///积分商品请求
    case queryIntegralMallForSubStation(subStationId:String,currentPage:Int,pageSize:Int)
    ///积分记录
    case storeQueryMemberIntegralV1(memberId:String,currentPage:Int,pageSize:Int)
    ///兑换记录
    case queryIntegralMallExchangeRecord(memberId:String,pageSize:Int,currentPage:Int)
    ///购买历史
    case queryStorePurchaseRecord(memberId:String,pageSize:Int,currentPage:Int)
    ///代金券
    case queryStoreCashCoupon(storeId:String,pageSize:Int,currentPage:Int)
    ///店铺的服务人员信息
    case storeServicePersonal(storeId:String)
    
}
extension MyAPI:TargetType{
    //请求URL
    public var baseURL:URL{
        switch self {
        case .querySubStationCC(_),.queryStoreCashCoupon(_,_,_):
            return Foundation.URL(string:HTTP_URL.components(separatedBy:"/front/")[0])!
        default:return Foundation.URL(string:HTTP_URL)!
            
        }
    }
    public var path: String {
        switch self {
        case .queryMessageToStore(_,_,_):
            return "queryMessageToStore.xhtml"
        case .querySubStationCC(_):
            return "/cc/querySubStationCC"
        case .queryStoreMember(_,_):
            return "queryStoreMember.xhtml"
        case .queryStoreShippAddressforAndroid(_):
            return "queryStoreShippAddressforAndroid.xhtml"
        case .deleteStoreShippAddressforAndroid(_):
            return "deleteStoreShippAddressforAndroid.xhtml"
        case .updateStoreShippAddressforAndroid(_,_,_,_,_,_,_,_,_):
            return "updateStoreShippAddressforAndroid.xhtml"
        case .addStoreShippAddressforAndroid(_,_,_,_,_,_,_,_):
            return "addStoreShippAddressforAndroid.xhtml"
        case .complaintsAndSuggestions(_,_):
            return "complaintsAndSuggestions.xhtml"
        case .integralMallExchange(_,_,_):
            return "integralMallExchange.xhtml"
        case .queryMemberIntegral(_):
            return "queryMemberIntegral.xhtml"
        case .queryIntegralMallForSubStation(_,_,_):
            return "queryIntegralMallForSubStation.xhtml"
        case .storeQueryMemberIntegralV1(_,_,_):
            return "storeQueryMemberIntegralV1.xhtml"
        case .queryIntegralMallExchangeRecord(_,_,_):
            return "queryIntegralMallExchangeRecord.xhtml"
        case .queryStorePurchaseRecord(_,_,_):
            return "queryStorePurchaseRecord.sc"
        case .queryStoreCashCoupon(_,_,_):
            return "cc/queryStoreCashCoupon"
        case .storeServicePersonal(_):
            return "storeServicePersonal"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .queryMessageToStore(_,_,_),.querySubStationCC(_),.queryStoreMember(_,_),.queryStoreShippAddressforAndroid(_),.deleteStoreShippAddressforAndroid(_),.integralMallExchange(_,_,_),.queryMemberIntegral(_),.queryIntegralMallForSubStation(_,_,_),.storeQueryMemberIntegralV1(_,_,_),.queryIntegralMallExchangeRecord(_,_,_),.queryStorePurchaseRecord(_,_,_),.queryStoreCashCoupon(_,_,_),.storeServicePersonal(_):
            return .get
        case .updateStoreShippAddressforAndroid(_,_,_,_,_,_,_,_,_),.addStoreShippAddressforAndroid(_,_,_,_,_,_,_,_),.complaintsAndSuggestions(_,_):
            return .post
        }
    }

    public var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }

    public var task: Task {
        switch self {
        case let .queryMessageToStore(id,pageSize,currentPage):
            return .requestParameters(parameters:["substationId":id,"pageSize":pageSize,"currentPage":currentPage], encoding: URLEncoding.default)
        case let .querySubStationCC(substationId):
            return .requestParameters(parameters:["substationId":substationId], encoding: URLEncoding.default)
        case let .queryStoreMember(storeId, memberId):
            return .requestParameters(parameters:["storeId":storeId,"memberId":memberId], encoding: URLEncoding.default)
        case let .queryStoreShippAddressforAndroid(storeId):
            return .requestParameters(parameters:["storeId":storeId], encoding: URLEncoding.default)
        case let .deleteStoreShippAddressforAndroid(shippAddressId):
            return .requestParameters(parameters:["shippAddressId":shippAddressId], encoding:  URLEncoding.default)
        case let .updateStoreShippAddressforAndroid(flag, storeId, county, city, province, shippName, detailAddress, phoneNumber,shippAddressId):
            return .requestParameters(parameters:["flag":flag,"storeId":storeId,"county":county,"city":city,"province":province,"shippName":shippName,"detailAddress":detailAddress,"phoneNumber":phoneNumber,"shippAddressId":shippAddressId], encoding:  URLEncoding.default)
        case let .addStoreShippAddressforAndroid(flag, storeId, county, city, province, shippName, detailAddress, phoneNumber):
            return .requestParameters(parameters:["flag":flag,"storeId":storeId,"county":county,"city":city,"province":province,"shippName":shippName,"detailAddress":detailAddress,"phoneNumber":phoneNumber], encoding:  URLEncoding.default)
        case let .complaintsAndSuggestions(complaint, storeId):
            return .requestParameters(parameters:["complaint":complaint,"storeId":storeId], encoding: URLEncoding.default)
        case let .integralMallExchange(integralMallId, memberId, exchangeCount):
            return .requestParameters(parameters:["integralMallId":integralMallId,"memberId":memberId,"exchangeCount":exchangeCount], encoding:  URLEncoding.default)
        case let .queryMemberIntegral(memberId):
            return .requestParameters(parameters:["memberId":memberId], encoding:  URLEncoding.default)
        case let .queryIntegralMallForSubStation(subStationId, currentPage, pageSize):
            return .requestParameters(parameters:["subStationId":subStationId,"currentPage":currentPage,"pageSize":pageSize], encoding:  URLEncoding.default)
        case let .storeQueryMemberIntegralV1(memberId, currentPage, pageSize):
            return .requestParameters(parameters:["memberId":memberId,"currentPage":currentPage,"pageSize":pageSize], encoding:  URLEncoding.default)
        case let .queryIntegralMallExchangeRecord(memberId, pageSize, currentPage):
            return .requestParameters(parameters:["memberId":memberId,"pageSize":pageSize,"currentPage":currentPage], encoding:  URLEncoding.default)
        case let .queryStorePurchaseRecord(memberId, pageSize, currentPage):
            return .requestParameters(parameters:["memberId":memberId,"pageSize":pageSize,"currentPage":currentPage], encoding:  URLEncoding.default)
        case let .queryStoreCashCoupon(storeId, pageSize, currentPage):
            return .requestParameters(parameters:["storeId":storeId,"pageSize":pageSize,"currentPage":currentPage], encoding: URLEncoding.default)
        case let .storeServicePersonal(storeId):
            return .requestParameters(parameters:["storeId":storeId], encoding: URLEncoding.default)
        }
    }


}
