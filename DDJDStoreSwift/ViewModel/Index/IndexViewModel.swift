//
//  IndexViewModel.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/6/12.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxDataSources
///首页VM
class IndexViewModel:NSObject{

    ///幻灯片model数据
    var advertisingArrModelBR = BehaviorRelay<[AdvertisingModel]> (value:[])

    ///幻灯片路径数组
    var imgUrlArrBR=BehaviorRelay<[String]>(value:[])

    ///商品分类model数组
    var categorySectionBR=BehaviorRelay<[SectionModel<String,GoodsCategoryModel>]>(value:[])

    ///特价与促销图片数组
    var specialsAndPromotionsArrModelBR=BehaviorRelay<[SpecialAndPromotionsModel]>(value:[])

    ///热门商品数组
    var hotGoodArrModelBR=BehaviorRelay<[SectionModel<String,HotGoodModel>]>(value:[])

    ///发送网络请求(true)刷新数据 false加载下一页
    var requestNewDataCommond = PublishSubject<Bool>()

    override init() {
        super.init()
        requestNewDataCommond.subscribe { [unowned self] (event) in
            phLog(event)
            if event.element == true{//重新加载数据
                self.getMobileAdvertising()
                self.getOneCategory()
                self.getSpecialsAndPromotions()
                self.getHotGood(b:event.element)
            }else{///加载热门商品下一页

            }
        }.disposed(by:rx_disposeBag)
    }


}

///网络请求
extension IndexViewModel{
    ///获取幻灯片数据
    private func getMobileAdvertising(){
        ///发送网络请求获取
        PHRequest.shared.requestJSONArrModel(target:IndexAPI.mobileAdvertising(countyId:COUNTY_ID!),model:AdvertisingModel.self).subscribe(onNext: { [unowned self] (arrModel) in
            self.advertisingArrModelBR.accept(arrModel)
            },onError: { (error) in
                phLog("获取幻灯片数据出错:\(error.localizedDescription)")
        }).disposed(by:rx_disposeBag)
        ///把幻灯片model数据转换成路径数组
        advertisingArrModelBR.asObservable().map { (arrModel) -> [String] in
            return arrModel.map({ (model) -> String in
                return HTTP_URL_IMG+(model.advertisingURL ?? "")
            })
            }.subscribe(onNext: { [unowned self] (imgUrlArr) in
                self.imgUrlArrBR.accept(imgUrlArr)
            }).disposed(by:rx_disposeBag)
    }

    ///获取分类数据
    private func getOneCategory(){
        PHRequest.shared.requestJSONArrModel(target:IndexAPI.queryOneCategory(), model:GoodsCategoryModel.self).subscribe(onNext: { [unowned self] (arrModel) in
            self.categorySectionBR.accept([SectionModel.init(model:"", items:arrModel)])
            }, onError: { (error) in
                phLog("获取分类数据出错:\(error.localizedDescription)")
        }).disposed(by:rx_disposeBag)

    }
    ///获取特价促销图片
    private func getSpecialsAndPromotions(){
        PHRequest.shared.requestJSONArrModel(target:IndexAPI.mobileAdvertisingPromotionAndPreferential(), model:SpecialAndPromotionsModel.self).subscribe(onNext: {
             [unowned self] (arrModel) in
            self.specialsAndPromotionsArrModelBR.accept(arrModel)
        }, onError: { (error) in
            phLog("获取特价与促销数据出错:\(error.localizedDescription)")
        }).disposed(by:rx_disposeBag)
    }
    ///获取热门商品  b是是否刷新数据 true是  false加载下一页数据
    private func getHotGood(b:Bool?){
        PHRequest.shared.requestJSONArrModel(target:IndexAPI.queryGoodsForAndroidIndexForStore(countyId:COUNTY_ID!, isDisplayFlag:2,storeId:STOREID!),model:HotGoodModel.self).subscribe(onNext: { [unowned self] (arrModel) in
            phLog(arrModel)
            self.hotGoodArrModelBR.accept([SectionModel.init(model:"", items:arrModel)])
            }, onError: { (error) in
                phLog("获取分类数据出错:\(error.localizedDescription)")
        }).disposed(by:rx_disposeBag)
    }

}
