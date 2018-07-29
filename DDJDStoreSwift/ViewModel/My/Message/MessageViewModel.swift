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
    var messageArrBR=BehaviorRelay<[EmptyDataType:[SectionModel<String,MessageModel>]]>(value:[.loading:[]])

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
                }else{///加载下一页
                    self?.currentPage+=1
                    self?.getMessageToStore(b:b)
                }
            }).disposed(by:rx_disposeBag)
    }

    ///获取消息信息
    private func getMessageToStore(b:Bool){
        PHRequest.shared.requestJSONArrModel(target:MyAPI.queryMessageToStore(substationId:substation_Id!, pageSize:pageSize, currentPage:currentPage), model: MessageModel.self).subscribe(onNext: { [weak self] (arrModel) in
            self?.subscribeResult(b:b,arr:arrModel)
        }, onError: { [weak self] (error) in
            self?.errorResult()
            phLog("获取消息信息发送错误:\(error.localizedDescription)")
        }).disposed(by:rx_disposeBag)
    }

    ///请求结果
    private func subscribeResult(b:Bool,arr:[MessageModel]){
        if b == true{///刷新
            ///每次获取最新的数据
            messageArr=arr
            messageArrBR.accept([.noData:[SectionModel.init(model:"",items:messageArr)]])

        }else{//加载更多
            ///追加数据
            messageArr+=arr
            messageArrBR.accept([.noData:[SectionModel.init(model:"",items:messageArr)]])
        }
        refreshStatus.accept(.endHeaderRefresh)
        refreshStatus.accept(.endFooterRefresh)
        if arr.count < pageSize{//如果下面没有数据了
            refreshStatus.accept(.noMoreData)
        }
    }

    ///错误结果
    private func errorResult(){
        refreshStatus.accept(.endHeaderRefresh)
        refreshStatus.accept(.endFooterRefresh)
        ///把页索引-1
        if currentPage > 1{
            currentPage-=1
        }else{ ///如果是第一页 表示第一次加载出错了  隐藏加载更多
            refreshStatus.accept(.noMoreData)
            ///获取数据出错 空页面提示
            messageArrBR.accept([.dataError:[SectionModel.init(model:"",items:[])]])
        }
    }

}
