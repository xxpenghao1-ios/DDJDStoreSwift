//
//  CarViewModel.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/7/17.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import RxCocoa
import RxDataSources
import RxSwift
///购物车vm
class CarViewModel:NSObject{

    ///发送网络请求
    var requestNewDataCommond = PublishSubject<Bool>()

    ///保存购物车数据
    var carListModelBR=BehaviorRelay<[EmptyDataType:[SectionModel<CarModel,GoodDetailModel>]]>(value:[.loading:[]])

    override init() {
        super.init()

        requestNewDataCommond.subscribe(onNext: { [weak self] (b) in
            self?.getCarGoodList()
        }).disposed(by:rx_disposeBag)
    }
}
///网络请求
extension CarViewModel{

    ///获取购物车商品数量
    private func getCarGoodList(){
        weak var weakSelf=self
        if weakSelf == nil{
            return
        }
        PHRequest.shared.requestJSONArrModel(target:CarAPI.queryShoppingCarNew(memberId:member_Id!, storeId:store_Id!), model:CarModel.self).subscribe(onNext: { (arr) in

                weakSelf!.carListModelBR.accept(weakSelf!.setArrSectionModel(arr:arr))
            }, onError: { (error) in
                weakSelf!.carListModelBR.accept([.dataError:[]])
                phLog("获取购物车数据出错\(error.localizedDescription)")
        }).disposed(by:rx_disposeBag)
    }

    ///生成购物车RxDataSources对应数据
    private func setArrSectionModel(arr:[CarModel]) -> [EmptyDataType:[SectionModel<CarModel,GoodDetailModel>]]{
        if arr.count == 0{
            return [.noData:[]]
        }else{
            var arrSectionModel=[SectionModel<CarModel, GoodDetailModel>]()
            for carModel in arr{

                if carModel.listGoods != nil &&  carModel.listGoods!.count > 0{///每组必须有商品
                    arrSectionModel.append(SectionModel.init(model:carModel, items:carModel.listGoods!))
                }
            }
            return [.noData:arrSectionModel]
        }
    }
}
