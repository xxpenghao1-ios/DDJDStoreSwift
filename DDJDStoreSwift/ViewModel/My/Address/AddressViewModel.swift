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

    override init() {
        super.init()

        requestNewDataCommond.subscribe(onNext: { [weak self] (b) in
            if b{
                self?.getAddressList()
            }
        }).disposed(by:rx_disposeBag)
    }

}
extension AddressViewModel{

    ///获取地址信息
    private func getAddressList(){

        PHRequest.shared.requestJSONArrModel(target:MyAPI.queryStoreShippAddressforAndroid(storeId:store_Id!), model:AddressModel.self).subscribe(onNext: { [weak self] (arr) in
            self?.addressList=arr
            self?.addressListBR.accept([.noData :[SectionModel.init(model:"",items:arr)]])
            ///拿到默认地址
            var model=arr.first(where: { (model) in
                return model.defaultFlag == 1
            })
            if model == nil{///如果为空拿第一个
                model=arr.first
            }
            self?.defaultAddressModelBR.accept(model)

        }, onError: { [weak self] (error) in
            self?.addressListBR.accept([.dataError :[SectionModel.init(model:"",items:[])]])
            phLog("获取收货地址数据出错")
        }).disposed(by:rx_disposeBag)
    }
}
