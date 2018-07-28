//
//  UpdateAddAddressViewModel.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/7/20.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
///修改/添加vm
class UpdateAddAddressViewModel:NSObject{
    ///操作成功
    var resultPS=PublishSubject<Bool>()
        
    override init() {
        super.init()
    }
}
extension UpdateAddAddressViewModel{

    ///添加收货地址
     func addAddress(flag:Int,province:String,city:String,county:String,detailAddress:String,phoneNumber:String,shippName:String){
        let b=validateInputInfo(province: province, city: city, county: county, detailAddress: detailAddress, phoneNumber: phoneNumber, shippName: shippName)
        if b == false{
            return
        }
            PHProgressHUD.showLoading("正在添加收货地址")
            PHRequest.shared.requestJSONObject(target:MyAPI.addStoreShippAddressforAndroid(flag:flag, storeId:store_Id!, county: county, city: city, province: province, shippName: shippName, detailAddress: detailAddress, phoneNumber: phoneNumber)).debug().subscribe(onNext: { [weak self] (result) in
            switch result{
            case let .success(json:json):
                let success=json["success"].stringValue
                if success == "success"{
                    PHProgressHUD.showSuccess("添加成功")
                    self?.resultPS.onNext(true)
                }else{
                    PHProgressHUD.showError("添加收货地址失败")
                }
                break
            default:
                PHProgressHUD.showError("添加收货地址失败")
                break
            }
        }, onError: { (error) in
            phLog("添加收货地址失败")
        }).disposed(by:rx_disposeBag)
    }

    ///修改收货地址
     func updateAddress(flag:Int,province:String,city:String,county:String,detailAddress:String,phoneNumber:String,shippName:String,shippAddressId:Int){

            let b=validateInputInfo(province: province, city: city, county: county, detailAddress: detailAddress, phoneNumber: phoneNumber, shippName: shippName)
        if b == false{
            return
        }
            PHProgressHUD.showLoading("正在修改收货地址")
            PHRequest.shared.requestJSONObject(target:MyAPI.updateStoreShippAddressforAndroid(flag: flag, storeId:store_Id!, county: county, city: city, province: province, shippName: shippName, detailAddress: detailAddress, phoneNumber: phoneNumber,shippAddressId: shippAddressId)).subscribe(onNext: { [weak self] (result) in
            switch result{
            case let .success(json:json):
                let success=json["success"].stringValue
                if success == "success"{
                    PHProgressHUD.showSuccess("修改成功")
                    self?.resultPS.onNext(true)
                }else{
                    PHProgressHUD.showError("修改收货地址失败")
                }
                break
            default:
                PHProgressHUD.showError("修改收货地址失败")
                break
            }
        }, onError: { (error) in
            phLog("修改收货地址失败")
        }).disposed(by:rx_disposeBag)
    }

    ///验证输入信息
    private func validateInputInfo(province:String,city:String,county:String,detailAddress:String,phoneNumber:String,shippName:String) -> Bool{
        if shippName.isNil(){
            PHProgressHUD.showInfo("收货人姓名不能为空")
            return false
        }
        if phoneNumber.isNil(){
            PHProgressHUD.showInfo("联系方式不能为空")
            return false
        }
        if !phoneNumber.validateStrCount(count: 11){
            PHProgressHUD.showInfo("手机号码格式不正确")
            return false
        }
        if province.isNil() || city.isNil() || county.isNil(){
            PHProgressHUD.showInfo("请选择省市区")
            return false
        }
        if detailAddress.isNil(){
            PHProgressHUD.showInfo("详细地址不能为空")
            return false
        }
        if detailAddress.containsEmoji{
            PHProgressHUD.showInfo("详细地址不能包含特殊字符")
            return false
        }
        return true

    }
}
