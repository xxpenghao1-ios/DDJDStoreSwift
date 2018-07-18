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
    ///总价
    var sumPriceBR=BehaviorRelay<String>(value:"0")
    ///刷新数据
    var arrPS=PublishSubject<Bool>()
    ///更新购物车商品数量(页面退出操作)
    var updateCarGoodListPS=PublishSubject<Bool>()
    ///删除购物车商品
    var deleteCarGoodListPS=PublishSubject<[GoodDetailModel]>()
    ///保存购物车数据
    var arr=[CarModel]()

    override init() {
        super.init()
        ///查询购物车商品数量
        requestNewDataCommond.subscribe(onNext: { [weak self] (_) in
            self?.getCarGoodList()
        }).disposed(by:rx_disposeBag)

        ///更新购物车商品数量(页面退出操作)s
        updateCarGoodListPS.subscribe(onNext: { [weak self] (_) in
            self?.updateCarAllGoodsNumForMember()
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
        PHProgressHUD.show("正在加载...")
        PHRequest.shared.requestJSONArrModel(target:CarAPI.queryShoppingCarNew(memberId:member_Id!, storeId:store_Id!), model:CarModel.self).map({ (arr) -> [CarModel] in
            ///筛选出商品list有值的(万一后台sb返回了个空呢😆)
            let carArr=arr.filter({ (carModel) -> Bool in
                return carModel.listGoods?.count > 0
            })
            return carArr
        }).subscribe(onNext: { (arr) in
                weakSelf!.arr=weakSelf!.setSumPriceArrModel(arr:arr)
                weakSelf!.arrPS.onNext(true)
        }, onError: { (error) in
                weakSelf!.arrPS.onNext(true)
                phLog("获取购物车数据出错\(error.localizedDescription)")
        }).disposed(by:rx_disposeBag)

    }
    ///修改购物车商品数量
    private func updateCarAllGoodsNumForMember(){
        ///保存所有的商品信息
        var goodArr=[GoodDetailModel]()
        for carModel in arr{
            if carModel.listGoods?.count > 0{
                goodArr+=carModel.listGoods!
            }
        }
        ///发送请求不做处理
        PHRequest.shared.requestJSONObject(target:CarAPI.updateCarAllGoodsNumForMember(memberId:member_Id!,goodsList:goodArr.toJSONString() ?? "")).subscribe().disposed(by:rx_disposeBag)
    }

    ///删除购物车商品
    private func deleteShoppingCar(arr:[GoodDetailModel]){
        PHProgressHUD.show("正在删除...")
        PHRequest.shared.requestJSONObject(target:CarAPI.deleteShoppingCar(memberId:member_Id!, goodsList: arr.toJSONString() ?? "")).subscribe(onNext: { (result) in
            switch result{
            case let .success(json:json):
                let success=json["success"].string
                if success == "success"{

                }else{
                    PHProgressHUD.showError("删除失败")
                }
                break
            case .faild(_):
                PHProgressHUD.showError("删除失败")
                break
            }
        }, onError: { (error) in
            PHProgressHUD.showError("删除失败")
        }).disposed(by:rx_disposeBag)
    }

}
extension CarViewModel{
    ///计算每组商品小计和总价
    private func setSumPriceArrModel(arr:[CarModel]) -> [CarModel]{
        ///所有选中商品总价
        var sumPrice="0"
        if arr.count == 0{
            sumPriceBR.accept(sumPrice)
            return []
            
        }else{
            for carModel in arr{
                //每组选中商品价格
                var sumSectionPrice="0"
                for i in 0..<carModel.listGoods!.count{
                    let goodModel=carModel.listGoods![i]
                    ///每个商品总价格
                    var goodSumPrice="0"
                    if goodModel.isSelected == 1{//只统计选中的商品
                        if goodModel.flag == 1{//如果是特价
                            goodSumPrice=PriceComputationsUtil.decimalNumberWithString(multiplierValue: "\(goodModel.carNumber ?? 0)", multiplicandValue:goodModel.prefertialPrice ?? "0", type:.multiplication, position:2)
                        }else{//普通价格
                            goodSumPrice=PriceComputationsUtil.decimalNumberWithString(multiplierValue: "\(goodModel.carNumber ?? 0)", multiplicandValue:goodModel.uprice ?? "0", type:.multiplication, position:2)
                        }
                    }
                    ///把每个商品相加
                    sumSectionPrice=PriceComputationsUtil.decimalNumberWithString(multiplierValue:sumSectionPrice,multiplicandValue:goodSumPrice, type:.addition, position:2)
                }
                ///把每个小计相加
                sumPrice=PriceComputationsUtil.decimalNumberWithString(multiplierValue:sumPrice,multiplicandValue:sumSectionPrice, type:.addition, position:2)
                carModel.sumPrice=sumSectionPrice
            }
            sumPriceBR.accept(sumPrice)
            return arr
        }
    }
}
