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
    case mobileAdvertising(countyId:String)
    ///获取促销/特价 图片
    case mobileAdvertisingPromotionAndPreferential()
    ///首页查询分类
    case queryOneCategory()
    ///热门商品请求
    case queryGoodsForAndroidIndexForStore(countyId:String,isDisplayFlag:Int,storeId:String)
    ///发送公告栏请求
    case queryAdMessgInfo(substationId:String)
}
extension IndexAPI:TargetType{
    public var path: String {
        switch self{
        case .mobileAdvertising(_):
            return "mobileAdvertising.xhtml"
        case .mobileAdvertisingPromotionAndPreferential():
            return "mobileAdvertisingPromotionAndPreferential.xhtml"
        case .queryOneCategory():
            return "queryOneCategory.xhtml"
        case .queryGoodsForAndroidIndexForStore(_,_,_):
            return "queryGoodsForAndroidIndexForStore.xhtml"
        case .queryAdMessgInfo(_):
            return "queryAdMessgInfo.xhtml"

        }
    }
    public var method: Moya.Method {
        switch self {
        case .mobileAdvertising(_),.mobileAdvertisingPromotionAndPreferential(),.queryOneCategory(),.queryGoodsForAndroidIndexForStore(_,_,_),.queryAdMessgInfo(_):
            return .get
        }
    }
    //单元测试用
    public var sampleData: Data{
        return "{}".data(using: String.Encoding.utf8)!
    }
    public var task: Task {
        switch self {
        case let .mobileAdvertising(countyId):
            return .requestParameters(parameters:["countyId":countyId],encoding:URLEncoding.default)
        case .mobileAdvertisingPromotionAndPreferential():
            return .requestPlain
        case .queryOneCategory():
            return .requestParameters(parameters:["isDisplayFlag":2], encoding: URLEncoding.default)
        case let .queryGoodsForAndroidIndexForStore(countyId, isDisplayFlag, storeId):
            return .requestParameters(parameters:["countyId":countyId,"isDisplayFlag":isDisplayFlag,"storeId":storeId], encoding: URLEncoding.default)
        case let .queryAdMessgInfo(substationId):
            return .requestParameters(parameters:["substationId":substationId], encoding: URLEncoding.default)
        }
    }
}
