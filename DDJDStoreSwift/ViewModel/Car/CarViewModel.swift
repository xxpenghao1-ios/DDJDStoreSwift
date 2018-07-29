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
    ///更新全选按钮状态  true全选
    var updateAllSelectedStatePS=PublishSubject<Bool>()
    ///刷新数据
    var arrPS=PublishSubject<Bool>()
    ///更新购物车商品数量(页面退出操作)
    var updateCarGoodListPS=PublishSubject<Bool>()
    ///保存购物车数据
    var arr=[CarModel]()

    override init() {
        super.init()
        ///查询购物车商品
        requestNewDataCommond.subscribe(onNext: { [weak self] (_) in
            self?.getCarGoodList()
        }).disposed(by:rx_disposeBag)

        ///更新购物车商品数量(页面退出操作)
        updateCarGoodListPS.subscribe(onNext: { [weak self] (_) in
            self?.updateCarAllGoodsNumForMember()
        }).disposed(by:rx_disposeBag)


    }
}
///网络请求
extension CarViewModel{

    ///获取购物车商品数量
    private func getCarGoodList(){
        PHProgressHUD.show("正在加载...")
        PHRequest.shared.requestJSONArrModel(target:CarAPI.queryShoppingCarNew(memberId:member_Id!, storeId:store_Id!), model:CarModel.self).map({ (arr) -> [CarModel] in
            ///筛选出商品list有值的(万一后台sb返回了个空呢😆)
            let carArr=arr.filter({ (carModel) -> Bool in
                return carModel.listGoods?.count > 0
            })
            ///统一库存  把特价 促销  普通库存统一到goodsStock
            let mapArr=carArr.map({ (carModel) -> CarModel in
                let goodList=carModel.listGoods!.map({ (goodModel) -> GoodDetailModel in
                    if goodModel.flag == 3{//促销
                        goodModel.goodsStock=goodModel.promotionEachCount
                    }else if goodModel.flag == 1{//特价
                        goodModel.goodsStock=goodModel.stock
                    }
                    return goodModel
                })
                carModel.listGoods=goodList
                return carModel
            })
            return mapArr
        }).subscribe(onNext: { [weak self] (arr) in
                self?.arr=arr
                self?.setSumPriceArrModel(arr:arr)
                self?.arrPS.onNext(true)
        }, onError: { [weak self] (error) in
                self?.arr=[]
                self?.arrPS.onNext(true)
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
    func deleteShoppingCar(index:IndexPath?=nil,allDelete:Bool?=false){
        PHProgressHUD.show("正在删除...")
        var goodsList=[GoodDetailModel]()
        if allDelete == true{///如果删除全部
            for carModel in arr{
                if carModel.listGoods?.count > 0{
                    goodsList+=carModel.listGoods!
                }
            }
        }else{///获取单个要删除的商品
            goodsList.append(arr[index!.section].listGoods![index!.row])
        }

        PHRequest.shared.requestJSONObject(target:CarAPI.deleteShoppingCar(memberId:member_Id!, goodsList:goodsList.toJSONString() ?? "")).subscribe(onNext: { [weak self] (result) in
            switch result{
            case let .success(json:json):
                let success=json["success"].stringValue
                if success == "success"{
                    if allDelete == true{///如果删除全部
                        self?.arr.removeAll()
                    }else{
                        ///删除对应商品
                        self?.arr[index!.section].listGoods?.remove(at:index!.row)
                        if self?.arr[index!.section].listGoods?.count == 0{//如果删完了
                            ///删除对应的组
                            self?.arr.remove(at:index!.section)
                        }
                    }
                    ///更新购物车各种状态
                    self?.setSumPriceArrModel(arr:self?.arr ?? [])
                    ///更新购物车数量
                    APP.tab?.updateCarBadgeValue.onNext(true)
                    
                    PHProgressHUD.showSuccess("删除成功")
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
    ///要结算的商品集合
    func settlementGoodArr() -> [GoodDetailModel]{
        var goodArr=[GoodDetailModel]()
        let _=arr.map { (carModel) in
           let _=carModel.listGoods?.map({ (goodModel)in
                if goodModel.isSelected == 1{///选中的
                    if goodModel.goodsStock == -1 || goodModel.goodsStock > 0{///有库存的
                        goodArr.append(goodModel)
                    }
                }
            })
        }
        return goodArr
    }
    ///每组是否选中 section组索引 isSelected=true选中  false未选中
    func sectionIsSelected(section:Int,isSelected:Bool){
        let listGood=arr[section].listGoods!
        ///更新对应每组选中状态
        arr[section].listGoods=listGood.map { (model) -> GoodDetailModel in
            if model.goodsStock == -1 || model.goodsStock > 0{///只更新库存大于0的
                model.isSelected=isSelected == true ? 1:2
            }
            return model
        }
        ///计算每组小计 商品总价  选中状态
        setSumPriceArrModel(arr:arr)
    }

    ///计算每组商品小计和总价
    func setSumPriceArrModel(arr:[CarModel]){
        ///所有选中商品总价
        var sumPrice="0"
        if arr.count == 0{
            ///更新商品总价
            sumPriceBR.accept(sumPrice)
        }else{
            for carModel in arr{
                //每组选中商品价格
                var sumSectionPrice="0"
                for i in 0..<carModel.listGoods!.count{
                    let goodModel=carModel.listGoods![i]
                    ///每个商品总价格
                    var goodSumPrice="0"
                    if goodModel.isSelected == 1{//只统计选中的商品
                        if goodModel.goodsStock == -1 || goodModel.goodsStock > 0{///只统计有库存的商品
                            if goodModel.flag == 1{//如果是特价
                                goodSumPrice=PriceComputationsUtil.decimalNumberWithString(multiplierValue: "\(goodModel.carNumber ?? 0)", multiplicandValue:goodModel.prefertialPrice ?? "0", type:.multiplication, position:2)
                                goodModel.goodsSumMoney=goodSumPrice
                            }else{//普通价格
                                goodSumPrice=PriceComputationsUtil.decimalNumberWithString(multiplierValue: "\(goodModel.carNumber ?? 0)", multiplicandValue:goodModel.uprice ?? "0", type:.multiplication, position:2)
                                goodModel.goodsSumMoney=goodSumPrice
                            }
                        }
                    }
                    ///把每个商品相加
                    sumSectionPrice=PriceComputationsUtil.decimalNumberWithString(multiplierValue:sumSectionPrice,multiplicandValue:goodSumPrice, type:.addition, position:2)
                }
                ///把每个小计相加
                sumPrice=PriceComputationsUtil.decimalNumberWithString(multiplierValue:sumPrice,multiplicandValue:sumSectionPrice, type:.addition, position:2)
                carModel.sumPrice=sumSectionPrice
            }
            ///更新商品总价
            sumPriceBR.accept(sumPrice)
            self.arr=arr
        }
        setAllSelectedState()
    }
    ///计算页面所有的选中状态
    private func setAllSelectedState(){
        for carModel in arr{
            ///返回未选中商品数组
            let uncheckArr=carModel.listGoods!.filter { (model) -> Bool in
                return model.isSelected == 2
            }
            ///未选中商品数组大于0 单组不选中
            carModel.isSelected=uncheckArr.count > 0 ? 2:1
        }
        ///返回未选中组
        let uncheckArr=arr.filter { (model) -> Bool in
            return model.isSelected == 2
        }
        ///未选中组大于0 全选按钮 不选中 否则选中
        updateAllSelectedStatePS.onNext(uncheckArr.count > 0 ? false:true)

        ///刷新页面
        arrPS.onNext(true)
    }

    ///是否全选 
    func allSelected(isSelected:Bool?){
        let carArr=arr.map { (carModel) -> CarModel in
            carModel.isSelected=isSelected == true ? 1:2
            let goodList=carModel.listGoods?.map({ (goodModel) -> GoodDetailModel in
                if goodModel.goodsStock == -1 || goodModel.goodsStock > 0{///只更新库存大于0的
                    goodModel.isSelected=isSelected == true ? 1:2
                }
                return goodModel
            })
            carModel.listGoods=goodList
            return carModel
        }
        self.arr=carArr
        ///计算每组小计 商品总价  选中状态
        setSumPriceArrModel(arr:arr)
    }
}
