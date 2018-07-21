//
//  AddressViewModel.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/7/20.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxDataSources
///收货地址vm
class AddressViewModel:NSObject{

    ///收货地址rx用
    var addressListBR=BehaviorRelay<[EmptyDataType:[SectionModel<String,AddressModel>]]>(value:[.loading:[]])

    ///保存默认收货地址(下单页面用到)  如果没有默认地址选择第一个地址
    var defaultAddressModelBR=BehaviorRelay<AddressModel?>(value:nil)

    ///保存收货地址
    var addressList=[AddressModel]()

    ///发送网络请求(true)加载数据
    var requestNewDataCommond = PublishSubject<Bool>()

    ///删除收货地址  传入行索引
    var deleteAddressPS=PublishSubject<Int>()

    override init() {
        super.init()

        requestNewDataCommond.subscribe(onNext: { [weak self] (b) in
            if b{
                self?.getAddressList()
            }
        }).disposed(by:rx_disposeBag)

        ///删除收货地址
        deleteAddressPS.subscribe(onNext: { [weak self] (row) in
            self?.deleteAddress(row:row)
        }).disposed(by:rx_disposeBag)
    }

}
extension AddressViewModel{

    ///拿默认收货地址 可以为空
    private func getDefaultAddressMode(){
        ///拿到默认地址
        var model=addressList.first(where: { (model) in
            return model.defaultFlag == 1
        })
        if model == nil{///如果为空拿第一个
            model=addressList.first
        }
        self.defaultAddressModelBR.accept(model)
    }
    ///获取地址信息
    private func getAddressList(){

        PHRequest.shared.requestJSONArrModel(target:MyAPI.queryStoreShippAddressforAndroid(storeId:store_Id!), model:AddressModel.self).subscribe(onNext: { [weak self] (arr) in
            self?.addressList=arr
            self?.addressListBR.accept([.noData :[SectionModel.init(model:"",items:arr)]])
            self?.getDefaultAddressMode()

        }, onError: { [weak self] (error) in
            self?.addressListBR.accept([.dataError :[SectionModel.init(model:"",items:[])]])
            phLog("获取收货地址数据出错")
        }).disposed(by:rx_disposeBag)
    }

    ///删除收货地址
    private func deleteAddress(row:Int){
        let shippAddressId=addressList[row].shippAddressId ?? 0
        PHRequest.shared.requestJSONObject(target:MyAPI.deleteStoreShippAddressforAndroid(shippAddressId:shippAddressId)).subscribe(onNext: { [weak self] (result) in
            switch result{
            case let .success(json:json):
                let success=json["success"].stringValue
                if success == "success"{
                    ///删除数据源
                    self?.addressList.remove(at:row)
                    ///更新ui
                    self?.addressListBR.accept([.noData :[SectionModel.init(model:"",items:self?.addressList ?? [])]])
                    self?.getDefaultAddressMode()
                }else{
                    PHProgressHUD.showError("删除地址失败")
                }
                break
            default:
                PHProgressHUD.showError("删除地址失败")
                break
            }
        }, onError: { (error) in
            phLog("删除地址出错")
        }).disposed(by:rx_disposeBag)
    }
}
