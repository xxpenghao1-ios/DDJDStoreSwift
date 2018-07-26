//
//  IndexAPI.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/6/12.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import Moya
///首页网络请求
public enum IndexAPI{
    ///幻灯片请求
    case mobileAdvertising_v5(subStationId:String)
    ///获取促销/特价 图片
    case mobileAdvertisingPromotionAndPreferential()
    ///首页查询分类
    case queryOneCategory()
    ///热门商品请求
    case queryGoodsForAndroidIndexForStore(countyId:String,isDisplayFlag:Int,storeId:String,currentPage:Int,pageSize:Int)
    ///发送公告栏请求
    case queryAdMessgInfo(substationId:String)
    ///新品推荐
    case queryGoodsForAndroidIndexForStoreNew(countyId:String,storeId:String,isDisplayFlag:Int,currentPage:Int,pageSize:Int,order:String)
}
extension IndexAPI:TargetType{
    public var path: String {
        switch self{
        case .mobileAdvertising_v5(_):
            return "mobileAdvertising_v5.xhtml"
        case .mobileAdvertisingPromotionAndPreferential():
            return "mobileAdvertisingPromotionAndPreferential.xhtml"
        case .queryOneCategory():
            return "queryOneCategory.xhtml"
        case .queryGoodsForAndroidIndexForStore(_,_,_,_,_):
            return "queryGoodsForAndroidIndexForStore.xhtml"
        case .queryAdMessgInfo(_):
            return "queryAdMessgInfo.xhtml"
        case .queryGoodsForAndroidIndexForStoreNew(_,_,_,_,_,_):
            return "queryGoodsForAndroidIndexForStoreNew.xhtml"

        }
    }
    public var method: Moya.Method {
        switch self {
        case .mobileAdvertising_v5(_),.mobileAdvertisingPromotionAndPreferential(),.queryOneCategory(),.queryGoodsForAndroidIndexForStore(_,_,_,_,_),.queryAdMessgInfo(_),.queryGoodsForAndroidIndexForStoreNew(_,_,_,_,_,_):
            return .get
        }
    }
    //单元测试用
    public var sampleData: Data{
        return "{}".data(using: String.Encoding.utf8)!
    }
    public var task: Task {
        switch self {
        case let .mobileAdvertising_v5(subStationId):
            return .requestParameters(parameters:["subStationId":subStationId],encoding:URLEncoding.default)
        case .mobileAdvertisingPromotionAndPreferential():
            return .requestPlain
        case .queryOneCategory():
            return .requestParameters(parameters:["isDisplayFlag":2], encoding: URLEncoding.default)
        case let .queryGoodsForAndroidIndexForStore(countyId, isDisplayFlag, storeId,currentPage,pageSize):
            return .requestParameters(parameters:["countyId":countyId,"isDisplayFlag":isDisplayFlag,"storeId":storeId,"currentPage":currentPage,"pageSize":pageSize], encoding: URLEncoding.default)
        case let .queryAdMessgInfo(substationId):
            return .requestParameters(parameters:["substationId":substationId], encoding: URLEncoding.default)
        case let .queryGoodsForAndroidIndexForStoreNew(countyId, storeId, isDisplayFlag, currentPage, pageSize, order):
            return .requestParameters(parameters:["countyId":countyId,"storeId":storeId,"isDisplayFlag":isDisplayFlag,"currentPage":currentPage,"pageSize":pageSize,"order":order], encoding: URLEncoding.default)
        }
    }
}
