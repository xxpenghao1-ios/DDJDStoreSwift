//
//  OrderViewModel.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/7/5.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxDataSources
///订单vm
class OrderViewModel:NSObject,OutputRefreshProtocol{

    ///订单数据
    var orderArrModelBR=BehaviorRelay<[EmptyDataType:[SectionModel<String,OrderModel>]]>(value:[.loading:[]])

    ///保存订单数据
    var orderArrModel=[OrderModel]()

    ///发送网络请求(true)刷新数据 false加载下一页
    var requestNewDataCommond = PublishSubject<Bool>()

    ///默认加载第一页
    private var currentPage=1

    ///每页加载10条
    private var pageSize=10

    ///刷新状态
    var refreshStatus = BehaviorRelay<PHRefreshStatus>(value:.none)

    ///传入订单状态
    init(orderStatus:Int?) {
        super.init()
        requestNewDataCommond.startWith(true)
            .subscribe(onNext: { [weak self] (b) in
                if b {//重新加载数据
                    self?.currentPage=1
                    self?.getOrderInfo4AndroidStoreByOrderStatus(b:b, orderStatus: orderStatus)
                }else{///加载下一页
                    self?.currentPage+=1
                    self?.getOrderInfo4AndroidStoreByOrderStatus(b:b, orderStatus: orderStatus)
                }
            }).disposed(by:rx_disposeBag)
    }
}

extension OrderViewModel{
    ///查询订单数据
    private func getOrderInfo4AndroidStoreByOrderStatus(b:Bool,orderStatus:Int?){

        PHRequest.shared.requestJSONArrModel(target:OrderAPI.queryOrderInfo4AndroidStoreByOrderStatus(orderStatus:orderStatus ?? 0, storeId:store_Id!, pageSize: pageSize, currentPage:currentPage), model:OrderModel.self).subscribe(onNext: { [weak self] (arr) in
            self?.subscribeResult(b:b, arr:arr)
        }, onError: { [weak self] (error) in
            self?.errorResult()
        }).disposed(by:rx_disposeBag)
    }

    ///请求结果
    private func subscribeResult(b:Bool,arr:[OrderModel]){
        if b == true{///刷新
            ///每次获取最新的数据
            orderArrModel=arr
            orderArrModelBR.accept([.noData:[SectionModel.init(model:"",items:orderArrModel)]])


        }else{//加载更多
            ///追加数据
            orderArrModel+=arr
            orderArrModelBR.accept([.noData:[SectionModel.init(model:"",items:orderArrModel)]])
        }
        refreshStatus.accept(.endHeaderRefresh)
        refreshStatus.accept(.endFooterRefresh)
        if arr.count < pageSize{//如果下面没有数据了
            refreshStatus.accept(.noMoreData)
        }
    }

    ///错误结果
    private func errorResult(){
        refreshStatus.accept(.endHeaderRefresh)
        refreshStatus.accept(.endFooterRefresh)
        ///把页索引-1
        if currentPage > 1{
            currentPage-=1
        }else{ ///如果是第一页 表示第一次加载出错了  隐藏加载更多
            refreshStatus.accept(.noMoreData)
            ///获取数据出错 空页面提示
            orderArrModelBR.accept([.dataError:[SectionModel.init(model:"",items:orderArrModel)]])
        }
    }
}
