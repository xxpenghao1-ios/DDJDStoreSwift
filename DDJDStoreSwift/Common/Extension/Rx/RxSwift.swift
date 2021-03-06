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
        do{
            let json=JSON(try self.mapJSON())
            phLog(json)
            guard let object = Mapper<T>().map(JSONObject:json.object) else {
                throw MoyaError.jsonMapping(self)
            }
            return object
        }catch{
            throw MoyaError.jsonMapping(self)
        }
    }

    // 这个主要是将JSON解析成多个Model并返回一个数组
    public func mapObjectArray<T:Mappable>(_ type: T.Type) throws -> [T] {
        do{
            let json=JSON(try self.mapJSON())
            phLog(json)
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
    //返回一个对象
    public func mapObjectModel<T:Mappable>(_ type: T.Type) -> Observable<T> {
        return flatMap { response -> Observable<T> in
            return Observable<T>.just(try response.mapObjectModel(type))
        }
    }
    //返回一个集合对象
    public func mapObjectArray<T:Mappable>(_ type: T.Type) -> Observable<[T]> {
        return flatMap { response -> Observable<[T]> in
            return Observable<[T]>.just(try response.mapObjectArray(type))
        }
    }

}

//extension PrimitiveSequenceType where TraitType == SingleTrait,ElementType == Response {
//    //返回一个集合对象
//    public func mapObjectModel<T:Mappable>(_ type: T.Type) -> Observable<T>{
//        return flatMap { response -> Single<T> in
//            return Single<T>.just(try response.mapObjectModel(type))
//            }.asObservable()
//    }
//
//    //返回一个集合对象
//    public func mapObjectArray<T:Mappable>(_ type: T.Type) -> Observable<[T]>{
//        return flatMap { response -> Single<[T]> in
//            return Single<[T]>.just(try response.mapObjectArray(type))
//        }
//    }
//}

