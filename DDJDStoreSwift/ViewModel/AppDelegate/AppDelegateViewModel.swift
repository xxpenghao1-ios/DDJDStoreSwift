//
//  AppDelegateViewModel.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/7/26.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
///AppDelegate vm
class AppDelegateViewModel:NSObject{

    ///验证用户是否已经被其他手机登录
    var memberDeviceVerificationPS=PublishSubject<Bool>()

    ///下线
    var subSubStationMemberPS=PublishSubject<Bool>()

    ///上线
    var addSubStationMemberPS=PublishSubject<Bool>()

    override init() {
        super.init()

        memberDeviceVerificationPS.subscribe(onNext: { [weak self] (_) in
            self?.memberDeviceVerification()
        }).disposed(by:rx_disposeBag)

        subSubStationMemberPS.subscribe(onNext: { [weak self] (_) in
            self?.subSubStationMember()
        }).disposed(by:rx_disposeBag)

        addSubStationMemberPS.subscribe(onNext: { [weak self] (_) in
            self?.addSubStationMember()
        }).disposed(by:rx_disposeBag)
    }
    ///app下线
    private func subSubStationMember(){

        if substation_Id != nil && store_Id != nil{
            PHRequest.shared.requestJSONObject(target:AppDelegateAPI.subSubStationMember(subStationId:substation_Id!, storeId:store_Id!)).subscribe(onNext: { (_) in

            }).disposed(by:rx_disposeBag)
        }
    }
    ///app上线
    private func addSubStationMember(){

        if substation_Id != nil && store_Id != nil{
            PHRequest.shared.requestJSONObject(target:AppDelegateAPI.addSubStationMember(subStationId:substation_Id!, storeId:store_Id!)).subscribe(onNext: { (_) in

            }).disposed(by:rx_disposeBag)
        }
    }
    ///验证用户是否已经被其他手机登录
    private func memberDeviceVerification(){

        if member_Id != nil{
            PHRequest.shared.requestJSONObject(target:AppDelegateAPI.memberDeviceVerification(memberId:member_Id!)).debug().subscribe(onNext: { (result) in
                switch result{
                case let .success(json:json):
                    //设备令牌
                    let deviceToken=json["deviceToken"].stringValue;
                    //登录时间
                    let loginTime=json["loginTime"].stringValue;
                    //设备名称
                    let deviceName=json["deviceName"].stringValue;
                    if deviceToken != "penghao"{//如果用户在打开app没有选择接收通知 直接在登录界面 给服务器传入了默认值(penghao) 不等于表示 用户开启了消息通知
                        if  deviceToken != USER_DEFAULTS.object(forKey:"deviceToken") as? String{//判断服务器返回的设备标识与当前本机的缓存中的设备标识是否相等  如果不等于表示该账号在另一台设备在登录
                            UIAlertController.showAlertYes(APP.window?.rootViewController, title:"重新登录", message: "您的账号于\(loginTime)在另一台设备\(deviceName)上登录。如非本人操作,则密码可能已泄露,建议您重新设置密码,以确保数据安全。", okButtonTitle:"确定", okHandler: { (_) in
                                ///跳转到登录页面
                                APP.jumpToLoginVC()
                                
                            })
                        }
                    }
                    break
                default:break
                }

            }).disposed(by:rx_disposeBag)
        }
    }
}
