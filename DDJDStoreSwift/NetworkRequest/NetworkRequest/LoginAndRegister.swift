//
//  LoginAndRegister.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/4/28.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import Moya
///登录注册接口
public enum LoginAndRegisterAPI{
    ///登录接口
    case login(memberName:String,password:String,deviceToken:String,deviceName:String,flag:Int)
}
extension LoginAndRegisterAPI:TargetType{
    public var path: String {
        switch self{
        case .login(_,_,_,_,_):
            return "storeLoginInterface.xhtml"
        }
    }
    public var method: Moya.Method {
        switch self {
        case .login(_,_,_,_,_):
            return .post
        }
    }
    //  单元测试用
    public var sampleData: Data{
        return "{}".data(using: String.Encoding.utf8)!
    }
    public var task: Task {
        switch self {
        case let .login(memberName, password, deviceToken, deviceName, flag):
            return .requestParameters(parameters:["memberName":memberName,"password":password,"deviceToken":deviceToken,"deviceName":deviceName,"flag":flag],encoding:URLEncoding.default)
        }
    }
}
