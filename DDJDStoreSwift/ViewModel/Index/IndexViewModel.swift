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
class IndexViewModel:NSObject,OutputRefreshProtocol{

    ///幻灯片model数据
    var advertisingArrModelBR = BehaviorRelay<[AdvertisingModel]> (value:[])

    ///幻灯片路径数组
    var imgUrlArrBR=BehaviorRelay<[String]>(value:[])

    ///公告栏信息
    var adMessgInfoBR=BehaviorRelay<AdMessgInfoModel?>(value:nil)

    ///商品分类model数组
    var categorySectionBR=BehaviorRelay<[SectionModel<String,GoodsCategoryModel>]>(value:[])

    ///特价与促销图片数组
    var specialsAndPromotionsArrModelBR=BehaviorRelay<[SpecialAndPromotionsModel]>(value:[])

    ///新品推荐数组  每组3个 最后一组数量不确定
    var newGoodArrModelBR=BehaviorRelay<[SectionModel<String,NewGoodModel>]>(value:[])

    ///热门商品数组
    var hotGoodArrModelBR=BehaviorRelay<[SectionModel<String,GoodDetailModel>]>(value:[])

    ///刷新状态
    var refreshStatus = BehaviorRelay<PHRefreshStatus>(value:.none)

    ///发送网络请求(true)刷新数据 false加载下一页
    var requestNewDataCommond = PublishSubject<Bool>()

    ///默认加载第一页
    private var currentPage=1

    ///每页加载10条
    private var pageSize=10

    ///热门商品数组
    private var hotGoodArr=[GoodDetailModel]()

    override init() {
        super.init()
        ///初始化就加载公告栏信息
        getAdMessgInfo()
        requestNewDataCommond
            .startWith(true)//默认刷新数据加载
            .subscribe { [weak self] (event) in
            if event.element == true{//重新加载数据
                self?.currentPage=1
                self?.getMobileAdvertising()
                self?.getOneCategory()
                self?.getNewGood()
                self?.getSpecialsAndPromotions()
                self?.getHotGood(b:event.element)
            }else{///加载热门商品下一页
                self?.currentPage+=1
                self?.getHotGood(b:event.element)
            }
        }.disposed(by:rx_disposeBag)
    }


}
///网络请求
extension IndexViewModel{
    ///获取幻灯片数据
    private func getMobileAdvertising(){
        ///发送网络请求获取
        PHRequest.shared.requestJSONArrModel(target:IndexAPI.mobileAdvertising(countyId:county_Id!),model:AdvertisingModel.self).retry(1).subscribe(onNext: { [weak self] (arrModel) in
            self?.advertisingArrModelBR.accept(arrModel)
            },onError: { (error) in
                phLog("获取幻灯片数据出错:\(error.localizedDescription)")
        }).disposed(by:rx_disposeBag)
        ///把幻灯片model数据转换成路径数组
        advertisingArrModelBR.asObservable().map { (arrModel) -> [String] in
            return arrModel.map({ (model) -> String in
                return HTTP_URL_IMG+(model.advertisingURL ?? "")
            })
            }.subscribe(onNext: { [weak self] (imgUrlArr) in
                self?.imgUrlArrBR.accept(imgUrlArr)
            }).disposed(by:rx_disposeBag)
    }
    ///获取分类数据
    private func getOneCategory(){
        PHRequest.shared.requestJSONArrModel(target:IndexAPI.queryOneCategory(), model:GoodsCategoryModel.self).retry(1).subscribe(onNext: { [weak self] (arrModel) in
            self?.categorySectionBR.accept([SectionModel.init(model:"", items:arrModel)])
            }, onError: { (error) in
                phLog("获取分类数据出错:\(error.localizedDescription)")
        }).disposed(by:rx_disposeBag)

    }
    ///获取特价促销图片
    private func getSpecialsAndPromotions(){
        PHRequest.shared.requestJSONArrModel(target:IndexAPI.mobileAdvertisingPromotionAndPreferential(), model:SpecialAndPromotionsModel.self).retry(1).subscribe(onNext: {
             [weak self] (arrModel) in

            self?.specialsAndPromotionsArrModelBR.accept(arrModel)
        }, onError: { (error) in
            phLog("获取特价与促销数据出错:\(error.localizedDescription)")
        }).disposed(by:rx_disposeBag)
    }
    ///获取新品推荐
    private func getNewGood(){
        weak var weakSelf=self
        if weakSelf == nil{
            return
        }
        PHRequest.shared.requestJSONArrModel(target:IndexAPI.queryGoodsForAndroidIndexForStoreNew(countyId:county_Id!, storeId:store_Id!, isDisplayFlag:2,currentPage:1,pageSize:30, order:""), model:NewGoodModel.self).retry(1)
            .subscribe(onNext: { (arrModel) in
                var valueArr=[NewGoodModel]()
                let _=arrModel.map({ (model) in //循环打印
                    valueArr.append(model)
                    //每次加3个 加满重新赋值  最后1组不确定 满足旋转木马效果
                    if valueArr.count == 3{
                        weakSelf!.newGoodArrModelBR.accept(weakSelf!.newGoodArrModelBR.value+[SectionModel.init(model:"",items:valueArr)])
                        valueArr.removeAll()
                    }
                })
            }, onError: { (error) in
                phLog("获取新品推荐出错:\(error.localizedDescription)")
        }).disposed(by:rx_disposeBag)
    }
    ///获取热门商品  b是是否刷新数据 true是  false加载下一页数据
    private func getHotGood(b:Bool?){
        weak var weakSelf=self
        if weakSelf == nil{
            return
        }
        ///发送网络请求
        PHRequest.shared.requestJSONArrModel(target:IndexAPI.queryGoodsForAndroidIndexForStore(countyId:county_Id!, isDisplayFlag:2,storeId:store_Id!,currentPage:currentPage,pageSize:pageSize),model:GoodDetailModel.self).retry(1).subscribe(onNext: { (arrModel) in

            if b == true{///刷新
                ///每次获取最新的数据
                weakSelf!.hotGoodArr=arrModel
                weakSelf!.hotGoodArrModelBR.accept([SectionModel.init(model:"",items:weakSelf!.hotGoodArr)])

            }else{//加载更多
                ///追加数据
                weakSelf!.hotGoodArr+=arrModel
            weakSelf!.hotGoodArrModelBR.accept([SectionModel.init(model:"",items:weakSelf!.hotGoodArr)])
            }
            weakSelf!.refreshStatus.accept(.endHeaderRefresh)
            weakSelf!.refreshStatus.accept(.endFooterRefresh)
            if arrModel.count < weakSelf!.pageSize{//如果下面没有数据了
                weakSelf!.refreshStatus.accept(.noMoreData)
            }
            }, onError: { (error) in
                ///把页索引-1
                if weakSelf!.currentPage > 1{
                    weakSelf!.currentPage-=1
                }
                phLog("获取分类数据出错:\(error.localizedDescription)")
                weakSelf!.refreshStatus.accept(.endHeaderRefresh)
                weakSelf!.refreshStatus.accept(.endFooterRefresh)
        }).disposed(by:rx_disposeBag)
    }
    ///获取公告栏信息
    private func getAdMessgInfo(){
        PHRequest.shared.requestJSONModel(target:IndexAPI.queryAdMessgInfo(substationId:substation_Id!),model:AdMessgInfoModel.self).retry(1).subscribe(onNext: { [weak self] (model) in
            
            self?.adMessgInfoBR.accept(model)
        }, onError: { (error) in
            phLog("获取公告栏数据出错:\(error.localizedDescription)")
        }).disposed(by: rx_disposeBag)
    }
}
