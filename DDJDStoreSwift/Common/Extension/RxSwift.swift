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
import RxDataSources
extension Response {
    // 这一个主要是将JSON解析为单个的Model
    public func mapObjectModel<T:Mappable>(_ type: T.Type) throws -> T {
        guard let object = Mapper<T>().map(JSONObject: try mapJSON()) else {
            throw MoyaError.jsonMapping(self)
        }
        return object
    }

    // 这个主要是将JSON解析成多个Model并返回一个数组
    public func mapArray<T:Mappable>(_ type: T.Type) throws -> [T] {
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

extension ObservableType where E == Response{
    //返回一个Observable<ResponseResult>
    public func mapObject<T:Mappable>(_ type: T.Type) -> Observable<T> {
        return flatMap { response -> Observable<T> in
            print(try response.mapObjectModel(type.self))
            return Observable<T>.just(try response.mapObjectModel(type.self))
        }
    }

}
//extension ObservableType where E == Mappable{
//    //返回一个Observable<ResponseResult>
//    public func mapObject<T:Mappable>(_ type: T.Type) -> [SectionModel<String,M>] {
//        return flatMap { response -> Observable<T> in
//            print(try response.mapObjectModel(type.self))
//            return Observable<T>.just(try response.mapObjectModel(type.self))
//        }
//    }
//
//}
//extension PrimitiveSequence where TraitType == SingleTrait, ElementType == Response {
//    public func mapArrModel<T:Mappable>(_ type: T.Type) -> Observable<[T]>{
//        flatMap{ response -> Observable<[T]> in
////            return Observable<[T]>.just(response)
//            return Observable<[T]>.just(response)
////            return Observable.just()
//        }
//    }
//}


