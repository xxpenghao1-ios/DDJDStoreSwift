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
    ///查询消息
    private func getOrderInfo4AndroidStoreByOrderStatus(b:Bool,orderStatus:Int?){
        weak var weakSelf=self
        if weakSelf == nil{
            return
        }
        PHRequest.shared.requestJSONArrModel(target:OrderAPI.queryOrderInfo4AndroidStoreByOrderStatus(orderStatus:orderStatus ?? 0, storeId:store_Id!, pageSize: pageSize, currentPage:currentPage), model:OrderModel.self).subscribe(onNext: { (arr) in
            if b == true{///刷新
                ///每次获取最新的数据
                weakSelf!.orderArrModel=arr
                weakSelf!.orderArrModelBR.accept([.noData:[SectionModel.init(model:"",items:weakSelf!.orderArrModel)]])


            }else{//加载更多
                ///追加数据
                weakSelf!.orderArrModel+=arr
                weakSelf!.orderArrModelBR.accept([.noData:[SectionModel.init(model:"",items:weakSelf!.orderArrModel)]])
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
                ///获取数据出错 空页面提示
                weakSelf!.orderArrModelBR.accept([.dataError:[SectionModel.init(model:"",items:weakSelf!.orderArrModel)]])
            }
        }).disposed(by:rx_disposeBag)
    }
}
