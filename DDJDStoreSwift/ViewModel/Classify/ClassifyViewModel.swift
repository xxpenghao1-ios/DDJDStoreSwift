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
class ClassifyViewModel:NSObject,OutputRefreshProtocol{
    
    ///商品分类id
    var goodsCategoryId:Int?

    ///发送网络请求(true)从首页点进来加载1级分类下面对应的2级分类 false加载全部2级分类
    var requestNewDataCommond=PublishSubject<Bool>()

    ///从首页1级分类进入*************
    ///商品1级分类对应23级分类集合
    var goodsCategory23ArrBR = BehaviorRelay<Dictionary<String,[GoodsCategoryModel]>>(value:[:])

    ///商品1级分类对应2级分类集合
    var goodsCategory2ArrBR = BehaviorRelay<[SectionModel<String,String>]>(value:[])

    ///3级分类集合
    var goodsCategory3ArrBR = BehaviorRelay<[EmptyDataType: [SectionModel<String,GoodsCategoryModel>]]>(value:[.loading:[]])
    ///****************************

    ///从底部点击分类进入************
    ///所有2级分类集合
    var goodsCategoryAll2ArrBR = BehaviorRelay<[SectionModel<String,GoodsCategoryModel>]>(value:[])

    ///底部所有的3级分类
    var goodsCategoryAll3ArrBR=BehaviorRelay<[SectionModel<String,GoodsCategoryModel>]>(value:[])

    ///****************************

    ///选中的行索引 默认0
    var index=0

    ///刷新状态
    var refreshStatus = BehaviorRelay<PHRefreshStatus>(value:.none)
    
     override init() {
        super.init()
        requestNewDataCommond.asObservable().subscribe(onNext: { [weak self] (b) in
            if b{
                self?.index=0
                self?.getTwoCategoryForMob()
            }else{
                self?.index=0
                self?.getCategory4AndroidAll()
            }
        }).disposed(by:rx_disposeBag)
    }
}
extension ClassifyViewModel{
    ///获取1级分类下面23级分类
    private func getTwoCategoryForMob(){
        PHRequest.shared.requestJSONObject(target:ClassifyAPI.queryTwoCategoryForMob(goodsCategoryId:goodsCategoryId ?? 0,substationId:substation_Id!))
            .subscribe(onNext: { [weak self] (result) in
            switch result{
             case let .success(json:json):
                self?.parsingJSON(json:json)
                break
            default:
                self?.goodsCategory3ArrBR.accept([.dataError:[SectionModel.init(model:"",items:[])]])
                break
            }
            self?.refreshStatus.accept(.endHeaderRefresh)
        }, onError: { [weak self] (error) in
            self?.refreshStatus.accept(.endHeaderRefresh)
            self?.goodsCategory3ArrBR.accept([.dataError:[SectionModel.init(model:"",items:[])]])
            phLog("1分类获取全部23级分类出错\(error.localizedDescription)")
        }).disposed(by: rx_disposeBag)
    }
    ///从底部点击分类获取全部23级分类
    private func getCategory4AndroidAll(){
        PHRequest.shared.requestJSONObject(target:ClassifyAPI.queryTwoCategory4AndroidAll_v5()).subscribe(onNext: { [weak self] (result) in
            switch result{
            case let .success(json:json):
                ///获取所有的2级分类
                var allTwo=Mapper<GoodsCategoryModel>().mapArray(JSONObject: json["allTwo"].object) ?? []
                var allModel=GoodsCategoryModel()
                allModel.goodsCategoryName="全部"
                ///插入一个全部选项
                allTwo.insert(allModel, at:0)
                self?.goodsCategoryAll2ArrBR.accept([SectionModel.init(model:"",items:allTwo)])
                ///获取所有的3级分类
                let allThree=Mapper<GoodsCategoryModel>().mapArray(JSONObject: json["allThree"].object) ?? []
                self?.goodsCategoryAll3ArrBR.accept([SectionModel.init(model:"",items:allThree)])

                ///默认展示显示全部3级分类
                self?.goodsCategory3ArrBR.accept([.noData:[SectionModel.init(model:"",items:allThree)]])
                break
            default:
                self?.goodsCategory3ArrBR.accept([.dataError:[SectionModel.init(model:"",items:[])]])
                break
            }
            self?.refreshStatus.accept(.endHeaderRefresh)
        }, onError: { [weak self] (error) in
            self?.refreshStatus.accept(.endHeaderRefresh)
            self?.goodsCategory3ArrBR.accept([.dataError:[SectionModel.init(model:"",items:[])]])
            phLog("底部点击分类获取全部23级分类出错\(error.localizedDescription)")
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
        self.goodsCategory3ArrBR.accept([.noData:[SectionModel.init(model:"",items:items)]])
    }
}
