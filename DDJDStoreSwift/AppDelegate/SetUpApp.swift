//
//  SetUpApp.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/4/27.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import UIKit
import IQKeyboardManagerSwift
import SwiftyJSON
import Siren
///设置app
extension AppDelegate{
    
    ///设置app
    internal func setApp(){
        
        if member_Id == nil{
            self.jumpToLoginVC()
        }else{
            self.jumpToIndexVC()
        }
        setNav()
        setThirdPartyFramework()

    }

    ///设置导航栏
    private func setNav(){
        //导航栏背景色
        UINavigationBar.appearance().barTintColor=UIColor.white
        //导航栏文字颜色
        UINavigationBar.appearance().titleTextAttributes=NSDictionary(object:UIColor.black, forKey:NSAttributedStringKey.foregroundColor as NSCopying) as? [NSAttributedStringKey : Any]
        
        UINavigationBar.appearance().tintColor=UIColor.applicationMainColor()
    }
}

///设置第三方框架
extension AppDelegate{

    internal func setThirdPartyFramework(){

        ///把一些第三方框架 放到异步线程中执行 加快页面加载速度
        DispatchQueue.main.async {
            ///版本更新
            let siren=Siren.shared
            ///为用户提供更新app的选项(2个按钮提醒)
            siren.alertType = .option
            ///设置好后，只有在当前版本已经发布了X天之后，才会显示警报。设置0天
            siren.showAlertAfterCurrentVersionHasBeenReleasedForDays=0
            ///设置检测app更新情况
            siren.checkVersion(checkType: .immediately)

            //开启键盘框架
            IQKeyboardManager.shared.enable = true

            ///初始化 提示框架
            PHProgressHUD.initProgressHUD()

            ///图片缓存
            //设置最大缓存时间为3天，默认为1周
            cache.maxCachePeriodInSecond = 60 * 60 * 24 * 3
            //清空失效和过大的缓存
            cache.cleanExpiredDiskCache()

            //监听极光推送自定义消息(只有在前端运行的时候才能收到自定义消息的推送。)
            NotificationCenter.default.addObserver(self, selector:#selector(self.networkDidReceiveMessage), name:NSNotification.Name.jpfNetworkDidReceiveMessage, object:nil)
            //关闭极光推送打印
            JPUSHService.setLogOFF()

            ///腾讯错误统计
//            let config=BuglyConfig()
//            config.debugMode=true
            Bugly.start(withAppId:"d98b089f84")
        }
    }
}

///页面切换
extension AppDelegate{
    //跳转到首页
    func jumpToIndexVC(){
        let tab=TabBarViewController()
        self.window?.rootViewController=tab
    }
    //跳转到登录页面(切换根视图)
    func jumpToLoginVC(){
        let login=LoginController()
        self.window?.rootViewController=UINavigationController(rootViewController:login)
    }
}

///极光推送
extension AppDelegate:JPUSHRegisterDelegate{

    ///处理推送消息  目前不做处理
    private func managePushInfo(json:JSON){
        print(json)

    }
    ///监听自定义消息
    @objc func networkDidReceiveMessage(_ notification:Notification){
        let userInfo=notification.userInfo
        if userInfo != nil{
            let json=JSON(userInfo!)
            let nmoreMessage=json["extras"]["nmoreMessage"].intValue
            if nmoreMessage == 3{//如果为3 表示该账号在其他设备登录
                vm.memberDeviceVerificationPS.onNext(true)
            }
        }
    }
    ///用户点击通知栏进入app执行
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        let userInfo=response.notification.request.content.userInfo

        if (response.notification.request.trigger?.isKind(of:UNPushNotificationTrigger.classForCoder()))!{
            JPUSHService.handleRemoteNotification(userInfo)
            managePushInfo(json:JSON(userInfo))
        }
        completionHandler()
    }
    ///用户在前台接收到推送消息执行
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        let userInfo=notification.request.content.userInfo
        if (notification.request.trigger?.isKind(of:UNPushNotificationTrigger.classForCoder()))!{
            JPUSHService.handleRemoteNotification(userInfo)
            managePushInfo(json:JSON(userInfo))
        }

    }
}
