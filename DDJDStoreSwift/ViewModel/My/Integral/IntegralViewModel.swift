//
//  IntegralViewModel.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/7/23.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import RxCocoa
import RxDataSources
import RxSwift
///积分vm
class IntegralViewModel:NSObject,OutputRefreshProtocol {

    ///查询总积分 与积分说明
    var requestSumIntegralPS = PublishSubject<Bool>()
    ///总积分
    var sumIntegralBR = BehaviorRelay<Int>(value:0)
    ///积分说明
    var integralExplainBR=BehaviorRelay<String>(value:"")

    ///查询积分商品
    var requestIntegralGoodListPS = PublishSubject<Bool>()
    ///积分商品数据
    var integralGoodListBR=BehaviorRelay<[EmptyDataType:[SectionModel<String,IntegralGoodModel>]]>(value:[.loading:[]])
    ///保存每次请求积分商品
    var integralGoodListArr=[IntegralGoodModel]()

    ///查询积分记录
    var requestIntegralRecordPS = PublishSubject<Bool>()
    //积分记录数据
    var integralRecordBR=BehaviorRelay<[EmptyDataType:[SectionModel<String,IntegralRecordModel>]]>(value:[.loading:[]])
    ///保存积分记录
    var integralRecordArr=[IntegralRecordModel]()

    ///查询兑换记录
    var requestExchangeRecordPS = PublishSubject<Bool>()

    ///积分兑换
    var integralExchangePS = PublishSubject<IntegralGoodModel>()
    ///积分兑换结果 兑换成功 返回兑换的model
    var integralExchangeSuccessPS = PublishSubject<IntegralGoodModel>()

    ///刷新状态
    var refreshStatus = BehaviorRelay<PHRefreshStatus>(value:.none)

    ///分页查询第几页 默认1
    private var currentPage=1

    ///10条数据
    private var pageSize=10

    override init() {
        super.init()

        ///查询总积分
        requestSumIntegralPS.subscribe(onNext: { [weak self] (b) in
            if b{
                self?.requestSumIntegral()
            }
        }).disposed(by:rx_disposeBag)

        ///查询积分商品
        requestIntegralGoodListPS.subscribe(onNext: { [weak self] (b) in
            if  b{
                self?.currentPage=1
                self?.requestIntegralGoodList(b:b)
            }else{
                self?.currentPage+=1
                self?.requestIntegralGoodList(b:b)
            }
        }).disposed(by:rx_disposeBag)

        ///兑换积分商品
        integralExchangePS.subscribe(onNext: { [weak self] (model) in
            self?.integralExchange(model:model)
        }).disposed(by:rx_disposeBag)

        ///查询积分记录
        requestIntegralRecordPS.subscribe(onNext: { [weak self] (b) in
            if  b{
                self?.currentPage=1
                self?.requestIntegralRecordList(b:b)
            }else{
                self?.currentPage+=1
                self?.requestIntegralRecordList(b:b)
            }
        }).disposed(by:rx_disposeBag)
    }

}

extension IntegralViewModel{
    ///查询总积分
    private func requestSumIntegral(){
        PHRequest.shared.requestJSONObject(target:MyAPI.queryMemberIntegral(memberId:member_Id!)).debug().subscribe(onNext: { [weak self] (result) in
            switch result{
            case let .success(json:json):
                let integral=json["success"].intValue
                let integralExplain=json["DDBInstructions"].stringValue
                self?.sumIntegralBR.accept(integral)
                self?.integralExplainBR.accept(integralExplain)
                break
            default:break
            }
        }, onError: { (error) in
            phLog("获取会员积分失败")
        }).disposed(by:rx_disposeBag)
    }

    ///查询积分商品
    private func requestIntegralGoodList(b:Bool){

        weak var weakSelf=self
        if weakSelf == nil{
            return
        }

        PHRequest.shared.requestJSONArrModel(target:MyAPI.queryIntegralMallForSubStation(subStationId:substation_Id!, currentPage:currentPage, pageSize:pageSize), model:IntegralGoodModel.self).debug().subscribe(onNext: { (arr) in
            if b == true{///刷新
                ///每次获取最新的数据
                weakSelf!.integralGoodListArr=arr
                weakSelf!.integralGoodListBR.accept([.noData:[SectionModel.init(model:"",items:weakSelf!.integralGoodListArr)]])


            }else{//加载更多
                ///追加数据
                weakSelf!.integralGoodListArr+=arr
                weakSelf!.integralGoodListBR.accept([.noData:[SectionModel.init(model:"",items:weakSelf!.integralGoodListArr)]])
            }
            weakSelf!.refreshStatus.accept(.endHeaderRefresh)
            weakSelf!.refreshStatus.accept(.endFooterRefresh)
            if arr.count < weakSelf!.pageSize{//如果下面没有数据了
                weakSelf!.refreshStatus.accept(.noMoreData)
            }
        }, onError: { (error) in
            weakSelf!.refreshStatus.accept(.endHeaderRefresh)
            weakSelf!.refreshStatus.accept(.endFooterRefresh)
            ///把页索引-1
            if weakSelf!.currentPage > 1{
                weakSelf!.currentPage-=1
            }else{ ///如果是第一页 表示第一次加载出错了  隐藏加载更多
                weakSelf!.refreshStatus.accept(.noMoreData)
                ///获取数据出错 空页面提示
                weakSelf!.integralGoodListBR.accept([.dataError:[SectionModel.init(model:"",items:weakSelf!.integralGoodListArr)]])
            }
            phLog("获取会员积分商品失败")
        }).disposed(by:rx_disposeBag)
    }

