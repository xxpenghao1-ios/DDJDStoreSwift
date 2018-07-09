//
//  NewGoodViewModel.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/7/7.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxDataSources
///新品推荐
class NewGoodViewModel:NSObject,OutputRefreshProtocol{
    ///新品数据
    var newGoodArrModelBR=BehaviorRelay<[SectionModel<String,GoodDetailModel>]>(value:[])

    ///保存新品数据
    var newGoodArrModel=[GoodDetailModel]()

    ///发送网络请求(true)刷新数据 false加载下一页
    var requestNewDataCommond = PublishSubject<Bool>()

    ///默认加载第一页
    private var currentPage=1

    ///每页加载10条
    private var pageSize=10

    ///刷新状态
    var refreshStatus = BehaviorRelay<PHRefreshStatus>(value:.none)
    override init() {
        super.init()
        requestNewDataCommond
            .startWith(true)//默认刷新数据加载
            .subscribe(onNext: { [weak self] (b) in
                if b {//重新加载数据
                    self?.currentPage=1
                    self?.getNewGood(b:b)
                }else{///加载下一页
                    self?.currentPage+=1
                    self?.getNewGood(b:b)
                }
            }).disposed(by:rx_disposeBag)
    }
    ///获取新品推荐商品
    private func getNewGood(b:Bool){
        weak var weakSelf=self
        if weakSelf == nil{
            return
        }
        PHRequest.shared.requestJSONArrModel(target:GoodAPI.queryGoodsForAndroidIndexForStoreNew(storeId:store_Id!, pageSize:pageSize, currentPage:currentPage), model:GoodDetailModel.self).subscribe(onNext: {  (arr) in
            if b == true{///刷新
                ///每次获取最新的数据
                weakSelf!.newGoodArrModel=arr
                weakSelf!.newGoodArrModelBR.accept([SectionModel.init(model:"",items:weakSelf!.newGoodArrModel)])


            }else{//加载更多
                ///追加数据
                weakSelf!.newGoodArrModel+=arr
                weakSelf!.newGoodArrModelBR.accept([SectionModel.init(model:"",items:weakSelf!.newGoodArrModel)])
            }
            weakSelf!.refreshStatus.accept(.endHeaderRefresh)
            weakSelf!.refreshStatus.accept(.endFooterRefresh)
            if arr.count < weakSelf!.pageSize{//如果下面没有数据了
                weakSelf!.refreshStatus.accept(.noMoreData)
            }
        }, onError: { (error) in
            ///把页索引-1
            if weakSelf!.currentPage > 1{
                weakSelf!.currentPage-=1
            }
            weakSelf!.refreshStatus.accept(.endHeaderRefresh)
            weakSelf!.refreshStatus.accept(.endFooterRefresh)
            phLog("获取新品推荐列表数据出错\(error.localizedDescription)")
        }).disposed(by:rx_disposeBag)
    }
}
