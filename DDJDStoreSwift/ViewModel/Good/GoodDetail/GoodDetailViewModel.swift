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

    ///加入收藏
    var addCollectionPS=PublishSubject<Bool>()

    ///商品详情flag   1特价，2普通,3促销
    init(model:GoodDetailModel,goodDetailflag:Int) {
        super.init()

        ///查看商品详情
        getGoodDetail(model:model,goodDetailflag:goodDetailflag)

        ///加入收藏
        addCollectionPS.subscribe(onNext: { [weak self](b) in
            if b{
                self?.addCollection()
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
            if goodDetailflag == 1{//特价
                self?.goodDetailOtherTitleArr.insert("该商品正在打特价,不要错过哦", at:0)
                self?.goodDetailOtherTitleArrValue.append(nil)
            }else if goodDetailflag == 3{//促销
                self?.goodDetailOtherTitleArr.insert("促销信息", at:0)
                self?.goodDetailOtherTitleArrValue.append(model.goodsDes)
            }
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
            if model.returnGoodsFlag != nil && model.returnGoodsFlag != 3{
                self?.goodDetailOtherTitleArr.append("是否可退")
                if model.returnGoodsFlag == 1{
                    self?.goodDetailOtherTitleArrValue.append("该商品可退换")
                }else{
                    self?.goodDetailOtherTitleArrValue.append("该商品不可退换")
                }
            }
            self?.goodDetailBR.accept(model)
        }, onError: { (error) in
            PHProgressHUD.showError("获取商品详情出错")
        }).disposed(by:rx_disposeBag)
    }

    ///加入收藏
    private func addCollection(){
        let model=goodDetailBR.value
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
