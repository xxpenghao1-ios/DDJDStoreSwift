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
     var newGoodArrModelBR=BehaviorRelay<[EmptyDataType:[SectionModel<String,GoodDetailModel>]]>(value:[.loading:[]])

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
        PHRequest.shared.requestJSONArrModel(target:GoodAPI.queryGoodsForAndroidIndexForStoreNew(storeId:store_Id!, pageSize:pageSize, currentPage:currentPage), model:GoodDetailModel.self).subscribe(onNext: {  [weak self] (arr) in
            self?.subscribeResult(b:b, arr:arr)
        }, onError: { [weak self] (error) in
            self?.errorResult()
            phLog("获取新品推荐列表数据出错\(error.localizedDescription)")
        }).disposed(by:rx_disposeBag)
    }
    ///请求结果处理
    private func subscribeResult(b:Bool,arr:[GoodDetailModel]){
        if b == true{///刷新
            ///每次获取最新的数据
            newGoodArrModel=arr
            newGoodArrModelBR.accept([.noData:[SectionModel.init(model:"",items:newGoodArrModel)]])


        }else{//加载更多
            ///追加数据
            newGoodArrModel+=arr
            newGoodArrModelBR.accept([.noData:[SectionModel.init(model:"",items:newGoodArrModel)]])
        }
        refreshStatus.accept(.endHeaderRefresh)
        refreshStatus.accept(.endFooterRefresh)
        if arr.count < pageSize{//如果下面没有数据了
            refreshStatus.accept(.noMoreData)
        }
    }

    ///错误结果处理
    private func errorResult(){
        refreshStatus.accept(.endHeaderRefresh)
        refreshStatus.accept(.endFooterRefresh)
        ///把页索引-1
        if currentPage > 1{
            currentPage-=1
        }else{ ///如果是第一页 表示第一次加载出错了  隐藏加载更多
            refreshStatus.accept(.noMoreData)
            ///获取数据出错 空页面提示
            newGoodArrModelBR.accept([.dataError:[SectionModel.init(model:"",items:newGoodArrModel)]])
        }
    }
}
