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
    ///验证账号是否存在
    case doMemberTheOnly(memberName:String)
    ///修改密码
    case updatePassWord(memberName:String,newPassWord:String)
    ///获取验证码 flag=updatePassword 修改密码
    case returnRandCode(memberName:String,flag:String)
}
extension LoginAndRegisterAPI:TargetType{
    public var path: String {
        switch self{
        case .login(_,_,_,_,_):
            return "storeLoginInterface.xhtml"
        case .updatePassWord:
            return "updatePassWord.xhtml"
        case .doMemberTheOnly:
            return "doMemberTheOnly.xhtml"
        case .returnRandCode:
            return "returnRandCode.xhtml"
        }
    }
    public var method: Moya.Method {
        switch self {
        case .login:
            return .post
        case .doMemberTheOnly,.returnRandCode,.updatePassWord:
            return .get
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
        case let .updatePassWord(memberName, newPassWord):
            return .requestParameters(parameters:["memberName":memberName,"newPassWord":newPassWord],encoding:URLEncoding.default)
        case let .doMemberTheOnly(memberName):
            return .requestParameters(parameters:["memberName":memberName],encoding:URLEncoding.default)
        case let .returnRandCode(memberName, flag):
            return .requestParameters(parameters:["memberName":memberName,"flag":flag],encoding:URLEncoding.default)
        }
    }
}
