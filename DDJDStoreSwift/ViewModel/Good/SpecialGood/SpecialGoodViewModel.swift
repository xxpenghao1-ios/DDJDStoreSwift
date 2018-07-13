//
//  SpecialGoodViewModel.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/7/10.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxDataSources
///特价vm
class SpecialGoodViewModel:NSObject,OutputRefreshProtocol{
    ///特价数据
    var specialArrModelBR=BehaviorRelay<[EmptyDataType:[SectionModel<String,GoodDetailModel>]]>(value:[.loading:[]])

    ///保存特价数据
    var specialArrModel=[GoodDetailModel]()

    ///发送网络请求(true)刷新数据 false加载下一页
    var requestNewDataCommond = PublishSubject<Bool>()

    ///默认加载第一页
    private var currentPage=1

    ///每页加载10条
    private var pageSize=10

    ///刷新状态
    var refreshStatus = BehaviorRelay<PHRefreshStatus>(value:.none)

    init(order:String) {
        super.init()
        requestNewDataCommond
            .startWith(true)//默认刷新数据加载
            .subscribe(onNext: { [weak self] (b) in
                if b {//重新加载数据
                    self?.currentPage=1
                    self?.getSpecialGoodArr(b:b, order:order)
                }else{///加载下一页
                    self?.currentPage+=1
                    self?.getSpecialGoodArr(b:b, order:order)
                }
            }).disposed(by:rx_disposeBag)
    }

    ///查询特价  order=count 销量排序   price 价格排序
    private func getSpecialGoodArr(b:Bool,order:String){
        weak var weakSelf=self
        if weakSelf == nil{
            return
        }
        PHRequest.shared.requestJSONArrModel(target:GoodAPI.queryPreferentialAndGoods4Store(storeId:store_Id!, pageSize:pageSize, currentPage: currentPage,order: order), model:GoodDetailModel.self).subscribe(onNext: { (arr) in
            if b == true{///刷新
                ///每次获取最新的数据
                weakSelf!.specialArrModel=arr
                weakSelf!.specialArrModelBR.accept([.noData:[SectionModel.init(model:"",items:weakSelf!.specialArrModel)]])


            }else{//加载更多
                ///追加数据
                weakSelf!.specialArrModel+=arr
                weakSelf!.specialArrModelBR.accept([.noData:[SectionModel.init(model:"",items:weakSelf!.specialArrModel)]])
            }
            weakSelf!.refreshStatus.accept(.endHeaderRefresh)
            weakSelf!.refreshStatus.accept(.endFooterRefresh)
            if arr.count < weakSelf!.pageSize{//如果下面没有数据了
                weakSelf!.refreshStatus.accept(.noMoreData)
            }
        }, onError: { (error) in
            weakSelf!.refreshStatus.accept(.endHeaderRefresh)
            weakSelf!.refreshStatus.accept(.endFooterRefresh)
            ///把页索引-1
            if weakSelf!.currentPage > 1{
                weakSelf!.currentPage-=1
            }else{ ///如果是第一页 表示第一次加载出错了  隐藏加载更多
                weakSelf!.refreshStatus.accept(.noMoreData)
                ///获取数据出错
                weakSelf!.specialArrModelBR.accept([.dataError:[SectionModel.init(model:"",items:weakSelf!.specialArrModel)]])
            }
            phLog("获取特价列表数据出错\(error.localizedDescription)")
        }).disposed(by:rx_disposeBag)
    }
}
