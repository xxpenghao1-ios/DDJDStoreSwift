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

    ///商品详情flag   1特价，2普通,3促销
    init(model:GoodDetailModel,goodDetailflag:Int) {
        super.init()

        getGoodDetail(model:model,goodDetailflag:goodDetailflag)
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
        ///flag不为空查特价商品 promotionFlag不为空查促销商品  都为空查普通商品
        PHRequest.shared.requestJSONModel(target:GoodAPI.queryGoodsDetailsForAndroid(goodsbasicinfoId:model.goodsbasicinfoId ?? 0, supplierId: model.supplierId ?? 0,flag:flag, storeId:store_Id!, aaaa: 11, subSupplier:model.subSupplier ?? 0, memberId:member_Id!, promotionFlag:promotionFlag), model:GoodDetailModel.self).subscribe(onNext: { [weak self] (model) in
            self?.goodDetailOtherTitleArrValue.append("\(model.goodsStock ?? 0)")
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
        PHRequest.shared.requestJSONObject(target:CarAPI.insertShoppingCar(memberId:member_Id!, goodId:model.goodsbasicinfoId ?? 0, supplierId: model.supplierId ?? 0, subSupplierId:model.subSupplier ?? 0,goodsCount: goodsCount,flag:2, goodsStock:model.goodsStock ?? 0, storeId:store_Id!, promotionNumber:nil))
    }
}
