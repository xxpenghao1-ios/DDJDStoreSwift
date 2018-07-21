//
//  AdvertisingModel.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/6/12.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import ObjectMapper
/// 广告
struct AdvertisingModel:Mappable {
    ///广告ID
    var advertisingId:Int?;
    ///广告名
    var advertisingName:String?
    ///广告描述
    var advertisingDescription:String?;
    ///广告路径
    var advertisingURL:String?;
    ///广告上传时间
    var advertisingUploadTime:String?;
    ///广告的链接路径
    var advertisingLinkURL:Int?;
    ///是否禁用此广告  ，默认1开启。2禁用
    var advertisingDisable:Int?;
    ///默认状态为1，在首页显示。如果将状态改为2，在登录界面显示
    var advertisingFlag:Int?;
    ///mobileOrPc,默认状态为1，在PC显示。如果将状态改为2，在移动端显示,3店铺版首页特价图片，4，消费者版下单转动图片
    var mobileOrPc:Int?
    ///分站Id
    var substationId:Int?
    var isPromotion:Int?
    ///searchStatu（1，不开启；2，开启） ；根据此字段判断是否可以点击搜索； 如果为2可以搜索，调用搜索接口 searchGoodsInterfaceForStore.xhtml 进行搜索； 搜索内容为此接口返回的advertisingDescription字段
    var searchStatu:Int?
    init?(map: Map) {
    }
    mutating func mapping(map: Map) {
        advertisingId <- map["advertisingId"]
        advertisingName <- map["advertisingName"]
        advertisingDescription <- map["advertisingDescription"]
        advertisingURL <- map["advertisingURL"]
        advertisingUploadTime <- map["advertisingUploadTime"]
        advertisingLinkURL <- map["advertisingLinkURL"]
        advertisingDisable <- map["advertisingDisable"]
        advertisingFlag <- map["advertisingFlag"]
        mobileOrPc <- map["mobileOrPc"]
        substationId <- map["substationId"]
        isPromotion <- map["isPromotion"]
        searchStatu <- map["searchStatu"]
    }
}
