//
//  AddCarGoodCountViewModel.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/7/12.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxDataSources
///加入购物车vm
class AddCarGoodCountViewModel:NSObject {

    ///加入购物车
    var addCarPS=PublishSubject<Int>()

    ///查询购物车商品数量 true是
    var queryCarSumCountPS=PublishSubject<Bool>()

    ///查询购物车总数量结果
    var queryCarSumCountBR=BehaviorRelay<Int>(value:0)

    ///flag   1特价，2普通,3促销
    init(model:GoodDetailModel?=nil,flag:Int?=nil) {
        super.init()
        if model != nil && flag != nil{
            ///加入购物车
            addCarPS.subscribe(onNext: { [weak self] (goodCount) in
                self?.addCar(model:model!,goodsCount:goodCount,flag:flag!)
            }).disposed(by:rx_disposeBag)
        }
        ///查询购物车商品总数
        queryCarSumCountPS.subscribe(onNext: { [weak self] (b) in
            if b {
                self?.getCarSumCount()
            }
        }).disposed(by:rx_disposeBag)

    }
    ///加入购物车 1特价，2普通,3促销  可以直接对外调用
    func addCar(model:GoodDetailModel,goodsCount:Int,flag:Int){
        PHProgressHUD.show("正在加入...")
        ///促销期号
        var promotionNumber:Int?=nil
        if flag == 3{//如果是促销
            promotionNumber=model.promotionNumber
        }
        PHRequest.shared.requestJSONObject(target:CarAPI.insertShoppingCar(memberId:member_Id!, goodId:model.goodsbasicinfoId ?? 0, supplierId: model.supplierId ?? 0, subSupplierId:model.subSupplier ?? 0,goodsCount: goodsCount,flag:flag, goodsStock:model.goodsStock ?? 0, storeId:store_Id!,promotionNumber:promotionNumber)).subscribe(onNext: { [weak self] (result) in
            switch result{
            case let .success(json:json):
                let success=json["success"].stringValue
                if success == "success"{
                    let count=json["shoppingCount"].intValue
                    ///查询购物车商品总数量
                    self?.queryCarSumCountBR.accept(count)

                    ///更新购物车角标
                    NotificationCenter.default.post(name:NSNotification.Name(rawValue:"postBadgeValue"), object:1)
                    PHProgressHUD.showSuccess("成功加入购物车")
                }else if success == "tjxgbz"{
                    PHProgressHUD.showInfo("特价商品限购数量不足")
                }else if success == "tjbz"{
                    PHProgressHUD.showInfo("特价可购买数量不足")
                }else if success == "zcbz"{
                    PHProgressHUD.showInfo("已超过该商品库存数")
                }else if success == "xgysq"{
                    PHProgressHUD.showInfo("促销限购已售罄")
                }else if success == "grxgbz"{
                    PHProgressHUD.showInfo("促销个人限购不足")
                }else{
                    PHProgressHUD.showError("加入购物车失败")
                }
                break
            default:break
            }
            }, onError: { (error) in
                phLog("加入购物车出错\(error.localizedDescription)")
        }).disposed(by:rx_disposeBag)
    }
    ///查询购物车商品总数量
    private func getCarSumCount(){

        PHRequest.shared.requestJSONObject(target:CarAPI.memberShoppingCarCountForMobile(memberId:member_Id ?? "")).subscribe(onNext: { [weak self] (result) in
            switch result{
            case let .success(json:json):
                let count=json["shoppingCount"].intValue
                ///查询购物车商品总数量
                self?.queryCarSumCountBR.accept(count)
                break
            default:break
            }
        }, onError: { (error) in
            phLog("查询购物车商品数量出错")
        }).disposed(by:rx_disposeBag)
    }
}
