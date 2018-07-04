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
///个人中心model
struct MyModel{
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
    var orderBR=BehaviorRelay<[SectionModel<String,MyModel>]>(value:[])

    ///菜单视图数据源
    var menuBR=BehaviorRelay<[SectionModel<String,MyModel>]>(value:[])

    override init() {
        super.init()

        ///订单数据
        orderBR.accept([SectionModel(model:"",items:
            [MyModel.init(name:"未发货", imgStr:"my_order_wfh"),
            MyModel.init(name:"已发货", imgStr:"my_order_yfh"),
            MyModel.init(name:"已完成", imgStr:"my_order_ywc")]
            )])

        ///菜单数据
        menuBR.accept([SectionModel(model:"",items:
            [MyModel.init(name:"购物车", imgStr:"my_car"),
             MyModel.init(name:"点单币记录", imgStr:"my_ddb_record"),
             MyModel.init(name:"点单商城", imgStr:"my_dd_store"),
             MyModel.init(name:"我的收藏", imgStr:"my_collection"),
             MyModel.init(name:"我的消息", imgStr:"my_message"),
             MyModel.init(name:"我的代金券", imgStr:"my_voucher"),
             MyModel.init(name:"联系客服", imgStr:"my_contact_customerService"),
             MyModel.init(name:"投诉与建议", imgStr:"my_complaintsSuggestions")]
            )])
    }
}
