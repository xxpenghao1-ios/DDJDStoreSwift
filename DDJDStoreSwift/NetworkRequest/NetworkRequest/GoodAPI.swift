//
//  GoodAPI.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/7/7.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import Moya
///商品相关
public enum GoodAPI{
    ///查询出便利店app首页展示的商品(新品推荐)
    case queryGoodsForAndroidIndexForStoreNew(storeId:String,pageSize:Int,currentPage:Int)
    ///店铺特价商品   order排序方式 不传默认根据后台设置的排序号排序；count 根据商品销量倒序排序；price 根据商品价格升序排序；new 根据特价商品开始时间倒序排序
    case queryPreferentialAndGoods4Store(storeId:String,pageSize:Int,currentPage:Int,order:String?)
    ///店铺促销商品  order默认根据促销商品的排序号排序 ;count 根据销量倒序排序； price 根据价格倒序排序 ；new 根据商品在商品库上架时间倒序排序
    case queryStorePromotionGoodsList(storeId:String,pageSize:Int,currentPage:Int,order:String?)
    ///商品三级分类ID与店铺ID查询商品
    ///priceScreen  根据价格筛选；查询N元以下的；如果此值不为空， goodsCategoryId 商品分类ID应该为一级分类ID
    ///order  不传默认根据销量倒序排序； count 根据销量排序；price 根据价格排序 ；new 根据商品上架时间排序 ；letter 根据字母排序； seachLetter 根据字母搜索
    ///tag  1 是从低到高； 2是从高到低； 比如 order = count ，tag = 2，那么表明是根据销量从高到底排序；
    /// order = seachLetter 根据字母搜索时，必须传 搜索的字母；
    /// seachLetterValue  搜索的字母
    case queryGoodsInfoByCategoryForAndroidForStore(pageSize:Int,currentPage:Int,goodsCategoryId:Int,storeId:String,priceScreen:Int?,order:String,tag:Int,seachLetterValue:String?)

    ///商品详情请求
    case queryGoodsDetailsForAndroid(goodsbasicinfoId:Int,supplierId:Int,flag:Int?,storeId:String,aaaa:Int,subSupplier:Int,memberId:String,promotionFlag:Int?)
    //加入收藏
    case goodsAddCollection(goodId:Int,supplierId:Int,subSupplierId:Int,memberId:String)
    ///取消收藏
    case goodsCancelCollection(memberId:String,goodId:Int)
    //购物车中查询配送商的更多商品（凑单）
    case queryShoppingCarMoreGoodsForSubSupplier(storeId:String,subSupplierId:Int,pageSize:Int,currentPage:Int,order:String,seachLetterValue:String?,tag:Int)
    ///根据商品名称/品牌搜索商品
    case searchGoodsInterfaceForStore(pageSize:Int,currentPage:Int,searchCondition:String,isDisplayFlag:Int,storeId:String,order:String,tag:Int,goodsCategoryId:Int?)
    ///查询收藏商品
    case queryStoreCollectionList(memberId:String,pageSize:Int,currentPage:Int)
    ///购买记录
    case queryStorePurchaseRecord(memberId:String,pageSize:Int,currentPage:Int)
}
extension GoodAPI:TargetType{
    public var path: String {
        switch self {
        case .queryGoodsForAndroidIndexForStoreNew(_,_,_):
            return "queryGoodsForAndroidIndexForStoreNew.xhtml"
        case .queryPreferentialAndGoods4Store(_,_,_,_):
            return "queryPreferentialAndGoods4Store.xhtml"
        case .queryStorePromotionGoodsList(_,_,_,_):
            return "queryStorePromotionGoodsList.xhtml"
        case .queryGoodsInfoByCategoryForAndroidForStore(_,_,_,_,_,_,_,_):
            return "queryGoodsInfoByCategoryForAndroidForStore.xhtml"
        case .queryGoodsDetailsForAndroid(_,_,_,_,_,_,_,_):
            return "queryGoodsDetailsForAndroid.xhtml"
        case .goodsAddCollection(_,_,_,_):
            return "goodsAddCollection.sc"
        case .goodsCancelCollection(_,_):
            return "goodsCancelCollection.sc"
        case .queryShoppingCarMoreGoodsForSubSupplier(_,_,_,_,_,_,_):
            return "queryShoppingCarMoreGoodsForSubSupplier.xhtml"
        case .searchGoodsInterfaceForStore(_,_,_,_,_,_,_,_):
            return "searchGoodsInterfaceForStore.xhtml"
        case .queryStoreCollectionList(_,_,_):
            return "queryStoreCollectionList.sc"
        case .queryStorePurchaseRecord(_,_,_):
            return "queryStorePurchaseRecord.sc"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .queryGoodsForAndroidIndexForStoreNew(_,_,_),.queryPreferentialAndGoods4Store(_,_,_,_),.queryStorePromotionGoodsList(_,_,_,_),.queryGoodsInfoByCategoryForAndroidForStore(_,_,_,_,_,_,_,_),.queryGoodsDetailsForAndroid(_,_,_,_,_,_,_,_),.goodsAddCollection(_,_,_,_),.queryShoppingCarMoreGoodsForSubSupplier(_,_,_,_,_,_,_),.queryStorePurchaseRecord(_,_,_):
            return .get
        case .searchGoodsInterfaceForStore(_,_,_,_,_,_,_,_),.goodsCancelCollection(_,_),.queryStoreCollectionList(_,_,_):
            return .post
        }
    }