    ///积分兑换
    private func integralExchange(model:IntegralGoodModel){
        PHProgressHUD.showLoading("请稍后...")
        PHRequest.shared.requestJSONObject(target:MyAPI.integralMallExchange(integralMallId:model.integralMallId ?? 0,memberId:member_Id!,exchangeCount:1)).debug().subscribe(onNext: { [weak self] (result) in
            switch result{
            case let .success(json:json):
                let success=json["success"].stringValue
                switch success{
                case "success":
                    let megInfo=json["megInfo"].stringValue
                    if megInfo == "0"{
                        ///抛出结果
                        self?.integralExchangeSuccessPS.onNext(model)
                        ///重新查询总积分
                        self?.requestSumIntegralPS.onNext(true)
                    }else if megInfo == "1"{
                        PHProgressHUD.showInfo("兑换失败")
                    }else if megInfo == "2"{
                        PHProgressHUD.showInfo("商品数量不足")
                    }else if megInfo == "3"{
                        PHProgressHUD.showInfo("点单币余额不足")
                    }
                    break
                case "memberBalance":
                    PHProgressHUD.showInfo("点单币余额不足")
                    break
                case "memberNull":
                    PHProgressHUD.showInfo("会员不存在")
                    break
                case "goodsNotEnough":
                    PHProgressHUD.showInfo("商品数量不足")
                    break
                case "goodsNull":
                    PHProgressHUD.showInfo("商品已经下架,不能兑换")
                    break
                case "integralMallIdNull":
                    PHProgressHUD.showInfo("点单币商城商品已经不存在了")
                    break
                default:
                    PHProgressHUD.showInfo("发生未知错误")
                    break
                }
                break
            default:
                PHProgressHUD.showError("兑换失败")
                break
            }
        }, onError: { (error) in
            phLog("兑换积分商品失败")
        }).disposed(by:rx_disposeBag)
    }

    ///查询积分记录
    private func requestIntegralRecordList(b:Bool){
        weak var weakSelf=self
        if weakSelf == nil{
            return
        }
        PHRequest.shared.requestJSONArrModel(target:MyAPI.storeQueryMemberIntegralV1(memberId:member_Id!, currentPage: currentPage, pageSize: pageSize), model:IntegralRecordModel.self).subscribe(onNext: { (arr) in
            if b == true{///刷新
                ///每次获取最新的数据
                weakSelf!.integralRecordArr=arr
                weakSelf!.integralRecordBR.accept([.noData:[SectionModel.init(model:"",items:weakSelf!.integralRecordArr)]])


            }else{//加载更多
                ///追加数据
                weakSelf!.integralRecordArr+=arr
                weakSelf!.integralRecordBR.accept([.noData:[SectionModel.init(model:"",items:weakSelf!.integralRecordArr)]])
            }
            weakSelf!.refreshStatus.accept(.endHeaderRefresh)
            weakSelf!.refreshStatus.accept(.endFooterRefresh)
            if arr.count < weakSelf!.pageSize{//如果下面没有数据了
                weakSelf!.refreshStatus.accept(.noMoreData)
            }
        }, onError: { (error) in
            weakSelf!.refreshStatus.accept(.endHeaderRefresh)
            weakSelf!.refreshStatus.accept(.endFooterRefresh)
            ///把页索引-1
            if weakSelf!.currentPage > 1{
                weakSelf!.currentPage-=1
            }else{ ///如果是第一页 表示第一次加载出错了  隐藏加载更多
                weakSelf!.refreshStatus.accept(.noMoreData)
                ///获取数据出错 空页面提示
                weakSelf!.integralRecordBR.accept([.dataError:[SectionModel.init(model:"",items:weakSelf!.integralRecordArr)]])
            }
            phLog("获取积分记录出错")
        }).disposed(by:rx_disposeBag)
    }
}
