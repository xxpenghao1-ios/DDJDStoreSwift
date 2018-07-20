//
//  PlaceOrderViewModel.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/7/20.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
///下单vm
class PlaceOrderViewModel:NSObject{

    //保存代金券使用下限
    var cashcouponLowerLimitOfUseBS=BehaviorRelay<Int>(value:0)

    //保存是否开启可以使用代金券 默认2关闭,1开启
    var cashcouponStatuBS=BehaviorRelay<Int>(value:2)

    //分站店铺积分获取是否开启； 1开启，2关闭；
    var subStationBalanceStatuBS=BehaviorRelay<Int>(value:2)

    ///下单 true成功
    var submitSuccessBR=BehaviorRelay<Bool>(value:false)

    override init() {
        super.init()
        querySubStationCC()
        queryStoreMember()
    }
    ///提交订单
    func submitOrder(goodsList:String,pay_message:String,cashCouponId:Int?,addressModel:AddressModel?,detailAddress:String){
        if addressModel == nil{
            PHProgressHUD.showInfo("请选择收货地址")
            return
        }
        PHProgressHUD.showLoading("正在提交订单...")
        PHRequest.shared.requestJSONObject(target:OrderAPI.storeOrderForAndroid(goodsList:goodsList, detailAddress: detailAddress, phoneNumber: addressModel?.phoneNumber ?? "", shippName: addressModel?.shippName ?? "", storeId:store_Id!, pay_message: pay_message, tag: 2, cashCouponId: cashCouponId)).subscribe(onNext: { [weak self] (result) in
            print(result)
            switch result{
            case let .success(json:json):
                let success=json["success"].stringValue
                switch success{
                case "success":
                    self?.submitSuccessBR.accept(true)
                    break
                case "orderRepeat":
                    PHProgressHUD.showError("订单重复提交")
                    break
                case "info":
                    let info=json["info"].stringValue
                    PHProgressHUD.showError(info)
                    break
                default:
                    PHProgressHUD.showError("下单失败")
                    break
                }
                break
            case .faild(_):
                PHProgressHUD.showError("提交订单失败")
                break
            }
        }, onError: { (error) in
            phLog("提交订单出错")
        }).disposed(by:rx_disposeBag)
    }
    ///查询是否可以使用代金券
    private func querySubStationCC(){

        PHRequest.shared.requestJSONObject(target:MyAPI.querySubStationCC(substationId:substation_Id!)).subscribe(onNext: { [weak self] (result) in
            switch result{
            case let .success(json:json):
                self?.cashcouponLowerLimitOfUseBS.accept(json["cashcouponLowerLimitOfUse"].intValue)
                self?.cashcouponStatuBS.accept(json["cashcouponStatu"].intValue)
                phLog("店铺代金券使用下限\(json["cashcouponLowerLimitOfUse"].intValue)")
                phLog("店铺是否可以使用代金券\(json["cashcouponStatu"].intValue)")
                break
            default:break
            }
        }, onError: { (error) in
            phLog("获取是否开启代金券数据出错")
        }).disposed(by:rx_disposeBag)
    }
    ///查询分站信息店铺是否可以获取积分
    private func queryStoreMember(){
        PHRequest.shared.requestJSONObject(target:MyAPI.queryStoreMember(storeId:store_Id!, memberId:member_Id!)).subscribe(onNext: { [weak self] (result) in
            switch result{
            case let .success(json:json):
                let flag=json["substationEntity"]["subStationBalanceStatu"].intValue
                self?.subStationBalanceStatuBS.accept(flag)
                phLog("店铺是否可以获取积分\(flag)")
                break
            default:break
            }
        }, onError: { (error) in
            phLog("获取店铺是否可以获取积分出错")
        }).disposed(by:rx_disposeBag)
    }
}
