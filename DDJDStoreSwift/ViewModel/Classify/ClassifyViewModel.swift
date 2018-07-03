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

    ///从首页1级分类进入*************
    ///商品1级分类对应23级分类集合
    var goodsCategory23ArrBR = BehaviorRelay<Dictionary<String,[GoodsCategoryModel]>>(value:[:])

    ///商品1级分类对应2级分类集合
    var goodsCategory2ArrBR = BehaviorRelay<[SectionModel<String,String>]>(value:[])

    ///商品1级分类对应-2级分类-3级分类
    var goodsCategory3ArrBR = BehaviorRelay<[SectionModel<String,GoodsCategoryModel>]>(value:[])
    ///****************************

    ///从底部点击分类进入************
    ///所有2级分类集合
    var goodsCategoryAll2ArrBR = BehaviorRelay<[SectionModel<String,GoodsCategoryModel>]>(value:[])

    ///查询3级分类
    var requestGoodsCategory3Commond=PublishSubject<Int>()
    ///****************************

     override init() {
        super.init()

        requestNewDataCommond.subscribe { [weak self] (event) in
            if event.element == true{
                self?.getTwoCategoryForMob()
            }else{
                self?.getCategory4AndroidAll()
            }
        }.disposed(by: rx_disposeBag)

        ///查询3级分类
        requestGoodsCategory3Commond.subscribe(onNext: { [weak self] (goodsCategoryId) in
            self?.getCategory3(goodsCategoryId:goodsCategoryId)
        }).disposed(by:rx_disposeBag)
    }
}
extension ClassifyViewModel{
    ///获取1级分类下面23级分类
    private func getTwoCategoryForMob(){
        PHRequest.shared.requestJSONObject(target:ClassifyAPI.queryTwoCategoryForMob(goodsCategoryId:goodsCategoryId ?? 0,substationId:substationId!))
            .subscribe(onNext: { [weak self] (result) in
            switch result{
             case let .success(json:json):
                self?.parsingJSON(json:json)
                break
            case let .faild(message:error):
                phLog("获取1级分类下面23级分类出错\(error ?? "")")
                break
            }
        }).disposed(by: rx_disposeBag)
    }
    ///从底部点击分类获取全部23级分类
    private func getCategory4AndroidAll(){
        PHRequest.shared.requestJSONArrModel(target:ClassifyAPI.queryCategory4AndroidAll(), model:GoodsCategoryModel.self).subscribe(onNext: { [weak self] (modelArr) in
            self?.goodsCategoryAll2ArrBR.accept([SectionModel.init(model:"", items: modelArr)])
        }, onError: { (error) in
            phLog("获取全部23级分类出错\(error.localizedDescription)")
        }).disposed(by:rx_disposeBag)
    }
    ///获取2级分类对应的3级分类
    private func getCategory3(goodsCategoryId:Int){
        PHRequest.shared.requestJSONArrModel(target:ClassifyAPI.queryCategory4Android(goodsCategoryId:goodsCategoryId), model:GoodsCategoryModel.self)
            .subscribe(onNext: { [weak self] (modelArr) in
            self?.goodsCategory3ArrBR.accept([SectionModel.init(model:"",items:modelArr)])
            }, onError: { (error) in
                phLog("获取全部3级分类出错\(error.localizedDescription)")
        }).disposed(by:rx_disposeBag)
    }
    ///解析从1级进入返回的json
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
