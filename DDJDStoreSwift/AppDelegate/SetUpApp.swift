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
///设置app
extension AppDelegate{
    ///设置app
    internal func setApp(){
        if store_Id == nil{
            self.jumpToLoginVC()
        }else{
            self.jumpToIndexVC()
        }
        setNav()
        setThirdPartyFramework()
        ///初始化
        PHProgressHUD.initProgressHUD()
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
        //开启键盘框架
        IQKeyboardManager.shared.enable = true
    }
}
///页面切换
extension AppDelegate{
    //跳转到首页
    func jumpToIndexVC(){
        tab=TabBarViewController()
        self.window?.rootViewController=tab
    }
    //跳转到登录页面(切换根视图)
    func jumpToLoginVC(){
        let login=LoginController()
        self.window?.rootViewController=login
    }
}

