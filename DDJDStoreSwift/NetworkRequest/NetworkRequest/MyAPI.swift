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
}
extension MyAPI:TargetType{
    public var path: String {
        switch self {
        case .queryMessageToStore(_,_,_):
            return "queryMessageToStore.xhtml"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .queryMessageToStore(_,_,_):
            return .get
        }
    }

    public var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }

    public var task: Task {
        switch self {
        case let .queryMessageToStore(id,pageSize,currentPage):
            return .requestParameters(parameters:["substationId":id,"pageSize":pageSize,"currentPage":currentPage], encoding: URLEncoding.default)
        }
    }


}
