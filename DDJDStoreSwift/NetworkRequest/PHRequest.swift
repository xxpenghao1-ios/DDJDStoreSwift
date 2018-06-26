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
import RxCocoa

typealias SuccessClosure = (JSON) -> Void

typealias SuccessArrClosure = ([Mappable]?) -> Void

typealias FailClosure = (String?) -> Void

/// 网络请求
final public class PHRequest:NSObject{
    /// 共享实例
    static let shared=PHRequest()
    private override init(){}
    private let failInfo="数据解析错误!"
    ///获取json数据
    func requestJSONObject<T:TargetType>(target:T) -> Observable<ResponseResult>{
        let provider=MoyaProvider<T>(requestClosure:requestTimeoutClosure(target:target),plugins:[RequestLoadingPlugin()])
        return Observable<ResponseResult>.create { (observable) -> Disposable in
            provider.request(target){ (result) -> () in
                switch result{
                case let .success(response):
                    do {
                        let json = try response.mapJSON()
                        observable.onNext(ResponseResult.success(json:JSON(json)))
                    } catch {
                        observable.onNext(ResponseResult.faild(message:self.failInfo))
                    }
                case let .failure(error):
                    observable.onNext(ResponseResult.faild(message:error.localizedDescription))
                }
            }
            return Disposables.create()
        }
    }
    ///获取ModelArr数据
    func requestJSONArrModel<T:TargetType,M:Mappable>(target:T,model:M.Type) ->Observable<[M]>{
        let provider=MoyaProvider<T>(requestClosure:requestTimeoutClosure(target:target),plugins:[RequestLoadingPlugin()])
        return Observable<[M]>.create { (observable) -> Disposable in
            provider.request(target){ (result) -> () in
                switch result{
                case let .success(response):
                    do {
                        print(JSON(try response.mapJSON()))
                        observable.onNext(try response.mapArray(M.self))
                    } catch {
                        observable.onError(MoyaError.jsonMapping(response))
                    }
                case let .failure(error):
                    observable.onError(MoyaError.requestMapping(error.localizedDescription))
                }
            }
            return Disposables.create()
        }
    }
    ///获取Model数据
    func requestJSONModel<T:TargetType,M:Mappable>(target:T,model:M.Type) ->Observable<M>{
        let provider=MoyaProvider<T>(requestClosure:requestTimeoutClosure(target:target),plugins:[RequestLoadingPlugin()])
        return Observable<M>.create { (observable) -> Disposable in
            provider.request(target){ (result) -> () in
                switch result{
                case let .success(response):
                    do {
                        observable.onNext(try response.mapObjectModel(M.self))
                    } catch {
                        observable.onError(MoyaError.jsonMapping(response))
                    }
                case let .failure(error):
                    observable.onError(MoyaError.requestMapping(error.localizedDescription))
                }
            }
            return Disposables.create()
        }
    }


////    /// 请求JSON数据  数据结果自行处理  返回被观察对象
////    func requestJSONData(target:LoginAndRegisterAPI,hudInfo:HUDInfo?=nil) -> Observable<ResponseResult> {
////
////
////    }
//    ///请求JSON数据 成功返回数组
//    func requestJSONModelArr<T:TargetType,M:Mappable>(target:T,model:M,hudInfo:HUDInfo?=nil, successClosure:@escaping SuccessArrClosure,failClosure:@escaping FailClosure){
//        let requestProvider = MoyaProvider<T>(requestClosure:requestTimeoutClosure(target: target),plugins:[RequestLoadingPlugin(hudInfo:hudInfo)])
//        requestProvider.rx.request(target).mapJSON().subscribe(onSuccess: { (any) in
//            let modelArr=Mapper<M>().mapArray(JSONObject:any)
//            successClosure(modelArr)
//        }, onError: { (error) in
//            failClosure(error.localizedDescription)
//        }).disposed(by:rx_disposeBag)
//    }
//    ///请求String数据
//        func requestStringData<T:TargetType>(target:T,hudInfo:HUDInfo?=nil,successClosure:@escaping (_ str:String) -> Void,failClosure: @escaping FailClosure) {
//        let requestProvider = MoyaProvider<T>(requestClosure:requestTimeoutClosure(target: target),plugins:[RequestLoadingPlugin(hudInfo:hudInfo)])
//        requestProvider.rx.request(target).mapString().subscribe(onSuccess: { (str) in
//            successClosure(str)
//        }, onError: { (error) in
//            failClosure(error.localizedDescription)
//        }).disposed(by:rx_disposeBag)
//    }

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
        return Foundation.URL(string:HTTP_URL)!
    }
    //请求类型
    public var headers: [String : String]? {
        return nil
    }
}
///返回结果
public enum ResponseResult {
    ///成功保存json数据
    case success(json:JSON)
    ///保存错误信息 基本用不到  RequestLoadingPlugin插件会把错误提示出来
    case faild(message:String?)
    var json:JSON? {
        switch self {
        case let .success(json):
            return json
        case .faild:
            return nil
        }
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
fileprivate final class RequestLoadingPlugin:PluginType{
    ///不做处理
    public func willSend(_ request: RequestType, target: TargetType) {

    }
    public func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        switch result {
        case let .failure(error):
            PHProgressHUD.showError(error.localizedDescription)
        default:self.dismissHUD()
        }
    }
    //MARK:-隐藏请求加载框
    private  func dismissHUD(){
        PHProgressHUD.dismissHUD()
    }
}
