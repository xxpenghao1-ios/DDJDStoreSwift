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
}
extension MyAPI:TargetType{
    //请求URL
    public var baseURL:URL{
        switch self {
        case .querySubStationCC(_):
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
        }
    }

    public var method: Moya.Method {
        switch self {
        case .queryMessageToStore(_,_,_),.querySubStationCC(_),.queryStoreMember(_,_),.queryStoreShippAddressforAndroid(_),.deleteStoreShippAddressforAndroid(_):
            return .get
        case .updateStoreShippAddressforAndroid(_,_,_,_,_,_,_,_,_),.addStoreShippAddressforAndroid(_,_,_,_,_,_,_,_):
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
        }
    }


}
