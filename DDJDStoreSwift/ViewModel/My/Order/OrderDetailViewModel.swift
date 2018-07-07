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

    ///订单其他信息title
    var orderOtherTitleArr=["下单时间","卖家联系方式","卖家留言","买家留言","支付方式","配送方式"]

    ///订单其他信息titleValue
    var orderOtherTitleArrValue=[String?]()

    ///取消订单  随便传入一个值反正不用
    var cancelOrderPS = PublishSubject<Bool>()

    ///取消订单结果
    var cancelOrderResult:Observable<Bool>?

    ///确认收货 随便传入一个值反正不用
    var confirmTheGoodsPS=PublishSubject<Bool>()

    ///确认收货结果
    var confirmTheGoodsResult:Observable<Bool>?

    init(orderinfoId:Int?) {
        super.init()
        ///获取订单详情
        setOrderInfo4AndroidByorderId(orderinfoId:orderinfoId)
        ///取消订单
        cancelOrder(orderinfoId:orderinfoId)
        ///确认收货
        confirmTheGoods(orderinfoId:orderinfoId)
    }
    ///确认收货
    private func confirmTheGoods(orderinfoId:Int?){
        confirmTheGoodsResult=confirmTheGoodsPS.flatMapLatest({ (_) -> Observable<ResponseResult> in
            return PHRequest.shared.requestJSONObject(target:OrderAPI.updataOrderStatus4Store(orderinfoId:orderinfoId ?? 0))
        }).map({ (result) -> Bool in
            switch result{
            case let .success(json:json):
                let success=json["success"].stringValue
                if success == "success"{
                    PHProgressHUD.showSuccess("收货成功")
                    return true
                }else{
                    PHProgressHUD.showError("收货失败")
                    return false
                }
            default:return false
            }
        })
    }
    ///取消订单
    private func cancelOrder(orderinfoId:Int?){
        cancelOrderResult=cancelOrderPS.flatMapLatest { (_) -> Observable<ResponseResult> in
            PHProgressHUD.showLoading("正在取消订单...")
            return PHRequest.shared.requestJSONObject(target:OrderAPI.storeCancelOrder(orderId:orderinfoId ?? 0))

            }.map({ (result) -> Bool in
                switch result{
                case let .success(json:json):
                    let success=json["success"].stringValue
                    if success == "success"{
                        PHProgressHUD.showSuccess("订单取消成功")
                        return true
                    }else{
                        PHProgressHUD.showError("取消订单失败")
                        return false
                    }
                default:return false
                }
            })
    }
    ///查询订单详情
    private func setOrderInfo4AndroidByorderId(orderinfoId:Int?){
        PHRequest.shared.requestJSONModel(target:OrderAPI.queryOrderInfo4AndroidByorderId(orderinfoId:orderinfoId ?? 0), model: OrderModel.self).subscribe(onNext: { [weak self] (model) in
            ///下单时间
            self?.orderOtherTitleArrValue.append(model.add_time)
            self?.setOrderOtherTitle(model:model)
            ///卖家联系方式
            self?.orderOtherTitleArrValue.append(model.sellerName)
            ///卖家留言
            self?.orderOtherTitleArrValue.append(model.postscript ?? "无")
            ///买家留言
            self?.orderOtherTitleArrValue.append(model.pay_message ?? "无")
            self?.orderOtherTitleArrValue.append("货到付款")
            self?.orderOtherTitleArrValue.append("送货上门")
            if model.cashCouponId != nil && model.cashCouponId > 0{//如果代金券id不为空且大于0
                self?.orderOtherTitleArr.append("代金券")
                self?.orderOtherTitleArrValue.append("已使用\(model.cashCouponAmountOfMoney ?? 0)元代金劵")
            }
            self?.orderDetailModelBR.accept(model)
            }, onError: { (error) in
                phLog("获取订单详情数据出错\(error.localizedDescription)")
        }).disposed(by:rx_disposeBag)
    }
    ///根据订单状态设置特定信息
    private func setOrderOtherTitle(model:OrderModel){
        if model.orderStatus == 1{ //未发货
            orderOtherTitleArr.insert("预计到货时间", at:1)
            orderOtherTitleArrValue.append(Date().expectDate(dateStr:model.add_time,day:1))
        }else if model.orderStatus == 2{//已发货
            orderOtherTitleArr.insert("发货时间", at:1)
            orderOtherTitleArrValue.append(model.ship_time)
        }else if model.orderStatus == 3{//已完成
            orderOtherTitleArr.insert("完成时间", at:1)
            orderOtherTitleArrValue.append(model.finished_time)
        }
    }
}