    public var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }

    public var task: Task {
        switch self {
        case let .queryGoodsForAndroidIndexForStoreNew(storeId, pageSize, currentPage):
            return .requestParameters(parameters:["storeId":storeId,"pageSize":pageSize,"currentPage":currentPage], encoding:URLEncoding.default)
        case .queryPreferentialAndGoods4Store(let storeId, let pageSize, let currentPage, let order):
            return .requestParameters(parameters:["storeId":storeId,"pageSize":pageSize,"currentPage":currentPage,"order":order ?? "count"], encoding: URLEncoding.default)
        case .queryStorePromotionGoodsList(let storeId, let pageSize, let currentPage, let order):
            return .requestParameters(parameters:["storeId":storeId,"pageSize":pageSize,"currentPage":currentPage,"order":order ?? "count"], encoding: URLEncoding.default)
        case let .queryGoodsInfoByCategoryForAndroidForStore(pageSize,currentPage,goodsCategoryId,storeId, priceScreen,order,tag,seachLetterValue):
            if priceScreen != nil{
                return .requestParameters(parameters:["pageSize":pageSize,"currentPage":currentPage,"goodsCategoryId":goodsCategoryId,"storeId":storeId,"priceScreen":priceScreen!,"order":order,"tag":tag,"seachLetterValue":seachLetterValue ?? ""], encoding: URLEncoding.default)
            }else{
                return .requestParameters(parameters:["pageSize":pageSize,"currentPage":currentPage,"goodsCategoryId":goodsCategoryId,"storeId":storeId,"order":order,"tag":tag,"seachLetterValue":seachLetterValue ?? ""], encoding: URLEncoding.default)
            }
        case let .queryGoodsDetailsForAndroid(goodsbasicinfoId, supplierId, flag, storeId, aaaa, subSupplier, memberId, promotionFlag):
            if flag != nil{//查询特价商品详情
                return .requestParameters(parameters:["goodsbasicinfoId":goodsbasicinfoId,"supplierId":supplierId,"flag":flag!,"storeId":storeId,"aaaa":aaaa,"subSupplier":subSupplier,"memberId":memberId], encoding:  URLEncoding.default)
            }else if promotionFlag != nil{
                return .requestParameters(parameters:["goodsbasicinfoId":goodsbasicinfoId,"supplierId":supplierId,"storeId":storeId,"aaaa":aaaa,"subSupplier":subSupplier,"memberId":memberId,"promotionFlag":promotionFlag!], encoding:  URLEncoding.default)
            }else if promotionFlag == nil && flag == nil{
                return .requestParameters(parameters:["goodsbasicinfoId":goodsbasicinfoId,"supplierId":supplierId,"storeId":storeId,"aaaa":aaaa,"subSupplier":subSupplier,"memberId":memberId], encoding:  URLEncoding.default)
            }else{
                return .requestPlain
            }
        case let .goodsAddCollection(goodId, supplierId, subSupplierId, memberId):
            return .requestParameters(parameters:["goodId":goodId,"supplierId":supplierId,"subSupplierId":subSupplierId,"memberId":memberId], encoding:  URLEncoding.default)
        case let .goodsCancelCollection(memberId, goodId):
            return .requestParameters(parameters:["memberId":memberId,"goodId":goodId], encoding:  URLEncoding.default)
        case let .queryShoppingCarMoreGoodsForSubSupplier(storeId, subSupplierId, pageSize, currentPage, order,seachLetterValue,tag):
            if order == "count" || order == "price"{
                return .requestParameters(parameters:["storeId":storeId,"subSupplierId":subSupplierId,"pageSize":pageSize,"currentPage":currentPage,"order":order,"tag":tag], encoding:  URLEncoding.default)
            }else if order == "letter"{
                return .requestParameters(parameters:["storeId":storeId,"subSupplierId":subSupplierId,"pageSize":pageSize,"currentPage":currentPage,"order":order], encoding:  URLEncoding.default)
            }else if order == "seachLetter"{
                return .requestParameters(parameters:["storeId":storeId,"subSupplierId":subSupplierId,"pageSize":pageSize,"currentPage":currentPage,"order":order,"seachLetterValue":seachLetterValue ?? ""], encoding:  URLEncoding.default)
            }else{
                return .requestPlain
            }
        case let .searchGoodsInterfaceForStore(pageSize,currentPage,searchCondition, isDisplayFlag, storeId, order, tag,goodsCategoryId):
            if goodsCategoryId == nil{
                return .requestParameters(parameters:["pageSize":pageSize,"currentPage":currentPage,"searchCondition":searchCondition,"isDisplayFlag":isDisplayFlag,"storeId":storeId,"order":order,"tag":tag], encoding: URLEncoding.default)
            }else{
                return .requestParameters(parameters:["pageSize":pageSize,"currentPage":currentPage,"searchCondition":searchCondition,"isDisplayFlag":isDisplayFlag,"storeId":storeId,"order":order,"tag":tag,"goodsCategoryId":goodsCategoryId!], encoding: URLEncoding.default)
            }
        case let .queryStoreCollectionList(memberId,pageSize,currentPage):
            return .requestParameters(parameters:["memberId":memberId,"pageSize":pageSize,"currentPage":currentPage], encoding: URLEncoding.default)
        case let .queryStorePurchaseRecord(memberId, pageSize, currentPage):
            return .requestParameters(parameters:["memberId":memberId,"pageSize":pageSize,"currentPage":currentPage], encoding: URLEncoding.default)
        }

    }
}
