//
//  MessageViewModel.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/7/4.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxDataSources
///消息VM
class MessageViewModel:NSObject,OutputRefreshProtocol{

    ///保存消息数据
    var messageArrBR=BehaviorRelay<[SectionModel<String,MessageModel>]>(value:[])

    ///保存消息数据
    var messageArr=[MessageModel]()

    ///发送网络请求(true)刷新数据 false加载下一页
    var requestNewDataCommond = PublishSubject<Bool>()

    ///默认加载第一页
    private var currentPage=1

    ///每页加载10条
    private var pageSize=10

    ///刷新状态
    var refreshStatus = BehaviorRelay<PHRefreshStatus>(value:.none)
    
    override init() {
        super.init()

        requestNewDataCommond
            .startWith(true)//默认刷新数据加载
            .subscribe(onNext: { [weak self] (b) in
                if b {//重新加载数据
                    self?.currentPage=1
                    self?.getMessageToStore(b:b)
                }else{///加载热门商品下一页
                    self?.currentPage+=1
                    self?.getMessageToStore(b:b)
                }
            }).disposed(by:rx_disposeBag)
    }

    ///获取消息信息
    private func getMessageToStore(b:Bool?){
        weak var weakSelf=self
        if weakSelf == nil{
            return
        }
        PHRequest.shared.requestJSONArrModel(target:MyAPI.queryMessageToStore(substationId:substationId!, pageSize:pageSize, currentPage:currentPage), model: MessageModel.self).subscribe(onNext: { (arrModel) in
            if b == true{///刷新
                ///每次获取最新的数据
                weakSelf!.messageArr=arrModel
                weakSelf!.messageArrBR.accept([SectionModel.init(model:"",items:weakSelf!.messageArr)])

            }else{//加载更多
                ///追加数据
                weakSelf!.messageArr+=arrModel
                weakSelf!.messageArrBR.accept([SectionModel.init(model:"",items:weakSelf!.messageArr)])
            }
            weakSelf!.refreshStatus.accept(.endHeaderRefresh)
            weakSelf!.refreshStatus.accept(.endFooterRefresh)
            if arrModel.count < weakSelf!.pageSize{//如果下面没有数据了
                weakSelf!.refreshStatus.accept(.noMoreData)
            }
        }, onError: { (error) in
            ///把页索引-1
            weakSelf!.currentPage-=1
            phLog("获取消息信息发送错误:\(error.localizedDescription)")
            weakSelf!.refreshStatus.accept(.endHeaderRefresh)
            weakSelf!.refreshStatus.accept(.endFooterRefresh)
        }).disposed(by:rx_disposeBag)
    }
}
