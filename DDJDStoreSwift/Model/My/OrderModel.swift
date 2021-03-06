//
//  OrderModel.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/7/5.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import ObjectMapper
/**订单信息*/
struct OrderModel:Mappable{
    /** 出货编号 **/
    var out_trade_sn:String?;
    /**当前登录者的Id **/
    var buyerId:Int?;
    /** 卖家Id**/
    var sellerId:Int?;
    /**订单总价**/
    var orderPrice:String?;
    /**订单id **/
    var orderinfoId:Int?;
    /** 买家电话**/
    var phone_tel:String?;
    /**1-可以抢单，2已经被抢单，3开始送货  4已完成**/
    var robflag:Int?;
    /** 收货地址**/
    var address:String?;
    /** 订单编号**/
    var orderSN:String?;
    /** 1-未发货，2已发货，3-已经完成**/
    var orderStatus:Int?;
    /** 订单类型1-店铺对供应商 2-用户对店铺 **/
    var orderType:Int?;
    /**评价状态 1-未评价2-已评价 **/
    var evaluation_status:Int?;
    /**买家用户名 **/
    var buyName:String?;
    /**列表商品集合**/
    var list:[OrderGoodModel]?;
    ///详情商品集合
    var listAndroid:[OrderGoodModel]?
    /** 下单时间 **/
    var add_time:String?;
    /**店铺名称**/
    var sellerName:String?;
    var storeName:String?;
    /** 商品数量 **/
    var goods_amount:String?;
    /**买家留言**/
    var pay_message:String?;
    /**用户加价价钱*/
    var additionalMoney:String?;
    /**供应商名称*/
    var supplierName:String?;
    ///发货时间
    var ship_time:String?
    /**完成时间*/
    var finished_time:String?;
    /**卖家附言*/
    var postscript:String?;
    ///商品是否可退；1可退；2不可退
    var returnGoodsFlag:Int?
    /**代金券金额*/
    var cashCouponAmountOfMoney:Double?
    /*代金券id*/
    var cashCouponId:Int?
    init(){}
    init?(map: Map) {

    }
    mutating func mapping(map:Map){
        out_trade_sn <- map["out_trade_sn"]
        buyerId <- map["buyerId"]
        sellerId <- map["sellerId"]
        orderPrice <- map["orderPrice"]
        orderinfoId <- map["orderinfoId"]
        phone_tel <- map["phone_tel"]
        robflag <- map["robflag"]
        address <- map["address"]
        orderSN <- map["orderSN"]
        orderStatus <- map["orderStatus"]
        orderType <- map["orderType"]
        evaluation_status <- map["evaluation_status"]
        buyName <- map["buyName"]
        list <- map["list"]
        listAndroid <- map["listAndroid"]
        add_time <- map["add_time"]
        sellerName <- map["sellerName"]
        storeName <- map["storeName"]
        goods_amount <- map["goods_amount"]
        pay_message <- map["pay_message"]
        additionalMoney <- map["additionalMoney"]
        supplierName <- map["supplierName"]
        ship_time <- map["ship_time"]
        finished_time <- map["finished_time"]
        postscript <- map["postscript"]
        returnGoodsFlag <- map["returnGoodsFlag"]
        cashCouponAmountOfMoney <- map["cashCouponAmountOfMoney"]
        cashCouponId <- map["cashCouponId"]

    }
}
