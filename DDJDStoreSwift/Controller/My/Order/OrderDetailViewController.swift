//
//  OrderDetailViewController.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/7/5.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
///订单详情
class OrderDetailViewController:BaseViewController{

    ///接收订单Id
    var orderinfoId:Int?

    ///订单编号
    @IBOutlet weak var lblOrderSN:UILabel!

    ///订单状态
    @IBOutlet weak var lblOrderStatus:UILabel!

    ///联系店铺名称
    @IBOutlet weak var lblStoreName:UILabel!

    ///店铺联系方式
    @IBOutlet weak var lblPhone_tel:UILabel!

    ///店铺地址
    @IBOutlet weak var lblStoreAddress:UILabel!

    ///订单总价
    @IBOutlet weak var lblOrderPrice:UILabel!

    ///订单按钮 取消订单 确认收货  根据状态来定
    @IBOutlet weak var btn:UIButton!
    var vm:OrderDetailViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="订单详情"
        ///设置按钮圆角
        btn.layer.cornerRadius=35/2
        ///初始化vm
        vm=OrderDetailViewModel(orderinfoId:orderinfoId)
        ///绑定vm
        bindViewModel()
    }
}
///绑定vm
extension OrderDetailViewController{
    private func bindViewModel(){
        vm.orderDetailModelBR.asObservable().subscribe(onNext: { [weak self] (model) in
            self?.lblPhone_tel.text=model.phone_tel
            self?.lblOrderSN.text=model.orderSN
            self?.lblStoreName.text=model.storeName
            self?.lblStoreAddress.text=model.address
            self?.lblOrderPrice.text="￥\(model.orderPrice ?? "0")"
            if model.orderStatus == 1{
                self?.lblOrderStatus.text="未发货"
                self?.btn.setTitle("取消订单", for: UIControlState.normal)
            }else if model.orderStatus == 2{
                self?.lblOrderStatus.text="已发货"
                self?.btn.setTitle("确认收货", for: UIControlState.normal)
            }else if model.orderStatus == 3{
                self?.lblOrderStatus.text="已完成"
                self?.btn.isHidden=true
            }
        }).disposed(by:rx_disposeBag)
    }
}
