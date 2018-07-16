//
//  BrandViewModel.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/7/14.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxDataSources
import SwiftyJSON
import ObjectMapper
///品牌vm
class BrandViewModel:NSObject,OutputRefreshProtocol{

    ///发送网络请求(1)从首页点进来加载1级分类下面对应的全部品牌 2加载全部品牌
    var requestNewDataCommond=PublishSubject<Int>()

    ///保存品牌信息
    var goodsBrandArrBR = BehaviorRelay<[EmptyDataType:[SectionModel<String,GoodsCategoryModel>]]>(value:[.loading:[]])

    ///刷新状态
    var refreshStatus = BehaviorRelay<PHRefreshStatus>(value:.none)
    
    init(goodsCategoryId:Int?) {
        super.init()
        requestNewDataCommond.subscribe(onNext: { [weak self] (i) in
            if i == 1{
                self?.getTwoCategoryForMob(goodsCategoryId:goodsCategoryId)
            }else{
                self?.getAllBrand()
            }
        }).disposed(by:rx_disposeBag)
    }
}
extension BrandViewModel{
    ///获取1级分类下面所有品牌
    private func getTwoCategoryForMob(goodsCategoryId:Int?){
        PHRequest.shared.requestJSONObject(target:ClassifyAPI.queryTwoCategoryForMob(goodsCategoryId:goodsCategoryId ?? 0,substationId:substation_Id!))
            .subscribe(onNext: { [weak self] (result) in
                switch result{
                case let .success(json:json):
                    let arr=Mapper<GoodsCategoryModel>().mapArray(JSONObject:json["全部"]["brand"].object)
                    self?.goodsBrandArrBR.accept([.noData:[SectionModel.init(model:"",items:arr ?? [])]])
                    break
                default:
                    ///获取数据出错 空页面提示
                    self?.goodsBrandArrBR.accept([.dataError:[SectionModel.init(model:"",items:[])]])
                    break
                }
                self?.refreshStatus.accept(.endHeaderRefresh)
            }, onError: { [weak self] (error) in
                self?.refreshStatus.accept(.endHeaderRefresh)
                ///获取数据出错 空页面提示
                self?.goodsBrandArrBR.accept([.dataError:[SectionModel.init(model:"",items:[])]])
                phLog("获取全部1级分类品牌出错\(error.localizedDescription)")
            }).disposed(by: rx_disposeBag)
    }
    ///查询所有的品牌
    private func getAllBrand(){
        PHRequest.shared.requestJSONArrModel(target:ClassifyAPI.queryAllBrandBySubstationId_v5(substationId:substation_Id!), model: GoodsCategoryModel.self).subscribe(onNext: { [weak self] (arr) in
            self?.goodsBrandArrBR.accept([.noData:[SectionModel.init(model:"",items:arr)]])
            self?.refreshStatus.accept(.endHeaderRefresh)
        }, onError: { [weak self] (error) in
            self?.refreshStatus.accept(.endHeaderRefresh)
            ///获取数据出错 空页面提示
            self?.goodsBrandArrBR.accept([.dataError:[SectionModel.init(model:"",items:[])]])
            phLog("获取全部品牌出错\(error.localizedDescription)")
        }).disposed(by:rx_disposeBag)
    }
}
