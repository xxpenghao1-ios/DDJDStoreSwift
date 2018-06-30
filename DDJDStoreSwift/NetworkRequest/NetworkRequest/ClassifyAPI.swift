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
    //查询所有的2,3级分类
    case queryTwoCategoryForMob(goodsCategoryId:Int,substationId:String)
}

extension ClassifyAPI:TargetType{
    public var path: String {
        switch self {
        case .queryTwoCategoryForMob(_,_):
            return "queryTwoCategoryForMob.xhtml"
        }

    }

    public var method: Moya.Method {
        switch self {
        case .queryTwoCategoryForMob(_,_):
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
        }
    }


}
