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

}

extension UpdateAddAddressViewModel:ViewModelType{
    ///输入
    public struct Input{
        ///如果有值是修改收货地址
        let shippAddressId:Observable<Int?>
        ///是否是默认地址
        let flag:Observable<Int>
        ///省
        let province:Observable<String>
        ///市
        let city:Observable<String>
        ///区
        let county:Observable<String>
        ///详细地址
        let detailAddress:Observable<String>
        ///手机号码
        let phoneNumber:Observable<String>
        ///收货人姓名
        let shippName:Observable<String>
        ///提交
        let submit:Observable<Void>
    }
    ///输出
    struct Output {
        ///true操作成功跳转页面
        let result:Observable<Bool>
        init(result:Observable<Bool>) {
            self.result=result
        }
    }
    func transform(input:Input) -> Output {

        ///合并
        let observableS=Observable.combineLatest(input.flag,input.province,input.city,input.county,input.detailAddress,input.phoneNumber,input.shippName,input.shippAddressId)

        ///接收返回结果true 成功 false失败
        let result=input.submit.withLatestFrom(observableS)
            .filter { [weak self] in ///验证输入是否正确
                return self?.validateInputInfo(flag:$0,province:$1, city: $2, county: $3, detailAddress: $4, phoneNumber: $5, shippName: $6,shippAddressId:$7) ?? false
            }.flatMapFirst { (res)-> Observable<ResponseResult> in
                if res.7 == nil{///添加收货地址
                    return  PHRequest.shared.requestJSONObject(target:MyAPI.addStoreShippAddressforAndroid(flag:res.0, storeId:store_Id!, county:res.3, city:res.2, province:res.1, shippName:res.6, detailAddress:res.4, phoneNumber:res.5, IPhonePenghao:520))
                }else{///修改收货
                    return PHRequest.shared.requestJSONObject(target:MyAPI.updateStoreShippAddressforAndroid(flag:res.0, storeId:store_Id!, county:res.3, city:res.2, province:res.1, shippName:res.6, detailAddress:res.4, phoneNumber:res.5, IPhonePenghao:520, shippAddressId:res.7!))
                }
            }.map({ (result) -> Bool in
                switch result{
                case let .success(json:json):
                    let success=json["success"].stringValue
                    if success == "success"{

                        PHProgressHUD.showSuccess("操作成功")
                        return true
                    }else{
                        PHProgressHUD.showError("操作失败")
                        return false
                    }
                default:
                    PHProgressHUD.showError("操作失败")
                    return false

                }
            })
        return Output(result:result)
    }

}
extension UpdateAddAddressViewModel{

    ///添加收货地址
    private func addAddress(flag:Int,province:String,city:String,county:String,detailAddress:String,phoneNumber:String,shippName:String){
        PHRequest.shared.requestJSONObject(target:MyAPI.addStoreShippAddressforAndroid(flag:flag, storeId:store_Id!, county: county, city: city, province: province, shippName: shippName, detailAddress: detailAddress, phoneNumber: phoneNumber, IPhonePenghao:520)).subscribe(onNext: { (result) in
            switch result{
            case let .success(json:json):
                let success=json["success"].stringValue
                if success == "success"{
                    PHProgressHUD.showSuccess("添加成功")
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
    private func updateAddress(flag:Int,province:String,city:String,county:String,detailAddress:String,phoneNumber:String,shippName:String,shippAddressId:Int){
        PHRequest.shared.requestJSONObject(target:MyAPI.updateStoreShippAddressforAndroid(flag: flag, storeId:store_Id!, county: county, city: city, province: province, shippName: shippName, detailAddress: detailAddress, phoneNumber: phoneNumber, IPhonePenghao:520, shippAddressId: shippAddressId)).subscribe(onNext: { (result) in
            switch result{
            case let .success(json:json):
                let success=json["success"].stringValue
                if success == "success"{
                    PHProgressHUD.showSuccess("修改成功")
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
    private func validateInputInfo(flag:Int,province:String,city:String,county:String,detailAddress:String,phoneNumber:String,shippName:String,shippAddressId:Int?) -> Bool{
//        if shippName.isNil(){
//            PHProgressHUD.showInfo("收货人姓名不能为空")
//            return false
//        }
//        if phoneNumber.isNil(){
//            PHProgressHUD.showInfo("联系方式不能为空")
//            return false
//        }
//        if !phoneNumber.validateStrCount(count: 11) && phoneNumber.first{
//
//        }
//        if province.isNil() || city.isNil() || county.isNil(){
//            PHProgressHUD.showInfo("请选择省市区")
//            return false
//        }
//        if detailAddress
        return true

    }
}
