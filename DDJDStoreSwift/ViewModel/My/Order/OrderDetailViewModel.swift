//
//  OrderDetailViewModel.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/7/5.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources
///订单详情vm
class OrderDetailViewModel:NSObject{
    ///保存订单详情数据
    var orderDetailModelBR=BehaviorRelay<OrderModel>(value:OrderModel())
    init(orderinfoId:Int?) {
        super.init()
        PHRequest.shared.requestJSONModel(target:OrderAPI.queryOrderInfo4AndroidByorderId(orderinfoId:orderinfoId ?? 0), model: OrderModel.self).subscribe(onNext: { [weak self] (model) in
            self?.orderDetailModelBR.accept(model)
        }, onError: { (error) in
            phLog("获取订单详情数据出错\(error.localizedDescription)")
        }).disposed(by:rx_disposeBag)
    }
}
