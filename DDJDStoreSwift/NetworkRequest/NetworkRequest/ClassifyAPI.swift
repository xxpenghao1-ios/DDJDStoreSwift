//
//  ClassifyAPI.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/6/30.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import Moya
///分类API
public enum ClassifyAPI{
    ///查询1级分类所有的2,3级分类
    case queryTwoCategoryForMob(goodsCategoryId:Int,substationId:String)
    ///查询所有2级分类
    case queryCategory4AndroidAll()
    ///查询2级分类下面3级分类
    case queryCategory4Android(goodsCategoryId:Int)
    ///查询所有2级分类以及全部的三级分类
    case queryTwoCategory4AndroidAll_v5()
    ///分站所有的品牌
    case queryAllBrandBySubstationId_v5(substationId:String)
    ///搜索时显示的推荐品牌
    case queryAllSystemBrand()
}

extension ClassifyAPI:TargetType{
    public var path: String {
        switch self {
        case .queryTwoCategoryForMob(_,_):
            return "queryTwoCategoryForMob.xhtml"
        case .queryCategory4AndroidAll():
            return "queryCategory4AndroidAll.xhtml"
        case .queryCategory4Android(_):
            return "queryCategory4Android.xhtml"
        case .queryTwoCategory4AndroidAll_v5():
            return "queryTwoCategory4AndroidAll_v5.xhtml"
        case .queryAllBrandBySubstationId_v5(_):
            return "queryAllBrandBySubstationId_v5.xhtml"
        case .queryAllSystemBrand():
            return "queryAllSystemBrand"
        }

    }

    public var method: Moya.Method {
        switch self {
        case .queryTwoCategoryForMob(_,_),.queryCategory4AndroidAll(_),.queryCategory4Android(_),.queryTwoCategory4AndroidAll_v5(),.queryAllBrandBySubstationId_v5(_),.queryAllSystemBrand():
            return .get
        }
    }

    //单元测试用
    public var sampleData: Data{
        return "{}".data(using: String.Encoding.utf8)!
    }

    public var task: Task {
        switch self {
        case let .queryTwoCategoryForMob(goodsCategoryId, substationId):
            return .requestParameters(parameters:["goodsCategoryId":goodsCategoryId,"substationId":substationId], encoding: URLEncoding.default)
        case .queryCategory4AndroidAll():
            return .requestPlain
        case let .queryCategory4Android(goodsCategoryId):
            return .requestParameters(parameters:["goodsCategoryId":goodsCategoryId], encoding: URLEncoding.default)
        case .queryTwoCategory4AndroidAll_v5():
            return .requestPlain
        case let .queryAllBrandBySubstationId_v5(substationId):
            return .requestParameters(parameters:["substationId":substationId], encoding: URLEncoding.default)
        case .queryAllSystemBrand():
            return .requestPlain
        }
    }


}
