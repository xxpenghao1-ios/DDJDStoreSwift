//
//  MyViewModel.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/7/3.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import ObjectMapper
import RxDataSources
///个人中心订单视图model
struct MyOrderViewModel{
    var name:String
    var imgStr:String
    init(name:String,imgStr:String) {
        self.name=name
        self.imgStr=imgStr
    }
}
///个人中心VM
class MyViewModel:NSObject{

    ///订单视图数据源
    var orderBR=BehaviorRelay<[SectionModel<String,MyOrderViewModel>]>(value:[])

    override init() {
        super.init()

        orderBR.accept([SectionModel(model:"",items:
            [MyOrderViewModel.init(name:"未发货", imgStr:"my_order_wfh"),
            MyOrderViewModel.init(name:"已发货", imgStr:"my_order_yfh"),
            MyOrderViewModel.init(name:"已完成", imgStr:"my_order_ywc")]
            )])
    }
}
