//
//  VouchersViewModel.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/7/25.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources
import RxCocoa
///代金券vm
class VouchersViewModel:NSObject,OutputRefreshProtocol{
    ///请求购买记录
    var requestVouchersPS=PublishSubject<Bool>()
    var vouchersBR=BehaviorRelay<[EmptyDataType:[SectionModel<String,VouchersModel>]]>(value:[.loading:[]])
    ///保存购买记录
    var vouchersArr=[VouchersModel]()

    ///刷新状态
    var refreshStatus = BehaviorRelay<PHRefreshStatus>(value:.none)
    ///默认加载第一页
    private var currentPage=1

    ///每页加载10条
    private var pageSize=10

    override init() {
        super.init()
        ///请求收藏商品
        requestVouchersPS.subscribe(onNext: { [weak self] (b) in
            if b{
                self?.currentPage=1
            }else{
                self?.currentPage+=1
            }
            self?.requestVouchers(b:b)
        }).disposed(by:rx_disposeBag)
    }

    ///请求代金券数据
    private func requestVouchers(b:Bool){
         PHRequest.shared.requestJSONArrModel(target:MyAPI.queryStoreCashCoupon(storeId:store_Id!, pageSize: pageSize, currentPage: currentPage), model:VouchersModel.self).debug().subscribe(onNext: { [weak self] (arr) in
            self?.subscribeResult(b:b, arr:arr)
        }, onError: { [weak self] (error) in
            self?.errorResult()
            phLog("获取代金券出错")
        }).disposed(by:rx_disposeBag)
    }
    ///请求结果
    private func subscribeResult(b:Bool,arr:[VouchersModel]){
        if b == true{///刷新
            ///每次获取最新的数据
            vouchersArr=arr
            vouchersBR.accept([.noData:[SectionModel.init(model:"",items:vouchersArr)]])


        }else{//加载更多
            ///追加数据
            vouchersArr+=arr
            vouchersBR.accept([.noData:[SectionModel.init(model:"",items:vouchersArr)]])
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
            vouchersBR.accept([.dataError:[SectionModel.init(model:"",items:vouchersArr)]])
        }
    }
}
