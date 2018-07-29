//
//  GoodListViewModel.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/7/13.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import RxCocoa
import RxDataSources
import RxSwift
///普通商品列表
class GoodListViewModel:NSObject,OutputRefreshProtocol{

    ///商品数据
    var goodArrModelBR=BehaviorRelay<[EmptyDataType:[SectionModel<String,GoodDetailModel>]]>(value:[.loading:[]])

    ///保存商品数据
    var goodArrModel=[GoodDetailModel]()
 
    ///发送网络请求(true)刷新数据 false加载下一页
    var requestNewDataCommond = PublishSubject<Bool>()

    ///刷新状态
    var refreshStatus = BehaviorRelay<PHRefreshStatus>(value:.none)

    ///order  不传默认根据销量倒序排序； count 根据销量排序；price 根据价格排序 ；new 根据商品上架时间排序 ；letter 根据字母排序；  默认销量
    var order="count"

    ///tag  1 是从低到高； 2是从高到低； 比如 order = count ，tag = 2，那么表明是根据销量从高到底排序；  默认是从高到低
    var tag=2

    ///按字母排序  默认nil
    var seachLetter:String?

    /// 索引组
    var  indexSet=["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]

    ///默认加载第一页
    private var currentPage=1

    ///每页加载10条
    private var pageSize=10

    /// 接收传入的状态 1表示搜索 2表示查询3级分类商品列表  3查询1元区商品 4查询配送商商品列表
    init(flag:Int,goodsCategoryId:Int?,subSupplierId:Int?,searchCondition:String?) {
        super.init()
        requestNewDataCommond
            .startWith(true)//默认刷新数据加载
            .subscribe(onNext: { [weak self] (b) in
                if b {//重新加载数据
                    self?.currentPage=1
                    self?.request(b:b, flag:flag,goodsCategoryId:goodsCategoryId, subSupplierId: subSupplierId, searchCondition: searchCondition)
                }else{///加载下一页
                    self?.currentPage+=1
                    self?.request(b:b,flag:flag,goodsCategoryId:goodsCategoryId, subSupplierId: subSupplierId, searchCondition: searchCondition)
                }
            }).disposed(by:rx_disposeBag)
    }
    ///网络请求
    private func request(b:Bool,flag:Int,goodsCategoryId:Int?,subSupplierId:Int?,searchCondition:String?){
        if flag == 1{///搜索商品
            searchGoodsInterfaceForStore(b:b,searchCondition:searchCondition ?? "" , order:order, tag:tag)
        }else if flag == 2{//查询3级分类列表
            getGoodsInfoByCategoryForAndroidForStore(b:b, goodsCategoryId:goodsCategoryId ?? 0, seachLetterValue:seachLetter,order:order,tag:tag)
        }else if flag == 3{///查询休闲零食1元区
            getGoodsInfoByCategoryForAndroidForStore(b:b, goodsCategoryId:goodsCategoryId ?? 0, seachLetterValue:seachLetter,order:order,tag:tag,priceScreen:1)
        }else if flag == 4{//查询配送商商品列表
            getSubSupplierGoodList(b:b, subSupplierId:subSupplierId, order: order, tag: tag, seachLetterValue:seachLetter)
        }
    }
}
///网络请求
extension GoodListViewModel{

    ///根据3级分类id查询
    ///priceScreen  根据价格筛选；查询N元以下的；如果此值不为空， goodsCategoryId 商品分类ID应该为一级分类ID
    ///order  不传默认根据销量倒序排序； count 根据销量排序；price 根据价格排序 ；new 根据商品上架时间排序 ；letter 根据字母排序； seachLetter 根据字母搜索
    ///tag  1 是从低到高； 2是从高到低； 比如 order = count ，tag = 2，那么表明是根据销量从高到底排序；
    /// order = seachLetter 根据字母搜索时，必须传 搜索的字母；
    /// seachLetterValue  搜索的字母
    private func getGoodsInfoByCategoryForAndroidForStore(b:Bool,goodsCategoryId:Int,seachLetterValue:String?,order:String,tag:Int,priceScreen:Int?=nil){

        PHRequest.shared.requestJSONArrModel(target:GoodAPI.queryGoodsInfoByCategoryForAndroidForStore(pageSize:pageSize,currentPage:currentPage, goodsCategoryId: goodsCategoryId,storeId: store_Id!, priceScreen:priceScreen,order:order, tag:tag, seachLetterValue:seachLetterValue), model:GoodDetailModel.self).subscribe(onNext: { [weak self] (arr) in
            self?.subscribeResult(b:b, arr:arr)
        }, onError: { [weak self] (error) in
            self?.errorResult()
            phLog("获取商品列表数据出错\(error.localizedDescription)")
        }).disposed(by:rx_disposeBag)
    }
    ///查询配送商所属商品
    private func getSubSupplierGoodList(b:Bool,subSupplierId:Int?,order:String,tag:Int,seachLetterValue:String?){

        PHRequest.shared.requestJSONArrModel(target:GoodAPI.queryShoppingCarMoreGoodsForSubSupplier(storeId:store_Id!,subSupplierId: subSupplierId ?? 0, pageSize:pageSize, currentPage: currentPage, order:order,seachLetterValue: seachLetter, tag:tag), model:GoodDetailModel.self).subscribe(onNext: { [weak self] (arr) in
            self?.subscribeResult(b:b, arr:arr)
        }, onError: { [weak self] (error) in
            self?.errorResult()
            phLog("查询配送商所属商品出错\(error.localizedDescription)")
        }).disposed(by:rx_disposeBag)
    }
    ///根据商品名字或者品牌查询商品的详细信息接口
    private func searchGoodsInterfaceForStore(b:Bool,searchCondition:String,order:String,tag:Int){

        PHRequest.shared.requestJSONArrModel(target:GoodAPI.searchGoodsInterfaceForStore(pageSize:pageSize,currentPage:currentPage,searchCondition:searchCondition, isDisplayFlag: 2, storeId: store_Id!,order:order, tag:tag), model: GoodDetailModel.self).subscribe(onNext: { [weak self] (arr) in
            self?.subscribeResult(b:b, arr:arr)
        }, onError: { [weak self] (error) in
            self?.errorResult()
            phLog("搜索商品出错\(error.localizedDescription)")
        }).disposed(by:rx_disposeBag)
    }
    ///请求结果处理
    private func subscribeResult(b:Bool,arr:[GoodDetailModel]){
        if b == true{///刷新
            ///每次获取最新的数据
            goodArrModel=arr
            goodArrModelBR.accept([.noData:[SectionModel.init(model:"",items:goodArrModel)]])


        }else{//加载更多
            ///追加数据
            goodArrModel+=arr
            goodArrModelBR.accept([.noData:[SectionModel.init(model:"",items:goodArrModel)]])
        }
        refreshStatus.accept(.endHeaderRefresh)
        refreshStatus.accept(.endFooterRefresh)
        if arr.count < pageSize{//如果下面没有数据了
            refreshStatus.accept(.noMoreData)
        }
    }

    ///错误结果处理
    private func errorResult(){
        refreshStatus.accept(.endHeaderRefresh)
        refreshStatus.accept(.endFooterRefresh)
        ///把页索引-1
        if currentPage > 1{
            currentPage-=1
        }else{ ///如果是第一页 表示第一次加载出错了  隐藏加载更多
            refreshStatus.accept(.noMoreData)
            ///获取数据出错 空页面提示
            goodArrModelBR.accept([.dataError:[SectionModel.init(model:"",items:goodArrModel)]])
        }
    }
}

