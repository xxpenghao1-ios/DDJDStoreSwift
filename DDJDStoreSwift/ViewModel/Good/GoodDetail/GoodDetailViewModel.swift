//
//  GoodDetailViewModel.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/7/9.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxDataSources
///商品详情vm
class GoodDetailViewModel:NSObject{

    ///保存订单详情
    var goodDetailBR=BehaviorRelay<GoodDetailModel>(value:GoodDetailModel())

    ///商品其他信息title
    var goodDetailOtherTitleArr=["库存","最低起订量","每次商品加减数量","配送商","条码","保质期"]

    ///商品其他信息titleValue
    var goodDetailOtherTitleArrValue=[String?]()

    ///加入购物车
    var addCarPS=PublishSubject<Int>()

    ///更新购物车item数量
    var updateCarItemCountBR=BehaviorRelay<Int>(value:0)

    ///加入收藏
    var addCollectionPS=PublishSubject<Bool>()

    ///商品详情flag   1特价，2普通,3促销
    init(model:GoodDetailModel,goodDetailflag:Int) {
        super.init()

        ///查看商品详情
        getGoodDetail(model:model,goodDetailflag:goodDetailflag)

        ///加入购物车
        addCarPS.subscribe(onNext: { [weak self] (goodCount) in
            self?.addCar(model:model,goodsCount:goodCount)
        }).disposed(by:rx_disposeBag)

        ///加入收藏
        addCollectionPS.subscribe(onNext: { [weak self](b) in
            if b{
                self?.addCollection(model:model)
            }
        }).disposed(by:rx_disposeBag)
    }


}
extension GoodDetailViewModel{
    ///查询商品详情
    private func getGoodDetail(model:GoodDetailModel,goodDetailflag:Int){
        ///是否是特价
        var flag:Int?=nil
        ///是否为促销
        var promotionFlag:Int?=nil
        if goodDetailflag == 1{//特价
            flag=1
        }else if goodDetailflag == 3{//促销
            promotionFlag=1
        }
        PHProgressHUD.showLoading("正在努力加载中")
        ///flag不为空查特价商品 promotionFlag不为空查促销商品  都为空查普通商品
        PHRequest.shared.requestJSONModel(target:GoodAPI.queryGoodsDetailsForAndroid(goodsbasicinfoId:model.goodsbasicinfoId ?? 0, supplierId: model.supplierId ?? 0,flag:flag, storeId:store_Id!, aaaa: 11, subSupplier:model.subSupplier ?? 0, memberId:member_Id!, promotionFlag:promotionFlag), model:GoodDetailModel.self).subscribe(onNext: { [weak self] (model) in
            if model.goodsStock == -1{
                self?.goodDetailOtherTitleArrValue.append("库存充足")
            }else{
                self?.goodDetailOtherTitleArrValue.append("\(model.goodsStock ?? 0)")
            }
            self?.goodDetailOtherTitleArrValue.append("\(model.miniCount ?? 1)")
            self?.goodDetailOtherTitleArrValue.append("\(model.goodsBaseCount ?? 1)")
            self?.goodDetailOtherTitleArrValue.append(model.supplierName)
            self?.goodDetailOtherTitleArrValue.append(model.goodInfoCode)
            self?.goodDetailOtherTitleArrValue.append(model.goodLife)
            self?.goodDetailBR.accept(model)
        }, onError: { (error) in
            phLog("获取商品详情数据出错\(error.localizedDescription)")
        }).disposed(by:rx_disposeBag)
    }

    ///加入购物车
    private func addCar(model:GoodDetailModel,goodsCount:Int){
        PHProgressHUD.show("正在加入")
        PHRequest.shared.requestJSONObject(target:CarAPI.insertShoppingCar(memberId:member_Id!, goodId:model.goodsbasicinfoId ?? 0, supplierId: model.supplierId ?? 0, subSupplierId:model.subSupplier ?? 0,goodsCount: goodsCount,flag:2, goodsStock:model.goodsStock ?? 0, storeId:store_Id!,promotionNumber:nil)).subscribe(onNext: { [weak self] (result) in
            switch result{
            case let .success(json:json):
                let success=json["success"].stringValue
                if success == "success"{
                    let count=json["shoppingCount"].intValue
                    ///更新跳转购物车按钮数量
                    self?.updateCarItemCountBR.accept(count)
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
    ///加入收藏
    private func addCollection(model:GoodDetailModel){
        PHProgressHUD.show("正在加载")
        PHRequest.shared.requestJSONObject(target:GoodAPI.goodsAddCollection(goodId:model.goodsbasicinfoId ?? 0, supplierId: model.supplierId ?? 0, subSupplierId:model.subSupplier ?? 0, memberId:member_Id!)).subscribe(onNext: { [weak self] (result) in
            switch result{
            case let .success(json:json):
                let success=json["success"].stringValue
                if success == "success"{
                    PHProgressHUD.showSuccess("成功加入收藏")
                    model.goodsCollectionStatu=1
                }else{
                    PHProgressHUD.showError("收藏失败")
                    model.goodsCollectionStatu=2
                }
                self?.goodDetailBR.accept(model)
                break
            default:break
            }
        }).disposed(by:rx_disposeBag)
    }
}
