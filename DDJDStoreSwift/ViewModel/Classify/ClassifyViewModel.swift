//
//  ClassifyViewModel.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/6/30.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxDataSources
import SwiftyJSON
import ObjectMapper
///分类VM
class ClassifyViewModel:NSObject{
    ///商品分类id
    var goodsCategoryId:Int?

    ///发送网络请求(true)从首页点进来加载1级分类下面对应的2级分类 false加载全部2级分类
    var requestNewDataCommond=PublishSubject<Bool>()

    ///商品23级分类集合
    var goodsCategory23ArrBR = BehaviorRelay<Dictionary<String,[GoodsCategoryModel]>>(value:[:])

    ///商品2级分类
    var goodsCategory2ArrBR = BehaviorRelay<[SectionModel<String,String>]>(value:[])

    ///商品3级分类
    var goodsCategory3ArrBR = BehaviorRelay<[SectionModel<String,GoodsCategoryModel>]>(value:[])

    ///分站id
    let substationId=USER_DEFAULTS.object(forKey:"substationId") as? String
     override init() {
        super.init()

        requestNewDataCommond.subscribe { [weak self] (event) in
            if event.element == true{
                self?.getTwoCategoryForMob()
            }else{
                
            }
        }.disposed(by: rx_disposeBag)

    }
}
extension ClassifyViewModel{
    ///获取23级分类
    private func getTwoCategoryForMob(){
        PHRequest.shared.requestJSONObject(target:ClassifyAPI.queryTwoCategoryForMob(goodsCategoryId:goodsCategoryId ?? 0,substationId:substationId ?? "")).subscribe(onNext: { [weak self] (result) in
            switch result{
             case let .success(json:json):
                self?.parsingJSON(json:json)
                break
            case let .faild(message:error):
                phLog("获取23级分类出错\(error ?? "")")
                break
            }
        }).disposed(by: rx_disposeBag)
    }
    ///解析json
    private func parsingJSON(json:JSON){
        ///所有的23级分类
        var dic=Dictionary<String,[GoodsCategoryModel]>()
        ///2级分类名称
        var keyArr=[String]()
        keyArr.append("全部")
        for(key,value) in json{
            if key != "全部"{
                keyArr.append(key)
            }
            dic[key]=Mapper<GoodsCategoryModel>().mapArray(JSONObject:value["goodsCategory"].object)

        }
        ///所有的23级分类
        self.goodsCategory23ArrBR.accept(dic)
        ///2级分类
        self.goodsCategory2ArrBR.accept([SectionModel.init(model:"",items:keyArr)])
        ///获取全部的3级分类默认展示
        let items=self.goodsCategory23ArrBR.value["全部"] ?? []
        self.goodsCategory3ArrBR.accept([SectionModel.init(model:"",items:items)])
    }
}
