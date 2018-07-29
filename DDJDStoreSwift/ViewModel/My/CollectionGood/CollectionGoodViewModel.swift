//
//  CollectionGoodViewModel.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/7/25.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import RxDataSources
import RxCocoa
import RxSwift
///收藏商品vm
class CollectionGoodViewModel:NSObject,OutputRefreshProtocol{

    ///取消收藏
    var cancelCollectionPS=PublishSubject<Int>()

    ///请求收藏商品
    var requestCollectionGoodPS=PublishSubject<Bool>()
    var collectionGoodBR=BehaviorRelay<[EmptyDataType:[SectionModel<String,GoodDetailModel>]]>(value:[.loading:[]])
    ///保存收藏商品
    var collectionGoodArr=[GoodDetailModel]()

    ///刷新状态
    var refreshStatus = BehaviorRelay<PHRefreshStatus>(value:.none)

    ///默认加载第一页
    private var currentPage=1

    ///每页加载10条
    private var pageSize=10
    override init() {
        super.init()

        
        ///请求收藏商品
        requestCollectionGoodPS.subscribe(onNext: { [weak self] (b) in
            if b{
                self?.currentPage=1
            }else{
                self?.currentPage+=1
            }
            self?.requestCollectionGood(b:b)
        }).disposed(by:rx_disposeBag)
    }
}

extension CollectionGoodViewModel{


    ///请求收藏商品
    private func requestCollectionGood(b:Bool){

        PHRequest.shared.requestJSONArrModel(target:GoodAPI.queryStoreCollectionList(memberId:member_Id!,pageSize:pageSize,currentPage:currentPage), model:GoodDetailModel.self).debug().subscribe(onNext: { [weak self] (arr) in
                self?.subscribeResult(b:b, arr:arr)
            }, onError: { [weak self] (error) in
                self?.errorResult()
            phLog("获取收藏商品失败")
        }).disposed(by:rx_disposeBag)
    }

    ///请求结果
    private func subscribeResult(b:Bool,arr:[GoodDetailModel]){
        if b == true{///刷新
            ///每次获取最新的数据
            collectionGoodArr=arr
            collectionGoodBR.accept([.noData:[SectionModel.init(model:"",items:collectionGoodArr)]])


        }else{//加载更多
            ///追加数据
            collectionGoodArr+=arr
            collectionGoodBR.accept([.noData:[SectionModel.init(model:"",items:collectionGoodArr)]])
        }
        refreshStatus.accept(.endHeaderRefresh)
        refreshStatus.accept(.endFooterRefresh)
        if arr.count < pageSize{//如果下面没有数据了
            refreshStatus.accept(.noMoreData)
        }
    }

    ///请求错误
    private func errorResult(){
        refreshStatus.accept(.endHeaderRefresh)
        refreshStatus.accept(.endFooterRefresh)
        ///把页索引-1
        if currentPage > 1{
            currentPage-=1
        }else{ ///如果是第一页 表示第一次加载出错了  隐藏加载更多
            refreshStatus.accept(.noMoreData)
            ///获取数据出错 空页面提示
            collectionGoodBR.accept([.dataError:[SectionModel.init(model:"",items:collectionGoodArr)]])
        }
    }
}
