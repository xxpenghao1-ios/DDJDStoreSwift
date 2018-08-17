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

/// 网络请求
final public class PHRequest:NSObject{
    /// 共享实例
    static let shared=PHRequest()
    private override init(){}
    ///获取json数据
    func requestJSONObject<T:TargetType>(target:T) -> Observable<ResponseResult>{
        let provider=MoyaProvider<T>(requestClosure:requestTimeoutClosure(target:target),plugins:[RequestLoadingPlugin()])
        return Observable<ResponseResult>.create { (observable) -> Disposable in
            let callBack=provider.request(target){ (result) -> () in
                switch result{
                case let .success(response):
                    do {
                        let json = try response.mapJSON()
                        phLog(JSON(json))
                        observable.onNext(ResponseResult.success(json:JSON(json)))
                    } catch {
                        observable.onNext(ResponseResult.faild(error:MoyaError.jsonMapping(response)))
                    }
                case let .failure(error):
                    observable.onNext(ResponseResult.faild(error:error))
                }
            }
            return Disposables.create{
                callBack.cancel()
            }
        }
    }
    ///获取Arr数据
    func requestJSONArrModel<T:TargetType,M:Mappable>(target:T,model:M.Type) ->Observable<[M]>{
        let provider=MoyaProvider<T>(requestClosure:requestTimeoutClosure(target:target),plugins:[RequestLoadingPlugin()])

        return Observable<[M]>.create { (observable) -> Disposable in
            let callBack=provider.request(target){ (result) -> () in
                switch result{
                case let .success(response):
                    do {
                        observable.onNext(try response.mapObjectArray(model))
                    } catch {
                        observable.onError(MoyaError.jsonMapping(response))
                    }
                case let .failure(error):
                    observable.onError(error)
                }
            }
            return Disposables.create{
                callBack.cancel()
            }
        }
    }
    ///获取Model数据
    func requestJSONModel<T:TargetType,M:Mappable>(target:T,model:M.Type) ->Observable<M>{

        let provider=MoyaProvider<T>(requestClosure:requestTimeoutClosure(target:target),plugins:[RequestLoadingPlugin()])
        return Observable<M>.create { (observable) -> Disposable in
            let callBack=provider.request(target){ (result) -> () in
                switch result{
                case let .success(response):
                    do {
                        observable.onNext(try response.mapObjectModel(model))
                    } catch {
                        observable.onError(MoyaError.jsonMapping(response))
                    }
                case let .failure(error):

                    observable.onError(error)
                }
            }
            return Disposables.create{
                callBack.cancel()
            }
        }
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
    ///保存错误信息
    case faild(error:Error?)
    var json:JSON? {
        switch self {
        case let .success(json):
            return json
        case .faild:
            return nil
        }
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
            break
        default:
            self.dismissHUD()
            break
        }
    }
    //MARK:-隐藏请求加载框
    private  func dismissHUD(){
        PHProgressHUD.dismissHUD()
    }
}
