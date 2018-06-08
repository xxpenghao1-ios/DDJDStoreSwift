//
//  RxSwift.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/6/7.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import Moya
import ObjectMapper
import SwiftyJSON
import RxSwift
extension Response {
    // 这一个主要是将JSON解析为单个的Model
    public func mapObject<T:Mappable>(_ type: T.Type) throws -> T {
        guard let object = Mapper<T>().map(JSONObject: try mapJSON()) else {
            throw MoyaError.jsonMapping(self)
        }
        return object
    }

    // 这个主要是将JSON解析成多个Model并返回一个数组
    public func mapArray<T:BaseMappable>(_ type: T.Type) throws -> [T] {
        do{
            let json=JSON(try self.mapJSON())
            guard let objects = Mapper<T>().mapArray(JSONObject:json.object) else {
                    throw MoyaError.jsonMapping(self)
            }
            return objects
        }catch{
            throw MoyaError.jsonMapping(self)
        }

    }
}

extension ObservableType where E == Response {
    //返回一个Observable<ResponseResult>
    public func mapObject() -> Observable<ResponseResult> {
        return flatMap { response -> Observable<ResponseResult> in
            print(response)
            do{
                let json=try response.mapJSON()
                print(json)
                return Observable<ResponseResult>.just(.success(json:JSON(json)))
            }catch{
                return Observable<ResponseResult>.just(.faild(message:"数据解析错误"))
            }

        }
    }

}
extension PrimitiveSequence where TraitType == SingleTrait, ElementType == Response{
//    //返回一个Observable<ResponseResult>
//    public func mapObject() -> Observable<ResponseResult> {
//        return flatMap { response -> Observable<ResponseResult> in
//            print(response)
//            do{
//                let json=try response.mapJSON()
//                print(json)
//                return Observable<ResponseResult>.just(.success(json:JSON(json)))
//            }catch{
//                return Observable<ResponseResult>.just(.faild(message:"数据解析错误"))
//            }
//
//        }
//    }

}
extension JSON{
//    ///返回model
//    public static func mapModel<M:Mappable>(model:M) -> M{
//        return Mapper<M>().map(JSONObject:)
//    }
}
