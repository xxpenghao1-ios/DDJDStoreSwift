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
import RxSwift

typealias SuccessClosure = (JSON) -> Void

typealias SuccessArrClosure = ([Mappable]?) -> Void

typealias FailClosure = (String?) -> Void

/// 网络请求
public class PHRequest:NSObject{
    static let shared = PHRequest()
    private override init(){}
    private let failInfo="数据解析失败请重试"
    private var disposeBag = DisposeBag()
    /// 请求JSON数据  数据结果自行处理
    func requestJSONData<T:TargetType>(target:T,hudInfo:HUDInfo?=nil,successClosure:@escaping SuccessClosure,failClosure:@escaping FailClosure) {
        let requestProvider = MoyaProvider<T>(requestClosure:requestTimeoutClosure(target: target),plugins:[RequestLoadingPlugin(hudInfo:hudInfo)])
        requestProvider.rx.request(target).mapJSON().subscribe(onSuccess: { (any) in
            successClosure(JSON(any))
        }, onError: { (error) in
            failClosure(error.localizedDescription)
        }).disposed(by:disposeBag)
    }
    ///请求JSON数据 成功返回数组
    func requestJSONModelArr<T:TargetType,M:Mappable>(target:T,model:M,hudInfo:HUDInfo?=nil, successClosure:@escaping SuccessArrClosure,failClosure:@escaping FailClosure){
        let requestProvider = MoyaProvider<T>(requestClosure:requestTimeoutClosure(target: target),plugins:[RequestLoadingPlugin(hudInfo:hudInfo)])
        requestProvider.rx.request(target).mapJSON().subscribe(onSuccess: { (any) in
            let modelArr=Mapper<M>().mapArray(JSONObject:any)
            successClosure(modelArr)
        }, onError: { (error) in
            failClosure(error.localizedDescription)
        }).disposed(by:disposeBag)
    }
    ///请求String数据
        func requestStringData<T:TargetType>(target:T,hudInfo:HUDInfo?=nil,successClosure:@escaping (_ str:String) -> Void,failClosure: @escaping FailClosure) {
        let requestProvider = MoyaProvider<T>(requestClosure:requestTimeoutClosure(target: target),plugins:[RequestLoadingPlugin(hudInfo:hudInfo)])
        requestProvider.rx.request(target).mapString().subscribe(onSuccess: { (str) in
            successClosure(str)
        }, onError: { (error) in
            failClosure(error.localizedDescription)
        }).disposed(by:disposeBag)
    }

    //设置请求超时时间
    private func requestTimeoutClosure<T:TargetType>(target:T) -> MoyaProvider<T>.RequestClosure{
        let requestTimeoutClosure = { (endpoint:Endpoint, closure: @escaping MoyaProvider<T>.RequestResultClosure) in
            do {
                var urlRequest = try endpoint.urlRequest()
                urlRequest.timeoutInterval = 30 //设置请求超时时间
                closure(.success(urlRequest))
            } catch MoyaError.requestMapping(let url) {
                closure(.failure(MoyaError.requestMapping(url)))
            } catch MoyaError.parameterEncoding(let error) {
                closure(.failure(MoyaError.parameterEncoding(error)))
            } catch {
                closure(.failure(MoyaError.underlying(error, nil)))
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
    //请求类型
    public var headers: [String : String]? {
        return nil
    }
}
///加载相关
struct HUDInfo{
    ///加载类型(loading(页面不能进行操作),progress(可以进行操作))
    var hudType:HUDType!
    ///是否显示加载视图
    var isShow:Bool!
    init(hudType:HUDType,isShow:Bool=true) {
        self.hudType=hudType
        self.isShow=isShow
    }
}
///插件
public final class RequestLoadingPlugin:PluginType{
    ///加载相关
    private var hudInfo:HUDInfo?
    ///是否显示加载框
    private var isShow:Bool!
    init(hudInfo:HUDInfo?) {
        self.hudInfo=hudInfo
        if self.hudInfo == nil{
            self.hudInfo=HUDInfo(hudType:HUDType.progress)
        }
    }
    public func willSend(_ request: RequestType, target: TargetType) {
        self.showHUD()
    }
    public func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        if(hudInfo!.isShow){//如果显示隐藏加载框
            self.dismissHUD();
        }
    }
    //MARK:-是否显示请求加载框
    private func showHUD(){
        if(hudInfo!.isShow){
            PHProgressHUD.showProgressHUD(type:hudInfo!.hudType,status:"正在加载")
        }
    }
    //MARK:-隐藏请求加载框
    private  func dismissHUD(){
        PHProgressHUD.dismissHUD()
    }
}
