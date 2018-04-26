//
//  PHRequest.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/4/26.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import Moya
import Result
import ObjectMapper
import SwiftyJSON
///成功返回
typealias SuccessClosure = (_ result:PHRequestResult) -> Void



/// 失败
typealias FailClosure = (_ errorMsg: String?) -> Void
/// 网络请求
public class PHRequest:NSObject{
    static let sharedInstance = PHRequest()
    private override init(){}
    private let failInfo="数据解析失败"
    /// 请求JSON数据
    func requestDataWithTargetJSON<T:TargetType>(target:T,successClosure:@escaping SuccessClosure,failClosure: @escaping FailClosure) {
        let requestProvider = MoyaProvider<T>(requestClosure:requestTimeoutClosure(target: target))
        let _=requestProvider.request(target) { (result) -> () in
            switch result{
            case let .success(response):
                do {
                    let mapjson = try response.mapJSON()
                    successClosure(PHRequestResult(json: mapjson))
                } catch {
                    failClosure(self.failInfo)
                }
            case let .failure(error):
                failClosure(error.errorDescription)
            }
        }
    }
    ///请求String数据
    func requestDataWithTargetString<T:TargetType>(target:T,successClosure:@escaping SuccessClosure,failClosure: @escaping FailClosure) {
        let requestProvider = MoyaProvider<T>(requestClosure:requestTimeoutClosure(target: target))
        let _=requestProvider.request(target) { (result) -> () in
            switch result{
            case let .success(response):
                do {
                    let str = try response.mapString()
                    successClosure(PHRequestResult(str:str))
                } catch {
                    failClosure(self.failInfo)
                }
            case let .failure(error):
                failClosure(error.errorDescription)
            }

        }
    }

    //设置请求超时时间
    private func requestTimeoutClosure<T:TargetType>(target:T) -> MoyaProvider<T>.RequestClosure{
        let requestTimeoutClosure = { (endpoint:Endpoint<T>, done: @escaping MoyaProvider<T>.RequestResultClosure) in
            do{
                var request = try endpoint.urlRequest()
                request.timeoutInterval = 30 //设置请求超时时间
                done(.success(request))
            }catch{
                return
            }
        }
        return requestTimeoutClosure
    }
}
///设置网请求url
extension TargetType{
    //请求URL
    public var baseURL:URL{
        return Foundation.URL(string:URL)!
    }
}
///网络请求返回结果
public struct PHRequestResult{
    ///保存返回json
    private var json:Any?
    ///保存返回字符串
    private var str:String?
    init(json:Any?=nil,str:String?=nil){
        self.json=json
        self.str=str
    }
    ///返回对应的entity
    public func toEntity<M:Mappable>() -> M?{
        return Mapper<M>().map(JSONObject:json)
    }
    ///返回对应的类型的数组
    public func toArrEntity<M:Mappable>() -> [M]?{
        return Mapper<M>().mapArray(JSONObject:json)
    }
    ///返回json
    public func toJSON() -> JSON{
        return JSON(json ?? "")
    }
    ///返回字符串
    public func toString() -> String?{
        return str
    }

}
