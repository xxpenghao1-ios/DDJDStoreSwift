//
//  AppDelegateAPI.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/7/26.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import Moya

public enum AppDelegateAPI{
    ///判断用户是否已经被别人登录
    case memberDeviceVerification(memberId:String)
    ///app下线
    case subSubStationMember(subStationId:String,storeId:String)
    ///上线
    case addSubStationMember(subStationId:String,storeId:String)
}
extension AppDelegateAPI:TargetType{
    //请求URL
    public var baseURL:URL{
        switch self {
        case .subSubStationMember,.addSubStationMember:
            return Foundation.URL(string:"http://tj.hnddjd.com/")!
        default:return Foundation.URL(string:HTTP_URL)!
        }
    }
    public var path: String {
        switch self{
        case .memberDeviceVerification:
            return "MemberDeviceVerification.xhtml"
        case .subSubStationMember:
            return "tj/member/subSubStationMember"
        case .addSubStationMember:
            return "tj/member/addSubStationMember"
        }
    }
    public var method: Moya.Method {
        switch self {
        case .memberDeviceVerification,.subSubStationMember,.addSubStationMember:
            return .get
        }
    }
    //  单元测试用
    public var sampleData: Data{
        return "{}".data(using: String.Encoding.utf8)!
    }
    public var task: Task {
        switch self {
        case let .memberDeviceVerification(memberId):
            return .requestParameters(parameters:["memberId":memberId],encoding:URLEncoding.default)
        case let .subSubStationMember(subStationId, storeId):
            return .requestParameters(parameters:["subStationId":subStationId,"storeId":storeId],encoding:URLEncoding.default)
        case let .addSubStationMember(subStationId, storeId):
            return .requestParameters(parameters:["subStationId":subStationId,"storeId":storeId],encoding:URLEncoding.default)
        }
    }
}
